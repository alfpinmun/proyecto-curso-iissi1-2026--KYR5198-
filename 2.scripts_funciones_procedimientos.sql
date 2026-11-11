USE pizzeria_iissi1;

DELIMITER $$

CREATE FUNCTION fn_importe_pedido(p_pedidoId INT)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_importe DECIMAL(14,2);

    IF NOT EXISTS (
        SELECT 1
        FROM Pedido
        WHERE id = p_pedidoId
    ) THEN
        RETURN NULL;
    END IF;

    SELECT COALESCE(SUM(cantidad * precioUnit), 0)
    INTO v_importe
    FROM LineaPedido
    WHERE pedidoId = p_pedidoId;

    RETURN v_importe;
END$$

CREATE FUNCTION fn_minutos_entrega(p_pedidoId INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_minutos INT DEFAULT NULL;

    IF NOT EXISTS (
        SELECT 1
        FROM Pedido
        WHERE id = p_pedidoId
    ) THEN
        RETURN NULL;
    END IF;

    SELECT TIMESTAMPDIFF(
        MINUTE,
        fechaInicio,
        fechaEntrega
    )
    INTO v_minutos
    FROM Pedido
    WHERE id = p_pedidoId;

    RETURN v_minutos;
END$$

CREATE FUNCTION fn_pizza_incompatible(
    p_clienteId INT,
    p_pizzaId INT
)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Cliente
        WHERE id = p_clienteId
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM Pizza
        WHERE id = p_pizzaId
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La pizza no existe';
    END IF;

    RETURN EXISTS (
        SELECT 1
        FROM Alergia a
        JOIN PizzaIngrediente pi
            ON pi.ingredienteId = a.ingredienteId
        WHERE a.clienteId = p_clienteId
          AND pi.pizzaId = p_pizzaId
    );
END$$

CREATE PROCEDURE sp_crear_pedido_con_linea(
    IN p_clienteId INT,
    IN p_tiendaId INT,
    IN p_cocineroId INT,
    IN p_repartidorId INT,
    IN p_pizzaId INT,
    IN p_cantidad INT,
    OUT p_pedidoId INT
)
MODIFIES SQL DATA
BEGIN
    DECLARE v_tiendaCocinero INT DEFAULT NULL;
    DECLARE v_tiendaRepartidor INT DEFAULT NULL;
    DECLARE v_precio DECIMAL(4,2) DEFAULT NULL;

    -- Ante un error, deshacer los cambios y comunicarlo.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_pedidoId = NULL;
        RESIGNAL;
    END;

    SET p_pedidoId = NULL;

    START TRANSACTION;

    IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad debe ser positiva';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM Tienda
        WHERE id = p_tiendaId
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La tienda no existe';
    END IF;

    SELECT e.tiendaId
    INTO v_tiendaCocinero
    FROM Empleado e
    JOIN Cocinero c ON c.id = e.id
    WHERE c.id = p_cocineroId
    FOR UPDATE;

    IF v_tiendaCocinero IS NULL
       OR v_tiendaCocinero <> p_tiendaId THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'El cocinero no existe o no pertenece a la tienda';
    END IF;

    SELECT e.tiendaId
    INTO v_tiendaRepartidor
    FROM Empleado e
    JOIN Repartidor r ON r.id = e.id
    WHERE r.id = p_repartidorId
    FOR UPDATE;

    IF v_tiendaRepartidor IS NULL
       OR v_tiendaRepartidor <> p_tiendaId THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'El repartidor no existe o no pertenece a la tienda';
    END IF;

    SELECT precio
    INTO v_precio
    FROM Pizza
    WHERE id = p_pizzaId
    FOR UPDATE;

    IF v_precio IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La pizza no existe';
    END IF;

    IF fn_pizza_incompatible(p_clienteId, p_pizzaId) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'El cliente es alergico a un ingrediente de la pizza';
    END IF;

    INSERT INTO Pedido (
        fechaInicio,
        fechaFinPreparacion,
        fechaEntrega,
        estado,
        tiendaId,
        clienteId,
        repartidorId,
        cocineroId
    )
    VALUES (
        NOW(),
        NULL,
        NULL,
        'enPreparacion',
        p_tiendaId,
        p_clienteId,
        p_repartidorId,
        p_cocineroId
    );

    SET p_pedidoId = LAST_INSERT_ID();

    INSERT INTO LineaPedido (
        cantidad,
        precioUnit,
        pedidoId,
        pizzaId
    )
    VALUES (
        p_cantidad,
        v_precio,
        p_pedidoId,
        p_pizzaId
    );

    COMMIT;
END$$

CREATE PROCEDURE sp_anadir_pizza_pedido(
    IN p_pedidoId INT,
    IN p_pizzaId INT,
    IN p_cantidad INT
)
MODIFIES SQL DATA
BEGIN
    DECLARE v_estado VARCHAR(20) DEFAULT NULL;
    DECLARE v_clienteId INT;
    DECLARE v_precio DECIMAL(4,2) DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad debe ser positiva';
    END IF;

    SELECT estado, clienteId
    INTO v_estado, v_clienteId
    FROM Pedido
    WHERE id = p_pedidoId
    FOR UPDATE;

    IF v_estado IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido no existe';
    END IF;

    IF v_estado <> 'enPreparacion' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Solo se anaden pizzas a pedidos en preparacion';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM LineaPedido
        WHERE pedidoId = p_pedidoId
          AND pizzaId = p_pizzaId
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Esta pizza ya tiene una linea en el pedido';
    END IF;

    SELECT precio
    INTO v_precio
    FROM Pizza
    WHERE id = p_pizzaId
    FOR UPDATE;

    IF v_precio IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La pizza no existe';
    END IF;

    IF fn_pizza_incompatible(v_clienteId, p_pizzaId) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'El cliente es alergico a un ingrediente de la pizza';
    END IF;

    INSERT INTO LineaPedido (
        cantidad,
        precioUnit,
        pedidoId,
        pizzaId
    )
    VALUES (
        p_cantidad,
        v_precio,
        p_pedidoId,
        p_pizzaId
    );

    COMMIT;
END$$

CREATE PROCEDURE sp_avanzar_estado_pedido(
    IN p_pedidoId INT,
    IN p_nuevoEstado VARCHAR(20),
    IN p_fecha DATETIME
)
MODIFIES SQL DATA
BEGIN
    DECLARE v_estado VARCHAR(20) DEFAULT NULL;
    DECLARE v_inicio DATETIME;
    DECLARE v_finPreparacion DATETIME;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF p_fecha IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha del cambio es obligatoria';
    END IF;

    SELECT estado, fechaInicio, fechaFinPreparacion
    INTO v_estado, v_inicio, v_finPreparacion
    FROM Pedido
    WHERE id = p_pedidoId
    FOR UPDATE;

    IF v_estado IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido no existe';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM LineaPedido
        WHERE pedidoId = p_pedidoId
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido debe contener alguna linea';
    END IF;

    IF v_estado = 'enPreparacion'
       AND p_nuevoEstado = 'enReparto' THEN

        IF p_fecha < v_inicio THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'La preparacion no puede finalizar antes del inicio';
        END IF;

        UPDATE Pedido
        SET estado = 'enReparto',
            fechaFinPreparacion = p_fecha,
            fechaEntrega = NULL
        WHERE id = p_pedidoId;

    ELSEIF v_estado = 'enReparto'
       AND p_nuevoEstado = 'entregado' THEN

        IF v_finPreparacion IS NULL
           OR p_fecha < v_finPreparacion THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'La entrega requiere una fecha valida de fin de preparacion';
        END IF;

        UPDATE Pedido
        SET estado = 'entregado',
            fechaEntrega = p_fecha
        WHERE id = p_pedidoId;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cambio de estado no permitido';
    END IF;

    COMMIT;
END$$

DELIMITER ;


-- =====================================================
-- EJEMPLOS DE USO
-- =====================================================

-- Consultar el importe de un pedido:
-- SELECT fn_importe_pedido(1);

-- Consultar sus minutos de entrega:
-- SELECT fn_minutos_entrega(1);

-- Comprobar la incompatibilidad del cliente 2 con la pizza 2:
-- SELECT fn_pizza_incompatible(2, 2);

-- Crear un pedido con dos unidades de la pizza 1:
-- Cliente 1, tienda 1, cocinero 3 y repartidor 4.
-- CALL sp_crear_pedido_con_linea(
--     1, 1, 3, 4, 1, 2, @nuevoPedido
-- );

-- Consultar el identificador generado:
-- SELECT @nuevoPedido;

-- Añadir una unidad de otra pizza:
-- CALL sp_anadir_pizza_pedido(@nuevoPedido, 2, 1);

-- Consultar el importe:
-- SELECT fn_importe_pedido(@nuevoPedido);

-- Finalizar la preparación y pasar a reparto:
-- CALL sp_avanzar_estado_pedido(
--     @nuevoPedido, 'enReparto', NOW()
-- );

-- Registrar la entrega:
-- CALL sp_avanzar_estado_pedido(
--     @nuevoPedido, 'entregado', NOW()
-- );
