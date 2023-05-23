CREATE OR REPLACE PACKAGE PC_Ventas AS
    PROCEDURE adicionar_ventas(p_id IN CHAR, p_idempleado IN CHAR, p_fecha IN DATE);
    PROCEDURE adicionar_detalles_ventas(p_id IN CHAR, p_idventa IN CHAR, p_detalle IN VARCHAR, p_cantidad IN NUMBER, p_idPerecederos IN CHAR, p_idNoPerecederos IN CHAR);
    PROCEDURE modificar_detalles_ventas(p_id IN CHAR, p_detalle IN VARCHAR, p_cantidad IN NUMBER);
    PROCEDURE eliminar_ventas(p_id IN CHAR);
    --FUNCTION
END PC_Ventas;
/

--CRUDI
CREATE OR REPLACE PACKAGE BODY PC_Ventas IS
    PROCEDURE adicionar_ventas(p_id IN CHAR, p_idempleado IN CHAR, p_fecha IN DATE) IS
    BEGIN
        INSERT INTO ventas(id, idempleado, fecha)
        VALUES (p_id, p_idempleado, p_fecha);
        COMMIT;
    END adicionar_ventas;

    PROCEDURE adicionar_detalles_ventas(p_id IN CHAR, p_idventa IN CHAR, p_detalle IN VARCHAR, p_cantidad IN NUMBER, p_idPerecederos IN CHAR, p_idNoPerecederos IN CHAR) IS
    BEGIN
        INSERT INTO detallesventas(id, idventa, detalle, cantidad, idPerecederos, idNoPerecederos)
        VALUES (p_id, p_idventa, p_detalle, p_cantidad, p_idPerecederos, p_idNoPerecederos);
        COMMIT;
    END adicionar_detalles_ventas;

    PROCEDURE modificar_detalles_ventas(p_id IN CHAR, p_detalle IN VARCHAR, p_cantidad IN NUMBER) IS
    BEGIN
        UPDATE detallesventas SET detalle = p_detalle, cantidad = p_cantidad WHERE id = p_id;
        COMMIT;
    END modificar_detalles_ventas;

    PROCEDURE eliminar_ventas(p_id IN CHAR) IS
        v_fecha DATE;
    BEGIN
        SELECT fecha INTO v_fecha FROM Ventas WHERE id = p_id; 
        IF TRUNC(SYSDATE - v_fecha) < (365*2) THEN
            RAISE_APPLICATION_ERROR(-20024, 'Solo se puede borrar una venta si ha pasado más de dos años desde su registro');
        ELSE
            DELETE FROM Ventas WHERE id = p_id;
            COMMIT;
        END IF;
    END eliminar_ventas;
END PC_Ventas;
/

--CRUD OK
--Adicionar
BEGIN
    PC_Ventas.adicionar_ventas('V1000', '10000134', '13/08/2017');
END;
/
SELECT * FROM Ventas WHERE id = 'V1100';
--Adicionar
BEGIN
    PC_Ventas.adicionar_detalles_ventas('V1000', 'V1100', 'uEeGcjzDMkCYWIOWaIasKeGHpYZWEGFBNbEhDvre', 43074, 10000059, 10001028);
END;
/
SELECT * FROM DetallesVentas WHERE id = 'V1100';
--Modificar
BEGIN
    PC_Ventas.modificar_detalles_ventas('V1100', '3 jugos de manzana verde', 274);
END;
/
SELECT * FROM DetallesVentas WHERE id = 'V1100';
--Eliminar
BEGIN
    PC_Ventas.eliminar_ventas('V1100');
END;
/
SELECT * FROM Ventas WHERE id = 'V1100';
SELECT * FROM DetallesVentas WHERE id = 'V1100';

--CRUD NOOK
BEGIN
    PC_Ventas.eliminar_ventas('V1004');
END;
/
/*
--XCRUD
DROP PACKAGE PC_Ventas;
*/

        