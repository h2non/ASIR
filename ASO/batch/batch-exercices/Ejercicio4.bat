@echo off

if "%1"=="" goto :error
if "%2"=="" goto :error

if not exist %1\nul goto :error2

rem para analizar si existe el directorio destino
if exist %2\nul goto :copiar

echo Error. El directorio destino no existe

:nuevo
set /p seguir="deseas crear el directorio destino (s/n)"
if "%seguir%"=="s" goto :crear
if "%seguir%"=="n" goto :nocrear
goto :nuevo

rem En este punto creamos el directorio destino y nos vamos a realizar la copia de archivos
rem y procedemos a crear el directorio en cuestión.

:crear
md %2
goto :copiar

rem En este punto indicamos que no hemos querido crear el directorio destino, visualizamos
rem el contenido de los directorios y ejecutamos el programa de imprimir ficheros de origen

:nocrear
Echo La copia no se ha realizado.
echo %1
echo %2
goto :fin 

rem En esta parte realizamos la copia propuesta en el primer punto

:copiar
copy %1\FICH*.??T %2
Echo Operación realizada con éxito
goto :fin

:error
echo Faltan parametros
goto :fin

:error2
echo El directorio origen no existe
	
:fin
