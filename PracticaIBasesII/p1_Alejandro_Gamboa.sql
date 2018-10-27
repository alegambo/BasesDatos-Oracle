host cls
-- start p1_Alejandro_Gamboa.sql
PROMPT Nombre: Alejandro Gamboa
PROMPT Cedula: 115790444
PROMPT Grupo 8pm
PROMPT 2
conn system/root

drop user compras cascade;
drop user bsoto cascade;
drop user jmendez cascade;
PROMPT 2.a
create user compras identified by 123;
create user bsoto identified by 123;
create user jmendez identified by 123;
PROMPT 2.b
grant create session to compras;
grant create session to bsoto;
grant create session to jmendez;

PROMPT 2.c
grant create table to compras;
grant create procedure to compras;
PROMPT 2.d
alter user compras quota unlimited on SYSTEM;
PROMPT 3
conn compras/123
PROMPT 3.a
create table proveedores(
  id number,
  nombre varchar2(10)
) tablespace SYSTEM;
PROMPT 3.c
create or replace procedure prc_ins_prov(PId in number, PNombre in varchar2) is
begin
insert into proveedores(id,nombre) values (PId, PNombre);
commit;
end prc_ins_prov;
/
PROMPT 3.d
create or replace procedure prc_act_prov(PID in number, PNombre in varchar2) is
  begin
    update proveedores set nombre = PNombre where id = PID;
    commit;
  end prc_act_prov;
/
PROMPT 3.e
create or replace procedure prc_bor_prov(PID in number) is
  begin
    delete proveedores where id = PID;
    commit;
  end prc_bor_prov;
/
PROMPT 3.f
grant execute on prc_ins_prov to bsoto;
PROMPT 6.b
-- grant execute on prc_ins_prov to jmendez;
PROMPT 3.g
grant execute on prc_act_prov to bsoto;
grant execute on prc_act_prov to jmendez;
PROMPT 3.h
grant execute on prc_bor_prov to jmendez;
PROMPT 3.i
grant select on proveedores to bsoto;
grant select on proveedores to jmendez;
PROMPT 4
conn bsoto/123
PROMPT 4.a
execute compras.prc_ins_prov(1,'Bimbo');
PROMPT 4.b
execute compras.prc_ins_prov(2,'Tosty');
PROMPT 4.c
execute compras.prc_act_prov(1,'BIMBO');
PROMPT 4.d
select * from compras.proveedores;
PROMPT 4
conn jmendez/123
PROMPT 4.a
PROMPT 6 El error se genera debido a que el usuario jmendez no tiene permisos para realizar el procedimiento de insertar en la tabla proveedores
PROMPT hace falta agregar que desde el usuario compras este brinde permisos a jmendez para insertar en la tabla
PROMPT esto se realiza haciendo grant execute on prc_ins_prov to jmendez;
execute compras.prc_ins_prov(3,'Jacks');
PROMPT 4.b
execute compras.prc_act_prov(1,'bimbo');
PROMPT 4.c
execute compras.prc_bor_prov(1);
PROMPT 4.d
select * from compras.proveedores;









