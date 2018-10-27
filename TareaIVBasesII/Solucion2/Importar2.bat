REM #0 Borrar y Creaer usuario prueba
sqlplus /nolog  @.\Scripts\BorrarCrear.sql

REM #1 desencriptra RUTA y con un nombre indicado hr.7z
aescrypt.exe -d -p clave123 -o ./Datos/hr.7z ./Respaldos/hr(2018-08-30)-(21-05-41).7z.aes 1> ./Logs/1.log 2> ./Logs/1.err

REM #2 descomprime en la carpeta actual
7z.exe x ./Datos/hr.7z 1> ./Logs/2.log 2> ./Logs/2.err

REM #3 Mueve a carpeta datos
move hr.dmp ./Datos/ 1> ./Logs/3.log 2> ./Logs/3.err

REM #4 Import genera propio log
imp parfile=./Parametros/imp-hr.par

REM #5 Concatenar todos los LOGS! (si son pequeños con type) o copy
REM  DOS Formas un solo LOG o uno y renombrar con namedate..
echo Inicio================================================ > ./Bitacoras/Final.log
echo #0 Borrar y Creaer usuario prueba                      >> ./Bitacoras/Final.log
type .\Logs\BorrarCrear.log                                 >> ./Bitacoras/Final.log

echo ______________________________________________________ >> ./Bitacoras/Final.log
echo #1 desencriptra RUTA y con un nombre indicado hr.7z    >> ./Bitacoras/Final.log
echo error:                                                 >> ./Bitacoras/Final.log
type ./Logs/1.err                                           >> ./Bitacoras/Final.log
echo log:                                                   >> ./Bitacoras/Final.log
type ./Logs/1.log                                           >> ./Bitacoras/Final.log

echo ______________________________________________________ >> ./Bitacoras/Final.log
echo #2 descomprime en la carpeta actual                    >> ./Bitacoras/Final.log
echo error:                                                 >> ./Bitacoras/Final.log
type ./Logs/2.err                                           >> ./Bitacoras/Final.log
echo log:                                                   >> ./Bitacoras/Final.log
type ./Logs/2.log                                           >> ./Bitacoras/Final.log

echo ______________________________________________________ >> ./Bitacoras/Final.log
echo #3 Mueve a carpeta datos                               >> ./Bitacoras/Final.log
echo error:                                                 >> ./Bitacoras/Final.log
type ./Logs/3.err                                           >> ./Bitacoras/Final.log
echo log:                                                   >> ./Bitacoras/Final.log
type ./Logs/3.log                                           >> ./Bitacoras/Final.log

echo ______________________________________________________ >> ./Bitacoras/Final.log
echo #4 Import genera propio log                            >> ./Bitacoras/Final.log
type ./Datos/imp-hr.log                                     >> ./Bitacoras/Final.log

echo Final ================================================ >> ./Bitacoras/Final.log


REM #6 Borrar archivos....

REM #7 Abrir con NOTEPAD.EXE












