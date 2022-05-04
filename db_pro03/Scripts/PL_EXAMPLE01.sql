/*
	PL/SQL
		PROCEDUAL LANGUAGE / SQL
		프로그래밍 기능이 추가된 SQL
		변수 정의, 조건문, 반복문을 만들어서 SQL문에 대한 처리 가능
		
*/

--SET SERVEROUTPUT ON; 을 사용해야 출력시 / 가 안나온다 (터미널로 킬때 사용)
DECLARE
	/*
	 * 변수 선언부 영역
	 */

BEGIN 
	/*
	 * 프로그래밍 로직을 작성하는 영역
	 */
	DBMS_OUTPUT.PUT_LINE('Hello PL/SQL');
EXCEPTION
	/*
  	 * 예외처리 영역
	 */
END;


