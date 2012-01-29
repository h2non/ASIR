/* 
 * @description Some MySQL exercises. Set 3
 * @author Tomas Aparicio <tomas@rijndael-project.com>
 * @license MIT License <http://www.opensource.org/licenses/mit-license.php>
 * @date 21/01/2012
 */
 
/* 
 * 4.3.1 Crear procedimiento que muestre la suma de los primeros n números enteros.
 */
USE test;
DELIMITER $$
DROP PROCEDURE IF EXISTS ejer1$$
CREATE PROCEDURE ejer1 (n INTEGER)
BEGIN
/* declaramos y definimos */
DECLARE i INTEGER;
DECLARE resul VARCHAR (100);
SET i = 1;
SET resul = n;
loop1: WHILE i<n DO
    /* definimos */
    SET resul = CONCAT(resul,CONCAT(', ',n+i));
    /* imcrementamos */
    SET i = i + 1;
END WHILE loop1;
/* mostramos el resultado separado por comas */
SELECT resul as Resultado;
END;$$

/* probamos */
CALL ejer1(5);$$
CALL ejer1(12);$$

/* 
 * 4.3.2 Crear procedimiento mostrando la suma de los términos 1/n con n entre 1 y m, es decir ½ + 1/3 …. Siendo m el parámetro de entrada.
 */
DELIMITER $$
DROP PROCEDURE IF EXISTS ejer2$$
CREATE PROCEDURE ejer2 (m INTEGER)
BEGIN
/* declaramos */
DECLARE i INTEGER;
DECLARE resul VARCHAR (100);
SET resul = 0;

IF m < 1 THEN
    SELECT 'Error, el parametro `m` debe ser mayor que 0...' AS Error;
ELSE
    SET i = 1;
    SET resul = m;
    loop1: WHILE i<m DO

        /* mostramos el resultado separado por comas */
        SET resul = resul + ROUND(1/i,2);
        /* imcrementamos */
        SET i = i + 1;

    END WHILE loop1;
    /* mostramos el resultado */
    SELECT resul AS Resultado;
END IF;
END;$$

/* probamos */
CALL ejer2(5);$$
CALL ejer2(9);$$

/*
 * 4.3.3 Crear funciona para determinar si un número es primo devolviendo 0 o 1.
 */
 /*
 * Implementación de primos en MySQL API basado en C
 void main(void) {
    int numero, divisor, primo, n;
    scanf("%d", &n);
    for (numero=2; numero<=n; numero++) {
      primo=1;
      for (divisor=2; divisor<=sqrt(numero); divisor++){
         if (numero%divisor==0){
            primo=0;
            break;
         }
      }
     if(primo==1) printf("%d\n", numero);
 }
 */
DELIMITER $$
DROP FUNCTION IF EXISTS ejer3$$
CREATE FUNCTION ejer3(n INTEGER)
    RETURNS INTEGER
BEGIN
    DECLARE num INTEGER;
    DECLARE i INTEGER;
    DECLARE primo INTEGER;
    SET i = 2;
    
    IF n < 2 THEN
        RETURN(0);
    ELSEIF n = 2 THEN 
        RETURN(1);
    ELSE
        SET primo = 1; /* por defecto defecto definimos como primo valido */
        loop1: WHILE i <= SQRT(n) DO
            IF (n%i) = 0 THEN
                SET primo = 0;
                LEAVE loop1;
            END IF;
            SET i = i +1;
        END WHILE loop1;
    
        RETURN (primo);
    END IF;
END;$$

/* probamos */
SELECT ejer3(15) as 'Es Primo?';$$
SELECT ejer3(67) as 'Es Primo?';$$

/*
 * 4.3.4 Usando la función anterior creamos otra que calcule la suma de todos primeros m números primos empezando en el 1.
 */
DELIMITER $$
DROP FUNCTION IF EXISTS ejer4$$
CREATE FUNCTION ejer4(n INTEGER)
    RETURNS VARCHAR(250)
BEGIN
    DECLARE x INTEGER;
    DECLARE i INTEGER;
    DECLARE primo INTEGER;
    DECLARE resul VARCHAR(250);
    SET i = 2;
    
    /* verificamos si es numero primo (antigua funcion) */
    IF n < 2 THEN
        SET primo = 0;
    ELSEIF n = 2 THEN 
        SET primo = 1;
    ELSE
        SET primo = 1;
        loop1: WHILE i <= SQRT(n) DO
            IF (n%i) = 0 THEN
                SET primo = 0;
                LEAVE loop1;
            END IF; 
            SET i = i +1;
        END WHILE loop1;
    END IF;
    
    
    /* en el caso de ser numero primo, procesamos */
    IF primo = 1 THEN
        SET x = 0; /* partimos de 0 como primer numero */
        SET resul = ''; /* string vacio para el CONCAT() */
        /* inicamos el bucle */
        loop2: WHILE x <= n DO 
            SET primo = 1; /* defecto validamos como primo */
            SET x = x + 1;
            SET i = 2;
            /* comprobamos si es primo */
            loop1: WHILE i <= SQRT(x) DO
                IF (x%i) = 0 THEN
                    SET primo = 0;
                    LEAVE loop1;
                END IF; 
                SET i = i +1;
            END WHILE loop1;
            /* si es primo concatenamos */
            IF primo = 1 THEN
                SET resul = CONCAT(resul,CONCAT(', ',x));
            END IF;
        END WHILE loop2;
        /* finalmente devolvemos todos los primos separados por comas */
        RETURN (resul);
    ELSE
        RETURN ('No es primo');
    END IF;
END;$$

/* probamos */
SELECT ejer4(15) as 'Es Primo?';$$
SELECT ejer4(67) as 'Es Primo?';$$
SELECT ejer4(29) as 'Es Primo?';$$

/*
 * 4.3.5 Crear un procedimiento para generar y almacenar en la tabla primos (id, numero) de la base de datos test los primeros números primos comprendido entre 1 y m.
 */
USE test;
DELIMITER $$
DROP PROCEDURE IF EXISTS ejer5$$
CREATE PROCEDURE ejer5 (INOUT n INTEGER)
BEGIN
    DECLARE x INTEGER;
    DECLARE i INTEGER;
    DECLARE primo INTEGER;
    SET i = 2;
    
    /* verificamos si es numero primo (antigua funcion) */
    IF n < 2 THEN
        SET primo = 0;
    ELSEIF n = 2 THEN 
        SET primo = 1;
    ELSE
        SET primo = 1;
        loop1: WHILE i <= SQRT(n) DO
            IF (n%i) = 0 THEN
                SET primo = 0;
                LEAVE loop1;
            END IF; 
            SET i = i +1;
        END WHILE loop1;
    END IF;
    
    /* en el caso de ser numero primo, procesamos */
    IF primo = 1 THEN
        /* si es numero primo procedemos a crear la tabla primos */
        DROP TABLE IF EXISTS primos;
        CREATE TABLE primos (
            id INTEGER PRIMARY KEY AUTO_INCREMENT,
            numero INTEGER UNIQUE
        ) engine=MyISAM; 
        /* fin tabla */
        
        SET x = 0; /* partimos de dos como primer numero primo */
        /* inicamos el bucle */
        loop2: WHILE x <= n DO 
            SET primo = 1; /* defecto validamos como primo */
            SET x = x + 1;
            SET i = 2;
            /* comprobamos si es primo */
            loop1: WHILE i <= SQRT(x) DO
                IF (x%i) = 0 THEN
                    SET primo = 0;
                    LEAVE loop1;
                END IF; 
                SET i = i +1;
            END WHILE loop1;
            /* si es primo concatenamos */
            IF primo = 1 THEN
                INSERT INTO primos(numero) VALUES(x);
            END IF;
        END WHILE loop2;
        /* definimos true como procesaro correctamente */
        SET n = TRUE;
        /* ejecutamos sentencia SELECT para comprobar los registros en la tabla */
        SELECT * FROM primos;
    ELSE
        /* definimos false como numero invalido */
        SET n = FALSE;
        /* ejectuamos SELECT como error */
        SELECT 'Error, el valor del parametro no es numero primo...' as Error;
    END IF;
END;$$

/* probamos */
SET @n = 15$$
CALL ejer5(@n)$$
SET @n = 67$$
CALL ejer5(@n)$$
SET @n = 29$$
CALL ejer5(@n)$$

/*
 * 4.3.6 Crear un procedimiento para generar n registros aleatorios en la tabla movimientos de la base de datos ebanca. Cada registro deberá contener datos de clientes y cuentas existentes. La cantidad deberá estar entre 1 y 10000 y la fecha será la actual.
 */
-- CREATE DATABASE ebanca;
USE ebanca;
DELIMITER $$
DROP PROCEDURE IF EXISTS ejer6$$
CREATE PROCEDURE ejer6 (IN n INTEGER)
BEGIN
    DECLARE i INTEGER;
    SET i = 1;
    
    /* creamos la tabla movimientos y su schema */
    DROP TABLE IF EXISTS movimientos;
    CREATE TABLE movimientos (
        id INTEGER PRIMARY KEY AUTO_INCREMENT,
        nombre VARCHAR(100),
        cuenta VARCHAR(32) UNIQUE, /* será única */
        cantidad INTEGER, 
        fecha DATETIME /* formato fecha completo */
    ) engine=MyISAM; 
    /* fin tabla */
        
    /* inicamos el bucle */
    loop1: WHILE i <= n DO 
        INSERT INTO movimientos (
            nombre,
            cuenta,
            cantidad,
            fecha
        )
        VALUES (
            CONCAT('Nombre ',i),
            MD5(CONCAT('Nombre ', rand() * i)), /* hash MD5 unico */
            (i * (RAND()*(10*i))), /* num aleatorio */
            NOW()
        );
        SET i = i + 1;
    END WHILE loop1;
    /* ejecutamos sentencia SELECT para comprobar los registros en la tabla */
    SELECT * FROM movimientos;
END;$$

/* probamos */
CALL ejer6(58)$$
CALL ejer6(17)$$
CALL ejer6(34)$$