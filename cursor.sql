-- license period check function.
CREATE OR REPLACE FUNCTION get_film_titles()
   RETURNS integer AS $$
DECLARE 
         result integer:=0;
	 titles TEXT DEFAULT '';
	 rec_film   RECORD;
	 cur_films CURSOR
		 FOR 
		 select qty 
		 from licensedetail ;
		 
		
BEGIN
   -- Open the cursor
   OPEN cur_films;
	
   LOOP
    -- fetch row into the film
      FETCH cur_films INTO rec_film;
    -- exit when no more row to fetch
     EXIT WHEN NOT FOUND;

       -- update licensedetail set qty = qty+1;
       result := result + 1;
       titles := titles || ',' || rec_film.dno;
       --RAISE info 'The current value of counter in the subblock is %', titles;
       --RAISE INFO 'information message %', now() ;
      
   END LOOP;
--titles:=rec_film.dno;
   -- Close the cursor
   CLOSE cur_films;
   RETURN result;
END; $$
LANGUAGE plpgsql;

drop function get_film_titles();
select * from licensedetail;

SELECT get_film_titles();


select * from licensedetail;



create or replace function test() RETURNS void as $$
declare 
        count integer:=0;
begin
update  licensedetail set qty = (select qty+1 from licensedetail where dno=58) where dno=58;
get diagnostics count = row_count;
raise info 'updated: % rows', count;
end;
$$
LANGUAGE plpgsql;

select test();

select * from licensedetail where dno=58;
select * from licensemaster ;
-- qty : 3  totqty : 15 

select * from licensedetail;

insert into licensedetail (dno,compid,compnum, regdate, updatedate, qty, chrrnm, chrrnum, chrrmail, hwserial, expireddate)
values ( nextval('seq_licDetail'), 'SAMSUNG', '12345', DATE_TRUNC('second',now()::timestamp), DATE_TRUNC('second',now()::timestamp),3, '홍길동', '01064746008','a@naver.com', 'OZDR123', DATE_TRUNC('second',now()::timestamp) - interval '1 days');

UPDATE LICENSEDETAIL SET EXPIREDDATE = DATE_TRUNC('second',now()::timestamp) - interval '2 days' WHERE DNO=71 AND COMPNUM='12345';



update licensemaster set totqty = 5 where mno=13;

SELECT M.COMPID, M.COMPNUM, M.TOTQTY, D.compid , D.QTY, D.EXPIREDDATE
FROM LICENSEMASTER M, LICENSEDETAIL D
WHERE M.COMPNUM = D.COMPNUM
ORDER BY COMPNUM;


SELECT * FROM LICENSEMASTER WHERE COMPNUM='12345';
SELECT * FROM LICENSEDETAIL WHERE COMPNUM='12345';

INSERT INTO LICENSEMASTER ( mno, compid, compnum, regdate, update, totqty ) values ( nextval('seq_licMaster'), '삼성전자','12345', DATE_TRUNC('second',now()::timestamp),DATE_TRUNC('second',now()::timestamp),5);