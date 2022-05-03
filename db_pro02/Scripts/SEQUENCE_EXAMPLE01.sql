CREATE SEQUENCE SEQ_TEST
-- START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

SELECT SEQ_TEST.CURRVAL FROM DUAL;
SELECT SEQ_TEST.NEXTVAL FROM DUAL; --반드시 NEXTVAL먼저 사용, 객체를 생성하고난 직후에는 현재값이 없기때문에 CURRVAL 사용불가

DROP SEQUENCE SEQ_TEST;

SELECT * FROM USER_SEQUENCES;

SELECT SEQ_TEST.NEXTVAL FROM DUAL;

SELECT SEQ_TEST.CURRVAL FROM DUAL;

SELECT NVL(NULL, '0') FROM DUAL; --NVL 함수는 값이 NULL인 경우 지정값을 출력하고, NULL이 아니면 원래 값을 그대로 출력한다.

COMMIT;