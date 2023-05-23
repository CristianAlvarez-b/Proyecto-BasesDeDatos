--Crear tablas
CREATE TABLE Ventas(
        id CHAR(5) NOT NULL,
        idEmpleado CHAR(8) NOT NULL,
        fecha DATE NOT NULL
);

CREATE TABLE DetallesVentas(
        id CHAR(5) NOT NULL,
        idVenta CHAR(5) NOT NULL,
        detalle VARCHAR(50) NOT NULL,
        cantidad NUMBER(5) NOT NULL,
        idPerecederos CHAR(8) NOT NULL,
        idNoPerecederos CHAR(8) NOT NULL
);

CREATE TABLE Generan(
        idCliente CHAR(8) NOT NULL,
        idVenta CHAR(5) NOT NULL
);

CREATE TABLE SeVenden(
        idPerecederos CHAR(8) NOT NULL,
        idNoPerecederos CHAR(8) NOT NULL,
        idVenta CHAR(5) NOT NULL
);

--XTablas
/*
DROP TABLE SeVenden;
DROP TABLE Generan;
DROP TABLE DetallesVentas;
DROP TABLE Ventas;
*/