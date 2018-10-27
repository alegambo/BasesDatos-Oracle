conn system/root
spool BorrarCrear.log
drop user prueba cascade;
create user prueba identified by p123;
grant dba to prueba;
spool off
exit