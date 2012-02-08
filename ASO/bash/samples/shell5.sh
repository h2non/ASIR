# Solucion del ejercicio 5
#! /bin/bash

respuesta="s"
while test "$respuesta" = "s" || test "$respuesta" = "S"
do
	clear
	echo "1.- Suma"
	echo
	echo "2.- Resta"
	echo
	echo "3.- Multiplicacion"
	echo
	echo "4.- Division"
	echo
	echo -e "Introduzca una opcion /c"; read opcion
	case $opcion in
		1)
			echo -e "Introduzca operando 1 : \c"; read n1
			echo -e "Introduzca operando 2 : \c"; read n2
			resultado=`expr $n1 + $n2`
			echo -e "\nEl resultado de sumar $n1 y $n2 es igual a : $resultado";;
		2)
			echo -e "Introduzca operando 1 : \c"; read n1
			echo -e "Introduzca operando 2 : \c"; read n2
			resultado=`expr $n1 - $n2`
			echo -e "\nEl resultado de restar $n1 y $n2 es igual a : $resultado";;
		3)
			echo -e "Introduzca operando 1 : \c"; read n1
			echo -e "Introduzca operando 2 : \c"; read n2
			resultado=`expr $n1 \* $n2`
			echo -e "\nEl resultado de multiplicar $n1 y $n2 es igual a : $resultado";;
		4)
			echo -e "Introduzca operando 1 : \c"; read n1
			echo -e "Introduzca operando 2 : \c"; read n2
			resultado=`expr $n1 / $n2`
			resto=`expr $n1 % $n2`
			echo -e "\nEl resultado de dividir $n1 y $n2 es igual a : $resultado"
			echo -e "\nEl resto de dividir $n1 y $n2 es igual a : $resto";;
		*)
			echo -e "\nOpcion incorrecta";;
	esac
	echo -e "\n¿Desea realizar otra operacion?"; read respuesta
done
clear
