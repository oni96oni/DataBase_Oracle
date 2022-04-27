--ORDER BY 컬럼명 | 별칭 | 컬럼 순번 정렬방식 [NULLS FIRST | LAST];
--                                      NULL을 처음에표기? 마지막에표기?

SELECT EMPLOYEE_ID AS 사번
	 , FIRST_NAME AS 이름
	 , LAST_NAME AS 성
	 , DEPARTMENT_ID AS 부서
  FROM EMPLOYEES
 ORDER BY DEPARTMENT_ID ASC, 이름 ASC;
 
--ASC 오름차순, DESC 내림차순
--NULLS LAST는 NULL은 마지막에 써준다 NULLS FIRST도있고 아무것도 안쓰면 NULL이 마지막에(NULLS LAST가 디폴트값인듯 하다)
--별칭으로 바꾼뒤에 별칭을 써도, 원래이름을 써도 둘다 가능!

SELECT DEPARTMENT_ID
	 , JOB_ID
	 , COUNT(*)
	 , SUM(SALARY)
	 , AVG(SALARY)
	 , MIN(SALARY)
	 , MAX(SALARY)
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IS NOT NULL
 GROUP BY DEPARTMENT_ID, JOB_ID
 ORDER BY DEPARTMENT_ID;

--★★★ FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY 순서로 진행된다. 즉 이 순서대로 분석하고, 작성하자!

SELECT COUNT(*)
	 , DECODE(COMMISSION_PCT, NULL, 'NO', 'YES')
  FROM EMPLOYEES
 GROUP BY DECODE(COMMISSION_PCT, NULL, 'NO', 'YES');
 

--★★1980,1990,2000년대 별로 그룹을 묶어서 평균급여와 총인원수를 구한다.
SELECT TRUNC(EXTRACT(YEAR FROM HIRE_DATE), -1) AS 년도
 	 , FLOOR(AVG(SALARY)) AS 평균급여
 	 , COUNT(*) AS 인원
  FROM EMPLOYEES
 GROUP BY TRUNC(EXTRACT(YEAR FROM HIRE_DATE), -1);

--커미션을 받는 직원 중 가장 높은 급여액과 가장 낮은 급여액을 구한다.
SELECT MAX(SALARY)
 	 , MIN(SALARY)
  FROM EMPLOYEES
 WHERE COMMISSION_PCT IS NOT NULL;

--DEPARTMENT 테이블에서 MANAGER_ID가 NULL인 부서의 수와 아닌 부서의 수를 구한다.
SELECT COUNT(*)
	 , DECODE(MANAGER_ID, NULL, 'NO', 'YES') AS MANAGER_ID유무
  FROM DEPARTMENTS
 GROUP BY DECODE(MANAGER_ID, NULL, 'NO', 'YES');

--EMPLOYEES 테이블에서 급여 통계를 위해 급여 구역별 인원 수를 구한다. 급여구역은 2000부터 1000단위로 분류
--EX) 2000~3000미만, 3000~4000미만, ...
SELECT TRUNC(SALARY, -3) AS 월급여
     , COUNT(*) AS 인원
  FROM EMPLOYEES
 GROUP BY TRUNC(SALARY, -3)
 ORDER BY 1;

/*
WHERE  HAVING
조건절  그룹에대한 조건
*/
SELECT TRUNC(SALARY, -3) AS 월급여
     , COUNT(*) AS 인원
  FROM EMPLOYEES
 GROUP BY TRUNC(SALARY, -3)
HAVING COUNT(*) > 10 --그룹에대한 조건에서 추가조건을 걸때 사용한다.
 ORDER BY 1;
 
/*★★★
부서별 전화번호 사용 실태를 확인하기 위한 조회 쿼리를 작성한다.
전화번호 앞자리 3자리에 따라 다음의 요금이 측정되어 있다.
515:월 500원
590:월 450원
650:월 400원
011:월 300원
603:월 600원
부서별 월별 통신비를 산출
 */
SELECT DEPARTMENT_ID AS 부서
	 , SUBSTR(PHONE_NUMBER,1,3) AS 회선번호
	 , COUNT(*) AS 회선수 
	 , DECODE(SUBSTR(PHONE_NUMBER,1,3),'515', 500*COUNT(*)
	 								  ,'590', 450*COUNT(*)
	 								  ,'650', 400*COUNT(*)
	 								  ,'011', 300*COUNT(*)
	 								  ,'603', 600*COUNT(*)) AS 총사용요금
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID
 	 , SUBSTR(PHONE_NUMBER,1,3)
 ORDER BY DEPARTMENT_ID;
 
ROLLUP, CUBE 함수 설명
	그룹별 산출한 결과에 대해서 추가 집계를 수행하는 함수.
	
SELECT DEPARTMENT_ID
	 , JOB_ID
	 , COUNT(*)
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID,JOB_ID 
 ORDER BY 1;

SELECT DEPARTMENT_ID
	 , JOB_ID 
	 , COUNT(*)
  FROM EMPLOYEES
 GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID);
 ORDER BY 1;
/*위2개의 함수의 차이는 GROUP BY 마다 NULL로 해당 컬럼의 개수를 체크 + 마지막줄에 NULL 카운트된것의 총합(그룹 별 산출한 결과 값의 집계를 계산)이 나온다.

아래처럼 집계를 한다. CUBE는 사용가능한 모든 집계를 한뒤 출력
ROLLUP  CUBE
A B C   A B C
A B     A B
A       A   C
ALL       B C
        A
          B
            C
        ALL
*/
--★★★
SELECT DEPARTMENT_ID
	 , JOB_ID 
	 , COUNT(*)
	 , CASE WHEN GROUPING(DEPARTMENT_ID) = 0 AND GROUPING(JOB_ID) = 0 THEN '부서/직급별 합계' -- 둘다 NULL이 아님
	        WHEN GROUPING(DEPARTMENT_ID) = 0 AND GROUPING(JOB_ID) = 1 THEN '부서별 집계' -- JOB_ID 가 NULL
	        WHEN GROUPING(DEPARTMENT_ID) = 1 AND GROUPING(JOB_ID) = 0 THEN '직급별 합계' -- DEPARTMENT_ID 가 NULL
	        WHEN GROUPING(DEPARTMENT_ID) = 1 AND GROUPING(JOB_ID) = 1 THEN '총 집계' -- 둘다 NULL
	   END AS 집계구분
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IS NOT NULL
 GROUP BY CUBE(DEPARTMENT_ID, JOB_ID);
 ORDER BY 1;
 
--무엇을 나타내고자하는 식인가요? (아래 두개와의 차이점은?)
--
SELECT DEPARTMENT_ID, JOB_ID, SUM(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY 1;

--무엇을 나타내고자하는 식인가요? (위 아래 와의 차이점은?)
--부서아이디별, 잡아이디별 
SELECT DEPARTMENT_ID 
	 , JOB_ID 
	 , SUM(SALARY)
  FROM EMPLOYEES
 GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
 ORDER BY 1;

--무엇을 나타내고자하는 식인가요? (위 두개와의 차이점은?)
-- 위의 그리드에서 아이디별로 나뉜 잡아이디의 급여 합계를 보여주는 행 추가, 부서별아이디와 상관없이 잡아이디로 구분한 급여합계까지 같이 보여줌
SELECT DEPARTMENT_ID
	 , JOB_ID
	 , SUM(SALARY)
  FROM EMPLOYEES
 GROUP BY CUBE(DEPARTMENT_ID, JOB_ID)
 ORDER BY 1;

--무엇을 나타내고자하는 식인가요?
--
SELECT DEPARTMENT_ID, JOB_ID, SUM(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
UNION
SELECT DEPARTMENT_ID, JOB_ID, SUM(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY 1;

--무엇을 나타내고자하는 식인가요?
--
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY),
CASE WHEN GROUPING(DEPT_CODE) = 0 AND
GROUPING(JOB_CODE) = 1

THEN '부서별 합계'
WHEN GROUPING(DEPT_CODE) = 1 AND
GROUPING(JOB_CODE) = 0

THEN '직급별 합계'
WHEN GROUPING(DEPT_CODE) = 1 AND
GROUPING(JOB_CODE) = 1

THEN '총 합계'
ELSE '그룹별 합계'
END AS 구분
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- UNION ALL 여러 쿼리 결과를 합치는 연산자로 중복된 영역 모두 포함하여 합침
SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 100
UNION ALL
SELECT *
  FROM EMPLOYEES
 WHERE MANAGER_ID = 101;

--UNION 여러 개의 쿼리 결과를 합치는 연산자로 중복된 영역은 제외하여 합침
SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 100
UNION 
SELECT *
  FROM EMPLOYEES
 WHERE MANAGER_ID = 101;
 
--INTERSECT 여러 개의 SELECT 결과에서 공통된 부분만 결과로 추출(교집합)
SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 100
INTERSECT 
SELECT *
  FROM EMPLOYEES
 WHERE MANAGER_ID = 101;
 
--MINUS 선행 SELECT 결과에서 다음 SELECT 결과와 겹치는 부분을 제외한 나머지 부분 추출(차집합)
SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 100
MINUS
SELECT *
  FROM EMPLOYEES
 WHERE MANAGER_ID = 101;
 
SELECT DEPARTMENT_ID
	 , NULL
	 , COUNT(*)
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IS NOT NULL
 GROUP BY DEPARTMENT_ID
UNION ALL
SELECT NULL AS DEPARTMENT_ID
	 , JOB_ID 
	 , COUNT(*)
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IS NOT NULL
 GROUP BY JOB_ID;
 
--위에 UNION ALL 한것과 아래가 동일하다. GROUPING SETS 그룹 별로 처리된 여러 개의 SELECT문을 하나로 합친 결과를 원할 때 사용 (집합 연산자 사용과 동일)

SELECT DEPARTMENT_ID
	 , JOB_ID
	 , COUNT(*)
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IS NOT NULL
 GROUP BY GROUPING SETS(DEPARTMENT_ID, JOB_ID)
 ORDER BY 1;