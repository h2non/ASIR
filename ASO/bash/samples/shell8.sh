# Solucion del ejercicio 8
#! /bin/bash

contador=0
total=0
for i in `ls`
do
	total=`expr $total + 1`
done
if test $total -eq 0; then
	clear
	echo "Este directorio no tiene ningun contenido"
	exit
fi
for i in `ls`
do
	contador=`expr $contador + 1`
	clear
	if test -f $i; then
		echo -e "\nContenido del archivo ********** $i **********\n"
		cat $i
		echo -e "\nFin del archivo ********** $i **********\n"
	elif test -d $i; then
		echo -e "\nContenido del directorio ********** $i **********\n"
		ls -l $i
		echo -e "\nFin del directorio ********** $i **********"
	else
		echo -e "\n**** $i no es un fichero ni directorio ****\n"
	fi
	if ! test $contador -eq $total; then
		echo -e "\nPulse una tecla para continuar: \c"; read tecla
		if test "$tecla" = "q"; then
			exit
		fi
	fi
done
echo "He llegado hasta aqui" # Simplemente para probar un break en vez de un exit
