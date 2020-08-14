/* cursor2 */

create or replace function testFunction() returns void as
$$

begin
 raise info '테스트입니다';
  
end;
$$
LANGUAGE plpgsql;

select testFunction(); 
                     

select * from licensemaster;
select * from licensedetail;

select  d.*
from licensemaster m,  licensedetail d
where m.compnum = d.compnum;


SELECT (DATE_TRUNC('second',now()::timestamp)) + interval '375 days';
--"2021-07-03 10:36:15"

UPDATE LICENSEDETAIL SET EXPIREDDATE = (DATE_TRUNC('second',now()::timestamp)) + interval '475 days' WHERE dno NOT IN (69,76,77);


create or replace function licPeriodCheck() returns void as 
$$
declare
    dm_count integer:=0;
    dd_count integer:=0;
    mu_count integer:=0;
    p_totqty licensemaster.totqty%type;

    rec_lic record;
    
    cur_licdetail cursor  
    for 
    select * 
    from licensedetail 
    where  expireddate < (DATE_TRUNC('second',now()::timestamp)) + interval '375 days';

begin
        open cur_licdetail;

        loop
                fetch cur_licdetail into  rec_lic;

                EXIT WHEN NOT FOUND;
                
                RAISE info '%', 'DNO : ' || rec_lic.dno || ', COMPNUM : ' || rec_lic.compnum || ', QTY : ' || rec_lic.qty ;

                select totqty 
                into  p_totqty
                from licensemaster where compnum=rec_lic.compnum;
                RAISE info '%',  '총수량 : ' || p_totqty;

                -- 전체수량에서 개별수량을 뺏을때 0보다 작으면 DETAIL TABLE을 먼저 삭제하고 MASTER테이블을 삭제한다.
                IF(p_totqty - rec_lic.qty <= 0 ) then
                
                   delete from licensedetail where dno=rec_lic.dno;
                   get diagnostics dd_count = row_count;
                   Raise info '%', '디테일 삭제카운트 개수 : ' || dd_count || ', dno : ' || rec_lic.dno;

                   delete from licensemaster where compnum = rec_lic.compnum;
                   get diagnostics dm_count = row_count;
                   Raise info '%', '마스터 삭제카운트 개수 : ' || dm_count || ', compnum : ' || rec_lic.compnum;
                ELSE
                --0보다 크면 DETAIL TABLE을 먼저 삭제 하고 MASTER 테이블의 전체 개수를 수정한다.
                   delete from licensedetail where dno=rec_lic.dno;
                   get diagnostics dd_count = row_count;
                   Raise info '%', '디테일 삭제카운트 개수 : ' || dd_count || ', dno : ' || rec_lic.dno;  

                   UPDATE licensemaster set totqty = p_totqty - rec_lic.qty where compnum = rec_lic.compnum;
                   get diagnostics mu_count = row_count;
                   Raise info '%', '수정카운트 개수 : ' || mu_count || ', compnum : ' || rec_lic.compnum;  
                END IF;
        
        end loop;
        close cur_licdetail;
end;
$$
LANGUAGE plpgsql;

--실행 
select licPeriodCheck();

