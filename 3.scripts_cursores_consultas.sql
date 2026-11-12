USE pizzeria_iissi1;

SET @fechaDesde = '2026-11-01';
SET @fechaHasta = '2026-11-30';
SET @clienteId = 1;
SET @tiendaId = 1;
SET @importeMinimo = 20.00;

SELECT
    t.id AS tiendaId,
    t.direccion,
    COUNT(v.pedidoId) AS pedidosEntregados,
    COALESCE(SUM(v.importe), 0) AS facturacion,
    COALESCE(ROUND(AVG(v.importe), 2), 0) AS importeMedio
FROM Tienda AS t
LEFT JOIN (
    SELECT
        p.id AS pedidoId,
        p.tiendaId,
        COALESCE(SUM(lp.cantidad * lp.precioUnit), 0) AS importe
    FROM Pedido AS p
    LEFT JOIN LineaPedido AS lp
        ON lp.pedidoId = p.id
    WHERE p.estado = 'entregado'
      AND p.fechaEntrega >= @fechaDesde
      AND p.fechaEntrega < DATE_ADD(@fechaHasta, INTERVAL 1 DAY)
    GROUP BY p.id, p.tiendaId
) AS v
    ON v.tiendaId = t.id
GROUP BY t.id, t.direccion
ORDER BY facturacion DESC, t.id;

SELECT
    c.id AS clienteId,
    u.nombre,
    COUNT(DISTINCT p.id) AS pedidosEntregados,
    SUM(lp.cantidad) AS unidadesCompradas,
    SUM(lp.cantidad * lp.precioUnit) AS gastoTotal
FROM Cliente AS c
INNER JOIN Usuario AS u
    ON u.id = c.id
INNER JOIN Pedido AS p
    ON p.clienteId = c.id
INNER JOIN LineaPedido AS lp
    ON lp.pedidoId = p.id
WHERE p.estado = 'entregado'
  AND p.fechaEntrega >= @fechaDesde
  AND p.fechaEntrega < DATE_ADD(@fechaHasta, INTERVAL 1 DAY)
GROUP BY c.id, u.nombre
HAVING SUM(lp.cantidad * lp.precioUnit) > @importeMinimo
ORDER BY gastoTotal DESC, c.id;

SELECT
    tp.id AS tipoPizzaId,
    tp.nombre,
    tp.tamano,
    SUM(lp.cantidad) AS unidadesVendidas,
    COUNT(DISTINCT p.id) AS numeroPedidos,
    SUM(lp.cantidad * lp.precioUnit) AS ingresos
FROM TipoPizza AS tp
INNER JOIN Pizza AS pi
    ON pi.TipoPizzaId = tp.id
INNER JOIN LineaPedido AS lp
    ON lp.pizzaId = pi.id
INNER JOIN Pedido AS p
    ON p.id = lp.pedidoId
WHERE p.estado = 'entregado'
  AND p.fechaEntrega >= @fechaDesde
  AND p.fechaEntrega < DATE_ADD(@fechaHasta, INTERVAL 1 DAY)
GROUP BY tp.id, tp.nombre, tp.tamano
ORDER BY unidadesVendidas DESC, ingresos DESC, tp.id;

SELECT
    p.id AS pedidoId,
    u.nombre AS cliente,
    t.direccion AS tienda,
    p.fechaEntrega,
    fn_importe_pedido(p.id) AS importe
FROM Pedido AS p
INNER JOIN Cliente AS c
    ON c.id = p.clienteId
INNER JOIN Usuario AS u
    ON u.id = c.id
INNER JOIN Tienda AS t
    ON t.id = p.tiendaId
WHERE p.estado = 'entregado'
  AND p.fechaEntrega >= @fechaDesde
  AND p.fechaEntrega < DATE_ADD(@fechaHasta, INTERVAL 1 DAY)
  AND fn_importe_pedido(p.id) > (
      SELECT AVG(fn_importe_pedido(p2.id))
      FROM Pedido AS p2
      WHERE p2.estado = 'entregado'
        AND p2.fechaEntrega >= @fechaDesde
        AND p2.fechaEntrega < DATE_ADD(
            @fechaHasta,
            INTERVAL 1 DAY
        )
  )
ORDER BY importe DESC, p.id;

SELECT
    c.id AS clienteId,
    u.nombre,
    c.direccion,
    c.codigoPostal
FROM Cliente AS c
INNER JOIN Usuario AS u
    ON u.id = c.id
WHERE NOT EXISTS (
    SELECT 1
    FROM Pedido AS p
    WHERE p.clienteId = c.id
      AND p.fechaInicio >= @fechaDesde
      AND p.fechaInicio < DATE_ADD(@fechaHasta, INTERVAL 1 DAY)
)
ORDER BY u.nombre, c.id;

SELECT
    pi.id AS pizzaId,
    tp.nombre,
    tp.tamano,
    pi.precio,
    COUNT(i.id) AS numeroIngredientes,
    COALESCE(
        GROUP_CONCAT(
            i.nombre
            ORDER BY i.nombre
            SEPARATOR ', '
        ),
        'Sin ingredientes registrados'
    ) AS ingredientes
FROM Pizza AS pi
INNER JOIN TipoPizza AS tp
    ON tp.id = pi.TipoPizzaId
LEFT JOIN PizzaIngrediente AS pin
    ON pin.pizzaId = pi.id
LEFT JOIN Ingrediente AS i
    ON i.id = pin.ingredienteId
WHERE EXISTS (
    SELECT 1
    FROM Cliente AS c
    WHERE c.id = @clienteId
)
AND NOT EXISTS (
    SELECT 1
    FROM PizzaIngrediente AS pin2
    INNER JOIN Alergia AS a
        ON a.ingredienteId = pin2.ingredienteId
    WHERE pin2.pizzaId = pi.id
      AND a.clienteId = @clienteId
)
GROUP BY pi.id, tp.nombre, tp.tamano, pi.precio
ORDER BY pi.precio, pi.id;

SELECT
    r.id AS repartidorId,
    u.nombre,
    COUNT(p.id) AS pedidosEntregados,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                p.fechaFinPreparacion,
                p.fechaEntrega
            )
        ),
        2
    ) AS minutosMediosReparto,
    MIN(
        TIMESTAMPDIFF(
            MINUTE,
            p.fechaFinPreparacion,
            p.fechaEntrega
        )
    ) AS minutosMinimosReparto,
    MAX(
        TIMESTAMPDIFF(
            MINUTE,
            p.fechaFinPreparacion,
            p.fechaEntrega
        )
    ) AS minutosMaximosReparto
FROM Repartidor AS r
INNER JOIN Empleado AS e
    ON e.id = r.id
INNER JOIN Usuario AS u
    ON u.id = e.id
LEFT JOIN Pedido AS p
    ON p.repartidorId = r.id
   AND p.estado = 'entregado'
   AND p.fechaEntrega >= @fechaDesde
   AND p.fechaEntrega < DATE_ADD(@fechaHasta, INTERVAL 1 DAY)
GROUP BY r.id, u.nombre
ORDER BY pedidosEntregados DESC, r.id;

SELECT
    c.id AS empleadoId,
    u.nombre,
    'Cocinero' AS categoria,
    COUNT(p.id) AS pedidosAsignados,
    SUM(
        CASE WHEN p.estado = 'enPreparacion' THEN 1 ELSE 0 END
    ) AS enPreparacion,
    SUM(
        CASE WHEN p.estado = 'enReparto' THEN 1 ELSE 0 END
    ) AS enReparto,
    SUM(
        CASE WHEN p.estado = 'entregado' THEN 1 ELSE 0 END
    ) AS entregados
FROM Cocinero AS c
INNER JOIN Empleado AS e
    ON e.id = c.id
INNER JOIN Usuario AS u
    ON u.id = e.id
LEFT JOIN Pedido AS p
    ON p.cocineroId = c.id
   AND p.tiendaId = @tiendaId
   AND p.fechaInicio >= @fechaDesde
   AND p.fechaInicio < DATE_ADD(@fechaHasta, INTERVAL 1 DAY)
WHERE e.tiendaId = @tiendaId
   OR p.id IS NOT NULL
GROUP BY c.id, u.nombre

UNION ALL

SELECT
    r.id AS empleadoId,
    u.nombre,
    'Repartidor' AS categoria,
    COUNT(p.id) AS pedidosAsignados,
    SUM(
        CASE WHEN p.estado = 'enPreparacion' THEN 1 ELSE 0 END
    ) AS enPreparacion,
    SUM(
        CASE WHEN p.estado = 'enReparto' THEN 1 ELSE 0 END
    ) AS enReparto,
    SUM(
        CASE WHEN p.estado = 'entregado' THEN 1 ELSE 0 END
    ) AS entregados
FROM Repartidor AS r
INNER JOIN Empleado AS e
    ON e.id = r.id
INNER JOIN Usuario AS u
    ON u.id = e.id
LEFT JOIN Pedido AS p
    ON p.repartidorId = r.id
   AND p.tiendaId = @tiendaId
   AND p.fechaInicio >= @fechaDesde
   AND p.fechaInicio < DATE_ADD(@fechaHasta, INTERVAL 1 DAY)
WHERE e.tiendaId = @tiendaId
   OR p.id IS NOT NULL
GROUP BY r.id, u.nombre

ORDER BY categoria, pedidosAsignados DESC, empleadoId;

SELECT
    i.id AS ingredienteId,
    i.nombre,
    COUNT(DISTINCT v.pedidoId) AS pedidosConIngrediente,
    COALESCE(SUM(v.cantidad), 0) AS unidadesPizzaConIngrediente
FROM Ingrediente AS i
LEFT JOIN PizzaIngrediente AS pin
    ON pin.ingredienteId = i.id
LEFT JOIN (
    SELECT
        p.id AS pedidoId,
        lp.pizzaId,
        lp.cantidad
    FROM Pedido AS p
    INNER JOIN LineaPedido AS lp
        ON lp.pedidoId = p.id
    WHERE p.estado = 'entregado'
      AND p.fechaEntrega >= @fechaDesde
      AND p.fechaEntrega < DATE_ADD(@fechaHasta, INTERVAL 1 DAY)
) AS v
    ON v.pizzaId = pin.pizzaId
GROUP BY i.id, i.nombre
ORDER BY unidadesPizzaConIngrediente DESC, i.id;

SELECT
    c.id AS clienteId,
    u.nombre
FROM Cliente AS c
INNER JOIN Usuario AS u
    ON u.id = c.id
WHERE EXISTS (
    SELECT 1
    FROM Tienda
)
AND NOT EXISTS (
    SELECT 1
    FROM Tienda AS t
    WHERE NOT EXISTS (
        SELECT 1
        FROM Pedido AS p
        WHERE p.clienteId = c.id
          AND p.tiendaId = t.id
          AND p.estado = 'entregado'
          AND p.fechaEntrega >= @fechaDesde
          AND p.fechaEntrega < DATE_ADD(
              @fechaHasta,
              INTERVAL 1 DAY
          )
    )
)
ORDER BY u.nombre, c.id;
