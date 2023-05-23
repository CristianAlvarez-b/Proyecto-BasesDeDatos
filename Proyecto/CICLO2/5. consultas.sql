/*COMO Gerente Ventas QUIERO consultar el total de compras de un cliente en el mes PARA PODER redefinir sus puntos de fidelidad

Detalle:
-------
1. id, nombre cliente, numeroVentas
2. Orden de mayor a menor por cantidad de compras echas
3. Cada mes
*/

SELECT personas.nombre, personas.apellido, COUNT(generan.idCliente) AS comprasHechas
FROM Generan JOIN Ventas ON generan.idventa = ventas.id
JOIN Clientes ON generan.idCliente = clientes.idpersonas
JOIN Personas ON personas.id = clientes.idpersonas
WHERE EXTRACT(YEAR FROM ventas.fecha) = 2023
GROUP BY clientes.idpersonas, personas.nombre, personas.apellido
ORDER BY comprasHechas DESC;