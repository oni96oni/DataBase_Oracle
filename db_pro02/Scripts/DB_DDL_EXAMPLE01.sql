/*
	DDL(Data Definition Language) : 데이터 정의어
		오라클에서 사용하는 객체들을 정의하기 위한 언어들.
		객체를 정의하기 위한 CREATE(생성), ALTER(수정), DROP(제거) 구문이 있다.
		오라클에서 사용하는 객체는 TABLE, VIEW, SEQUENCE, INDEX, FUNCTION, PROCEDUAL, USER, ... 등이 있다
		
*/

CREATE TABLE 테이블명 (
	   컬럼명 데이터타입(크기) [제약조건]
	 , ...
);

CREATE TABLE MEMBER(
MEMBER_ID VARCHAR2(20),
MEMBER_PWD VARCHAR2(20),
MEMBER_NAME VARCHAR2(20)
);
SELECT * FROM MEMBER;
DROP TABLE MEMBER;

CREATE TABLE sample_t ( --만들때는 대/소문자 구분안해도 괜찮아!
	   u_id NUMBER 		 --PRIMARY KEY
	 , jumin CHAR(13)    --UNIQUE
	 , name VARCHAR2(50) NOT NULL
	 , age NUMBER(3) 	 DEFAULT(0)
	 , gender CHAR(1) 	 CHECK(GENDER IN('M','F'))
	 , birth_day DATE 	 DEFAULT(SYSDATE)
	 , ref_col NUMBER    --REFERENCES ref_t(r_id)
	 , CONSTRAINT PK_SAMPLE_U_ID PRIMARY KEY(u_id)
	 , CONSTRAINT UK_SAMPLE_T_JUMIN UNIQUE(jumin)
	 , CONSTRAINT FK_SAMPLE_T_REF_COL FOREIGN KEY(ref_col) REFERENCES ref_t(r_id)
);

CREATE TABLE ref_t (
 	   r_id NUMBER PRIMARY KEY
	 , note VARCHAR2(100)
);

DROP TABLE SAMPLE_T;
DROP TABLE REF_T;

COMMENT ON COLUMN sample_t.u_id IS '사용자 구분 아이디'; --테이블명.컬럼명을 통해서 주석을 넣는것!
COMMENT ON COLUMN sample_t.name IS '사용자 이름'; 
COMMENT ON COLUMN sample_t.age IS '사용자 나이'; 
COMMENT ON COLUMN sample_t.gender IS '사용자 성별(M:남자, F:여자)'; 
COMMENT ON COLUMN sample_t.birth_day IS '사용자 생일'; 

SELECT * FROM SAMPLE_T;
SELECT * FROM USER_ALL_TABLES WHERE TABLE_NAME = 'SAMPLE_T'; --여기서는 대/소문자 구분을 해주어야한다.
SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'SAMPLE_T';
SELECT * FROM USER_COL_COMMENTS WHERE TABLE_NAME = 'SAMPLE_T';
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'SAMPLE_T'; --CONSTRAINT_TYPE이 키구분! P-PRIMARY, U-UNIQUE, R-REFERENCE 등등
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'REF_T'; --기존의 제약조건들!!
/*
 	고정길이 문자 데이터
 	CHAR(10) -> 10BYTE 저장 가능
 	CHAR(10 CHAR) -> 10바이트 문자 10개 저장 가능
	CHAR 장점: 속도가 좋음, 단점: 공간에대한 효율성이 떨어짐, 문자열 길이가 일정하면 사용 EX) 성별, 주민번호
	
	가변길이 문자 데이터 ( 4000 BYTE )
	VARCHAR2 장점: 공간에대한 효율성이 좋음, 단점: 속도가 좋지 않음, 문자열 길이가 일정하지 않으면 사용 EX) 매출, 비용
	 
	LONG DEPRECATED
	
	LONG 대신 LOB! (Large Object Byte)
	BLOB 바이너리
	CLOB 문자
	
*/

/*
	제약조건(CONSTANCT)
	테이블에 데이터를 저장할 떄 저장되는 데이터를 제한하기 위해 사용하는 조건 FOR 데이터의 무결성보장
	
	NOT NULL
		NULL데이터 허용X
		
	UNIQUE (고유키)
		중복 데이터 허용X, UK라고도 함 
		
	PRIMARY KEY (기본키)
		NOT NULL + UNIQUE 결합된 조건
		기본키, PK라고하며 데이터 식별값으로 사용
		
	FOREIGN KEY (외래키)
		FK라고 하며 다른 테이블의 데이터를 참조하기 위한 참조값이 저장된 컬럼을 명시.
		테이블간의 관계를 형성하기 위해 사용
		참조 대상이 되는 테이블의 데이터는 임의로 삭제할 수 없게 된다 ( 제약을 걸어서 함부로 제거 안되게 끔 )FK로 지정된 컬럼에 저장될 데이터는 반드시 참조 대상 테이블에 동일한 데이터가 있어야 한다( 참조 대상이 있어야함 )
		
	CHECK
		미리 설정한 값만 저장할 수 있도록 검사
		
	컬럼 레벨
		컬럼 옆에 직접 명시하여 작성
		
	테이블 레벨
		컬럼 외의 영역에 명시하여 작성(아래로) 
		
	REFERENCES USER_GRADE (GRADE_CODE) ON DELETE SET NULL : 지워지면 NULL로 다시 세팅하겠다
	
	REFERENCES USER_GRADE (GRADE_CODE) ON DELETE CASCADE : 같이 삭제해라. CASCADE는 가급적 사용 X, 참조관계가 얽힌 상태에서 사용시 데이터 소멸의 가능성이 있음.
	
	
		
*/

/*
테이블은 이미 만들어져있는 상태에서 정의가 된 내용에 대해서 수정할것이 생겼을때 (ALTER, DROP)

*/

ALTER TABLE sample_t ADD nickname VARCHAR2(100); --ADD는 추가
ALTER TABLE sample_t MODIFY nickname VARCHAR2(200); -- MODIFY는 수정, DATA_LENGTH가 100에서 200으로 늘어남
ALTER TABLE sample_t MODIFY nickname NUMBER; --타입에대한 크기를 늘이고 줄이는건 상관없지만 ★★★타입을 바꾸는건 심각한 오류를 발생시킨다. 타입바꾸는건 금지!
ALTER TABLE sample_t RENAME COLUMN nickname TO n_name; --RENAME도 왠만해서는 금지! 왜? 컬럼명이 명령문에 사용되는데 바뀌면 그 전에 사용 한 컬럼명까지 바꿔주어야 에러가 발생하지 않아서

ALTER TABLE sample_t DROP COLUMN n_name; --DROP 또한 왠만해서는 사용X
ALTER TABLE sample_t RENAME TO sam_t; --테이블도 이름이 바뀔 수 있다.
ALTER TABLE sam_t RENAME TO sample_t; --테이블도 이름이 바뀔 수 있다.

ALTER TABLE ref_t ADD UNIQUE(note);
ALTER TABLE ref_t ADD CONSTRAINT UK_REF_T UNIQUE(note);
ALTER TABLE ref_t RENAME CONSTRAINT UK_REF_T TO UK_REF_T_NOTE;
ALTER TABLE ref_t MODIFY note NOT NULL; --NOT NULL 제약으로 수정하여 제약조건 추가, NULL은 ADD,DROP이 안된다 MODIFY만 가능
ALTER TABLE ref_t MODIFY note NULL;	 	--NULL은 수정으로 추가됨
ALTER TABLE ref_t MODIFY note CHECK(note IN ('h', 'k'));
ALTER TABLE ref_t DROP CONSTRAINT SYS_C007387;

ALTER TABLE ref_t DROP CONSTRAINT UK_REE_T_NOTE DROP CONSTRAINT SYS_C007388;
ALTER TABLE ref_t ADD PRIMARY KEY(r_id, note);

ALTER TABLE ref_t RENAME CONSTRAINT FK_SAMPLE_T_REF_NOTE;

-- ALTER TABLE ref_t MODIFY PRIMARY KEY(r_id, note); 이런건 안된다 지우고 다시 수정해야만 한다.

-- 컬럼레벨로만 제약 조건을 추가하는 NOT NULL, CHECK는 MODIFY로 추가/삭제
-- 테이블레벨로 제약조건을 추가할 수 있는 PRIMARY KEY, UNIQUE, FOREIGN KEY는 ADD,DROP을 사용

ALTER TABLE ref_t DROP COLUMN r_id CASCADE CONSTRAINT; --옵션을붙여서 드랍하라 제약조건까지 다 제거하는방법
ALTER TABLE sample_t DROP CONSTRAINT FK_SAMPLE_T_REF_COL; --이런것들 때문에 제약조건을사용해서 제거한다.

DROP TABLE REF_T CASCADE CONSTRAINT; --제약조건까지 다 제거하는방법 CASCADE CONSTRAINT는 안쓰는게 바람직 ( 제약조건이 묶여 있으면 확인해보고 삭제 )

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'SAMPLE_T'; --CONSTRAINT_TYPE이 키구분! P-PRIMARY, U-UNIQUE, R-REFERENCE 등등
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'REF_T';