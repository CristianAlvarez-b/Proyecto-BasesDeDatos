
--Indices
CREATE INDEX idx_ventas_fecha ON Ventas(fecha);

--Vistas
--Consultar total compras del cliente
CREATE VIEW total_compras_cliente AS 
SELECT personas.nombre, personas.apellido, COUNT(generan.idCliente) AS comprasHechas
FROM Generan JOIN Ventas ON generan.idventa = ventas.id
JOIN Clientes ON generan.idCliente = clientes.idpersonas
JOIN Personas ON personas.id = clientes.idpersonas
WHERE EXTRACT(YEAR FROM ventas.fecha) = 2023
GROUP BY clientes.idpersonas, personas.nombre, personas.apellido
ORDER BY comprasHechas DESC;

--IndicesVistasOk
--
SELECT * FROM total_compras_cliente WHERE ROWNUM <= 10;

/*
--XIndices
DROP INDEX idx_ventas_fecha;
--XVistas
DROP VIEW total_compras_cliente;
*/