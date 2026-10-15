# Título Proyecto

## Miembros del grupo L11-XXX-X

1. Pineda Muñoz, Alfonso
2. Tejada González, Gonzalo
3. León Ramos, Mario

## 1. Introducción al problema

Somos una empresa de pizzerías con servicio a domicilio y consumo en tienda, la cual tiene diferentes tiendas, cada una asignada a una ubicación con un código postal distinto. La dirección de cada tienda está formada por su dirección exacta y su código postal. Cada tienda cuenta con una plantilla de 10 personas: 3 repartidores, 3 cocineros, 3 camareros y 1 admin, que gestiona y dirige la tienda. Cada empleado y cada admin pertenecen a una única tienda.

Hay 3 tipos de usuarios: admin, cliente y empleado. (Hay diferentes tipos de empleados: cocinero, repartidor y camarero).

Para realizar pedidos en línea es necesario registrarse como cliente; para consumir en la tienda física no es necesario. Los clientes deben proporcionar su nombre, DNI y dirección (dirección exacta y código postal) para poder realizar pedidos en línea. A través de la ubicación del cliente, se le asociará la tienda cuyo código postal se encuentre más cerca de su ubicación. Los pedidos de la tienda física no se asocian a ningún cliente y se identifican únicamente por su número de pedido, ya que no se dispone de más información; son registrados por los camareros.

El pedido contiene varios atributos: número, tiempo (tiempo total de entrega), fecha (fecha en la que se realiza el pedido), fechaEntrega (fecha real de entrega), estado, precio y tipo (en línea o en tienda). El estado puede ser en preparación, en reparto, entregado o no entregado (si surge cualquier inconveniente). Los pedidos en tienda no tienen cliente, repartidor ni fecha de entrega, y no pasan por el estado en reparto. De cada pedido se registra el cocinero que lo prepara y, en los pedidos en línea, el repartidor que lo entrega.

Los clientes pueden pedir pizzas del catálogo de la empresa, y las hay de 3 tamaños: pequeña, mediana y grande. Cada pizza tiene un precio base distinto para cada tamaño, que puede ser modificado puntualmente; cuando esto ocurre, se guarda el precio anterior, ya que se supone un cambio temporal y el precio base volverá a su valor. Los clientes podrán eliminar de una pizza del catálogo los ingredientes a los que sean alérgicos; no se registran las alergias del cliente.

Además, los clientes podrán contar con una suscripción que le otorgará prioridad sobre los no suscritos a la hora de la entrega y la elaboración de sus pizzas. Solo existe un tipo de suscripción y un cliente solo puede tener una activa.

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

#### R.F.01. Gestión de usuarios

Como administrador quiero gestionar los usuarios del sistema para controlar el acceso y la información de los distintos tipos de usuarios.

#### R.F.02. Registro de clientes

Como cliente quiero registrarme en el sistema proporcionando mi nombre, DNI y dirección (dirección exacta y código postal) para poder realizar pedidos en línea.

#### R.F.03. Gestión de empleados

Como administrador quiero registrar, modificar y eliminar empleados (cocineros, repartidores y camareros) para mantener actualizada la plantilla de cada tienda.

#### R.F.04. Gestión de tiendas

Como administrador quiero gestionar las tiendas de la empresa indicando su dirección exacta y código postal para organizar el servicio de las distintas zonas.

#### R.F.05. Asignación automática de tiendas

Como sistema quiero asignar automáticamente a cada cliente la tienda cuyo código postal esté más cerca del código postal de su dirección para determinar qué establecimiento debe gestionar sus pedidos en línea.

#### R.F.06. Realización de pedidos en línea

Como cliente registrado quiero realizar pedidos de pizzas en línea para recibirlos en mi dirección a través de la tienda que me corresponde.

#### R.F.07. Registro de pedidos

Como sistema quiero almacenar el número identificador, la fecha de realización, el tiempo total de entrega, la fecha real de entrega, el estado, el precio total y el tipo (en línea o en tienda) de cada pedido para mantener un registro de las operaciones realizadas.

#### R.F.08. Consulta de pedidos

Como cliente quiero consultar mis pedidos en línea para conocer su información y estado.

#### R.F.09. Actualización del estado de los pedidos

Como empleado quiero actualizar el estado de los pedidos (en preparación, en reparto, entregado o no entregado) para mantener informada a la empresa sobre su preparación y entrega.

#### R.F.10. Asignación de pedidos a tiendas

Como sistema quiero asociar cada pedido en línea a la tienda que corresponde al cliente, y cada pedido en tienda a la tienda donde se registra, para determinar qué establecimiento se encarga de prepararlo y entregarlo.

#### R.F.11. Consulta de pizzas

Como cliente quiero consultar las pizzas del catálogo y sus precios según el tamaño para elegir las que deseo incluir en mi pedido.

#### R.F.12. Gestión de precios

Como administrador quiero establecer y modificar los precios base de las pizzas para cada tamaño, conservando el precio anterior cuando se modifique, para mantener actualizada la oferta de la empresa.

#### R.F.13. Cálculo del precio del pedido

Como cliente quiero conocer el precio total de mi pedido antes de confirmarlo para saber cuánto debo pagar.

#### R.F.14. Gestión de ingredientes

Como administrador quiero gestionar los ingredientes utilizados en la elaboración de las pizzas para mantener actualizada la información de los productos disponibles.

#### R.F.15. Registro de pedidos en tienda

Como camarero quiero registrar los pedidos de los clientes que consumen en la tienda física, identificándolos únicamente por su número de pedido, para atender a los clientes sin necesidad de que se registren.

#### R.F.16. Clasificación de empleados

Como administrador quiero clasificar a los empleados según su función, distinguiendo entre cocineros, repartidores y camareros, y asignar cada uno a una única tienda, para organizar las tareas de cada tienda.

#### R.F.17. Selección del tamaño de las pizzas

Como cliente quiero elegir entre pizzas pequeñas, medianas y grandes para adaptar mi pedido a mis preferencias.

#### R.F.18. Eliminación de ingredientes por alergias

Como cliente quiero eliminar de una pizza del catálogo los ingredientes a los que soy alérgico para poder consumirla de forma segura.

#### R.F.19. Gestión de suscripciones

Como administrador quiero gestionar las suscripciones de los clientes, teniendo en cuenta que un cliente solo puede tener una activa, para identificar a aquellos que disponen de este servicio.

#### R.F.20. Priorización de pedidos de clientes suscritos

Como sistema quiero priorizar los pedidos de los clientes con una suscripción activa durante la elaboración y la entrega para ofrecerles las ventajas asociadas a su suscripción.


**Pruebas de aceptación**

- Se deberá mostrar un listado de las pizzas disponibles.
- Cada pizza deberá mostrar su nombre, ingredientes y tamaños disponibles.
- Se deberá mostrar el precio correspondiente a cada tamaño.
- Si no existen pizzas disponibles, el sistema deberá mostrar un listado vacío.

##### R.F.02. Consulta de ingredientes de una pizza

Como cliente quiero consultar los ingredientes de una pizza para conocer su composición antes de realizar un pedido.

**Pruebas de aceptación**

- Se deberá poder seleccionar una pizza del catálogo.
- El sistema deberá mostrar los ingredientes que componen la pizza seleccionada.
- Se deberá mostrar la información sobre los alérgenos asociados a sus ingredientes.
- La consulta deberá corresponder únicamente a la pizza seleccionada.

##### R.F.03. Consulta del historial de pedidos

Como cliente quiero consultar mis pedidos anteriores para conocer los productos solicitados, sus importes y sus estados.

**Pruebas de aceptación**

- El sistema deberá mostrar los pedidos asociados al cliente identificado.
- Cada pedido deberá mostrar su identificador, fecha, importe total y estado.
- Se deberá poder consultar el detalle de las líneas de cada pedido, incluyendo cantidades y precios aplicados.
- Un cliente no podrá consultar los pedidos pertenecientes a otros clientes.
- Si el cliente no ha realizado pedidos, se mostrará un listado vacío.

##### R.F.04. Consulta de pedidos pendientes de una tienda

Como empleado quiero consultar los pedidos pendientes de mi tienda para conocer cuáles deben prepararse o entregarse.

**Pruebas de aceptación**

- El sistema deberá mostrar los pedidos de la tienda a la que pertenece el empleado.
- La consulta deberá permitir identificar los pedidos que todavía no han sido entregados.
- Cada pedido deberá mostrar su número identificativo, fecha, estado y productos solicitados.
- No deberán aparecer pedidos de otras tiendas.

##### R.F.05. Consulta del estado de un pedido

Como cliente quiero consultar el estado actual de un pedido para conocer si ha sido entregado o continúa pendiente.

**Pruebas de aceptación**

- El cliente deberá poder seleccionar uno de sus pedidos.
- El sistema deberá mostrar el estado actual del pedido seleccionado.
- Se deberá mostrar la fecha de entrega cuando esté registrada.
- El sistema no deberá mostrar información de pedidos pertenecientes a otros clientes.

##### R.F.06. Listado de empleados de una tienda

Como administrador quiero consultar los empleados de una tienda para conocer su plantilla y distribución por categorías profesionales.

**Pruebas de aceptación**

- Se deberá poder seleccionar una tienda.
- El sistema deberá mostrar los empleados asociados a la tienda seleccionada.
- Se deberá mostrar el nombre y la categoría profesional de cada empleado.
- Se deberá poder identificar al jefe responsable de la tienda.
- No deberán aparecer trabajadores asociados a otras tiendas.

##### R.F.07. Consulta de trabajadores supervisados por un jefe

Como administrador quiero consultar los trabajadores supervisados por un jefe de tienda para conocer la estructura organizativa del establecimiento.

**Pruebas de aceptación**

- Se deberá poder seleccionar un jefe de tienda.
- El sistema deberá mostrar los empleados supervisados por el jefe seleccionado.
- Se deberá mostrar el nombre y la categoría de cada trabajador.
- Los empleados mostrados deberán pertenecer a la misma tienda que su jefe.

##### R.F.08. Consulta de alergias de un cliente

Como cliente quiero consultar mis alergias registradas para conocer qué alérgenos tiene asociados mi perfil.

**Pruebas de aceptación**

- El sistema deberá mostrar los alérgenos registrados para el cliente identificado.
- Se deberá mostrar la denominación de cada alérgeno.
- El cliente no podrá acceder mediante esta consulta a la información de alergias de otros clientes.
- Si no existen alergias registradas, se mostrará un listado vacío.

##### R.F.09. Consulta de suscripciones de un cliente

Como cliente quiero consultar mis suscripciones para conocer las modalidades contratadas y sus periodos de vigencia.

**Pruebas de aceptación**

- El sistema deberá mostrar las suscripciones asociadas al cliente identificado.
- Cada registro deberá mostrar la modalidad contratada y las fechas de inicio y finalización.
- Se deberá indicar si la suscripción está vigente en la fecha de consulta.
- Se deberán poder consultar también las suscripciones finalizadas.
- No deberán aparecer suscripciones de otros clientes.

##### R.F.10. Listado de pedidos por tienda y fecha

Como administrador quiero consultar los pedidos realizados en una tienda durante un periodo determinado para conocer su actividad.

**Pruebas de aceptación**

- Se deberá poder seleccionar una tienda y un intervalo de fechas.
- El sistema deberá mostrar los pedidos asociados a esa tienda dentro del periodo seleccionado.
- Cada resultado deberá mostrar el número de pedido, su fecha, importe total y estado.
- No deberán aparecer pedidos de otras tiendas ni de fechas fuera del intervalo indicado.

##### R.F.11. Consulta de suscriptores activos

Como administrador quiero consultar los clientes que tienen una suscripción vigente para conocer qué clientes disponen de las ventajas de suscripción.

**Pruebas de aceptación**

- Se deberá mostrar un listado de clientes con suscripciones vigentes en la fecha de consulta.
- Se deberá mostrar el cliente, la modalidad de suscripción y su fecha de finalización.
- No deberán aparecer clientes cuyas suscripciones hayan finalizado.
- Un mismo cliente no deberá aparecer duplicado por una misma suscripción vigente.

##### R.F.12. Consulta de pizzas por tamaño y precio

Como cliente quiero consultar las pizzas disponibles filtradas por tamaño y precio para encontrar las opciones que mejor se adapten a mis preferencias.

**Pruebas de aceptación**

- Se deberá poder seleccionar uno de los tres tamaños disponibles.
- Se deberá poder establecer un precio máximo.
- El sistema deberá mostrar las pizzas del tamaño seleccionado cuyo precio no supere el máximo indicado.
- Cada resultado deberá mostrar el nombre de la pizza, su tamaño y su precio.
- Si ninguna pizza cumple las condiciones, se mostrará un listado vacío.

#### 4.1.1. Requisitos de información

A continuación se describen los requisitos de información necesarios para el funcionamiento del sistema de gestión de la empresa de pizzas. Cada requisito identifica la información que debe almacenar o proporcionar el sistema, el usuario que la necesita y las pruebas de aceptación que permiten comprobar su cumplimiento.

##### R.I.01. Información de usuarios:

Como administrador quiero almacenar la información de los usuarios del sistema para poder identificarlos y gestionar sus permisos de acceso.

**Prueba de aceptación**

- Cada usuario deberá tener un correo electrónico, un nombre y una contraseña.
- El correo electrónico deberá permitir identificar de forma única a cada usuario.
- Se deberá almacenar el tipo de usuario al que pertenece cada persona.
- Se deberá poder distinguir entre administradores, empleados y clientes.

##### R.I.02. Información de clientes:

Como cliente quiero almacenar mi información personal para poder identificarme en el sistema y realizar pedidos.

**Prueba de aceptación**

- Cada cliente deberá estar asociado a un usuario del sistema.
- Se deberán poder consultar los datos personales del cliente.
- Un cliente podrá realizar varios pedidos.
- Se deberá poder identificar qué pedidos pertenecen a cada cliente.

##### R.I.03. Información de alergias de clientes:

Como cliente quiero registrar los ingredientes a los que soy alérgico para evitar realizar pedidos que contengan ingredientes incompatibles con mis alergias.

**Prueba de aceptación**

- Un cliente podrá tener alergia a varios ingredientes.
- Un mismo ingrediente podrá provocar alergias a varios clientes.
- Se deberán almacenar las relaciones entre los clientes y los ingredientes a los que son alérgicos.
- Se deberá poder consultar la información sobre las alergias de cada cliente.

##### R.I.04. Información de tiendas:

Como administrador quiero almacenar la información de las tiendas para poder identificar los establecimientos de la empresa y conocer sus trabajadores.

**Prueba de aceptación**

- Cada tienda deberá tener un identificador único.
- El sistema deberá permitir identificar a las tiendas de la empresa.
- Se deberá poder conocer qué empleados trabajan en cada tienda.
- Se deberá poder identificar a los clientes y pedidos asociados a cada tienda, de acuerdo con las relaciones del modelo.

##### R.I.05. Información de empleados:

Como administrador quiero almacenar la información de los empleados para conocer los trabajadores de cada tienda y gestionar su distribución.

**Prueba de aceptación**

- Cada empleado deberá estar asociado a un usuario del sistema.
- Cada empleado deberá trabajar en una tienda.
- Se deberá poder conocer el número de empleados de cada tienda.
- Se deberá poder consultar la información de los empleados de una tienda determinada.

##### R.I.06. Información de jefes y trabajadores:

Como administrador quiero conocer la información de los jefes y los trabajadores de cada tienda para identificar quién es responsable de supervisar a cada empleado.

**Prueba de aceptación**

- Se deberá poder identificar al jefe de cada tienda.
- Se deberá poder conocer qué empleados están supervisados por un jefe.
- Se deberá almacenar la relación entre el jefe y los trabajadores a su cargo.
- Se deberá poder consultar la información de los empleados supervisados por un jefe determinado.

##### R.I.07. Información de pizzas

Como administrador quiero almacenar la información de las pizzas ofrecidas por la empresa para mantener registrados los productos disponibles en el catálogo.

**Pruebas de aceptación**

- Cada pizza deberá tener un identificador único y un nombre.
- Se deberá almacenar la composición base de cada pizza mediante su relación con los ingredientes.
- Una pizza podrá estar compuesta por varios ingredientes.
- Un mismo ingrediente podrá formar parte de distintas pizzas.
- Se deberá registrar el precio establecido para cada combinación de pizza y tamaño.

##### R.I.08. Información de ingredientes

Como administrador quiero almacenar la información de los ingredientes utilizados en las pizzas para mantener registrada su composición y sus posibles alérgenos.

**Pruebas de aceptación**

- Cada ingrediente deberá tener un identificador único y un nombre.
- Un ingrediente podrá formar parte de varias pizzas.
- Una pizza podrá contener varios ingredientes.
- Se deberán almacenar las relaciones entre los ingredientes y los alérgenos que contienen.
- Un mismo alérgeno podrá estar presente en varios ingredientes.

##### R.I.09. Información de pedidos

Como administrador quiero almacenar la información de los pedidos realizados por los clientes para mantener un registro de las operaciones y entregas efectuadas.

**Pruebas de aceptación**

- Cada pedido deberá tener un número identificativo único.
- Se deberá almacenar la fecha y hora de realización del pedido.
- Se deberá almacenar el importe total correspondiente al pedido.
- Cada pedido deberá estar asociado al cliente que lo ha realizado y a la tienda responsable de su preparación.
- Se deberá registrar el estado del pedido.
- Se deberá almacenar la fecha y hora de entrega cuando corresponda.
- Se deberá conservar el importe aplicado al pedido, aunque posteriormente cambien los precios del catálogo.


##### R.I.10. Información de líneas de pedido:

Como cocinero quiero conocer las pizzas y cantidades incluidas en cada pedido para saber qué productos tengo que preparar.

**Prueba de aceptación**

- Cada línea de pedido deberá estar asociada a un pedido.
- Se deberá conocer la pizza correspondiente a cada línea de pedido.
- Se deberá almacenar la cantidad solicitada de cada pizza.
- Se deberá almacenar el precio correspondiente a cada línea de pedido.
- Un pedido podrá contener varias líneas de pedido.

##### R.I.11. Información de estados de pedidos

Como administrador quiero almacenar los estados asociados a los pedidos para mantener registrada su situación durante el proceso de preparación y entrega.

**Pruebas de aceptación**

- Cada estado deberá disponer de un identificador único y una denominación.
- Se deberán registrar, como mínimo, los estados «entregado» y «no entregado».
- Cada pedido deberá tener asociado un estado actual.
- Se deberá conservar la relación entre cada pedido y su estado correspondiente.

##### R.I.12. Información de tamaños de pizzas

Como administrador quiero almacenar los tamaños disponibles de las pizzas para mantener registradas las distintas opciones de venta y sus precios.

**Pruebas de aceptación**

- Cada tamaño deberá tener un identificador único y una denominación.
- Se deberán registrar tres tamaños: pequeño, mediano y grande.
- Se deberá almacenar la relación entre las pizzas y sus tamaños disponibles.
- Se deberá registrar el precio correspondiente a cada combinación de pizza y tamaño.

##### R.I.14. Información de suscripciones de clientes

Como administrador quiero almacenar las suscripciones contratadas por los clientes para mantener un registro de las modalidades contratadas y sus periodos de vigencia.

**Pruebas de aceptación**

- Cada contratación deberá estar asociada a un cliente.
- Se deberá identificar la modalidad de suscripción contratada.
- Se deberá almacenar la fecha de inicio de cada suscripción contratada.
- Se deberá almacenar su fecha de finalización.
- Un cliente podrá tener registradas varias suscripciones correspondientes a diferentes periodos.
- Se deberán conservar las suscripciones finalizadas como parte del historial de contrataciones.
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

##### R.N.05. Empleados -> Tienda
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


