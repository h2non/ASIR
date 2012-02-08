@ECHO OFF

REM Buscamos la información en el comando ipconfig

for /F "tokens=13 delims=: " %%x in ('ipconfig ^| find "IP"') do ( 
	REM mostramos la información
	echo.
	echo Tu dirección IP es ... %%x
)

