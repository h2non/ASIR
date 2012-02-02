/**
 * Code header geek! ;)
 * @author Tomas Aparicio <tomas@rijndael-project.com>
 * @license MIT
 * @date 16/02/2012
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
/* end funcion */

/* uso en funcion de ejemplo */
DROP FUNCTION IF EXISTS ejemplo$$
CREATE FUNCTION ejemplo ()
    RETURNS VARCHAR(100)
BEGIN
	/* declaramos */
	DECLARE cadena varchar(100);
    DECLARE txt1 INTEGER; /* ojo, es numericos */
    DECLARE txt2 INTEGER; /* ojo, es numericos */
	
	SET cadena = '043-009'; /* lo defino estaticamente, pero normalmente vendria como parametro */
	SET txt1 = SPLIT(cadena,'-',1); /* posicion 1 a extraer */
    SET txt2 = SPLIT(cadena,'-',2); /* posicion 2 a extraer */
	
	/* 
		aqui implementas lo que necesites
	*/
	
	/* concatenamos los strings para ver que la division es correcta */ 
	RETURN(CONCAT(CONCAT(txt1,'  <--->  '),txt2));
END;$$
/* end */

/* probamos */
SELECT ejemplo() AS 'Texto divido' 