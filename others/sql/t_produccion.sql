--PRESUPUESTO DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_presupuesto_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select pc.usu_codigo from presupuesto_cab pc where pc.pres_codigo=NEW.pres_codigo);
		usuLogin := (select u.usu_login from presupuesto_cab pc join usuario u on u.usu_codigo=pc.usu_codigo where pc.pres_codigo=NEW.pres_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO presupuesto_det_auditoria (
            presdetaud_codigo,
            usu_codigo,
            usu_login,
            presdetaud_fecha,
            presdetaud_procedimiento,
            pres_codigo,
            it_codigo,
            tipit_codigo,
            presdet_cantidad,
            presdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(presdetaud_codigo), 0) + 1 FROM presupuesto_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.pres_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.presdet_cantidad,
            NEW.presdet_precio
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select pc.usu_codigo from presupuesto_cab pc where pc.pres_codigo=OLD.pres_codigo);
		usuLogin := (select u.usu_login from presupuesto_cab pc join usuario u on u.usu_codigo=pc.usu_codigo where pc.pres_codigo=OLD.pres_codigo);
		--Insertamos la auditoria de la nueva eliminacion	
        INSERT INTO presupuesto_det_auditoria (
            presdetaud_codigo,
            usu_codigo,
            usu_login,
            presdetaud_fecha,
            presdetaud_procedimiento,
            pres_codigo,
            it_codigo,
            tipit_codigo,
            presdet_cantidad,
            presdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(presdetaud_codigo), 0) + 1 FROM presupuesto_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.pres_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.presdet_cantidad,
            OLD.presdet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

 --ORDEN PRODUCCION DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_orden_produccion_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select opc.usu_codigo from orden_produccion_cab opc where opc.orpro_codigo=NEW.orpro_codigo);
		usuLogin := (select u.usu_login from orden_produccion_cab opc join usuario u on u.usu_codigo=opc.usu_codigo where opc.orpro_codigo=NEW.orpro_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO orden_produccion_det_auditoria (
            orprodetaud_codigo,
            usu_codigo,
            usu_login,
            orprodetaud_fecha,
            orprodetaud_procedimiento,
            orpro_codigo,
            it_codigo,
            tipit_codigo,
            orprodet_especificacion,
            orprodet_cantidad,
			dep_codigo,
			suc_codigo,
			emp_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(orprodetaud_codigo), 0) + 1 FROM orden_produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.orpro_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.orprodet_especificacion,
            NEW.orprodet_cantidad,
			NEW.dep_codigo,
		    NEW.suc_codigo,
			NEW.emp_codigo
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select opc.usu_codigo from orden_produccion_cab opc where opc.orpro_codigo=OLD.orpro_codigo);
		usuLogin := (select u.usu_login from orden_produccion_cab opc join usuario u on u.usu_codigo=opc.usu_codigo where opc.orpro_codigo=OLD.orpro_codigo);
		--Insertamos la auditoria de la nueva eliminacion	
         INSERT INTO orden_produccion_det_auditoria (
            orprodetaud_codigo,
            usu_codigo,
            usu_login,
            orprodetaud_fecha,
            orprodetaud_procedimiento,
            orpro_codigo,
            it_codigo,
            tipit_codigo,
            orprodet_especificacion,
            orprodet_cantidad,
			dep_codigo,
			suc_codigo,
			emp_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(orprodetaud_codigo), 0) + 1 FROM orden_produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.orpro_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.orprodet_especificacion,
            OLD.orprodet_cantidad,
			OLD.dep_codigo,
		    OLD.suc_codigo,
			OLD.emp_codigo
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_orden_produccion_det()
CREATE TRIGGER t_insercion_eliminacion_orden_produccion_det
AFTER INSERT OR DELETE ON orden_produccion_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_orden_produccion_det();

--COMPONENTE PRODUCCION DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_componente_produccion_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select cpc.usu_codigo from componente_produccion_cab cpc where cpc.compro_codigo=NEW.compro_codigo);
		usuLogin := (select u.usu_login from componente_produccion_cab cpc join usuario u on u.usu_codigo=cpc.usu_codigo where cpc.compro_codigo=NEW.compro_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO componente_produccion_det_auditoria (
            comprodetaud_codigo,
            usu_codigo,
            usu_login,
            comprodetaud_fecha,
            comprodetaud_procedimiento,
            compro_codigo,
            it_codigo,
            tipit_codigo,
            comprodet_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(comprodetaud_codigo), 0) + 1 FROM componente_produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.compro_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.comprodet_cantidad
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select cpc.usu_codigo from componente_produccion_cab cpc where cpc.compro_codigo=OLD.compro_codigo);
		usuLogin := (select u.usu_login from componente_produccion_cab cpc join usuario u on u.usu_codigo=cpc.usu_codigo where cpc.compro_codigo=OLD.compro_codigo);
		--Insertamos la auditoria de la nueva eliminacion	
         INSERT INTO componente_produccion_det_auditoria (
            comprodetaud_codigo,
            usu_codigo,
            usu_login,
            comprodetaud_fecha,
            comprodetaud_procedimiento,
            compro_codigo,
            it_codigo,
            tipit_codigo,
            comprodet_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(comprodetaud_codigo), 0) + 1 FROM componente_produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            OLD.compro_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.comprodet_cantidad
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_componente_produccion_det()
CREATE TRIGGER t_insercion_eliminacion_componente_produccion_det
AFTER INSERT OR DELETE ON componente_produccion_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_componente_produccion_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_orden_produccion_det2()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select opc.usu_codigo from orden_produccion_cab opc where opc.orpro_codigo=NEW.orpro_codigo);
		usuLogin := (select u.usu_login from orden_produccion_cab opc join usuario u on u.usu_codigo=opc.usu_codigo where opc.orpro_codigo=NEW.orpro_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO orden_produccion_det2_auditoria (
            orprodet2aud_codigo,
            usu_codigo,
            usu_login,
            orprodet2aud_fecha,
            orprodet2aud_procedimiento,
            orpro_codigo,
            compro_codigo,
            it_codigo,
            tipit_codigo,
            orprodet2_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(orprodet2aud_codigo), 0) + 1 FROM orden_produccion_det2_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.orpro_codigo,
            NEW.compro_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.orprodet2_cantidad
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select opc.usu_codigo from orden_produccion_cab opc where opc.orpro_codigo=OLD.orpro_codigo);
		usuLogin := (select u.usu_login from orden_produccion_cab opc join usuario u on u.usu_codigo=opc.usu_codigo where opc.orpro_codigo=OLD.orpro_codigo);
		--Insertamos la auditoria de la nueva eliminacion	
         INSERT INTO orden_produccion_det2_auditoria (
            orprodet2aud_codigo,
            usu_codigo,
            usu_login,
            orprodet2aud_fecha,
            orprodet2aud_procedimiento,
            orpro_codigo,
            compro_codigo,
            it_codigo,
            tipit_codigo,
            orprodet2_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(orprodet2aud_codigo), 0) + 1 FROM orden_produccion_det2_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.orpro_codigo,
            OLD.compro_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.orprodet2_cantidad
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_orden_produccion_det2()
CREATE TRIGGER t_insercion_eliminacion_orden_produccion_det2
AFTER INSERT OR DELETE ON orden_produccion_det2
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_orden_produccion_det2();

--PRODUCCION DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_modificacion_eliminacion_produccion_det_auditoria()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select pc.usu_codigo from produccion_cab pc where pc.prod_codigo=NEW.prod_codigo);
		usuLogin := (select u.usu_login from produccion_cab pc join usuario u on u.usu_codigo=pc.usu_codigo where pc.prod_codigo=NEW.prod_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO produccion_det_auditoria (
            prodetaud_codigo,
            usu_codigo,
            usu_login,
            prodetaud_fecha,
            prodetaud_procedimiento,
			prod_codigo,
            it_codigo,
            tipit_codigo,
            prodet_cantidad,
			prodet_fechainicio,
			prodet_fechafinal,
			prodet_observacion,
			prodet_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(prodetaud_codigo), 0) + 1 FROM produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.prod_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.prodet_cantidad,
			NEW.prodet_fechainicio,
			NEW.prodet_fechafinal,
			NEW.prodet_observacion,
			NEW.prodet_estado
        );
	-- Validamos si la operacion es de modificacion
	ELSEIF TG_OP = 'UPDATE' THEN
	     --Insertamos en la tabla de auditoria el valor anterior del registro modificado
         INSERT INTO produccion_det_auditoria (
            prodetaud_codigo,
            usu_codigo,
            usu_login,
            prodetaud_fecha,
            prodetaud_procedimiento,
			prod_codigo,
            it_codigo,
            tipit_codigo,
            prodet_cantidad,
			prodet_fechainicio,
			prodet_fechafinal,
			prodet_observacion,
			prodet_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(prodetaud_codigo), 0) + 1 FROM produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'MODIFICACION_ANTERIOR',       
            OLD.prod_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.prodet_cantidad,
			OLD.prodet_fechainicio,
			OLD.prodet_fechafinal,
			OLD.prodet_observacion,
			OLD.prodet_estado
        );
	    --Insertamos en la tabla de auditoria el valor nuevo del registro modificado
	    INSERT INTO produccion_det_auditoria (
            prodetaud_codigo,
            usu_codigo,
            usu_login,
            prodetaud_fecha,
            prodetaud_procedimiento,
			prod_codigo,
            it_codigo,
            tipit_codigo,
            prodet_cantidad,
			prodet_fechainicio,
			prodet_fechafinal,
			prodet_observacion,
			prodet_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(prodetaud_codigo), 0) + 1 FROM produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'MODIFICACION_NUEVO',       
            NEW.prod_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.prodet_cantidad,
			NEW.prodet_fechainicio,
			NEW.prodet_fechafinal,
			NEW.prodet_observacion,
			NEW.prodet_estado
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		 --Sacamos el codigo y nombre de usuario
		 usuCodigo := (select pc.usu_codigo from produccion_cab pc where pc.prod_codigo=OLD.prod_codigo);
		 usuLogin := (select u.usu_login from produccion_cab pc join usuario u on u.usu_codigo=pc.usu_codigo where pc.prod_codigo=OLD.prod_codigo);
		 --Insertamos la auditoria de la nueva eliminacion	
         INSERT INTO produccion_det_auditoria (
            prodetaud_codigo,
            usu_codigo,
            usu_login,
            prodetaud_fecha,
            prodetaud_procedimiento,
			prod_codigo,
            it_codigo,
            tipit_codigo,
            prodet_cantidad,
			prodet_fechainicio,
			prodet_fechafinal,
			prodet_observacion,
			prodet_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(prodetaud_codigo), 0) + 1 FROM produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.prod_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.prodet_cantidad,
			OLD.prodet_fechainicio,
			OLD.prodet_fechafinal,
			OLD.prodet_observacion,
			OLD.prodet_estado
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_modificacion_eliminacion_produccion_det_auditoria()
CREATE TRIGGER t_insercion_modificacion_eliminacion_produccion_det
AFTER INSERT OR DELETE ON produccion_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_modificacion_eliminacion_produccion_det_auditoria();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_etapa_produccion()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO etapa_produccion_auditoria (
            etproaud_codigo,
            etproaud_fecha,
            etproaud_procedimiento,
            prod_codigo,
            it_codigo,
            tipit_codigo,
            tipet_codigo,
            etpro_fecha,
            usu_codigo,
			suc_codigo,
			emp_codigo,
			maq_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(etproaud_codigo), 0) + 1 FROM etapa_produccion_auditoria), 
            current_timestamp,
            'ALTA',       
            NEW.prod_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.tipet_codigo,
			NEW.etpro_fecha,
			NEW.usu_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.maq_codigo
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Insertamos la auditoria de la nueva eliminacion	
         INSERT INTO etapa_produccion_auditoria (
            etproaud_codigo,
            etproaud_fecha,
            etproaud_procedimiento,
            prod_codigo,
            it_codigo,
            tipit_codigo,
            tipet_codigo,
            etpro_fecha,
            usu_codigo,
			suc_codigo,
			emp_codigo,
			maq_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(etproaud_codigo), 0) + 1 FROM etapa_produccion_auditoria), 
            current_timestamp,
            'BAJA',       
            OLD.prod_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.tipet_codigo,
			OLD.etpro_fecha,
			OLD.usu_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
			OLD.maq_codigo
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_etapa_produccion()
CREATE TRIGGER t_insercion_eliminacion_etapa_produccion
AFTER INSERT OR DELETE ON etapa_produccion
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_etapa_produccion();

--PRODUCCION TERMINADA DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_produccion_terminada_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ptc.usu_codigo from produccion_terminada_cab ptc where ptc.proter_codigo=NEW.proter_codigo);
		usuLogin = (select u.usu_login from produccion_terminada_cab ptc join usuario u on u.usu_codigo=ptc.usu_codigo where ptc.proter_codigo=NEW.proter_codigo);
        INSERT INTO produccion_terminada_det_auditoria(
            proterdetaud_codigo,
            usu_codigo,
            usu_login,
            proterdetaud_fecha,
            proterdetaud_procedimiento,
            proter_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            proterdet_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(proterdetaud_codigo), 0) + 1 FROM produccion_terminada_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.proter_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
            NEW.proterdet_cantidad
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ptc.usu_codigo from produccion_terminada_cab ptc where ptc.proter_codigo=OLD.proter_codigo);
		usuLogin = (select u.usu_login from produccion_terminada_cab ptc join usuario u on u.usu_codigo=ptc.usu_codigo where ptc.proter_codigo=OLD.proter_codigo);
        INSERT INTO produccion_terminada_det_auditoria(
            proterdetaud_codigo,
            usu_codigo,
            usu_login,
            proterdetaud_fecha,
            proterdetaud_procedimiento,
            proter_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            proterdet_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(proterdetaud_codigo), 0) + 1 FROM produccion_terminada_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',   
            OLD.proter_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
            OLD.proterdet_cantidad
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_produccion_terminada_det
CREATE TRIGGER t_insercion_eliminacion_produccion_terminada_det
AFTER INSERT OR DELETE ON produccion_terminada_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_produccion_terminada_det();

--MERMAS DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_mermas_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select mc.usu_codigo from mermas_cab mc where mc.mer_codigo=NEW.mer_codigo);
		usuLogin = (select u.usu_login from mermas_cab mc join usuario u on u.usu_codigo=mc.usu_codigo where mc.mer_codigo=NEW.mer_codigo);
        INSERT INTO mermas_det_auditoria(
            merdetaud_codigo,
            usu_codigo,
            usu_login,
            merdetaud_fecha,
            merdetaud_procedimiento,
            mer_codigo,
            it_codigo,
            tipit_codigo,
			merdet_cantidad,
			merdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(merdetaud_codigo), 0) + 1 FROM mermas_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.mer_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.merdet_cantidad,
			NEW.merdet_precio
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select mc.usu_codigo from mermas_cab mc where mc.mer_codigo=OLD.mer_codigo);
		usuLogin = (select u.usu_login from mermas_cab mc join usuario u on u.usu_codigo=mc.usu_codigo where mc.mer_codigo=OLD.mer_codigo);
        INSERT INTO mermas_det_auditoria(
            merdetaud_codigo,
            usu_codigo,
            usu_login,
            merdetaud_fecha,
            merdetaud_procedimiento,
            mer_codigo,
            it_codigo,
            tipit_codigo,
			merdet_cantidad,
			merdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(merdetaud_codigo), 0) + 1 FROM mermas_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',   
            OLD.mer_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.merdet_cantidad,
			OLD.merdet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_mermas_det
CREATE TRIGGER t_insercion_eliminacion_mermas_det
AFTER INSERT OR DELETE ON mermas_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_mermas_det();

--CONTROL CALIDAD DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_control_calidad_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ccc.usu_codigo from control_calidad_cab ccc where ccc.conca_codigo=NEW.conca_codigo);
		usuLogin = (select u.usu_login from control_calidad_cab ccc join usuario u on u.usu_codigo=ccc.usu_codigo where ccc.conca_codigo=NEW.conca_codigo);
        INSERT INTO control_calidad_det_auditoria(
            concadetaud_codigo,
            usu_codigo,
            usu_login,
            concadetaud_fecha,
            concadetaud_procedimiento,
            conca_codigo,
            it_codigo,
            tipit_codigo,
			pacoca_codigo,
			concadet_cantidadfallida
        )
        VALUES (
            (SELECT COALESCE(MAX(concadetaud_codigo), 0) + 1 FROM control_calidad_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.conca_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.pacoca_codigo,
			NEW.concadet_cantidadfallida
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ccc.usu_codigo from control_calidad_cab ccc where ccc.conca_codigo=OLD.conca_codigo);
		usuLogin = (select u.usu_login from control_calidad_cab ccc join usuario u on u.usu_codigo=ccc.usu_codigo where ccc.conca_codigo=OLD.conca_codigo);
        INSERT INTO control_calidad_det_auditoria(
            concadetaud_codigo,
            usu_codigo,
            usu_login,
            concadetaud_fecha,
            concadetaud_procedimiento,
            conca_codigo,
            it_codigo,
            tipit_codigo,
			pacoca_codigo,
			concadet_cantidadfallida
        )
        VALUES (
            (SELECT COALESCE(MAX(concadetaud_codigo), 0) + 1 FROM control_calidad_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',   
            OLD.conca_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.pacoca_codigo,
			OLD.concadet_cantidadfallida
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_control_calidad_det
CREATE TRIGGER t_insercion_eliminacion_control_calidad_det
AFTER INSERT OR DELETE ON control_calidad_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_control_calidad_det();

--COSTO PRODUCCION DETALLE
CREATE OR REPLACE FUNCTION spt_insercion_costo_produccion_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cpc.usu_codigo from costo_produccion_cab cpc where cpc.copro_codigo=NEW.copro_codigo);
		usuLogin = (select u.usu_login from costo_produccion_cab cpc join usuario u on u.usu_codigo=cpc.usu_codigo where cpc.copro_codigo=NEW.copro_codigo);
        INSERT INTO costo_produccion_det_auditoria(
            coprodetaud_codigo,
            usu_codigo,
            usu_login,
            coprodetaud_fecha,
            coprodetaud_procedimiento,
            copro_codigo,
            it_codigo,
            tipit_codigo,
			coprodet_cantidad,
			coprodet_costo
        )
        VALUES (
            (SELECT COALESCE(MAX(coprodetaud_codigo), 0) + 1 FROM costo_produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.copro_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.coprodet_cantidad,
			NEW.coprodet_costo
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_costo_produccion_det
CREATE TRIGGER t_insercion_costo_produccion_det
AFTER INSERT OR DELETE ON costo_produccion_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_costo_produccion_det();