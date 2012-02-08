@ECHO OFF

rem Fichero : BAT_ALUM.BAT

rem Crea un usuario por cada alumno

net user %1 %2 /add

set usuario=%1

shift
shift

rem Para cada uno de los grupos se crean

:comienzo

if "%1"=="" goto :EOF

net group %1 /add
cacls C:\CURSO\%1 /E /g %1:C
net group %1 %usuario% /add

shift
goto comienzo
