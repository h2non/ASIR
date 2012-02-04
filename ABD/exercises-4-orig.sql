/*
 * 1.
 */
DELIMITER $$
CREATE PROCEDURE mas2()
READS SQL DATA
BEGIN
	/*declaraciones*/
	DECLARE vautor,na_count,vautor_max,noti_max INT;
	DECLARE fin BOOL;
	DECLARE ac CURSOR FOR SELECT id_autor FROM autores;
	DECLARE nc CURSOR FOR SELECT autor_id FROM noticias WHERE autor_id=vautor;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;
	SET na_count=0;
	SET noti_max=0;
	SET vautor_max=0;
	OPEN ac;
	autor_loop: LOOP
		FETCH ac into vautor;
		IF fin=1 THEN LEAVE autor_loop;
		END IF;
		OPEN nc;
		SET na_count=0;
		noticias_loop:LOOP
			FETCH nc INTO vautor;
			IF fin=1 THEN LEAVE noticias_loop;
			END IF;
			set na_count=na_count +1;
		END LOOP noticias_loop;
		IF (na_count>noti_max) THEN
			SET noti_max=na_count;
			SET vautor_max=vautor;
		END IF;
		CLOSE nc;
		SET fin=0;
		SELECT CONCAT ('eL AUTOR ',vautor, 'tiene ', na_count, ' noticias');
	END LOOP autor_loop;
	CLOSE ac;
END;$$

/*
 * 2.
 */
DELIMITER $$
CREATE PROCEDURE datos()
READS SQL DATA
BEGIN
	/*declaraciones*/
	DECLARE cod_client,cod_clientt,dni,saldo,cod_cuenta,muestro_saldo,saldo_total INT;
	DECLARE nombre,apellido1,apellido2,direccion,region VARCHAR(25);
	DECLARE fexa DATE;
	DECLARE fin BOOL;
	DECLARE cursor_datos CURSOR FOR SELECT * FROM clientes; /*cursor para clientes*/
	DECLARE cursor_cuentas CURSOR FOR SELECT * FROM cuentas where cod_cliente=cod_client; /
	*cursor para cuentas*/
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;
	SET fin=0;
	/*Abro cursor datos cliente*/
	OPEN cursor_datos;
	datos_loop: LOOP
		FETCH cursor_datos INTO cod_client,dni,nombre,apellido1,apellido2,direccion,region ;
		SELECT CONCAT ('Cliente:',cod_client ,'.', nombre, ' ', apellido1, '.DNI ', dni, '.
		Direccion ',direccion, ' Region:', region );
		SELECT ('Cuentas: ');
		SET muestro_saldo=0;
		SET saldo_total=0;
		IF fin=1 THEN LEAVE datos_loop;
		END IF;
		/*Abro cursor cuentas*/
		OPEN cursor_cuentas;
		cuentas_loop: LOOP
			/*Guardo cursor en vbles y muestro*/
			FETCH cursor_cuentas INTO fexa,saldo,cod_cuenta,cod_clientt ;
			SELECT CONCAT('Fecha ', fexa, ' Cod_cuenta ', cod_cuenta,' Cod_client ', cod_clientt );
			/*Almaceno saldo por si tengo que mostrar*/
			SET saldo_total=saldo_total+saldo;
			/*Compruebo si saldo es negativo en cuenta, si lo es flag a 1 para que muestre*/
			IF saldo<0 THEN SET muestro_saldo=1;
			END IF;
			/*Salida bucle*/
			IF fin=1 THEN LEAVE cuentas_loop;
			END IF;
			/*Cerramos bucle y cursor*/
		END LOOP cuentas_loop;
		CLOSE cursor_cuentas;
		/*Si flag esta 1 muestro saldo*/
		IF (muestro_saldo=1) THEN 
			SELECT CONCAT('Saldo ', saldo_total);
		END IF;
		/*fin a cero para bucle inicial pueda salir*/
		SET fin=0;
	END LOOP datos_loop;
	CLOSE cursor_datos;
END; $$

/*
 * 3.
 */
/*Recorre las cuentas de los clientes, y para cada cuenta calcula movimientos ingresos y cargos y muestra */
DELIMITER $$
CREATE PROCEDURE movimientos()
READS SQL DATA
BEGIN
	/*declaraciones*/
	DECLARE cod_client,saldo,cod_cuentt,dni,idmov,cod_cuent,ingresos,cargos,cantidad INT;
	DECLARE fexa,fexa_hora DATE;
	DECLARE fin BOOL;
	/*Declaro cursores y handler*/
	DECLARE cursor_cuentas CURSOR FOR SELECT * FROM cuentas; /*cursor para cuentas*/
	DECLARE cursor_movimientos CURSOR FOR SELECT * FROM movimientos where
	cod_cuenta=cod_cuentt; /*cursor para movimientos*/
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;
	set fin=0;
	/*Abro cursor cuentas*/
	OPEN cursor_cuentas;
	cuentas_loop: LOOP
		FETCH cursor_cuentas INTO fexa,saldo,cod_cuentt,cod_client ;
		SELECT CONCAT(' Cod_cuenta ', cod_cuentt,' Cod_client ', cod_client );
		/*Inicializo ingresos y cargos a 0 para la cuenta*/
		SET ingresos=0;
		SET cargos=0;
		IF fin=1 THEN LEAVE cuentas_loop;
		END IF;
		/*Abro cursor movimientos*/
		OPEN cursor_movimientos;
		movimientos_loop: LOOP/*Guardo cursor en vbles y muestro*/
			FETCH cursor_movimientos INTO dni,fexa_hora,cantidad,idmov,cod_cuent ;
			/*Compruebo si saldo es negativo en cuenta, si lo es flag a 1 para que muestre*/
			IF cantidad>0 THEN SET ingresos=ingresos+cantidad;
			ELSEIF cantidad<0 THEN SET cargos=cargos+cantidad;
			END IF;
			/*Salida bucle*/
			IF fin=1 THEN LEAVE movimientos_loop;
			END IF;
		/*Cerramos bucle y cursor*/
		END LOOP movimientos_loop;
		CLOSE cursor_movimientos;
		/*mUESTRO ingresos y cargos*/
		SELECT CONCAT('Ingresos en cuenta ',ingresos);
		SELECT CONCAT('Cargos en cuenta ',cargos);
		/*fin a cero para bucle inicial pueda salir*/
		SET fin=0;
	END LOOP cuentas_loop;
CLOSE cursor_cuentas;
END; $$

/*
 * 4.
 */
/* Recorre la tabla partidos almacena partidos seguidos ganados en casa y muestra */
DELIMITER $$
CREATE PROCEDURE part_ganados()
READS SQL DATA
BEGIN
	/*declaraciones*/
	DECLARE eq_local,eq_visitante,result,eq_local_ante,eq_bueno,max_ano VARCHAR(10);
	DECLARE fexa DATE;
	DECLARE max_num_ganados,num_ganados,ptos_total INT;
	DECLARE fin BOOL;
	/*Declaro cursores y handler*/
	DECLARE cursor_partidos CURSOR FOR SELECT * FROM partido order by fecha; /*cursor
	para cuentas*/
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;
	set fin=0;
	set max_num_ganados=0;
	set num_ganados=0;set eq_local_ante="";
	set eq_bueno="";
	/*Abro cursor partidos*/
	OPEN cursor_partidos;
	partidos_loop: LOOP
		/* Guardo contenido cursor en vbles*/
		FETCH cursor_partidos INTO fexa,eq_local,eq_visitante,result,ptos_total,max_ano;
		/*miro si es el primer registro para inicializar eq_local*/
		IF eq_local_ante="" THEN 
			SET eq_local_ante=eq_local;
		END IF;
		/*si gana partido local, veo si es el mismo del anterior sino inicializo cuenta*/
		if SUBSTRING(result,1,3)>SUBSTRING(result,5,3) THEN
		IF eq_local=eq_local_ante THEN 
			SET num_ganados=num_ganados+1;
		ELSE /*gana el local pero es un equipo diferente inicializo cuentas y guardo max_ganados*/
			IF num_ganados>=max_num_ganados THEN
				SET max_num_ganados=num_ganados;
				SET eq_bueno=eq_local_ante;
			END IF;
			SET num_ganados=1;
			SET eq_local_ante=eq_local;
		END IF;	
		END IF;
		
		IF fin=1 THEN
			LEAVE partidos_loop;
		END IF;
	/* fin blucle */
	END LOOP partidos_loop;
	CLOSE cursor_partidos;
	/*Comparo con el ultimo ya que solo compruebo cdo cambia el eq_local*/
	IF num_ganados>=max_num_ganados THEN
		SET max_num_ganados=num_ganados;
		SET eq_bueno=eq_local_ante;
	END IF;
	SELECT CONCAT('EL equipo ', eq_bueno,' ha ganado ', max_num_ganados) ;
END; $$