# Solucion del ejercicio 10
#! /bin/bash

echo "Indique el numero de mensajes que deseas enviar"
read numero
if test $numero -lt 0; then
   echo $numero no es un numero correcto
else
   while test $numero -gt 0
   do
      echo "Nombre de usuario :"
      read usuario
      echo "Enviando mensaje a usuario $usuario"
      mail $usuario
      numero=`expr $numero - 1`
   done
fi
