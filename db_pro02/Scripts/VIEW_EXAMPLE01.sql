DROP TABLE SAMPLE_T;

CREATE TABLE SAMPLE_T (
	   ID NUMBER PRIMARY KEY
	 , NAME VARCHAR(30) NOT NULL
	 , GENDER CHAR(1) CHECK(GENDER IN('F','M'))
	 , AGE NUMBER DEFAULT(0) NOT NULL
);

INSERT INTO SAMPLE_T VALUES (SEQ_TEST.NEXTVAL, '홍길동', 'M', 32);
INSERT INTO SAMPLE_T VALUES (SEQ_TEST.NEXTVAL, '둘리', 'M', 12);
INSERT INTO SAMPLE_T VALUES (SEQ_TEST.NEXTVAL, '마이콜', 'M', 22);

CREATE OR REPLACE VIEW V_SAMPLE_T --어떨때는 만들고 어떨때는 대체한다 기준은? 기존에 만들어져 있는가 아닌가 중복되어있으면 REPLACE 없으면 CREATE 한다.
	AS SELECT ID
	 		, NAME
	 		, GENDER
	 		, AGE
	 	 FROM SAMPLE_T
	 	WHERE AGE BETWEEN 12 AND 35
WITH CHECK OPTION;
	 	 
SELECT * FROM V_SAMPLE_T;

SELECT * FROM USER_VIEWS;

INSERT INTO V_SAMPLE_T VALUES(5, '도우너', 'M', 30);

UPDATE V_SAMPLE_T
   SET AGE = AGE +1;
   
DELETE FROM V_SAMPLE_T;

--객체를 지울때가 DROP, 행데이터를 지울때가 DELETE 

