/*ACTORESE*/
CREATE OR REPLACE PACKAGE PA_ADMINISTRADOR AS
    PROCEDURE adicionar_Proveedores(p_id IN CHAR, p_nombre IN VARCHAR, p_direccion IN VARCHAR, p_correo IN VARCHAR);
    PROCEDURE modificar_Proveedores(p_id IN CHAR, p_correo IN VARCHAR);
    PROCEDURE eliminar_Proveedores(p_id IN CHAR);
    FUNCTION obtener_Precio_Proveedor(p_id IN CHAR) RETURN NUMBER;
    PROCEDURE adicionar_Compras(p_id IN CHAR, p_idempleados IN CHAR, p_fecha IN DATE, p_estado IN CHAR);
    PROCEDURE adicionar_detalleCompras(p_id IN CHAR, p_idcompra IN CHAR, p_detalle IN VARCHAR, p_cantidad IN NUMBER, p_deuda IN NUMBER);
    PROCEDURE modificar_Compras(p_id IN CHAR, p_estado IN CHAR);
    PROCEDURE eliminar_Compras(p_id IN CHAR);
    FUNCTION obtener_Total_Compras(p_id IN CHAR) RETURN SYS_REFCURSOR;
    PROCEDURE adicionar_persona(p_id IN CHAR, p_nombre IN VARCHAR, p_apellido IN VARCHAR, p_telefono IN NUMBER, p_direccion IN VARCHAR, p_fechadenacimiento IN DATE);
    PROCEDURE adicionar_empleado(p_idpersona IN CHAR, p_sueldo IN CHAR, p_puesto IN NUMBER, p_departamento IN VARCHAR);
    PROCEDURE adicionar_cliente(p_idpersona IN CHAR, p_puntosdefidelidad IN NUMBER);
    PROCEDURE modificar_persona(p_id IN CHAR, p_nombre IN VARCHAR, p_apellido IN VARCHAR, p_telefono IN NUMBER, p_direccion IN VARCHAR, p_fechadenacimiento IN DATE);
    PROCEDURE modificar_empleado_ascenso(p_idpersona IN CHAR);
    PROCEDURE modificar_empleado_descenso(p_idpersona IN CHAR);
    PROCEDURE eliminar_empleado(p_idpersona IN CHAR);
    PROCEDURE eliminar_cliente(p_idpersona IN CHAR);
    PROCEDURE eliminar_persona(p_id IN CHAR);
    FUNCTION obtener_ventas_empleados(p_idpersona IN CHAR) RETURN NUMBER;
    PROCEDURE adicionar_perecedero(p_id IN CHAR, p_fechadevencimiento IN DATE, p_nombre IN VARCHAR, p_precio IN NUMBER, p_cantidad IN NUMBER, p_idproveedor IN CHAR);
    PROCEDURE modificar_perecedero(p_id IN CHAR, p_fechadevencimiento IN DATE, p_nombre IN VARCHAR, p_precio IN NUMBER, p_cantidad IN NUMBER, p_idproveedor IN CHAR);
    PROCEDURE eliminar_perecedero(p_id IN CHAR);
    PROCEDURE adicionar_noPerecedero(p_id IN CHAR, p_tipo IN CHAR, p_nombre IN CHAR, p_precio IN NUMBER, p_cantidad IN NUMBER, p_idproveedor IN CHAR);
    PROCEDURE modificar_noPerecedero(p_id IN CHAR, p_tipo IN CHAR, p_nombre IN CHAR, p_precio IN NUMBER, p_cantidad IN NUMBER, p_idproveedor IN CHAR);
    PROCEDURE eliminar_noPerecedero(p_id IN CHAR);
    FUNCTION proximos_a_vencer(p_numero IN NUMBER)  RETURN SYS_REFCURSOR;
END PA_ADMINISTRADOR;
/

CREATE OR REPLACE PACKAGE PA_GERENTE_COMPRAS AS
    PROCEDURE adicionar_Proveedores(p_id IN CHAR, p_nombre IN VARCHAR, p_direccion IN VARCHAR, p_correo IN VARCHAR);
    PROCEDURE modificar_Proveedores(p_id IN CHAR, p_correo IN VARCHAR);
    PROCEDURE eliminar_Proveedores(p_id IN CHAR);
    FUNCTION obtener_Precio_Proveedor(p_id IN CHAR) RETURN NUMBER;
    PROCEDURE adicionar_Compras(p_id IN CHAR, p_idempleados IN CHAR, p_fecha IN DATE, p_estado IN CHAR);
    PROCEDURE adicionar_detalleCompras(p_id IN CHAR, p_idcompra IN CHAR, p_detalle IN VARCHAR, p_cantidad IN NUMBER, p_deuda IN NUMBER);
    PROCEDURE modificar_Compras(p_id IN CHAR, p_estado IN CHAR);
    PROCEDURE eliminar_Compras(p_id IN CHAR);
    FUNCTION obtener_Total_Compras(p_id IN CHAR) RETURN SYS_REFCURSOR;
END PA_GERENTE_COMPRAS;
/

CREATE OR REPLACE PACKAGE PA_SERVICIO_CLIENTE AS
    PROCEDURE adicionar_persona(p_id IN CHAR, p_nombre IN VARCHAR, p_apellido IN VARCHAR, p_telefono IN NUMBER, p_direccion IN VARCHAR, p_fechadenacimiento IN DATE);
    PROCEDURE adicionar_empleado(p_idpersona IN CHAR, p_sueldo IN CHAR, p_puesto IN NUMBER, p_departamento IN VARCHAR);
    PROCEDURE adicionar_cliente(p_idpersona IN CHAR, p_puntosdefidelidad IN NUMBER);
    PROCEDURE modificar_persona(p_id IN CHAR, p_nombre IN VARCHAR, p_apellido IN VARCHAR, p_telefono IN NUMBER, p_direccion IN VARCHAR, p_fechadenacimiento IN DATE);
    PROCEDURE modificar_empleado_ascenso(p_idpersona IN CHAR);
    PROCEDURE modificar_empleado_descenso(p_idpersona IN CHAR);
    PROCEDURE eliminar_empleado(p_idpersona IN CHAR);
    PROCEDURE eliminar_cliente(p_idpersona IN CHAR);
    PROCEDURE eliminar_persona(p_id IN CHAR);
    FUNCTION obtener_ventas_empleados(p_idpersona IN CHAR) RETURN NUMBER;
END PA_SERVICIO_CLIENTE;
/

/*ACTORESI*/
CREATE OR REPLACE PACKAGE BODY PA_ADMINISTRADOR AS
    PROCEDURE adicionar_Proveedores(p_id IN CHAR, p_nombre IN VARCHAR, p_direccion IN VARCHAR, p_correo IN VARCHAR) IS
    BEGIN   
        INSERT INTO Proveedores(id, nombre, direccion, correo)
        VALUES (p_id, p_nombre, p_direccion, p_correo);
        COMMIT;
    END adicionar_Proveedores;

    PROCEDURE modificar_Proveedores(p_id IN CHAR, p_correo IN VARCHAR) IS
    BEGIN
        UPDATE proveedores SET correo = p_correo WHERE id = p_id;
        COMMIT;
    END modificar_Proveedores;

    PROCEDURE eliminar_Proveedores(p_id IN CHAR) IS
        v_estado_correo VARCHAR(50);
    BEGIN
        SELECT correo INTO v_estado_correo FROM Proveedores WHERE id = p_id;
        IF v_estado_correo is NULL THEN
            DELETE FROM proveedores WHERE id = p_id;
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20045, 'No se puede eliminar un proveedor si su correo no es nulo');
            ROLLBACK;
        END IF;
    END eliminar_Proveedores;

    FUNCTION obtener_Precio_Proveedor(p_id IN CHAR) RETURN NUMBER IS
        v_precio NUMBER;
    BEGIN
        SELECT SUM(Total_Compras) INTO v_precio
        FROM precio_proveedor
        WHERE proveedor_id = p_id;
        RETURN v_precio;
    END obtener_Precio_Proveedor;
    PROCEDURE adicionar_Compras(p_id IN CHAR, p_idempleados IN CHAR, p_fecha IN DATE, p_estado IN CHAR) IS
    BEGIN
        INSERT INTO Compras(id, idempleados, fecha, estado)
        VALUES(p_id, p_idempleados, p_fecha, p_estado);
        COMMIT;
    END adicionar_Compras;
    
    PROCEDURE adicionar_detalleCompras(p_id IN CHAR, p_idcompra IN CHAR, p_detalle IN VARCHAR, p_cantidad IN NUMBER, p_deuda IN NUMBER) IS
    BEGIN
        INSERT INTO DetallesCompras(id, idcompra, detalle, cantidad, deuda)
        VALUES(p_id, p_idcompra, p_detalle, p_cantidad, p_deuda);
        COMMIT;
    END adicionar_detalleCompras;

    PROCEDURE modificar_Compras(p_id IN CHAR, p_estado IN CHAR) IS 
        deuda_actual NUMBER(9);
    BEGIN
        SELECT SUM(deuda) INTO deuda_actual
        FROM DetallesCompras
        WHERE idcompra = p_id;

        IF deuda_actual = 0 THEN
            UPDATE Compras SET estado = p_estado WHERE id = p_id;
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20008, 'Solo se puede modificar el estado de una compra si la deuda esta pagada');
            ROLLBACK;
        END IF;
    END modificar_Compras;

    PROCEDURE eliminar_Compras(p_id IN CHAR) IS
        v_estado_compra CHAR(1);
    BEGIN
        SELECT estado INTO v_estado_compra FROM Compras WHERE id = p_id;
        IF v_estado_compra = 'C' THEN
            DELETE FROM Compras WHERE id = p_id;
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20009, 'Solo se puede eliminar una compra que se encuentre en estado Cancelada');
            ROLLBACK;
        END IF;
    END eliminar_Compras;

    FUNCTION obtener_Total_Compras(p_id IN CHAR) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM total_compras WHERE id = p_id;
        RETURN v_cursor;
    END obtener_Total_Compras;
    PROCEDURE adicionar_persona(p_id IN CHAR, p_nombre IN VARCHAR, p_apellido IN VARCHAR, p_telefono IN NUMBER, p_direccion IN VARCHAR, p_fechadenacimiento IN DATE) IS
    BEGIN
        INSERT INTO Personas(id, nombre, apellido, telefono, direccion, fechaDeNacimiento)
        VALUES(p_id, p_nombre, p_apellido, p_telefono, p_direccion, p_fechadenacimiento);
        COMMIT;
    END adicionar_persona;
    
    PROCEDURE adicionar_empleado(p_idpersona IN CHAR, p_sueldo IN CHAR, p_puesto IN NUMBER, p_departamento IN VARCHAR) IS
    BEGIN
        INSERT INTO Empleados(idpersonas, sueldo, puesto, departamento)
        VALUES(p_idpersona, p_sueldo, p_puesto, p_departamento);
        COMMIT;
    END adicionar_empleado;
    
    PROCEDURE adicionar_cliente(p_idpersona IN CHAR, p_puntosdefidelidad IN NUMBER) IS
    BEGIN
        INSERT INTO Clientes(idPersonas, puntosdefidelidad)
        VALUES(p_idpersona, p_puntosdefidelidad);
        COMMIT;
    END adicionar_cliente;
    
    PROCEDURE modificar_persona(p_id IN CHAR, p_nombre IN VARCHAR, p_apellido IN VARCHAR, p_telefono IN NUMBER, p_direccion IN VARCHAR, p_fechadenacimiento IN DATE) IS
    BEGIN
        UPDATE Personas 
        SET nombre = p_nombre, apellido = p_apellido, telefono = p_telefono, direccion = p_direccion, fechaDeNacimiento = p_fechadenacimiento
        WHERE id = p_id;
        COMMIT;
    END modificar_persona;
    
    PROCEDURE modificar_empleado_ascenso(p_idpersona IN CHAR) IS
        v_puesto NUMBER(1);
    BEGIN
        SELECT puesto INTO v_puesto
        FROM Empleados
        WHERE idpersonas = p_idpersona;
        
        IF v_puesto = 1 THEN
            UPDATE Empleados SET puesto = 2 WHERE idpersonas = p_idpersona;
            COMMIT;
        ELSIF v_puesto = 2 THEN
            UPDATE Empleados SET puesto = 3 WHERE idpersonas = p_idpersona;
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20032, 'Maximo puesto alcanzado, no se puede ascender más');
            ROLLBACK;
        END IF;
    END modificar_empleado_ascenso;
    
    PROCEDURE modificar_empleado_descenso(p_idpersona IN CHAR) IS
        v_puesto NUMBER(1);
    BEGIN
        SELECT puesto INTO v_puesto
        FROM Empleados
        WHERE idpersonas = p_idpersona;
        
        IF v_puesto = 3 THEN
            UPDATE Empleados SET puesto = 2 WHERE idpersonas = p_idpersona;
            COMMIT;
        ELSIF v_puesto = 2 THEN
            UPDATE Empleados SET puesto = 1 WHERE idpersonas = p_idpersona;
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20032, 'Minimo puesto alcanzado, no se puede descender más. Sugerencia: Despedir');
            ROLLBACK;
        END IF;
    END modificar_empleado_descenso; 
    
    PROCEDURE eliminar_empleado(p_idpersona IN CHAR) IS
    BEGIN
        DELETE FROM Empleados WHERE idpersonas = p_idpersona;
        COMMIT;
    END eliminar_empleado; 
    PROCEDURE eliminar_cliente(p_idpersona IN CHAR) IS
    BEGIN
        DELETE FROM Clientes WHERE idPersonas = p_idpersona;
        COMMIT;
    END eliminar_cliente;
    PROCEDURE eliminar_persona(p_id IN CHAR) IS
    BEGIN
        DELETE FROM Personas WHERE id = p_id;
        COMMIT;
    END eliminar_persona;
    FUNCTION obtener_ventas_empleados(p_idpersona IN CHAR) RETURN NUMBER IS
        v_ventas NUMBER(2);
    BEGIN
        SELECT comprasHechas INTO  v_ventas FROM ventas_empleados WHERE idpersonas = p_idpersona;
        RETURN v_ventas;
    END obtener_ventas_empleados;
    PROCEDURE adicionar_perecedero(p_id IN CHAR, p_fechadevencimiento IN DATE, p_nombre IN VARCHAR, p_precio IN NUMBER, p_cantidad IN NUMBER, p_idproveedor IN CHAR) IS
    BEGIN
        INSERT INTO Perecederos(id, fechaDeVencimiento, nombre, precio, cantidad, idProveedor)
        VALUES(p_id, p_fechadevencimiento, p_nombre, p_precio, p_cantidad, p_idproveedor);
        COMMIT;
    END adicionar_perecedero;

    PROCEDURE modificar_perecedero(p_id IN CHAR, p_fechadevencimiento IN DATE, p_nombre IN VARCHAR, p_precio IN NUMBER, p_cantidad IN NUMBER, p_idproveedor IN CHAR) IS
    BEGIN
        UPDATE Perecederos SET fechaDeVencimiento = p_fechadevencimiento, nombre = p_nombre, precio = p_precio, cantidad = p_cantidad, idProveedor = p_idproveedor
        WHERE id = p_id;
        COMMIT;
    END modificar_perecedero; 

    PROCEDURE eliminar_perecedero(p_id IN CHAR) IS       
    BEGIN
        DELETE FROM Perecederos WHERE id = p_id;
        COMMIT;
    END eliminar_perecedero;

    PROCEDURE adicionar_noPerecedero(p_id IN CHAR, p_tipo IN CHAR, p_nombre IN CHAR, p_precio IN NUMBER, p_cantidad IN NUMBER, p_idproveedor IN CHAR) IS
    BEGIN
        INSERT INTO NoPerecederos(id, tipo, nombre, precio, cantidad, idProveedor)
        VALUES(p_id, p_tipo, p_nombre, p_precio, p_cantidad, p_idproveedor);
        COMMIT;
    END adicionar_noPerecedero;

    PROCEDURE modificar_noPerecedero(p_id IN CHAR, p_tipo IN CHAR, p_nombre IN CHAR, p_precio IN NUMBER, p_cantidad IN NUMBER, p_idproveedor IN CHAR) IS
    BEGIN
        UPDATE NoPerecederos SET tipo = p_tipo, nombre = p_nombre, precio = p_precio, cantidad = p_cantidad, idProveedor = p_idproveedor
        WHERE id = p_id;
        COMMIT;
    END modificar_noPerecedero;

    PROCEDURE eliminar_noPerecedero(p_id IN CHAR) IS
    BEGIN
        DELETE FROM NoPerecederos WHERE id = p_id;
        COMMIT;
    END eliminar_noPerecedero; 
    FUNCTION proximos_a_vencer(p_numero IN NUMBER) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
        SELECT id, nombre, fechaDeVencimiento FROM vencimiento_producto WHERE ROWNUM <= p_numero; 
        RETURN v_cursor;
    END proximos_a_vencer;
END PA_ADMINISTRADOR;
/

CREATE OR REPLACE PACKAGE BODY PA_GERENTE_COMPRAS AS
    PROCEDURE adicionar_Compras(p_id IN CHAR, p_idempleados IN CHAR, p_fecha IN DATE, p_estado IN CHAR) IS
    BEGIN
        INSERT INTO Compras(id, idempleados, fecha, estado)
        VALUES(p_id, p_idempleados, p_fecha, p_estado);
        COMMIT;
    END adicionar_Compras;
    
    PROCEDURE adicionar_detalleCompras(p_id IN CHAR, p_idcompra IN CHAR, p_detalle IN VARCHAR, p_cantidad IN NUMBER, p_deuda IN NUMBER) IS
    BEGIN
        INSERT INTO DetallesCompras(id, idcompra, detalle, cantidad, deuda)
        VALUES(p_id, p_idcompra, p_detalle, p_cantidad, p_deuda);
        COMMIT;
    END adicionar_detalleCompras;

    PROCEDURE modificar_Compras(p_id IN CHAR, p_estado IN CHAR) IS 
        deuda_actual NUMBER(9);
    BEGIN
        SELECT SUM(deuda) INTO deuda_actual
        FROM DetallesCompras
        WHERE idcompra = p_id;

        IF deuda_actual = 0 THEN
            UPDATE Compras SET estado = p_estado WHERE id = p_id;
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20008, 'Solo se puede modificar el estado de una compra si la deuda esta pagada');
            ROLLBACK;
        END IF;
    END modificar_Compras;

    PROCEDURE eliminar_Compras(p_id IN CHAR) IS
        v_estado_compra CHAR(1);
    BEGIN
        SELECT estado INTO v_estado_compra FROM Compras WHERE id = p_id;
        IF v_estado_compra = 'C' THEN
            DELETE FROM Compras WHERE id = p_id;
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20009, 'Solo se puede eliminar una compra que se encuentre en estado Cancelada');
            ROLLBACK;
        END IF;
    END eliminar_Compras;

    FUNCTION obtener_Total_Compras(p_id IN CHAR) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM total_compras WHERE id = p_id;
        RETURN v_cursor;
    END obtener_Total_Compras;
    PROCEDURE adicionar_Proveedores(p_id IN CHAR, p_nombre IN VARCHAR, p_direccion IN VARCHAR, p_correo IN VARCHAR) IS
    BEGIN   
        INSERT INTO Proveedores(id, nombre, direccion, correo)
        VALUES (p_id, p_nombre, p_direccion, p_correo);
        COMMIT;
    END adicionar_Proveedores;

    PROCEDURE modificar_Proveedores(p_id IN CHAR, p_correo IN VARCHAR) IS
    BEGIN
        UPDATE proveedores SET correo = p_correo WHERE id = p_id;
        COMMIT;
    END modificar_Proveedores;

    PROCEDURE eliminar_Proveedores(p_id IN CHAR) IS
        v_estado_correo VARCHAR(50);
    BEGIN
        SELECT correo INTO v_estado_correo FROM Proveedores WHERE id = p_id;
        IF v_estado_correo is NULL THEN
            DELETE FROM proveedores WHERE id = p_id;
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20045, 'No se puede eliminar un proveedor si su correo no es nulo');
            ROLLBACK;
        END IF;
    END eliminar_Proveedores;

    FUNCTION obtener_Precio_Proveedor(p_id IN CHAR) RETURN NUMBER IS
        v_precio NUMBER;
    BEGIN
        SELECT SUM(Total_Compras) INTO v_precio
        FROM precio_proveedor
        WHERE proveedor_id = p_id;
        RETURN v_precio;
    END obtener_Precio_Proveedor;
END PA_GERENTE_COMPRAS;
/

CREATE OR REPLACE PACKAGE BODY PA_SERVICIO_CLIENTE AS
    PROCEDURE adicionar_persona(p_id IN CHAR, p_nombre IN VARCHAR, p_apellido IN VARCHAR, p_telefono IN NUMBER, p_direccion IN VARCHAR, p_fechadenacimiento IN DATE) IS
    BEGIN
        INSERT INTO Personas(id, nombre, apellido, telefono, direccion, fechaDeNacimiento)
        VALUES(p_id, p_nombre, p_apellido, p_telefono, p_direccion, p_fechadenacimiento);
        COMMIT;
    END adicionar_persona;
    
    PROCEDURE adicionar_empleado(p_idpersona IN CHAR, p_sueldo IN CHAR, p_puesto IN NUMBER, p_departamento IN VARCHAR) IS
    BEGIN
        INSERT INTO Empleados(idpersonas, sueldo, puesto, departamento)
        VALUES(p_idpersona, p_sueldo, p_puesto, p_departamento);
        COMMIT;
    END adicionar_empleado;
    
    PROCEDURE adicionar_cliente(p_idpersona IN CHAR, p_puntosdefidelidad IN NUMBER) IS
    BEGIN
        INSERT INTO Clientes(idPersonas, puntosdefidelidad)
        VALUES(p_idpersona, p_puntosdefidelidad);
        COMMIT;
    END adicionar_cliente;
    
    PROCEDURE modificar_persona(p_id IN CHAR, p_nombre IN VARCHAR, p_apellido IN VARCHAR, p_telefono IN NUMBER, p_direccion IN VARCHAR, p_fechadenacimiento IN DATE) IS
    BEGIN
        UPDATE Personas 
        SET nombre = p_nombre, apellido = p_apellido, telefono = p_telefono, direccion = p_direccion, fechaDeNacimiento = p_fechadenacimiento
        WHERE id = p_id;
        COMMIT;
    END modificar_persona;
    
    PROCEDURE modificar_empleado_ascenso(p_idpersona IN CHAR) IS
        v_puesto NUMBER(1);
    BEGIN
        SELECT puesto INTO v_puesto
        FROM Empleados
        WHERE idpersonas = p_idpersona;
        
        IF v_puesto = 1 THEN
            UPDATE Empleados SET puesto = 2 WHERE idpersonas = p_idpersona;
            COMMIT;
        ELSIF v_puesto = 2 THEN
            UPDATE Empleados SET puesto = 3 WHERE idpersonas = p_idpersona;
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20032, 'Maximo puesto alcanzado, no se puede ascender más');
            ROLLBACK;
        END IF;
    END modificar_empleado_ascenso;
    
    PROCEDURE modificar_empleado_descenso(p_idpersona IN CHAR) IS
        v_puesto NUMBER(1);
    BEGIN
        SELECT puesto INTO v_puesto
        FROM Empleados
        WHERE idpersonas = p_idpersona;
        
        IF v_puesto = 3 THEN
            UPDATE Empleados SET puesto = 2 WHERE idpersonas = p_idpersona;
            COMMIT;
        ELSIF v_puesto = 2 THEN
            UPDATE Empleados SET puesto = 1 WHERE idpersonas = p_idpersona;
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20032, 'Minimo puesto alcanzado, no se puede descender más. Sugerencia: Despedir');
            ROLLBACK;
        END IF;
    END modificar_empleado_descenso; 
    
    PROCEDURE eliminar_empleado(p_idpersona IN CHAR) IS
    BEGIN
        DELETE FROM Empleados WHERE idpersonas = p_idpersona;
        COMMIT;
    END eliminar_empleado; 
    PROCEDURE eliminar_cliente(p_idpersona IN CHAR) IS
    BEGIN
        DELETE FROM Clientes WHERE idPersonas = p_idpersona;
        COMMIT;
    END eliminar_cliente;
    PROCEDURE eliminar_persona(p_id IN CHAR) IS
    BEGIN
        DELETE FROM Personas WHERE id = p_id;
        COMMIT;
    END eliminar_persona;
    FUNCTION obtener_ventas_empleados(p_idpersona IN CHAR) RETURN NUMBER IS
        v_ventas NUMBER(2);
    BEGIN
        SELECT comprasHechas INTO  v_ventas FROM ventas_empleados WHERE idpersonas = p_idpersona;
        RETURN v_ventas;
    END obtener_ventas_empleados;
END PA_SERVICIO_CLIENTE;
/

/*SEGURIDAD*/

CREATE ROLE ADMINISTRADOR;
GRANT EXECUTE ON PA_ADMINISTRADOR TO administrador;
GRANT EXECUTE ON PA_GERENTE_COMPRAS TO administrador;
GRANT EXECUTE ON PA_SERVICIO_CLIENTE TO administrador;

CREATE ROLE GERENTE_COMPRAS;
GRANT EXECUTE ON PA_GERENTE_COMPRAS TO GERENTE_COMPRAS;

CREATE ROLE SERVICIO_CLIENTE;
GRANT EXECUTE ON PA_SERVICIO_CLIENTE TO SERVICIO_CLIENTE;

/*SeguridadOk*/
SET SERVEROUTPUT ON
EXECUTE DBMS_SESSION.SET_ROLE('ADMINISTRADOR');
DECLARE
  resultado SYS_REFCURSOR;
BEGIN
  resultado := PA_ADMINISTRADOR.proximos_a_vencer(15);
  DBMS_SQL.RETURN_RESULT(resultado);
END;
/

SELECT * FROM COMPRAS WHERE id BETWEEN 'C1098' AND 'C1100';
EXECUTE DBMS_SESSION.SET_ROLE('GERENTE_COMPRAS');
BEGIN
    PA_GERENTE_COMPRAS.adicionar_Compras('C1100', '10000053', '30/09/2019', 'C');
END;
/

SELECT * FROM COMPRAS WHERE id BETWEEN 'C1098' AND 'C1100';

SELECT * FROM Empleados WHERE idpersonas = 10000152;
EXECUTE DBMS_SESSION.SET_ROLE('SERVICIO_CLIENTE');
BEGIN
  PA_SERVICIO_CLIENTE.modificar_empleado_ascenso(10000152);
END;
/
SELECT * FROM Empleados WHERE idpersonas = 10000152;

/*Xseguridad*/
REVOKE EXECUTE ON PA_GERENTE_COMPRAS FROM GERENTE_COMPRAS;
REVOKE EXECUTE ON PA_SERVICIO_CLIENTE FROM GERENTE_COMPRAS;
REVOKE EXECUTE ON PA_ADMINISTRADOR FROM ADMINISTRADOR;
REVOKE EXECUTE ON PA_GERENTE_COMPRAS FROM ADMINISTRADOR;
REVOKE EXECUTE ON PA_SERVICIO_CLIENTE FROM ADMINISTRADOR;
DROP ROLE SERVICIO_CLIENTE;
DROP ROLE GERENTE_COMPRAS;
DROP ROLE ADMINISTRADOR;
DROP PACKAGE PA_ADMINISTRADOR;
DROP PACKAGE PA_SERVICIO_CLIENTE;
DROP PACKAGE PA_GERENTE_COMPRAS;