/* 
 * 1.
 */
DELIMITER $$
CREATE FUNCTION esdivisible(num1 INT,num2 INT)
RETURNS int
BEGIN
	DECLARE divi INT;
	IF MOD (num1,num2)=0 THEN 
		SET divi=TRUE;
	ELSE 
		SET divi=FALSE;
	END IF;
	RETURN (divi);
END ;$$

/*
 * 2.
 */ 
DELIMITER $$
CREATE PROCEDURE diasemana (IN dia INT)
BEGIN
	IF dia=1 THEN 
		SELECT 'domingo';
	ELSEIF dia=2 THEN 
		SELECT 'lunes';
	ELSEIF dia=3 THEN 
		SELECT 'martes';
	ELSEIF dia=4 THEN 
		SELECT 'miercoles';
	ELSEIF dia=5 THEN 
		SELECT 'jueves';
	ELSEIF dia=6 THEN 
		SELECT 'viernes';
	ELSEIF dia=7 THEN
		SELECT 'sabado';
	END IF;
END;$$

/*
 * 3.
 */
DELIMITER $$
CREATE FUNCTION damemayor(a INT,b INT,c INT)
RETURNS int
BEGIN
	DECLARE mayor int;
	SET mayor=a;
	IF (b>mayor) THEN 
		SET mayor=b;
	END IF;
	if (c>mayor) THEN 
		SET mayor=c;
	END IF;
	RETURN (mayor);
END ;$$

/* 
 * 4. Se debe reutilizar el código de la última actividad del 4.1.
 */
DELIMITER $$
CREATE FUNCTION quiniela(cad1 VARCHAR(20))
RETURNS int
BEGIN
	DECLARE marc1 CHAR(50) ;
	DECLARE marc2 CHAR(50) ;
	DECLARE result INTEGER ;
	SET marc1=SUBSTRING(cad1,1,3);
	SET marc2=SUBSTRING(cad1,5,3);
	IF (cast(marc1 as decimal))>(cast(marc2 as decimal)) THEN 
		SET result=1;
	ELSEIF (cast(marc1 as decimal))<(cast(marc2 as decimal)) THEN 
		SET result=0;
	ELSE 
		SET result=3;
	END IF;
	RETURN result;
END; $$