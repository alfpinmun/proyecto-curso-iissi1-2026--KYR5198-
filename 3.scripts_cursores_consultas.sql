USE pizzeria_iissi1;

SET @clienteId = 1;
SET @tiendaId = 1;
SET @pizzaId = 1;
SET @pedidoId = 1;
SET @repartidorId = 4;

SET @tamano = 'mediana';
SET @precioMaximo = 10.00;

SET @fechaDesde = '2026-11-01';
SET @fechaHasta = '2026-11-30';

SELECT
    p.id AS pizzaId,
    tp.nombre,
    tp.tamano,
    p.precio
FROM Pizza p
JOIN TipoPizza tp
    ON tp.id = p.TipoPizzaId
ORDER BY tp.nombre, tp.tamano, p.id;

SELECT
    p.id AS pizzaId,
    tp.nombre AS nombrePizza,
    tp.tamano,
    i.id AS ingredienteId,
    i.nombre AS ingrediente
FROM Pizza p
JOIN TipoPizza tp
    ON tp.id = p.TipoPizzaId
JOIN PizzaIngrediente pi
    ON pi.pizzaId = p.id
JOIN Ingrediente i
    ON i.id = pi.ingredienteId
WHERE p.id = @pizzaId
ORDER BY i.nombre;

SELECT
    p.id AS pedidoId,
    p.fechaInicio,
    p.estado,
    p.tiendaId,
    fn_importe_pedido(p.id) AS importeTotal
FROM Pedido p
WHERE p.clienteId = @clienteId
ORDER BY p.fechaInicio DESC, p.id DESC;

SELECT
    lp.pedidoId,
    lp.pizzaId,
    tp.nombre AS nombrePizza,
    tp.tamano,
    lp.cantidad,
    lp.precioUnit,
    lp.cantidad * lp.precioUnit AS importeLinea
FROM LineaPedido lp
JOIN Pedido p
    ON p.id = lp.pedidoId
JOIN Pizza z
    ON z.id = lp.pizzaId
JOIN TipoPizza tp
    ON tp.id = z.TipoPizzaId
WHERE p.id = @pedidoId
  AND p.clienteId = @clienteId
ORDER BY lp.pizzaId;

SELECT
    p.id AS pedidoId,
    p.fechaInicio,
    p.estado,
    u.nombre AS cliente,
    p.cocineroId,
    p.repartidorId,
    fn_importe_pedido(p.id) AS importeTotal
FROM Pedido p
JOIN Cliente c
    ON c.id = p.clienteId
JOIN Usuario u
    ON u.id = c.id
WHERE p.tiendaId = @tiendaId
  AND p.estado IN ('enPreparacion', 'enReparto')
ORDER BY p.fechaInicio, p.id;

SELECT
    p.id AS pedidoId,
    p.estado,
    p.fechaInicio,
    p.fechaFinPreparacion,
    p.fechaEntrega
FROM Pedido p
WHERE p.id = @pedidoId
  AND p.clienteId = @clienteId;

SELECT
    e.id AS empleadoId,
    u.nombre,
    e.tiendaId,
    CASE
        WHEN c.id IS NOT NULL AND r.id IS NOT NULL
            THEN 'Cocinero y repartidor: revisar'
        WHEN c.id IS NOT NULL
            THEN 'Cocinero'
        WHEN r.id IS NOT NULL
            THEN 'Repartidor'
        ELSE 'Sin categoria'
    END AS categoria
FROM Empleado e
JOIN Usuario u
    ON u.id = e.id
LEFT JOIN Cocinero c
    ON c.id = e.id
LEFT JOIN Repartidor r
    ON r.id = e.id
WHERE e.tiendaId = @tiendaId
ORDER BY u.nombre, e.id;

SELECT
    c.id AS cocineroId,
    u.nombre,
    e.tiendaId
FROM Cocinero c
JOIN Empleado e
    ON e.id = c.id
JOIN Usuario u
    ON u.id = e.id
WHERE e.tiendaId = @tiendaId
ORDER BY u.nombre, c.id;

SELECT
    r.id AS repartidorId,
    u.nombre,
    e.tiendaId
FROM Repartidor r
JOIN Empleado e
    ON e.id = r.id
JOIN Usuario u
    ON u.id = e.id
WHERE e.tiendaId = @tiendaId
ORDER BY u.nombre, r.id;

SELECT
    p.id AS pedidoId,
    p.fechaInicio,
    p.estado,
    p.tiendaId,
    u.nombre AS cliente,
    c.direccion,
    c.codigoPostal
FROM Pedido p
JOIN Cliente c
    ON c.id = p.clienteId
JOIN Usuario u
    ON u.id = c.id
WHERE p.repartidorId = @repartidorId
ORDER BY p.fechaInicio, p.id;

SELECT
    p.id AS pedidoId,
    p.fechaInicio,
    p.estado,
    fn_importe_pedido(p.id) AS importeTotal
FROM Pedido p
WHERE p.tiendaId = @tiendaId
  AND p.fechaInicio >= @fechaDesde
  AND p.fechaInicio < DATE_ADD(@fechaHasta, INTERVAL 1 DAY)
ORDER BY p.fechaInicio, p.id;

SELECT
    p.id AS pizzaId,
    tp.nombre,
    tp.tamano,
    p.precio
FROM Pizza p
JOIN TipoPizza tp
    ON tp.id = p.TipoPizzaId
WHERE tp.tamano = @tamano
  AND p.precio <= @precioMaximo
ORDER BY p.precio, tp.nombre, p.id;

SELECT
    a.clienteId,
    u.nombre AS cliente,
    i.id AS ingredienteId,
    i.nombre AS ingrediente
FROM Alergia a
JOIN Cliente c
    ON c.id = a.clienteId
JOIN Usuario u
    ON u.id = c.id
JOIN Ingrediente i
    ON i.id = a.ingredienteId
WHERE a.clienteId = @clienteId
ORDER BY i.nombre;

DELIMITER $$

CREATE PROCEDURE sp_resumen_entregados_cursor(
    IN p_tiendaId INT,
    IN p_fechaDesde DATE,
    IN p_fechaHasta DATE,
    OUT p_numPedidos INT,
    OUT p_importeTotal DECIMAL(14,2)
)
READS SQL DATA
BEGIN
    -- Variables utilizadas durante el recorrido.
    DECLARE v_fin BOOLEAN DEFAULT FALSE;
    DECLARE v_pedidoId INT;

    -- El cursor selecciona los pedidos que se recorrerán.
    -- El periodo se aplica a la fecha de realización.
    DECLARE cur_pedidos CURSOR FOR
        SELECT id
        FROM Pedido
        WHERE tiendaId = p_tiendaId
          AND estado = 'entregado'
          AND fechaInicio >= p_fechaDesde
          AND fechaInicio < DATE_ADD(
              p_fechaHasta,
              INTERVAL 1 DAY
          )
        ORDER BY fechaInicio, id;

    -- Cuando FETCH no encuentre más filas,
    -- se marcará el final del recorrido.
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_fin = TRUE;

    -- Inicializar los resultados.
    SET p_numPedidos = 0;
    SET p_importeTotal = 0;

    -- Comprobar que la tienda existe.
    IF NOT EXISTS (
        SELECT 1
        FROM Tienda
        WHERE id = p_tiendaId
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La tienda no existe';
    END IF;

    -- Comprobar el intervalo de fechas.
    IF p_fechaDesde IS NULL
       OR p_fechaHasta IS NULL
       OR p_fechaDesde > p_fechaHasta THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El intervalo de fechas no es valido';
    END IF;

    -- Abrir el cursor.
    OPEN cur_pedidos;

    recorrer_pedidos: LOOP

        -- Obtener el identificador del siguiente pedido.
        FETCH cur_pedidos INTO v_pedidoId;

        -- Salir cuando no queden filas.
        IF v_fin THEN
            LEAVE recorrer_pedidos;
        END IF;

        -- Contar el pedido.
        SET p_numPedidos = p_numPedidos + 1;

        -- Acumular su importe usando la función del script 2.
        SET p_importeTotal =
            p_importeTotal + fn_importe_pedido(v_pedidoId);

    END LOOP recorrer_pedidos;

    -- Cerrar el cursor al finalizar.
    CLOSE cur_pedidos;
END$$

DELIMITER ;


-- =====================================================
-- EJEMPLO DE USO
-- =====================================================

-- CALL sp_resumen_entregados_cursor(
--     1,
--     '2026-11-01',
--     '2026-11-30',
--     @numeroPedidos,
--     @importeTotal
-- );

-- SELECT
--     @numeroPedidos AS pedidosEntregados,
--     @importeTotal AS importeTotal;
