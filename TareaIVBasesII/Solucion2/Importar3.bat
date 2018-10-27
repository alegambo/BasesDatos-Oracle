

REM #0 Borrar y Creaer usuario prueba
sqlplus /nolog  @.\Scripts\BorrarCrear.sql

REM #0 Borrar y Creaer usuario prueba
sqlplus /nolog  @.\Scripts\BorrarCrear.sql

REM #1 desencriptra RUTA y con un nombre indicado hr.7z
aescrypt.exe -d -p clave123 -o .\Datos\hr.7z .\Respaldos\hr(2018-08-30)-(21-05-41).7z.aes 1> 1.log 2> 1.err

REM #2 descomprime en la carpeta actual
7z.exe x .\Datos\hr.7z 1> 2.log 2> 2.err

REM #3 Mueve a carpeta datos
move hr.dmp .\Datos\ 1> 3.log 2> 3.err

REM #4 Import genera propio log
imp parfile=.\Parametros\imp-hr.par

REM #5 Concatenar todos los LOGS! (si son pequeños con type) o copy
REM  DOS Formas un solo LOG o uno y renombrar con namedate..
echo Inicio================================================ > .\Bitacoras\Final.log
echo #0 Borrar y Creaer usuario prueba                      >> .\Bitacoras\Final.log
type BorrarCrear.log                                        >> .\Bitacoras\Final.log

echo ______________________________________________________ >> .\Bitacoras\Final.log
echo #1 desencriptra RUTA y con un nombre indicado hr.7z    >> .\Bitacoras\Final.log
echo error:                                                 >> .\Bitacoras\Final.log
type 1.err                                                  >> .\Bitacoras\Final.log
echo log:                                                   >> .\Bitacoras\Final.log
type 1.log                                                  >> .\Bitacoras\Final.log

echo ______________________________________________________ >> .\Bitacoras\Final.log
echo #2 descomprime en la carpeta actual                    >> .\Bitacoras\Final.log
echo error:                                                 >> .\Bitacoras\Final.log
type 2.err                                                  >> .\Bitacoras\Final.log
echo log:                                                   >> .\Bitacoras\Final.log
type 2.log                                                  >> .\Bitacoras\Final.log

echo ______________________________________________________ >> .\Bitacoras\Final.log
echo #3 Mueve a carpeta datos                               >> .\Bitacoras\Final.log
echo error:                                                 >> .\Bitacoras\Final.log
type 3.err                                                  >> .\Bitacoras\Final.log
echo log:                                                   >> .\Bitacoras\Final.log
type 3.log                                                  >> .\Bitacoras\Final.log

echo ______________________________________________________ >> .\Bitacoras\Final.log
echo #4 Import genera propio log                            >> .\Bitacoras\Final.log
type imp-hr.log                                             >> .\Bitacoras\Final.log

echo Final ================================================ >> .\Bitacoras\Final.log


del .\Datos\hr.7z
del .\Datos\hr.dmp
del *.err
del *.log


.\namedate.exe /Y /ZZ:"F(Y-m-d)-(H-M-S).X" .\Bitacoras\Final.log

dir /b .\Bitacoras\*.log > Final.ini

type Final.ini | find /v /c "">NumLineaALeer.txt

echo off
(
set /p Var1=

) < .\NumLineaALeer.txt
SET VVar1=%Var1:~0,100%

FIND /N /V "" Final.ini | FIND "[%VVar1%]">LineaALeer.txt
echo off
(
set /p Variable1=

) < .\LineaALeer.txt
SET VVariable1=%Variable1:~3,100%

start notepad.exe .\Bitacoras\%VVariable1%

REM del .\NumLineaALeer.txt

REM del .\LineaALeer.txt









REM #6 Borrar archivos.... aplicar NAMEDATE al Final.log



REM #7 Abrir con NOTEPAD.EXE












