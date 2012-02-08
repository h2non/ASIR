# Solución al ejercicio 1 de programación shell
#! /bin/bash

for i in `ls *.txt`
do
	if test -f $i
	then
		if ! test -d "copias"
		then
			mkdir copias
			echo "El directorio copias no existe y se crea"
		fi
		mv $i copias
		if test $? = 0
		then
			echo "$i ha sido movido a la carpeta copias"
		fi
	else
		echo "$i no es un fichero"
	fi
done
