/* 
 * @description Some MySQL exercises. Set 1
 * @author Tomas Aparicio <tomas@rijndael-project.com>
 * @license MIT License <http://www.opensource.org/licenses/mit-license.php>
 * @date 09/01/2012
 */

/*
 * 4.1 - Mostrar en año actual a través de un procedimiento:
 */
DELIMITER $$
DROP PROCEDURE IF EXISTS anyo$$
CREATE PROCEDURE anyo()
BEGIN
    SELECT YEAR(NOW()) AS "Año Actual";
END;$$
/* ejecutar la procedimiento para testearlo */
CALL anyo()

/* 
 * 4.2 – Crear y mostrar una variable de usuario con SET.
 */
DROP PROCEDURE IF EXISTS variable$$
CREATE PROCEDURE variable()
BEGIN
    DECLARE mivar INTEGER;
    SET mivar = 1234;
    SELECT mivar AS Variable;
 END;$$
/* ejecutar la procedimiento para testearlo*/
CALL variable()

/*
 * 4.3– Incrementar la variable en “1” a una variable anterior en cada ejecución.
 */
DELIMITER $$
DROP PROCEDURE IF EXISTS incrementar$$
CREATE PROCEDURE incrementar (INOUT count INTEGER)
BEGIN
    IF count THEN
        SET count = count + 1;
    END IF;
    SELECT count AS "Variable count";
END;$$
SET @c = 1;$$
/* ejecutar el procedimiento para testearlo (repetidas veces)*/
CALL incrementar(@c);$$
CALL incrementar(@c);$$
CALL incrementar(@c);$$

/*
 * 4.4. Procedimientos mostrando las tres primeras letras de una cadena y en mayúsculas.
 */
 DELIMITER $$
DROP PROCEDURE IF EXISTS cadena$$
CREATE PROCEDURE cadena (IN texto VARCHAR(100))
BEGIN
    IF LENGTH(texto) > 0 THEN
        SELECT UPPER(LEFT(texto,3)) AS "Cadena de Texto";
    ELSE
        SELECT 'Error: debes definir un parametro...' AS Error;
    END IF;
END;$$
/* ejecutar el procedimiento para testearlo */
CALL cadena('Esto es un texto de prueba');$$

/* 
 * 4.5. Mostrar dos cadenas concatenadas y en mayúsculas.
 */
DELIMITER $$
DROP PROCEDURE IF EXISTS cadenas$$
CREATE PROCEDURE cadenas (IN texto VARCHAR(100), IN texto2 VARCHAR(100))
BEGIN
    IF LENGTH(texto) > 0 AND LENGTH(texto2) > 0 THEN
        SELECT UPPER(CONCAT(texto, texto2))  AS "Cadenas de texto";
    ELSE
        SELECT 'Error: debes definir dos parametros...' AS Error;
    END IF;
END;$$
/* ejecutar el procedimiento para testearlo */
CALL cadenas('Esto es un texto 1',' y esto es un texto 2');$$

/* 
 * 4.6. Función para calcular la hipotenusa de un triangulo según sus valores.
 */
DELIMITER $$
DROP FUNCTION IF EXISTS triangulo$$
CREATE FUNCTION triangulo (lado1 INTEGER, lado2 INTEGER)
    RETURNS VARCHAR(100)
BEGIN
    DECLARE hipotenusa VARCHAR(100);
    IF lado1 > 0 AND lado2 > 0 THEN
        /* aplicamos el calculo y raiz cuadrada, además de redondeo a 0 decimales */
        SET hipotenusa = ROUND(SQRT((lado1 * lado1) + (lado2 * lado2)), 0);
    ELSE
        SET hipotenusa = 'Error: debes definir dos parametros y mayores que 0...';
    END IF;
    RETURN(hipotenusa);
END;$$
/* ejecutar la función para testearla */
SELECT 42 AS 'Cateto 1', 33 AS 'Cateto 2', triangulo(43,33) AS "Hipotenusa";$$

/*
 * 4.7. Función para calcular el total de puntos de un partido tomando una entrada con formato “xxx-xxx”.
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
    DECLARE puntos VARCHAR(100);
    /* comprobamos el marcados */
    IF LENGTH(marcador) > 2 AND LENGTH(marcador) < 8 AND INSTR(marcador,'-') > 0 THEN
        SET partido1 = SPLIT(marcador,'-',1); /* posicion 1, primer resultado */
        SET partido2 = SPLIT(marcador,'-',2); /* posicion 2, segundo resultado */
        /* si es empate */
        IF partido1 = partido2 THEN
            SET puntos = 2; /* 1 punto para cada equipo */
        /* si hay un vencedor */
        ELSEIF partido1 > partido2 OR partido2 > partido1 THEN
            SET puntos = 3; /* tres puntos al vencedor */
        END IF;
    ELSE
        SET puntos = 'Error: debes definir un parametro y con formato "xxx-xxx" ...';
    END IF;
    RETURN(puntos);
END;$$

/* ejecutar la function para testearla */
SELECT 2 AS 'Goles Equipo 1', 3 AS 'Goles Equipo 2', partido('2-3') AS "Total puntos";$$
/* empate */
SELECT 3 AS 'Goles Equipo 1', 3 AS 'Goles Equipo 2', partido('3-3') AS "Total puntos";$$
/* formato completo */
SELECT 5 AS 'Goles Equipo 1', 1 AS 'Goles Equipo 2', partido('005-0001') AS "Total puntos";$$