CREATE TABLE topic (
	   id NUMBER
	 , title VARCHAR2(50) NOT NULL
	 , description VARCHAR2(4000)
	 , created DATE NOT NULL
);

INSERT INTO TOPIC (
	   id,title,description,created)
	   VALUES
	   (1,'ORACLE','ORACLE is ...',SYSDATE);
	   
INSERT INTO TOPIC (
	   id,title,description,created)
	   VALUES
	   (2,'MYSQL','MYSQL is ...',SYSDATE);
	   
INSERT INTO TOPIC (
	   id,title,description,created)
	   VALUES
	   (3,'MSSQL','MSSQL is ...',SYSDATE);
	   
SELECT * FROM topic; -- *는 모든컬럼을 보여줘! 이다.

SELECT id, title, created FROM topic; -- 컬럼을 제한하는 방법

SELECT * FROM topic WHERE id > 1; -- 행 제한(조건)하는 방법

SELECT id, title, created FROM topic WHERE id = 1;

SELECT * FROM topic ORDER BY title deSC;

SELECT * FROM TOPIC
	     OFFSET 2 ROWS; --OFFSET은 N(매개변수)번째 이후에 나오는 행들을 가져온다. OFFSET은 "어디부터 가져올것이냐" 를 결정한다 
	     
SELECT * FROM TOPIC
	     OFFSET 1 ROWS --M(OFFSET의 매개변수)번째 데이터부터 N(FETCH NEXT의 매개변수)개만큼 가져온다.
		 FETCH NEXT 2 ROWS ONLY;
		 
UPDATE TOPIC  --UPDATE, DELETE 할때 WHERE문이 없다면 뭔가 이상하다.
	   SET
	   TITLE = 'MONGODB'
	 , DESCRIPTION = 'MONGODB IS ...'
 WHERE ID = 3;
 
COMMIT;

--DELETE는 매우 위험! 사용할때 각별 주의 요망.

DELETE FROM TOPIC
 WHERE ID = 3;
 
--식별자같은것은 중복되어서는 안된다! (NOT NULL) 그리고 하나만 존재해야한다 (UNIQUE) 이 둘을 합친게 PRIMARY KEY

DROP TABLE TOPIC;

CREATE TABLE topic (
	   id NUMBER NOT NULL
	 , title VARCHAR2(50) NOT NULL
	 , description VARCHAR2(4000)
	 , created DATE NOT NULL
	 , CONSTRAINT PK_TOPIC PRIMARY KEY(ID)
);

INSERT INTO TOPIC (
	   id,title,description,created)
	   VALUES
	   (SEQ_TOPIC.NEXTVAL,'ORACLE','ORACLE is ...',SYSDATE);
	  
SELECT ID,TITLE FROM TOPIC;   

INSERT INTO TOPIC (
	   id,title,description,created)
	   VALUES
	   (SEQ_TOPIC.NEXTVAL,'MYSQL','MYSQL is ...',SYSDATE);
	   
INSERT INTO TOPIC (
	   id,title,description,created)
	   VALUES
	   (SEQ_TOPIC.NEXTVAL,'MSSQL','MSSQL is ...',SYSDATE);
	   
SELECT  ID,TITLE FROM TOPIC WHERE ID = 2; --PRIMARY KEY로 지정해놓은 데이터를 찾는것은 굉장히 빠르다 지정안해놓은것보다!!

CREATE SEQUENCE SEQ_TOPIC; --INSERT하는것을 자동으로 해줬으면 좋겠어! 시퀀스의 값은 0부터시작해서 NEXTVAL사용하면 0부터 ~ N까지

INSERT INTO TOPIC (
	   id,title,description,created)
	   VALUES
	   (SEQ_TOPIC.NEXTVAL,'MONGODB','MONGODB is ...',SYSDATE);
	   
DELETE FROM TOPIC;
COMMIT;

SELECT SEQ_TOPIC.CURRVAL FROM TOPIC; --현재 SEQUENCE의 현재값을 보여준다.

SELECT SEQ_TOPIC.CURRVAL FROM DUAL; --FROM DUAL은 가상의 테이블 만들어서 보여준다.


/*	Oracle-14강 서버와 클라이언트
		인터넷에 연결된 컴퓨터 한대 한대를 HOST라고 한다. 그런데 이렇게 부르는게 부족해서
		정보를 요청하는 컴퓨터를 CLIENT, 정보를 제공하는 컴퓨터를 SERVER라고 정의했다.
		오라클 서버랑 SQLPLUS는 다른것이다.
		
	JOIN
		
 */
CREATE TABLE author (
 	   id NUMBER NOT NULL
 	 , name VARCHAR2(20) NOT NULL
 	 , profile VARCHAR2(50)
 	 , CONSTRAINT PK_AUTHOR PRIMARY KEY(ID)
);

CREATE SEQUENCE SEQ_AUTHOR;

INSERT INTO AUTHOR (ID,NAME,PROFILE) VALUES (SEQ_AUTHOR.NEXTVAL,'EGOING', 'DEVELOPER');
INSERT INTO AUTHOR (ID,NAME,PROFILE) VALUES (SEQ_AUTHOR.NEXTVAL,'DURU', 'DBA');
INSERT INTO AUTHOR (ID,NAME,PROFILE) VALUES (SEQ_AUTHOR.NEXTVAL,'SION', 'DATA SCIENTISTS');

ALTER TABLE TOPIC ADD(AUTHOR_ID NUMBER);

UPDATE TOPIC SET AUTHOR_ID ='1' WHERE ID = 1;
UPDATE TOPIC SET AUTHOR_ID ='1' WHERE ID = 1;
UPDATE TOPIC SET AUTHOR_ID ='2' WHERE ID = 2;
UPDATE TOPIC SET AUTHOR_ID ='3' WHERE ID = 3;
UPDATE TOPIC SET AUTHOR_ID ='3' WHERE ID = 4;

SELECT * FROM AUTHOR;
SELECT * FROM TOPIC;

SELECT * 
  FROM TOPIC LEFT JOIN author ON topic.author_id = author.id;
 
SELECT T.id TOPIC_ID
	 , TITLE
	 , NAME 
  FROM TOPIC T 
  LEFT JOIN author A ON T.author_id = A.id
 WHERE T.id = 1;
  