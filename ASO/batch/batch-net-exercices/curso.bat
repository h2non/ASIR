@ECHO OFF

rem Fichero : CURSO.BAT

rem Crea el grupo profesores y la carpeta del grupo
rem Comparte la carpeta
rem Asigna permisos totales al Administrador y profesores, quitando los que hubiese

net group profesores /add

md C:\CURSO
net share CURSO=C:\CURSO

CACLS C:\CURSO /g Administrador:F profesores:F < resp.txt

rem Lee el fichero de profesores y llama al BAT de profesores

ECHO Procesando profesores...

for /f "tokens=1,2" %%i in (profesores.txt) do call bat_prof %%i %%j

rem Lee el fichero de asiganturas y llama al BAT de asignaturas

ECHO Procesando asignaturas...

for /f "tokens=1,2" %%i in (asignaturas.txt) do call bat_asig %%i %%j

ECHO --- Trabajo finalizado ---

Pause