/** 
   PL/pgSQL 블록 구조   
*/

--first_block은 label로 설명을 위한 것.
-- $$는 작은따음표(')를 대체한다.
do $$
<<first_block>>
declare 
counter integer:=0;
begin
	counter:=counter+1;
	raise notice 'the current value of counter is %',counter;
end first_block $$;


do
$$
<<outer_block>>
declare
	counter integer:=0;
begin
	counter := counter+1;
	raise notice 'the current value of counter is %',counter;

	declare
		counter integer:=0;
		
	begin
		counter := counter+10;
		RAISE NOTICE 'The current value of counter in the subblock is %', counter;
		RAISE NOTICE 'The current value of counter in the outer block is %', outer_block.counter;
	end;
	RAISE NOTICE 'The current value of counter in the outer block is %', counter;
	
end outer_block $$;
