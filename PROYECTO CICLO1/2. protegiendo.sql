    --Protegiendo
    /*1*/

    /*PK*/
    ALTER TABLE Personas ADD CONSTRAINT PK_Personas PRIMARY KEY (id);
    ALTER TABLE Clientes ADD CONSTRAINT PK_Clientes PRIMARY KEY (idPersonas);
    ALTER TABLE Empleados ADD CONSTRAINT PK_Empleados PRIMARY KEY (idPersonas);
    ALTER TABLE Proveedores ADD CONSTRAINT PK_Proveedores PRIMARY KEY (id);
    ALTER TABLE TelefonosP ADD CONSTRAINT PK_TelefonosP PRIMARY KEY (numero, idProveedores);
    ALTER TABLE Compras ADD CONSTRAINT PK_Compras PRIMARY KEY (id);
    ALTER TABLE ComprasProveedores ADD CONSTRAINT PK_ComprasProveedores PRIMARY KEY (idCompra, idProveedor);
    ALTER TABLE DetallesCompras ADD CONSTRAINT PK_DetallesCompras PRIMARY KEY (id, idCompra);
    ALTER TABLE Perecederos ADD CONSTRAINT PK_Percederos PRIMARY KEY (id);
    ALTER TABLE noPerecederos ADD CONSTRAINT PK_noPercederos PRIMARY KEY (id);
    ALTER TABLE DetalleProductosCompras ADD CONSTRAINT PK_DetalleProductosCompras PRIMARY KEY (idPerecederos, idNoPerecederos, idCompra, idDetalleCompra);

    /*UK*/
    ALTER TABLE Personas ADD CONSTRAINT UK_Personas_telefono UNIQUE (telefono);
    ALTER TABLE Proveedores ADD CONSTRAINT UK_Proveedor_nombre UNIQUE (nombre);
    ALTER TABLE Perecederos ADD CONSTRAINT UK_Perecederos_nombre UNIQUE(nombre);
    ALTER TABLE noPerecederos ADD CONSTRAINT UK_noPerecederos_nombre UNIQUE(nombre);

    /*FK*/
    ALTER TABLE Clientes ADD CONSTRAINT FK_Clientes_Personas FOREIGN KEY (idPersonas) REFERENCES Personas(id);
    ALTER TABLE Empleados ADD CONSTRAINT FK_Empleados_Personas FOREIGN KEY (idPersonas) REFERENCES Personas(id);
    ALTER TABLE TelefonosP ADD CONSTRAINT FK_TelefonosP_Proveedores FOREIGN KEY (idProveedores) REFERENCES Proveedores(id);
    ALTER TABLE Compras ADD CONSTRAINT FK_Compras_Empleados FOREIGN KEY (idEmpleados) REFERENCES Empleados(idPersonas);
    ALTER TABLE ComprasProveedores ADD CONSTRAINT FK_ComprasProveedores_Compras FOREIGN KEY (idCompra) REFERENCES Compras(id);
    ALTER TABLE ComprasProveedores ADD CONSTRAINT FK_ComprasProveedores_Proveedores FOREIGN KEY (idProveedor) REFERENCES Proveedores(id);
    ALTER TABLE DetallesCompras ADD CONSTRAINT FK_DetallesCompras_Compras FOREIGN KEY (idCompra) REFERENCES Compras(id);
    ALTER TABLE Perecederos ADD CONSTRAINT FK_Percederos_Proveedores FOREIGN KEY (idProveedor) REFERENCES Proveedores(id);
    ALTER TABLE noPerecederos ADD CONSTRAINT FK_noPercederos_Proveedores FOREIGN KEY (idProveedor) REFERENCES Proveedores(id);
    ALTER TABLE DetalleProductosCompras ADD CONSTRAINT FK_DetalleProductosCompras_Perecederos FOREIGN KEY (idPerecederos) REFERENCES Perecederos(id);
    ALTER TABLE DetalleProductosCompras ADD CONSTRAINT FK_DetalleProductosCompras_noPerecederos FOREIGN KEY (idNoPerecederos) REFERENCES noPerecederos(id);
    ALTER TABLE DetalleProductosCompras ADD CONSTRAINT FK_DetalleProductosCompras_DetallesCompras FOREIGN KEY (idDetalleCompra, idCompra) REFERENCES DetallesCompras(id, idCompra);


    /*CK*/
    ALTER TABLE Perecederos ADD CONSTRAINT CK_Perecederos_id CHECK(id > 9999999);
    ALTER TABLE NoPerecederos ADD CONSTRAINT CK_NoPerecederos_id CHECK(id > 9999999);
    ALTER TABLE Perecederos ADD CONSTRAINT CK_Perecederos_precio CHECK(precio > -1 AND precio < 1000000000);
    ALTER TABLE NoPerecederos ADD CONSTRAINT CK_NoPerecederos_precio CHECK(precio > -1 AND precio < 1000000000);
    ALTER TABLE DetallesCompras ADD CONSTRAINT CK_DetallesCompras_precio CHECK(deuda > -1 AND deuda < 1000000000);
    ALTER TABLE Personas ADD CONSTRAINT CK_Personas_telefono CHECK(telefono LIKE '3%');
    ALTER TABLE noPerecederos ADD CONSTRAINT CK_noPerecederos_tipo CHECK(tipo IN('D','E'));
    ALTER TABLE Compras ADD CONSTRAINT CK_Compras_estado CHECK(estado IN('C','P'));
    ALTER TABLE Empleados ADD CONSTRAINT CK_Empleados_puesto CHECK(puesto IN('1','2','3'));
    ALTER TABLE Proveedores ADD CONSTRAINT CK_Proveedores_correo CHECK (REGEXP_LIKE(correo,'^[^@]+@[^@]+\.[^@]+$'));
    ALTER TABLE Empleados ADD CONSTRAINT CK_Empleados_depa CHECK(departamento IN('Financiero', 'Recursos Humanos', 'Marketing', 'Comercial', 'Compras', 'Control de Gestion', 'Logistica',  'Ventas', 'Comunicacion'));
    ALTER TABLE Empleados ADD CONSTRAINT CK_Empleados_sueldo CHECK(sueldo < 4000001);
    ALTER TABLE ComprasProveedores ADD CONSTRAINT CK_ComprasProveedores_moneda CHECK(precio > 0 AND precio < 1000000000);



/*
NO SE PERMITEN


--PK
--La pk no puede ser nula
insert into Personas (id, nombre, apellido, telefono, direccion, fechaDeNacimiento) values (NULL, 'Steven', 'Stainbridge', '3476808419', '961 Corry Junction', '20/05/1982');
--UK
--No se pueden repetir valores de llaves unicas, atributo nombre
insert into Perecederos (id, fechaDeVencimiento, nombre, precio, cantidad, idProveedor) values (10000004, '02/06/2026', 'Uvas', 314509774, 8332, 'P1041');
insert into Perecederos (id, fechaDeVencimiento, nombre, precio, cantidad, idProveedor) values (10000005, '06/06/2026', 'Uvas', 314509774, 8332, 'P1041');
--FK
--No se pueden ingresar datos que no esten referenciados

insert into Clientes (idPersonas, puntosDeFidelidad) values (10000066, '575');
insert into Personas (id, nombre, apellido, telefono, direccion, fechaDeNacimiento) values (10000000, 'Steven', 'Stainbridge', '3476808419', '961 Corry Junction', '20/05/1982');
--CK
--Los telefonos deben empezar por 3
insert into Personas (id, nombre, apellido, telefono, direccion, fechaDeNacimiento) values (10000000, 'Steven', 'Stainbridge', '9476808419', '961 Corry Junction', '20/05/1982');
--El atributo tipo debe ser D o E
insert into noPerecederos (id, tipo, nombre, precio, cantidad, idProveedor) values (10001004, 'F', 'Cereales', 425441812, 15908, 'P1071');
--El correo debe tener . y un unico arroba(@)
insert into Proveedores (id, nombre, direccion, correo) values ('P1006', 'Altdfasierre', '14 Westridge Point', 'ccsdfsafsd@@madsf.dsaf');
--El estado de compras debe ser C o P
insert into Compras (id, idEmpleados, fecha, estado) values ('C1096', '10000105', '24/09/2019', 'L');
--El nivel del puesto debe ser 1, 2 o 3
insert into Empleados (idPersonas, sueldo, puesto, departamento) values (10000164, 3525449, '7', 'Compras');
--El correo debe tener solo un arroba y tener al menos un punto
insert into Proveedores (id, nombre, direccion, correo) values ('P1038', 'Food Lion', '89 Prentice Court', 'gclare12@@technorati.com');
--El departamento debe pertenecer a 'Financiero', 'Recursos Humanos', 'Marketing', 'Comercial', 'Compras', 'Control de Gestion', 'Logistica',  'Ventas', 'Comunicacion'.
insert into Empleados (idPersonas, sueldo, puesto, departamento) values (10000164, 3525449, '2', 'Videojuegos');
--El sueldo de los empleados no debe superar los 4 millones
insert into Empleados (idPersonas, sueldo, puesto, departamento) values (10000164, 4000001, '7', 'Compras');
*/