USE henry;

-- 1) ¿Cuantas carreas tiene Henry?
SELECT COUNT(idCarrera)
	FROM carrera;

-- 2) ¿Cuantos alumnos hay en total?
SELECT COUNT(DISTINCT idAlumno)
	FROM alumno;
    
-- 3) ¿Cuantos alumnos tiene cada cohorte?
SELECT idCohorte, COUNT(*) as cantidad_alumnos
	FROM alumno
    GROUP BY idCohorte;

-- 4) Confecciona un listado de los alumnos ordenado por los últimos alumnos que ingresaron, con nombre y apellido en un solo campo.
SELECT concat(nombre, ' ', apellido) AS nombre_apellido, 
		fechaIngreso
	FROM alumno
	ORDER BY fechaIngreso DESC;

-- 5) ¿Cual es el nombre del primer alumno que ingreso a Henry?
SELECT concat(nombre, ' ', apellido) AS nombre_apellido
	FROM alumno
    ORDER BY fechaIngreso
    LIMIT 1;
    
-- 6) ¿En que fecha ingresó?
SELECT concat(nombre, ' ', apellido) AS nombre_apellido, 
		fechaIngreso
	FROM alumno
    ORDER BY fechaIngreso
    LIMIT 1;

-- 7) ¿Cual es el nombre del ultimo alumno que ingreso a Henry?
SELECT concat(nombre, ' ', apellido) AS nombre_apellido, 
		fechaIngreso
	FROM alumno
    ORDER BY fechaIngreso DESC
    LIMIT 1;

-- 8) La función YEAR le permite extraer el año de un campo date, utilice esta función y especifique cuantos alumnos ingresarona a Henry por año.
SELECT YEAR(fechaIngreso) AS año, 
		count(*) AS cantidad_alumnos
	FROM alumno
	GROUP BY YEAR(fechaIngreso)
	ORDER BY año;
    
-- 9) ¿Cuantos alumnos ingresaron por semana a henry?, indique también el año. WEEKOFYEAR()
SELECT YEAR(fechaIngreso) AS año, 
		WEEKOFYEAR(fechaIngreso) AS semana_año, 
        COUNT(*) AS cantidad_alumnos
	FROM alumno
    GROUP BY YEAR(fechaIngreso), WEEKOFYEAR(fechaIngreso)
    ORDER BY año;

-- 10) ¿En que años ingresaron más de 20 alumnos?
SELECT YEAR(fechaIngreso) as Año, 
		COUNT(*) AS cantidad_alumnos
	FROM alumno
	GROUP BY YEAR(fechaIngreso)
    HAVING count(*) > 20
	ORDER BY 1;

-- 11) Investigue las funciones TIMESTAMPDIFF() y CURDATE(). ¿Podría utilizarlas para saber cual es la edad de los instructores?. ¿Como podrías verificar si la función cálcula años completos? Utiliza DATE_ADD().
-- con esto visualizo un ejemplo para calcular manual
SELECT fechaNacimiento, 
		CONCAT(nombre, " ", apellido) AS nombre_apellido 
	FROM instructor
    LIMIT 1;

-- RESPUESTA: No calcula años completos:
SELECT CONCAT(nombre, " ", apellido) AS nombre_apellido, 
		TIMESTAMPDIFF(YEAR, i.fechaNacimiento, CURDATE()) AS edad_años,
		TIMESTAMPDIFF(MONTH, i.fechaNacimiento, CURDATE()) AS edad_meses,
		DATE_ADD(fechaNacimiento, INTERVAL (TIMESTAMPDIFF(YEAR,fechaNacimiento, curdate())) YEAR) AS verificacion
FROM instructor i;

-- 12) Cálcula:
-- 		- La edad de cada alumno.
-- 		- La edad promedio de los alumnos de henry.
-- 		- La edad promedio de los alumnos de cada cohorte.





