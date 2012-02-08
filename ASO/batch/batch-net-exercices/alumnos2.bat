@echo off

for /f "tokens=1,2,3,4,5,6" %%a in (alumnos.txt) do call bat_alum2 %%a %%b %%c %%d %%e %%f
