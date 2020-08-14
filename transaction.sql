/* postgreSQL transaction */ 


CREATE TABLE accounts (
    id INT ,
    name VARCHAR(100) NOT NULL,
    balance DEC(15,2) NOT NULL,
    PRIMARY KEY(id)
);


DELETE FROM accounts;
DROP SEQUENCE accounts_seq;

CREATE SEQUENCE accounts_seq start with 1; 

begin;
INSERT INTO accounts(id,name,balance) VALUES(nextval('accounts_seq'),'Bob',10000);
--rollback;
end;


BEGIN WORK;
INSERT INTO accounts(id,name,balance) VALUES(nextval('accounts_seq'),'Alice',10000);
commit;
END;

select * from accounts;


UPDATE accounts 
SET balance = balance - 1000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE id = 2; 


INSERT INTO accounts(id,name, balance)VALUES(nextval('accounts_seq'),'Jack',0);     

BEGIN;
UPDATE accounts 
SET balance = balance - 1500
WHERE id = 1;

UPDATE accounts
SET balance = balance + 1500
WHERE id = 3; 
rollback;

