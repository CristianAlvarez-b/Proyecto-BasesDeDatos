--ACCIONES REFERENCIALES

ALTER TABLE DetallesVentas DROP CONSTRAINT FK_DETALLESVENTAS_VENTAS;
ALTER TABLE Generan DROP CONSTRAINT FK_GENERAN_VENTAS;

ALTER TABLE Generan ADD CONSTRAINT FK_Generan_Ventas FOREIGN KEY (idVenta) REFERENCES Ventas(id) ON DELETE CASCADE;
ALTER TABLE DetallesVentas ADD CONSTRAINT FK_DetallesVentas_Ventas FOREIGN KEY (idVenta) REFERENCES Ventas(id) ON DELETE CASCADE;


--TRIGGERS
--CRUD: Ventas
--Se genera automaticamente el id

CREATE OR REPLACE TRIGGER TR_ventas_automatizar
BEFORE INSERT ON Ventas
FOR EACH ROW
DECLARE
    consecutivo NUMBER(4);
BEGIN
    SELECT MAX(SUBSTR(id, 2)) INTO consecutivo FROM Ventas WHERE id LIKE 'V%';
    IF :NEW.fecha > SYSDATE THEN
        :NEW.fecha := SYSDATE;
    END IF;
    IF consecutivo IS NULL THEN
        :NEW.id := 'V1000';
    ELSE
        :NEW.id := 'V' || TO_CHAR(consecutivo + 1, 'FM0000');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER TR_detalles_ventas_automatizar
BEFORE INSERT ON DetallesVentas
FOR EACH ROW
DECLARE
    consecutivo NUMBER(4);
BEGIN
    SELECT MAX(SUBSTR(id, 2)) INTO consecutivo FROM DetallesVentas WHERE id LIKE 'V%';
    IF consecutivo IS NULL THEN
        :NEW.id := 'V1000';
    ELSE
        :NEW.id := 'V' || TO_CHAR(consecutivo + 1, 'FM0000');
    END IF;
END;
/

--solo se puede actualizar una venta, si no ha pasado más de una semana, y Solo se puede modificar la cantidad y el detalle.
CREATE OR REPLACE TRIGGER TR_DetallesVentas_modificar
BEFORE UPDATE ON DetallesVentas
FOR EACH ROW
DECLARE
    fecha DATE;
BEGIN
    SELECT fecha INTO fecha FROM Ventas WHERE id = :OLD.idVenta;
    IF (fecha - SYSDATE) > 7 THEN
        RAISE_APPLICATION_ERROR(-20022, 'Solo se puede actualizar una venta, si no ha pasado más de una semana');
    END IF;
    IF :NEW.id <> :OLD.id OR :NEW.idventa <> :OLD.idventa OR :NEW.idPerecederos <> :OLD.idPerecederos OR :NEW.idNoPerecederos <> :OLD.idNoPerecederos THEN
        RAISE_APPLICATION_ERROR(-20023, 'Solo se puede modificar la cantidad y el detalle');
    END IF;
END;
/

--Solo se puede borrar una venta si ha pasado mas de dos años desde su registro.
CREATE OR REPLACE TRIGGER TR_Ventas_eliminar
BEFORE DELETE ON Ventas
FOR EACH ROW
DECLARE
    fecha DATE;
BEGIN
    IF TRUNC(SYSDATE - :OLD.fecha) < (365*2) THEN
        RAISE_APPLICATION_ERROR(-20024, 'Solo se puede borrar una venta si ha pasado mas de dos años desde su registro');
    END IF;
END;
/


--Disparadores Ok
insert into Ventas (id, idEmpleado, fecha) values ('V1000', '10000134', '13/08/2022');
SELECT * FROM Ventas;


insert into DetallesVentas (id, idventa, detalle, cantidad, idPerecederos, idNoPerecederos) values ('V1000', 'V1006', 'uEeGcjzDMkCYWIOWaIasKeGHpYZWEGFBNbEhDvre', 43074, 10000059, 10001028);
SELECT * FROM DetallesVentas;


UPDATE detallesventas SET cantidad = 15 WHERE idventa = 'V1099';

SELECT * FROM VEntas WHERE id = 'V1057';
DELETE FROM ventas WHERE id = 'V1057';
--Disparadores NO ok
UPDATE detallesventas SET cantidad = 15 WHERE idventa = 'V1035';
UPDATE detallesventas SET id = 15 WHERE idventa = 'V1099';
DELETE FROM ventas WHERE id = 'V1004';

--XDisparadores
DROP TRIGGER TR_Ventas_eliminar;
DROP TRIGGER TR_DetallesVentas_modificar;
DROP TRIGGER TR_detalles_ventas_automatizar;
DROP TRIGGER TR_ventas_automatizar;