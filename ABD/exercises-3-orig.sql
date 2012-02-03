/*
 * 1.
 */
DELIMITER $$
CREATE PROCEDURE suma2(IN param INT)
BEGIN
	DECLARE cont INT;
	DECLARE suma INT;
	SET cont=0;
	SET suma=0;
	loop_label: LOOP
		IF cont>param THEN
			LEAVE loop_label;
		END IF;
		SET suma=suma+cont;
		SET cont=cont+1;
	END LOOP;
	SELECT concat("la suma es ", suma);
END;$$

/*
 * 2.
 */
DELIMITER $$
CREATE PROCEDURE sumaterm(IN m INT)
BEGIN
	DECLARE cont INT;
	DECLARE suma decimal(4,2);
	SET cont=1;
	SET suma=0;
	loop_label: LOOP
		IF cont>m THEN
			LEAVE loop_label;
		END IF;
		SET cont=cont+1;
		SET suma=suma+(1/cont);
	END LOOP;
	SELECT concat("La suma es ", FORMAT(suma,3));
END;$$

/*
 * 3.
 */ 
DELIMITER $$
CREATE FUNCTION esprimo(num int)
RETURNS int /*devuelve 1 si es primo o sino*/
BEGIN
	DECLARE divisor INT;
	DECLARE prim INT;set divisor=2;
	set prim=0; /*devuelve 1 si es primo 0 en caso contrario*/
	loop1: while(divisor<num) DO
		loop2: while (MOD(num,divisor)<> 0) DO
			set divisor=divisor+1;
		end while loop2;
		if (num=divisor) then 
			set prim=1;
		else 
			set prim=0;
		end if;
		leave loop1;
	end while loop1;
	RETURN (prim);
END ;$$

/*
 * 4.
 */
DELIMITER $$
CREATE FUNCTION sumprims(m int)
RETURNS int
BEGIN
	DECLARE cont INT;
	DECLARE suma INT;
	declare var int;
	set var=0;
	set cont=1;
	set suma=0;
	loop1: while(cont<=m) DO
		if (esprimo(cont)=1)
		then set suma=suma+cont;
		end if;
		set cont=cont+1;
	end while loop1;
	RETURN (suma);
END ;$$

/* 
 * 5.
 */
DELIMITER $$
/*es el mismo que sumprims pero en vez de sumar almaceno en tabla*/
CREATE PROCEDURE geneprims(IN m INT)
BEGIN
	DECLARE cont,id_cont INT;
	DECLARE suma INT;
	declare var int;
	set var=0;
	set cont=1;
	set suma=0;
	set id_cont=1;
	loop1: while(cont<=m) DO
		if (esprimo(cont)=1)
		then insert into primos values (id_cont,cont);set id_cont=id_cont+1;
		end if;
		set cont=cont+1;
	end while loop1;
END;$$

/*
 * 6.
 */ 
DELIMITER $$
/*es el mismo que sumprims pero en vez de sumar almaceno en tabla*/
CREATE PROCEDURE cargaregbanca(IN m INT)
BEGIN
	DECLARE cont INT;
	DECLARE fexa DATE;
	DECLARE ale INT;
	DECLARE dni INT;
	DECLARE idmov INT;
	set cont=1;
	set fexa=current_date();
	set dni=11111111;
	select max(idmov) into idmov from movimientos;
	loop1: while(cont<=m) DO
		set ale=round(rand()*(100000+1));
		insert into movimientos values (dni,fexa,cont,idmov,1);
		set cont=cont+1;
		set idmov=idmov+1;
	end while loop1;
END;$$