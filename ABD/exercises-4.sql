/* 
 * @description Some MySQL exercises. Set 4
 * @author Tomas Aparicio <tomas@rijndael-project.com>
 * @license MIT License <http://www.opensource.org/licenses/mit-license.php>
 * @date 02/02/2012
 */

/*
 * 4.4.1 
 * Haz un procedimiento que muestre el nombre del autor que mas noticias ha publicado en el último mes.
 */
/* usamos la base de datos deseada */
USE motorblog;

DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio1;$$ 
CREATE PROCEDURE ejercicio1 ( )
    /* procedimiento de tipo SQL DATA */
    READS SQL DATA
BEGIN
    /* declaramos variables */
    DECLARE autor, vautor, count, tcount, mes INT;
    DECLARE fin BOOL;
     
    /* obtenemos todos los autores */
    DECLARE autor_cursor CURSOR FOR SELECT id_autor FROM autores; 
    /* seleccionamos las noticias de cada autor y hacemos un count para obtener el maximo */
    DECLARE noticia_cursor CURSOR FOR SELECT COUNT(id) FROM noticias WHERE autor_id=vautor AND MONTH(fecha_pub) = 11;
    /* declaramos variable fin si no existen resultados */
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;

    /* definimos el mes anterior */
    -- SET mes=DATE_ADD(NOW(), INTERVAL 1 MONTH); /* real */
    -- SET mes=11; /* ejemplo estatico practico */

    /* forzamos a definir a cero */
    SET count=0;
    /* abrimos el cursor */
    OPEN autor_cursor;
        autor_loop: LOOP
            /* obtenemos el valor en vautor */
            FETCH autor_cursor INTO vautor;
            /* if final salimos del bucle */
            IF fin=1 THEN 
                LEAVE autor_loop;
            END IF;
            /* buscamos en cada noticia por autor */
            OPEN noticia_cursor; 
                /* obtenemos el numero de noticias */
                FETCH noticia_cursor INTO tcount;

                /* si es mayor que el anterior seleccionamos el autor (id) */
                IF tcount > count THEN
                    SET autor = vautor;
                    SET count = tcount;
                END IF;

            CLOSE noticia_cursor;
            
            SET fin=0;
            
        END LOOP autor_loop;
    CLOSE autor_cursor;
    
    /* devolvemos el resultado del autor que mas noticias tiene - ejecutamos fuera del bucle */
    SELECT CONCAT('El autor ', (SELECT login FROM autores WHERE id_autor = vautor), ' tiene ', count, ' noticias en el mes ', 11);
            
END;$$

CALL ejercicio1();


/*
 * 4.4.2
 * Usando cursores crear un procedimiento que muestre los datos del cliente, la cuenta y el saldo de los clientes con saldo negativo en algunas de sus cuentas.
 */
/* usamos la base de datos deseada */
USE ebanca;

DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio2;$$ 
CREATE PROCEDURE ejercicio2 ( )
    /* procedimiento de tipo SQL DATA */
    READS SQL DATA
BEGIN
    /* declaramos variables */
    DECLARE codigo INT;
    DECLARE fin BOOL;
    
    /* obtenemos los saldos de todas las cuentas de los clientes menores de 0 */
    DECLARE cuentas_cursor CURSOR FOR SELECT cod_cliente FROM cuentas WHERE saldo < 0; 
    /* declaramos variable fin si no existen resultados */
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;

    /* abrimos el cursor */
    OPEN cuentas_cursor;
        /* recorremos cada cuenta en el bucle */
        cuentas_loop: LOOP
            /* obtenemos el saldo de la cuenta */
            FETCH cuentas_cursor INTO codigo;
            /* if no existe salimos del bucle */
            IF fin=1 THEN 
                LEAVE cuentas_loop;
            END IF;
            /* seleccionamos el cliente en una consulta distinta para cada caso */
            SELECT codigo_cliente, nombre, apellido1, apellido2, dni, cod_cuenta, saldo 
            FROM clientes 
                INNER JOIN cuentas ON codigo_cliente = cod_cliente
            WHERE codigo_cliente = codigo AND saldo < 0;
            
        END LOOP cuentas_loop;
    CLOSE cuentas_cursor;
            
END;$$

CALL ejercicio2();

/*
 * 4.4.3
 * Calcula con un procedimiento la suma de todos los ingresos y cargos (por separado) en todas las cuentas de ebanca.
 */

/* usamos la base de datos deseada */
USE ebanca;

DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio3;$$ 
CREATE PROCEDURE ejercicio3 ( )
    /* procedimiento de tipo SQL DATA */
    READS SQL DATA
BEGIN
    /* declaramos variables */
    DECLARE cuenta, movimiento, ingresos, cargos INT;
    DECLARE fin BOOL;
    
    /* obtenemos todas las cuentas */
    DECLARE cuentas_cursor CURSOR FOR SELECT cod_cuenta FROM cuentas; 
    /* obtenemos la cantidad de los movimientos para cada cuenta */
    DECLARE movimientos_cursor CURSOR FOR SELECT cantidad FROM movimientos WHERE cod_cuenta = cuenta; 
    /* declaramos variable fin si no existen resultados */
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;

    /* abrimos el cursor */
    OPEN cuentas_cursor;
        /* recorremos cada cuenta en el bucle */
        cuentas_loop: LOOP
            /* definimos a cero */
            SET ingresos = 0;
            SET cargos = 0;
            
            /* obtenemos el saldo de la cuenta */
            FETCH cuentas_cursor INTO cuenta;
            /* if no existe salimos del bucle */
            IF fin=1 THEN 
                LEAVE cuentas_loop;
            END IF;
            
            /* buscamos los movimientos */
            OPEN movimientos_cursor;
                movimientos_loop: LOOP
                    FETCH movimientos_cursor INTO movimiento;
                    IF fin=1 THEN 
                        LEAVE movimientos_loop;
                    END IF;
                    /* sumamos ingresos y cargos */
                    IF movimiento < 0 THEN
                        SET cargos = cargos + movimiento;
                    ELSE
                        SET ingresos = ingresos + movimiento;
                    END IF;
                END LOOP movimientos_loop;
            CLOSE movimientos_cursor;
            
            /* mostramos el resultado */ 
            SELECT CONCAT('La cuenta Nº', cuenta, ' tiene ', cargos, ' € en cargos y ', ingresos, ' € en ingresos');
            SET fin=0;
            
        END LOOP cuentas_loop;
    CLOSE cuentas_cursor;
END;$$

CALL ejercicio3();

/*
 * 4.4.4
 * Crea un procedimientos que muestre el número máximo de partidos seguidos ganaos por un equipo en casa.
 */
/* usamos la base de datos deseada */
USE liga;

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

DROP PROCEDURE IF EXISTS ejercicio4;$$ 
CREATE PROCEDURE ejercicio4 ( )
    /* procedimiento de tipo SQL DATA */
    READS SQL DATA
BEGIN
    /* declaramos variables */
    DECLARE equipo, partido VARCHAR(10);
    DECLARE resul1, resul2, count INT;
    DECLARE fin, ultimo BOOL;
    
    /* obtenemos todos los equipos */
    DECLARE equipos_cursor CURSOR FOR SELECT nombre FROM equipo; 
    /* obtenemos los resultados de los partidos con equipo local ordenado por fecha para conocer su consecución */
    DECLARE partidos_cursor CURSOR FOR SELECT resultado FROM partido WHERE local = equipo ORDER BY fecha; 
    /* declaramos variable fin si no existen resultados */
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;

    /* abrimos el cursor */
    OPEN equipos_cursor;
        /* recorremos cada cuenta en el bucle */
        equipos_loop: LOOP
            SET count = 0;
            /* obtenemos el saldo de la cuenta */
            FETCH equipos_cursor INTO equipo;
            /* if no existe salimos del bucle */
            IF fin=1 THEN 
                LEAVE equipos_loop;
            END IF;

            /* buscamos los movimientos */
            OPEN partidos_cursor;
                partidos_loop: LOOP
                    FETCH partidos_cursor INTO partido;
                    -- SELECT CONCAT('Equipo -> ' , equipo, ' -> resultado -> ', partido);
                    IF fin=1 THEN 
                        LEAVE partidos_loop;
                    END IF;
                    
                    SET resul1 = SPLIT(partido,'-',1); /* resultado local */
                    SET resul2 = SPLIT(partido,'-',2); /* resultado visitante */
                    /* comprobamos que ha ganado el equipo y es consecutivo */
                    IF (resul1 > resul2) THEN
                        SET count = count + 1; /* incrementanos un partido ganado */
                    ELSE
                        SET count = 0;
                    END IF;
                    
                END LOOP partidos_loop;
            CLOSE partidos_cursor;
            
            /* mostramos el resultado */ 
            SELECT CONCAT('El equipo "', equipo, '" ha ganado ', count, ' partido/s consecutivos en casa.');
            SET fin=0;
            
        END LOOP equipos_loop;
    CLOSE equipos_cursor;
END;$$

CALL ejercicio4();
 