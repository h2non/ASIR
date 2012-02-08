Rem recibo %1 como alumno
Rem recibo %2 como passwore
Rem recibo %3, %4 en adelante como asignaturas

SET alumno=%1%
set passwd=%2%

:BUCLE
if "%3"=="" goto :eof
echo %alumno%:%passwd%>>%3%.txt
shift /3
GOTO BUCLE