--Crear tablas
CREATE TABLE Personas(
        id CHAR(8) NOT NULL,
        nombre VARCHAR(15) NOT NULL,
        apellido VARCHAR(20) NOT NULL,
        telefono NUMBER(10) NOT NULL,
        direccion VARCHAR(35) NOT NULL,
        fechaDeNacimiento DATE NOT NULL
);

CREATE TABLE Clientes(
        idPersonas CHAR(8) NOT NULL,
        puntosDeFidelidad NUMBER(3) NOT NULL
);

CREATE TABLE Empleados(
        idPersonas CHAR(8) NOT NULL,
        sueldo VARCHAR(8) NOT NULL,
        puesto NUMBER(1) NOT NULL,
        departamento VARCHAR(20) NOT NULL
);

CREATE TABLE Proveedores(
        id CHAR(5) NOT NULL,
        nombre VARCHAR(50) NOT NULL,
        direccion VARCHAR(35) NOT NULL,
        correo VARCHAR(50)
);

CREATE TABLE TelefonosP(
        numero NUMBER(10) NOT NULL,
        idProveedores CHAR(5) NOT NULL
);

CREATE TABLE Compras(
        id CHAR(5) NOT NULL,
        idEmpleados CHAR(8) NOT NULL,
        fecha DATE NOT NULL,
        estado CHAR(1) NOT NULL
);

CREATE TABLE ComprasProveedores(
        idCompra CHAR(5) NOT NULL,
        idProveedor CHAR(5) NOT NULL,
        precio NUMBER(9) NOT NULL
);
    
CREATE TABLE DetallesCompras(
        id CHAR(5) NOT NULL,
        idCompra CHAR(5) NOT NULL,
        detalle VARCHAR(50) NOT NULL,
        cantidad NUMBER(5) NOT NULL,
        deuda NUMBER(9) NOT NULL
);

CREATE TABLE Perecederos(
        id CHAR(8) NOT NULL,
        fechaDeVencimiento DATE NOT NULL,
        nombre VARCHAR(40) NOT NULL,
        precio NUMBER(9) NOT NULL,
        cantidad NUMBER(5) NOT NULL,
        idProveedor CHAR(5) NOT NULL
);

CREATE TABLE noPerecederos(
        id CHAR(8) NOT NULL,
        tipo CHAR(1) NOT NULL,
        nombre VARCHAR(40) NOT NULL,
        precio NUMBER(9) NOT NULL,
        cantidad NUMBER(5) NOT NULL,
        idProveedor CHAR(5) NOT NULL
);

CREATE TABLE DetalleProductosCompras(
        idPerecederos CHAR(8) NOT NULL,
        idNoPerecederos CHAR(8) NOT NULL,
        idCompra CHAR(5) NOT NULL,
        idDetalleCompra CHAR(5) NOT NULL
);

--XTablas
/*
DROP TABLE DetalleProductosCompras;
DROP TABLE ComprasProveedores;
DROP TABLE TelefonosP;
DROP TABLE noPerecederos;
DROP TABLE Perecederos;
DROP TABLE Proveedores;
DROP TABLE DetallesCompras;
DROP TABLE Compras;
DROP TABLE Clientes;
DROP TABLE Empleados;
DROP TABLE Personas;
*/