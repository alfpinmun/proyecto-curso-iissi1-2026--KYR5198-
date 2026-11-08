USE pizzeria_iissi1;

INSERT INTO Ingrediente (nombre, precio) VALUES
    ('Tomate', 0.50),
    ('Mozzarella', 1.00),
    ('Albahaca', 0.30),
    ('Carne', 2.00),
    ('Salsa barbacoa', 0.80);

INSERT INTO Tienda (direccion, codigoPostal) VALUES
	('Calle Sierpes 10', '41004'),
	('Avenida de la Constitución 5', '41001');
	
INSERT INTO Tipopizza (nombre, precio, tamano) VALUES
	('Margarita', 6.00, 'pequena'),
	('Margarita', 8.50, 'mediana'),
	('Barbacoa', 10.00, 'mediana'),
	('Barbacoa', 12.50, 'grande');

INSERT INTO Usuario (dni, nombre, contrasena) VALUES
	('11111111A', 'Juan', '1234'),
	('22222222B', 'Ana', '1234'),
	('33333333C', 'Luis', '1234'),
	('44444444D', 'Marta', '1234'),
	('55555555E', 'Pablo', '1234'),
	('66666666F', 'Lucia', '1234');

INSERT INTO Cliente (id, direccion, codigoPostal) VALUES
    (1, 'Calle Betis 12', '41010'),
    (2, 'Calle Feria 7', '41002');

INSERT INTO Empleado (id, tiendaId) VALUES
    (3, 2),
    (4, 2),
    (5, 3),
    (6, 3);

INSERT INTO Cocinero (id) VALUES
    (3),
    (5);

INSERT INTO Repartidor (id) VALUES
    (4),
    (6);

INSERT INTO Pizza (precio, TipoPizzaId) VALUES
    (8.50, 2),
    (12.50, 4),
    (10.50, 2);

INSERT INTO PizzaIngrediente (pizzaId, ingredienteId) VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 1),
    (2, 2),
    (2, 4),
    (2, 5),
    (3, 1),
    (3, 2),
    (3, 3),
    (3, 4);

INSERT INTO Pedido (clienteId, tiendaId, cocineroId, repartidorId, fechaInicio, fechaFinPreparacion, fechaEntrega, estado) VALUES
    (1, 2, 3, 4, '2026-11-08 13:00:00', '2026-11-08 13:20:00', '2026-11-08 13:45:00', 'entregado'),
    (2, 3, 5, 6, '2026-11-08 14:00:00', NULL, NULL, 'enPreparacion');

INSERT INTO LineaPedido (pedidoId, pizzaId, cantidad, precioUnit) VALUES
    (1, 1, 2, 8.50),
    (1, 2, 1, 12.50),
    (2, 3, 1, 10.50);

INSERT INTO Alergia (clienteId, ingredienteId) VALUES
    (2, 5);
