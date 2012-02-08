@ECHO OFF
rem Fichero : BAT_ALUM.BAT

rem Crea un usuario por cada alumno y lo agrega al grupo de la asignatura

net user %1 %2 /add

net group %3 %1 /add