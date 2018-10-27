PROMPT Alejandro Gamboa
host cls
conn system/root
PROMPT Cambiamos clave de hr
alter user hr identified by hr;
PROMPT Desbloqueamos hr
alter user hr account unlock;
conn hr/hr
PROMPT Drops
drop procedure prc_calc_ded;
drop sequence seq_deduction;
drop table deducciones;

PROMPT se crea tabla de deducciones

create table deducciones(
deduccion_id number(4) not null,
employee_id number(6) not null,
deduccion_tipo varchar2(15) not null,
monto number(8,2)  null,
mes number(2) not null,
ano number(4) not null,
pension number(6) null
);

PROMPT se crea PK,UK,FK,CK

alter table deducciones add constraint
deduccion_pk primary key (deduccion_id);

alter table deducciones add constraint
deducc_employee_fk foreign key (employee_id) references employees;

alter table deducciones add constraint
deducccion_tipo_ck check (deduccion_tipo in ('CCSS','Banco Popular','Imp. Renta','Pension'));

create unique index uk_emp_ano_mes on deducciones (employee_id,deduccion_tipo,mes,ano);

create sequence seq_deduction start with 1 increment by 1;

create or replace procedure prc_calc_ded(EmpID in number, AnoDec in number,
mesDec in number, montoP in number default null) is
salary_emp number;
Exc_pension exception;
begin
  if montoP < 0 then
    raise Exc_pension;
  end if;
  select salary into salary_emp from employees where employee_id = EmpID;
  insert into deducciones(deduccion_id,employee_id,deduccion_tipo,monto,mes,ano,pension)
               values (seq_deduction.nextval,EmpID,'CCSS',salary_emp*0.055,mesDec,AnoDec,montoP);
  insert into deducciones(deduccion_id,employee_id,deduccion_tipo,monto,mes,ano,pension)
               values (seq_deduction.nextval,EmpID,'Banco Popular',salary_emp*0.01,mesDec,AnoDec,montoP);
  if salary_emp > 5000 then
    insert into deducciones(deduccion_id,employee_id,deduccion_tipo,monto,mes,ano,pension)
                 values (seq_deduction.nextval,EmpID,'Imp. Renta',salary_emp*0.03,mesDec,AnoDec,montoP);
  end if;
  commit;
exception
  when Exc_pension then
    raise_application_error(-20001,'Error Monto de pension menor a 0');
end prc_calc_ded;
/
show error

PROMPT Se crea la funcion suma deducciones

create or replace function fun_sum_deduc(EmID in number) return number is
  monto_total number;
begin
  select sum(nvl(d.monto,0))
  into monto_total
  from deducciones d
  where d.employee_id = EmID;
  return (monto_total);
end fun_sum_deduc;
/
show error

PROMPT Se crea la vista
create or replace view vista_deduc as
select e.employee_id id,e.first_name ||' '|| e.last_name empleado,e.salary, fun_sum_deduc(e.employee_id) total_dec, (e.salary - fun_sum_deduc(e.employee_id)) total_pago
from employees e, deducciones d
where d.employee_id = e.employee_id
group by e.employee_id,e.first_name ,e.last_name ,e.salary
order by e.last_name desc;

PROMPT Se crea el Trigger
create or replace function fun_sal_emp(PEmpID in number) return number is
  sal number;
begin
  select salary
  into sal
  from employees d
  where d.employee_id = PEmpID;
  return (sal);
end fun_sal_emp;
/
show error

create trigger deducc_trg_bir
before insert on deducciones
referencing old as old new as new for each row
begin
  if fun_sal_emp(:new.employee_id) < 3000 and :new.monto > 400 then
    :new.monto := 400;
  end if;
end deducc_trg_bir;
/
PROMPT --> EJECUTANDO PROCEDIMIENTO PLANILLA
PROMPT --> #1 CALCULA OMITE EL MONTO DE -$100 Y NO REGISTRA
exec prc_calc_ded(202,2018,5,0);
PROMPT --> #2 CALCULA EL MONTO DE PENSION QUEDA EN $600
exec prc_calc_ded(205,2018,5,600);
PROMPT --> #3 CALCULA EL MONTO QUEDA EN $600 POR TRIGGER
exec prc_calc_ded(132,2018,5,500);
PROMPT --> #4 SE REGISTRA NO RECIBE PENSION
exec prc_calc_ded(139,2018,5);
PROMPT --> #5 ERROR DE PK, UK POR RESTRICCION
exec prc_calc_ded(139,2018,5);

PROMPT SELECT Total deducciones

select d.employee_id EMP_ID, count(d.employee_id) CANT_DEDUC
from deducciones d
group by d.employee_id;

PROMPT Se imprime la vista con Formato

COLUMN ID format 99,999.00
COLUMN EMPLEADO format 99,999.00
COLUMN SALARY format 99,999.00
COLUMN TOTAL_DEC format 99,999.00
COLUMN TOTAL_PAGO format 99,999.00
select * from vista_deduc;

