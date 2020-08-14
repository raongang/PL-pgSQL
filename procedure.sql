/* 
    ※  postgreSQL procedure
      - function을 이용하는 방식의 단점은 트랜잭션(commit, rollback) 을 실행할수 없다.(? oracle은 되는데?)      
      - transaction을 지원하기 위해 procedure를 사용.
      - function과 다르게 return값이 없으며 강제 종료를 하기 위해서는 return 명령문을 이용.

      형태

      CREATE [OR REPLACE] PROCEDURE procedure_name(parameter_list)
	LANGUAGE language_name
	AS $$
	    stored_procedure_body;
	$$;
*/ 

--postgreSql 11에서 지원됨. 
CREATE OR REPLACE procedure transfer(INTEGER, INTEGER, DEC)
LANGUAGE plpgsql    
AS $$
BEGIN
    -- subtracting the amount from the sender's account 
    UPDATE accounts 
    SET balance = balance - $3
    WHERE id = $1;

    -- adding the amount to the receiver's account
    UPDATE accounts 
    SET balance = balance + $3
    WHERE id = $2;

    COMMIT;
END;
$$;