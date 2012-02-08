# Solucion del ejercicio 12
#! /bin/bash

clear
echo "################   AGENDA #####################"
echo "#1.- ANADIR"
echo "#2.- BUSCAR"
echo "#3.- LISTAR"
echo "#4.- ORDENAR"
echo "#5.- BORRAR"
echo .
echo "Introduzca una opcion"
read opcion
case $opcion in
1) echo -e "Nombre : \c"; read nombre
   echo -e "Telefono : \c"; read telefono
   echo -e "$nombre \t $telefono" >> agenda
   echo "Entrada anadida";;
2) if ! test -f agenda; then
      echo "No existe la agenda"
   else
      echo "#1.- Nombre"
      echo "#2.- Telefono"
      echo -e "Elija una opcion \c"; read otra
      case $otra in
      1) echo -e "introduzca nombre : \c"; read busqueda
         grep $busqueda agenda;;
      2) echo -e "introduzca telefono : \c"; read busqueda
         grep $busqueda agenda;;
      *) echo "Opcion no valida";;
      esac
   fi;;
3) if ! test -f agenda; then
      echo "No existe la agenda"
   else
      cat agenda
   fi;;
4) if ! test -f agenda; then
      echo "No existe la agenda"
   else
      sort agenda
   fi;;
5) if ! test -f agenda; then
      echo "No existe la agenda"
   else
      rm agenda
   fi;;
*) echo "Opcion incorrecta";;
esac
