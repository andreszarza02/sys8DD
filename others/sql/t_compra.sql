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

-- Libro Compra y Cuenta Pagar 2
CREATE OR REPLACE FUNCTION spt_actualizacion2_libro_compra_cuenta_pagar()
RETURNS TRIGGER AS $$
DECLARE
    -- montos / tipos
    tipoNota        integer;
    tipoImpuesto    integer;
    monto5          numeric := 0;
    monto10         numeric := 0;
    exenta          numeric := 0;
    monto           numeric := 0;

    -- identificadores y datos de cabecera
    nocomCodigo     int4;
    itCodigo        int4;
    tipitCodigo     int4;
    cantidad        numeric;
    precio          numeric;
    compcodigo      int4;        -- <-- ESTE es el código de compra que necesitamos usar
    codigoUsuario   integer;
    usuario         varchar;
    comprobante     varchar;
    numero_comprobante varchar;

    -- control / auditoría
    notaMonto       numeric := 0;
    compraEstado    varchar;
    compAudit       text;

    -- cursor parametrizado para auditar la cabecera de compra
    c_compra_cab cursor(comp_id int) is
        select cc.comp_fecha,
               cc.comp_numfactura,
               cc.comp_timbrado,
               cc.comp_timbrado_venc,
               cc.comp_tipofactura,
               cc.comp_cuota,
               cc.comp_montocuota,
               cc.comp_interfecha,
               cc.tipco_codigo,
               tc.tipco_descripcion,
               cc.pro_codigo,
               p.pro_razonsocial,
               cc.tipro_codigo,
               tp.tipro_descripcion,
               cc.emp_codigo,
               e.emp_razonsocial,
               cc.suc_codigo,
               s.suc_descripcion,
               cc.comp_estado
        from compra_cab cc
        join tipo_comprobante tc on tc.tipco_codigo=cc.tipco_codigo
        join proveedor p on p.pro_codigo=cc.pro_codigo
        join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
        join sucursal s on s.suc_codigo=cc.suc_codigo and s.emp_codigo=cc.emp_codigo
        join empresa e on e.emp_codigo=s.emp_codigo
        where cc.comp_codigo = comp_id;
BEGIN
    /* 1) Obtener ids/valores del row (nuevo o viejo según operación) */
    IF TG_OP = 'INSERT' THEN
        nocomCodigo := NEW.nocom_codigo;
        itCodigo    := NEW.it_codigo;
        tipitCodigo := NEW.tipit_codigo;
        cantidad    := NEW.nocomdet_cantidad;
        precio      := NEW.nocomdet_precio;
    ELSE
        nocomCodigo := OLD.nocom_codigo;
        itCodigo    := OLD.it_codigo;
        tipitCodigo := OLD.tipit_codigo;
        cantidad    := OLD.nocomdet_cantidad;
        precio      := OLD.nocomdet_precio;
    END IF;

    /* 2) Obtener datos de la nota (incluye comp_codigo de la compra relacionada) */
    SELECT ncc.tipco_codigo,
           tc.tipco_descripcion,
           ncc.nocom_numeronota,
           ncc.comp_codigo,
           ncc.usu_codigo,
           u.usu_login
    INTO   tipoNota, comprobante, numero_comprobante, compcodigo, codigoUsuario, usuario
    FROM nota_compra_cab ncc
    JOIN tipo_comprobante tc ON tc.tipco_codigo = ncc.tipco_codigo
    JOIN usuario u ON u.usu_codigo = ncc.usu_codigo
    WHERE ncc.nocom_codigo = nocomCodigo;

    -- Si no encontramos la nota (defensivo), salimos
    IF compcodigo IS NULL THEN
        RETURN NULL;
    END IF;

    /* 3) Solo procesar notas crédito(1) o débito(2) */
    IF tipoNota IN (1,2) THEN

        /* 3.1) Obtener tipo de impuesto del ítem */
        SELECT i.tipim_codigo INTO tipoImpuesto FROM items i WHERE i.it_codigo = itCodigo;

        /* 3.2) Calcular montos según impuesto y si es servicio (tipit=3) */
        monto5 := 0; monto10 := 0; exenta := 0;

        IF tipoImpuesto = 1 THEN
            IF tipitCodigo = 3 THEN
                monto5 := round(precio);
            ELSE
                monto5 := round(cantidad * precio);
            END IF;
        ELSIF tipoImpuesto = 2 THEN
            IF tipitCodigo = 3 THEN
                monto10 := round(precio);
            ELSE
                monto10 := round(cantidad * precio);
            END IF;
        ELSE
            IF tipitCodigo = 3 THEN
                exenta := round(precio);
            ELSE
                exenta := round(cantidad * precio);
            END IF;
        END IF;

        /* monto total para cuenta pagar */
        IF tipitCodigo = 3 THEN
            monto := round(precio);
        ELSE
            monto := round(cantidad * precio);
        END IF;

        /* 3.3) Si es nota de crédito (1) tratamos montos como negativos */
        IF tipoNota = 1 THEN
            monto5 := monto5 * -1;
            monto10 := monto10 * -1;
            exenta := exenta * -1;
            monto := monto * -1;
        END IF;

        /* 4) Actualizar libro_compra y cuenta_pagar usando compcodigo (código de compra) */
        IF TG_OP = 'INSERT' THEN
            PERFORM sp_libro_compra(compcodigo, exenta, monto5, monto10,
                                    tipoNota, comprobante, numero_comprobante,
                                    1, codigoUsuario, usuario);
            PERFORM sp_cuenta_pagar(compcodigo, monto, monto,
                                    1, codigoUsuario, usuario);
        ELSIF TG_OP = 'DELETE' THEN
            PERFORM sp_libro_compra(compcodigo, exenta, monto5, monto10,
                                    tipoNota, comprobante, numero_comprobante,
                                    2, codigoUsuario, usuario);
            PERFORM sp_cuenta_pagar(compcodigo, monto, monto,
                                    2, codigoUsuario, usuario);
        END IF;

        /* 5) Recalcular monto total y decidir anular/reactivar (USAR compcodigo) */
        SELECT cuenpa_monto INTO notaMonto FROM cuenta_pagar WHERE comp_codigo = compcodigo;
        SELECT comp_estado INTO compraEstado FROM compra_cab WHERE comp_codigo = compcodigo;

        -- Si ya quedó en cero → ANULA cuenta_pagar y compra_cab (y audita)
        IF notaMonto = 0 THEN
            UPDATE cuenta_pagar SET cuenpa_estado = 'ANULADO' WHERE comp_codigo = compcodigo;
            PERFORM sp_cuenta_pagar(compcodigo, 0, 0, 3, codigoUsuario, usuario); -- operación 3 solo para auditar

            UPDATE compra_cab SET comp_estado = 'ANULADO', usu_codigo = codigoUsuario WHERE comp_codigo = compcodigo;

            FOR compra IN c_compra_cab(compcodigo) LOOP
                SELECT coalesce(comp_audit, '') INTO compAudit FROM compra_cab WHERE comp_codigo = compcodigo;

                UPDATE compra_cab
                SET comp_audit = compAudit || '' || json_build_object(
                    'usu_codigo', codigoUsuario,
                    'usu_login',  usuario,
                    'fecha',      to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
                    'procedimiento', 'MODIFICACION',
                    'comp_fecha', compra.comp_fecha,
                    'comp_numfactura', compra.comp_numfactura,
                    'comp_timbrado', compra.comp_timbrado,
                    'comp_timbrado_venc', compra.comp_timbrado_venc,
                    'comp_tipofactura', compra.comp_tipofactura,
                    'comp_cuota', compra.comp_cuota,
                    'comp_montocuota', compra.comp_montocuota,
                    'comp_interfecha', compra.comp_interfecha,
                    'tipco_codigo', compra.tipco_codigo,
                    'tipco_descripcion', compra.tipco_descripcion,
                    'pro_codigo', compra.pro_codigo,
                    'pro_razonsocial', compra.pro_razonsocial,
                    'tipro_codigo', compra.tipro_codigo,
                    'tipro_descripcion', compra.tipro_descripcion,
                    'emp_codigo', compra.emp_codigo,
                    'emp_razonsocial', compra.emp_razonsocial,
                    'suc_codigo', compra.suc_codigo,
                    'suc_descripcion', compra.suc_descripcion,
                    'comp_estado', compra.comp_estado
                ) || ','
                WHERE comp_codigo = compcodigo;
            END LOOP;

        -- Si hay monto y la compra estaba anulada → reactivar (y auditar)
        ELSIF notaMonto > 0 AND compraEstado = 'ANULADO' THEN
            UPDATE cuenta_pagar SET cuenpa_estado = 'ACTIVO' WHERE comp_codigo = compcodigo;
            PERFORM sp_cuenta_pagar(compcodigo, 0, 0, 3, codigoUsuario, usuario); -- solo auditoría

            UPDATE compra_cab SET comp_estado = 'ACTIVO', usu_codigo = codigoUsuario WHERE comp_codigo = compcodigo;

            FOR compra IN c_compra_cab(compcodigo) LOOP
                SELECT coalesce(comp_audit, '') INTO compAudit FROM compra_cab WHERE comp_codigo = compcodigo;

                UPDATE compra_cab
                SET comp_audit = compAudit || '' || json_build_object(
                    'usu_codigo', codigoUsuario,
                    'usu_login',  usuario,
                    'fecha',      to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
                    'procedimiento', 'MODIFICACION',
                    'comp_fecha', compra.comp_fecha,
                    'comp_numfactura', compra.comp_numfactura,
                    'comp_timbrado', compra.comp_timbrado,
                    'comp_timbrado_venc', compra.comp_timbrado_venc,
                    'comp_tipofactura', compra.comp_tipofactura,
                    'comp_cuota', compra.comp_cuota,
                    'comp_montocuota', compra.comp_montocuota,
                    'comp_interfecha', compra.comp_interfecha,
                    'tipco_codigo', compra.tipco_codigo,
                    'tipco_descripcion', compra.tipco_descripcion,
                    'pro_codigo', compra.pro_codigo,
                    'pro_razonsocial', compra.pro_razonsocial,
                    'tipro_codigo', compra.tipro_codigo,
                    'tipro_descripcion', compra.tipro_descripcion,
                    'emp_codigo', compra.emp_codigo,
                    'emp_razonsocial', compra.emp_razonsocial,
                    'suc_codigo', compra.suc_codigo,
                    'suc_descripcion', compra.suc_descripcion,
                    'comp_estado', compra.comp_estado
                ) || ','
                WHERE comp_codigo = compcodigo;
            END LOOP;
        END IF;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Reemplaza el trigger anterior por este (AFTER)
CREATE TRIGGER t_actualizacion2_libro_compra_cuenta_pagar
AFTER INSERT OR DELETE ON nota_compra_det
FOR EACH ROW EXECUTE FUNCTION spt_actualizacion2_libro_compra_cuenta_pagar();


