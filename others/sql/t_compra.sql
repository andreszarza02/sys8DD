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
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_ajuste_stock_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select aju.usu_codigo from ajuste_stock_cab aju where aju.ajus_codigo=NEW.ajus_codigo);
		usuLogin = (select u.usu_login from ajuste_stock_cab aju join usuario u on u.usu_codigo=aju.usu_codigo where aju.ajus_codigo=NEW.ajus_codigo);
        INSERT INTO ajuste_stock_det_auditoria(
            ajusdetaud_codigo,
            usu_codigo,
            usu_login,
            ajusdetaud_fecha,
            ajusdetaud_procedimiento,
            ajus_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            ajusdet_cantidad,
			ajusdet_precio,
            ajusdet_motivo
        )
        VALUES (
            (SELECT COALESCE(MAX(ajusdetaud_codigo), 0) + 1 FROM ajuste_stock_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.ajus_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
            NEW.ajusdet_cantidad,
			NEW.ajusdet_precio,
            NEW.ajusdet_motivo
        );

    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select aju.usu_codigo from ajuste_stock_cab aju where aju.ajus_codigo=OLD.ajus_codigo);
		usuLogin = (select u.usu_login from ajuste_stock_cab aju join usuario u on u.usu_codigo=aju.usu_codigo where aju.ajus_codigo=OLD.ajus_codigo);
        INSERT INTO ajuste_stock_det_auditoria(
            ajusdetaud_codigo,
            usu_codigo,
            usu_login,
            ajusdetaud_fecha,
            ajusdetaud_procedimiento,
            ajus_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            ajusdet_cantidad,
			ajusdet_precio,
            ajusdet_motivo
        )
        VALUES (
            (SELECT COALESCE(MAX(ajusdetaud_codigo), 0) + 1 FROM ajuste_stock_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',   
            OLD.ajus_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
            OLD.ajusdet_cantidad,
			OLD.ajusdet_precio,
            OLD.ajusdet_motivo
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_ajuste_stock_det
CREATE TRIGGER t_insercion_eliminacion_ajuste_stock_det
AFTER INSERT OR DELETE ON ajuste_stock_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_ajuste_stock_det();

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

-- Libro Compra y Cuenta Pagar
CREATE OR REPLACE FUNCTION spt_actualizacion_libro_compra_cuenta_pagar() 
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE tipoImpuesto integer;
		monto5 numeric;
		monto10 numeric;
		exenta numeric;
		monto numeric;
		codigo_comprobante integer;
		comprobante varchar;
		numero_comprobante varchar;
		codigoUsuario integer;
		usuario varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		-- Consultamos datos para modificacion en libro_compra y cuenta_pagar
		-- Consultamos datos del item
		select i.tipim_codigo into tipoImpuesto from items i where i.it_codigo=NEW.it_codigo;
		-- Definimos valores por defecto a las variables 
		monto5 := 0;
	    monto10 := 0;
	    exenta := 0;
		monto := 0;
		-- Validamos y asignamos la multiplicacion en base al tipo de impuesto, esto solo para libro_compra
		if tipoImpuesto = 1 then -- 5%
			if NEW.tipit_codigo = 3 then -- validamos servicio
				monto5 := round(NEW.compdet_precio);
			else 
				monto5 := round(NEW.compdet_cantidad*NEW.compdet_precio);
			end if;
		elseif tipoImpuesto = 2 then -- 10%
			if NEW.tipit_codigo = 3 then -- validamos servicio
				monto10 := round(NEW.compdet_precio);
			else 
				monto10 := round(NEW.compdet_cantidad*NEW.compdet_precio);
			end if;
		else -- exenta
			if NEW.tipit_codigo = 3 then -- validamos servicio
				exenta := round(NEW.compdet_precio);
			else 
				exenta := round(NEW.compdet_cantidad*NEW.compdet_precio);
			end if;
		end if;
		-- Multiplicamos cantidad por precio y asignamos a total, esto solo para cuenta pagar
		if NEW.tipit_codigo = 3 then -- validamos servicio
			monto := round(NEW.compdet_precio);
		else 
			monto := round(NEW.compdet_cantidad*NEW.compdet_precio);
		end if;
		-- Consultamos datos de la cabecera
		select cc.tipco_codigo into codigo_comprobante from compra_cab cc where cc.comp_codigo=NEW.comp_codigo;
		select tc.tipco_descripcion into comprobante from compra_cab cc join tipo_comprobante tc on tc.tipco_codigo=cc.tipco_codigo  where cc.comp_codigo=NEW.comp_codigo;
		select cc.comp_numfactura into numero_comprobante from compra_cab cc where cc.comp_codigo=NEW.comp_codigo;
		select cc.usu_codigo into codigoUsuario from compra_cab cc where cc.comp_codigo=NEW.comp_codigo;
		select u.usu_login into usuario from compra_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.comp_codigo=NEW.comp_codigo;
		-- Llamamos al sp de libro compra y le pasamos los parametros
	    perform sp_libro_compra(NEW.comp_codigo, exenta, monto5, monto10, codigo_comprobante, comprobante, numero_comprobante, 1, codigoUsuario, usuario);
		-- Llammos al sp de cuenta pagar y le pasamos los parametros
		perform sp_cuenta_pagar(NEW.comp_codigo, monto, monto, 1, codigoUsuario, usuario);
    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		-- Consultamos datos para modificacion en libro_compra y cuenta_pagar
		-- Consultamos datos del item
		select i.tipim_codigo into tipoImpuesto from items i where i.it_codigo=OLD.it_codigo;
		-- Definimos valores por defecto a las variables 
		monto5 := 0;
	    monto10 := 0;
	    exenta := 0;
		monto := 0;
		-- Validamos y asignamos la multiplicacion en base al tipo de impuesto, esto solo para libro_compra
		if tipoImpuesto = 1 then -- 5%
			if OLD.tipit_codigo = 3 then -- validamos servicio
				monto5 := round(OLD.compdet_precio);
			else 
				monto5 := round(OLD.compdet_cantidad*OLD.compdet_precio);
			end if;
		elseif tipoImpuesto = 2 then -- 10%
			if OLD.tipit_codigo = 3 then -- validamos servicio
				monto10 := round(OLD.compdet_precio);
			else 
				monto10 := round(OLD.compdet_cantidad*OLD.compdet_precio);
			end if;
		else -- exenta
			if OLD.tipit_codigo = 3 then -- validamos servicio
				exenta := round(OLD.compdet_precio);
			else 
				exenta := round(OLD.compdet_cantidad*OLD.compdet_precio);
			end if;
		end if;
		-- Multiplicamos cantidad por precio y asignamos a total, esto solo para cuenta pagar
		if OLD.tipit_codigo = 3 then -- validamos servicio
			monto := round(OLD.compdet_precio);
		else 
			monto := round(OLD.compdet_cantidad*OLD.compdet_precio);
		end if;
		-- Consultamos datos de la cabecera
		select cc.tipco_codigo into codigo_comprobante from compra_cab cc where cc.comp_codigo=OLD.comp_codigo;
		select tc.tipco_descripcion into comprobante from compra_cab cc join tipo_comprobante tc on tc.tipco_codigo=cc.tipco_codigo  where cc.comp_codigo=OLD.comp_codigo;
		select cc.comp_numfactura into numero_comprobante from compra_cab cc where cc.comp_codigo=OLD.comp_codigo;
		select cc.usu_codigo into codigoUsuario from compra_cab cc where cc.comp_codigo=OLD.comp_codigo;
		select u.usu_login into usuario from compra_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.comp_codigo=OLD.comp_codigo;
		-- Llamamos al sp de libro compra y le pasamos los parametros
	    perform sp_libro_compra(OLD.comp_codigo, exenta, monto5, monto10, codigo_comprobante, comprobante, numero_comprobante, 2, codigoUsuario, usuario);
		-- Llammos al sp de cuenta pagar y le pasamos los parametros
		perform sp_cuenta_pagar(OLD.comp_codigo, monto, monto, 2, codigoUsuario, usuario);
    END IF;
		RETURN NULL;
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_actualizacion_libro_compra_cuenta_pagar()
CREATE TRIGGER t_actualizacion_libro_compra_cuenta_pagar
AFTER INSERT OR DELETE ON compra_det
FOR EACH ROW EXECUTE FUNCTION spt_actualizacion_libro_compra_cuenta_pagar();


