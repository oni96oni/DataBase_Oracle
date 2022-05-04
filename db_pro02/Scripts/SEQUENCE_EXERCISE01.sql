/*
	다음의 요구 사항에 맞추어 데이터 베이스 작업을 진행한다.
	1. 관리자 계정으로 devAdmin 계정을 새로 만들고 데이터베이스 원격 접속과 테이블 생성, 수정, 삭제/ 데이터 추가 , 수정 , 삭제 / 뷰 테이블 생성을 할 수 있는 권한을 부여 한다.
	
*/

CREATE USER devAdmin IDENTIFIED BY pddevAdmin;

--  connect(접속 권한), resource(객체 및 데이터 조작 권한)
GRANT RESOURCE CONNECT TO devAdmin;
GRANT CONNECT CONNECT TO devAdmin;
GRANT INSERT ANY TABLE, UPDATE ANY TABLE
    , DELETE ANY TABLE, CREATE VIEW
    , CREATE SESSION TO devAdmin;
   
-- 테이블 스페이스 사용 권한 및 용량 설정
ALTER USER devAdmin quota 10M ON USERS;

--유저 확인
select * from all_users WHERE USERNAME = 'DEVADMIN';
select * from DBA_ROLE_PRIVS WHERE GRANTEE = 'DEVADMIN';
select * from DBA_SYS_PRIVS WHERE GRANTEE = 'DEVADMIN';
select * FROM USER_ROLE_PRIVS;
select * FROM USER_sys_PRIVS;

/*
	2.devAdmin계정으로 접속하고 회원관리를 위한 테이블(USER_ACCOUNT)을 생성한다. 테이블에는 ID, 회원계정명, 회원패스워드, 회원 이름정보를 관리할 수 있도록 컬럼을 생성한다.
	
*/

CREATE TABLE USER_ACCOUNT (
	   ID VARCHAR(30) CONSTRAINT PK_USER_ACCOUNT_ID PRIMARY KEY
	 , 회원계정명 VARCHAR(60) CONSTRAINT NN_USER_ACCOUNT_회원계정명 NOT NULL
	 , 회원패스워드 VARCHAR(60) CONSTRAINT NN_USER_ACCOUNT_회원패스워드 NOT NULL
	 , 회원이름정보 VARCHAR(15) CONSTRAINT NN_USER_ACCOUNT_회원이름정보 NOT NULL
);
--CONSTRAINT 다음에오는것은 제한조건 이름!!
SELECT * FROM USER_ACCOUNT;
SELECT * FROM USER_INFO;

DROP TABLE USER_INFO;
DROP TABLE USER_ACCOUNT;

/*
	3. 2번에서 생성한 데이터베이스와 외래키로 관계를 맺는 회원정보 테이블(USER_INFO)을 생성한다. 테이블에는 ID, 성별, 나이, 이메일, 주소, 전화번호 정보를 관리 할 수 있도록 컬럼을 생성한다. ID컬럼은 USER_ACCOUNT와 외래키 관계를 가지는 칼럼으로 생성한다.
*/

CREATE TABLE USER_INFO (
	   ID VARCHAR(30)  CONSTRAINT PK_USER_INFO_ID PRIMARY KEY
	 , GENDER CHAR(1) CONSTRAINT CK_USER_INFO_GENDER CHECK(GENDER IN('F','M'))
	 , AGE NUMBER CONSTRAINT CK_USER_INFO_AGE CHECK(AGE BETWEEN 0 AND 199)
	 , EMAIL VARCHAR(100)
	 , ADDRESS VARCHAR(200)
	 , PHONE NUMBER
);

SELECT * FROM ALL_ALL_TABLES WHERE OWNER = 'DEVADMIN' AND TABLE_NAME LIKE 'USER\_%' ESCAPE '\';
SELECT * FROM ALL_TAB_COLUMNS WHERE OWNER = 'DEVADMIN' AND TABLE_NAME LIKE 'USER\_%' ESCAPE '\';
SELECT * FROM USER_CONSTRAINTS WHERE OWNER = 'DEVADMIN' AND TABLE_NAME LIKE 'USER\_%' ESCAPE '\';
/*
	4. 2,3Q번에서 생성한 테이블에 데이터를 3개 추가한다. 데이터를 추가할 때 ID 컬럼에 대해서는 SEQUENCE객체를 사용하여 값이 자동으로 생성될 수 있게 한다.
*/

CREATE SEQUENCE USER_ID;

INSERT INTO USER_ACCOUNT VALUES (USER_ID.NEXTVAL,'ENFFL','ENFFL1','둘리');
INSERT INTO USER_INFO VALUES (USER_ID.CURRVAL,'M','15','ENFFL@NAVER.COM','달나라','01059594949');

INSERT INTO USER_ACCOUNT VALUES (USER_ID.NEXTVAL,'도우너','ENFFL1','도우너');
INSERT INTO USER_INFO VALUES (USER_ID.NEXTVAL,'M','25','도우너@NAVER.COM','한국','01059594949');

INSERT INTO USER_ACCOUNT VALUES (USER_ID.NEXTVAL,'마이콜','ENFFL1','마이콜');
INSERT INTO USER_INFO VALUES (USER_ID.NEXTVAL,'M','35','마이콜@NAVER.COM','아프리카','01059594949');

/*
	5.VIEW를 만들어서 두개의 테이블 정보가 모두 조회될 수 있도록 한다 성별에 관해서는 남성, 여성으로 변환되게 하며, 패스워드는 문자로 마스킹한다.
*/

CREATE OR REPLACE VIEW V_USER_ACCOUNT
	AS SELECT ID
	 		, 회원계정명
	 		, 회원패스워드
	 		, 회원이름정보
	 	 FROM USER_ACCOUNT A;

SELECT * FROM V_USER_ACCOUNT;

CREATE OR REPLACE VIEW V_USER_INFO
	AS SELECT ID
	 		, GENDER DECODE(GENDER, 'M', '남성', '여성')
	 		, AGE 
	 		, EMAIL
	 		, ADDRESS 
	 		, PHONE 
	 	 FROM USER_INFO I;
	 	 
SELECT * FROM V_USER_INFO;

CREATE OR REPLACE VIEW V_USER_INFO
    AS SELECT A.ID
            , A.회원계정명
            , REPLACE(A.회원패스워드, A.회원패스워드, RPAD('*', (SELECT DATA_LENGTH
                                                           FROM USER_TAB_COLUMNS
                                                          WHERE TABLE_NAME = 'USER_ACCOUNT'
                                                            AND COLUMN_NAME = 'PASSWORD'), '*')) AS PASSWORD
            , A.회원이름정보
            , DECODE(B.GENDER, 'F', '여성', 'M', '남성') AS GENDER
            , B.AGE
            , B.EMAIL
            , B.PHONE
         FROM USER_ACCOUNT A
         JOIN USER_INFO B
           ON A.ID = B.ID;

SELECT * FROM V_USER_INFO;