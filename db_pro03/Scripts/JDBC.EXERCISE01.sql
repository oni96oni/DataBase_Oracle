CREATE TABLE accounts (
	   userid VARCHAR2(200) PRIMARY KEY
	 , userpw VARCHAR2(200)
	 , username VARCHAR2(200)
	 , gender CHAR(10)
	 , age NUMBER
	 , createdate DATE
	 );
	 
SELECT * FROM accounts;

DROP TABLE accounts;

DELETE TABLE accounts;

--컬럼사이즈가 작을때는!
ALTER TABLE USER_DATA MODIFY(ADDRESS varchar2(100));