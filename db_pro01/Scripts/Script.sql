--직원 테이블
SELECT * FROM EMPLOYEES;

SELECT EMPLOYEE_ID
	 , FIRST_NAME
	 , LAST_NAME
  FROM EMPLOYEES;

SELECT EMPLOYEE_ID
	 , FIRST_NAME
	 , LAST_NAME
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID >= 200; --이렇게 비교연산자 사용가능
	
SELECT EMPLOYEE_ID
	 , FIRST_NAME
	 , LAST_NAME
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID >= 200 --이렇게 비교연산자 사용가능
   AND FIRST_NAME = 'Pat'; --AND는 둘다 만족하는 값을!:문자열 리터럴 사용할때는 ' '를 사용!

SELECT EMPLOYEE_ID
	 , FIRST_NAME
	 , LAST_NAME
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID >= 200 --이렇게 비교연산자 사용가능
	OR FIRST_NAME = 'Steven'; --OR는 둘중 하나만이라도 만족하는 값을!

SELECT EMPLOYEE_ID AS "사번" --별칭등록! 유출되지않도록..?
	 , FIRST_NAME AS 이름 --별칭등록은 다양하게! " ", 그냥, AS도 생략가능! 띄워쓰기는 안되지만 " "로 씌워주면 괜찮다
	 , LAST_NAME 성
	 , EMAIL "이메일 주소"
	 FROM EMPLOYEES; 

SELECT EMPLOYEE_ID AS "사번" --별칭은 결과값 출력한 뒤에 컬럼에대한 이름을 바꿔준것이다! SQL문을 실행할때에는 변경되기전의 이름으로 사용해야한다
	 , FIRST_NAME AS "이름"
	 , LAST_NAME AS "성"
  FROM EMPLOYEES --FROM절의 명령먼저 그다음 WHERE절 조건에 부합하는 애들만 그다음 SELECT에 해당하는 데이터출력! 즉 순서가 1.FROM 2.WHERE 3.SELECT이다.
 WHERE EMPLOYEE_ID >= 200;

SELECT FIRST_NAME || ' ' || LAST_NAME AS "이름" --문자열 결합할때 || 사용, 이렇게 컬럼끼리 결합해서 하나로 만들어 줄 수도 있다.
	 , SALARY * 12 AS "연봉"
  FROM EMPLOYEES;

-- 조건절에서 사용하는 연산자
-- AND, OR, NOT, IN, NOT IN, BETWEEN, ...AND, LIKE, IS NULL, IS NOT NULL, 
SELECT *
  FROM EMPLOYEES
 WHERE NOT EMPLOYEE_ID >= 200; --200이상이 아닌 값들만 출력

SELECT *
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID IN(200, 201, 202, 203); --IN 매개변수에 해당하는 값들 출력

SELECT *
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID BETWEEN 200 AND 203; --200~203 사이 출력

SELECT *
  FROM EMPLOYEES
 WHERE FIRST_NAME LIKE 'S%'; --★S로 시작하는 이름 출력
	
SELECT *
  FROM EMPLOYEES
 WHERE FIRST_NAME LIKE '%e'; --E로 끝나는 이름 출력
	
SELECT *
  FROM EMPLOYEES
 WHERE FIRST_NAME LIKE '%ea%'; --ea가 포함된 이름 출력
	
SELECT *
  FROM EMPLOYEES
 WHERE FIRST_NAME LIKE '_____'; --5글자(언더바5개)인 이름 출력
	
SELECT *
  FROM EMPLOYEES
 WHERE FIRST_NAME LIKE 'D____'; --D를 포함한 5글자(언더바5개)인 이름 출력
	
SELECT *
  FROM EMPLOYEES
 WHERE JOB_ID LIKE '%#____' ESCAPE '#' --★이스케이프문자를 통해서 언더바 이후로 3글자인 직업 출력
	
SELECT *
  FROM EMPLOYEES
 WHERE JOB_ID NOT LIKE '%#____' ESCAPE '#' --이스케이프문자를 통해서 언더바 이후로 3글자아닌 직업 출력
	
SELECT *
  FROM EMPLOYEES
 WHERE COMMISSION_PCT IS NULL; --COMMISSION_PCT가 null인것만 출력
	
SELECT *
  FROM EMPLOYEES
 WHERE COMMISSION_PCT IS NOT  NULL; --COMMISSION_PCT가 null이 아닌것 출력
	
SELECT *
  FROM EMPLOYEES
 WHERE COMMISSION_PCT = NULL; --★이렇게해서 못찾는다 null은 IS NULL, IS NOT NULL을 사용해서 찾아야만 한다.
	
SELECT *
  FROM  EMPLOYEES
 WHERE NOT EMPLOYEE_ID >= 200 --200미만 + 100 출력
    OR EMPLOYEE_ID = 100;

SELECT *
  FROM  EMPLOYEES
 WHERE NOT (EMPLOYEE_ID >= 200 --200넘거나 100인경우 제외하고 출력 :소괄호로 조건을 더 다양하게 적용가능
	OR EMPLOYEE_ID = 100);

	
--부서 테이블
SELECT * FROM DEPARTMENTS;

--직급 테이블
SELECT * FROM JOBS;

--국가 테이블
SELECT * FROM COUNTRIES;

--국가별 지역 테이블
SELECT * FROM LOCATIONS;

--대륙 테이블
SELECT * FROM REGIONS;

--기본키: 해당 테이블에서 유일하게 사용하는 값; 중복값이 없다. 유일한 값만 가지게함
--외래키: 참조값