-- start prac2_Alejandro_Gamboa.sql
-- Alejandro_Gamboa
-- 115790444,  Grupo 8:00 pm

host cls

conn system/root

drop user veterinaria cascade;
create user veterinaria identified by v123;
grant dba to veterinaria;

conn veterinaria/v123
PROMPT ***********************************
PROMPT Dropeo de objetos
PROMPT ***********************************
PROMPT creacion de tablas
create table Mascota (
id_mascota	 number(2) not null,
apodo    	 varchar2(10) not null,
tipo		 varchar2(10) not null
);
create table Citas (
id_cita 	 number(2)     not null,
id_mascota   number(2) not null,
precio_tot    number(4) not null
);

create table mascota_bit(
id_mascota_bit   number(2),
 id_mascota    number(2),
apodo       varchar2(10), 
tipo      varchar2(10),
accion         varchar2(1),
fec_accion     timestamp, 
usu_accion     varchar2(20)
);

PROMPT ++++++++++++++++++++++++++++++
PROMPT Creacion de PK y FKs

alter table Mascota add constraint mascota_pk primary key (id_mascota);
alter table Citas add constraint citas_pk primary key (id_cita);

alter table Citas add constraint
citas_fk foreign key (id_mascota) references Mascota;

PROMPT ++++++++++++++++++++++++++++++
PROMPT  Creacion de Sequens

create sequence sec_masco start with 1 increment by 1;
create sequence sec_mascobit start with 1 increment by 1;
create sequence sec_cita start with 1 increment by 1;
PROMPT ++++++++++++++++++++++++++++++
PROMPT  Creacion de 4 triggers. 2 de validacion y de sustitucion(en insert y update)
create or replace trigger
citas_trg_bir before insert on Citas
referencing old as old new as new
for each row
begin
  if :new.precio_tot < 0 then
    raise_application_error(-20001,
    'El monto no puede ser negativo en insert');
  end if;
end citas_trg_bir;
/
show error

create or replace trigger
citas_trg_bur before update on Citas
referencing old as old new as new
for each row
begin
  if 
  :new.precio_tot < 0 then
    raise_application_error(-20001,
    'El monto no puede ser negativo en update');
  end if;
end citas_trg_bur;
/
show error

create or replace trigger
mascota_trg_bir before insert on Mascota
referencing old as old new as new
for each row
begin
  --sustituye y coloca el nombre siempre en mayuscula
  :new.apodo := upper(:new.apodo);
end mascota_trg_bir;
/
show error

create or replace trigger
mascota_trg_bur before update on Mascota
referencing old as old new as new
for each row
begin
  --sustituye y coloca el nombre siempre en mayuscula
  :new.apodo := upper(:new.apodo);
end mascota_trg_bur;
/
show error
PROMPT ++++++++++++++++++++++++++++++
PROMPT  Creacion de 3 triggers de bitacoras. insert delete update

create or replace trigger mascota_trg_air AFTER INSERT on Mascota REFERENCING OLD AS OLD  NEW AS NEW FOR EACH ROW
BEGIN
  insert into  mascota_bit(id_mascota_bit, 
  id_mascota , apodo ,
  tipo, accion, fec_accion , 
  usu_accion ) values (sec_mascobit.nextval,:NEW.id_mascota,  :NEW.apodo,   :NEW.tipo ,
  'I', CURRENT_TIMESTAMP, user);
END mascota_trg_air;
/
show error


create or replace trigger mascota_trg_adr AFTER DELETE on Mascota REFERENCING OLD AS OLD  NEW AS NEW FOR EACH ROW
BEGIN
  insert into mascota_bit(id_mascota_bit, 
  id_mascota , apodo , tipo, accion, fec_accion , 
  usu_accion ) values (sec_mascobit.nextval,   :OLD.id_mascota,   :OLD.apodo ,
 :OLD.tipo,'D', CURRENT_TIMESTAMP, user);
END mascota_trg_adr;
/
show error


create or replace trigger mascota_trg_aur AFTER UPDATE on Mascota REFERENCING OLD AS OLD  NEW AS NEW FOR EACH ROW
BEGIN
  insert into mascota_bit(id_mascota_bit, 
  id_mascota,
  apodo ,tipo, accion, fec_accion , 
  usu_accion ) values (sec_mascobit.nextval,:OLD.id_mascota , :OLD.apodo,
  :OLD.tipo,'U', CURRENT_TIMESTAMP, user);
END mascota_trg_aur;
/
show error
PROMPT ++++++++++++++++++++++++++++++
PROMPT  Inserts directos de mascota

insert into Mascota(id_mascota,apodo,tipo) values(sec_masco.nextval,'puppy','Perro');
insert into Mascota(id_mascota,apodo,tipo) values(sec_masco.nextval,'bunny','Conejo');
insert into Mascota(id_mascota,apodo,tipo) values(sec_masco.nextval,'cowy','Vaca');
insert into Mascota(id_mascota,apodo,tipo) values(sec_masco.nextval,'kitty','Gato');
commit;
select *from Mascota;
PROMPT ++++++++++++++++++++++++++++++
PROMPT  Inserts directos de citas
insert into Citas(id_cita,id_mascota,precio_tot) values(sec_cita.nextval,3,100);
insert into Citas(id_cita,id_mascota,precio_tot) values(sec_cita.nextval,3,150);
insert into Citas(id_cita,id_mascota,precio_tot) values(sec_cita.nextval,3,120);
insert into Citas(id_cita,id_mascota,precio_tot) values(sec_cita.nextval,1,110);
insert into Citas(id_cita,id_mascota,precio_tot) values(sec_cita.nextval,1,130);
commit;
select *from Citas;
PROMPT ++++++++++++++++++++++++++++++
PROMPT  Error esperado 1 de insert cita en negativo
insert into Citas(id_cita,id_mascota,precio_tot) values(sec_cita.nextval,1,-110);
commit;
PROMPT ++++++++++++++++++++++++++++++
PROMPT  Error esperado 2 de no se permite update cita en negativo
update Citas set precio_tot=-110
where id_cita=1;
PROMPT ++++++++++++++++++++++++++++++
PROMPT  los datos de tabla Citas no cambian
select *from Citas;

PROMPT ++++++++++++++++++++++++++++++
PROMPT  Reemplazo 1 actualizo apodo
update Mascota set apodo='fido'
where id_mascota=1;
PROMPT +++++++++++
select *from Mascota;

PROMPT ++++++++++++++++++++++++++++++
PROMPT  Prueba de delete
delete Mascota where id_mascota=2;
commit;
set linesize 100
set pagesize 100

COLUMN id_mascota_bit    format 999
COLUMN apodo    format A7
COLUMN tipo   format A7
COLUMN usu_accion   format A10
COLUMN accion        format A2
COLUMN fec_accion        format A28

select *from mascota_bit;
 






