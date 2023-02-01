
USE henry_m3;
/* Vamos a sacar la cantidad total de empleados cuyo cargo es administrativo (IdCargo = 1) */

SELECT COUNT(IdEmpleado)
	FROM empleado
	WHERE IdCargo = 1; -- Execution time: 0:00:0.00060000

-- Calculamos el promedio de salario de todas las personas cuyo cargo es administrativo de la sucursal 13;

SELECT IdCargo,
		ROUND(AVG(Salario2), 2) AS Salario_Promedio
	FROM Empleado
    WHERE IdCargo = 1 AND IdSucursal = 13
    GROUP BY IdCargo; -- Execution time: 0:00:0.00059500

SELECT SUM(v.Cantidad);


SELECT ca.trimestre, 
		c.Rango_Etario, 
		SUM(v.Precio * v.Cantidad) as venta
	FROM venta v
	JOIN cliente c ON(v.IdCliente = c.IdCliente) -- AND YEAR(v.Fecha) = 2020)
	JOIN calendario ca ON(ca.Fecha = v.Fecha)
	WHERE YEAR(v.Fecha) = 2020
	GROUP BY ca.trimestre, c.Rango_Etario
	ORDER BY ca.trimestre, c.Rango_Etario; -- Execution time: 0:00:1.88803900


