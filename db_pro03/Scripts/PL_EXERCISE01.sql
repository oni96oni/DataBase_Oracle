/*
 * 상품 재고 관리를 위한 테이블
 *     재고입출고 테이블
 *         - 상품에 대한 입고/출고 내역을 저장하는 테이블
 * 
 *     재고관리 테이블
 *         - 상품에 대한 전체 재고 수량을 관리하는 테이블
 * 
 * 요구사항
 *     - 재고 입고가 발생하는 경우 재고관리 테이블에 동일한 이름의 상품이 없는 경우
 *       재고관리에 새로운 상품으로 추가한다.
 *       동일한 이름의 상품이 있는 경우 기존 수량을 증가시킨다.
 *     - 재고 출고가 발생하는 경우 재고관리 테이블에 동일한 이름의 상품이 없는 경우 -> 에러
 *       동일한 이름의 상품이 있는 경우 기존 수량을 감소시킨다. 만약 차감된 수량이 마이너스가
 *       된 경우 롤백(ROLLBACK)을 한다.
 */
CREATE TABLE 재고입출고(
       PID    NUMBER                     CONSTRAINT PK_재고입출고_PID    PRIMARY KEY
     , PNAME  VARCHAR2(100)              CONSTRAINT NN_재고입출고_PNAME  NOT NULL
     , PTYPE  CHAR(1)                    CONSTRAINT CK_재고입출고_PTYPE  CHECK(PTYPE IN ('I', 'O'))
     , PCNT   NUMBER         DEFAULT(1)  CONSTRAINT NN_재고입출고_PCNT   NOT NULL
     , PDATE  DATE                       CONSTRAINT NN_재고입출고_PDATE  NOT NULL
);

CREATE TABLE 재고관리(
       PID     NUMBER         CONSTRAINT PK_재고관리_PID     PRIMARY KEY
     , PNAME   VARCHAR2(100)  CONSTRAINT NN_재고관리_PNAME   NOT NULL
     , PTOTAL  NUMBER         CONSTRAINT NN_재고관리_PTOTAL  NOT NULL
);

CREATE TABLE 재고입고신청(
       PID      NUMBER         CONSTRAINT PK_재고입고신청_PID       PRIMARY KEY
     , PNAME    VARCHAR2(100)  CONSTRAINT NN_재고입고신청_PNAME     NOT NULL
     , PCNT     NUMBER         CONSTRAINT NN_재고입고신청_PCNT      NOT NULL
     , PROCTYPE VARCHAR(9)     CONSTRAINT NN_재고입고신청_PROCTYPE  NOT NULL
     , PDATE    DATE           CONSTRAINT NN_재고입고신청_PDATE     NOT NULL
     , DDATE    DATE
     , DID      NUMBER         CONSTRAINT FK_재고입고신청_DID       REFERENCES 재고입출고(PID)
);

CREATE SEQUENCE SEQ_재고입출고 NOCACHE;

CREATE SEQUENCE SEQ_재고관리 NOCACHE;

CREATE SEQUENCE SEQ_재고입고신청 NOCACHE;


CREATE OR REPLACE PROCEDURE PROC_재고입출등록(
       inout_name  IN   VARCHAR2
     , inout_type  IN   VARCHAR2
     , inout_cnt   IN   NUMBER
     , inout_date  IN   DATE
     , res_count   OUT  NUMBER
)
IS
    var_type VARCHAR2(1) := inout_type;
    var_cnt  NUMBER;
BEGIN
	var_type := UPPER(inout_type);
    IF var_type = 'I' THEN
        INSERT INTO 재고입출고 VALUES(SEQ_재고입출고.NEXTVAL, inout_name, var_type, inout_cnt, inout_date);
        
        SELECT COUNT(*)
          INTO var_cnt
          FROM 재고관리
         WHERE PNAME = inout_name;
        
        IF var_cnt = 0 THEN
            INSERT INTO 재고관리 VALUES(SEQ_재고관리.NEXTVAL, inout_name, inout_cnt);
        ELSE
            UPDATE 재고관리
               SET PTOTAL = PTOTAL + inout_cnt
             WHERE PNAME = inout_name;
        END IF;
    ELSE
        SELECT COUNT(*)
          INTO var_cnt
          FROM 재고관리
         WHERE PNAME = inout_name;
        
        IF var_cnt = 0 THEN
            DBMS_OUTPUT.PUT_LINE('출고 대상 상품이 없습니다.');
        ELSE
            INSERT INTO 재고입출고 VALUES(SEQ_재고입출고.NEXTVAL, inout_name, var_type, inout_cnt, inout_date);
            
            UPDATE 재고관리
               SET  PTOTAL = PTOTAL - inout_cnt
             WHERE PNAME = inout_name;
            
            SELECT PTOTAL
              INTO var_cnt
              FROM 재고관리
             WHERE PNAME = inout_name;
            
            IF var_cnt < 0 THEN
                /*
                 * PROC_재고입고신청 프로시져를 만들어서 부족한 수량을 신청할 수 있게 한다.
                 * 재고입고신청 테이블을 추가로 작성
                 *     컬럼 : PID, PNAME, PCNT, PROCTYPE, PDATE, DDATE, DID
                 * PROCTYPE 은 진행도와 관련된 컬럼으로 다음의 구분값을 가진다.
                 *     OFFER : 신청
                 *     PROCEEDING : 진행중
                 *     DONE : 입고완료
                 * PDATE 는 신청날짜이다.
                 * DDATE 는 입고완료 된 날짜
                 * DID 는 
                 * 
                 * 사용예)
                 *     PROC_재고입고신청('상품A', 5)
                 *     5 라고하는 수량은 부족분에 대한 수량이다.
                 */
                ROLLBACK;
                PROC_재고입고신청(inout_name, ABS(var_cnt));
            END IF;
        END IF;
    END IF;
    res_count := 1;
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE PROC_재고입고신청(
       in_name   IN  VARCHAR2
     , in_count  IN  NUMBER
)
IS
BEGIN
    INSERT INTO 재고입고신청 VALUES(SEQ_재고입고신청.NEXTVAL, in_name, in_count, 'OFFER', SYSDATE, NULL, NULL);
    COMMIT;
END;



CREATE OR REPLACE PROCEDURE PROC_재고입고신청처리(
)
IS
    /*
     * 재고입고신청된 데이터를 처리하는 프로시져로 생성한다.
     *     재고입고신청 테이블의 PID로 어떤 신청항목을 처리할 것인지 외부로 부터 값을 입력받는다.
     *     외부로 부터 입력 받은 PID를 이용하여 재고입출고 테이블에 데이터 등록 처리를 하고
     *     OFFER 상태를 DONE 상태로 변경 후 DDATE 는 현재날짜로 등록 처리 한다.
     *     DID 컬럼은 재고입출고 테이블에 등록 할 때 생성된 PID가 저장되도록 한다.
     */
BEGIN;


SELECT * FROM USER_ERRORS;
SELECT * FROM USER_PROCEDURES;


DECLARE
    res_count  NUMBER;
BEGIN
    PROC_재고입출등록('상품A', 'I', 5, TO_DATE(20220506), res_count);
    PROC_재고입출등록('상품A', 'O', 10, TO_DATE(20220506), res_count);
END;


SELECT * FROM 재고입출고;
SELECT * FROM 재고관리;
SELECT * FROM 재고입고신청;
SELECT * FROM USER_SEQUENCES;

DELETE FROM 재고입출고;
DELETE FROM 재고관리;
DELETE FROM 재고입고신청;
COMMIT;




DROP TABLE 재고입출고;
DROP TABLE 재고관리;
DROP TABLE 재고입고신청;
DROP PROCEDURE PROC_재고입고신청;
DROP PROCEDURE PROC_재고입출등록;
DROP SEQUENCE SEQ_재고입출고;
DROP SEQUENCE SEQ_재고관리;
DROP SEQUENCE SEQ_재고입고신청;



