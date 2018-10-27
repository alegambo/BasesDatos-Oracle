-- Basado en: start 2018-07-30-roles8pm.sql
-- start alejandro_gamboa_t1.sql
host cls
PROMPT Alejandro Gamboa/BD2
PROMPT Tarea #1 8p.m 
PROMPT Fecha Entrega 06-Agosto-2018
PROMPT ......................................................
PROMPT Nos conectamos como system
PROMPT ......................................................
conn system/root
PROMPT ......................................................
PROMPT Dropeo de 3 usuarios y 3 roles
PROMPT ......................................................
drop user conta cascade;
drop user juan cascade;
drop user pedro cascade;

DROP ROLE R_CREA_TABLA;
DROP ROLE R_CONSULTA;
DROP ROLE  R_ACTUALIZA;


PROMPT ......................................................
PROMPT Creacion de ROLE R_CREA_TABLA,3 usuario
PROMPT  permiso directo de conectarse a pedro y juan
PROMPT ......................................................
CREATE ROLE R_CREA_TABLA;
create user conta identified by conta123;
create user juan identified by juan123;
create user pedro identified by pedro123;
grant create session to juan;
grant create session to pedro;
PROMPT ......................................................
PROMPT Brindar los permisos minimos.
PROMPT Permisos de crear tabla,conectarse,crear procedimientos.
PROMPT Crear vistas,crear rol, cuota, rol a conta.
PROMPT ......................................................

grant create table to R_CREA_TABLA;
grant create session to R_CREA_TABLA;
grant create procedure to R_CREA_TABLA;
grant create any view to R_CREA_TABLA;

grant create role to R_CREA_TABLA;

alter user conta quota unlimited on SYSTEM;
--#1.4
grant R_CREA_TABLA to conta;


PROMPT ......................................................
PROMPT Conexion con usuario CONTA
PROMPT Crea 2 roles
PROMPT ......................................................
conn conta/conta123

create role R_CONSULTA;
create role R_ACTUALIZA;
PROMPT ......................................................
PROMPT Crear tabla Empleado(codigo,nombre,salario) y la PK ambos en TABLESPACE SYSTEM
PROMPT ......................................................
create table empleado(codigo number, nombre varchar2(10),salario number(5))
tablespace SYSTEM;
PROMPT ......................................................
PROMPT Se crea la funcion fun_cant_emp
PROMPT ......................................................

create or replace function fun_cant_emp return number is
  VCant number;
begin
  select count(*) into VCant from empleado;
  return(VCant);
end fun_cant_emp;
/
PROMPT ......................................................
PROMPT Crear Procedimiento prc_act_salario
PROMPT ......................................................
create or replace procedure prc_act_salario(PCod in number, PSalario in number) is
begin
update empleado set salario=PSalario where codigo=PCod;
commit;
end prc_act_salario;
/
PROMPT ......................................................
PROMPT Crear Vista REP_ALTO
PROMPT ......................................................

CREATE VIEW rep_alto AS
   SELECT nombre, salario
   FROM empleado
   WHERE salario > 1000;
 
insert into empleado (codigo,nombre,salario) values (1,'Juan',1000);
insert into empleado (codigo,nombre,salario) values (2,'Ana',2000);
insert into empleado (codigo,nombre,salario) values (3,'Pedro',3000);
commit; 
PROMPT ......................................................
PROMPT Prueba de la funcion cantidad de empleados
PROMPT ......................................................

select fun_cant_emp() cantidad from dual;

PROMPT ......................................................
PROMPT Prueba de la funcion cantidad de empleados
PROMPT ......................................................
grant select on empleado to R_CONSULTA;
grant select on rep_alto to R_CONSULTA;
grant execute on fun_cant_emp to R_CONSULTA;
grant execute on prc_act_salario to R_ACTUALIZA;
grant select on empleado to R_ACTUALIZA;
PROMPT ......................................................
PROMPT Dar Role a Juan y Pedro
PROMPT ......................................................
--#2.5
grant R_CONSULTA to juan;
grant R_ACTUALIZA to pedro;
PROMPT ......................................................
PROMPT Se conecta con Juan, hace pruebas
PROMPT ......................................................
conn juan/juan123
select * from conta.empleado;	
select conta.fun_cant_emp() cantidad from dual;
select *from conta.rep_alto;
PROMPT ......................................................
PROMPT Se conecta con Pedro, hace pruebas
PROMPT ......................................................
conn pedro/pedro123
PROMPT ......................................................
PROMPT Error esperado, no puede actualizar directamente, solo por medio de procedimiento
PROMPT ......................................................
update conta.empleado set salario=1500 where codigo=1;
commit;
PROMPT ......................................................
PROMPT Se ejecuta el procedimiento para actualizar
PROMPT ......................................................
exec conta.prc_act_salario(1,1500);
PROMPT ......................................................
PROMPT Select de la tabla empleado con salario actualizado
PROMPT ......................................................

select * from conta.empleado;


