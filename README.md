# Título Proyecto

## Miembros del grupo LX-XXX-X (sustituir)

1. Pineda Muñoz, Alfonso
2. Tejada González, Gonzalo
3. León Ramos, Mario

## 1. Introducción al problema

- Somos una empresa de pizzerías a domicilio la cual tiene diferentes tiendas asignadas a una ubicación con un código postal. Cada tienda tiene una serie de empleados. Hay 3 tipos de usuarios: admin, cliente y empleado. 
(Hay diferentes tipos de empleados: cocinero y repartidor).
Los clientes deben proporcionar su nombre, DNI y dirección para poder realizar pedidos. El pedido contiene varios atributos: número, tiempo, fecha, fechaEntrega, estado, precio. El estado puede ser entregado o no entregado.
"Los clientes pueden pedir pizzas, y las hay de 3 tamaños: pequeña, mediana, grande. Los clientes podrán personalizar las pizzas al gusto añadiendo o eliminando ingredientes." Éstas pizzas también tienen un precio base, aunque puntualmente puede ser modificado.
Además, los clientes podrán contar con una suscripción que le otorgará prioridad sobre los no suscritos a la hora de la entrega y la elaboración de sus pizzas.
El admin deberá contactar con la línea para comprar al por mayor los ingredientes necesarios para elaborar las pizzas.

## 2. Glosario de términos

A continuación se definen, por orden alfabético, los principales términos relacionados con el sistema de información de una empresa de pizzas con varias tiendas.

-Administrador: Usuario encargado de gestionar la información general del sistema, incluyendo tiendas, empleados y productos.

-Alérgeno: Sustancia presente en un ingrediente que puede provocar una reacción alérgica en determinadas personas.

-Alergia: Condición de un cliente que indica que debe evitar consumir determinados alérgenos.

-Cliente: Persona que realiza pedidos de productos en alguna de las tiendas de la empresa.

-Cocinero: Empleado encargado de preparar las pizzas y demás productos solicitados en los pedidos.

-Empleado: Trabajador asociado a una de las tiendas de la empresa, que desempeña una función determinada.

-Encargado: Empleado responsable de supervisar el funcionamiento de una tienda y gestionar sus trabajadores y pedidos.

-Estado del pedido: Situación en la que se encuentra un pedido durante su procesamiento, como pendiente, en preparación, listo, en reparto o entregado.

-Ingrediente: Alimento o componente utilizado para elaborar una pizza u otro producto del catálogo.

-Pedido: Solicitud de compra realizada por un cliente, asociada a una tienda y compuesta por uno o varios productos.

-Pizza: Producto elaborado por la pizzería, compuesto por una masa y un conjunto de ingredientes.

-Producto: Artículo que la empresa ofrece a sus clientes, como pizzas, bebidas o complementos.

-Repartidor: Empleado encargado de transportar y entregar los pedidos a domicilio.

-Tienda: Establecimiento físico de la empresa donde trabajan empleados y se preparan y gestionan pedidos.

-Tipo de pedido: Modalidad elegida por el cliente para recibir su compra, como recogida en tienda o entrega a domicilio.

## 3. Visión general del sistema
      
### 3.1. Requisitos generales
En este proyecto nos centraríamos en la gestión de poder permitir a los clientes realizar su pedido de pizza es decir la organización de la pizzeria para que les sea cómodo y sencillo a los clientes. Permitiendole a los mismos poder elegir tamaño e ingredientes.
También necesitaríamos un control de entregas e historial, para registrar los tiempos de preparación, fecha y estado del envío (entregado / no entregado), manteniendo trazabilidad de precios anteriores ante posibles cambios en la tarifa.  
Se debería también mantener una gestión de la estructura organizativa. Administrar las distintas sucursales/tiendas físicas, la asignación de la plantilla (repartidores, camareros, cocineros y jefes) y los recursos asociados (motos para reparto).  
La seguridad y perfiles de acceso. Disponer de un sistema de autenticación único para todos los usuarios que restrinja las funcionalidades según el rol o tipo de usuario asignado. 
Y por ultimo la gestión de alérgenos y fidelización. Poder registrar las alergias asociadas a cada cliente para prevenir incidentes de salud alimentaria y gestionar planes de suscripción para clientes habituales. 
### 3.2. Usuarios del sistema
Dentro de los usuarios del sistema nos encontraríamos al Administrador que su desempeño sería controlar que todo funcione correctamente ser el que decide si cambia algo del catalogo de las tiendas, y el que controla a los distintos usuarios ya que es el que tiene mayor privilegios en la plataforma.
Después vendrían los empleados que dentro de estos estarían: Los cocineros que necesitarían los respectivos ingredientes y serían los que cambian el estado del pedido, los siguientes serian los camareros que tendrían que estar pendientes del cliente y del pedido para repartirlo en la tienda y por ultimo estarían los repartidores que necesitarían una moto para poder repartir el pedido y de ellos dependería la actualización de la entrega del pedido. 
Por ultimo estarían los clientes que serían los que ordenan a la tienda lo que quieren eligiendo en el catalogo la pizza y el tamaño.
## 4. Catálogo de requisitos

### 4.1. Requisitos funcionales

#### R.F.01. Título requisito funcional

Como [tipo de usuario]
quiero [servicio]
para [razón]

**Prueba de aceptación**
- Descripción de la primera comprobación a realizar
- Descripción de la segunda comprobación a realizar
- Se debe aplicar la regla de negocio R.N.XX.
- ...

#### 4.1.1. Requisitos de información

A continuación se describen los requisitos de información necesarios para el funcionamiento del sistema de gestión de la empresa de pizzas. Cada requisito identifica la información que debe almacenar o proporcionar el sistema, el usuario que la necesita y las pruebas de aceptación que permiten comprobar su cumplimiento.

#R.I.01. Información de usuarios:

Como administrador quiero almacenar la información de los usuarios del sistema para poder identificarlos y gestionar sus permisos de acceso.

Prueba de aceptación:
- Cada usuario deberá tener un correo electrónico, un nombre y una contraseña.
- El correo electrónico deberá permitir identificar de forma única a cada usuario.
- Se deberá almacenar el tipo de usuario al que pertenece cada persona.
- Se deberá poder distinguir entre administradores, empleados y clientes.

#R.I.02. Información de clientes:

Como cliente quiero almacenar mi información personal para poder identificarme en el sistema y realizar pedidos.

Prueba de aceptación
- Cada cliente deberá estar asociado a un usuario del sistema.
- Se deberán poder consultar los datos personales del cliente.
- Un cliente podrá realizar varios pedidos.
- Se deberá poder identificar qué pedidos pertenecen a cada cliente.

#R.I.03. Información de alergias de clientes:

Como cliente quiero registrar los ingredientes a los que soy alérgico para evitar realizar pedidos que contengan ingredientes incompatibles con mis alergias.

Prueba de aceptación
- Un cliente podrá tener alergia a varios ingredientes.
- Un mismo ingrediente podrá provocar alergias a varios clientes.
- Se deberán almacenar las relaciones entre los clientes y los ingredientes a los que son alérgicos.
- Se deberá poder consultar la información sobre las alergias de cada cliente.

#R.I.04. Información de tiendas:

Como administrador quiero almacenar la información de las tiendas para poder identificar los establecimientos de la empresa y conocer sus trabajadores.

Prueba de aceptación
- Cada tienda deberá tener un identificador único.
- El sistema deberá permitir identificar a las tiendas de la empresa.
- Se deberá poder conocer qué empleados trabajan en cada tienda.
- Se deberá poder identificar a los clientes y pedidos asociados a cada tienda, de acuerdo con las relaciones del modelo.

#R.I.05. Información de empleados:

Como administrador quiero almacenar la información de los empleados para conocer los trabajadores de cada tienda y gestionar su distribución.

Prueba de aceptación
- Cada empleado deberá estar asociado a un usuario del sistema.
- Cada empleado deberá trabajar en una tienda.
- Se deberá poder conocer el número de empleados de cada tienda.
- Se deberá poder consultar la información de los empleados de una tienda determinada.

#R.I.06. Información de jefes y trabajadores:

Como administrador quiero conocer la información de los jefes y los trabajadores de cada tienda para identificar quién es responsable de supervisar a cada empleado.

Prueba de aceptación
- Se deberá poder identificar al jefe de cada tienda.
- Se deberá poder conocer qué empleados están supervisados por un jefe.
- Se deberá almacenar la relación entre el jefe y los trabajadores a su cargo.
- Se deberá poder consultar la información de los empleados supervisados por un jefe determinado.

#R.I.07. Información de pizzas:

Como cliente quiero conocer la información de las pizzas disponibles para poder elegir las que deseo incluir en mi pedido.

Prueba de aceptación
- Cada pizza deberá tener información sobre su precio.
- Se deberá poder conocer el tamaño de cada pizza.
- Se deberá poder consultar qué ingredientes contiene cada pizza.
- Una pizza podrá estar compuesta por varios ingredientes.
- Se deberá poder consultar la información de las pizzas ofrecidas por la empresa.

#R.I.08. Información de ingredientes:

Como cliente quiero consultar los ingredientes de las pizzas para conocer su composición y comprobar si contienen algún ingrediente al que soy alérgico.

Prueba de aceptación
- Cada ingrediente deberá disponer de un nombre que permita identificarlo.
- Un ingrediente podrá formar parte de varias pizzas.
- Una pizza podrá contener varios ingredientes.
- Se deberá poder conocer en qué pizzas se utiliza un ingrediente determinado.
- Se deberá poder relacionar cada ingrediente con los clientes que hayan indicado ser alérgicos a él.

#R.I.09. Información de pedidos:

Como cliente quiero consultar la información de mis pedidos para conocer los productos solicitados, su precio y el estado en el que se encuentran.

Prueba de aceptación
- Cada pedido deberá tener un número identificativo.
- Se deberá almacenar la fecha de realización del pedido.
- Se deberá almacenar el precio del pedido.
- Se deberá conocer el cliente que ha realizado cada pedido.
- Se deberá almacenar la fecha de entrega cuando corresponda.
- Se deberá conocer el estado del pedido.

#R.I.10. Información de líneas de pedido:

Como cocinero quiero conocer las pizzas y cantidades incluidas en cada pedido para saber qué productos tengo que preparar.

Prueba de aceptación
- Cada línea de pedido deberá estar asociada a un pedido.
- Se deberá conocer la pizza correspondiente a cada línea de pedido.
- Se deberá almacenar la cantidad solicitada de cada pizza.
- Se deberá almacenar el precio correspondiente a cada línea de pedido.
- Un pedido podrá contener varias líneas de pedido.

#R.I.11. Información de estados de pedidos:

Como empleado quiero conocer el estado de los pedidos para poder identificar cuáles han sido entregados y cuáles están pendientes de entrega.

Prueba de aceptación
- Cada pedido deberá tener asociado un estado.
- Se deberán distinguir los estados «entregado» y «no entregado».
- Se deberá poder consultar el estado actual de cada pedido.
- Se deberá poder identificar qué pedidos están pendientes de entrega.

#R.I.12. Información de tamaños de pizzas:

Como cliente quiero conocer los tamaños disponibles de las pizzas para poder elegir el que mejor se adapte a mis necesidades.

Prueba de aceptación
- El sistema deberá almacenar los tamaños de pizza disponibles.
- Se deberán distinguir tres tamaños: pequeño, mediano y grande.
- Cada pizza deberá tener asociado un tamaño.
- Se deberá poder consultar el tamaño de las pizzas disponibles.
- Se deberá almacenar el precio de cada pizza según lo establecido en el modelo.

#R.I.13. Información de suscripciones:

Como administrador quiero almacenar la información de las suscripciones disponibles para poder gestionar las modalidades que ofrece la empresa a sus clientes.

Prueba de aceptación
- Cada suscripción deberá tener un nombre que permita identificarla.
- Se deberá almacenar el precio de cada suscripción.
- Se deberá poder consultar la información de las suscripciones disponibles.
- Una misma suscripción podrá estar asociada a distintos clientes mediante sus correspondientes registros de suscripción.

#R.I.14. Información de suscripciones de clientes:

Como cliente quiero consultar la información de mis suscripciones para conocer su duración y las fechas durante las que están vigentes.

Prueba de aceptación
- Cada suscripción de cliente deberá estar asociada a un cliente.
- Se deberá identificar la modalidad de suscripción contratada.
- Se deberá almacenar la fecha de inicio de la suscripción.
- Se deberá almacenar la fecha de finalización.
- Se deberá poder consultar las suscripciones asociadas a un cliente.
- Se deberá poder determinar si una suscripción se encuentra vigente a partir de sus fechas.
#### 4.1.2. Reglas de negocio

##### R.N.01. Identificación de clientes 
La identificación de cada cliente tienen que ser distintas, no puede haber 2 DNIs iguales en el sistema

##### R.N.02. Advertencia por alergías:
Se debe bloquear la compra de determinadas pizzas si el cliente es alérgico a algún alimento

##### R.N.03. Límite de suscripciones 
Un usuario tan solo puede tener una suscripción activa ya que puedes estar o Suscrito\No suscrito por lo que solo se podría tener 1 suscripción

##### R.N.04. Exclusividad Jefe de tienda
Un empleado solo podría ser jefe en una tienda, y la tienda solo puede tener un jefe asignado.
Así mismo los empleados(cocinero, repartidor y camarero), solo podrían tener un jefe

##### R.N.05. Empleados > Tienda
En cada tienda es obligatorio e independiente de las otras tiendas tener: 1 jefe de tienda, 3 repartidores, 3 cocineros y 3 camareros.

##### R.N.06. Una categoría 
Dentro del sistema cada empleado solo puede tener una categoría; si soy jefe no puedo ser cocinero, si soy camarero no puedo ser repartidor y así respectivamente con cada uno.

### 4.2. Mapa de historias de usuario (opcional)

### 4.3. Requisitos no funcionales (opcional)

**R.N.F. 01. Título requisito no funcional**
Como [tipo de usuario]
quiero [servicio]
para [razón]

-- fin entregable 1 --

## 5. Modelo conceptual

### 5.1. Diagramas de clases UML

- con restricciones.

### 5.2. Escenarios de prueba

- con descripción textual y diagrama de objetos UML.

## 6. Matrices de trazabilidad

- Matriz de trazabilidad entre los elementos del modelo conceptual y los requisitos.

|       | EntidadX   | AsociaciónX  | RestricciónX  | Entidad2 ...   | 
|:------|:-----------|:-----------|:-----------|:-----------|
| RI-1  | X          | X          | X          | X          |
| RI-2  |            | X          |            | X          |
| RF-1  |            | X          |            | X          |
| RF-2  | X          |            | X          | X          |
| RN-1  |            | X          |            |            |
| RN-2  | X          | X          | X          |            |
| ...   |            |            |            |            |

-- fin entregable 2 --

## 7. Modelo relacional en 3FN

- Relaciones obtenidas al aplicar la transformación del modelo conceptual.

### 7.1.  Justificación de la estrategia de transformación de jerarquías

- si se identificaron jerarquías en el MC.


### 8. Matriz de trazabilidad MC/SQL (opcional):

- Restricciones sobre el MC / Elementos del modelo tecnológico (SQL) (Triggers, checks, etc.)
- Incluir Reglas de negocio — Constraints/Triggers en las matrices de trazabilidad para el entregable 3

|       | EntidadX   | AsociaciónX  | RestricciónX  | Entidad2 ...   | 
|:-------|:-------|:-------|:-------|:-------|
| TABLA-1 |        |        |        |        |
| TABLA-2 |        |        |        |        |
| TABLA-3 |        |        |        |        |
| TABLA-4 |        |        |        |        |
| TRIG-1 |        |        |        |        |
| TRIG-2 | X      | X      |        | X      |
| TRIG-3 |        | X      |        | X      |
| TRIG-4 |        |        | X      |        |
| CONST-1 |        |        |        |        |
| CONST-2 | X      | X      |        | X      |
| CONST-3 |        | X      |        | X      |
| CONST-4 |        |        | X      |        |

Se consideran todo tipo de constraints declarativas (aquellas definidas durante el CREATE TABLE).
-- fin entregable 3 --

## Referencias


