-- EMPLOYEES 테이블의 직원이름, 이메일, 전화번호, 고용일을 조회 한다.
--     - 직원이름은 성과 이름을 하나의 컬럼으로 만들어야 한다.
--     - 이메일 뒤에는 @employees.co.kr 을 붙여야 한다.
--     - 전화번호의 구분자는 . 대신 - 이 사용되도록 한다.
--     - 고용일은 xxxx년 xx월 xx일 형식으로 출력되게 한다.
SELECT FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
,EMAIL || '@employees.co.kr' AS employeesEmail
--,TO_DATE(PHONE_NUMBER, '999-999-9999') 
--,TO_DATE(HIRE_DATE, 'YYYY"년" MM"월" DD"일"') 
FROM EMPLOYEES;

-- EMPLOYEES 테이블에서 직원이름, 급여, 연봉을 조회 한다.
-- 연봉은 급여에 12개월을 곱하는 것으로 한다.
SELECT FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
, SALARY
, SALARY * 12 AS annual_salary
FROM EMPLOYEES;

-- EMPLOYEES 테이블에서 전화번호가 011 로 시작하는 직원의 성+이름과 사원번호, 전화번호를 조회한다.
SELECT FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
, EMPLOYEE_ID 
, PHONE_NUMBER 
FROM EMPLOYEES
WHERE PHONE_NUMBER LIKE '011_______________';

-- EMPLOYEES 테이블에서 커미션이 존재하는 직원의 이름과 급여, 연봉을 조회한다.
-- 연봉에는 커미션이 계산된 연봉으로 조회한다.

SELECT FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
, SALARY 
, SALARY * 12 AS annual_salary
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT  NULL;

-- EMPLOYEES 테이블에서 2000년도에 고용된 직원을 조회한다.
SELECT  *
FROM EMPLOYEES
WHERE TO_NUMBER(SUBSTR(HIRE_DATE,1,4)) = 2020;

SELECT *
FROM EMPLOYEES;

-- EMPLOYEES 테이블에서 고용일(HIRE_DATE) 를 기준으로 1999년 12월 31일 까지의 근무개월수가 60개월 이상인 직원을 조회한다.
SELECT *
FROM EMPLOYEES
WHERE (TO_NUMBER(HIRE_DATE)-19991231)>=60 ;

-- EMPLOYEES 테이블에서 고용일(HIRE_DATE) 를 기준으로 1999년 12월 31일 까지의 근속년이 7년 이상인 직원을 조회한다.
