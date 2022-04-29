/*
 * 지출내역서(가계부)를 위한 테이블을 만들어 본다.
 *     - 날짜, 입금액, 출금액, 비고 를 저장할 수 있는 컬럼 필요하다.
 *     - 비고의 경우 한글 150자 까지 저장 가능해야 한다.
 */
CREATE TABLE 지출내역서 (
	   날짜 DATE
	 , 입금액 NUMBER
	 , 출금액 NUMBER
	 , 비고 VARCHAR2(450)
);
/*
 * 위에서 만든 지출내역서에 다음의 컬럼 정보를 추가 및 수정 한다.
 *     - 행 데이터를 식별하기 위한 식별자용 컬럼을 추가 이 컬럼 이름은 ACCOUNT_ID 로 한다.
 *     - 비고의 데이터 저장 크기를 기존보다 2배 늘린다.
 *     - 지출내역 항목을 구분하기 위한 ACCOUNT_TYPE 컬럼을 추가하고
 *       해당 컬럼은 FK 로 만든다.
 *     - ACCOUNT_TYPE 컬럼이 참조하는 테이블은 "지출내역구분" 이라는 테이블로 만들어 둔다.
 *     - 지출내역구분 테이블에는 식별자용 컬럼, 구분명 컬럼이 있어야 한다.
 */
ALTER TABLE 지출내역서 ADD ACCOUNT_ID NUMBER CONSTRAINT PK_지출내역서_ACCOUINT_ID PRIMARY KEY;
ALTER TABLE 지출내역서 MODIFY 비고 VARCHAR2(900);

CREATE TABLE 지출내역구분 (
	   구분ID NUMBER CONSTRAINT PK_지출내역구분_구분ID PRIMARY KEY
	 , 구분명 VARCHAR2(100)	 
);

ALTER TABLE 지출내역서 ADD ACCOUNT_TYPE NUMBER CONSTRAINT FK_지출내역서_ACCOUNT_TYPE REFERENCES 지출내역구분(구분ID);

SELECT * FROM USER_ALL_TABLES WHERE TABLE_NAME = '지출내역서';
SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = '지출내역서';
SELECT * FROM USER_COL_COMMENTS WHERE TABLE_NAME = '지출내역서';
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = '지출내역서';

SELECT * FROM USER_ALL_TABLES WHERE TABLE_NAME = '지출내역구분';
SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = '지출내역구분';
SELECT * FROM USER_COL_COMMENTS WHERE TABLE_NAME = '지출내역구분';
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = '지출내역구분';

L지출내역서_T
   식별   날짜         입금액             출금액           비고                 구분
    1    2022-04-28  1000             0           XXX 은행에 저금            2
    
    
지출내역구분_T
    식별      구분명
      1       은행적금
      2       은행예금