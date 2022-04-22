SELECT 'Hello Oracle cloud' FROM DUAL;
/*
admin, system은 관리자계정이다.
관리하기위한 용도의 계정.
우리는 사용자의 입장 -> 그래서 추가 계정이 필요하다.
오라클 클라우드는 비밀번호가 12자이상, 대문자 소문자 숫자 특수문자 포함, 관리자 비밀번호랑같으면 안댐
 */
--계정명, 비밀번호
CREATE USER puser1 IDENTIFIED BY Database1234;
--권한부여,연결
GRANT RESOURCE, CONNECT TO puser1;
GRANT INSERT ANY TABLE, UPDATE ANY TABLE, DELETE ANY TABLE, CREATE VIEW, CREATE SESSION TO puser1

--테이블 스페이스 사용 권한 및 용량 설정
ALTER USER puser1 quota 10M ON USERS;

SELECT USERNAME FROM ALL_USERS WHERE USERNAME = 'PUSER1';

SELECT GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'PUSER1'; --ROLL을 모은다? DB에 접근할수있는 권한=CONNECT, DB를 다룰 수 있는 가장 기본적인 권한=RESOURCE, 

SELECT PRIVILEGE FROM DBA_SYS_PRIVS WHERE GRANTEE = 'PUSER1';