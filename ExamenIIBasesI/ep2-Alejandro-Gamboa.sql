host cls
conn system/root
PROMPT -------> Cambiamos clave de hr
alter user hr identified by hr;
PROMPT -------> Desbloqueamos hr
alter user hr account unlock;
conn hr/hr
PROMPT -------> Drops
drop procedure prc_calc_bonif;
drop sequence seq_bonifican;
drop table bonificacion;

create table bonificacion(
id_bonificacion number(4) not null,
employee_id number(6) not null,
bonificacion_type varchar2(15) not null,
monto number(8,2)  null,
month number(2) not null,
year number(4) not null
);

PROMPT -------> Creando PK,UK,FK,CK

alter table bonificacion add constraint
bonificacion_pk primary key (id_bonificacion);

alter table bonificacion add constraint
bon_employee_fk foreign key (employee_id) references employees;

alter table bonificacion add constraint
bonificacion_type_ck check (bonificacion_type in ('Ventas','Evaluacion','Gerencia'));

create unique index uk_emp_month_mes on bonificacion (employee_id,bonificacion_type,month,year);

create sequence seq_bonifican start with 1 increment by 1;

PROMPT -------> Creando procedimientos

create or replace procedure prc_calc_bonif(EmpID in number, AnnoDec in number,
monthDec in number, mountP in number default null,mountg in number default null) is
salary_emp number;
comm_emp number;
begin
if mountg > 0 then
insert into bonificacion(id_bonificacion,employee_id,bonificacion_type,monto,month,year)
               values (seq_bonifican.nextval,EmpID,'Gerencia',mountg,monthDec,AnnoDec);
			   commit;
end if;
  select salary into salary_emp from employees where employee_id = EmpID;
   select COMMISSION_PCT into comm_emp from employees where employee_id = EmpID;
  insert into bonificacion(id_bonificacion,employee_id,bonificacion_type,monto,month,year)
               values (seq_bonifican.nextval,EmpID,'Ventas',(mountP*comm_emp)/100,monthDec,AnnoDec);
			   commit;
	if comm_emp is null then  
	insert into bonificacion(id_bonificacion,employee_id,bonificacion_type,monto,month,year)
               values (seq_bonifican.nextval,EmpID,'Evaluacion',0.01*salary_emp,monthDec,AnnoDec);

  commit;
end if;
end prc_calc_bonif;
/
show error

create or replace function fun_sum_bonif(PEmpID in number) return number is
  total_bonif number;
begin
  select sum(nvl(d.monto,0))
  into total_bonif
  from bonificacion d
  where d.employee_id = PEmpID;
  return (total_bonif);
end fun_sum_bonif;
/
show error

PROMPT -------> Creando function vista
create or replace view view_info_boni as
select e.employee_id id,e.last_name empleado,e.salary, fun_sum_bonif(e.employee_id) total_boni, (e.salary +  fun_sum_bonif(e.employee_id)) total_pago
from employees e, bonificacion d
where d.employee_id = e.employee_id
group by e.employee_id,e.last_name ,e.salary
order by e.salary desc;

PROMPT --Creando trigger

PROMPT ---> SELECT CANTIDAD DE Bonificaciones

select d.employee_id EMP_ID, count(d.employee_id) CANT_Bonificaciones
from bonificacion d
group by d.employee_id;

exec prc_calc_bonif(168,2018,5,50000,550);
exec prc_calc_bonif(103,2018,5,0,-50);
exec prc_calc_bonif(160,2018,5,10000,125);
exec prc_calc_bonif(105,2018,5,12000);
exec prc_calc_bonif(105,2018,5,12000);


select * from view_info_boni;








