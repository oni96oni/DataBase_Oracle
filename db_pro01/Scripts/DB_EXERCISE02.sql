/*
모든 컬럼명은 한글로 별칭을 부여하여 조회한다.
FIRTST_NAME과 LAST_NAME을 하나의 컬럼으로 만들어서 조회한다
PHONE_NUMBER에서 사용한 구분자 . 은 - 으로 변경하여 조회하도록 한다.
EMAIL 주소는 @example.com을 추가로 덧붙여서 조회하도록 한다.(소문자로만 나오게 한다)
HIRE_DATE는 YYYY년 MM월DD일 형식으로 조회되도록 하며, 추가로 입사일부터 현재일까지의 근년일수가 계산되어 조회되도록 한다.
SALARY는 원화 단위로 변환시켜 조회하며, COMMISISION_PCT가 있는 경우 이를 계산한 SALARY금액이 나오게한다
추가로 100원 단위는 절사한다.
입사일을 기준으로 오름차순 정렬하여 조회하도록 한다.
*/
SELECT *
FROM EMPLOYEES;

SELECT EMPLOYEE_ID 직원번호
	 , FIRST_NAME || LAST_NAME AS 이름
	 , CONCAT(EMAIL , '@example.com') AS 이메일
--	 , TO_CHAR(HIRE_DATE, 'YYYY"년"MM"월"DD"일"') || ' ' || EXTRACT(YEAR FROM HIRE_DATE)  AS "입사날짜 및 근속년수"
	 , 2022 - EXTRACT(YEAR FROM HIRE_DATE) AS 근속년수
	 , TRUNC(SALARY,2) AS 급여
	 , CASE WHEN IS NOT NULL THEN SALARY * (1 + COMMISSION_PCT) * 12
	   ELSE SALARY * 12
	   END AS 급여
  FROM EMPLOYEES
 ORDER BY HIRE_DATE ASC;
/*
전화번호 회선을 집계하기 위한 조회 쿼리를 만드시오
전화번호 회선은 515, 590, 650, 011, 603 별로 구분하여 얼마나 사용되고 있는지 조회하도록 한다.
번호별 회선 수에 추가로 전체 회선 수가 조회될 수 있도록 한다 
*/
SELECT SUBSTR(PHONE_NUMBER,1,3) AS 전화번호회선
 	 , COUNT(*) || '/' || '전체' AS 회선사용수
  FROM EMPLOYEES
 GROUP BY SUBSTR(PHONE_NUMBER,1,3);

/*
MANAGER_ID 는 해당 EMPLOYEE_ID를 관리하는 관리자 정보가 연결되어 있는 정보이다.
한명의 관리자가 얼마나 많은 직원을 관리하고 있는지를 알 수 있도록 조회 쿼리를 작성한다
MANAGER_ID가 NULL 인 경우는 제외하여 조회하도록 한다.
*/
SELECT MANAGER_ID AS 담당 관리자 번호
	 , EMPLOYEE_ID AS 직원 번호
  FROM EMPLOYEES
 WHERE MANAGER_ID IS NOT NULL
 GROUP BY MANAGER_ID;