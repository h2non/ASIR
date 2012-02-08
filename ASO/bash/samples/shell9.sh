# Solucion del ejercicio 9
#! /bin/bash

if test $# -ne 1; then
	echo "Numero de parametros incorrecto"
elif ! test -f $1; then
	echo "No existe el fichero $1"
else
	if ! test -d $HOME/.papelera; then
		mkdir $HOME/.papelera 2> /dev/null
		if test $? -ne 0; then
			echo "La papelera no pudo crearse. Fin"
			exit
		fi
	fi
	mv $1 $HOME/.papelera
	echo -e "\n$1 ha sido borrado\n"
fi
