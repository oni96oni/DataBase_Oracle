SELECT ROWNUM
	 , FIRST_NAME
	 , LAST_NAME
	 , SALARY
	 , COMMISSION_PCT 
  FROM EMPLOYEES
 WHERE COMMISSION_PCT IS NOT NULL --WHERE절이 붙으면서 ROWNUM이 바뀜.
   AND ROWNUM <= 15
 ORDER BY SALARY DESC;
 
-- 왜 위와 아래가 다른 결과가 나오는걸까? AND ROWNUM <= 15 조건 때문에! 저기서 ROWNUM으로 다르게 걸러진다 아래와
SELECT * -- TOP-N 분석, 미리 정렬된 쿼리를 만들어 놓고 필요한 상위 몇개만 조회하는 분석 방법.
FROM (SELECT FIRST_NAME
	 	   , LAST_NAME
		   , SALARY
		   , COMMISSION_PCT
  	    FROM EMPLOYEES
 	   WHERE COMMISSION_PCT IS NOT NULL
 	   ORDER BY SALARY DESC)
WHERE ROWNUM <= 15;
 
WITH EMP_COM --서브쿼리구문자체를 WITH구문을 사용해서 별칭을 부여하는방법, 서브쿼리가 자주사용되는경우 재사용을 위해서.
  AS (SELECT FIRST_NAME
	 	   , LAST_NAME
		   , SALARY
		   , COMMISSION_PCT
  	    FROM EMPLOYEES
 	   WHERE COMMISSION_PCT IS NOT NULL
 	   ORDER BY SALARY DESC)
SELECT * FROM EMP_COM;

SELECT FIRST_NAME
	 , LAST_NAME
	 , SALARY
	 , RANK() OVER(ORDER BY SALARY DESC) AS 순위 --급여에 따른 순위부여( 동률이 나오면 다음순위는 누적계산 O)
  FROM EMPLOYEES;
  
SELECT FIRST_NAME
	 , LAST_NAME
	 , SALARY
	 , DENSE_RANK() OVER(ORDER BY SALARY DESC) AS 순위 --급여에 따른 순위부여( 동률이 나와도 다음순위는 누적계산 X)
  FROM EMPLOYEES; 
  
SELECT FIRST_NAME --이렇게하면 조회가 안된다 아래처럼 서브쿼리를 사용하여야 한다. 순위테이블은 READ-ONLY이기 때문에 우리가 사용할 수 없다.
	 , LAST_NAME
	 , SALARY
	 , RANK() OVER(ORDER BY SALARY DESC) AS 순위
  FROM EMPLOYEES
 WHERE 순위 <= 5;

SELECT *
  FROM(SELECT FIRST_NAME
	   , LAST_NAME
	   , SALARY
	   , RANK() OVER(ORDER BY SALARY DESC) AS 순위
  FROM EMPLOYEES)
 WHERE 순위 <= 5;
 
/*
	JOIN문
	
	오라클, ANSI 표준 구문이 있다. 가급적으로 표준구문인 ANSI를 사용하는것이 바람직.
	
*/
SELECT * 
  FROM EMPLOYEES, DEPARTMENTS
 WHERE EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID; --DEPARTMENT_ID가 헷갈릴수있기 때문에 앞에 자바에서 THIS처럼 써준다.
 
SELECT * --별칭을 사용해서 짧게사용 (이 방법은 오라클 전용 구문)
  FROM EMPLOYEES E, DEPARTMENTS D 
 WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID; 
 
SELECT * --JOIN하는 방법, ON을 사용하면 교집합부분 중복되어서 출력
  FROM EMPLOYEES E
  JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;
    
SELECT * --JOIN하는 방법, USING을 사용하면 교집합부분 제거한뒤 출력
  FROM EMPLOYEES E
  JOIN DEPARTMENTS D
 USING (DEPARTMENT_ID)
 
--OUTER JOIN의 종류 LEFT, RIGHT, FULL 각각 왼쪽테이블기준, 오른쪽테이블기준, 양쪽모두를 기준으로
 
SELECT *
  FROM EMPLOYEES E
  LEFT JOIN DEPARTMENTS D 
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
 WHERE E.EMPLOYEE_ID = 178;
 
SELECT *
  FROM EMPLOYEES E
 RIGHT JOIN DEPARTMENTS D 
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

SELECT *
  FROM EMPLOYEES E
  FULL JOIN DEPARTMENTS D 
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

SELECT * --LEFT (아래두개는 오라클전용구문이라 잘 사용X)
  FROM EMPLOYEES E, DEPARTMENTS D
 WHERE E.DEPARTMENT_ID(+) = D.DEPARTMENT_ID;  

SELECT * --RIGHT
  FROM EMPLOYEES E, DEPARTMENTS D
 WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+);  

--카데시안 곱(총 개별데이터의 개수)
SELECT COUNT(*) -- 데이터의 개수보기.
  FROM EMPLOYEES
 CROSS JOIN DEPARTMENTS;

SELECT X * Y AS TOTAL --이걸 곱하면 위와 같이 나옴.
  FROM (SELECT (SELECT COUNT(*) FROM EMPLOYEES) AS X --행데이터를 보는방법
	 , (SELECT COUNT(*) FROM DEPARTMENTS) AS Y
        FROM DUAL);
        
SELECT *
  FROM EMPLOYEES E 
  JOIN JOBS J 
    ON (E.SALARY BETWEEN J.MIN_SALARY AND J.MAX_SALARY); -- NON_EQUAL JOIN 값이 같지않아도 일정 범위의 해당이 되면 JOIN 시켜라
    
SELECT * --SELF JOIN - 동일한 하나의 테이블로 JOIN하는 형식
  FROM EMPLOYEES E1
  JOIN EMPLOYEES E2
    ON E1.EMPLOYEE_ID = E2.EMPLOYEE_ID;
    
--다중 조인
   