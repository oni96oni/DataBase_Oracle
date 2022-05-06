-- EMPLOYEES 테이블의 직원이름, 이메일, 전화번호, 고용일을 조회 한다.
--     - 직원이름은 성과 이름을 하나의 컬럼으로 만들어야 한다.
--     - 이메일 뒤에는 @employees.co.kr 을 붙여야 한다.
--     - 전화번호의 구분자는 . 대신 - 이 사용되도록 한다.
--     - 고용일은 xxxx년 xx월 xx일 형식으로 출력되게 한다.
SELECT FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
,EMAIL || '@employees.co.kr' AS employeesEmail --CONCAT(EMAIL, '@employees.co.kr') AS EMAIL
,REPLACE(PHONE_NUMBER,'.','-') AS RE_PHONE_NUMBER
,TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"') AS HIRE_DATE
FROM EMPLOYEES;

-- EMPLOYEES 테이블에서 직원이름, 급여, 연봉을 조회 한다.
-- 연봉은 급여에 12개월을 곱하는 것으로 한다.
SELECT FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
, TO_CHAR(SALARY,'999,999,999') AS 급여 --구분자 넣는법 혹은 설정에서 자동으로 나오게끔 설정가능
, SALARY * 12 AS 연봉
FROM EMPLOYEES;

-- EMPLOYEES 테이블에서 전화번호가 011 로 시작하는 직원의 성+이름과 사원번호, 전화번호를 조회한다.
SELECT FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
, EMPLOYEE_ID 
, PHONE_NUMBER 
FROM EMPLOYEES
WHERE PHONE_NUMBER LIKE '011%';

-- EMPLOYEES 테이블에서 커미션이 존재하는 직원의 이름과 급여, 연봉을 조회한다.
-- 연봉에는 커미션이 계산된 연봉으로 조회한다.
SELECT FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
, TO_CHAR(SALARY * 12, '999,999,999') AS 연봉
, SALARY * (1+COMMISSION_PCT) * 12 AS 커미션포함연봉
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL;

-- ★★EMPLOYEES 테이블에서 2000년도에 고용된 직원을 조회한다.
SELECT  *
FROM EMPLOYEES
--WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000;
WHERE HIRE_DATE BETWEEN TO_DATE(20000101) AND TO_DATE(20001231);  

-- EMPLOYEES 테이블에서 고용일(HIRE_DATE) 를 기준으로 1999년 12월 31일 까지의 근무개월수가 60개월 이상인 직원을 조회한다.
SELECT *
FROM EMPLOYEES
WHERE MONTHS_BETWEEN(TO_DATE(19991231),HIRE_DATE) >= 60; 

-- EMPLOYEES 테이블에서 고용일(HIRE_DATE) 를 기준으로 1999년 12월 31일 까지의 근속년이 7년 이상인 직원을 조회한다.
SELECT *
FROM EMPLOYEES
WHERE MONTHS_BETWEEN(TO_DATE(19991231), HIRE_DATE) >= 72; 

-- WHERE 조건에 그룹함수에대한 조건이 필요하다면 ! 바로 HAVING!
SELECT DEPARTMENT_ID
	 , SUM(SALARY) 합
	 , FLOOR(AVG(SALARY)) 평균
	 , COUNT(*) 인원수
  FROM EMPLOYEES
HAVING AVG(SALARY) > 3800
 GROUP BY DEPARTMENT_ID
 ORDER BY DEPARTMENT_ID ASC;