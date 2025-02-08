-- PEDIDO COMPRA DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_pedido_compra_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select pcc.usu_codigo from pedido_compra_cab pcc where pcc.pedco_codigo=NEW.pedco_codigo);
		usuLogin = (select u.usu_login from pedido_compra_cab pcc join usuario u on u.usu_codigo=pcc.usu_codigo where pcc.pedco_codigo=NEW.pedco_codigo);
        INSERT INTO pedido_compra_det_auditoria (
            pedcodetaud_codigo,
            usu_codigo,
            usu_login,
            pedcodetaud_fecha,
            pedcodetaud_procedimiento,
            pedco_codigo,
            it_codigo,
            tipit_codigo,
            pedcodet_cantidad,
            pedcodet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(pedcodetaud_codigo), 0) + 1 FROM pedido_compra_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.pedco_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.pedcodet_cantidad,
            NEW.pedcodet_precio
        );

    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select pcc.usu_codigo from pedido_compra_cab pcc where pcc.pedco_codigo=OLD.pedco_codigo);
		usuLogin = (select u.usu_login from pedido_compra_cab pcc join usuario u on u.usu_codigo=pcc.usu_codigo where pcc.pedco_codigo=OLD.pedco_codigo);
        INSERT INTO pedido_compra_det_auditoria (
            pedcodetaud_codigo,
            usu_codigo,
            usu_login,
            pedcodetaud_fecha,
            pedcodetaud_procedimiento,
            pedco_codigo,
            it_codigo,
            tipit_codigo,
            pedcodet_cantidad,
            pedcodet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(pedcodetaud_codigo), 0) + 1 FROM pedido_compra_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,         
            'BAJA',       
            OLD.pedco_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.pedcodet_cantidad,
            OLD.pedcodet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

CREATE TRIGGER t_insercion_eliminacion_pedido_compra_det
AFTER INSERT OR DELETE ON pedido_compra_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_pedido_compra_det();

-- PRESUPUESTO PROVEEDOR DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_presupuesto_proveedor_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ppc.usu_codigo from presupuesto_proveedor_cab ppc where ppc.prepro_codigo=NEW.prepro_codigo);
		usuLogin = (select u.usu_login from presupuesto_proveedor_cab ppc join usuario u on u.usu_codigo=ppc.usu_codigo where ppc.prepro_codigo=NEW.prepro_codigo);
        INSERT INTO presupuesto_proveedor_det_auditoria (
            preprodetaud_codigo,
            usu_codigo,
            usu_login,
            preprodetaud_fecha,
            preprodetaud_procedimiento,
            prepro_codigo,
            it_codigo,
            tipit_codigo,
            peprodet_cantidad,
            peprodet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(preprodetaud_codigo), 0) + 1 FROM presupuesto_proveedor_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,-
            'ALTA',       
            NEW.prepro_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.peprodet_cantidad,
            NEW.peprodet_precio
        );

    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ppc.usu_codigo from presupuesto_proveedor_cab ppc where ppc.prepro_codigo=OLD.prepro_codigo);
		usuLogin = (select u.usu_login from presupuesto_proveedor_cab ppc join usuario u on u.usu_codigo=ppc.usu_codigo where ppc.prepro_codigo=OLD.prepro_codigo);
        INSERT INTO presupuesto_proveedor_det_auditoria (
            preprodetaud_codigo,
            usu_codigo,
            usu_login,
            preprodetaud_fecha,
            preprodetaud_procedimiento,
            prepro_codigo,
            it_codigo,
            tipit_codigo,
            peprodet_cantidad,
            peprodet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(preprodetaud_codigo), 0) + 1 FROM presupuesto_proveedor_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,        
            'BAJA',       
            OLD.prepro_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.peprodet_cantidad,
            OLD.peprodet_precio
        );
    END IF;
		RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_presupuesto_proveedor_det()
CREATE TRIGGER t_insercion_eliminacion_presupuesto_proveedor_det
AFTER INSERT OR DELETE ON presupuesto_proveedor_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_presupuesto_proveedor_det();

-- ORDEN COMPRA DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_orden_compra_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select occ.usu_codigo from orden_compra_cab occ where occ.orcom_codigo=NEW.orcom_codigo);
		usuLogin = (select u.usu_login from orden_compra_cab occ join usuario u on u.usu_codigo=occ.usu_codigo where occ.orcom_codigo=NEW.orcom_codigo);
        INSERT INTO orden_compra_det_auditoria(
            orcomdetaud_codigo,
            usu_codigo,
            usu_login,
            orcomdetaud_fecha,
            orcomdetaud_procedimiento,
            orcom_codigo,
            it_codigo,
            tipit_codigo,
            orcomdet_cantidad,
            orcomdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(orcomdetaud_codigo), 0) + 1 FROM orden_compra_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.orcom_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.orcomdet_cantidad,
            NEW.orcomdet_precio
        );

    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select occ.usu_codigo from orden_compra_cab occ where occ.orcom_codigo=OLD.orcom_codigo);
		usuLogin = (select u.usu_login from orden_compra_cab occ join usuario u on u.usu_codigo=occ.usu_codigo where occ.orcom_codigo=OLD.orcom_codigo);
        INSERT INTO orden_compra_det_auditoria(
            orcomdetaud_codigo,
            usu_codigo,
            usu_login,
            orcomdetaud_fecha,
            orcomdetaud_procedimiento,
            orcom_codigo,
            it_codigo,
            tipit_codigo,
            orcomdet_cantidad,
            orcomdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(orcomdetaud_codigo), 0) + 1 FROM orden_compra_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',
            OLD.orcom_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.orcomdet_cantidad,
            OLD.orcomdet_precio
        );
    END IF;
		RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

-- COMPRA DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_compra_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from compra_cab cc where cc.comp_codigo=NEW.comp_codigo);
		usuLogin = (select u.usu_login from compra_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.comp_codigo=NEW.comp_codigo);
        INSERT INTO compra_det_auditoria(
            compdetaud_codigo,
            usu_codigo,
            usu_login,
            compdetaud_fecha,
            compdetaud_procedimiento,
            comp_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            compdet_cantidad,
            compdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(compdetaud_codigo), 0) + 1 FROM compra_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.comp_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
            NEW.compdet_cantidad,
            NEW.compdet_precio
        );

    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from compra_cab cc where cc.comp_codigo=OLD.comp_codigo);
		usuLogin = (select u.usu_login from compra_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.comp_codigo=OLD.comp_codigo);
        INSERT INTO compra_det_auditoria(
            compdetaud_codigo,
            usu_codigo,
            usu_login,
            compdetaud_fecha,
            compdetaud_procedimiento,
            comp_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            compdet_cantidad,
            compdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(compdetaud_codigo), 0) + 1 FROM compra_det_auditoria), 
            usuCodigo, 
            usuLogin,
            current_timestamp,
            'BAJA',
            OLD.comp_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
            OLD.compdet_cantidad,
            OLD.compdet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_compra_det
CREATE TRIGGER t_insercion_eliminacion_compra_det
AFTER INSERT OR DELETE ON compra_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_compra_det();

-- TRIGGER
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_ajuste_inventario_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select aic.usu_codigo from ajuste_inventario_cab aic where aic.ajuin_codigo=NEW.ajuin_codigo);
		usuLogin = (select u.usu_login from ajuste_inventario_cab aic join usuario u on u.usu_codigo=aic.usu_codigo where aic.ajuin_codigo=NEW.ajuin_codigo);
        INSERT INTO ajuste_inventario_det_auditoria(
            ajuindetaud_codigo,
            usu_codigo,
            usu_login,
            ajuindetaud_fecha,
            ajuindetaud_procedimiento,
            ajuin_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            ajuindet_cantidad,
			ajuindet_motivo,
            ajuindet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(ajuindetaud_codigo), 0) + 1 FROM ajuste_inventario_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.ajuin_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
            NEW.ajuindet_cantidad,
			NEW.ajuindet_motivo,
            NEW.ajuindet_precio
        );

    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select aic.usu_codigo from ajuste_inventario_cab aic where aic.ajuin_codigo=OLD.ajuin_codigo);
		usuLogin = (select u.usu_login from ajuste_inventario_cab aic join usuario u on u.usu_codigo=aic.usu_codigo where aic.ajuin_codigo=OLD.ajuin_codigo);
        INSERT INTO ajuste_inventario_det_auditoria(
            ajuindetaud_codigo,
            usu_codigo,
            usu_login,
            ajuindetaud_fecha,
            ajuindetaud_procedimiento,
            ajuin_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            ajuindet_cantidad,
			ajuindet_motivo,
            ajuindet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(ajuindetaud_codigo), 0) + 1 FROM ajuste_inventario_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',   
            OLD.ajuin_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
            OLD.ajuindet_cantidad,
			OLD.ajuindet_motivo,
            OLD.ajuindet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_ajuste_inventario_det
CREATE TRIGGER t_insercion_eliminacion_ajuste_inventario_det
AFTER INSERT OR DELETE ON ajuste_inventario_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_ajuste_inventario_det();

--NOTA COMPRA DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_nota_compra_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ncc.usu_codigo from nota_compra_cab ncc where ncc.nocom_codigo=NEW.nocom_codigo);
		usuLogin = (select u.usu_login from nota_compra_cab ncc join usuario u on u.usu_codigo=ncc.usu_codigo where ncc.nocom_codigo=NEW.nocom_codigo);
        INSERT INTO nota_compra_det_auditoria(
            nocomdetaud_codigo,
            usu_codigo,
            usu_login,
            nocomdetaud_fecha,
            nocomdetaud_procedimiento,
            nocom_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            nocomdet_cantidad,
			nocomdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(nocomdetaud_codigo), 0) + 1 FROM nota_compra_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.nocom_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
            NEW.nocomdet_cantidad,
			NEW.nocomdet_precio
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ncc.usu_codigo from nota_compra_cab ncc where ncc.nocom_codigo=OLD.nocom_codigo);
		usuLogin = (select u.usu_login from nota_compra_cab ncc join usuario u on u.usu_codigo=ncc.usu_codigo where ncc.nocom_codigo=OLD.nocom_codigo);
        INSERT INTO nota_compra_det_auditoria(
            nocomdetaud_codigo,
            usu_codigo,
            usu_login,
            nocomdetaud_fecha,
            nocomdetaud_procedimiento,
            nocom_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            nocomdet_cantidad,
			nocomdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(nocomdetaud_codigo), 0) + 1 FROM nota_compra_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            OLD.nocom_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
            OLD.nocomdet_cantidad,
			OLD.nocomdet_precio
		);
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion 
CREATE TRIGGER t_insercion_eliminacion_nota_compra_det
AFTER INSERT OR DELETE ON nota_compra_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_nota_compra_det();


--STOCK
CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_eliminacion_stock()
RETURNS TRIGGER AS $$
--Creamos las variables
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO stock_auditoria(
            staud_codigo,
            staud_fecha,
            staud_procedimiento,
            it_codigo,
            tipit_codigo,
            dep_codigo,
			suc_codigo,
			emp_codigo,
			st_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(staud_codigo), 0) + 1 FROM stock_auditoria),   
            current_timestamp,
            'ALTA',   
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
            NEW.st_cantidad
        );
    -- Validamos si la operacion es de insercion
	ELSEIF TG_OP = 'UPDATE' THEN
    -- Registramos el valor anterior a que se actualice
    INSERT INTO stock_auditoria(
        staud_codigo,
        staud_fecha,
        staud_procedimiento,
        it_codigo,
        tipit_codigo,
        dep_codigo,
        suc_codigo,
        emp_codigo,
        st_cantidad
    )
    VALUES (
        (SELECT COALESCE(MAX(staud_codigo), 0) + 1 FROM stock_auditoria),   
        current_timestamp,
        'MODIFICACION_ANTERIOR',   
        OLD.it_codigo,
        OLD.tipit_codigo,
        OLD.dep_codigo,
        OLD.suc_codigo,
        OLD.emp_codigo,
        OLD.st_cantidad
    );
    -- Registramos el nuevo valor actualizado
    INSERT INTO stock_auditoria(
        staud_codigo,
        staud_fecha,
        staud_procedimiento,
        it_codigo,
        tipit_codigo,
        dep_codigo,
        suc_codigo,
        emp_codigo,
        st_cantidad
    )
    VALUES (
        (SELECT COALESCE(MAX(staud_codigo), 0) + 1 FROM stock_auditoria),   
        current_timestamp,
        'MODIFICACION_NUEVO',   
        NEW.it_codigo,
        NEW.tipit_codigo,
        NEW.dep_codigo,
        NEW.suc_codigo,
        NEW.emp_codigo,
        NEW.st_cantidad
    );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
        INSERT INTO stock_auditoria(
            staud_codigo,
            staud_fecha,
            staud_procedimiento,
            it_codigo,
            tipit_codigo,
            dep_codigo,
			suc_codigo,
			emp_codigo,
			st_cantidad
        )
		VALUES (
            (SELECT COALESCE(MAX(staud_codigo), 0) + 1 FROM stock_auditoria),   
            current_timestamp,
            'BAJA',   
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
            OLD.st_cantidad
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_eliminacion_stock
CREATE TRIGGER t_insercion_actualizacion_eliminacion_stock
AFTER INSERT OR UPDATE OR DELETE ON stock
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_eliminacion_stock();

