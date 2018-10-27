--Nombre t2_Alejandro_Gamboa.sql
PROMPT Alejandro Gamboa
spool alejandro_gamboa.log

conn system/root
PROMPT cambiamos clave de hr
alter user hr identified by hr;
PROMPT desbloqueamos hr
alter user hr account unlock;
conn hr/hr

PROMPT Primera Parte Operadores
PROMPT Consulta  Operador LIKE
PROMPT Se usa para realizar comparaciones de 2 campos
select country_id id, country_name country_name 
from countries where country_name like 'E%';

PROMPT Consulta Operador ANY
PROMPT Revisa si alguna fila de la lista se encuentra el valor especificado en la condición.
select employee_id id, first_name emp_no, salary sal from employees emp_c1
where salary < any ( select salary from employees emp_c2 where emp_c2.department_id = 50);

PROMPT Consulta Operador <>
PROMPT Selecciona todos los registros distinto a Susan.
select employee_id id, first_name||' '||last_name nom_emp 
from employees where first_name<>'Susan';

PROMPT Consulta Operador UNION
PROMPT Une 2 consultas
select job_id jobs_id from jobs
union
select job_id  from job_history;

PROMPT Consulta Operador DISTINCT
PROMPT Elimina duplicados en el select
select distinct employee_id id, first_name||' '||last_name nom_emp 
from employees;

PROMPT Consulta Operador IN
PROMPT Revisa si se encuentra en la consulta el valor especificado
select first_name||' '||last_name nom_emp, manager_id manager 
from employees where manager_id IN(110);

PROMPT Consulta Operador UNION_ALL
PROMPT Une 2 consultas, manda todo con duplicados
select location_id  from locations 
UNION ALL 
select location_id  from departments;

PROMPT Consulta Operador EXISTS
PROMPT determina si existen datos en la consulta
select job_id id, job_title job from jobs j
 where exists
  (select * from job_history jh 
    where j.job_id = jh.job_id);

PROMPT Consulta Operador MINUS
PROMPT Devuelve los registros que noo coinciden 
select location_id id from locations
minus
select location_id from departments;

PROMPT Consulta Operador INTERSECT
PROMPT 	Interseccion de 2 consultas
select location_id id from locations
intersect
select location_id  id from departments;



PROMPT Parte #2

PROMPT Consulta #1.Los 35 primeros empleados que posee un puesto 'Sales Representative' con una fecha de inicio un 15-01-2000
select first_name||''||last_name nom_emp, job_title job_title, start_date start_date
from employees e, jobs j, job_history jh
where j.job_title='Sales Representative' and jh.start_date=to_date('15-01-2000','dd-mm-yyyy') and rownum < 35;

PROMPT Consulta #2.Los departamentos que tienen puestos de presidentes ubicados en 9702 Chester Road
select job_title job_title, department_name dep_name, street_address st_add
from jobs j,departments d, locations l
where j.job_title='President' and l.street_address='9702 Chester Road';

PROMPT Consulta #3.Los empleados que pertenecen a departamento IT Helpdesk con salario menor a 5000 y que esten en la ciudad Roma
select first_name||''||last_name nom_emp, salary, city city, department_name depart_name
from employees e, departments d, locations l
where d.department_name='IT Helpdesk' and e.salary < 5000 and l.city='Roma';


PROMPT Parte #3 Validación de Funciones de Agregación.


PROMPT Consulta #1 Funcion SUM con un date
PROMPT Esta consulta da error ya que se espera sum solo espera valores numericos
select sum(hire_date) st_date from employees;

PROMPT Consulta #2 Funcion SUM con un number
PROMPT no da error
select sum(salary) min_sal from employees;

PROMPT Consulta #3 Funcion AVG con un number
PROMPT no da error
select avg(salary) min_sal from employees;


PROMPT Consulta #4 Funcion MAX con un varchar32
PROMPT no da error
select max(last_name) last_name from employees;

PROMPT Consulta #5 Funcion MAX con un date
PROMPT no da error
select max(hire_date) st_date from employees;

PROMPT Consulta #6 Funcion SUM con un varchar32
PROMPT Da error porque es invalido
select sum(last_name) last_name from employees;

PROMPT Consulta #7 Funcion MAX con un number
PROMPT no da error
select max(salary) min_sal from employees;

PROMPT Consulta #8 Funcion MIN con un varchar32
PROMPT no da error
select min(last_name) last_name from employees;

PROMPT Consulta #9 Funcion MIN con un date
PROMPT no da error
select min(hire_date) st_date from employees;

PROMPT Consulta #10 Funcion AVG con un varchar32
PROMPT Esta consulta da error porque es un valor invalido
select avg(last_name) last_name from employees;

PROMPT Consulta #11 Funcion AVG con un date
PROMPT Esta da error  ya que se espera un dato tipo NUMBER y se puso un dato tipo DATE
select avg(hire_date) st_date from employees;


PROMPT Consulta #12 Funcion COUNT con un varchar32
PROMPT no da error
select count(last_name) last_name from employees;

PROMPT Consulta #13 Funcion COUNT con un date
PROMPT no da error
select count(hire_date) st_date from employees;

PROMPT Consulta #14 Funcion COUNT con un number
PROMPT no da error
select count(salary) min_sal from employees;

PROMPT Consulta #15 Funcion MIN con un number
PROMPT no da error
select sum(salary) min_sal from employees;


spool off;