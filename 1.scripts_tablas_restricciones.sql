CREATE TABLE Usuario (
	id INT PRIMARY KEY AUTO_INCREMENT,
	dni VARCHAR(9) NOT NULL UNIQUE,
	nombre VARCHAR(20) NOT NULL,
	contrasena VARCHAR(30) NOT NULL
);

CREATE TABLE Tienda (
	id INT PRIMARY KEY AUTO_INCREMENT,
	direccion VARCHAR(100) NOT NULL,
	codigoPostal VARCHAR(5) NOT NULL,
	CHECK (codigoPostal REGEXP '^[0-9]{5}$')
);

CREATE TABLE Ingrediente (
	id INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(30) NOT NULL UNIQUE,
	precio DECIMAL(4,2) NOT NULL,
	CHECK (precio > 0)
);

CREATE TABLE TipoPizza (
	id INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(20) NOT NULL,
	precio DECIMAL(4,2) NOT NULL,
	tamano ENUM('pequena', 'mediana', 'grande') NOT NULL,
	UNIQUE (nombre, tamano),
	CHECK (precio > 0)
);

CREATE TABLE Cliente (
	id INT PRIMARY KEY,
	direccion VARCHAR(100) NOT NULL,
	codigoPostal VARCHAR(5) NOT NULL,
	FOREIGN KEY (id) REFERENCES Usuario(id),
	CHECK (codigoPostal REGEXP '^[0-9]{5}$')
);

CREATE TABLE Empleado (
	id INT PRIMARY KEY,
	tiendaId INT NOT NULL,
	FOREIGN KEY (id) REFERENCES Usuario(id),
	FOREIGN KEY (tiendaId) REFERENCES Tienda(id)
);

CREATE TABLE Cocinero (
	id INT PRIMARY KEY,
	FOREIGN KEY (id) REFERENCES Empleado(id)
);

CREATE TABLE Repartidor (
	id INT PRIMARY KEY,
	FOREIGN KEY (id) REFERENCES Empleado(id)
);

CREATE TABLE Pizza (
	id INT PRIMARY KEY AUTO_INCREMENT,
	precio DECIMAL(4,2) NOT NULL,
	TipoPizzaId INT NOT NULL,
	FOREIGN KEY (TipoPizzaId) REFERENCES TipoPizza(id),
	CHECK (precio > 0)
);

CREATE TABLE Pedido (
	id INT PRIMARY KEY AUTO_INCREMENT,
	fechaInicio DATETIME NOT NULL,
	fechaFinPreparacion DATETIME,
	fechaEntrega DATETIME,
	estado ENUM('enPreparacion', 'enReparto', 'entregado') NOT NULL,
	tiendaId INT NOT NULL,
	clienteId INT NOT NULL,
	repartidorId INT NOT NULL,
	cocineroId INT NOT NULL,
	FOREIGN KEY (tiendaId) REFERENCES Tienda(id),
	FOREIGN KEY (clienteId) REFERENCES Cliente(id),
	FOREIGN KEY (repartidorId) REFERENCES Repartidor(id),
	FOREIGN KEY (cocineroId) REFERENCES Cocinero(id),
	CHECK (fechaFinPreparacion >= fechaInicio),
	CHECK (fechaEntrega >= fechaFinPreparacion)
);

CREATE TABLE LineaPedido (
	cantidad INT NOT NULL,
	precioUnit DECIMAL(4,2) NOT NULL,
	pedidoId INT NOT NULL,
	pizzaId INT NOT NULL,
	PRIMARY KEY (pedidoId, pizzaId),
	FOREIGN KEY (pedidoId) REFERENCES Pedido(id),
	FOREIGN KEY (pizzaId) REFERENCES Pizza(id),
	CHECK (precioUnit > 0),
	CHECK (cantidad > 0)
);

CREATE TABLE PizzaIngrediente (
	pizzaId INT NOT NULL,
	ingredienteId INT NOT NULL,
	PRIMARY KEY (pizzaId, ingredienteId),
	FOREIGN KEY (pizzaId) REFERENCES Pizza(id),
	FOREIGN KEY (ingredienteId) REFERENCES Ingrediente(id)
);

CREATE TABLE Alergia (
	clienteId INT NOT NULL,
	ingredienteId INT NOT NULL,
	PRIMARY KEY (clienteId, ingredienteId),
	FOREIGN KEY (clienteId) REFERENCES Cliente(id),
	FOREIGN KEY (ingredienteId) REFERENCES Ingrediente(id)
);
