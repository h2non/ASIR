@ECHO OFF
REM Ejercicio 1 Tema 6 - Programacion Batch
REM @author Tomas Aparicio
REM @date 17/01/2012

if "%1"=="" (
	goto :error
) else (
	IF EXIST "%1" (
		echo Comprobando "%1"
		chkdsk /F /I /C "%1"
		echo Desgragmentando "%1"
		defrag "%1"
	) else ( goto :error2 )
)

if "%2"!="" (
	IF EXIST "%2" (
		echo Comprobando "%2"
		chkdsk /F /I /C "%2"
		echo Desgragmentando "%2"
		defrag "%2"
	) else ( goto :error2 )
)

if "%3"!="" (
	IF EXIST "%3" (
		echo Comprobando "%3"
		chkdsk /F /I /C "%3"
		echo Desgragmentando "%3"
		defrag "%3"
	) else ( goto :error2 )
)

if "%4"!="" (
	IF EXIST "%4" (
		echo Comprobando "%4"
		chkdsk /F /I /C "%4"
		echo Desgragmentando "%4"
		defrag "%4"
	) else ( goto :error2 )
)  

:error
echo Faltan parametros. Define las unidadades a desgragmentar como 'C:', 'D:'...
goto :fin

:error2
echo La unidad introducida no existe...
goto :fin

:fin