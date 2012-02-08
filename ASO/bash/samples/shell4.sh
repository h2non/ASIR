#! /bin/bash
# Solución del ejercicio 4

if test $# -gt 1; then
	echo "Numero de parametros incorrecto"
elif test $# -eq 0; then
	recursivo="no"
elif test "$1" = "-r"; then
	recursivo="si"
else
	echo "Ojo ! Si hay un parámetro debe ser -r"
	exit
fi
clear
echo "*********************************** MENU ***************************************"
echo "**                                                                            **"
echo "**  1.- Ordenar el listado detallado por fecha no mostrando ocultos           **"
echo "**                                                                            **"
echo "**  2.- Ordenar el listado detallado por fecha mostrando ocultos              **"
echo "**                                                                            **"
echo "**  3.- Salir                                                                 **"
echo "**                                                                            **"
echo "********************************************************************************"
echo

read opcion

case $opcion in
1) if test "$recursivo" = "si"; then
	clear
	ls -Rtl
   else
	clear
	ls -tl
   fi;;

2) if test "$recursivo" = "si"; then
	clear
	ls -Rtal
   else
	clear
	ls -tal
   fi;;

3) clear
   echo "Fin !!!";;

*)  clear
    echo "Opcion erronea";;

esac
