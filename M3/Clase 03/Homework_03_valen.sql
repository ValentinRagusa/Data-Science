
USE henry_m3;
SELECT * FROM venta;

-- Una manera de analizar los Outliers puede ser por un periodo de tiempo definido, en este caso seleccionamos el promedio de precios por IdProducto (Cada producto) en el año 2018.
SELECT AVG(precio), 
		IdProducto,
        Fecha
	FROM venta
    WHERE YEAR(fecha) = 2018
    GROUP BY IdProducto, Fecha
    ORDER BY AVG(precio) DESC;
SELECT IdProducto, 
		ROUND(AVG(Precio), 2) AS Precio_Promedio, 
        ROUND(AVG(Precio) + (3 * STDDEV(Precio)), 2) AS Outlier_Max,
        Fecha
	FROM venta
    WHERE YEAR(Fecha) = 2018
    GROUP BY IdProducto, Fecha
    ORDER BY Precio_Promedio DESC;
/* Este proceso puede ser repetido varias veces hasta que hagamos el analisis que creamos necesario */
-- Veamos el año 2015:
SELECT Fecha,
		IdProducto, 
		ROUND(AVG(Precio), 2) AS Precio_Promedio, 
        ROUND(AVG(Precio) + (3 * STDDEV(Precio)), 2) AS Outlier_Max
	FROM venta
    WHERE YEAR(Fecha) = 2015
    GROUP BY IdProducto, Fecha
    ORDER BY Fecha;

-- Si queremos corroborar un producto en especifico bastaría con seleccionar su IdProducto y ver manualmente los precios o correr un loop entre ellos (tarea muy facil con Python) para verificar la variación entre sus precios. Cabe aclarar que habría que exportar la tabla primero para acceder a ella utlizando la función read_csv() de Pandas.

/* Tabla a exportar y loopear precio con Python usando Pandas: */
SELECT *
	FROM venta
    WHERE IdProducto = 42824;



-- Analisis general
SELECT IdProducto, 
		AVG(Precio) as promedio, 
		AVG(Precio) + (3 * stddev(Precio)) as maximo
FROM venta
GROUP BY IdProducto;

SELECT IdProducto, 
		avg(Precio) as promedio, 
		avg(Precio) - (3 * stddev(Precio)) as minimo
FROM venta
GROUP BY IdProducto;

SELECT v.*, 
		o.promedio, 
        o.maximo 
	FROM venta v
	JOIN (SELECT IdProducto, 
					ROUND(AVG(Precio), 2) as promedio, 
					ROUND(AVG(Precio) + (3 * stddev(Precio)), 2) as maximo
		FROM venta
		GROUP BY IdProducto) o
	ON (v.IdProducto = o.IdProducto)
	WHERE v.Precio > o.maximo;
    
SELECT *
FROM venta
WHERE IdProducto = 42883;
    
SELECT *
	FROM venta
    WHERE IdProducto = 42798;
    
SELECT *
	FROM venta
    WHERE IdProducto = 42893;
    
-- Es importante el analisis de Outliers porque en casos de ciertos productos, cuando se calcula el promedio, si hay una falla en la distincion de un número decimal o entero como puede ser 550.15 con 55015, el mismo tiende a elevarse por mucho mas de lo que en realidad debería ser. Si nosotros eliminamos estos outliers, obtenemos un promedio mucho mas cercano a su valor real.

/* ------------------------------------------------------------------------------ */


-- Introducimos los outliers de CANTIDAD en la tabla aux_venta
INSERT into aux_venta
SELECT v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal, v.IdEmpleado,
v.IdProducto, v.Precio, v.Cantidad, 2
	FROM venta v
	JOIN (SELECT IdProducto, 
					AVG(Cantidad) as promedio, 
					STDDEV(Cantidad) as Desv
		FROM venta
		GROUP BY IdProducto) v2
	ON (v.IdProducto = v2.IdProducto)
	WHERE v.Cantidad > (v2.Promedio + (3*v2.Desv)) OR v.Cantidad < (v2.Promedio - (3*v2.Desv)) OR v.Cantidad < 0;
    
-- Introducimos los Outliers de PRECIO en la tabla aux_venta
INSERT INTO aux_venta
SELECT v.IdVenta, v.Fecha, v.Fecha_entrega, v.IdCliente, v.IdSucursal, v.IdEmpleado, v.IdProducto, v.Precio, v.Cantidad, 3
	FROM venta v
    JOIN (SELECT IdProducto,
					AVG(Precio) as precioPromedio,
                    STDDEV(Precio) as Desv_Precio
		FROM venta
        GROUP BY IdProducto) v3
	ON (v.IdProducto = v3.IdProducto)
    WHERE v.Precio > (v3.precioPromedio + (3*v3.Desv_Precio)) OR v.Precio < (v3.precioPromedio - (3*v3.Desv_Precio)) OR v.Precio < 0;
    

/* ------------------------------------------------------------------------------ */

-- 										KPI's

-- Muestra de ventas con y sin Outliers.

ALTER TABLE venta ADD Outlier TINYINT  NOT NULL DEFAULT '1' AFTER Cantidad;
UPDATE venta v
JOIN aux_venta a
ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
SET v.Outlier = 0;

SELECT 	conOutliers.TipoProducto,
		conOutliers.PromedioVentaConOutliers,
        sinOutliers.PromedioVentaSinOutliers
	FROM
		(SELECT tp.TipoProducto,
				AVG(v.Precio * v.Cantidad) as PromedioVentaConOutliers
			FROM 	venta v 
				JOIN producto p
				ON (v.IdProducto = p.IdProducto)
				JOIN tipo_producto tp
				ON (p.IdTipoProducto = tp.IdTipoProducto)
			GROUP BY tp.TipoProducto) conOutliers
	JOIN
		(SELECT tp.TipoProducto,
				AVG(v.Precio * v.Cantidad) as PromedioVentaSinOutliers
			FROM 	venta v JOIN producto p
			ON (v.IdProducto = p.IdProducto and v.Outlier = 1)
			JOIN tipo_producto tp
			ON (p.IdTipoProducto = tp.IdTipoProducto)
		GROUP BY tp.TipoProducto) sinOutliers

	ON conOutliers.TipoProducto = sinOutliers.TipoProducto;

/* ------------------------------------------------------------------------------ */

-- KPI de Mayor cantidad de ventas por categoría.

SELECT 	Tipo_Producto.TipoProducto,
		Tipo_Producto.Cantidad_Productos_Vendidos
	FROM
		(SELECT tp.TipoProducto,
				SUM(v.Cantidad) as Cantidad_Productos_Vendidos
			FROM 	venta v 
				JOIN producto p
					ON (v.IdProducto = p.IdProducto)
				JOIN tipo_producto tp
					ON (p.IdTipoProducto = tp.IdTipoProducto)
			GROUP BY tp.TipoProducto) Tipo_Producto
	JOIN
		(SELECT SUM(Cantidad),
				IdProducto
			FROM henry_m3.venta
			GROUP BY CANTIDAD, IdProducto) cant
	GROUP BY Tipo_Producto.TipoProducto, Tipo_Producto.Cantidad_Productos_Vendidos
    ORDER BY Tipo_Producto.Cantidad_Productos_Vendidos DESC;
        
/* ------------------------------------------------------------------------------ */

-- EXTRA DEL PROFESOR:
-- KPI: Margen de Ganancia por producto superior a 20%
SELECT 	venta.Producto, 
		venta.SumaVentas, 
        venta.CantidadVentas, 
        venta.SumaVentasOutliers,
        compra.SumaCompras, 
        compra.CantidadCompras,
        ((venta.SumaVentas / compra.SumaCompras - 1) * 100) as margen
FROM
	(SELECT 	p.Producto,
			SUM(v.Precio * v.Cantidad * v.Outlier) 	as 	SumaVentas,
			SUM(v.Outlier) 							as	CantidadVentas,
			SUM(v.Precio * v.Cantidad) 				as 	SumaVentasOutliers,
			COUNT(*) 								as	CantidadVentasOutliers
	FROM venta v JOIN producto p
		ON (v.IdProducto = p.IdProducto
			AND YEAR(v.Fecha) = 2019)
	GROUP BY p.Producto) AS venta
JOIN
	(SELECT 	p.Producto,
			SUM(c.Precio * c.Cantidad) 				as SumaCompras,
			COUNT(*)								as CantidadCompras
	FROM compra c JOIN producto p
		ON (c.IdProducto = p.IdProducto
			AND YEAR(c.Fecha) = 2019)
	GROUP BY p.Producto) as compra
ON (venta.Producto = compra.Producto);


