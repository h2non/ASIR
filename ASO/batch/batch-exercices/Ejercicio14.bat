@ECHO OFF

REM buscamos todos los ficheros que tengan extension .bat
REM cambiamos el nombre del fichero

CD %1
FOR %%A IN (*.bat) DO (
 for /f "tokens=2-4 delims=/ " %%W in ("%date%") do ren %%A %%Y%%X%%W-%%A 
)