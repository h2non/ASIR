#Solucion del ejercicio 6
#! /bin/bash

respuesta="s"
while test "$respuesta" = "s" || test "$respuesta" = "S"
do
	echo -e "Introduzca nombre del fichero a copiar : \c "; read nombre
	if ! test -f $nombre; then
		echo "$nombre no es un fichero. Copia cancelada"
	else
		echo -e "Introduzca el nombre de la copia : \c"; read copia
		if test -f $copia; then
			echo "El fichero ya existe. Copia cancelada"
		else
			cp $nombre $copia
			echo
			echo "Se copio el fichero $nombre con el nombre $copia"
		fi
	fi
	echo -e "\n¿Desea realizar otra copia? \c"; read respuesta
done
