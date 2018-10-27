--Nombre Script: 115790444TareaAlejandroGamboa.sql
spool 115790444TareaAlejandroGamboa.log
conn system/root
drop tablespace TB_Agencia1 including contents and datafiles;
CREATE TABLESPACE TB_Agencia1
datafile 'C:\oraclexe\app\oracle\oradata\XE\TB_Agencia1.DBF' 
SIZE  10M REUSE AUTOEXTEND ON;

drop tablespace TB_KEYS including contents and datafiles;
CREATE TABLESPACE TB_KEYS
datafile 'C:\oraclexe\app\oracle\oradata\XE\TB_KEYS.DBF' 
SIZE  10M REUSE AUTOEXTEND ON;

drop user agencia cascade;
create user agencia identified by a123;
grant dba to agencia;
conn agencia/a123

create table Agencia_Venta_Vehiculos(
cedula_juridica number(10) not null,
nombre varchar2(30) not null,
direccion varchar2(30) not null,
telefono number(9) null
) tablespace TB_Agencia1;

create table Vendedor(
id number(10)not null,
ced_Agen number(10),
nombre varchar2(30) not null,
telefono number(10) null,
salario number(10) not null
)tablespace TB_Agencia1;

create table Vehiculo(
numero_placa varchar2(10)not null,
marca varchar2(30) not null,
tipo varchar2(30) null,
modelo varchar2(30) not null,
id_Agencia number(10)
)tablespace TB_Agencia1;

create table Vendedor_Vehiculo(
idVendedor_Vehiculo number(10) not null,
idVendedor number(10),
id_numeroplaca varchar2(10)
)tablespace TB_Agencia1;

alter table Agencia_Venta_Vehiculos add constraint
Agencia_Venta_Vehiculos_pk primary key(cedula_juridica) using index tablespace TB_KEYS;
alter table Vendedor add constraint
Vendedor_pk primary key(id) using index tablespace TB_KEYS;
alter table Vehiculo add constraint
Vehiculo_pk primary key(numero_placa) using index tablespace TB_KEYS;
alter table Vendedor_Vehiculo add constraint
Vendedor_Vehiculo_pk primary key(idVendedor_Vehiculo) using index tablespace TB_KEYS;

alter table Vendedor add constraint
cedAgencia_fk foreign key (ced_Agen) references Agencia_Venta_Vehiculos;
alter table Vehiculo add constraint
idAgencia_fk foreign key (id_Agencia) references Agencia_Venta_Vehiculos;
alter table Vendedor_Vehiculo add constraint
Vendedor_id_fk foreign key (idVendedor) references Vendedor;
alter table Vendedor_Vehiculo add constraint
Vehiculo_id_fk foreign key (id_numeroplaca) references Vehiculo;

insert into Agencia_Venta_Vehiculos(cedula_juridica, nombre, direccion, telefono) 
values (1, 'Grupo Q', 'San Jose', 222223);
insert into Agencia_Venta_Vehiculos(cedula_juridica, nombre, direccion, telefono) 
values (2, 'HONDA FACO', 'La URUCA', 24222243);
insert into Agencia_Venta_Vehiculos(cedula_juridica, nombre, direccion, telefono) 
values (3, 'GRUPO DANISSA', 'HEREDIA', 24222243);
commit;

insert into Vendedor(id, ced_Agen, nombre, telefono,salario) 
values (115790444, 1, 'Alejandro Gamboa', 89940537,800000);
insert into Vendedor(id, ced_Agen, nombre, telefono,salario) 
values (115790445, 1, 'Henry', 89940537,800000);
insert into Vendedor(id, ced_Agen, nombre, telefono,salario) 
values (115794345, 2, 'MARTA', 71346373,700000);
commit;

insert into Vehiculo(numero_placa,marca,tipo,modelo, id_Agencia) 
values ('BX555', 'HONDA', 'MOTOCICLETA','XR',1);
insert into Vehiculo(numero_placa,marca,tipo,modelo, id_Agencia) 
values ('B6555', 'HYUNDAI', 'AUTOMOVIL','ACCENT',1);
insert into Vehiculo(numero_placa,marca,tipo,modelo, id_Agencia) 
values ('C6555', 'Suzuki', 'CUADRACICLO','RSX',2);
commit

insert into Vendedor_Vehiculo(idVendedor_Vehiculo,idVendedor,id_numeroplaca) 
values (1, 115790444, 'BX555');
insert into Vendedor_Vehiculo(idVendedor_Vehiculo,idVendedor,id_numeroplaca) 
values (2, 115790445, 'B6555');
insert into Vendedor_Vehiculo(idVendedor_Vehiculo,idVendedor,id_numeroplaca) 
values (3, 115794345,'C6555');
commit

select * from Agencia_Venta_Vehiculos;
select * from Vendedor;
select * from Vehiculo;
select * from Vendedor_Vehiculo;

spool off;



