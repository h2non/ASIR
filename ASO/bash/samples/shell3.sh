#! /bin/bash
# Solución del ejercicio 3

if test $# -le 1; then
	echo "Faltan parametros"
else
	variable=$1
	shift
	case $variable in 
	t|T) for i in $*
	     do
		if test -f $i; then
			echo "****************** Fichero : $i *****************"
			echo
			cat $i
			echo
			echo "****************** FIN DEL FICHERO **************"
		else
			echo
			echo "el fichero $i no existe"
			echo
		fi
	     done;;
	d|D) for i in $*
	     do
		if test -f $i; then
			rm $i
			echo "$i : Fichero borrado"
			echo
		else
			echo "el fichero $i no existe"
			echo
		fi
	     done;;
	*) echo "Opcion no disponible";;
	esac
fi

