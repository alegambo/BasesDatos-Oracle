REM Alejandro Gamboa Barahona
@ECHO off
cls
set Palabra1=
set /p Palabra1=Indique el nombre de la tabla:

set Palabra2=
set /p Palabra2=Indique el nombre del campo:

sqlplus /nolog @.\NomTabNomCam.sql %Palabra1% %Palabra2%

set Palabra3=
set /p Palabra3=Indique el primer insert:

set Palabra4=
set /p Palabra4=Indique el segundo insert:

set Palabra5=
set /p Palabra5=Indique el tercer insert:

sqlplus /nolog @.\inserts.sql %Palabra1% %Palabra2% %Palabra3% %Palabra4% %Palabra5%

del *.log


sqlplus /nolog @.\reporte.sql %Palabra1%



start notepad.exe .\Rep.log






