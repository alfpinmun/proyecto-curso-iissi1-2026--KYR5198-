USE pizzeria_iissi1;

DELIMITER $$

CREATE TRIGGER trg_cocinero_insert_categoria
BEFORE INSERT ON Cocinero
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Repartidor
        WHERE id = NEW.id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'El empleado ya esta registrado como repartidor';
    END IF;
END$$

CREATE TRIGGER trg_cocinero_update_categoria
BEFORE UPDATE ON Cocinero
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Repartidor
        WHERE id = NEW.id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'El empleado ya esta registrado como repartidor';
    END IF;
END$$

CREATE TRIGGER trg_repartidor_insert_categoria
BEFORE INSERT ON Repartidor
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Cocinero
        WHERE id = NEW.id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'El empleado ya esta registrado como cocinero';
    END IF;
END$$

CREATE TRIGGER trg_repartidor_update_categoria
BEFORE UPDATE ON Repartidor
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Cocinero
        WHERE id = NEW.id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'El empleado ya esta registrado como cocinero';
    END IF;
END$$

CREATE TRIGGER trg_pedido_insert_validar
BEFORE INSERT ON Pedido
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Cocinero c
        JOIN Empleado e ON e.id = c.id
        WHERE c.id = NEW.cocineroId
          AND e.tiendaId = NEW.tiendaId
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'El cocinero no pertenece a la tienda del pedido';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM Repartidor r
        JOIN Empleado e ON e.id = r.id
        WHERE r.id = NEW.repartidorId
          AND e.tiendaId = NEW.tiendaId
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'El repartidor no pertenece a la tienda del pedido';
    END IF;

    IF NEW.fechaInicio IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de inicio es obligatoria';
    END IF;

    IF NEW.estado = 'enPreparacion' THEN

        IF NEW.fechaFinPreparacion IS NOT NULL
           OR NEW.fechaEntrega IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Un pedido en preparacion no puede tener fechas de finalizacion o entrega';
        END IF;

    ELSEIF NEW.estado = 'enReparto' THEN

        IF NEW.fechaFinPreparacion IS NULL
           OR NEW.fechaEntrega IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Un pedido en reparto requiere fin de preparacion y no tiene entrega';
        END IF;

    ELSEIF NEW.estado = 'entregado' THEN

        IF NEW.fechaFinPreparacion IS NULL
           OR NEW.fechaEntrega IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Un pedido entregado requiere las fechas de preparacion y entrega';
        END IF;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estado de pedido no valido';
    END IF;

    IF NEW.fechaFinPreparacion < NEW.fechaInicio THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'La preparacion no puede finalizar antes del inicio';
    END IF;

    IF NEW.fechaEntrega < NEW.fechaFinPreparacion THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'La entrega no puede ser anterior al fin de preparacion';
    END IF;
END$$

CREATE TRIGGER trg_pedido_update_validar
BEFORE UPDATE ON Pedido
FOR EACH ROW
BEGIN
    -- Conservar los datos que identifican la operación.
    IF NOT (NEW.id <=> OLD.id)
       OR NOT (NEW.clienteId <=> OLD.clienteId)
       OR NOT (NEW.tiendaId <=> OLD.tiendaId)
       OR NOT (NEW.fechaInicio <=> OLD.fechaInicio) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'No se cambia el identificador, cliente, tienda o fecha inicial del pedido';
    END IF;

    -- Los pedidos entregados quedan cerrados.
    IF OLD.estado = 'entregado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'No se modifica un pedido ya entregado';
    END IF;

    -- Comprobar una nueva asignación de cocinero.
    IF NOT (NEW.cocineroId <=> OLD.cocineroId) THEN

        IF OLD.estado <> 'enPreparacion' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Solo se cambia el cocinero durante la preparacion';
        END IF;

        IF NOT EXISTS (
            SELECT 1
            FROM Cocinero c
            JOIN Empleado e ON e.id = c.id
            WHERE c.id = NEW.cocineroId
              AND e.tiendaId = NEW.tiendaId
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'El nuevo cocinero no pertenece a la tienda';
        END IF;
    END IF;

    -- Comprobar una nueva asignación de repartidor.
    IF NOT (NEW.repartidorId <=> OLD.repartidorId) THEN

        IF NOT EXISTS (
            SELECT 1
            FROM Repartidor r
            JOIN Empleado e ON e.id = r.id
            WHERE r.id = NEW.repartidorId
              AND e.tiendaId = NEW.tiendaId
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'El nuevo repartidor no pertenece a la tienda';
        END IF;
    END IF;

    -- Permitir únicamente los avances previstos.
    IF NOT (NEW.estado <=> OLD.estado) THEN

        IF NOT (
            (OLD.estado = 'enPreparacion'
             AND NEW.estado = 'enReparto')
            OR
            (OLD.estado = 'enReparto'
             AND NEW.estado = 'entregado')
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cambio de estado no permitido';
        END IF;
    END IF;

    -- No avanzar pedidos sin productos.
    IF NEW.estado IN ('enReparto', 'entregado')
       AND NOT EXISTS (
           SELECT 1
           FROM LineaPedido
           WHERE pedidoId = OLD.id
       ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'El pedido debe contener al menos una linea';
    END IF;

    -- Conservar la fecha de preparación ya registrada.
    IF OLD.estado = 'enReparto'
       AND NOT (
           NEW.fechaFinPreparacion <=> OLD.fechaFinPreparacion
       ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'No se cambia una fecha de fin de preparacion ya registrada';
    END IF;

    IF NEW.estado = 'enPreparacion' THEN

        IF NEW.fechaFinPreparacion IS NOT NULL
           OR NEW.fechaEntrega IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Un pedido en preparacion no puede tener fechas de finalizacion o entrega';
        END IF;

    ELSEIF NEW.estado = 'enReparto' THEN

        IF NEW.fechaFinPreparacion IS NULL
           OR NEW.fechaEntrega IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Un pedido en reparto requiere fin de preparacion y no tiene entrega';
        END IF;

    ELSEIF NEW.estado = 'entregado' THEN

        IF NEW.fechaFinPreparacion IS NULL
           OR NEW.fechaEntrega IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Un pedido entregado requiere las fechas de preparacion y entrega';
        END IF;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estado de pedido no valido';
    END IF;

    IF NEW.fechaFinPreparacion < NEW.fechaInicio THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'La preparacion no puede finalizar antes del inicio';
    END IF;

    IF NEW.fechaEntrega < NEW.fechaFinPreparacion THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'La entrega no puede ser anterior al fin de preparacion';
    END IF;
END$$

CREATE TRIGGER trg_linea_insert_alergias
BEFORE INSERT ON LineaPedido
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Pedido p
        JOIN Alergia a
            ON a.clienteId = p.clienteId
        JOIN PizzaIngrediente pi
            ON pi.ingredienteId = a.ingredienteId
        WHERE p.id = NEW.pedidoId
          AND pi.pizzaId = NEW.pizzaId
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'La pizza contiene un ingrediente al que el cliente es alergico';
    END IF;
END$$

CREATE TRIGGER trg_linea_update_validar
BEFORE UPDATE ON LineaPedido
FOR EACH ROW
BEGIN
    IF NOT (NEW.pedidoId <=> OLD.pedidoId)
       OR NOT (NEW.pizzaId <=> OLD.pizzaId)
       OR NOT (NEW.precioUnit <=> OLD.precioUnit) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Solo se puede modificar la cantidad de una linea';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM Pedido
        WHERE id = OLD.pedidoId
          AND estado = 'enPreparacion'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Solo se modifican lineas de pedidos en preparacion';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Pedido p
        JOIN Alergia a
            ON a.clienteId = p.clienteId
        JOIN PizzaIngrediente pi
            ON pi.ingredienteId = a.ingredienteId
        WHERE p.id = NEW.pedidoId
          AND pi.pizzaId = NEW.pizzaId
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'La pizza contiene un ingrediente al que el cliente es alergico';
    END IF;
END$$



CREATE TRIGGER trg_linea_delete_validar
BEFORE DELETE ON LineaPedido
FOR EACH ROW
BEGIN
    DECLARE v_numLineas INT;

    IF NOT EXISTS (
        SELECT 1
        FROM Pedido
        WHERE id = OLD.pedidoId
          AND estado = 'enPreparacion'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Solo se eliminan lineas de pedidos en preparacion';
    END IF;

    SELECT COUNT(*)
    INTO v_numLineas
    FROM LineaPedido
    WHERE pedidoId = OLD.pedidoId;

    IF v_numLineas <= 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'No se puede eliminar la ultima linea del pedido';
    END IF;
END$$

DELIMITER ;

SHOW TRIGGERS FROM pizzeria_iissi1;
-- =====================================================
-- EJEMPLOS DE PRUEBA
-- =====================================================

-- Un cocinero no puede ser también repartidor:
-- INSERT INTO Repartidor (id) VALUES (3);

-- Un repartidor no puede ser también cocinero:
-- INSERT INTO Cocinero (id) VALUES (4);

-- No se permite saltar de preparación a entregado:
-- UPDATE Pedido
-- SET estado = 'entregado',
--     fechaFinPreparacion = NOW(),
--     fechaEntrega = NOW()
-- WHERE id = 2;

-- No se permite eliminar la única línea de un pedido:
-- DELETE FROM LineaPedido
-- WHERE pedidoId = 2 AND pizzaId = 3;

-- No se cambia el precio aplicado a una línea:
-- UPDATE LineaPedido
-- SET precioUnit = 1.00
-- WHERE pedidoId = 2 AND pizzaId = 3;
