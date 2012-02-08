# Solucion del ejercicio 11
#! /bin/bash

if test $# -ne 1; then
   echo "Numero de parametros erroneo"
else
   if ! test -d $1; then
      dire=0; fiche=0; total=0
      for i in `ls $1`
      do
         if test -d $1/$i; then
            dire=`expr $dire + 1`
         elif test -f $1/$i; then
            fiche=`expr $fiche + 1`
         fi
         total=`expr $total + 1`
      done
      echo "Numero de ficheros regulares : $fiche"
      echo "Numero de directorios : $dire"
      echo "Numero total de elementos : $total"
   fi
fi
