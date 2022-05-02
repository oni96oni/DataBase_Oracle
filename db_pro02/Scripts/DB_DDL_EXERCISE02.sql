/*
지출내역서 테이블과 지출내역서구분 테이블에 데이터를 추가/수정/삭제 하는 작업을 진행한다.
	지출내역서구분에는 본인의 한 달치 분량의 생활비 내역을 참고하여 교통비, 식대, 수도세, 전기세 등의 구분명을 추가한다
	지출내역서에는 본인의 한달치 분량의 실제 입출고 내역을 참고하여 가계부를 작성하듯 데이터를 추가한다.
*/

SELECT * FROM 지출내역서;
SELECT * FROM 지출내역구분;

ALTER TABLE 테이블 DROP CONSTRAINT 외래키명;

CREATE SEQUENCE SEQ_지출내역구분;

INSERT INTO 지출내역구분
	   VALUES(1, '용돈');
INSERT INTO 지출내역구분
	   VALUES(2, '급여');
INSERT INTO 지출내역구분
	   VALUES(3, '교통비');
INSERT INTO 지출내역구분
	   VALUES(4, '월세');
INSERT INTO 지출내역구분
	   VALUES(5, '전기세');
INSERT INTO 지출내역구분
	   VALUES(6, '수도세');
INSERT INTO 지출내역구분
	   VALUES(7, '차량유지비');
INSERT INTO 지출내역구분
	   VALUES(8, '유류비');
INSERT INTO 지출내역구분
	   VALUES(9, '식비');

INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220301),500000,0,'',2,1);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220301),0,15000,'',3,4);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220301),0,45000,'',4,6);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220301),0,350000,'',5,5);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220301),0,50000,'',6,3);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220401),500000,0,'',7,1);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220410),0,15000,'',8,4);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220415),0,45000,'',9,6);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220420),0,350000,'',10,5);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220425),0,50000,'',11,3);	   
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220501),500000,0,'',12,1);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220510),0,15000,'',13,4);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220515),0,45000,'',14,6);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220520),0,350000,'',15,5);
INSERT INTO 지출내역서(날짜, 입금액, 출금액, 비고, ACCOUNT_ID, ACCOUNT_TYPE)
	   VALUES (TO_DATE(20220525),0,50000,'',16,3);	
	   
COMMIT;

/*
위 작업을 모두 마친 후에는 다음의 작업을 추가로 진행 한다.
	입금액만을 따로 조회하여 얼마나 입금이 되었는지 통계 조회를 한다.
	출금액만을 따로 조회하여 얼마나 출금이 되었는지 통계 조회를 한다.
	위에서 조회한 데이터를월별지출내역 테이블을 새로만들어 월별로 저장될 수 있게 한다.
	월별지출내역 테이블에는 년, 월, 지출구분, 금액 컬럼을 가지게 만들고 지출구분은, '입', 출'만 저장되도록 한다.
*/

SELECT EXTRACT(YEAR FROM 날짜) AS 년
	 , EXTRACT(MONTH FROM 날짜) AS 월
	 , SUM(입금액) AS 입금액
  FROM 지출내역서
 WHERE 입금액 > 0
 GROUP BY ROLLUP(EXTRACT(YEAR FROM 날짜), EXTRACT(MONTH FROM 날짜)); --ROLL UP을 해주면 연도별 소계, 총계 둘다 나온다.
 
SELECT EXTRACT(YEAR FROM 날짜) AS 년
	 , EXTRACT(MONTH FROM 날짜) AS 월
	 , SUM(출금액) AS 출금액
  FROM 지출내역서
 WHERE 출금액 > 0
 GROUP BY ROLLUP(EXTRACT(YEAR FROM 날짜), EXTRACT(MONTH FROM 날짜));
 
SELECT EXTRACT(YEAR FROM 날짜) AS 년
	 , EXTRACT(MONTH FROM 날짜) AS 월
	 , SUM(입금액) AS 입금액
	 , SUM(출금액) AS 출금액
  FROM 지출내역서
 GROUP BY ROLLUP(EXTRACT(YEAR FROM 날짜), EXTRACT(MONTH FROM 날짜));
 

CREATE TABLE 월별지출내역 --테이블만들기용도.
	AS SELECT EXTRACT(YEAR FROM 날짜) AS 년
	 		, EXTRACT(MONTH FROM 날짜) AS 월
	 		, '입' AS 지출구분 
	 		, 입금액 AS 금액
	 	 FROM 지출내역서
	 	WHERE 1=0;

SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = '월별지출내역'; 
DROP TABLE 월별지출내역;

INSERT ALL INTO 월별지출내역 VALUES(년, 월, 지출구분, 금액)
SELECT EXTRACT(YEAR FROM 날짜) AS 년
	 , EXTRACT(MONTH FROM 날짜) AS 월
	 , CASE WHEN 입금액 > 0 THEN '입'
	 		WHEN 출금액 > 0 THEN '출'
	   END 지출구분
	 , SUM(입금액 + 출금액) AS 금액
  FROM 지출내역서
 GROUP BY EXTRACT(YEAR FROM 날짜), EXTRACT(MONTH FROM 날짜)
	    , CASE WHEN 입금액 > 0 THEN '입'
	 		   WHEN 출금액 > 0 THEN '출'
	      END;
/*
	지출내역서에 작성된 모든 지출을 기존 금액보다 10% 인상 시키고 이를 월별지출내역에도 반영하도록 한다.
 */
	     
UPDATE 지출내역서 
   SET 출금액 = 출금액 + 출금액 * 0.1
 WHERE 출금액 IS NOT NULL;

UPDATE 월별지출내역
   SET 금액 = 금액 * 1.1
 WHERE 지출구분 = '출';
 
SELECT * FROM 월별지출내역;
SELECT * FROM 지출내역서;
SELECT * FROM 지출내역구분;

/*
 	서브쿼리
		쿼리문 안에 쿼리가 하나 더 있는것! ★반드시 괄호로 묶여야한다.
		서브쿼리와 비교할 항목은 반드시 서브쿼리의 SELECT한 항목의 개수와 자료형을 일치시켜야함. 행,열,타입 삼위일체필요
		
		다중행은 IN이 사용 다중열은 컬럼이 묶여야한다 ( WHERE 앞에 첫번째 매개변수조건이 묶여야해 )
		
		서브쿼리가 메인쿼리바꾸고 그 바꿈으로인해서 서브쿼리값이 바뀌면 상호연관쿼리 -> 결과값이 하나바뀌면 스칼라 서브쿼리
*/
