@ECHO OFF

rem Fichero : ALUMNOS.BAT

rem Crea el grupo con el nombre de la asignatura proporcionado como primer parámetro
rem Asigna permisos de "cambio" al grupo de la asignatura sobre su carpeta

net group %1 /add

CACLS C:\CURSO\%1 /E /g %1:C

rem Lee el fichero txt (dado por el segundo parámetro) de los alumnos matriculados en la asignatura
rem y llama al BAT bat_asig.bat

ECHO Procesando alumnos...

for /f "tokens=1,2" %%i in (%2) do call bat_alum %%i %%j %1

ECHO --- Trabajo finalizado ---
Pause