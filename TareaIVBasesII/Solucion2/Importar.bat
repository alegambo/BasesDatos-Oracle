REM #0 Borrar y Crear usuario prueba
sqlplus /nolog  @.\Scripts\BorrarCrear.sql

REM #1 desencriptra RUTA y con un nombre indicado hr.7z
aescrypt.exe -d -p clave123 -o .\Datos\hr.7z .\Respaldos\hr(2018-08-30)-(21-05-41).7z.aes

REM descomprime en la carpeta actual
7z.exe x .\Datos\hr.7z

REM Mueve hr.dmp a carpeta datos
move hr.dmp .\Datos\

REM Import
imp parfile=.\Parametros\imp-hr.par
pause