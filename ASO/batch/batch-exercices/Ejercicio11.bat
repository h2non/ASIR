@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

REM establecemos para parte correspondiente a la red de una dirección ip

SET RED=%1

REM Utilizamos la forma del for que equivale a un típico bucle por contador

if exist encontradas.txt del encontradas.txt
@echo Direcciones ENCONTRADAS:  > encontradas.txt

FOR  /L  %%H IN (1, 1, 254) DO ( 
	echo.
	echo Probando %RED%.%%H
	echo.
	for /F "tokens=7" %%r in ('ping -n 1 %RED%.%%H ^| FIND "recibidos ="') DO ( 		
		if "%%r"=="1," (
			echo "Direccion encontrada"
			@echo %RED%.%%H >> encontradas.txt
		) ELSE (echo "Direccion no existente")
	)
)

CLS
TYPE encontradas.txt
