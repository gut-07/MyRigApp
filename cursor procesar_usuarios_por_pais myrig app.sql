DELIMITER //

CREATE PROCEDURE procesar_usuarios_por_pais()
BEGIN
    -- Declarar variables
    DECLARE done INT DEFAULT FALSE;
    DECLARE user_id INT;
    DECLARE user_name VARCHAR(45);
    DECLARE user_email VARCHAR(45);
    DECLARE country_name VARCHAR(45);
    
    -- Declarar el cursor
    DECLARE user_cursor CURSOR FOR 
        SELECT u.idUsuario, u.Nombre, u.Email, p.NombrePais
        FROM Usuario u
        JOIN Paises p ON u.idPais = p.idPais
        ORDER BY p.NombrePais, u.Nombre;
    
    -- Declarar manejador para cuando no haya más filas
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Crear tabla temporal para resultados
    CREATE TEMPORARY TABLE IF NOT EXISTS resultados_procesamiento (
        id_usuario INT,
        nombre_usuario VARCHAR(45),
        email_usuario VARCHAR(45),
        pais_usuario VARCHAR(45),
        fecha_procesamiento DATETIME
    );
    
    -- Abrir el cursor
    OPEN user_cursor;
    
    -- Iniciar bucle de lectura
    read_loop: LOOP
        -- Obtener siguiente fila
        FETCH user_cursor INTO user_id, user_name, user_email, country_name;
        
        -- Salir del bucle si no hay más filas
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Procesar la fila (ejemplo: insertar en tabla temporal)
        INSERT INTO resultados_procesamiento
        VALUES (user_id, user_name, user_email, country_name, NOW());
        
        -- Aquí podrías añadir más lógica de procesamiento
    END LOOP;
    
    -- Cerrar el cursor
    CLOSE user_cursor;
    
    -- Mostrar resultados
    SELECT * FROM resultados_procesamiento;
    
    -- Eliminar tabla temporal (opcional)
    DROP TEMPORARY TABLE IF EXISTS resultados_procesamiento;
END //

DELIMITER ;