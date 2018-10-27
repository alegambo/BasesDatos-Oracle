--2018-04-12-proc-sec.sql
--Clase #14 Procedimientos y secuencias
host cls
--Copiamos de otros scripts esta parte (reset de clave y desbloqueo de HR)
conn system/root
PROMPT cambiamos clave de hr
alter user hr identified by hr;
PROMPT desbloqueamos hr
alter user hr account unlock;
conn hr/hr
--fin de lo copiado

--ojo recursivo es solo quitar los otros objetos NO TODO el USUARIO HR!
--1 Vistas
--2 Funciones
--3 Procedimientos
--4 Secuencias
--5 Tablas hija
--6 Tablas Padre
drop procedure prc_ins_loan;
drop sequence seq_loan;
drop table hr.payments;
drop table hr.loans;

--prestamos DOS DECIMALES  6,2
create table hr.loans(
loan_id  number(7) not null,
employee_id       number(6) not null,
loan_amount       number(6,2) not null,
loan_balance      number(6,2) not null,
loan_start_date   date   not null,
loan_end_date     date   null,
comments varchar2(100) null
);

create table hr.payments(
loan_id  number(7) not null,
pay_id  number(7) not null,
dateP date    not null,
loan_amount       number(6,2) not null
);
PROMPT PK hr.loans
alter table hr.loans add constraint loans_pk primary key (loan_id);
PROMPT FK hr.loans with hr.employees
alter table hr.loans add constraint loans_fk foreign key (employee_id)
references hr.employees;

PROMPT PK hr.payments
alter table hr.payments add constraint payments_pk primary key (pay_id);
PROMPT FK hr.payments with hr.loans
alter table hr.payments add constraint payments_fk foreign key (loan_id)
references hr.loans;


PROMPT Sequences for loan_id
create sequence seq_loan start with 1 increment by 1;

PROMPT Sequences for pay_id
create sequence seq_pay start with 1 increment by 1;

--if PStartDate is null then the procedure use current date!
PROMPT Store Procedure for inserts loans using sequence.
create or replace procedure prc_ins_loan(PEmpId in number,
PAmount in number, PStartDate in date default sysdate,
PComments in varchar2 default null) is
Ex_Emp  exception;
begin
  if PEmpId is null then
    raise Ex_Emp;
  end if;
  insert into hr.loans (loan_id , employee_id , loan_amount ,
  loan_balance , loan_start_date , loan_end_date , comments )
  values (seq_loan.nextval, PEmpId, PAmount, 
  PAmount, PStartDate, null, PComments);
  commit;
exception
when Ex_Emp then
  raise_application_error(-20001,'Empleado es nulo');
  --si colo null; en la excepcion, ignora el error 
  --y el PRC se ejecuta como "correcto"
  --null;
when others then
  --Muestro mi propio mensaje de error,  -20001, -20002...etc
  raise_application_error(-20001,'Error al Insertar');
end prc_ins_loan;
/
show error
--Usa los default! para los ultims parametros
--Es buena practica, dejarlos campos con default al final!
exec prc_ins_loan(100,1500);
exec prc_ins_loan(101,1400,sysdate-10);
--Falla el valor posicional del parametro
exec prc_ins_loan(102,1500,'Urgent!');
--Hacerlo así (no puedo ponerle null en el sysdate)
--Si no lo paso del todo como parametro es que asume el SYSDATE!
exec prc_ins_loan(102,1500,sysdate,'Urgent!');

--que pasa si invoco el Procedimiento con un empleado incorrecto?
exec prc_ins_loan(90,1500,sysdate,'Test');
--Programen para que se genere un msg 'Error al insertar'

PROMPT inserto null en empleado
exec prc_ins_loan(null,1500,sysdate,'Test 2');
--Programen para que se genere con una excepcion personalizada
--un mensaje que diga EMPLEADO ES NULO, cuando el parametro de empleado sea nulo
COLUMN loan_id format 99
COLUMN employee_id format 999
COLUMN loan_amount format 9999
COLUMN loan_balance format 9999
COLUMN loan_start_date format A8
COLUMN loan_end_date format A8
COLUMN comments format A10
SET LINESIZE 100
SET PAGESIZE 100

select loan_id , employee_id , loan_amount ,
loan_balance , loan_start_date , loan_end_date , comments 
from loans;

