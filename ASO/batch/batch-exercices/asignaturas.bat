@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM compramos el parametro uno
if "%1"=="" goto error
REM comprobamos que el fichero existe
if not exist "%1" goto error
REM comprobamos el parametro dos
REM if not "%2"=="" goto error

rem pretendo pasar como parámetros al siguiente bat alumno, contraseña y asignaturas como un solo parámetro
for /f "tokens=1-3* delims=:" %%i in (%1) do call bat_asignatura %%i %%j %%k
goto FIN

:ERROR
echo No has introducido la base de datos
echo O has puestos demasiados parametros

:FIN
ECHO SE ACABO EL SCRIPT