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
 
 ALTER TABLE cafeteria_once.vendedor
MODIFY telefono VARCHAR(20);


 -- INSERCIÓN DE DATOS 
 
INSERT INTO cafeteria_once.clientes 
(nombre_apellido,email)
VALUES
('Ana Gomez','anagomez1@gmail.com'),
('Juan Lopez','juanlopez1@gmail.com'),
('Ander Torres','andertorres1@gmail.com'),
('Valentina Felipe','valenfelipe1@gmail.com'),
('Leandro Medina','leandromedina1@gmail.com'),
('Norma Ferreyra','normaferreyra1@gmail.com'),
('Cindy Lopez','cindylopez1@gmail.com'),
('Maby Aguero','mabyaguero1@gmail.com'),
('Leon Medina','leonmedina1@gmail.com'),
('Berenise Aguero','bereniseaguero1@gmail.com');

INSERT INTO cafeteria_once.vendedor
(nombre_apellido,telefono)
VALUES
('Jose Perez',3512562634),
('Juan Gomez',3518963369),
('Lucas Ramos',3514785690),
('Natalia Torno',3517575824),
('Juana Garcia',3518045056);

INSERT INTO cafeteria_once.productos
(categoria,precio)
VALUES
('Porcion Torta',100),
('Medialuna',75),
('Mafalda',85),
('Criollo',45),
('Tostado',85),
('Porcion Budin',100),
('Cafe con leche',100),
('Cafe Macchiato',115),
('Cafe Expreso',100),
('Capuccino',100);


INSERT INTO cafeteria_once.ventas
(id_cliente,id_vendedor,producto,importe_total,fecha,medio_pago)
VALUES
(1,1,'Medialuna',75,'2026-03-14','Efectivo'),
(2,3,'Cafe con leche',100,'2026-03-14','Efectivo'),
(3,2,'Porcion Budin',100,'2026-03-14','Mercado Pago'),
(4,4,'Cafe Expreso',100,'2026-03-14','Transferencia'),
(5,5,'Tostado',85,'2026-03-14','Mercado Pago'),
(6,1,'Criollo',45,'2026-03-14','Efectivo'),
(7,2,'Mafalda',85,'2026-03-14','Efectivo'),
(8,3,'Porcion Torta',100,'2026-03-14','Transferencia'),
(9,4,'Cafe Macchiato',115,'2026-03-14','Mercado Pago'),
(10,5,'Capuccino',100,'2026-03-14','Efectivo');

INSERT INTO cafeteria_once.detalle_venta
(id_ventas,id_productos,cantidad,precio_unitario)
VALUES
(1,1,1,75),
(2,7,1,100),
(3,6,1,100),
(4,9,1,100),
(5,5,1,85),
(6,4,1,45),
(7,3,1,85),
(8,1,1,100),
(9,8,1,115),
(10,10,1,100);

SELECT * FROM cafeteria_once.detalle_venta;

-- VISTAS
-- VISTA 1

CREATE VIEW tabla_ventas AS SELECT producto, importe_total, fecha FROM ventas;

SELECT * FROM tabla_ventas;

-- VISTA 2

CREATE VIEW tabla_clientes AS SELECT nombre_apellido, email FROM clientes;

SELECT * FROM tabla_clientes;

-- VISTA 3

CREATE VIEW total_ventas AS
 SELECT id_vendedor, SUM(importe_total) AS total_ventas
 FROM ventas
 GROUP BY id_vendedor;

SELECT * FROM total_ventas;

-- FUNCTIONS 
-- FUNCTIONS 1

DELIMITER //

DROP FUNCTION IF EXISTS cafeteria_once.fn_aumentar_precio;

CREATE FUNCTION cafeteria_once.fn_aumentar_precio(
_precio DECIMAL (10,2)
) RETURNS DECIMAL (10,2)
DETERMINISTIC
BEGIN
DECLARE valor_de_retorno DECIMAL (10,2);

SET valor_de_retorno= _precio * 1.21;

RETURN valor_de_retorno;

END //

DELIMITER ;


SELECT importe_total, cafeteria_once.fn_aumentar_precio (importe_total) AS precio_final
FROM ventas;


-- FUNCTIONS 2

DELIMITER //

DROP FUNCTION IF EXISTS cafeteria_once.fn_cuantos_pagaron_con_efectivo//

CREATE FUNCTION cafeteria_once.fn_cuantos_pagaron_con_efectivo()
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE valor_de_retorno INT;
  
  SELECT COUNT(*) INTO valor_de_retorno
  FROM ventas
  WHERE medio_pago = 'Efectivo';
  
  RETURN valor_de_retorno;
  
  END//  

SELECT cafeteria_once.fn_cuantos_pagaron_con_efectivo() AS clientes_que_pagaron_con_efectivo;

-- STORED PROCEDURES
-- PROCEDURES 1

DELIMITER //

DROP PROCEDURE IF EXISTS cafeteria_once.sp_total_por_medio_pago //

CREATE PROCEDURE cafeteria_once.sp_total_por_medio_pago(
    _medio_pago VARCHAR(50)
)
BEGIN
    SELECT 
        _medio_pago AS medio_pago,
        SUM(importe_total) AS total_ventas,
        COUNT(*) AS cantidad_ventas
    FROM ventas
    WHERE medio_pago = _medio_pago;
END //

DELIMITER ;

CALL cafeteria_once.sp_total_por_medio_pago ('Efectivo');
CALL cafeteria_once.sp_total_por_medio_pago ('Transferencia');
CALL cafeteria_once.sp_total_por_medio_pago ('Mercado Pago');

-- PROCEDURE 2

DELIMITER //

DROP PROCEDURE IF EXISTS cafeteria_once.sp_total_por_vendedor //

CREATE PROCEDURE cafeteria_once.sp_total_por_vendedor()
BEGIN
    SELECT 
        id_vendedor,
        SUM(importe_total) AS total_vendido,
        COUNT(*) AS cantidad_ventas
    FROM ventas
    GROUP BY id_vendedor;
END //

DELIMITER ;

CALL cafeteria_once.sp_total_por_vendedor ();


-- TRIGGERS
-- TRIGGER 1

CREATE TABLE cafeteria_once.nuevas_ventas_insert(
id_nuevas_ventas INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
mensaje VARCHAR(255),
fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS cafeteria_once.nuevas_ventas_insert;

DELIMITER //

CREATE TRIGGER tgr_nueva_venta_insert
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
    INSERT INTO nuevas_ventas_insert (mensaje) 
    VALUES ( CONCAT('Venta realizada - Importe: ', NEW.importe_total, ' - Medio de pago: ', NEW.medio_pago) );
END //

DELIMITER ;


DROP TRIGGER tgr_nueva_venta_insert;

SELECT * FROM nuevas_ventas_insert;


INSERT INTO ventas (importe_total, medio_pago)
VALUES ('200','Transferencia');


-- TRIGGER 2

DELIMITER //

CREATE TRIGGER no_eliminar
BEFORE DELETE ON clientes
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede eliminar este registro';
END //

DELIMITER ;

DELETE FROM clientes WHERE id_clientes = 1;

-- TRANSACTION


START TRANSACTION;

CREATE USER 'matiascantora'@'localhost' IDENTIFIED BY 'matiascantora123';

GRANT ALL PRIVILEGES ON *.* TO 'matiascantora'@'localhost';

COMMIT;

