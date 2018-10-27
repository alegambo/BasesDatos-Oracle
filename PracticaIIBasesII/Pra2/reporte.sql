--Nombre: Alejandro Gamboa Barahona
conn system/root
spool C:\Pra2\Rep.log
select * from &1;
spool off;
exit