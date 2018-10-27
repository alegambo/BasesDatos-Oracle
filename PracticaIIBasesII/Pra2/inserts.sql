--Nombre: Alejandro Gamboa Barahona
conn system/root
insert into &1 (&2) values ('&3');
insert into &1 (&2) values ('&4');
insert into &1 (&2) values ('&5');
commit;
exit