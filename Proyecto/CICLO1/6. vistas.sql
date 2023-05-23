--Indices
CREATE INDEX idx_compras_fecha ON Compras (fecha);
--Vistas
--Consultar total compras
CREATE VIEW total_compras AS SELECT compras.id, COUNT(compras.id)AS cantidadVendida, SUM(DetallesCompras.cantidad) AS TotalVendido
FROM Compras
JOIN DetallesCompras ON compras.id = DetallesCompras.idCompra
WHERE EXTRACT(MONTH FROM fecha) = 5 AND EXTRACT(YEAR FROM fecha) = 2023
GROUP BY compras.id
ORDER BY cantidadVendida DESC;
--Consultar total ventas de un empleado
CREATE VIEW ventas_empleados AS SELECT empleados.idpersonas, personas.nombre, personas.apellido, COUNT(compras.idEmpleados) AS comprasHechas
FROM Compras
JOIN Empleados ON compras.idEmpleados = empleados.idpersonas
JOIN Personas ON personas.id = empleados.idpersonas
WHERE EXTRACT(YEAR FROM compras.fecha) = 2023
GROUP BY empleados.idpersonas, personas.nombre, personas.apellido
ORDER BY comprasHechas DESC;
-- Consultar fecha Productos proximos a vencer
CREATE VIEW vencimiento_producto AS SELECT id, nombre, fechaDeVencimiento
FROM (SELECT id, nombre, fechaDeVencimiento FROM Perecederos ORDER BY fechaDeVencimiento)
WHERE ROWNUM <= 100;
-- Consultar precios del proveedor
CREATE VIEW precio_proveedor AS 
SELECT proveedores.id AS proveedor_id, compras.id AS compra_id, SUM(comprasProveedores.precio) AS total_compras, proveedores.nombre
FROM Compras 
JOIN comprasproveedores ON compras.id = comprasProveedores.idCompra 
JOIN Proveedores ON comprasproveedores.idproveedor = proveedores.id
WHERE EXTRACT(YEAR FROM compras.fecha) = 2023
GROUP BY proveedores.id, compras.id, proveedores.nombre
ORDER BY compras.id DESC;

--IndicesVistasOk
--Ver las primeras dias compras con mayor monto del mes
SELECT * FROM total_compras WHERE ROWNUM <= 10;
--Ver los 3 mejores empleados y la cantidad de ventas Hechas
SELECT nombre, apellido, comprasHechas FROM ventas_empleados ORDER BY comprasHechas DESC FETCH FIRST 3 ROWS ONLY;
-- Ver el nombre de los 5 productos mas prontos a vencer y los que ya estan vencidos, y ver los dias que restan para que se dañe
SELECT id, nombre, fechaDeVencimiento, TRUNC(fechaDeVencimiento) - TRUNC(SYSDATE) AS diasRestantes FROM vencimiento_producto WHERE ROWNUM <= 20 ORDER BY diasRestantes ASC;
--Consultar los 10 proveedores con los precios mas bajos
SELECT * FROM precio_proveedor WHERE ROWNUM <= 10 ORDER BY total_compras ASC;
/*
--XIndices
DROP INDEX idx_compras_fecha;
--XVistas
DROP VIEW total_compras;
DROP VIEW ventas_empleados;
DROP VIEW vencimiento_producto;
DROP VIEW precio_proveedor;
*/