--PEDIDO VENTA 
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_pedido_venta_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select pvc.usu_codigo from pedido_venta_cab pvc where pvc.peven_codigo=NEW.peven_codigo);
		usuLogin := (select u.usu_login from pedido_venta_cab pvc join usuario u on u.usu_codigo=pvc.usu_codigo where pvc.peven_codigo=NEW.peven_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO pedido_venta_det_auditoria (
            pevendetaud_codigo,
            usu_codigo,
            usu_login,
            pevendetaud_fecha,
            pevendetaud_procedimiento,
            peven_codigo,
            it_codigo,
            tipit_codigo,
            pevendet_cantidad,
            pevendet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(pevendetaud_codigo), 0) + 1 FROM pedido_venta_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.peven_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.pevendet_cantidad,
            NEW.pevendet_precio
        );

    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select pvc.usu_codigo from pedido_venta_cab pvc where pvc.peven_codigo=OLD.peven_codigo);
		usuLogin := (select u.usu_login from pedido_venta_cab pvc join usuario u on u.usu_codigo=pvc.usu_codigo where pvc.peven_codigo=OLD.peven_codigo);
		--Insertamos la auditoria de la nueva eliminacion	
        INSERT INTO pedido_venta_det_auditoria (
            pevendetaud_codigo,
            usu_codigo,
            usu_login,
            pevendetaud_fecha,
            pevendetaud_procedimiento,
            peven_codigo,
            it_codigo,
            tipit_codigo,
            pevendet_cantidad,
            pevendet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(pevendetaud_codigo), 0) + 1 FROM pedido_venta_det_auditoria), -- Generar nuevo código
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.peven_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.pevendet_cantidad,
            OLD.pevendet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_pedido_venta_det()
CREATE TRIGGER t_insercion_eliminacion_pedido_venta_det
AFTER INSERT OR DELETE ON pedido_venta_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_pedido_venta_det();

CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_apertura_cierre()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO apertura_cierre_auditoria(
            apercieaud_codigo,
            apercieaud_fecha,
            apercieaud_procedimiento,
            apercie_codigo,
            suc_codigo,
            emp_codigo,
			caj_codigo,
			usu_codigo,
			apercie_fechahoraapertura,
			apercie_fechahoracierre,
			apercie_montoapertura,
			apercie_montocierre,
			apercie_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(apercieaud_codigo), 0) + 1 FROM apertura_cierre_auditoria),   
            current_timestamp,
            'ALTA',   
            NEW.apercie_codigo,
            NEW.suc_codigo,
            NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.apercie_fechahoraapertura,
			NEW.apercie_fechahoracierre,
			NEW.apercie_montoapertura,
			NEW.apercie_montocierre,
			NEW.apercie_estado
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    -- Registramos el valor anterior a que se actualice
    INSERT INTO apertura_cierre_auditoria(
            apercieaud_codigo,
            apercieaud_fecha,
            apercieaud_procedimiento,
            apercie_codigo,
            suc_codigo,
            emp_codigo,
			caj_codigo,
			usu_codigo,
			apercie_fechahoraapertura,
			apercie_fechahoracierre,
			apercie_montoapertura,
			apercie_montocierre,
			apercie_estado
    )
    VALUES (
            (SELECT COALESCE(MAX(apercieaud_codigo), 0) + 1 FROM apertura_cierre_auditoria),   
            current_timestamp,
            'MODIFICACION_ANTERIOR',   
            OLD.apercie_codigo,
            OLD.suc_codigo,
            OLD.emp_codigo,
			OLD.caj_codigo,
			OLD.usu_codigo,
			OLD.apercie_fechahoraapertura,
			OLD.apercie_fechahoracierre,
			OLD.apercie_montoapertura,
			OLD.apercie_montocierre,
			OLD.apercie_estado
      );
    -- Registramos el nuevo valor actualizado
    INSERT INTO apertura_cierre_auditoria(
            apercieaud_codigo,
            apercieaud_fecha,
            apercieaud_procedimiento,
            apercie_codigo,
            suc_codigo,
            emp_codigo,
			caj_codigo,
			usu_codigo,
			apercie_fechahoraapertura,
			apercie_fechahoracierre,
			apercie_montoapertura,
			apercie_montocierre,
			apercie_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(apercieaud_codigo), 0) + 1 FROM apertura_cierre_auditoria),   
            current_timestamp,
            'MODIFICACION_NUEVO',   
            NEW.apercie_codigo,
            NEW.suc_codigo,
            NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.apercie_fechahoraapertura,
			NEW.apercie_fechahoracierre,
			NEW.apercie_montoapertura,
			NEW.apercie_montocierre,
			NEW.apercie_estado
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_apertura_cierre
CREATE TRIGGER t_insercion_actualizacion_apertura_cierre
AFTER INSERT OR UPDATE ON apertura_cierre
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_apertura_cierre();

CREATE OR REPLACE FUNCTION spt_insercion_recaudacion_depositar()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO recaudacion_depositar_auditoria(
            recaud_codigo,
            recaud_fecha,
            recaud_procedimiento,
            rec_codigo,
            apercie_codigo,
            suc_codigo,
			emp_codigo,
			caj_codigo,
			usu_codigo,
			rec_montoefectivo,
			rec_montocheque,
			rec_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(recaud_codigo), 0) + 1 FROM recaudacion_depositar_auditoria),   
            current_timestamp,
            'ALTA',   
            NEW.rec_codigo,
            NEW.apercie_codigo,
            NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.rec_montoefectivo,
			NEW.rec_montocheque,
			NEW.rec_estado
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_recaudacion_depositar
CREATE TRIGGER t_insercion_recaudacion_depositar
AFTER INSERT ON recaudacion_depositar
FOR EACH ROW EXECUTE FUNCTION spt_insercion_recaudacion_depositar();

CREATE OR REPLACE FUNCTION spt_insercion_arqueo_control_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO arqueo_control_auditoria(
            arcoaud_codigo,
            arcoaud_fecha,
            arcoaud_procedimiento,
            arco_codigo,
            apercie_codigo,
            suc_codigo,
			emp_codigo,
			caj_codigo,
			usu_codigo,
			arco_observacion,
			arco_fecha,
			func_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(arcoaud_codigo), 0) + 1 FROM arqueo_control_auditoria),   
            current_timestamp,
            'ALTA',   
            NEW.arco_codigo,
            NEW.apercie_codigo,
            NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.arco_observacion,
			NEW.arco_fecha,
			NEW.func_codigo
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_arqueo_control_auditoria
CREATE TRIGGER t_insercion_arqueo_control
AFTER INSERT ON arqueo_control
FOR EACH ROW EXECUTE FUNCTION spt_insercion_arqueo_control_auditoria();

--Factura Venta
CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_factura_venta()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO factura_venta_auditoria(
            facvenaud_codigo,
            facvenaud_fecha,
            facvenaud_procedimiento,
            suc_codigo,
            emp_codigo,
            caj_codigo,
			facven_numero
        )
        VALUES (
            (SELECT COALESCE(MAX(facvenaud_codigo), 0) + 1 FROM factura_venta_auditoria),   
            current_timestamp,
            'ALTA',   
            NEW.suc_codigo,
            NEW.emp_codigo,
            NEW.caj_codigo,
			NEW.facven_numero
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    -- Registramos el valor anterior a que se actualice
    	INSERT INTO factura_venta_auditoria(
            facvenaud_codigo,
            facvenaud_fecha,
            facvenaud_procedimiento,
            suc_codigo,
            emp_codigo,
            caj_codigo,
			facven_numero
        )
        VALUES (
            (SELECT COALESCE(MAX(facvenaud_codigo), 0) + 1 FROM factura_venta_auditoria),   
            current_timestamp,
            'MODIFICACION_ANTERIOR',   
            OLD.suc_codigo,
            OLD.emp_codigo,
            OLD.caj_codigo,
			OLD.facven_numero
        );
    -- Registramos el nuevo valor actualizado
   		INSERT INTO factura_venta_auditoria(
            facvenaud_codigo,
            facvenaud_fecha,
            facvenaud_procedimiento,
            suc_codigo,
            emp_codigo,
            caj_codigo,
			facven_numero
        )
        VALUES (
            (SELECT COALESCE(MAX(facvenaud_codigo), 0) + 1 FROM factura_venta_auditoria),   
            current_timestamp,
            'MODIFICACION_NUEVO',   
            NEW.suc_codigo,
            NEW.emp_codigo,
            NEW.caj_codigo,
			NEW.facven_numero
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_factura_venta
CREATE TRIGGER t_insercion_actualizacion_factura_venta
AFTER INSERT OR UPDATE ON factura_venta
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_factura_venta();

-- VENTA CABECERA
CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_venta_cab()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO venta_cab_auditoria(
            venaud_codigo,
			venaud_fecha,
			venaud_procedimiento,
			ven_codigo,
			ven_fecha,
			ven_numfactura,
			ven_tipofactura,
			ven_cuota,
			ven_montocuota,
			ven_interfecha,
			ven_estado,
			usu_codigo,
			cli_codigo,
			suc_codigo,
			emp_codigo,
			tipco_codigo,
			ven_timbrado
        )
        VALUES (
            (SELECT COALESCE(MAX(venaud_codigo), 0) + 1 FROM venta_cab_auditoria),   
			current_timestamp,
			'ALTA',
            NEW.ven_codigo,
			NEW.ven_fecha,
			NEW.ven_numfactura,
			NEW.ven_tipofactura,
			NEW.ven_cuota,
			NEW.ven_montocuota,
			NEW.ven_interfecha,
			NEW.ven_estado,
			NEW.usu_codigo,
			NEW.cli_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.tipco_codigo,
			NEW.ven_timbrado
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    	-- Registramos el nuevo valor actualizado
    	INSERT INTO venta_cab_auditoria(
            venaud_codigo,
			venaud_fecha,
			venaud_procedimiento,
			ven_codigo,
			ven_fecha,
			ven_numfactura,
			ven_tipofactura,
			ven_cuota,
			ven_montocuota,
			ven_interfecha,
			ven_estado,
			usu_codigo,
			cli_codigo,
			suc_codigo,
			emp_codigo,
			tipco_codigo,
			ven_timbrado
        )
        VALUES (
            (SELECT COALESCE(MAX(venaud_codigo), 0) + 1 FROM venta_cab_auditoria),   
			current_timestamp,
			(case NEW.ven_estado when 'ANULADO' then 'BAJA' else 'MODIFICACION' end),
            NEW.ven_codigo,
			NEW.ven_fecha,
			NEW.ven_numfactura,
			NEW.ven_tipofactura,
			NEW.ven_cuota,
			NEW.ven_montocuota,
			NEW.ven_interfecha,
			NEW.ven_estado,
			NEW.usu_codigo,
			NEW.cli_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.tipco_codigo,
			NEW.ven_timbrado
        );
	END IF;
		RETURN NEW; --Este return no se utiliza
END
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_venta_cab
CREATE TRIGGER t_insercion_actualizacion_venta_cab
AFTER INSERT OR UPDATE ON venta_cab
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_venta_cab();

-- VENTA DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_venta_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select vc.usu_codigo from venta_cab vc where vc.ven_codigo=NEW.ven_codigo);
		usuLogin = (select u.usu_login from venta_cab vc join usuario u on u.usu_codigo=vc.usu_codigo where vc.ven_codigo=NEW.ven_codigo);
        INSERT INTO venta_det_auditoria (
            vendetaud_codigo,
			usu_codigo,
			usu_login,
			vendetaud_fecha,
			vendetaud_procedimiento,
			ven_codigo,
			it_codigo,
			tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
			vendet_cantidad,
			vendet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(vendetaud_codigo), 0) + 1 FROM venta_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,-
            'ALTA',       
            NEW.ven_codigo,
			NEW.it_codigo,
			NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.vendet_cantidad,
			NEW.vendet_precio
        );
    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select vc.usu_codigo from venta_cab vc where vc.ven_codigo=OLD.ven_codigo);
		usuLogin = (select u.usu_login from venta_cab vc join usuario u on u.usu_codigo=vc.usu_codigo where vc.ven_codigo=OLD.ven_codigo);
        INSERT INTO venta_det_auditoria (
            vendetaud_codigo,
			usu_codigo,
			usu_login,
			vendetaud_fecha,
			vendetaud_procedimiento,
			ven_codigo,
			it_codigo,
			tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
			vendet_cantidad,
			vendet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(vendetaud_codigo), 0) + 1 FROM venta_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,-
            'BAJA',       
            OLD.ven_codigo,
			OLD.it_codigo,
			OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
			OLD.vendet_cantidad,
			OLD.vendet_precio
        );
    END IF;
		RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_venta_det()
CREATE TRIGGER t_insercion_eliminacion_venta_det
AFTER INSERT OR DELETE ON venta_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_venta_det();

-- PEDIDO VENTA INTERMEDIO 
CREATE OR REPLACE FUNCTION spt_insercion_pedido_venta()
RETURNS TRIGGER AS $$
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select vc.usu_codigo from venta_cab vc where vc.ven_codigo=NEW.ven_codigo);
		usuLogin = (select u.usu_login from venta_cab vc join usuario u on u.usu_codigo=vc.usu_codigo where vc.ven_codigo=NEW.ven_codigo);
        INSERT INTO pedido_venta_auditoria(
            pedvenaud_codigo,
            usu_codigo,
            usu_login,
            pedvenaud_fecha,
            pedvenaud_procedimiento,
            ven_codigo,
			peven_codigo,
			pedven_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(pedvenaud_codigo), 0) + 1 FROM pedido_venta_auditoria),   
			usuCodigo,
			usuLogin,
            current_timestamp,
            'ALTA',   
            NEW.ven_codigo,
            NEW.peven_codigo,
            NEW.pedven_codigo
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_pedido_venta
CREATE TRIGGER t_insercion_pedido_venta
AFTER INSERT ON pedido_venta
FOR EACH ROW EXECUTE FUNCTION spt_insercion_pedido_venta();

-- LIBRO VENTA 
CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_libro_venta()
RETURNS TRIGGER AS $$
declare usuCodigo integer;
		usuLogin varchar;
BEGIN
	--Definimos el usuario que inserto o modifico el registro
	if NEW.tipco_codigo = 4 then
		-- Si el comprobante es una factura traemos el usuario de venta
		usuCodigo = (select vc.usu_codigo from venta_cab vc where vc.ven_codigo=NEW.ven_codigo);
		usuLogin = (select u.usu_login from venta_cab vc join usuario u on u.usu_codigo=vc.usu_codigo where vc.ven_codigo=NEW.ven_codigo);
	elseif NEW.tipco_codigo in (1, 2) then
		-- Si el comprobante es una nota traemos el usuario de nota venta
		usuCodigo = (select nvc.usu_codigo from nota_venta_cab nvc where nvc.ven_codigo=NEW.ven_codigo 
		and nvc.tipco_codigo=NEW.tipco_codigo and nvc.notven_numeronota=NEW.libven_numcomprobante);
		usuLogin = (select u.usu_login from nota_venta_cab nvc join usuario u on u.usu_codigo=nvc.usu_codigo where nvc.ven_codigo=NEW.ven_codigo
		and nvc.tipco_codigo=NEW.tipco_codigo and nvc.notven_numeronota=NEW.libven_numcomprobante);
	end if;
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO libro_venta_auditoria(
            libvenaud_codigo,
            usu_codigo,
            usu_login,
            libvenaud_fecha,
            libvenaud_procedimiento,
            libven_codigo,
			ven_codigo,
			libven_exenta,
			libven_iva5,
			libven_iva10,
			libven_fecha,
			libven_numcomprobante,
			libven_estado,
			tipco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(libvenaud_codigo), 0) + 1 FROM libro_venta_auditoria),   
			usuCodigo,
			usuLogin,
            current_timestamp,
            'ALTA',   
            NEW.libven_codigo,
			NEW.ven_codigo,
			NEW.libven_exenta,
			NEW.libven_iva5,
			NEW.libven_iva10,
			NEW.libven_fecha,
			NEW.libven_numcomprobante,
			NEW.libven_estado,
			NEW.tipco_codigo
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    	-- Registramos el nuevo valor actualizado
    	INSERT INTO libro_venta_auditoria(
            libvenaud_codigo,
            usu_codigo,
            usu_login,
            libvenaud_fecha,
            libvenaud_procedimiento,
            libven_codigo,
			ven_codigo,
			libven_exenta,
			libven_iva5,
			libven_iva10,
			libven_fecha,
			libven_numcomprobante,
			libven_estado,
			tipco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(libvenaud_codigo), 0) + 1 FROM libro_venta_auditoria),   
			usuCodigo,
			usuLogin,
            current_timestamp,
            'MODIFICACION',   
            NEW.libven_codigo,
			NEW.ven_codigo,
			NEW.libven_exenta,
			NEW.libven_iva5,
			NEW.libven_iva10,
			NEW.libven_fecha,
			NEW.libven_numcomprobante,
			NEW.libven_estado,
			NEW.tipco_codigo
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_libro_venta
CREATE TRIGGER t_insercion_actualizacion_libro_venta
AFTER INSERT OR UPDATE ON libro_venta
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_libro_venta();

-- CUENTA COBRAR 
CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_cuenta_cobrar()
RETURNS TRIGGER AS $$
declare usuCodigo integer;
		usuLogin varchar;
		cobCodigo integer;
BEGIN
	--Definimos el usuario que inserto o modifico el registro
	if NEW.tipco_codigo = 4 then
		-- Si el comprobante es una factura traemos el usuario de venta
		usuCodigo = (select vc.usu_codigo from venta_cab vc where vc.ven_codigo=NEW.ven_codigo);
		usuLogin = (select u.usu_login from venta_cab vc join usuario u on u.usu_codigo=vc.usu_codigo where vc.ven_codigo=NEW.ven_codigo);
	elseif NEW.tipco_codigo in (1, 2) then
		-- Si el comprobante es una nota traemos el usuario de nota venta
		usuCodigo = (select nvc.usu_codigo from nota_venta_cab nvc where nvc.ven_codigo=NEW.ven_codigo 
		and nvc.tipco_codigo=NEW.tipco_codigo and nvc.notven_estado='ACTIVO');
		usuLogin = (select u.usu_login from nota_venta_cab nvc join usuario u on u.usu_codigo=nvc.usu_codigo where nvc.ven_codigo=NEW.ven_codigo
		and nvc.tipco_codigo=NEW.tipco_codigo and nvc.notven_estado='ACTIVO');
	elseif NEW.tipco_codigo = 5 then
		--Si el comprobante es un recibo traemos el usuario de las tablas de cobro
		--Traemos el codigo de cobro y lo guardamos dentro de una variable para su validacion, en caso de no existir devolvera 0
		cobCodigo := (select 
						coalesce(
							(select 
									cc.usu_codigo 
							from cobro_det cd 
					 		join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
					 		where cd.ven_codigo=NEW.ven_codigo 
							order by cd.cob_codigo desc limit 1), 0)
					);
		--Validamos la el codigo de cobro
		if cobCodigo = 0 then
			--Si es igual a 0 consultamos el usucodigo y usulogin de cobro detalle auditoria
			usuCodigo = (select 
							cda.usu_codigo 
						from cobro_det_auditoria cda 
						where cda.ven_codigo=NEW.ven_codigo
						order by cda.cob_codigo desc limit 1);
			usuLogin = (select 
							cda.usu_login 
						from cobro_det_auditoria cda 
						where cda.ven_codigo=NEW.ven_codigo
						order by cda.cob_codigo desc limit 1);
		else
			--Si es distinto de 0 consultamos el usucodigo y usulogin de cobro cabecera
			usuCodigo = (select cc.usu_codigo from cobro_det cd 
					 join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
					 where cd.ven_codigo=NEW.ven_codigo order by cd.cob_codigo desc limit 1);
			usuLogin = (select u.usu_login from cobro_det cd 
					 join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
					 join usuario u on u.usu_codigo=cc.usu_codigo
					 where cd.ven_codigo=NEW.ven_codigo order by cd.cob_codigo desc limit 1);
		end if;
	end if;
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO cuenta_cobrar_auditoria(
            cuencoaud_codigo,
            usu_codigo,
            usu_login,
            cuencoaud_fecha,
            cuencoaud_procedimiento,
			ven_codigo,
			cuenco_nrocuota,
			cuenco_monto,
			cuenco_saldo,
			cuenco_estado,
			tipco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cuencoaud_codigo), 0) + 1 FROM cuenta_cobrar_auditoria),   
			usuCodigo,
			usuLogin,
            current_timestamp,
            'ALTA',   
            NEW.ven_codigo,
			NEW.cuenco_nrocuota,
			NEW.cuenco_monto,
			NEW.cuenco_saldo,
			NEW.cuenco_estado,
			NEW.tipco_codigo
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    	-- Registramos el nuevo valor actualizado
    	INSERT INTO cuenta_cobrar_auditoria(
            cuencoaud_codigo,
            usu_codigo,
            usu_login,
            cuencoaud_fecha,
            cuencoaud_procedimiento,
			ven_codigo,
			cuenco_nrocuota,
			cuenco_monto,
			cuenco_saldo,
			cuenco_estado,
			tipco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cuencoaud_codigo), 0) + 1 FROM cuenta_cobrar_auditoria),   
			usuCodigo,
			usuLogin,
            current_timestamp,
            'MODIFICACION',   
            NEW.ven_codigo,
			NEW.cuenco_nrocuota,
			NEW.cuenco_monto,
			NEW.cuenco_saldo,
			NEW.cuenco_estado,
			NEW.tipco_codigo
        );
	END IF;
		RETURN NEW; --Este return no se utiliza
END
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_cuenta_cobrar
CREATE TRIGGER t_insercion_actualizacion_cuenta_cobrar
AFTER INSERT OR UPDATE ON cuenta_cobrar
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_cuenta_cobrar();

-- COBRO CABECERA
CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_cobro_cab()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO cobro_cab_auditoria(
            cobaud_codigo,
			cobaud_fecha,
			cobaud_procedimiento,
			cob_codigo,
			cob_fecha,
			cob_estado,
			apercie_codigo,
			suc_codigo,
			emp_codigo,
			caj_codigo,
			usu_codigo,
			tipco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cobaud_codigo), 0) + 1 FROM cobro_cab_auditoria),   
			current_timestamp,
			'ALTA',
            NEW.cob_codigo,
			NEW.cob_fecha,
			NEW.cob_estado,
			NEW.apercie_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.tipco_codigo
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    	-- Registramos el nuevo valor actualizado
    	INSERT INTO cobro_cab_auditoria(
            cobaud_codigo,
			cobaud_fecha,
			cobaud_procedimiento,
			cob_codigo,
			cob_fecha,
			cob_estado,
			apercie_codigo,
			suc_codigo,
			emp_codigo,
			caj_codigo,
			usu_codigo,
			tipco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cobaud_codigo), 0) + 1 FROM cobro_cab_auditoria),   
			current_timestamp,
			'BAJA',
            NEW.cob_codigo,
			NEW.cob_fecha,
			NEW.cob_estado,
			NEW.apercie_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.tipco_codigo
        );
	END IF;
		RETURN NEW; --Este return no se utiliza
END
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_cobro_cab
CREATE TRIGGER t_insercion_actualizacion_cobro_cab
AFTER INSERT OR UPDATE ON cobro_cab
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_cobro_cab();

-- COBRO DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_cobro_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from cobro_cab cc where cc.cob_codigo=NEW.cob_codigo);
		usuLogin = (select u.usu_login from cobro_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.cob_codigo=NEW.cob_codigo);
        INSERT INTO cobro_det_auditoria(
            cobdetaud_codigo,
			usu_codigo,
			usu_login,
			cobdetaud_fecha,
			cobdetaud_procedimiento,
			cobdet_codigo,
			cob_codigo,
			ven_codigo,
			cobdet_monto,
			cobdet_numerocuota,
			forco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cobdetaud_codigo), 0) + 1 FROM cobro_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.cobdet_codigo,
			NEW.cob_codigo,
			NEW.ven_codigo,
			NEW.cobdet_monto,
			NEW.cobdet_numerocuota,
			NEW.forco_codigo
        );
    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from cobro_cab cc where cc.cob_codigo=OLD.cob_codigo);
		usuLogin = (select u.usu_login from cobro_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.cob_codigo=OLD.cob_codigo);
        INSERT INTO cobro_det_auditoria(
            cobdetaud_codigo,
			usu_codigo,
			usu_login,
			cobdetaud_fecha,
			cobdetaud_procedimiento,
			cobdet_codigo,
			cob_codigo,
			ven_codigo,
			cobdet_monto,
			cobdet_numerocuota,
			forco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cobdetaud_codigo), 0) + 1 FROM cobro_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.cobdet_codigo,
			OLD.cob_codigo,
			OLD.ven_codigo,
			OLD.cobdet_monto,
			OLD.cobdet_numerocuota,
			OLD.forco_codigo
        );
    END IF;
		RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_cobro_det()
CREATE TRIGGER t_insercion_eliminacion_cobro_det
AFTER INSERT OR DELETE ON cobro_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_cobro_det();

--COBRO TARJETA
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_cobro_tarjeta()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from cobro_cab cc where cc.cob_codigo=NEW.cob_codigo);
		usuLogin = (select u.usu_login from cobro_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.cob_codigo=NEW.cob_codigo);
        INSERT INTO cobro_tarjeta_auditoria(
            cobtaaud_codigo,
			usu_codigo,
			usu_login,
			cobtaaud_fecha,
			cobtaaud_procedimiento,
			cobta_codigo,
			cobta_numero,
			cobta_monto,
			cobta_tipotarjeta,
			entad_codigo,
			ent_codigo,
			marta_codigo,
			cobdet_codigo,
			cob_codigo,
			ven_codigo,
			cobta_transaccion,
			redpa_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cobtaaud_codigo), 0) + 1 FROM cobro_tarjeta_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.cobta_codigo,
			NEW.cobta_numero,
			NEW.cobta_monto,
			NEW.cobta_tipotarjeta,
			NEW.entad_codigo,
			NEW.ent_codigo,
			NEW.marta_codigo,
			NEW.cobdet_codigo,
			NEW.cob_codigo,
			NEW.ven_codigo,
			NEW.cobta_transaccion,
			NEW.redpa_codigo
        );
    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from cobro_cab cc where cc.cob_codigo=OLD.cob_codigo);
		usuLogin = (select u.usu_login from cobro_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.cob_codigo=OLD.cob_codigo);
        INSERT INTO cobro_tarjeta_auditoria(
            cobtaaud_codigo,
			usu_codigo,
			usu_login,
			cobtaaud_fecha,
			cobtaaud_procedimiento,
			cobta_codigo,
			cobta_numero,
			cobta_monto,
			cobta_tipotarjeta,
			entad_codigo,
			ent_codigo,
			marta_codigo,
			cobdet_codigo,
			cob_codigo,
			ven_codigo,
			cobta_transaccion,
			redpa_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cobtaaud_codigo), 0) + 1 FROM cobro_tarjeta_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.cobta_codigo,
			OLD.cobta_numero,
			OLD.cobta_monto,
			OLD.cobta_tipotarjeta,
			OLD.entad_codigo,
			OLD.ent_codigo,
			OLD.marta_codigo,
			OLD.cobdet_codigo,
			OLD.cob_codigo,
			OLD.ven_codigo,
			OLD.cobta_transaccion,
			OLD.redpa_codigo
        );
    END IF;
		RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_cobro_tarjeta()
CREATE TRIGGER t_insercion_eliminacion_cobro_tarjeta
AFTER INSERT OR DELETE ON cobro_tarjeta
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_cobro_tarjeta();

--COBRO CHEQUE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_cobro_cheque()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from cobro_cab cc where cc.cob_codigo=NEW.cob_codigo);
		usuLogin = (select u.usu_login from cobro_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.cob_codigo=NEW.cob_codigo);
        INSERT INTO cobro_cheque_auditoria(
            cocheaud_codigo,
			usu_codigo,
			usu_login,
			cocheaud_fecha,
			cocheaud_procedimiento,
			coche_codigo,
			coche_numero,
			coche_monto,
			coche_tipocheque,
			coche_fechavencimiento,
			ent_codigo,
			cobdet_codigo,
			cob_codigo,
			ven_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cocheaud_codigo), 0) + 1 FROM cobro_cheque_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.coche_codigo,
			NEW.coche_numero,
			NEW.coche_monto,
			NEW.coche_tipocheque,
			NEW.coche_fechavencimiento,
			NEW.ent_codigo,
			NEW.cobdet_codigo,
			NEW.cob_codigo,
			NEW.ven_codigo
        );
    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from cobro_cab cc where cc.cob_codigo=OLD.cob_codigo);
		usuLogin = (select u.usu_login from cobro_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.cob_codigo=OLD.cob_codigo);
        INSERT INTO cobro_cheque_auditoria(
            cocheaud_codigo,
			usu_codigo,
			usu_login,
			cocheaud_fecha,
			cocheaud_procedimiento,
			coche_codigo,
			coche_numero,
			coche_monto,
			coche_tipocheque,
			coche_fechavencimiento,
			ent_codigo,
			cobdet_codigo,
			cob_codigo,
			ven_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cocheaud_codigo), 0) + 1 FROM cobro_cheque_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            OLD.coche_codigo,
			OLD.coche_numero,
			OLD.coche_monto,
			OLD.coche_tipocheque,
			OLD.coche_fechavencimiento,
			OLD.ent_codigo,
			OLD.cobdet_codigo,
			OLD.cob_codigo,
			OLD.ven_codigo
        );
    END IF;
		RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_cobro_cheque()
CREATE TRIGGER t_insercion_eliminacion_cobro_cheque
AFTER INSERT OR DELETE ON cobro_cheque
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_cobro_cheque();