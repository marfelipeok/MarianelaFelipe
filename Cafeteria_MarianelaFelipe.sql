CREATE DATABASE IF NOT EXISTS cafeteria_once;

USE cafeteria_once;

CREATE TABLE IF NOT EXISTS cafeteria_once.ventas( 
id_ventas INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
id_cliente INT, 
id_vendedor INT, 
producto VARCHAR (100),
importe_total INT,
fecha DATE, 
medio_pago VARCHAR (100) 
);

CREATE TABLE IF NOT EXISTS cafeteria_once.clientes( 
id_clientes INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
nombre_apellido VARCHAR (200),
 email VARCHAR (100) UNIQUE 
 );
 
 CREATE TABLE IF NOT EXISTS cafeteria_once.productos( 
 id_productos INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 categoria VARCHAR (100), 
 precio INT
 );
 
 CREATE TABLE IF NOT EXISTS cafeteria_once.vendedor( 
 id_vendedor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nombre_apellido VARCHAR (100), 
 telefono INT 
 );
 
 CREATE TABLE IF NOT EXISTS cafeteria_once.detalle_venta(
 id_ventas INT, 
 id_productos INT, 
 cantidad INT,
 precio_unitario DECIMAL (10,2), 
 
 PRIMARY KEY (id_ventas,id_productos), 
 FOREIGN KEY (id_ventas) REFERENCES cafeteria_once.ventas (id_ventas), 
 FOREIGN KEY (id_productos) REFERENCES cafeteria_once.productos (id_productos)
 );
 
 ALTER TABLE cafeteria_once.ventas
 ADD CONSTRAINT fk_ventas_clientes
 FOREIGN KEY (id_cliente)
 REFERENCES cafeteria_once.clientes (id_clientes);
 
 ALTER TABLE cafeteria_once.ventas
 ADD CONSTRAINT fk_ventas_vendedor
 FOREIGN KEY (id_vendedor)
 REFERENCES cafeteria_once.vendedor (id_vendedor);