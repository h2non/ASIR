@echo off

set /p num1=Cual es el primer numero?

set /p num2=Cual es el segundo numero?

set /a media= (%num1% + %num2%) / 2

echo.

echo La media es %media%