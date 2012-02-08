@echo off

set /p nombre=Escribe tu nombre y oprime Enter.

set /p apellido=Escribe tu primer apellido?

set /p apellido2=Escribe tu segundo apellido?

echo.

echo Tu nombre completo es %nombre% %apellido% %apellido2%

echo %nombre% %apellido% %apellido2% >> agenda.txt