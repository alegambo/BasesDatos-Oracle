--Nombre Script: ALEJANDRO_GAMBOA.sql
spool ALEJANDRO_GAMBOA.log
conn system/root
drop tablespace TB_TABLAS including contents and datafiles;
CREATE TABLESPACE TB_TABLAS
datafile 'C:\oraclexe\app\oracle\oradata\XE\TB_TABLAS.DBF' 
SIZE  5M REUSE AUTOEXTEND OFF;

drop tablespace TB_INDICES including contents and datafiles;
CREATE TABLESPACE TB_INDICES
datafile 'C:\oraclexe\app\oracle\oradata\XE\TB_INDICES.DBF' 
SIZE  10M REUSE AUTOEXTEND OFF;

drop user ventas;
create user ventas identified by v123;
grant dba to ventas;
conn ventas/v123


create table vendedor(
idVendedor number(4) not null,
nombre varchar2(10) not null,
estado number(4) not null,
id_jefe number(4) null,
fecha_des date null
) tablespace TB_TABLAS;
create table comision(
idComision number(4) not null,
nombre varchar2(10) null,
monto varchar2(10) not null
) tablespace TB_TABLAS;
create table historial(
id_vendedor number(4) not null,
id_comision number(4) not null,
montoC varchar2(30) not null,
fecha_com date not null
) tablespace TB_TABLAS;
alter table vendedor add constraint
vendedor_pk primary key(idVendedor) using index tablespace TB_INDICES;
alter table comision add constraint
comision_pk primary key(idComision) using index tablespace TB_INDICES;
alter table historial add constraint
historial_pk primary key(fecha_com) using index tablespace TB_INDICES;

alter table vendedor add constraint
vendedor_jefe_fk foreign key (id_jefe) references vendedor;
alter table historial add constraint
vendedor_fk foreign key (id_vendedor) references vendedor;
alter table historial add constraint
comision_fk foreign key (id_comision) references comision;

insert into vendedor(idVendedor, nombre, estado, id_jefe,fecha_des) 
values (112, 'Juan', 1, NULL,NULL);
insert into vendedor(idVendedor, nombre, estado, id_jefe,fecha_des) 
values (113, 'ANA', 1, 112,NULL);
insert into vendedor(idVendedor, nombre, estado, id_jefe,fecha_des) 
values (114, 'PEDRO', 1, 112,NULL);
insert into vendedor(idVendedor, nombre, estado, id_jefe,fecha_des) 
values (115, 'FLOR', 1, 112,NULL);
Commit;
insert into comision(idComision, nombre, monto) 
values (1, 'EXTRA', 1000);
insert into comision(idComision, nombre, monto) 
values (2, 'BONIFICA','5%' );
COMMIT;
insert into historial(id_vendedor, id_comision, montoC,fecha_com) 
values (112, 1, 1000,'01-02-2018');
insert into historial(id_vendedor, id_comision, montoC,fecha_com) 
values (113, 2, '5%','04-02-2018');
commit;
select * from vendedor;
select * from comision;
select * from historial;
spool off;



