--ADMIN OR SYSTEM 계정에서 권한부여하자

SELECT * FROM PUSER1.EMPLOYEES; --EMPLOYEES가 안되는 이유? 스키마에 정의된 테이블이 없어서. PUSER1 에는 EMPLOYEES테이블을 정의했었음

--그런데 Docker_devAdmin 계정으로 실행하니까 권한이 불충분하다고 나온다 왜? 관리자 계정이 아닌 각 계정들은 자기 계정이 아닌 테이블에 접근 불가하다. 

GRANT SELECT ON EMPLOYEES TO DEVADMIN; --PUSER1계정에서 실행, 동의어를 다른 계정에서 사용하기 위해 SELECT 권한은 필요하다.

SELECT * FROM PUSER1.EMPLOYEES; --위에 권한을 받아서 이제 DEVADMIN계정에서도 실행가능

CREATE SYNONYM P_EMP FOR PUSER1.EMPLOYEES; --권한이 부족해! 관리자계정으로가서 권한부여하자

GRANT CREATE SYNONYM TO DEVADMIN; --SYSTEM계정으로실행 , 이 계정에 동의어를 생성할수있는 권한부여

CREATE SYNONYM EMP FOR PUSER1.EMPLOYEES; --별칭부여하는것과 동일

SELECT * FROM EMP;
SELECT * FROM EMPLOYEES;
SELECT * FROM PUSER1.EMPLOYEES;

DROP SYNONYM EMP;

GRANT CREATE SYNONYM TO PUSER1;
GRANT CREATE SYNONYM TO DEVADMIN;

--공개동의어 작업은 SYSTEM계정만 사용가능하다.

CREATE SYNONYM EMP FOR EMPLOYEES; --비공개 동의어

CREATE PUBLIC SYNONYM EMP FOR PUSER1.EMPLOYEES; --공개 동의어

DROP PUBLIC SYNONYM POPOPO;
--공개, 비동개동의어 작업 어떤차이? 생성가능한계정, 만든뒤 사용할 수 있는 계정 

SELECT * 
  FROM ALL_SYNONYMS
 WHERE SYNONYM_NAME ='EMP'; 

SELECT * 
  FROM ALL_SYNONYMS;

--★SYNONYM은 보안의 의미가 강하다. 스키마명을 알려주면 그걸로 정보를 몰래 열람할 수도 있다. 스키마,테이블명을 숨겨서 소유자를 유추할수 없게하기위함
--보통은 이름을 줄일때 제일 많이 사용한다.