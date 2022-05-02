SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;
SELECT * FROM LOCATIONS;
SELECT * FROM COUNTRIES;
SELECT * FROM REGIONS;

/*
	EMPLOYEES 테이블을 조회할 때 JOB_ID, DEPARTMENT_ID가 아닌 NAME으로 조회될 수 있도록
	JOIN을 활용한다. (서브쿼리도 사용 가능하기 때문에 서브쿼리로도 만들어 본다)
*/

SELECT E.EMPLOYEE_ID
	 , E.FIRST_NAME 
	 , E.LAST_NAME 
	 , E.EMAIL 
	 , E.PHONE_NUMBER 
	 , E.HIRE_DATE 
	 , J.JOB_TITLE 
	 , E.SALARY 
	 , E.COMMISSION_PCT 
	 , E.MANAGER_ID 
	 , D.DEPARTMENT_ID 
FROM EMPLOYEES E
  JOIN JOBS J 
    ON E.JOB_ID = J.JOB_ID
  JOIN DEPARTMENTS D 
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

SELECT EMPLOYEE_ID
	 , FIRST_NAME
	 , LAST_NAME
	 , EMAIL
	 , PHONE_NUMBER
	 , HIRE_DATE
	 , (SELECT JOB_TITLE FROM JOBS J WHERE E.JOB_ID = J.JOB_ID) AS JOB
	 , SALARY
	 , COMMISSION_PCT
	 , MANAGER_ID
	 , (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE E.DEPARTMENT_ID  = D.DEPARTMENT_ID) AS DEPARTMENT_NAME
  FROM EMPLOYEES E;
/*
	DEPARTMENS 테이블과 LOCATIONS 테이블을 사용하여 각 부서가 어느 지역에 위치하고 있는지 JOIN을 활용하여 조회한다.
	(서브쿼리로도 사용가능하기 때문에 서브쿼리로도 만들어 본다.
*/

SELECT D.DEPARTMENT_ID
	 , D.DEPARTMENT_NAME 
	 , D.MANAGER_ID 
	 , L.LOCATION_ID 
	 , L.STREET_ADDRESS 
	 , L.POSTAL_CODE 
	 , L.CITY 
	 , L.STATE_PROVINCE 
	 , L.COUNTRY_ID 
  FROM DEPARTMENTS D 
  JOIN LOCATIONS L
	ON D.LOCATION_ID = L.LOCATION_ID;

SELECT D.DEPARTMENT_ID
	 , D.DEPARTMENT_NAME 
	 , D.MANAGER_ID 
	 , D.LOCATION_ID 
	 , (SELECT STREET_ADDRESS FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) AS STREET_ADDRESS  
	 , (SELECT POSTAL_CODE FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID ) AS POSTAL_CODE 
	 , (SELECT CITY FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) AS CITY 
	 , (SELECT STATE_PROVINCE FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) AS STATE_PROVINCE 
	 , (SELECT COUNTRY_ID FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) AS COUNTRY_ID 
  FROM DEPARTMENTS D;

/*
	LOCATIONS, COUNTRIES, REGION 테이블을 사용하여 각 지역이 어느 나라,대륙에 위치하고 있는지
	JOIN을 활용하여 조회한다.
*/  

SELECT * FROM LOCATIONS;
SELECT * FROM COUNTRIES;
SELECT * FROM REGIONS;

SELECT R.REGION_NAME 
	 , C.COUNTRY_NAME 
	 , L.CITY || ' ' || NVL(L.STATE_PROVINCE, '') || ' ' || L.STREET_ADDRESS AS ADDRESS
--	 , L.CITY || ' ' || DECODE(L.STATE_PROVINCE,NULL, '', CONCAT(L.STATE_PROVINCE, ' ')) || L.STREET_ADDRESS AS ADDRESS
	 , L.POSTAL_CODE
  FROM LOCATIONS L
  JOIN COUNTRIES C 
    ON L.COUNTRY_ID = C.COUNTRY_ID
  JOIN REGIONS R 
    ON C.REGION_ID = R.REGION_ID
 ORDER BY 1, 2;

/*
	대륙별 직원수를 파악하기 위한 조회 쿼리를 만든다.
*/
--원본
SELECT *
  FROM EMPLOYEES E
  JOIN DEPARTMENTS D 
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
  JOIN LOCATIONS L  
    ON D.LOCATION_ID = L.LOCATION_ID
  JOIN COUNTRIES C
    ON L.COUNTRY_ID = C.COUNTRY_ID 
  JOIN REGIONS R 
    ON C.REGION_ID = R.REGION_ID; 
   
SELECT R.REGION_NAME AS 대륙구분
	 , COUNT(*) AS 직원수
  FROM EMPLOYEES E
  JOIN DEPARTMENTS D 
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
  JOIN LOCATIONS L  
    ON D.LOCATION_ID = L.LOCATION_ID
  JOIN COUNTRIES C
    ON L.COUNTRY_ID = C.COUNTRY_ID 
  JOIN REGIONS R 
    ON C.REGION_ID = R.REGION_ID
 GROUP BY R.REGION_NAME ;

/*
	대륙별,나라별 직원수를 파악하기 위한 집계 쿼리를 만든다.
*/

SELECT DECODE(GROUPING(R.REGION_NAME), 1, '총계', R.REGION_NAME) AS 대륙구분
	 , DECODE(GROUPING(C.COUNTRY_NAME), 1, DECODE(GROUPING(R.REGION_NAME),1, ' ', '소계'), C.COUNTRY_NAME) AS 나라구분
	 , COUNT(*) AS 직원수
  FROM EMPLOYEES E
  JOIN DEPARTMENTS D 
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
  JOIN LOCATIONS L  
    ON D.LOCATION_ID = L.LOCATION_ID
  JOIN COUNTRIES C
    ON L.COUNTRY_ID = C.COUNTRY_ID 
  JOIN REGIONS R 
    ON C.REGION_ID = R.REGION_ID
 GROUP BY ROLLUP (R.REGION_NAME, C.COUNTRY_NAME);
    
/*
	부서별 최고참, 막내 사원 구하기
*/

SELECT D.DEPARTMENT_NAME
	 , MIN(HIRE_DATE)
	 , MAX(HIRE_DATE)
  FROM EMPLOYEES E
  JOIN DEPARTMENTS D 
  	ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
 GROUP BY D.DEPARTMENT_NAME;

/*
	국가별 최고액 급여자, 최저 급여자 구하기(커미션이 있는 경우 커미션 포함)
*/
