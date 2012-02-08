@ECHO OFF

IF "%1"=="" GOTO ERROR
IF EXIST Ejercicio3.tmp DEL Ejercicio3.tmp

FOR %%a IN (*.%1) DO CALL Ejercicio3_bis %%a

ECHO FICHEROS MOSTRADOS

TYPE Ejercicio3.tmp

GOTO FIN

:ERROR
CLS
ECHO La extensión no existe
ECHO.
PAUSE

:FIN
ECHO ejecucion terminada
