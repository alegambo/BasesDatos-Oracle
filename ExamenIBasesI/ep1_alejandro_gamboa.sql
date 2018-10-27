--ep1_alejandro_gamboa.sql
host cls
PROMPT Alejandro Gamboa
spool ep1_alejandro_gamboa.log
conn system/root

drop user cobros cascade;

create user cobros identified by c123;

grant dba to cobros;
conn cobros/c123

PROMPT.....................

PROMPT Creacion de Tablas

create table clientes(
id_cl number(4) not null,
nombre varchar2(10) not null,
email varchar2(10)  null,
telefono varchar2(10) null,
limite number(4) not null
) tablespace users;
create table cobros(
id_co number(4) not null,
fec_cob date not null,
monto number(10) not null,
moneda varchar2(10) not  null,
id_cli number(4) not null
) tablespace users;

PROMPT.....................

PROMPT Creacion de las PK

alter table clientes add constraint
clientes_pk primary key (id_cl) using index tablespace users;

alter table cobros add constraint
cobros_pk primary key (id_co) using index tablespace users;

PROMPT.....................

PROMPT Creacion de las FK

alter table cobros add constraint
cobros_fk_clientes foreign key(id_cli) references clientes;

PROMPT.....................

PROMPT Creacion de los CK

alter table cobros  add constraint 
cobros_ck_moneda check (moneda in('Colones','Dolares'));

alter table clientes add constraint 
clientes_ck_limite check (limite >=0);

alter table cobros add constraint 
cobros_ck_monto check (monto >=0);
PROMPT Insert clientes

insert into clientes(id_cl, nombre,email,telefono,limite) 
values (1,'AMAZON',null,4444,8500);
insert into clientes(id_cl, nombre,email,telefono,limite) 
values (2,'GBM','g@gbm.com',null,9000);
insert into clientes(id_cl, nombre,email,telefono,limite) 
values (3,'WISH','O@wish.com',5555,0);
commit;
PROMPT Insert cobros
insert into cobros(id_co, fec_cob,monto,moneda,id_cli) 
values (1,to_date('20-03-2018','dd-mm-yyyy'),500,'Dolares',1);
insert into cobros(id_co, fec_cob,monto,moneda,id_cli) 
values (2,to_date('20-03-2018','dd-mm-yyyy'),100,'Dolares',1);
insert into cobros(id_co, fec_cob,monto,moneda,id_cli) 
values (3,to_date('20-03-2018','dd-mm-yyyy'),300,'Colones',1);
insert into cobros(id_co, fec_cob,monto,moneda,id_cli) 
values (4,to_date('21-03-2018','dd-mm-yyyy'),150,'Dolares',2);
insert into cobros(id_co, fec_cob,monto,moneda,id_cli) 
values (5,to_date('22-03-2018','dd-mm-yyyy'),160,'Colones',2);
commit;
PROMPT.....................

PROMPT Reporte 1

select nombre, nvl(telefono,-1) telefono from clientes where limite >0;
PROMPT.....................

PROMPT Reporte 2
select sum(monto) tot_Dolares from cobros where moneda = 'Dolares';
PROMPT.....................

PROMPT Reporte 3
select d.nombre,m.fec_cob,m.moneda,m.monto
from clientes d,cobros m
where m.id_cli=d.id_cl and m.moneda='Colones'
order by m.monto asc;

spool off;