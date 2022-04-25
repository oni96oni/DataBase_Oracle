--오라클에서 제공하는 함수
--그룹 함수는 여러개의 행에대한 결과가 그룹으로 묶여서 1개의 결과로 반환 (GROUP BY절 사용)
SELECT  FIRST_NAME, LENGTH(FIRST_NAME) --이런개 단일항 함수
FROM EMPLOYEES;

SELECT LENGTH('Hello') AS Col1
,	LENGTH('안녕') AS Col2
,   LENGTHB('Hello') AS Col1 --LENGTHB()는 바이트크기 
,	LENGTHB('안녕') AS Col2 
FROM DUAL; --DUMMY데이터가 저장될수있는 테이블 (테스트용도의 임시테이블이 DUAL이다)

SELECT INSTR('sample@example.com', '@') AS Col1 --INSTR() 두번째 매개변수의 index가 어디에있는가 알려주는 함수 
, INSTR('sample@example.com', '@', -1) AS Col2 -- 세번째 매개변수에 -1을 넣어주면 뒤에서 부터 찾음 (결과값은 맨 앞에 기준 위치한 숫자로 알려줌)
, INSTR('sample@example.com', 'e') AS Col3
, INSTR('sample@example.com', 'e', -1) AS Col4
, INSTR('sample@example.com', 'e', 1, 2) AS Col5
, INSTR('sample@example.com', 'e', -1, 2) AS Col6
FROM DUAL;

SELECT LTRIM('   sample@example.com   ', ' ') AS Col1 --첫번째 매개변수에있는 문자열에서 두번째 문자열에 해당하는 문자들을 제거한뒤에 출력함
,RTRIM('   sample@example.com   ', ' ') AS Col2 
,TRIM('   sample@example.com   ') AS Col3 --두번째 매개변수 없으면 양쪽의 공백을 제거한다.
,TRIM(LEADING '-' FROM '-----sample@example.com-----') AS Col4 
,TRIM(TRAILING '-' FROM '-----sample@example.com-----') AS Col5 
,TRIM(BOTH '-' FROM '-----sample@example.com-----') AS Col6 
FROM DUAL;

SELECT '!' || LPAD('A', 4) AS Col1 --여백을 줄때 사용한다
,'!' || LPAD('AB', 4) AS Col2
,'!' || LPAD('ABC', 4) AS Col3
,RPAD('A', 4) || '!' AS Col4
,RPAD('AB', 4) || '!' AS Col5
,RPAD('ABC', 4) || '!' AS Col6
,RPAD('ABC', 4, '0') || '!' AS Col7
,RPAD('ABCDE', 4) || '!' AS Col8 -- 두번째 매개변수보다 초과되는 부분의 문자열은 삭제된다음에 출력
FROM DUAL;

SELECT SUBSTR('sample@example.com', 1, 6) AS Col1 --첫번째 매개변수의 인덱스부터 두번째 매개변수의 숫자만큼 짜른뒤에 출력한다.
,SUBSTR('sample@example.com', 8, 7) AS Col2 
,SUBSTR('sample@example.com', -18, 6) AS Col3 -- 첫번째 매개변수 -온다면 뒤에서부터 숫자를 샌다음에 두번째 매개변수의 숫자만큼 짜른뒤에 출력
,SUBSTR('sample@example.com', -11, 7) AS Col4 
,SUBSTR('sample@example.com', -11) AS Col5 --두번째 매개변수 입력안하면 첫번째 매개변수 위치에서부터 끝까지 출력
,SUBSTR('123456', 1, 4) AS Col6 --두번째 매개변수 입력안하면 첫번째 매개변수 위치에서부터 끝까지 출력
FROM DUAL;

SELECT LOWER('sample@example.com') AS Col1 --소문자
, UPPER('sample@example.com') AS Col2 --대문자
, INITCAP('sample@example.com') AS Col3 --구분되는 구간마다 대문자로만
FROM DUAL;

SELECT CONCAT('sample', 'sample@example.com') AS Col1 --문자열 더하기
FROM DUAL;
--              원본                  이 문자열을        이 문자열로 변경
SELECT REPLACE('sample@example.com', 'example.com', 'example.co.kr') AS Col1
FROM DUAL;

SELECT ABS(10.9) AS Col1
, ABS(-10.9) AS Col2
FROM DUAL;

SELECT MOD(10, 3) AS Col1
,MOD(-10, 3) AS Col2
,MOD(10.9, 3) AS Col3
,MOD(-10.9, 3) AS Col4
,MOD(10, -3) AS Col5
,MOD(-10, -3) AS Col6
,MOD(10.9, -3) AS Col7
,MOD(-10.9, -3) AS Col8
FROM DUAL;

SELECT ROUND(10.4) AS Col1
, ROUND(10.5) AS Col2
, ROUND(10.45) AS Col3
, ROUND(10.45, 1) AS Col4
, ROUND(10.456, 2) AS Col5
, ROUND(18.5, -1) AS Col6 --정수 자리수 첫번째에서 반올림
FROM DUAL;

SELECT FLOOR(10.34) AS Col1
, CEIL (10.34) AS Col2
, FLOOR(-10.34) AS Col3
, CEIL (-10.34) AS Col4
FROM DUAL;

SELECT TRUNC(10.34) AS Col1 --인자로 전달 받은 숫자 혹은 컬럼에서 지정한 위치부터 소수점 자리의 수를 버리고 반환
,TRUNC(10.34, 1)AS Col2 
,TRUNC(10.34, 2)AS Col3
,TRUNC(10.34, -1)AS Col4 
FROM DUAL;

SELECT SYSDATE AS Col1
,ADD_MONTHS(SYSDATE, 2) AS Col2 
,ADD_MONTHS(SYSDATE, -2) AS Col3
,LAST_DAY(SYSDATE) AS Col4
,NEXT_DAY(SYSDATE, 6) AS Col5 --1:일요일, 2:월요일, ... , 6: 금요일, 7:토요일 그래서 여기서는 현재날짜기준으로 다음 6(금요일)이 언제인가를 나타냄
,NEXT_DAY(SYSDATE, '금') AS Col6
FROM DUAL;

SELECT MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE, 2)) AS Col1 --차이를 구하는 함수
, MONTHS_BETWEEN(ADD_MONTHS(SYSDATE, 2),SYSDATE) AS Col2
FROM DUAL;

SELECT EXTRACT (YEAR FROM SYSDATE) AS Col1 --연도 추출
, EXTRACT (MONTH FROM SYSDATE) AS Col2 --월 추출
, EXTRACT (DAY FROM SYSDATE) AS Col3 --일 추출
, EXTRACT (HOUR FROM SYSTIMESTAMP) AS Col4 --시간 추출
, EXTRACT (MINUTE FROM SYSTIMESTAMP) AS Col5 --분 추출
, EXTRACT (SECOND FROM SYSTIMESTAMP) AS Col6 --초 추출
FROM DUAL;

SELECT SYSDATE +1 AS Col1 --그냥 +붙이면은 일에 적용된다.
, SYSDATE +2 AS Col2
,SYSDATE -1 AS Col3
,SYSDATE -2 AS Col4
,SYSDATE + INTERVAL '1' DAY AS Col5
,SYSDATE + INTERVAL '2' DAY AS Col6
,SYSDATE - INTERVAL '1' DAY AS Col7
,SYSDATE - INTERVAL '2' DAY AS Col8
,SYSDATE + INTERVAL '1' MONTH AS Col9
,SYSDATE + INTERVAL '1' YEAR AS Col10
,SYSDATE + INTERVAL '1' HOUR AS Col11
,SYSDATE + INTERVAL '1' MINUTE AS Col12
,SYSDATE + INTERVAL '1' SECOND AS Col13
FROM DUAL;

SELECT 1234 AS Col1 --그리드를 자세히보면 테이블마다 데이터의 형이 따로따로있다
, TO_CHAR(1234) AS Col2
, TO_CHAR(SYSDATE) AS Col3
, TO_CHAR(SYSDATE, 'YYYYMMDD') AS Col4 
, TO_CHAR(SYSDATE, 'YYYY-MM-DD') AS Col5
, TO_CHAR(SYSDATE, 'YYYY/MM/DD') AS Col6 
, TO_CHAR(SYSDATE, 'YYYY.MM.DD') AS Col7
, TO_CHAR(SYSDATE, 'YYYY"년"MM"월"DD"일"') AS Col8
, TO_CHAR(SYSDATE, 'YYYY"년"MM"월"DD"일"MON-DAY-DY') AS Col9
, TO_CHAR(1000000, '999,999,999') AS Col10 --구분자 삽입
, TO_CHAR(1000000, '999,999,999L') AS Col11 --구분자 삽입(L붙이면 원화표시)
, TO_CHAR(1000000, '000,000,000') AS Col12 --구분자 삽입(앞에 비어있는자리에 대해서 채우고싶으면 0을 아니면 9를)
FROM DUAL;

SELECT TO_DATE(20220425) AS Col1 --숫자를 날짜타입으로
, TO_DATE('20220425') AS Col2 --문자를 날짜타입으로
, TO_DATE('2022/04/25') AS Col3 --문자를 날짜타입으로
, TO_DATE('2022-04-25') AS Col4 --문자를 날짜타입으로
, TO_DATE('2022.04.25') AS Col5 --문자를 날짜타입으로
, TO_DATE('2022년 04월 25일', 'YYYY"년"MM"월"DD"일"') AS Col6 --문자를 날짜타입으로
FROM DUAL;

SELECT TO_NUMBER('12345') AS Col
, TO_NUMBER('123,456', '999,999') AS Col2
, TO_NUMBER('123.456') AS Col3
, TO_NUMBER('FF','XX') AS Col4
FROM DUAL;

SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMMDD'))
FROM DUAL;

SELECT DISTINCT JOB_ID --DISTINCT 는 중복을 제거!
FROM EMPLOYEES;