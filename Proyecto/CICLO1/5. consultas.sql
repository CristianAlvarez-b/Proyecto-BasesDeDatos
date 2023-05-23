
--Consultar total compras
SELECT compras.id, COUNT(compras.id)AS cantidadVendida, SUM(DetallesCompras.cantidad) AS TotalVendido
FROM Compras
JOIN DetallesCompras ON compras.id = DetallesCompras.idCompra
WHERE EXTRACT(MONTH FROM fecha) = 5 AND EXTRACT(YEAR FROM fecha) = 2023
GROUP BY compras.id
ORDER BY cantidadVendida DESC;

--Consultar total ventas de un empleado
SELECT empleados.idpersonas, personas.nombre, personas.apellido, COUNT(compras.idEmpleados) AS comprasHechas
FROM Compras
JOIN Empleados ON compras.idEmpleados = empleados.idpersonas
JOIN Personas ON personas.id = empleados.idpersonas
WHERE EXTRACT(YEAR FROM compras.fecha) = 2023
GROUP BY empleados.idpersonas, personas.nombre, personas.apellido
ORDER BY comprasHechas DESC;


--Consultar fecha Productos proximos a vencer
SELECT id, nombre, fechaDeVencimiento
FROM (SELECT id, nombre, fechaDeVencimiento FROM Perecederos ORDER BY fechaDeVencimiento)
WHERE ROWNUM <= 100;

--Consultar precios del proveedor
SELECT compras.id, SUM(comprasProveedores.precio) AS Compras, proveedores.nombre
FROM Compras JOIN comprasproveedores ON compras.id = comprasProveedores.idCompra JOIN Proveedores ON comprasproveedores.idproveedor = proveedores.id
WHERE EXTRACT(YEAR FROM compras.fecha) = 2023
GROUP BY compras.id, proveedores.nombre
ORDER BY compras.id DESC;