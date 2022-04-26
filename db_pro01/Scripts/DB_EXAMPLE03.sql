SELECT NVL(NULL, 'Default') --NULL이 아니라 Default가 출력되도록! 즉 첫번째 매개변수대신 두번째 매개변수가 나오게함
  FROM DUAL;
  
SELECT NVL(COMMISSION_PCT, 0)
  FROM EMPLOYEES;
  
--SELECT DECODE(식,값1,반환값1,값2,반환값2,값3,반환값3, ...., 기본값) --SWITCH문과 비슷한 느낌
-- 주어진 식에서 값1에 해당하는것을 반환값1으로.. 마지막은 나머지들은 기본값으로

SELECT DECODE(DEPARTMENT_ID, 90, 'A부서', 60, 'B부서', 100, 'C부서', '그 외')
  FROM EMPLOYEES;
 
SELECT DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2000, '신규사원', '기존사원')
  FROM EMPLOYEES;
 
SELECT SALARY 
,      CASE WHEN SALARY >= 2000 AND SALARY < 5000 THEN '하위소득' --IF문과 비슷한느낌, 여기서는 THEN 뒤에 ' ' 필수적으로 붙여주어야 한다.
		    WHEN SALARY >= 5000 AND SALARY < 10000 THEN '중위소득'
		    WHEN SALARY >= 10000 THEN '고소득'
		    ELSE '미분류'
	   END AS 급여분류
  FROM EMPLOYEES;

SELECT SUM(SALARY) AS 총합
	 , AVG(SALARY) AS 평균
	 , MAX(SALARY) AS 최대급여액
	 , MIN(SALARY) AS 최소급여액
	 , COUNT(SALARY) AS 행수
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 100;

SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 100;

SELECT MAX(FIRST_NAME) --문자열에서 사전순으로 봤을때 가장 뒤에있는것
	 , MIN(LAST_NAME) --반대로 가장 앞에있는것
  FROM EMPLOYEES;
  
SELECT COUNT(*) --행의 수를 센다! 즉 어떤 컬럼을 넣어도 상관이 없다!
  FROM EMPLOYEES;
  
