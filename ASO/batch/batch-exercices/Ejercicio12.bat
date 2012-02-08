@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

REM inicializamos una variable contador

set contador=0

REM Recorremos el fichero e incrementamos el contador

for /F "tokens=*" %%m in (%1) do set /a contador=!contador! + 1

REM Mostramos el resultado

echo El fichero %1 tiene %contador% líneas

