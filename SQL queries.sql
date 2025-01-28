#EJERCICO 1: CREACION DEL MODELO FISICO

CREATE TABLE prestamos_2015.merchant(
merchant_id VARCHAR(50),
name VARCHAR(25)
);

CREATE TABLE prestamos_2015.orders(
order_id VARCHAR(30),
created_at TIMESTAMP,
status VARCHAR(10),
amount FLOAT,
merchant_id VARCHAR(50),
country VARCHAR(15)
);

CREATE TABLE prestamos_2015.refunds(
order_id VARCHAR(30),
refunded_at TIMESTAMP,
amount FLOAT
);


#EJERCICIO 2
#EJERCICIO 2.1
SELECT `country`, `status`, COUNT(`country`) AS total_operaciones, ROUND(AVG(`amount`), 2) AS importe_promedio
FROM prestamos_2015.orders
WHERE `created_at` > "2015-07-01" AND `country` IN ("Espana", "Portugal", "Francia") AND `amount` > 100 AND `amount` < 1500
GROUP BY `country`, `status`
ORDER BY importe_promedio DESC;


#EJERCICIO 2.2 
SELECT `country`, COUNT(`country`) AS total_operaciones, MAX(`amount`) AS valor_maximo, MIN(`amount`) AS valor_minimo
FROM prestamos_2015.orders
WHERE `status` NOT IN ("DELINQUENT", "CANCELLED") AND `amount` > 100
GROUP BY `country`
ORDER BY total_operaciones DESC
LIMIT 3;


#EJERCICIO 3
#EJERCICIO 3.1
SELECT o.country, m.merchant_id, m.name, COUNT(o.country) AS total_operaciones, ROUND(AVG(o.amount), 2) AS valor_promedio, COUNT(r.order_id) AS total_devoluciones,
    CASE
		WHEN COUNT(r.order_id) > 0 THEN "Sí"
        ELSE "No"
	END AS acepta_devoluciones
FROM prestamos_2015.orders AS o INNER JOIN prestamos_2015.merchant AS m 
ON o.merchant_id=m.merchant_id
LEFT JOIN prestamos_2015.refunds AS r
ON o.order_id=r.order_id
WHERE o.country IN ("Marruecos", "Italia", "Espana", "Portugal")
GROUP BY o.country, o.merchant_id, m.name
HAVING total_operaciones > 10
ORDER BY total_operaciones ASC;


#EJERCICIO 3.2
CREATE VIEW prestamos_2015.orders_view AS
SELECT 
	o.*, 
    m.name,
    COALESCE(conteo_devoluciones, 0) AS conteo_devoluciones,
    COALESCE(valor_devoluciones, 0) AS valor_devoluciones
FROM
	prestamos_2015.orders AS o INNER JOIN prestamos_2015.merchant AS m ON o.merchant_id=m.merchant_id
    LEFT JOIN (
    SELECT r.order_id, COUNT(r.order_id) AS conteo_devoluciones, SUM(r.amount) AS valor_devoluciones
    FROM prestamos_2015.refunds AS r
    GROUP BY r.order_id) AS devoluciones ON o.order_id=devoluciones.order_id
HAVING conteo_devoluciones > 0 AND valor_devoluciones > 0;


#EJERCICIO 4
#1.- INSIGHT EXPLORATORIO
SELECT `country`, `name`, COUNT(`order_id`) AS cantidad_operaciones
FROM prestamos_2015.orders AS o INNER JOIN prestamos_2015.merchant AS m ON o.merchant_id=m.merchant_id
WHERE `created_at` BETWEEN "2015-07-01" AND "2015-09-30" AND `status`="CLOSED" AND `name`="Calcedonia"
GROUP BY `country`, `name`;


#2.- EXPLORACION TRIMESTRE DE MESES DE VERANO 
SELECT o.country, m.name, o.created_at, SUM(o.amount) AS sumatoria_ventas_x_dia,
CASE
	WHEN SUM(o.amount) > 0 AND SUM(o.amount) < 300 THEN "Bajo"
    WHEN SUM(o.amount) >= 300 AND SUM(o.amount) < 500 THEN "Medio"
    ELSE "Alto"
END AS Nivel_ventas
FROM prestamos_2015.orders AS o INNER JOIN prestamos_2015.merchant AS m
ON o.merchant_id=m.merchant_id
WHERE o.created_at BETWEEN "2015-07-01" AND "2015-09-30"
AND o.country = "Espana"
AND m.name = "Calcedonia"
AND o.status = "CLOSED"
GROUP BY 1, 2, 3
HAVING Nivel_ventas = "Alto"
ORDER BY o.created_at DESC;


#3.- EXPLORACION TRIMESTRE DE MESES DE VERANO 
SELECT o.country, m.name, o.created_at, SUM(o.amount) AS sumatoria_ventas_x_dia,
CASE
	WHEN SUM(o.amount) > 0 AND SUM(o.amount) < 300 THEN "Bajo"
    WHEN SUM(o.amount) >= 300 AND SUM(o.amount) < 500 THEN "Medio"
    ELSE "Alto"
END AS Nivel_ventas
FROM prestamos_2015.orders AS o INNER JOIN prestamos_2015.merchant AS m
ON o.merchant_id=m.merchant_id
WHERE o.created_at BETWEEN "2015-10-01" AND "2015-12-31"
AND o.country = "Espana"
AND m.name = "Calcedonia"
AND o.status = "CLOSED"
GROUP BY 1, 2, 3
HAVING Nivel_ventas = "Alto"
ORDER BY o.created_at DESC;


#4.- SUMATORIA TOTAL DE VENTAS DEL TRIMESTRE (Epoca inicio de verano y balnear)
SELECT SUM(sumatoria_ventas_x_dia) AS sumatoria_total_trimestre
FROM (SELECT o.country, m.name, o.created_at, SUM(o.amount) AS sumatoria_ventas_x_dia,
CASE
	WHEN SUM(o.amount) > 0 AND SUM(o.amount) < 300 THEN "Bajo"
    WHEN SUM(o.amount) >= 300 AND SUM(o.amount) < 500 THEN "Medio"
    ELSE "Alto"
END AS Nivel_ventas
FROM prestamos_2015.orders AS o INNER JOIN prestamos_2015.merchant AS m
ON o.merchant_id=m.merchant_id
WHERE o.created_at BETWEEN "2015-07-01" AND "2015-09-30"
AND o.country = "Espana"
AND m.name = "Calcedonia"
AND o.status = "CLOSED"
GROUP BY 1, 2, 3
HAVING Nivel_ventas = "Alto"
ORDER BY o.created_at DESC) AS subconsulta1;


#5.- SUMATORIA TOTAL DE VENTAS DEL TRIMESTRE (Epoca inicio de invierno y navidad)
SELECT SUM(sumatoria_ventas_x_dia) AS sumatoria_total_trimestre
FROM (SELECT o.country, m.name, o.created_at, SUM(o.amount) AS sumatoria_ventas_x_dia,
CASE
	WHEN SUM(o.amount) > 0 AND SUM(o.amount) < 300 THEN "Bajo"
    WHEN SUM(o.amount) >= 300 AND SUM(o.amount) < 500 THEN "Medio"
    ELSE "Alto"
END AS Nivel_ventas
FROM prestamos_2015.orders AS o INNER JOIN prestamos_2015.merchant AS m
ON o.merchant_id=m.merchant_id
WHERE o.created_at BETWEEN "2015-10-01" AND "2015-12-31"
AND o.country = "Espana"
AND m.name = "Calcedonia"
AND o.status = "CLOSED"
GROUP BY 1, 2, 3
HAVING Nivel_ventas = "Alto"
ORDER BY o.created_at DESC) AS subconsulta2;