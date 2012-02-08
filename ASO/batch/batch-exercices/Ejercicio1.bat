@ECHO OFF

REM Comprobamos si se ha recibido el parámetro 
IF "%1"=="" GOTO ERROR


FOR %%a IN (*.%1) DO CALL Ejercicio1_bis %%a
GOTO FIN

:ERROR
CLS
ECHO El primer parametro no existe
ECHO.
PAUSE

:FIN
ECHO ejecucion terminada
