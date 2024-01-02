/*Nombres de campos*/
use henry_m3;
ALTER TABLE `calendario` CHANGE `id` `IdFecha` INT(11) NOT NULL;
ALTER TABLE `cliente` CHANGE `ID` `IdCliente` INT(11) NOT NULL;
ALTER TABLE `empleado` CHANGE `ID_Empleado` `IdEmpleado` INT(11) NOT NULL;
ALTER TABLE `proveedor` CHANGE `IDProveedor` `IdProveedor` INT(11) NOT NULL;
ALTER TABLE `sucursal` CHANGE `ID` `IdSucursal` INT(11) NOT NULL;
ALTER TABLE `tipo_gasto` CHANGE `Descripcion` `Tipo_Gasto` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL;
ALTER TABLE `producto` CHANGE `ID_Producto` `IdProducto` INT(11) NOT NULL;
ALTER TABLE `producto` CHANGE `Concepto` `Producto` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NULL DEFAULT NULL;

select * from producto;
-- SELECT replace('Hola Mundo', 'o', ' ');
/*Tipos de Datos*/
ALTER TABLE `cliente` 	ADD `Latitud` DECIMAL(13,10) NOT NULL DEFAULT '0' AFTER `Y`, 
						ADD `Longitud` DECIMAL(13,10) NOT NULL DEFAULT '0' AFTER `Latitud`;
UPDATE cliente SET Y = '0' WHERE Y = '';
UPDATE cliente SET X = '0' WHERE X = '';
UPDATE `cliente` SET X = REPLACE(Y,',','.');
UPDATE `cliente` SET Y = REPLACE(X,',','.');
UPDATE cliente SET Latitud = X;
UPDATE cliente SET Longitud = Y;
SELECT * FROM `cliente`;
ALTER TABLE `cliente` DROP `Y`;
ALTER TABLE `cliente` DROP `X`;
ALTER TABLE cliente DROP col10;

ALTER TABLE `empleado` ADD `Salario2` DECIMAL(10,2) NOT NULL DEFAULT '0' AFTER `Salario`;
UPDATE `empleado` SET Salario = REPLACE(Salario,',','.');
ALTER TABLE `empleado` DROP `Salario`;

ALTER TABLE `producto` ADD `Precio2` DECIMAL(15,3) NOT NULL DEFAULT '0' AFTER `Precio`;
UPDATE `producto` SET Precio2 = REPLACE(Precio,',','.');
ALTER TABLE `producto` DROP `Precio`;


UPDATE `sucursal` SET Latitud = REPLACE(Latitud,',','.');
UPDATE `sucursal` SET Longitud = REPLACE(Longitud,',','.');
SELECT * FROM `sucursal`;


UPDATE venta set Precio = 0 WHERE TRIM(Precio) = "" OR ISNULL(Precio);
ALTER TABLE `venta` CHANGE `Precio` precio DECIMAL(15,3) NOT NULL DEFAULT '0';
SELECT * FROM venta;


SELECT * FROM cliente;
-- SELECT trim('     Hola Mundo      ');

/*Imputar Valores Faltantes*/
UPDATE `cliente` SET Domicilio = 'Sin Dato' WHERE TRIM(Domicilio) = "" OR ISNULL(Domicilio);
UPDATE `cliente` SET Localidad = 'Sin Dato' WHERE TRIM(Localidad) = "" OR ISNULL(Localidad);
UPDATE `cliente` SET Nombre_y_Apellido = 'Sin Dato' WHERE TRIM(Nombre_y_Apellido) = "" OR ISNULL(Nombre_y_Apellido);
UPDATE `cliente` SET Provincia = 'Sin Dato' WHERE TRIM(Provincia) = "" OR ISNULL(Provincia);

UPDATE `empleado` SET Apellido = 'Sin Dato' WHERE TRIM(Apellido) = "" OR ISNULL(Apellido);
UPDATE `empleado` SET Nombre = 'Sin Dato' WHERE TRIM(Nombre) = "" OR ISNULL(Nombre);
UPDATE `empleado` SET Sucursal = 'Sin Dato' WHERE TRIM(Sucursal) = "" OR ISNULL(Sucursal);
UPDATE `empleado` SET Sector = 'Sin Dato' WHERE TRIM(Sector) = "" OR ISNULL(Sector);
UPDATE `empleado` SET Cargo = 'Sin Dato' WHERE TRIM(Cargo) = "" OR ISNULL(Cargo);

UPDATE `producto` SET Producto = 'Sin Dato' WHERE TRIM(Producto) = "" OR ISNULL(Producto);
UPDATE `producto` SET Tipo = 'Sin Dato' WHERE TRIM(Tipo) = "" OR ISNULL(Tipo);

ALTER TABLE `henry_m3`.`proveedor` 
	CHANGE COLUMN `Address` `Domicilio` TEXT NULL DEFAULT NULL ,
	CHANGE COLUMN `City` `Ciudad` TEXT NULL DEFAULT NULL ,
	CHANGE COLUMN `State` `Provincia` TEXT NULL DEFAULT NULL ,
	CHANGE COLUMN `Country` `Pais` TEXT NULL DEFAULT NULL ,
	CHANGE COLUMN `departamen` `Departamento` TEXT NULL DEFAULT NULL ;
UPDATE `proveedor` SET Nombre = 'Sin Dato' WHERE TRIM(Nombre) = "" OR ISNULL(Nombre);
UPDATE `proveedor` SET Domicilio = 'Sin Dato' WHERE TRIM(Domicilio) = "" OR ISNULL(Domicilio);

UPDATE `proveedor` SET Ciudad = 'Sin Dato' WHERE TRIM(Ciudad) = "" OR ISNULL(Ciudad);
UPDATE `proveedor` SET Provincia = 'Sin Dato' WHERE TRIM(Provincia) = "" OR ISNULL(Provincia);
UPDATE `proveedor` SET Pais = 'Sin Dato' WHERE TRIM(Pais) = "" OR ISNULL(Pais);
UPDATE `proveedor` SET Departamento = 'Sin Dato' WHERE TRIM(Departamento) = "" OR ISNULL(Departamento);

ALTER TABLE henry_m3.sucursal
	CHANGE COLUMN `Direccion` `Domicilio` TEXT NULL DEFAULT NULL;
UPDATE `sucursal` SET Domicilio = 'Sin Dato' WHERE TRIM(Domicilio) = "" OR ISNULL(Domicilio);
UPDATE `sucursal` SET Sucursal = 'Sin Dato' WHERE TRIM(Sucursal) = "" OR ISNULL(Sucursal);
UPDATE `sucursal` SET Provincia = 'Sin Dato' WHERE TRIM(Provincia) = "" OR ISNULL(Provincia);
UPDATE `sucursal` SET Localidad = 'Sin Dato' WHERE TRIM(Localidad) = "" OR ISNULL(Localidad);

SELECT Precio, 
		COUNT(*) 
	FROM venta
	WHERE Precio = '' OR Cantidad = ''
	GROUP BY Precio;

SELECT count(*) FROM venta;
SELECT * FROM VENTA;

/*Tabla ventas limpieza y normalizacion*/
ALTER TABLE henry_m3.producto
	CHANGE COLUMN `Precio2` `Precio` DECIMAL(15,3) NOT NULL DEFAULT '0.000';
UPDATE venta v 
	JOIN producto p ON (v.IdProducto = p.IdProducto) 
	SET v.Precio = p.Precio
	WHERE v.Precio = 0;

/*Tabla auxiliar donde se guardarán registros con problemas:
1-Cantidad en Cero
*/
DROP TABLE IF EXISTS `aux_venta`;
CREATE TABLE IF NOT EXISTS `aux_venta` (
  `IdVenta`				INTEGER,
  `Fecha` 				DATE NOT NULL,
  `Fecha_Entrega` 		DATE NOT NULL,
  `IdCliente`			INTEGER, 
  `IdSucursal`			INTEGER,
  `IdEmpleado`			INTEGER,
  `IdProducto`			INTEGER,
  `Precio`				FLOAT,
  `Cantidad`			INTEGER,
  `Motivo`				INTEGER
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

UPDATE venta SET Cantidad = REPLACE(Cantidad, '\r', '');

INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, 0, 1
FROM venta WHERE Cantidad = '' or Cantidad IS NULL;

UPDATE venta SET Cantidad = '1' WHERE Cantidad = '' or Cantidad IS NULL;
ALTER TABLE `venta` CHANGE `Cantidad` `Cantidad` INTEGER NOT NULL DEFAULT '0';

/*Normalizacion a Letra Capital*/
UPDATE cliente SET 	Provincia = UC_Words(TRIM(Provincia)),
					Localidad = UC_Words(TRIM(Localidad)),
                    Domicilio = UC_Words(TRIM(Domicilio)),
                    Nombre_y_Apellido = UC_Words(TRIM(Nombre_y_Apellido));
					
UPDATE sucursal SET Provincia = UC_Words(TRIM(Provincia)),
					Localidad = UC_Words(TRIM(Localidad)),
                    Domicilio = UC_Words(TRIM(Domicilio)),
                    Sucursal = UC_Words(TRIM(Sucursal));
					
UPDATE proveedor SET Provincia = UC_Words(TRIM(Provincia)),
					Ciudad = UC_Words(TRIM(Ciudad)),
                    Departamento = UC_Words(TRIM(Departamento)),
                    Pais = UC_Words(TRIM(Pais)),
                    Nombre = UC_Words(TRIM(Nombre)),
                    Domicilio = UC_Words(TRIM(Domicilio));

UPDATE producto SET Producto = UC_Words(TRIM(Producto)),
					Tipo = UC_Words(TRIM(Tipo));
					
UPDATE empleado SET Sucursal = UC_Words(TRIM(Sucursal)),
                    Sector = UC_Words(TRIM(Sector)),
                    Cargo = UC_Words(TRIM(Cargo)),
                    Nombre = UC_Words(TRIM(Nombre)),
                    Apellido = UC_Words(TRIM(Apellido));

/*Chequeo de claves duplicadas*/
SELECT IdCliente, COUNT(*) FROM cliente GROUP BY IdCliente HAVING COUNT(*) > 1;
SELECT IdSucursal, COUNT(*) FROM sucursal GROUP BY IdSucursal HAVING COUNT(*) > 1;
SELECT IdEmpleado, COUNT(*) FROM empleado GROUP BY IdEmpleado HAVING COUNT(*) > 1;
SELECT IdProveedor, COUNT(*) FROM proveedor GROUP BY IdProveedor HAVING COUNT(*) > 1;
SELECT IdProducto, COUNT(*) FROM producto GROUP BY IdProducto HAVING COUNT(*) > 1;

select count(*) from empleado;

SELECT e.*, s.IdSucursal, s.Sucursal
	FROM empleado e
	JOIN sucursal s	ON (e.Sucursal = s.Sucursal);
    
SELECT DISTINCT Sucursal 
	FROM empleado
	WHERE Sucursal NOT IN (SELECT Sucursal FROM sucursal);

/*Generacion de clave única tabla empleado mediante creacion de clave subrogada*/
UPDATE empleado SET Sucursal = 'Mendoza1' WHERE Sucursal = 'Mendoza 1';
UPDATE empleado SET Sucursal = 'Mendoza2' WHERE Sucursal = 'Mendoza 2';
-- UPDATE empleado SET Sucursal = 'Córdoba Quiroz' WHERE Sucursal = 'Cordoba Quiroz';

ALTER TABLE `empleado` ADD `IdSucursal` INT NULL DEFAULT '0' AFTER `Sucursal`;

UPDATE empleado e
	JOIN sucursal s	ON (e.Sucursal = s.Sucursal)
	SET e.IdSucursal = s.IdSucursal;

SELECT * FROM `empleado`;

ALTER TABLE `empleado` DROP `Sucursal`;

ALTER TABLE `empleado` ADD `CodigoEmpleado` INT NULL DEFAULT '0' AFTER `IdEmpleado`;

UPDATE empleado SET CodigoEmpleado = IdEmpleado;
UPDATE empleado SET IdEmpleado = (IdSucursal * 1000000) + CodigoEmpleado;

/*Chequeo de claves duplicadas*/
SELECT * FROM `empleado`;
SELECT IdEmpleado, COUNT(*) FROM empleado GROUP BY IdEmpleado HAVING COUNT(*) > 1;

/*Modificacion de la clave foranea de empleado en venta*/
UPDATE venta SET IdEmpleado = (IdSucursal * 1000000) + IdEmpleado;

/*Normalizacion tabla empleado*/
DROP TABLE IF EXISTS `cargo`;
CREATE TABLE IF NOT EXISTS `cargo` (
  `IdCargo` int(11) NOT NULL AUTO_INCREMENT,
  `Cargo` varchar(50) NOT NULL,
  PRIMARY KEY (`IdCargo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

DROP TABLE IF EXISTS `sector`;
CREATE TABLE IF NOT EXISTS `sector` (
  `IdSector` int(11) NOT NULL AUTO_INCREMENT,
  `Sector` varchar(50) NOT NULL,
  PRIMARY KEY (`IdSector`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO cargo (Cargo) SELECT DISTINCT Cargo FROM empleado ORDER BY 1;
INSERT INTO sector (Sector) SELECT DISTINCT Sector FROM empleado ORDER BY 1;

select * from cargo;
select * from sector;

ALTER TABLE `empleado` 	ADD `IdSector` INT NOT NULL DEFAULT '0' AFTER `IdSucursal`, 
						ADD `IdCargo` INT NOT NULL DEFAULT '0' AFTER `IdSector`;

-- Tuve que cambiar el tipo de encoding para hacer el join.
SET collation_connection = 'utf8_general_ci';
ALTER DATABASE henry_m3 CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE empleado CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;

UPDATE empleado e JOIN cargo c ON (c.Cargo = e.Cargo) SET e.IdCargo = c.IdCargo;
UPDATE empleado e JOIN sector s ON (s.Sector = e.Sector) SET e.IdSector = s.IdSector;

ALTER TABLE `empleado` DROP `Cargo`;
ALTER TABLE `empleado` DROP `Sector`;

SELECT * FROM `empleado`;

/*Normalización tabla producto*/
ALTER TABLE `producto` ADD `IdTipoProducto` INT NOT NULL DEFAULT '0' AFTER `Precio`;

DROP TABLE IF EXISTS `tipo_producto`;
CREATE TABLE IF NOT EXISTS `tipo_producto` (
  `IdTipoProducto` int(11) NOT NULL AUTO_INCREMENT,
  `TipoProducto` varchar(50) NOT NULL,
  PRIMARY KEY (`IdTipoProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tipo_producto (TipoProducto) SELECT DISTINCT Tipo FROM producto ORDER BY 1;

ALTER TABLE producto CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;

UPDATE producto p JOIN tipo_producto t ON (p.Tipo = t.TipoProducto) SET p.IdTipoProducto = t.IdTipoProducto;

SELECT * FROM `producto`;

ALTER TABLE `producto` DROP `Tipo`;

/*Normalización Localidad Provincia*/
DROP TABLE IF EXISTS aux_Localidad;
CREATE TABLE IF NOT EXISTS aux_Localidad (
	Localidad_Original	VARCHAR(80),
	Provincia_Original	VARCHAR(50),
	Localidad_Normalizada	VARCHAR(80),
	Provincia_Normalizada	VARCHAR(50),
	IdLocalidad			INTEGER
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO aux_localidad (Localidad_Original, Provincia_Original, Localidad_Normalizada, Provincia_Normalizada, IdLocalidad)
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM cliente
UNION
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM sucursal
UNION
SELECT DISTINCT Ciudad, Provincia, Ciudad, Provincia, 0 FROM proveedor
ORDER BY 2, 1;

SELECT * FROM aux_localidad ORDER BY Provincia_Original;

UPDATE `aux_localidad` SET Provincia_Normalizada = 'Buenos Aires'
WHERE Provincia_Original IN ('B. Aires',
                            'B.Aires',
                            'Bs As',
                            'Bs.As.',
                            'Buenos Aires',
                            'C Debuenos Aires',
                            'Caba',
                            'Ciudad De Buenos Aires',
                            'Pcia Bs As',
                            'Prov De Bs As.',
                            'Provincia De Buenos Aires');
							
UPDATE `aux_localidad` SET Localidad_Normalizada = 'Capital Federal'
WHERE Localidad_Original IN ('Boca De Atencion Monte Castro',
                            'Caba',
                            'Cap.   Federal',
                            'Cap. Fed.',
                            'Capfed',
                            'Capital',
                            'Capital Federal',
                            'Cdad De Buenos Aires',
                            'Ciudad De Buenos Aires')
AND Provincia_Normalizada = 'Buenos Aires';
							
UPDATE `aux_localidad` SET Localidad_Normalizada = 'Córdoba'
WHERE Localidad_Original IN ('Coroba',
                            'Cordoba',
							'Cã³rdoba')
AND Provincia_Normalizada = 'Córdoba';

DROP TABLE IF EXISTS `localidad`;
CREATE TABLE IF NOT EXISTS `localidad` (
  `IdLocalidad` int(11) NOT NULL AUTO_INCREMENT,
  `Localidad` varchar(80) NOT NULL,
  `Provincia` varchar(80) NOT NULL,
  `IdProvincia` int(11) NOT NULL,
  PRIMARY KEY (`IdLocalidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

DROP TABLE IF EXISTS `provincia`;
CREATE TABLE IF NOT EXISTS `provincia` (
  `IdProvincia` int(11) NOT NULL AUTO_INCREMENT,
  `Provincia` varchar(50) NOT NULL,
  PRIMARY KEY (`IdProvincia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO Localidad (Localidad, Provincia, IdProvincia)
	SELECT	DISTINCT Localidad_Normalizada, Provincia_Normalizada, 0
	FROM aux_localidad
	ORDER BY Provincia_Normalizada, Localidad_Normalizada;

INSERT INTO provincia (Provincia)
	SELECT DISTINCT Provincia_Normalizada
	FROM aux_localidad
	ORDER BY Provincia_Normalizada;

SELECT * FROM provincia;
SELECT * FROM localidad;

UPDATE localidad l
JOIN provincia p ON (l.Provincia = p.Provincia)
SET l.IdProvincia = p.IdProvincia;

UPDATE aux_localidad a
JOIN localidad l ON (l.Localidad = a.Localidad_Normalizada
                AND a.Provincia_Normalizada = l.Provincia)
SET a.IdLocalidad = l.IdLocalidad;

SELECT * FROM aux_localidad;

ALTER TABLE `cliente` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Localidad`;
ALTER TABLE `proveedor` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Departamento`;
ALTER TABLE `sucursal` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Provincia`;


ALTER TABLE cliente CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
UPDATE cliente c JOIN aux_localidad a
	ON (c.Provincia = a.Provincia_Original AND c.Localidad = a.Localidad_Original)
SET c.IdLocalidad = a.IdLocalidad;

ALTER TABLE sucursal CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
UPDATE sucursal s JOIN aux_localidad a
	ON (s.Provincia = a.Provincia_Original AND s.Localidad = a.Localidad_Original)
SET s.IdLocalidad = a.IdLocalidad;

ALTER TABLE proveedor CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
UPDATE proveedor p JOIN aux_localidad a
	ON (p.Provincia = a.Provincia_Original AND p.Ciudad = a.Localidad_Original)
SET p.IdLocalidad = a.IdLocalidad;

SELECT * FROM cliente;
SELECT * FROM proveedor;
SELECT * FROM sucursal;

ALTER TABLE `cliente`
  DROP `Provincia`,
  DROP `Localidad`;
  
ALTER TABLE `proveedor`
  DROP `Ciudad`,
  DROP `Provincia`,
  DROP `Pais`,
  DROP `Departamento`;
  
ALTER TABLE `sucursal`
  DROP `Localidad`,
  DROP `Provincia`;
  
ALTER TABLE `localidad`
  DROP `Provincia`;
  
SELECT * FROM `cliente`;
SELECT * FROM `proveedor`;
SELECT * FROM `sucursal`;
SELECT * FROM `localidad`;
SELECT * FROM `provincia`;

/*Discretización*/
ALTER TABLE `cliente` ADD `Rango_Etario` VARCHAR(20) NOT NULL DEFAULT '-' AFTER `Edad`;

UPDATE cliente SET Rango_Etario = '1_Hasta 30 años' WHERE Edad <= 30;
UPDATE cliente SET Rango_Etario = '2_De 31 a 40 años' WHERE Edad <= 40 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '3_De 41 a 50 años' WHERE Edad <= 50 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '4_De 51 a 60 años' WHERE Edad <= 60 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '5_Desde 60 años' WHERE Edad > 60 AND Rango_Etario = '-';

SELECT Rango_Etario, count(*)
FROM cliente
GROUP BY Rango_Etario;

SELECT * FROM venta
UNION ALL
SELECT * FROM aux_venta;