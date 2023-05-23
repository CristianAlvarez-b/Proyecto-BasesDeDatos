
--ACCIONES REFERENCIALES

--CRUD: Personas
--En la eliminacion de id en Persona, actualizar en cascada
ALTER TABLE Clientes DROP CONSTRAINT FK_Clientes_Personas;
ALTER TABLE Empleados DROP CONSTRAINT FK_Empleados_Personas;
ALTER TABLE Clientes ADD CONSTRAINT FK_Clientes_Personas FOREIGN KEY (idPersonas) REFERENCES Personas(id) ON DELETE CASCADE;
ALTER TABLE Empleados ADD CONSTRAINT FK_Empleados_Personas FOREIGN KEY (idPersonas) REFERENCES Personas(id) ON DELETE CASCADE;
--CRUD: Proveedores

ALTER TABLE TelefonosP DROP CONSTRAINT FK_TelefonosP_Proveedores;
ALTER TABLE ComprasProveedores DROP CONSTRAINT FK_ComprasProveedores_Proveedores;
ALTER TABLE Perecederos DROP CONSTRAINT FK_Percederos_Proveedores;
ALTER TABLE noPerecederos DROP CONSTRAINT FK_noPercederos_Proveedores;
ALTER TABLE DetalleProductosCompras DROP CONSTRAINT FK_DetalleProductosCompras_noPerecederos;
ALTER TABLE DetalleProductosCompras DROP CONSTRAINT FK_DetalleProductosCompras_Perecederos;
ALTER TABLE DetalleProductosCompras ADD CONSTRAINT FK_DetalleProductosCompras_Perecederos FOREIGN KEY (idPerecederos) REFERENCES Perecederos(id) ON DELETE CASCADE;
ALTER TABLE DetalleProductosCompras ADD CONSTRAINT FK_DetalleProductosCompras_noPerecederos FOREIGN KEY (idNoPerecederos) REFERENCES noPerecederos(id) ON DELETE CASCADE;
ALTER TABLE ComprasProveedores ADD CONSTRAINT FK_ComprasProveedores_Proveedores FOREIGN KEY (idProveedor) REFERENCES Proveedores(id) ON DELETE CASCADE;
ALTER TABLE TelefonosP ADD CONSTRAINT FK_TelefonosP_Proveedores FOREIGN KEY (idProveedores) REFERENCES Proveedores(id) ON DELETE CASCADE;
ALTER TABLE Perecederos ADD CONSTRAINT FK_Percederos_Proveedores FOREIGN KEY (idProveedor) REFERENCES Proveedores(id) ON DELETE CASCADE;
ALTER TABLE noPerecederos ADD CONSTRAINT FK_noPercederos_Proveedores FOREIGN KEY (idProveedor) REFERENCES Proveedores(id) ON DELETE CASCADE;
--CRUD: Compras

ALTER TABLE ComprasProveedores DROP CONSTRAINT FK_ComprasProveedores_Compras;
ALTER TABLE DetallesCompras DROP CONSTRAINT FK_DetallesCompras_Compras;
ALTER TABLE DetalleProductosCompras DROP CONSTRAINT FK_DetalleProductosCompras_DetallesCompras;
ALTER TABLE ComprasProveedores ADD CONSTRAINT FK_ComprasProveedores_Compras FOREIGN KEY (idCompra) REFERENCES Compras(id) ON DELETE CASCADE;
ALTER TABLE DetallesCompras ADD CONSTRAINT FK_DetallesCompras_Compras FOREIGN KEY (idCompra) REFERENCES Compras(id) ON DELETE CASCADE;
ALTER TABLE DetalleProductosCompras ADD CONSTRAINT FK_DetalleProductosCompras_DetallesCompras FOREIGN KEY (idDetalleCompra, idCompra) REFERENCES DetallesCompras(id, idCompra) ON DELETE CASCADE;


--TRIGGERS
--CRUD: Personas
--Se genera automaticamente el id
CREATE OR REPLACE TRIGGER TR_Personas_automatizar
BEFORE INSERT ON Personas
FOR EACH ROW
DECLARE
consecutivo number;
BEGIN
    SELECT MAX(id) INTO consecutivo FROM Personas;
    IF consecutivo IS NULL THEN
        :NEW.id := 10000000;
    ELSE
        :NEW.id := consecutivo + 1;
    END IF;
END;
/
--El sueldo depende del puesto del empleado
CREATE OR REPLACE TRIGGER TR_Empleados_Sueldo
BEFORE INSERT ON Empleados
FOR EACH ROW
BEGIN
    IF :NEW.puesto = 1 THEN
        :NEW.sueldo := 1500000;
    ELSIF :NEW.puesto = 2 THEN
        :NEW.sueldo := 2500000;
    ELSE
        :NEW.sueldo := 4000000;
    END IF;
END;
/

--El estado inicial de los puntos de fidelidad es 10
CREATE OR REPLACE TRIGGER TR_Clientes_estadoInicial_Pf
BEFORE INSERT ON Clientes
FOR EACH ROW
BEGIN
    :NEW.puntosDeFidelidad := 10;
END;
/

--Solo se pueden insertar personas mayores de 12 años
CREATE OR REPLACE TRIGGER TR_Personas_edadMinima
BEFORE INSERT ON Personas
FOR EACH ROW
DECLARE
    fecha DATE;
BEGIN
    fecha := SYSDATE;
    IF MONTHS_BETWEEN(fecha, :NEW.fechaDeNacimiento) < 144 THEN
        raise_application_error(-20005, 'La edad minima es de 12 años');
    END IF;
END;
/

--Solo se puede modificar el puesto en un ascenso de 1 a 2 y de 2 a 3, el sueldo se asigna automaticamente segun ese cambio
CREATE OR REPLACE TRIGGER TR_Empleados_modificarPuesto_ascenso
BEFORE UPDATE ON Empleados
FOR EACH ROW
DECLARE
BEGIN
    IF  :NEW.departamento <> :OLD.departamento THEN
        RAISE_APPLICATION_ERROR(-20003, 'Solo se puede actualizar el puesto');
    ELSE
        IF :OLD.puesto = 1 AND :NEW.puesto = 1 THEN 
                                                    
            :NEW.sueldo := 1500000;                     
        ELSE
            IF :OLD.puesto = 1 AND :NEW.puesto = 3 THEN
                RAISE_APPLICATION_ERROR(-20013, 'Solo se puede ascender de puesto 1 a 2');
            ELSIF :NEW.puesto = 2 THEN
                :NEW.sueldo := 2500000;
            ELSE
                :NEW.sueldo := 4000000;
            END IF;
        END IF;
    END IF;
END;
/
--Solo se puede modificar el puesto en un descenso de 3 a 2 y de 2 a 1, el sueldo se asigna automaticamente segun ese cambio
CREATE OR REPLACE TRIGGER TR_Empleados_modificarPuesto_descenso
BEFORE UPDATE ON Empleados
FOR EACH ROW
DECLARE
BEGIN
    IF  :NEW.departamento <> :OLD.departamento THEN
        RAISE_APPLICATION_ERROR(-20003, 'Solo se puede actualizar el puesto');
    ELSE
        IF :OLD.puesto = 3 AND :NEW.puesto = 3 THEN
            :NEW.sueldo := 4000000;
        ELSE
            IF :OLD.puesto = 3 AND :NEW.puesto = 1 THEN
                RAISE_APPLICATION_ERROR(-20013, 'Solo se puede descender de puesto 3 a 2');
            ELSIF :NEW.puesto = 2 THEN
                :NEW.sueldo := 2500000;
            ELSE
                :NEW.sueldo := 1500000;
            END IF;
        END IF;
    END IF;
END;
/



--CRUD: Proveedores
--Automatizar proveedores
CREATE OR REPLACE TRIGGER TR_Proveedores_automatizar
BEFORE INSERT ON Proveedores
FOR EACH ROW
DECLARE
    consecutivo NUMBER(4);
BEGIN
    SELECT MAX(SUBSTR(id, 2)) INTO consecutivo FROM Proveedores WHERE id LIKE 'P%';
    IF consecutivo IS NULL THEN
        :NEW.id := 'P1000';
    ELSE
        :NEW.id := 'P' || TO_CHAR(consecutivo + 1, 'FM0000');
    END IF;
END;
/

--Solo se puede actualizar el correo del proveedor
CREATE OR REPLACE TRIGGER TR_Proveedor_modificar
BEFORE UPDATE ON Proveedores
FOR EACH ROW
BEGIN
    IF :NEW.id <> :OLD.id OR :NEW.nombre <> :OLD.nombre OR :NEW.direccion <> :OLD.direccion THEN
     RAISE_APPLICATION_ERROR(-20006, 'Solo se puede actualizar el correo del proveedor');
    END IF;
END;
/

--Solo se puede eliminar un proveedor si no tiene correo
CREATE OR REPLACE TRIGGER TR_Proveedor_eliminar
BEFORE DELETE ON Proveedores
FOR EACH ROW
BEGIN
    IF :OLD.correo IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20007, 'Solo se puede eliminar un proveedor si no tiene correo');
    END IF;
END;
/



--CRUD: Compras
--Disparadores
--Automatizar compras
CREATE OR REPLACE TRIGGER TR_Compras_automatizar
BEFORE INSERT ON Compras
FOR EACH ROW
DECLARE
    consecutivo NUMBER(4);
BEGIN
    SELECT MAX(SUBSTR(id, 2)) INTO consecutivo FROM Compras WHERE id LIKE 'C%';
    :NEW.fecha := SYSDATE;
    IF consecutivo IS NULL THEN
        :NEW.id := 'C1000';
    ELSE
        :NEW.id := 'C' || TO_CHAR(consecutivo + 1, 'FM0000');
    END IF;
END;
/
--Automatizar detalleCompras
CREATE OR REPLACE TRIGGER TR_DetallesCompras_automatizar
BEFORE INSERT ON DetallesCompras
FOR EACH ROW
DECLARE
    consecutivo NUMBER(4);
BEGIN
    SELECT MAX(SUBSTR(id, 2)) INTO consecutivo FROM DetallesCompras WHERE id LIKE 'C%';
    IF consecutivo IS NULL THEN
        :NEW.id := 'C1000';
    ELSE
        :NEW.id := 'C' || TO_CHAR(consecutivo + 1, 'FM0000');
    END IF;
END;
/
--Solo se puede modificar el estado de una compra si la deuda esta pagada, solo se puede modificar el estado
CREATE OR REPLACE TRIGGER TR_Compras_modificar
BEFORE UPDATE ON Compras
FOR EACH ROW
DECLARE
    deuda_actual NUMBER(9);
BEGIN
    SELECT SUM(DetallesCompras.deuda) INTO deuda_actual
    FROM DetallesCompras
    WHERE DetallesCompras.idCompra = :OLD.id;
    
    IF deuda_actual <> 0 OR :NEW.id <> :OLD.id OR :NEW.idEmpleados <> :OLD.idEmpleados OR :NEW.fecha <> :OLD.fecha THEN
        RAISE_APPLICATION_ERROR(-20008, 'Solo se puede modificar el estado de una compra si la deuda está pagada');
    END IF;
END;
/

--Solo se puede eliminar una compra que se encuentre en estado Cancelada
CREATE OR REPLACE TRIGGER TR_Compras_delete
BEFORE DELETE ON Compras
FOR EACH ROW
BEGIN
    IF :OLD.estado <> 'C' THEN
        RAISE_APPLICATION_ERROR(-20009, 'Solo se puede eliminar una compra que se encuentre en estado Cancelada');
    END IF;
END;
/




--CRUD: Productos
--Disparadores
--Automatizar id
CREATE OR REPLACE TRIGGER TR_Perecederos_automatizar
BEFORE INSERT ON Perecederos
FOR EACH ROW
DECLARE
consecutivo number;
BEGIN
    SELECT MAX(id) INTO consecutivo FROM Perecederos;
    IF consecutivo IS NULL THEN
        :NEW.id := 10000000;
    ELSE
        :NEW.id := consecutivo + 1;
    END IF;
END;
/
--Automatizar id
CREATE OR REPLACE TRIGGER TR_NoPerecederos_automatizar
BEFORE INSERT ON NoPerecederos
FOR EACH ROW
DECLARE
consecutivo number;
BEGIN
    SELECT MAX(id) INTO consecutivo FROM NoPerecederos;
    IF consecutivo IS NULL THEN
        :NEW.id := 10001000;
    ELSE
        :NEW.id := consecutivo + 1;
    END IF;
END;
/
--El nuevo precio no puede ser mayor o menor que el 10% del precio anterior
CREATE OR REPLACE TRIGGER TR_Perecederos_modificar
BEFORE UPDATE ON Perecederos
FOR EACH ROW
BEGIN
    IF :OLD.precio + :OLD.precio*0.10 < :NEW.precio OR :OLD.precio - :OLD.precio*0.10 > :NEW.precio THEN
        RAISE_APPLICATION_ERROR(-20010, 'El nuevo precio no puede ser mayor o menor que el 10% del precio anterior');
    END IF;
END;
/


--El nuevo precio no puede ser mayor o menor que el 10% del precio anterior
CREATE OR REPLACE TRIGGER TR_NoPerecederos_modificar
BEFORE UPDATE ON NoPerecederos
FOR EACH ROW
BEGIN
    IF :OLD.precio + :OLD.precio*0.10 < :NEW.precio OR :OLD.precio - :OLD.precio*0.10 > :NEW.precio THEN
        RAISE_APPLICATION_ERROR(-20010, 'El nuevo precio no puede ser mayor o menor que el 10% del precio anterior');
    END IF;
END;
/
--Solo se pueden eliminar productos caducados
CREATE OR REPLACE TRIGGER TR_Perecederos_delete
BEFORE DELETE ON Perecederos
FOR EACH ROW
DECLARE
    fechaActual DATE;
BEGIN
    fechaActual := SYSDATE;
    IF fechaActual < :OLD.fechaDeVencimiento THEN
        RAISE_APPLICATION_ERROR(-20011, 'Solo se pueden eliminar productos caducados');
    END IF;
END;
/
--Solo se pueden eliminar productos no perecederos si su cantidad es 0
CREATE OR REPLACE TRIGGER TR_NoPerecederos_delete
BEFORE DELETE ON NoPerecederos
FOR EACH ROW
BEGIN
   IF :OLD.cantidad <> 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Solo se pueden eliminar productos cuya existencia sea 0');
    END IF;
END;
/


--DisparadoresOk 
--CRUD: Personas
--Edad aceptada
insert into Personas (id, nombre, apellido, telefono, direccion, fechaDeNacimiento) values (10000032, 'Raymund', 'Tettley', '3987876855', '1459 Delladonna Drive', '16/09/2004');
SELECT * FROM Personas WHERE id = 10000201;
--Consuiltas!!!!
--Actualizar puesto ascenso
SELECT * FROM Empleados WHERE idPersonas = 10000137;
UPDATE Empleados SET puesto = 2 WHERE idPersonas = 10000137;
SELECT * FROM Empleados WHERE idPersonas = 10000137;
UPDATE Empleados SET puesto = 3 WHERE idPersonas = 10000137;
SELECT * FROM Empleados WHERE idPersonas = 10000137;
--Actualizar puesto descenso
UPDATE Empleados SET puesto = 2 WHERE idPersonas = 10000137;
SELECT * FROM Empleados WHERE idPersonas = 10000137;
UPDATE Empleados SET puesto = 1 WHERE idPersonas = 10000137;
SELECT * FROM Empleados WHERE idPersonas = 10000137;

--CRUD: Proveedores
--Solo se puede actualizar el correo del proveedor
SELECT * FROM Proveedores WHERE id = 'P1059';
UPDATE Proveedores SET correo = 'sergioLopez@gmail.com' WHERE id = 'P1059';
SELECT * FROM Proveedores WHERE id = 'P1059';
--Solo se puede eliminar un proveedor si no tiene correo
SELECT * FROM Proveedores WHERE id  BETWEEN 'P1059' AND 'P1062';
DELETE FROM Proveedores WHERE id = 'P1062';
SELECT * FROM Proveedores WHERE id  BETWEEN 'P1059' AND 'P1062';

--CRUD: Compras
--Solo se puede modificar el estado de una compra si la deuda esta pagada, solo se puede modificar el estado pendiente a cancelada
SELECT SUM(DetallesCompras.deuda) As Deuda FROM DetallesCompras WHERE DetallesCompras.idCompra = 'C1089';
SELECT * FROM Compras WHERE id BETWEEN 'C1087' AND 'C1089';
UPDATE Compras SET estado = 'C' WHERE id = 'C1089';
SELECT * FROM Compras WHERE id BETWEEN 'C1087' AND 'C1089';
--Solo se puede eliminar una compra que se encuentre en estado Cancelada
SELECT * FROM Compras WHERE id BETWEEN 'C1088' AND 'C1090';
DELETE Compras WHERE id = 'C1089';
SELECT * FROM Compras WHERE id BETWEEN 'C1088' AND 'C1090';

--CRUD: Productos
--El nuevo precio no puede ser mayor o menor que el 10% del precio anterior
SELECT nombre, precio FROM Perecederos WHERE id = 10000099;
UPDATE Perecederos SET precio = 327017130 WHERE id = 10000099;
SELECT nombre, precio FROM Perecederos WHERE id = 10000099;

--Solo se pueden eliminar productos caducados
insert into Perecederos (id, fechaDeVencimiento, nombre, precio, cantidad, idProveedor) values (10000102, '11/07/2019', 'Uvass pasas', 297288307, 78676, 'P1045');
SELECT * FROM Perecederos WHERE id BETWEEN 10000095 AND 10000100;
DELETE Perecederos WHERE id = 10000100;
SELECT * FROM Perecederos WHERE id BETWEEN 10000095 AND 10000100;
--Solo se pueden eliminar no perecederos si su cantidad es 0
insert into noPerecederos (id, tipo, nombre, precio, cantidad, idProveedor) values (10001001, 'D', 'Arrozz', 259266223, 0, 'P1031');

SELECT * FROM noPerecederos WHERE id BETWEEN 10001095 AND 10001100;
SELECT id, TRUNC(fechaDeVencimiento) - TRUNC(SYSDATE) AS diasRestantes FROM vencimiento_producto WHERE id = 10000100;
DELETE NoPerecederos WHERE id = 10001100;
SELECT * FROM noPerecederos WHERE id BETWEEN 10001095 AND 10001100;

--DisparadorNoOk
--CRUD: Personas
--La persona es menor de 12 años, no se permite insertar
insert into Personas (id, nombre, apellido, telefono, direccion, fechaDeNacimiento) values (10000032, 'Raymund', 'Tettley', '3887876855', '1459 Delladonna Drive', '16/09/2023');
--Se esta intentando modificar un valor diferente al puesto
UPDATE Empleados SET departamento = 'Ventas' WHERE idPersonas = 10000137;
--Se esta modificando los puesto de 1 a 3
UPDATE Empleados SET puesto = 3 WHERE idPersonas = 10000054;
--Se esta descendiendo del puesto 3 a 1
UPDATE Empleados SET puesto = 1 WHERE idPersonas = 10000197;

--CRUD: Proveedores
--Se esta tratando de actualizar un atributo que no es el correo
UPDATE Proveedores SET direccion = 'Venezuela' WHERE id = 'P1059';
--Se esta intentando eliminar un proveedor con correo
DELETE FROM Proveedores WHERE id = 'P1060';

--CRUD:Compras
--La deuda no esta pagada, por lo que no se puede actualizar
UPDATE Compras SET estado = 'C' WHERE id = 'C1079';
--No se puede eliminar porque el estado de la compra no es cancelada
DELETE Compras WHERE id = 'C1010';

--CRUD: Productos

--DisparadoresNoOk
UPDATE Perecederos SET precio = 999999999 WHERE id = 10000099;
DELETE Perecederos WHERE id = 10000093;
DELETE NoPerecederos WHERE id = 10001099;

--XDisparadores
DROP TRIGGER TR_Personas_automatizar;
DROP TRIGGER TR_Empleados_Sueldo;
DROP TRIGGER TR_Clientes_estadoInicial_Pf;
DROP TRIGGER TR_Personas_edadMinima;
DROP TRIGGER TR_Empleados_modificarPuesto_ascenso;
DROP TRIGGER TR_Empleados_modificarPuesto_descenso;
DROP TRIGGER TR_Proveedores_automatizar;
DROP TRIGGER TR_Proveedor_modificar;
DROP TRIGGER TR_Proveedor_eliminar;
DROP TRIGGER TR_Compras_automatizar;
DROP TRIGGER TR_DetallesCompras_automatizar;
DROP TRIGGER TR_Compras_modificar;
DROP TRIGGER TR_Compras_delete;
DROP TRIGGER TR_Perecederos_automatizar;
DROP TRIGGER TR_NoPerecederos_automatizar;
DROP TRIGGER TR_Perecederos_modificar;
DROP TRIGGER TR_NoPerecederos_modificar;
DROP TRIGGER TR_Perecederos_delete;
DROP TRIGGER TR_NoPerecederos_delete;


--AccionesOk
--CRUD: Personas
insert into Personas (id, nombre, apellido, telefono, direccion, fechaDeNacimiento) values (10000000, 'Steven', 'Stainbridge', '3976808419', '961 Corry Junction', '20/05/1982');
SELECT * FROM Personas WHERE id BETWEEN '10000195' AND '10000203';
DELETE FROM Personas WHERE id = 10000203;
SELECT * FROM Personas WHERE id BETWEEN '10000195' AND '10000203';
--CRUD: Proveedores

--CRUD: Compras


/*
--Tuplas
ALTER TABLE Perecederos ADD CONSTRAINT CK_Perecederos_precio_cantidad CHECK(Cantidad > -1 AND precio > -1);
ALTER TABLE NoPerecederos ADD CONSTRAINT CK_NoPerecederos_precio_cantidad CHECK(Cantidad > -1 AND precio > -1);

--TuplasOk
insert into Perecederos (id, fechaDeVencimiento, nombre, precio, cantidad, idProveedor) values (10000099, '11/07/2025', 'Uvax pasas', 0, 78676, 'P1045'); --0
insert into noPerecederos (id, tipo, nombre, precio, cantidad, idProveedor) values (10001001, 'D', 'Arrox', 56456, 48161, 'P1031');

--TuplasNoOk
insert into Perecederos (id, fechaDeVencimiento, nombre, precio, cantidad, idProveedor) values (10000099, '11/07/2025', 'Uvaxx pasas', -2, 78676, 'P1045');
insert into noPerecederos (id, tipo, nombre, precio, cantidad, idProveedor) values (10001001, 'D', 'Arroxx', -1, 48161, 'P1031');
*/
