/* 
 * 1. Solución
 */ 
DELIMITER $$
CREATE PROCEDURE act1() /*nombre*/
BEGIN
	DECLARE fexa DATE ;
	DECLARE any CHAR(10) ;
	SELECT CURRENT_DATE() into fexa;
	SELECT YEAR(fexa) into any;
	SELECT fexa;
	SELECT any;
END; $$

/*
 * 2. Solución.
 */
> SET @edad=33;
> select @edad;
/* Deberá ser de sesión. */

/* 
 * 3. Solución:
 */
DELIMITER $$
CREATE PROCEDURE act3 (INOUT p INT)
BEGIN
	SET p=p+1;
	SELECT p;
END; $$
>select @edad;
>CALL act3(@edad)$$
>select @edad;
>CALL act3(@edad)$$
>select @edad;

/*
 * 4. Solución:
 */
DELIMITER $$
CREATE PROCEDURE act4 (IN cad VARCHAR(20))
BEGIN
	DECLARE cad_mayusc CHAR(3); /*declaro cadena mayusc*/
	SET cad_mayusc=substring(@cad,1,3); /*monto contenido cadena*/
	SELECT UPPER(cad_mayusc);
END; $$

/*
 * 5. Solución
 */
DELIMITER $$
CREATE PROCEDURE act5 (IN cad1 VARCHAR(20),IN cad2 VARCHAR(20))
BEGIN
	DECLARE cad_nueva CHAR(50) ; /*declaro cadena mayusc*/
	SET cad_nueva=concat(cad1,cad2); /*monto contenido cadena*/
	SELECT UPPER(cad_nueva);
END; $$
>call act5(“uno”,”dos”)$$

/*
 * 6. Solución
 */
DELIMITER $$
CREATE PROCEDURE act6
(IN l1 integer,IN l2 integer)
BEGIN
	DECLARE h integer;
	SET h=SQRT((POW(l1,2)+POW(l2,2)));
	SELECT h;
END; $$

/* 
 * 7. Solución
 */
DELIMITER $$
CREATE PROCEDURE act8
(IN cad1 VARCHAR(20))
BEGIN
	DECLARE marc1 CHAR(50) ;
	DECLARE marc2 CHAR(50) ;
	DECLARE result INTEGER ;
	SET marc1=SUBSTRING(cad1,1,3);
	SET marc2=SUBSTRING(cad1,5,3);
	SET result=(cast(marc1 as decimal))+ (cast(marc2 as decimal));
	SELECT marc1;
	SELECT marc2;
	SELECT result;
END; $$
>call act8(“123-456”)$$