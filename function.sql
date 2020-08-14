/*
   function

    1. 형식

    CREATE FUNCTION function_name(p1 type, p2 type)
	 RETURNS type AS
	BEGIN
	 -- logic
	END;
	LANGUAGE language_name;
	
*/

/*
   $의 정체 
    제공하는 전체 함수 정의 CREATE FUNCTION는 작은 따옴표로 묶인 문자열이어야합니닊    함수에 작은 따옴표 ( ')가 있으면 이스케이프해야한다는 의미입니다.

    다행히도 버전 8.0부터 PostgreSQL은 달러 인용 기능을 제공하여 함수에 표시되지 않는 적절한 문자열을 선택하여 이스케이프 처리 할 필요가 없습니다. 
    달러 따옴표는 문자 사이의 문자열입니다 $.
    
*/
CREATE or replace FUNCTION inc(val integer) RETURNS integer AS $$
BEGIN
RETURN val + 1;
END; $$
LANGUAGE PLPGSQL;

select inc(20);

/*
	PL/pgSQL 함수 매개 변수
	  - IN, OUT, INOUT, VARIADIC
*/

create or replace function get_sum(
a numeric,
b numeric)
returns numeric as $$
begin
	return a+b;
end; $$
LANGUAGE plpgsql;

select get_sum(10,20);


create or replace function hi_lo(
a numeric,
b numeric,
c numeric,
out hi numeric,
out lo numeric)
as $$
begin
	hi := greatest(a,b,c);
	lo = least(a,b,c);
end;$$
LANGUAGE plpgsql;

select hi_lo(10,20,30);
SELECT * FROM hi_lo(10,20,30);


CREATE OR REPLACE FUNCTION square(
	INOUT a NUMERIC)
AS $$
BEGIN
	a := a * a;
END; $$
LANGUAGE plpgsql;

SELECT square(4);

CREATE OR REPLACE FUNCTION sum_avg(
	VARIADIC list NUMERIC[],
	OUT total NUMERIC, 
        OUT average NUMERIC)
AS $$
BEGIN
   SELECT INTO total SUM(list[i])
   FROM generate_subscripts(list, 1) g(i);

   SELECT INTO average AVG(list[i])
   FROM generate_subscripts(list, 1) g(i);
	
END; $$
LANGUAGE plpgsql;

SELECT * FROM sum_avg(10,20,30);


