#! /bin/bash
# Solución del ejercicio 2

if test $# -le 1; then
	echo "Faltan parametros"
elif test $# -gt 2; then
	echo "Sobran parametros"
else
	variable=$1
	case $variable in 
	t|T) if test -f $2; then
		echo "****************** Fichero : $2 *****************"
		echo
		cat $2
		echo
		echo "****************** FIN DEL FICHERO **************"
		else
		echo "el fichero $2 no existe"
		fi;;
	d|D) if test -f $2; then
		rm $2
		echo "$2 : Fichero borrado"
		else
		echo "el fichero $2 no existe"
		fi;;
	*) echo "Opcion no disponible";;
	esac
fi

