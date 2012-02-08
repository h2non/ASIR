@ECHO OFF
rem Fichero : BAT_PROF.BAT

rem Crea un usuario por cada profesor y lo agrega al grupo de profesores

net user %1 %2 /add

net group profesores %1 /add