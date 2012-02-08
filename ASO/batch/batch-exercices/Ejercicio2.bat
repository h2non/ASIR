@ECHO OFF

REM Comprobamos si se han recibido los parametros
IF "%1"=="" GOTO ERROR
IF "%2"=="" GOTO ERROR


IF NOT EXIST %2\nul GOTO ERROR

FOR %%a IN (%2\*.%1) DO call Ejercicio1_bis %%a
GOTO FIN

:ERROR
CLS
ECHO El primer parametro no existe
ECHO o el directorio no existe
ECHO.
PAUSE

:FIN
ECHO ejecucion terminada
