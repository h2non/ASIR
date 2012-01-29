/* 
 * @description Some MySQL exercises. Set 2
 * @author Tomas Aparicio <tomas@rijndael-project.com>
 * @license MIT License <http://www.opensource.org/licenses/mit-license.php>
 * @date 16/01/2012
 */

/* 
 * 4.1 Crear una función que devuelva 1 ó 0 si un número de divisible o no por otro
 */
DELIMITER $$
DROP FUNCTION IF EXISTS divisible$$
CREATE FUNCTION divisible (num1 INTEGER, num2 INTEGER)
    RETURNS VARCHAR(50)
BEGIN
    DECLARE divisible VARCHAR(100);
    IF num1 > 0 AND num2 > 0 THEN
        /* verificamos si es divisible */
        IF MOD(num1,num2) = 0 THEN
            /* ES DIVISIBLE */
            SET divisible = 1;
        ELSE
            /* NO ES DIVISIBLE */
            SET divisible = 0;
        END IF;
    ELSE
        SET divisible = 'Error: debes definir dos parametros numericos y mayores que 0...';
    END IF;
    RETURN(divisible);
END;$$

/* ejecutamos la función para testearla */
SELECT 2 AS 'Numero 1', 33 AS 'Numero 2', divisible(2,33) AS "Es Divisible?"$$
/* function dos con valores divisibles */
SELECT 30 AS 'Numero 1', 6 AS 'Numero 2', divisible(30,6) AS "Es Divisible?"$$

/* 
 * 4.2 Usando lo mismo que anteriormente mostramos el día de la semana según el valor de entrada 1 = domingo, 2 = lunes….
 */
DELIMITER $$
DROP FUNCTION IF EXISTS dias$$
CREATE FUNCTION dias (dia INTEGER)
    RETURNS VARCHAR(100)
BEGIN
    DECLARE nombredia VARCHAR(100);
    IF dia IS NOT NULL AND ( dia < 8 OR dia >= 0) THEN
        /* implementamos una estructura de control switch (mas util) */
        CASE dia
            WHEN 0 THEN 
                SET nombredia = 'Domingo';
            WHEN 1 THEN 
                SET nombredia = 'Lunes';
            WHEN 2 THEN 
                SET nombredia = 'Martes';
            WHEN 3 THEN 
                SET nombredia = 'Miercoles';
            WHEN 4 THEN 
                SET nombredia = 'Jueves';
            WHEN 5 THEN 
                SET nombredia = 'Viernes';
            WHEN 6 THEN 
                SET nombredia = 'Sabado';
    ELSE
            SET nombredia = 'Error: debes definir un parametro numerico entre 0-7...';
        END CASE;
    
    ELSE
        SET nombredia = 'Error: debes definir un parametro numerico entre 0-7...';
    END IF;
    RETURN(nombredia);
END;$$

/* ejecutamos la función para testearla */
SELECT 2 AS 'Dia de la semana', dias(1) AS "Nombre del dia"$$
/* prueba con otro dia */
SELECT 6 AS 'Dia de la semana', dias(6) AS "Nombre del dia"$$
/* prueba con otro dia */
SELECT 6 AS 'Dia de la semana', dias(4) AS "Nombre del dia"$$

/*
 * 4.3 Crear una función que devuelva el mayor de tres números pasados como parámetros
 */
DELIMITER $$
DROP FUNCTION IF EXISTS mayor$$
CREATE FUNCTION mayor (num1 INTEGER, num2 INTEGER, num3 INTEGER)
    RETURNS VARCHAR(100)
BEGIN
    DECLARE nmayor VARCHAR(100);
    IF num1 > 0 AND num2 > 0 AND num3 > 0 THEN
        /* obtenemos el numero mayor con estructuras if else */
        IF num1 >= num2 AND num1 >= num3 THEN
            SET nmayor = num1;
        ELSEIF num2 >= num1 AND num2 >= num3 THEN
            SET nmayor = num2;
        ELSE 
            SET nmayor = num3;
        END IF;
    ELSE 
        SET nmayor = 'Error: debes definir tres parametros numericos y mayores que 0...';
    END IF;
    RETURN(nmayor);
END;$$

/* ejecutamos la función para testearla */
SELECT 2 AS 'Num 1', 5 AS 'Num 2', 9 AS 'Num 3', mayor(2,5,9) AS "Numero mayor"$$
/* prueba con otro dia */
SELECT 17 AS 'Num 1', 3 AS 'Num 2', 11 AS 'Num 3', mayor(17,3,11) AS "Numero mayor"$$

/*
 * 4.4 Sobre la base de datos ‘liga’ crear una función que devuelva 1 si ganó el visitante y 0 en caso contrario. El parámetro de entrada es el resultado con el formato ‘xxx-xxx’.
 */
 DELIMITER $$
/* usamos una funcion avanzada a medida inspirada en split() */
DROP FUNCTION IF EXISTS SPLIT$$
CREATE FUNCTION SPLIT(
  x VARCHAR(100),
  delim VARCHAR(2),
  pos INT
)
RETURNS VARCHAR(255)
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
        LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1), delim, '');$$
/* Fin funcion */

/* definimos funcion partido() */
DROP FUNCTION IF EXISTS partido$$
CREATE FUNCTION partido (marcador VARCHAR(8))
    RETURNS VARCHAR(100)
BEGIN
    DECLARE partido1 INTEGER;
    DECLARE partido2 INTEGER;
    DECLARE vencedor VARCHAR(100);
    /* comprobamos el marcados */
    IF LENGTH(marcador) > 2 AND LENGTH(marcador) < 8 AND INSTR(marcador,'-') > 0 THEN
        SET partido1 = SPLIT(marcador,'-',1); /* posicion 1, primer resultado */
        SET partido2 = SPLIT(marcador,'-',2); /* posicion 2, segundo resultado */
        /* si es empate */
        IF partido1 = partido2 THEN
            SET vencedor = 3; /* empate */
        /* si hay un vencedor */
        ELSEIF partido1 > partido2 THEN
            SET vencedor = 0; /* gana el equipo local */
        ELSEIF partido2 > partido1 THEN
            SET vencedor = 1; /* gana el equipo visitante */
        END IF;
    ELSE
        SET vencedor = 'Error: debes definir un parametro y con formato "xxx-xxx" ...';
    END IF;
    RETURN(vencedor);
END;$$

/* ejecutar la function para testearla */
SELECT 2 AS 'Goles Equipo Local', 3 AS 'Goles Equipo Visitante', partido('2-3') AS "Resultado";$$
/* empate */
SELECT 3 AS 'Goles Equipo Local', 3 AS 'Goles Equipo Visitante', partido('3-3') AS "Resultado";$$
/* formato completo */
SELECT 5 AS 'Goles Equipo Local', 1 AS 'Goles Equipo Visitante', partido('005-001') AS "Resultado";$$

/*
 * 4.5 Ejercicio palabra palíndroma (extra)
 */
DELIMITER $$
/* implementacion con bucles */
DROP FUNCTION IF EXISTS palindroma$$
CREATE FUNCTION palindroma (palabra VARCHAR(8))
    RETURNS VARCHAR(100)
BEGIN
    DECLARE resultado VARCHAR(100);
    DECLARE par1 VARCHAR(50);
    DECLARE par2 VARCHAR(50);
    DECLARE i INTEGER;
    /* comprobamos que el numero de letras es par */
    IF ROUND(CHAR_LENGTH(palabra)%2,0) = 0 THEN
        SET resultado = ROUND(CHAR_LENGTH(palabra) / 2, 0); /* usamos la variable para almacenar la divion */
        SET i = 0;
        _loop: LOOP
            SET i = i + 1;
            IF i < resultado THEN
                SET par1 = LEFT(palabra,resultado); /* obtenemos la cadena izquieda */
                SET par2 = RIGHT(palabra,resultado); /* obtenemos la cadena derecha */
                /*SET resultado = CONCAT(SUBSTRING(par1,i,1),SUBSTRING(par2,i-resultado,1));*/
                /* comprobamos cada caracter con la funcion nativa SUBSTRING() */
                IF SUBSTRING(par1,i,1) <> SUBSTRING(par2,i-resultado,1) THEN
                    SET resultado = 'NO es polindroma';
                    LEAVE _loop;
                END IF;
            ELSE
                SET resultado = 'SI es polindroma';
                LEAVE _loop;
            END IF;
        END LOOP _loop;
    ELSE
        SET resultado = 'Error: debes definir un palabra con numero de letras par...';
    END IF;
    RETURN(resultado);
END;$$

/* ejecutar la function para testearla */
SELECT 'paap' AS 'Palabra', palindroma('paap') AS "Es palindroma?";$$
/* no polindroma */
SELECT 'pepe' AS 'Palabra', palindroma('pepe') AS "Es palindroma?";$$
/* caracteres impares*/
SELECT 'peope' AS 'Palabra', palindroma('peope') AS "Es palindroma?";$$


/* implementacion sin bucles */
DROP FUNCTION IF EXISTS palindroma$$
CREATE FUNCTION palindroma (palabra VARCHAR(8))
    RETURNS VARCHAR(100)
BEGIN
    DECLARE resultado VARCHAR(100);
    DECLARE par1 VARCHAR(50);
    DECLARE par2 VARCHAR(50);
    DECLARE i INTEGER;
    /* comprobamos que el numero de letras es par */
    IF CHAR_LENGTH(palabra)%2 = 0 THEN
        SET resultado = ROUND(CHAR_LENGTH(palabra) / 2, 0); /* usamos la variable para almacenar la divion */
        SET par1 = LEFT(palabra,resultado); /* obtenemos la cadena izquieda */
        SET par2 = RIGHT(palabra,resultado); /* obtenemos la cadena derecha */
        IF par1 = REVERSE(par2) THEN /* usamos la funcion native reverse() */
            SET resultado = 'SI es polindroma';
        ELSE 
            SET resultado = 'NO es polindroma';
        END IF;
    ELSE
        SET resultado = 'Error: debes definir un palabra con numero de letras par...';
    END IF;
    RETURN(resultado);
END;$$

/* ejecutar la function para testearla */
SELECT 'paap' AS 'Palabra', palindroma('paap') AS "Es palindroma?";$$
/* no polindroma */
SELECT 'pepe' AS 'Palabra', palindroma('pepe') AS "Es palindroma?";$$
/* caracteres impares*/
SELECT 'peope' AS 'Palabra', palindroma('peope') AS "Es palindroma?";$$