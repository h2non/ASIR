/* 
 * Ejemplo libro
 */
USE motorblog;
DELIMITER $$
DROP PROCEDURE IF EXISTS ejercicio;$$ 
CREATE PROCEDURE ejercicio ( )
    READS SQL DATA
BEGIN
    DECLARE vautor, na_count INT;
    DECLARE fin BOOL;
    DECLARE autor_cursor CURSOR FOR SELECT id_autor FROM autor;
    DECLARE noticia_cursor CURSOR FOR SELECT autor FROM noticias WHERE autor=vautor;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;
    
    SET NA_COUNT=0;
    OPEN autor_cursor;
        autor_loop: LOOP
      
            FETCH autor_cursor INTO vautor;
            IF fin=1 THEN LEAVE autor_loop;
            END IF;
            OPEN noticia_cursor; 
                SET na_count=0;
                noticias_loop: LOOP
                    FETCH noticia_cursor INTO vautor;
                    IF fin=1 THEN LEAVE autor_loop;
                    END IF;
                SET na_count=na_count+1;
                END LOOP noticias_loop;
            CLOSE noticia_cursor;
            SET fin=0;
            SELECT CONCAT('El autor ', vautor, ' tiene ', na_count, ' noticias');
        END LOOP autor_loop;
    CLOSE autor_cursor;
END;$$

CALL ejercicio();

/* MySQL documentation sample with cursor */
CREATE PROCEDURE curdemo()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE a CHAR(16);
  DECLARE b,c INT;
  DECLARE cur1 CURSOR FOR SELECT id,data FROM test.t1;
  DECLARE cur2 CURSOR FOR SELECT i FROM test.t2;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

  OPEN cur1;
  OPEN cur2;

  REPEAT
    FETCH cur1 INTO a, b;
    FETCH cur2 INTO c;
    IF NOT done THEN
       IF b < c THEN
          INSERT INTO test.t3 VALUES (a,b);
       ELSE
          INSERT INTO test.t3 VALUES (a,c);
       END IF;
    END IF;
  UNTIL done END REPEAT;

  CLOSE cur1;
  CLOSE cur2;
END;