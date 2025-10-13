--Procedimiento Almacenado
-- Tipo Cliente
create or replace function sp_tipo_cliente(
    ticlicodigo integer,
    ticlidescripcion varchar,
    ticliestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Definimos las variables
declare ticliAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita la descripcion de tipo cliente
        perform * from tipo_cliente
        where upper(ticli_descripcion)=upper(ticlidescripcion) and ticli_codigo != ticlicodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into tipo_cliente(ticli_codigo, ticli_descripcion, ticli_estado)
				values(ticlicodigo, upper(ticlidescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE CLIENTE FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update tipo_cliente
				set ticli_descripcion=upper(ticlidescripcion), ticli_estado='ACTIVO'
				where ticli_codigo=ticlicodigo;
				raise notice 'EL TIPO DE CLIENTE FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update tipo_cliente 
		set ticli_estado='INACTIVO'
		where ticli_codigo=ticlicodigo;
		raise notice 'EL TIPO DE CLIENTE FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(ticli_audit, '') into ticliAudit from tipo_cliente where ticli_codigo = ticlicodigo;
	-- A los datos anteriores le agregamos los nuevos
	update tipo_cliente 
	set ticli_audit = ticliAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'ticli_descripcion', upper(ticlidescripcion),
		'ticli_estado', upper(ticliestado)
	)||','
	where ticli_codigo = ticlicodigo;
end
$function$ 
language plpgsql;

-- Chapa Vehiculo
create or replace function sp_chapa_vehiculo(
	chavecodigo integer,
    chavechapa varchar,
    modvecodigo integer,
    chaveestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    modvedescripcion varchar,
    marvedescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare chaveAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita el numero de chapa
        perform * from chapa_vehiculo
        where upper(chave_chapa)=upper(chavechapa) and chave_codigo != chavecodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'chapa';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into chapa_vehiculo(chave_codigo, chave_chapa, modve_codigo, chave_estado)
				values(chavecodigo, upper(chavechapa), modvecodigo, 'ACTIVO');
				raise notice 'LA CHAPA DE VEHICULO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update chapa_vehiculo
				set chave_chapa=upper(chavechapa), modve_codigo=modvecodigo, chave_estado='ACTIVO'
				where chave_codigo=chavecodigo;
				raise notice 'LA CHAPA DE VEHICULO FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update chapa_vehiculo 
		set chave_estado='INACTIVO'
		where chave_codigo=chavecodigo;
		raise notice 'LA CHAPA DE VEHICULO FUE BORRADA CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(chave_audit, '') into chaveAudit from chapa_vehiculo where chave_codigo = chavecodigo;
	-- A los datos anteriores le agregamos los nuevos
	update chapa_vehiculo 
	set chave_audit = chaveAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'chave_chapa', upper(chavechapa),
		'modve_codigo', modvecodigo,
		'modve_descripcion', upper(modvedescripcion),
		'marve_codigo', marvecodigo,
		'marve_descripcion', upper(marvedescripcion),
		'chave_estado', upper(chaveestado)
	)||','
	where chave_codigo = chavecodigo;
end
$function$ 
language plpgsql;

-- Modelo Vehiculo
create or replace function sp_modelo_vehiculo(
    modvecodigo integer,
    modvedescripcion varchar,
    modveestado varchar,
    marvecodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    marvedescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare modveAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita el modelo vehiculo y la marca del vehiculo
        perform * from modelo_vehiculo
        where upper(modve_descripcion)=upper(modvedescripcion) and marve_codigo=marvecodigo
        and modve_codigo != modvecodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into modelo_vehiculo(modve_codigo, modve_descripcion, modve_estado, marve_codigo)
				values(modvecodigo, upper(modvedescripcion), 'ACTIVO', marvecodigo);
				raise notice 'EL MODELO DE VEHICULO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update modelo_vehiculo
				set modve_descripcion=upper(modvedescripcion), modve_estado='ACTIVO', marve_codigo=marvecodigo
				where modve_codigo=modvecodigo;
				raise notice 'EL MODELO DE VEHICULO FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update modelo_vehiculo 
		set modve_estado='INACTIVO'
		where modve_codigo=modvecodigo;
		raise notice 'EL MODELO DE VEHICULO FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(modve_audit, '') into modveAudit from modelo_vehiculo where modve_codigo = modvecodigo;
	-- A los datos anteriores le agregamos los nuevos
	update modelo_vehiculo 
	set modve_audit = modveAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'modve_descripcion', upper(modvedescripcion),
		'marve_codigo', marvecodigo,
		'marve_descripcion', upper(marvedescripcion),
		'modve_estado', upper(modveestado)
	)||','
	where modve_codigo = modvecodigo;
end
$function$ 
language plpgsql;
language plpgsql;

-- Marca Vehiculo
create or replace function sp_marca_vehiculo(
    marvecodigo integer,
    marvedescripcion varchar,
    marveestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Definimos las variables
declare marveAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
        perform * from marca_vehiculo
        where upper(marve_descripcion)=upper(marvedescripcion)
        and marve_codigo != marvecodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into marca_vehiculo(marve_codigo, marve_descripcion, marve_estado)
				values(marvecodigo, upper(marvedescripcion), 'ACTIVO');
				raise notice 'LA MARCA DE VEHICULO FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update marca_vehiculo
				set marve_descripcion=upper(marvedescripcion), marve_estado='ACTIVO'
				where marve_codigo=marvecodigo;
				raise notice 'LA MARCA DE VEHICULO FUE MODIFICADA CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update marca_vehiculo 
		set marve_estado='INACTIVO'
		where marve_codigo=marvecodigo;
		raise notice 'LA MARCA DE VEHICULO FUE BORRADA CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(marve_audit, '') into marveAudit from marca_vehiculo where marve_codigo = marvecodigo;
	-- A los datos anteriores le agregamos los nuevos
	update marca_vehiculo 
	set marve_audit = marveAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'marve_descripcion', upper(marvedescripcion),
		'marve_estado', upper(marveestado)
	)||','
	where marve_codigo = marvecodigo;
end
$function$ 
language plpgsql;

--Red Pago
create or replace function sp_red_pago(
    redpacodigo integer,
    redpadescripcion varchar,
    redpaestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare redpaAudit text;
begin 
	--Validamos si la operacion es de insercion o modificacion
    if operacion in(1,2) then
		--Validamos que la descripcion no se repita, solo en caso de modificar un mismo registro
        perform * from red_pago
        where upper(redpa_descripcion) = upper(redpadescripcion)
        and redpa_codigo != redpacodigo;
        if found then
			--En caso de que se cumpla la condicion, generamos una excepcion
            raise exception '1';
    	elseif operacion = 1 then
				--En caso de que no se cumpla, procedemos con la insercion en caso de que la operacion sea 1
	        	insert into red_pago(redpa_codigo, redpa_descripcion, redpa_estado)
				values(redpacodigo, upper(redpadescripcion), 'ACTIVO');
				--Enviamos un mensaje de confirmacion de insercion
				raise notice 'LA RED DE PAGO FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
				--En caso de que no se cumpla, procedemos con la modificacion en caso de que la operacion sea 2
        		update red_pago
				set redpa_descripcion=upper(redpadescripcion), redpa_estado='ACTIVO'
				where redpa_codigo=redpacodigo;
				--Enviamos un mensaje de confirmacion de modificacion
				raise notice 'LA RED DE PAGO FUE MODIFICADA CON EXITO';
        end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 3 then 
		--En este caso se procede con un borrado logico
    	update red_pago
		set redpa_estado='INACTIVO'
		where redpa_codigo=redpacodigo;
		raise notice 'LA RED DE PAGO FUE ELIMINADA CON EXITO';
    end if;
	--Consultamos el audit anterior
	select coalesce(redpa_audit, '') into redpaAudit from red_pago where redpa_codigo = redpacodigo;
	--A los datos anteriores le agregamos los nuevos
	update red_pago 
	set redpa_audit = redpaAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'redpa_descripcion', upper(redpadescripcion),
		'redpa_estado', upper(redpaestado)
	)||','
	where redpa_codigo = redpacodigo;
end
$function$ 
language plpgsql;

--Timbrados
create or replace function sp_timbrados(
    timbcodigo integer,
    succodigo integer,
    empcodigo integer,
    cajcodigo integer,
    tipcocodigo integer,
    timbnumero integer,
    timbnumerofechainic date,
    timbnumerofechavenc date,
    timbnumerocomp varchar,
    timbnumerocompinic integer,
    timbnumerocomplim integer,
    timbestado varchar,
    usucodigo integer,
    operacion integer
) returns void as
$function$
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que la fecha de vencimiento no sea menor a la fecha de inicio
		if timbnumerofechavenc < timbnumerofechainic then
		  -- En caso de ser asi, generamos una excepcion
		  raise exception 'fecha_venc';
		end if;
		-- Validamos que el número limite no sea menor al numero de inicio
		if timbnumerocomplim < timbnumerocompinic then
		  -- En caso de ser asi, generamos una excepcion
		  raise exception 'numero_limite';
		end if;
		-- Validamos que no se repita el numero de timbrado
		perform * from timbrados
        where timb_numero=timbnumero and timb_codigo != timbcodigo;
		if found then
	       -- En caso de ser asi, generamos una excepcion
            raise exception 'timbrado';
		end if;
		-- Validamos que no se repita la sucursal, empresa, caja y tipo comprobante
        perform * from timbrados
        where suc_codigo=succodigo and emp_codigo=empcodigo
		and caj_codigo=cajcodigo and tipco_codigo=tipcocodigo
        and timb_codigo != timbcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into timbrados(timb_codigo, suc_codigo, emp_codigo, 
									  caj_codigo, tipco_codigo, timb_numero,
	        						  timb_numero_fecha_inic, timb_numero_fecha_venc, timb_numero_comp,
									  timb_numero_comp_inic, timb_numero_comp_lim, timb_estado, usu_codigo)
				values(timbcodigo, succodigo, empcodigo, 
					   cajcodigo, tipcocodigo, timbnumero,
	        		   timbnumerofechainic, timbnumerofechavenc, timbnumerocomp,
					   timbnumerocompinic, timbnumerocomplim, 'ACTIVO', usucodigo);
				-- Enviamos un mensaje de confirmacion
				raise notice 'EL TIMBRADO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update timbrados
				set suc_codigo=succodigo, emp_codigo=empcodigo, caj_codigo=cajcodigo,
				tipco_codigo=tipcocodigo, timb_numero=timbnumero, timb_numero_fecha_inic=timbnumerofechainic,
				timb_numero_fecha_venc=timbnumerofechavenc, timb_numero_comp=timbnumerocomp, timb_numero_comp_inic=timbnumerocompinic,
				timb_numero_comp_lim=timbnumerocomplim, timb_estado='ACTIVO', usu_codigo=usucodigo
				where timb_codigo=timbcodigo;
				-- Enviamos un mensaje de confirmacion
				raise notice 'EL TIMBRADO FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de elimianacion (borrado logíco)
    if operacion = 3 then 
    	update timbrados 
		set timb_estado='INACTIVO', usu_codigo=usucodigo
		where timb_codigo=timbcodigo;
		-- Enviamos un mensaje de confirmacion
		raise notice 'EL TIMBRADO FUE BORRADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Tipo documento
create or replace function sp_tipo_documento(
    tipdocodigo integer,
    tipdodescripcion varchar,
    tipdoestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare tipdoAudit text;
begin 
    if operacion in(1,2) then
        perform * from tipo_documento
        where upper(tipdo_descripcion) = upper(tipdodescripcion)
        and tipdo_codigo != tipdocodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into tipo_documento(tipdo_codigo, tipdo_descripcion, tipdo_estado)
				values(tipdocodigo, upper(tipdodescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE DOCUMENTO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		UPDATE tipo_documento
				SET tipdo_descripcion=upper(tipdodescripcion), tipdo_estado='ACTIVO'
				WHERE tipdo_codigo=tipdocodigo;
				raise notice 'EL TIPO DE DOCUMENTO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	UPDATE tipo_documento
		SET tipdo_estado='INACTIVO'
		WHERE tipdo_codigo=tipdocodigo;
		raise notice 'EL TIPO DE DOCUMENTO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(tipdo_audit, '') into tipdoAudit from tipo_documento where tipdo_codigo = tipdocodigo;
	--a los datos anteriores le agregamos los nuevos
	update tipo_documento 
	set tipdo_audit = tipdoAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tipdo_descripcion', upper(tipdodescripcion),
		'tipdo_estado', upper(tipdoestado)
	)||','
	where tipdo_codigo = tipdocodigo;
end
$function$ 
language plpgsql;

--Tipo Comprobante
create or replace function sp_tipo_comprobante(
    tipcocodigo integer,
    tipcodescripcion varchar,
    tipcoestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare tipcoAudit text;
begin 
    if operacion in(1,2) then
        perform * from tipo_comprobante
        where upper(tipco_descripcion) = upper(tipcodescripcion)
        and tipco_codigo != tipcocodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into tipo_comprobante(tipco_codigo, tipco_descripcion, tipco_estado)
				values(tipcocodigo, upper(tipcodescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE COMPROBANTE FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update tipo_comprobante
				set tipco_descripcion=upper(tipcodescripcion), tipco_estado='ACTIVO'
				where tipco_codigo=tipcocodigo;
				raise notice 'EL TIPO DE COMPROBANTE FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update tipo_comprobante
		set tipco_estado='INACTIVO'
		where tipco_codigo=tipcocodigo;
		raise notice 'EL TIPO DE COMPROBANTE FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(tipco_audit, '') into tipcoAudit from tipo_comprobante where tipco_codigo = tipcocodigo;
	--a los datos anteriores le agregamos los nuevos
	update tipo_comprobante 
	set tipco_audit = tipcoAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tipco_descripcion', upper(tipcodescripcion),
		'tipco_estado', upper(tipcoestado)
	)||','
	where tipco_codigo = tipcocodigo;
end
$function$ 
language plpgsql;

--Forma Cobro
create or replace function sp_forma_cobro(
    forcocodigo integer,
    forcodescripcion varchar,
    forcoestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare forcoAudit text;
begin 
    if operacion in(1,2) then
        perform * from forma_cobro
        where upper(forco_descripcion) = upper(forcodescripcion)
        and forco_codigo != forcocodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into forma_cobro(forco_codigo, forco_descripcion, forco_estado)
				values(forcocodigo, upper(forcodescripcion), 'ACTIVO');
				raise notice 'LA FORMA DE COBRO FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update forma_cobro
				set forco_descripcion=upper(forcodescripcion), forco_estado='ACTIVO'
				where forco_codigo=forcocodigo;
				raise notice 'LA FORMA DE COBRO FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update forma_cobro
		set forco_estado='INACTIVO'
		where forco_codigo=forcocodigo;
		raise notice 'LA FORMA DE COBRO FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(forco_audit, '') into forcoAudit from forma_cobro where forco_codigo = forcocodigo;
	--a los datos anteriores le agregamos los nuevos
	update forma_cobro 
	set forco_audit = forcoAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'forco_descripcion', upper(forcodescripcion),
		'forco_estado', upper(forcoestado)
	)||','
	where forco_codigo = forcocodigo;
end
$function$ 
language plpgsql;

--Marca Tarjeta
create or replace function sp_marca_tarjeta(
    martacodigo integer,
    martadescripcion varchar,
    martaestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare martaAudit text;
begin 
    if operacion in(1,2) then
        perform * from marca_tarjeta
        where upper(marta_descripcion) = upper(martadescripcion)
        and marta_codigo != martacodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into marca_tarjeta(marta_codigo, marta_descripcion, marta_estado)
				values(martacodigo, upper(martadescripcion), 'ACTIVO');
				raise notice 'LA MARCA DE TARJETA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update marca_tarjeta
				set marta_descripcion=upper(martadescripcion), marta_estado='ACTIVO'
				where marta_codigo=martacodigo;
				raise notice 'LA MARCA DE TARJETA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update marca_tarjeta
		set marta_estado='INACTIVO'
		where marta_codigo=martacodigo;
		raise notice 'LA MARCA DE TARJETA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(marta_audit, '') into martaAudit from marca_tarjeta where marta_codigo = martacodigo;
	--a los datos anteriores le agregamos los nuevos
	update marca_tarjeta 
	set marta_audit = martaAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'marta_descripcion', upper(martadescripcion),
		'marta_estado', upper(martaestado)
	)||','
	where marta_codigo = martacodigo;
end
$function$ 
language plpgsql;

--Entidad Emisora
create or replace function sp_entidad_emisora(
    entcodigo integer,
    entrazonsocial varchar,
    entruc varchar,
    enttelefono varchar,
    entemail varchar,
    entestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare entAudit text;
begin 
    if operacion in(1,2) then
        perform * from entidad_emisora
        where ent_ruc = entruc and ent_codigo != entcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into entidad_emisora(ent_codigo, ent_razonsocial, ent_ruc, ent_telefono, ent_email, ent_estado)
				values(entcodigo, upper(entrazonsocial), entruc, enttelefono, entemail, 'ACTIVO');
				raise notice 'LA ENTIDAD EMISORA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update entidad_emisora
				set ent_razonsocial=upper(entrazonsocial), ent_ruc=entruc, ent_telefono=enttelefono,
				ent_email=entemail, ent_estado='ACTIVO'
				where ent_codigo=entcodigo;
				raise notice 'LA ENTIDAD EMISORA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update entidad_emisora
		set ent_estado='INACTIVO'
		where ent_codigo=entcodigo;
		raise notice 'LA ENTIDAD EMISORA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(ent_audit, '') into entAudit from entidad_emisora where ent_codigo = entcodigo;
	--a los datos anteriores le agregamos los nuevos
	update entidad_emisora 
	set ent_audit = entAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'ent_razonsocial', upper(entrazonsocial),
		'ent_ruc', entruc,
		'ent_telefono', enttelefono,
		'ent_email', entemail,
		'ent_estado', upper(entestado)
	)||','
	where ent_codigo = entcodigo;
end
$function$ 
language plpgsql;

--Entidad Adherida
create or replace function sp_entidad_adherida(
    entadcodigo integer,
    entcodigo integer,
    martacodigo integer,
    entadestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    entrazonsocial varchar,
    martadescripcion varchar
) returns void as
$function$
declare entadAudit text;
begin 
    if operacion in(1,2) then
        perform * from entidad_adherida
        where (ent_codigo=entcodigo and marta_codigo=martacodigo)
        and entad_codigo != entadcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into entidad_adherida(entad_codigo, ent_codigo, marta_codigo, entad_estado)
				values(entadcodigo, entcodigo, martacodigo, 'ACTIVO');
				raise notice 'LA ENTIDAD ADHERIDA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update entidad_adherida
				set ent_codigo=entcodigo, marta_codigo=martacodigo, entad_estado='ACTIVO'
				where entad_codigo=entadcodigo;
				raise notice 'LA ENTIDAD ADHERIDA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update entidad_adherida
		set entad_estado='INACTIVO'
		where entad_codigo=entadcodigo;
		raise notice 'LA ENTIDAD ADHERIDA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(entad_audit, '') into entadAudit from entidad_adherida where entad_codigo = entadcodigo;
	--a los datos anteriores le agregamos los nuevos
	update entidad_adherida 
	set entad_audit = entadAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'ent_codigo', entcodigo,
		'ent_razonsocial', upper(entrazonsocial),
		'marta_codigo', martacodigo,
		'marta_descripcion', upper(martadescripcion),
		'entad_estado', upper(entadestado)
	)||','
	where entad_codigo = entadcodigo;
end
$function$ 
language plpgsql;

--Caja
create or replace function sp_caja(
    cajcodigo integer,
    cajdescripcion varchar,
    cajestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare cajAudit text;
begin 
    if operacion in(1,2) then
        perform * from caja
        where upper(caj_descripcion)=upper(cajdescripcion)
        and caj_codigo != cajcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into caja(caj_codigo, caj_descripcion, caj_estado, suc_codigo, emp_codigo)
				values(cajcodigo, upper(cajdescripcion), 'ACTIVO');
				raise notice 'LA CAJA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update caja
				set caj_descripcion=upper(cajdescripcion), caj_estado='ACTIVO'
				where caj_codigo=cajcodigo;
				raise notice 'LA CAJA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update caja 
		set caj_estado='INACTIVO'
		where caj_codigo=cajcodigo;
		raise notice 'LA CAJA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(caj_audit, '') into cajAudit from caja where caj_codigo = cajcodigo;
	--a los datos anteriores le agregamos los nuevos
	update caja 
	set caj_audit = cajAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'caj_descripcion', upper(cajdescripcion),
		'caj_estado', upper(cajestado)
	)||','
	where caj_codigo = cajcodigo;
end
$function$ 
language plpgsql;

--Clientes
create or replace function sp_cliente(
    clicodigo integer,
    clidireccion varchar,
    clitipocliente tipo_cliente,
    cliestado varchar,
    percodigo integer,
    ciucodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    pernumerodocumento varchar,
    persona varchar,
    ciudescripcion varchar--1:insert 2:update 3:delete
) returns void as
$function$
declare cliAudit text;
begin 
    if operacion in(1,2) then
        perform * from cliente
        where per_codigo=percodigo
        and cli_codigo != clicodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into cliente(cli_codigo, cli_direccion, cli_tipocliente, cli_estado, per_codigo,
	        	ciu_codigo)
				values(clicodigo, upper(clidireccion), clitipocliente, 'ACTIVO', percodigo, ciucodigo);
				raise notice 'EL CLIENTE FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update cliente
				set cli_direccion=upper(clidireccion), cli_tipocliente=clitipocliente, cli_estado='ACTIVO',
				per_codigo=percodigo, ciu_codigo=ciucodigo
				where cli_codigo=clicodigo;
				raise notice 'EL CLIENTE FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update cliente 
		set cli_estado='INACTIVO'
		where cli_codigo=clicodigo;
		raise notice 'EL CLIENTE FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(cli_audit, '') into cliAudit from cliente where cli_codigo = clicodigo;
	--a los datos anteriores le agregamos los nuevos
	update cliente 
	set cli_audit = cliAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'cli_tipocliente', clitipocliente,
		'per_codigo', percodigo,
		'per_numerodocumento', pernumerodocumento,
		'persona', upper(persona),
		'ciu_codigo', ciucodigo,	
		'ciu_descripcion', upper(ciudescripcion),	
		'cli_direccion', upper(clidireccion),
		'cli_estado', upper(cliestado)
	)||','
	where cli_codigo = clicodigo;
end
$function$ 
language plpgsql;

--Pedido Venta Cabecera
create or replace function sp_pedido_venta_cab(
    pevencodigo integer,
    pevenfecha date,
    pevenestado varchar,
    succodigo integer,
    empcodigo integer,
    clicodigo integer,
    usucodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    pernumerodocumento varchar,
    cliente varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
--Declaramos las variables a utilizar
declare pevenAudit text;
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
	     insert into pedido_venta_cab(peven_codigo, peven_fecha, peven_estado, suc_codigo, emp_codigo, cli_codigo, usu_codigo)
		 values(pevencodigo, pevenfecha, 'PENDIENTE', succodigo, empcodigo, clicodigo, usucodigo);
		 raise notice 'EL PEDIDO DE VENTA FUE REGISTRADO CON EXITO';
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--En esta parte se hace solo un borrado logico
    	update pedido_venta_cab 
		set peven_estado='ANULADO', usu_codigo=usucodigo
		where peven_codigo=pevencodigo;
		raise notice 'EL PEDIDO DE VENTA FUE ANULADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(peven_audit, '') into pevenAudit from pedido_venta_cab where peven_codigo=pevencodigo;
	--a los datos anteriores le agregamos los nuevos
	update pedido_venta_cab 
	set peven_audit = pevenAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'peven_fecha', pevenfecha,
		'cli_codigo', clicodigo,
		'cliente', upper(cliente),
		'per_numerodocumento', pernumerodocumento,
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'peven_estado', upper(pevenestado)
	)||','
	where peven_codigo = pevencodigo;
end
$function$ 
language plpgsql;

--Pedido Venta Detalle
create or replace function sp_pedido_venta_det(
    pevencodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    pevendetcantidad numeric,
    pevendetprecio numeric,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si existe el item en caso de que si generamos una excepcion
     	perform * from pedido_venta_det
     	where it_codigo=itcodigo and peven_codigo=pevencodigo;
     	if found then
     		 raise exception 'item';
		--Si no existe el item insertamos el mismo en el detalle
     	elseif operacion = 1 then
		     insert into pedido_venta_det(peven_codigo, it_codigo, tipit_codigo, pevendet_cantidad, pevendet_precio)
			 values(pevencodigo, itcodigo, tipitcodigo, pevendetcantidad, pevendetprecio);
			 raise notice 'EL PEDIDO DE VENTA DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from pedido_venta_det 
    	where peven_codigo=pevencodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'EL PEDIDO DE VENTA DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Apertura Cierre 
create or replace function sp_apertura_cierre(
    aperciecodigo integer,
    succodigo integer,
    empcodigo integer,
    cajcodigo integer,
    usucodigo integer,
    aperciefechahoraapertura timestamp,
    aperciefechahoracierre timestamp,
    aperciemontoapertura numeric,
    aperciemontocierre numeric,
    apercieestado varchar,
    operacion integer 
) returns void as	
$function$
-- Definimos las variables
declare ultcod integer;
begin 
	 -- Validamos que la oepracion sea de insercion
     if operacion = 1 then
		-- Validamos que no se repita la caja abierta por sucursal
     	perform * from apertura_cierre
     	where (caj_codigo=cajcodigo and suc_codigo=succodigo and emp_codigo=empcodigo and apercie_estado='ABIERTO' and apercie_codigo<>aperciecodigo);
     	if found then
			 -- En caso de ser asi, generamos una excepcion
     		 raise exception 'caja';
     	elseif operacion = 1 then
		 -- Si los parametros pasan la validacion, procedemos con su insercion
	     insert into apertura_cierre(apercie_codigo, suc_codigo, emp_codigo, 
									 caj_codigo, usu_codigo, apercie_fechahoraapertura, apercie_fechahoracierre, 
									 apercie_montoapertura, apercie_montocierre, apercie_estado)
		 values(aperciecodigo, succodigo, empcodigo, 
				cajcodigo, usucodigo, aperciefechahoraapertura, aperciefechahoracierre,
				aperciemontoapertura, aperciemontocierre, 'ABIERTO');
		 -- Enviamos mensaje de confirmacion
		 raise notice 'CAJA ABIERTA EXITOSAMENTE';
		end if;
    end if;
	-- Validamos que la operacion sea de modificacion
    if operacion = 2 then 
    	update apertura_cierre 
		set apercie_fechahoracierre=aperciefechahoracierre, apercie_montocierre=aperciemontocierre, apercie_estado='CERRADO', usu_codigo=usucodigo
		where apercie_codigo=aperciecodigo;
		-- Enviamos mensaje de confirmacion
		raise notice 'CAJA CERRADA EXITOSAMENTE';
    end if;
end
$function$ 
language plpgsql;

--Venta cabecera
CREATE OR REPLACE FUNCTION sp_venta_cab(
    vencodigo integer,
    venfecha date,
    vennumfactura varchar,
    ventimbrado varchar,
    ventimbradovenc date,
    ventipofactura tipo_factura,
    vencuota integer,
    venmontocuota numeric,
    veninterfecha varchar,
    venestado varchar,
    usucodigo integer,
    clicodigo integer,
    succodigo integer,
    empcodigo integer,
    tipcocodigo integer,
    pevencodigo integer,
    cajcodigo integer,
    operacion integer 
) RETURNS void AS
$function$
DECLARE
    ventaDet record;
    pedido   record;
	presupuestoDet record;
    -- Variables para reducir llamadas repetidas
    usuario_txt varchar;
    sucursal_txt varchar;
    empresa_txt  varchar;
    -- Variables para claves autocalculadas
    ultcod_pedven integer;
    ultcod_libven integer;
	-- Variables de cantidad
	cantidadStockAuditoria numeric := 0;
BEGIN
    -- PRE-CARGAS: usuario, sucursal y empresa (se usan en auditoría)
    SELECT usu_login INTO usuario_txt FROM usuario WHERE usu_codigo = usucodigo;
    SELECT suc_descripcion INTO sucursal_txt FROM sucursal WHERE suc_codigo = succodigo;
    SELECT emp_razonsocial INTO empresa_txt FROM empresa WHERE emp_codigo = empcodigo;

    -- OPERACION = 1 -> INSERTAR NUEVA VENTA
    IF operacion = 1 THEN

        -- Verificar duplicado de factura
        IF EXISTS (
            SELECT 1 FROM venta_cab
            WHERE ven_numfactura = vennumfactura
			  AND ven_timbrado = ventimbrado
              AND ven_estado = 'ACTIVO'
        ) THEN
            RAISE EXCEPTION 'factura';
        END IF;

        -- Insertar cabecera venta
        INSERT INTO venta_cab(
            ven_codigo, ven_fecha, ven_numfactura, ven_tipofactura,
            ven_cuota, ven_montocuota, ven_interfecha, ven_estado,
            usu_codigo, cli_codigo, suc_codigo, emp_codigo,
            tipco_codigo, ven_timbrado, ven_timbrado_venc
        ) VALUES (
            vencodigo, venfecha, vennumfactura, ventipofactura,
            vencuota, venmontocuota, upper(veninterfecha), 'ACTIVO',
            usucodigo, clicodigo, succodigo, empcodigo,
            tipcocodigo, ventimbrado, ventimbradovenc
        );

        -- Insertar relacion pedido_venta (calcular nuevo pedven_codigo una sola vez)
        SELECT coalesce(max(pedven_codigo),0) + 1 INTO ultcod_pedven FROM pedido_venta;
        INSERT INTO pedido_venta(ven_codigo, peven_codigo, pedven_codigo)
        VALUES (vencodigo, pevencodigo, ultcod_pedven);

        -- Insertar libro_venta (calcular nuevo libven_codigo una sola vez)
        SELECT coalesce(max(libven_codigo),0) + 1 INTO ultcod_libven FROM libro_venta;
        INSERT INTO libro_venta(
            libven_codigo, ven_codigo, libven_exenta, libven_iva5,
            libven_iva10, libven_fecha, libven_numcomprobante, libven_estado, tipco_codigo
        ) VALUES (
            ultcod_libven, vencodigo, 0, 0, 0, venfecha, vennumfactura, 'ACTIVO', tipcocodigo
        );

        -- Insertar cuenta cobrar (inicialmente 0s)
        INSERT INTO cuenta_cobrar(
            ven_codigo, cuenco_nrocuota, cuenco_monto, cuenco_saldo, cuenco_estado, tipco_codigo
        ) VALUES (
            vencodigo, vencuota, 0, 0, 'ACTIVO', tipcocodigo
        );

		-- Insertar detalle venta 
		FOR presupuestoDet IN
            SELECT pd.it_codigo, pd.tipit_codigo, pd.presdet_cantidad, pd.presdet_precio
			FROM presupuesto_det pd 
			 JOIN presupuesto_cab pc ON pc.pres_codigo=pd.pres_codigo 
			WHERE pc.peven_codigo=pevencodigo
        LOOP
			-- Insertamos en detalle
            INSERT INTO venta_det(
            ven_codigo, it_codigo, tipit_codigo, dep_codigo,
            suc_codigo, emp_codigo, vendet_cantidad, vendet_precio
        	) VALUES (
            vencodigo, presupuestoDet.it_codigo, presupuestoDet.tipit_codigo, 1,
            succodigo, empcodigo, presupuestoDet.presdet_cantidad, presupuestoDet.presdet_precio
        	);
			-- Restamos de stock la cantidad
			-- Actualizar stock (disminuir)
	        UPDATE stock
	        SET st_cantidad = st_cantidad - presupuestoDet.presdet_cantidad
	        WHERE it_codigo   = presupuestoDet.it_codigo
	          AND tipit_codigo= presupuestoDet.tipit_codigo
	          AND dep_codigo  = 1
	          AND suc_codigo  = succodigo
	          AND emp_codigo  = empcodigo;
			-- Actualizar auditoria stock pito
			select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=presupuestoDet.it_codigo and s.tipit_codigo=presupuestoDet.tipit_codigo
			and s.dep_codigo=1 and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			perform sp_stock(presupuestoDet.it_codigo, presupuestoDet.tipit_codigo, 1, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usuario_txt);
        END LOOP;

        -- Actualizar pedido_venta_cab a 'VENDIDO'
        UPDATE pedido_venta_cab
        SET peven_estado = 'VENDIDO', usu_codigo = usucodigo
        WHERE peven_codigo = pevencodigo;

        -- Actualizar número de factura en tabla timbrados
        UPDATE timbrados
        SET timb_numero_comp = split_part(vennumfactura, '-', 3)::integer, usu_codigo=usucodigo
        WHERE suc_codigo = succodigo
          AND emp_codigo = empcodigo
          AND caj_codigo = cajcodigo
		  AND tipco_codigo = tipcocodigo;

		-- Enviamos un mensaje de confirmacion
        RAISE NOTICE 'LA VENTA FUE REGISTRADA CON EXITO';

    END IF; 

    -- OPERACION = 2 -> ANULAR VENTA (borrado lógico y reversión stock)
    IF operacion = 2 THEN

		-- Verificamos si la venta ya se encuentra asociada a una nota
        IF EXISTS (
            SELECT 1 FROM nota_venta_cab
            WHERE ven_codigo = vencodigo
              AND notven_estado <> 'ANULADO'
        ) THEN
            RAISE EXCEPTION 'asociado_nota';
        END IF;

		-- Verificamos si la venta ya se encuentra asociada a un cobro
        IF EXISTS (
            SELECT 1 FROM cobro_cab
            WHERE ven_codigo = vencodigo
              AND cob_estado <> 'ANULADO'
        ) THEN
            RAISE EXCEPTION 'asociado_cobro';
        END IF;

        -- Marcar venta como ANULADO
        UPDATE venta_cab
        SET usu_codigo = usucodigo, ven_estado = 'ANULADO'
        WHERE ven_codigo = vencodigo;

        -- Anular libro de ventas y cuentas por cobrar
        UPDATE libro_venta SET libven_estado = 'ANULADO' WHERE ven_codigo = vencodigo;
        UPDATE cuenta_cobrar SET cuenco_estado = 'ANULADO' WHERE ven_codigo = vencodigo;

        -- Activar/ajustar estado del pedido original
        UPDATE pedido_venta_cab
        SET peven_estado = 'TERMINADA', usu_codigo = usucodigo
        WHERE peven_codigo = pevencodigo;

        -- Revertir stock sumando las cantidades de venta_det
        FOR ventaDet IN
            SELECT * FROM venta_det WHERE ven_codigo = vencodigo
        LOOP
            UPDATE stock
            SET st_cantidad = st_cantidad + ventaDet.vendet_cantidad
            WHERE it_codigo = ventaDet.it_codigo
              AND tipit_codigo = ventaDet.tipit_codigo
              AND dep_codigo = ventaDet.dep_codigo
              AND suc_codigo = ventaDet.suc_codigo
              AND emp_codigo = ventaDet.emp_codigo;
			-- Actualizar auditoria stock pito
			select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=ventaDet.it_codigo and s.tipit_codigo=ventaDet.tipit_codigo
			and s.dep_codigo=ventaDet.dep_codigo and s.suc_codigo=ventaDet.suc_codigo and s.emp_codigo=ventaDet.emp_codigo;
			perform sp_stock(ventaDet.it_codigo, ventaDet.tipit_codigo, ventaDet.dep_codigo, ventaDet.suc_codigo, ventaDet.emp_codigo, 
			cantidadStockAuditoria, 2, usucodigo, usuario_txt);
        END LOOP;

		-- Enviamos un mensaje de confirmacion
        RAISE NOTICE 'LA VENTA FUE ANULADA CON EXITO';

    END IF; -- operacion = 2

    -- AUDITORIA: actualizar campo peven_audit en pedido_venta_cab
    FOR pedido IN (
        SELECT pvc.peven_fecha, pvc.cli_codigo,
               p.per_nombre || ' ' || p.per_apellido AS cliente,
               p.per_numerodocumento, pvc.peven_estado, pvc.peven_audit
        FROM pedido_venta_cab pvc
        JOIN cliente c ON c.cli_codigo = pvc.cli_codigo
        JOIN personas p ON p.per_codigo = c.per_codigo
        WHERE pvc.peven_codigo = pevencodigo
    ) LOOP
        UPDATE pedido_venta_cab
        SET peven_audit = pedido.peven_audit || '' || json_build_object(
            'usu_codigo', usucodigo,
            'usu_login', coalesce(usuario_txt, ''),
            'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
            'procedimiento', 'MODIFICACION',
            'peven_fecha', pedido.peven_fecha,
            'cli_codigo', pedido.cli_codigo,
            'cliente', pedido.cliente,
            'per_numerodocumento', pedido.per_numerodocumento,
            'emp_codigo', empcodigo,
            'emp_razonsocial', coalesce(empresa_txt, ''),
            'suc_codigo', succodigo,
            'suc_descripcion', coalesce(sucursal_txt, ''),
            'peven_estado', pedido.peven_estado
        ) || ','
        WHERE peven_codigo = pevencodigo;
    END LOOP;

END;
$function$ LANGUAGE plpgsql;

--Venta Detalle
CREATE OR REPLACE FUNCTION sp_venta_det(
    vencodigo       integer,
    itcodigo        integer,
    tipitcodigo     integer,
    depcodigo       integer,
    succodigo       integer,
    empcodigo       integer,
    vendetcantidad  integer,
    vendetprecio    numeric,
    operacion       integer
) RETURNS void AS
$function$
declare cantidadStockAuditoria numeric := 0;
		usuario_int integer := 0;
		usuario_txt varchar;
BEGIN
	SELECT vc.usu_codigo INTO usuario_int FROM venta_cab vc WHERE vc.ven_codigo = vencodigo;
	SELECT usu_login INTO usuario_txt FROM usuario WHERE usu_codigo = usuario_int;
    -- OPERACION = 1 -> INSERTAR DETALLE DE VENTA
    IF operacion = 1 THEN
        -- Validar si ya existe el item en el mismo depósito para la misma venta
        IF EXISTS (
            SELECT 1 FROM venta_det
            WHERE ven_codigo = vencodigo
              AND it_codigo  = itcodigo
              AND dep_codigo = depcodigo
        ) THEN
            RAISE EXCEPTION 'item';
        END IF;

        -- Insertar detalle
        INSERT INTO venta_det(
            ven_codigo, it_codigo, tipit_codigo, dep_codigo,
            suc_codigo, emp_codigo, vendet_cantidad, vendet_precio
        ) VALUES (
            vencodigo, itcodigo, tipitcodigo, depcodigo,
            succodigo, empcodigo, vendetcantidad, vendetprecio
        );

        -- Actualizar stock (disminuir)
        UPDATE stock
        SET st_cantidad = st_cantidad - vendetcantidad
        WHERE it_codigo   = itcodigo
          AND tipit_codigo= tipitcodigo
          AND dep_codigo  = depcodigo
          AND suc_codigo  = succodigo
          AND emp_codigo  = empcodigo;

		-- Actualizar auditoria stock
		select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
		and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
		perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usuario_int, usuario_txt);

		-- Enviamos un mensaje de conformacion
        RAISE NOTICE 'LA VENTA DETALLE FUE REGISTRADA CON EXITO';
    END IF;

    -- OPERACION = 2 -> ELIMINAR DETALLE DE VENTA
    IF operacion = 2 THEN
        -- Borrado físico del detalle
        DELETE FROM venta_det
        WHERE ven_codigo  = vencodigo
          AND it_codigo   = itcodigo
          AND tipit_codigo= tipitcodigo
          AND dep_codigo  = depcodigo
          AND suc_codigo  = succodigo
          AND emp_codigo  = empcodigo;

        -- Reponer stock (sumar)
        UPDATE stock
        SET st_cantidad = st_cantidad + vendetcantidad
        WHERE it_codigo   = itcodigo
          AND tipit_codigo= tipitcodigo
          AND dep_codigo  = depcodigo
          AND suc_codigo  = succodigo
          AND emp_codigo  = empcodigo;
	
		-- Actualizar auditoria stock
		select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
		and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
		perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usuario_int, usuario_txt);

		-- Enviamos un mensaje de conformacion
        RAISE NOTICE 'LA VENTA DETALLE FUE ELIMINADA CON EXITO';
    END IF;
END;
$function$ LANGUAGE plpgsql;

--Libro venta
CREATE OR REPLACE FUNCTION sp_libro_venta(
    vencodigo            integer,
    libvenexenta         numeric,
    libveniva5           numeric,
    libveniva10          numeric,
    libvennumcomprobante varchar,
    tipcocodigo          integer,
    operacion            integer
) RETURNS void AS
$function$
DECLARE
    factor int := 0;
BEGIN
    -- Definir el factor según la operación
    IF operacion = 1 THEN
        factor := 1;  -- suma
    ELSIF operacion = 2 THEN
        factor := -1; -- resta
    END IF;

    -- Un solo UPDATE usando el factor
    UPDATE libro_venta
    SET libven_exenta = libven_exenta + (libvenexenta * factor),
        libven_iva5   = libven_iva5   + (libveniva5   * factor),
        libven_iva10  = libven_iva10  + (libveniva10  * factor)
    WHERE ven_codigo = vencodigo
      AND libven_numcomprobante = libvennumcomprobante
      AND tipco_codigo = tipcocodigo;
END;
$function$ LANGUAGE plpgsql;

--Cuenta Cobrar
CREATE OR REPLACE FUNCTION sp_cuenta_cobrar(
    vencodigo    integer,
    cuencomonto  numeric,
    cuencosaldo  numeric,
    tipcocodigo  integer,
    operacion    integer
) RETURNS void AS
$function$
DECLARE
    factor int := 0;
BEGIN
    -- Definimos el factor según la operación
    IF operacion = 1 THEN
        factor := 1;   -- suma
    ELSIF operacion = 2 THEN
        factor := -1;  -- resta
    END IF;

    -- Un solo UPDATE usando el factor
    UPDATE cuenta_cobrar
    SET cuenco_monto = cuenco_monto + (cuencomonto * factor),
        cuenco_saldo = cuenco_saldo + (cuencosaldo * factor),
        tipco_codigo = tipcocodigo
    WHERE ven_codigo = vencodigo;
END;
$function$ LANGUAGE plpgsql;

--Cobro Cabecera
CREATE OR REPLACE FUNCTION sp_cobro_cab(
    cobcodigo       integer,
    cobfecha        timestamp,
    cobestado       varchar,
    cobnumerocuota  integer,
    aperciecodigo   integer,
    succodigo       integer,
    empcodigo       integer,
    cajcodigo       integer,
    usucodigo       integer,
    tipcocodigo     integer,
    vencodigo       integer,
    cobnumrecibo    varchar,
    operacion       integer
) RETURNS void AS
$function$
DECLARE
    ventaEstado varchar;
	cobroDet record;
BEGIN 
    -- Inserción de cobro
    IF operacion = 1 THEN
        -- Validar duplicado de número de recibo
        IF EXISTS (SELECT 1 FROM cobro_cab WHERE cob_num_recibo = cobnumrecibo) THEN
            RAISE EXCEPTION 'recibo';
        END IF;

        -- Insertar en cabecera
        INSERT INTO cobro_cab(
            cob_codigo, cob_fecha, cob_estado, cob_numerocuota,
            apercie_codigo, suc_codigo, emp_codigo, caj_codigo, 
            usu_codigo, tipco_codigo, ven_codigo, cob_num_recibo
        )
        VALUES (
            cobcodigo, cobfecha, 'ACTIVO', cobnumerocuota,
            aperciecodigo, succodigo, empcodigo, cajcodigo,
            usucodigo, tipcocodigo, vencodigo, cobnumrecibo
        );

		-- Actualizar número de recibo en tabla timbrados
        UPDATE timbrados
        SET timb_numero_comp = cobnumrecibo::varchar, usu_codigo=usucodigo
        WHERE suc_codigo = succodigo
          AND emp_codigo = empcodigo
          AND caj_codigo = cajcodigo
		  AND tipco_codigo = tipcocodigo;

		-- Enviamos mensaje de confirmacion
        RAISE NOTICE 'EL COBRO FUE REGISTRADO CON EXITO';
    END IF;

    -- Anulación de cobro
    IF operacion = 2 THEN

		-- Validamos que no exista un cobro mayor en estado activo para anular
		IF EXISTS (select 1 from cobro_cab cc where cc.ven_codigo=vencodigo and cc.cob_numerocuota > cobnumerocuota and cc.cob_estado='ACTIVO') THEN
            RAISE EXCEPTION 'cuota';
        END IF;		

        -- Estado de la venta asociada
        SELECT ven_estado
        INTO ventaEstado
        FROM venta_cab
        WHERE ven_codigo = vencodigo;

        -- Anulación lógica
        UPDATE cobro_cab 
        SET cob_estado='ANULADO', usu_codigo=usucodigo
        WHERE cob_codigo=cobcodigo;

        -- Revertir saldos de cuenta_cobrar
        FOR cobroDet IN 
	        SELECT * FROM cobro_det WHERE cob_codigo = cobcodigo 
	    LOOP
	        UPDATE cuenta_cobrar 
	        SET cuenco_saldo = cuenco_saldo + cobroDet.cobdet_monto, 
	            cuenco_estado = 'ACTIVO', 
	            tipco_codigo = 5
	        WHERE ven_codigo = vencodigo;
	    END LOOP;

        -- Restaurar estado de venta si estaba cancelada
        IF ventaEstado = 'CANCELADO' THEN
            UPDATE venta_cab 
            SET ven_estado='ACTIVO', usu_codigo=usucodigo
            WHERE ven_codigo = vencodigo;
        END IF;

		-- Enviamos mensae de confirmacion
        RAISE NOTICE 'EL COBRO FUE ANULADO CON EXITO';
    END IF;
END
$function$
LANGUAGE plpgsql;


--Cobro Detalle
CREATE OR REPLACE FUNCTION sp_cobro_det(
    cobdetcodigo    INTEGER,
    cobcodigo       INTEGER,
    forcocodigo     INTEGER,
    cobdetmonto     NUMERIC,
    cochenumero     VARCHAR,
    entcodigo       INTEGER,
    usucodigo       INTEGER,
    cobtatransaccion VARCHAR,
    redpacodigo     INTEGER,
    vencodigo       INTEGER,
    venmontocuota   NUMERIC,
    operacion       INTEGER
) RETURNS VOID AS
$function$
DECLARE 
    ventaEstado VARCHAR;
	sumatoriaCobro NUMERIC;
BEGIN 
    -- Operación: Inserción
    IF operacion = 1 THEN
		-- Validacion monto cuota menor a sumatoria de cobro_det
		SELECT round((coalesce(sum(cobdet_monto), 0)+cobdetmonto)) INTO sumatoriaCobro FROM cobro_det cd WHERE cd.cob_codigo=cobcodigo;
		IF sumatoriaCobro > venmontocuota THEN
			RAISE EXCEPTION 'monto_superado';
		END IF;
        -- Validación según forma de cobro
        CASE 
            WHEN forcocodigo = 2 THEN  -- Tarjeta
                IF EXISTS (
                    SELECT 1 FROM cobro_tarjeta ct
					JOIN cobro_cab cc ON cc.cob_codigo=ct.cob_codigo
                    WHERE ct.cobta_transaccion = cobtatransaccion 
                      AND ct.redpa_codigo = redpacodigo
					  AND cc.cob_estado = 'ACTIVO'
                ) THEN
                    RAISE EXCEPTION 'tarjeta';
                END IF;

            WHEN forcocodigo = 3 THEN  -- Cheque
                IF EXISTS (
                    SELECT 1 FROM cobro_cheque cc 
					JOIN cobro_cab cc2 ON cc2.cob_codigo=cc.cob_codigo
                    WHERE cc.coche_numero = cochenumero 
                      AND cc.ent_codigo = entcodigo
					  AND cc2.cob_estado = 'ACTIVO'
                ) THEN
                    RAISE EXCEPTION 'cheque';
                END IF;

            WHEN forcocodigo = 1 THEN  -- Efectivo
                IF EXISTS (
                    SELECT 1 FROM cobro_det 
                    WHERE forco_codigo = forcocodigo 
                      AND cob_codigo = cobcodigo 
                ) THEN
                    RAISE EXCEPTION 'efectivo';
                END IF;
        END CASE;

        -- Insertamos detalle de cobro
        INSERT INTO cobro_det(
            cobdet_codigo, 
            cob_codigo, 
            forco_codigo, 	
            cobdet_monto
        )
        VALUES (
            (SELECT COALESCE(MAX(cobdet_codigo),0)+1 FROM cobro_det),  -- Mejor: usar secuencia
            cobcodigo, 
            forcocodigo,
            cobdetmonto
        );

        -- Actualizamos saldo en cuenta cobrar
        UPDATE cuenta_cobrar 
        SET cuenco_saldo = cuenco_saldo - cobdetmonto, 
            tipco_codigo = 5
        WHERE ven_codigo = vencodigo;

		-- Enviamos un mensaje de confirmacion
        RAISE NOTICE 'EL DETALLE DEL COBRO FUE REGISTRADO CON EXITO';
    END IF;

    -- Operación: Eliminación
    IF operacion = 2 THEN 
        -- Estado de la venta
        SELECT ven_estado INTO ventaEstado 
        FROM venta_cab 
        WHERE ven_codigo = vencodigo;

        -- Eliminaciones asociadas
        IF forcocodigo = 2 THEN
            DELETE FROM cobro_tarjeta WHERE cobdet_codigo = cobdetcodigo;
        ELSIF forcocodigo = 3 THEN
            DELETE FROM cobro_cheque WHERE cobdet_codigo = cobdetcodigo;
        END IF;

        -- Eliminamos el detalle
        DELETE FROM cobro_det WHERE cobdet_codigo = cobdetcodigo;

        -- Revertimos saldo en cuenta cobrar
        UPDATE cuenta_cobrar 
        SET cuenco_saldo = cuenco_saldo + cobdetmonto, 
            cuenco_estado = 'ACTIVO',
            tipco_codigo = 5
        WHERE ven_codigo = vencodigo;

        -- Si estaba cancelada, volvemos a activa
        IF ventaEstado = 'CANCELADO' THEN
            UPDATE venta_cab 
            SET ven_estado = 'ACTIVO',
                usu_codigo = usucodigo  
            WHERE ven_codigo = vencodigo;
        END IF;

		-- Enviamos un mensaje de confirmacion
        RAISE NOTICE 'EL DETALLE DEL COBRO FUE ELIMINADO CON EXITO';
    END IF;
END
$function$ 
LANGUAGE plpgsql;

--Cobro Cheque
create or replace function sp_cobro_cheque(
    cochecodigo integer,
    cochenumero varchar,
    cochemonto numeric,
    cochetipocheque tipo_cheque,
    cochefechavencimiento date,
    entcodigo integer,
    cobcodigo integer,
    vencodigo integer,
    cobdetcodigo integer,
    operacion integer
) returns void as
$function$
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
     	--Insertamos registro en cobro cheque
		insert into cobro_cheque(
		coche_codigo, 	
		coche_numero, 
		coche_monto, 
		coche_tipocheque, 
		coche_fechavencimiento,
		ent_codigo, 
		cob_codigo, 
		ven_codigo, 
		cobdet_codigo
		)
		values(
		(select coalesce(max(coche_codigo),0)+1 from cobro_cheque), 
		cochenumero, 
		cochemonto, 
		cochetipocheque, 
		cochefechavencimiento, 
		entcodigo, 
		cobcodigo,
		vencodigo, 
		cobdetcodigo
		);
		end if;
end
$function$ 
language plpgsql;

--Cobro tarjeta
create or replace function sp_cobro_tarjeta(
    cobtacodigo integer,
    cobtanumero varchar,
    cobtamonto numeric,
    cobtatipotarjeta tipo_tarjeta,
    entadcodigo integer,
    entcodigo integer,
    martacodigo integer,
    cobcodigo integer,
    vencodigo integer,
    cobdetcodigo integer,
    cobtatransaccion varchar,
    redpacodigo integer,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
     	--Procedemos con la insercion en cobro tarjeta
		insert into cobro_tarjeta(
		cobta_codigo, 
		cobta_numero, 
		cobta_monto, 
		cobta_tipotarjeta, 
		entad_codigo,
		ent_codigo, 
		marta_codigo, 
		cob_codigo, 
		ven_codigo, 
		cobdet_codigo,
		cobta_transaccion,
		redpa_codigo
		)
		values(
		(select coalesce(max(cobta_codigo),0)+1 from cobro_tarjeta), 
		cobtanumero, 
		cobtamonto, 
		cobtatipotarjeta, 
		entadcodigo, 
		entcodigo, 
		martacodigo,
		cobcodigo, 
		vencodigo, 
		cobdetcodigo,
		cobtatransaccion,
		redpacodigo
		);
    end if;
end
$function$ 
language plpgsql;

--Nota Venta 
create or replace function sp_nota_venta_cab(
    notvencodigo integer,
    notvenfecha date,
    notvennumeronota varchar,
    notvenconcepto varchar,
    notvenestado varchar,
    tipcocodigo integer,
    vencodigo integer,
    succodigo integer,
    empcodigo integer,
    usucodigo integer,
    clicodigo integer,
    operacion integer 
) returns void as
$function$
-- Declaramos las variables a utilizar
declare ultCodLibroVenta integer;
		estadoVenta varchar;
		c_nota_venta_det cursor is
		select 
		it_codigo,
		tipit_codigo,
		dep_codigo,
		suc_codigo,
		emp_codigo,
		notvendet_cantidad 
		from nota_venta_det
		where notven_codigo=notvencodigo;
		totalSuma numeric;
begin 
	 -- Validamos si la operacion es de insercion
     if operacion = 1 then
		ultCodLibroVenta = (select coalesce(max(libven_codigo),0)+1 from libro_venta);
		--Validamos que no se repita el numero de nota
     	perform * from nota_venta_cab
     	where notven_numeronota=notvennumeronota and notvenestado='ACTIVO';
     	if found then
			 -- En caso de que si, generamos una excepcion
     		 raise exception 'nota';
		-- En caso de no generar excepciones procedemos con la insercion
     	elseif operacion = 1 then
	     insert into nota_venta_cab(
		 notven_codigo, 
		 notven_fecha, 
		 notven_numeronota, 
		 notven_concepto, 
	     notven_estado, 
		 tipco_codigo, 
		 ven_codigo, 
		 suc_codigo, 
		 emp_codigo, 
		 usu_codigo, 
		 cli_codigo
		 )
		 values(
		 notvencodigo, 
		 notvenfecha, 
		 notvennumeronota, 
		 upper(notvenconcepto), 
		 'ACTIVO', 
		 tipcocodigo, 
		 vencodigo, 
		 succodigo, 
		 empcodigo, 
		 usucodigo, 
		 clicodigo
		 );
		 -- Cargamos Libro venta dependiendo del tipo de comprobante
		 if tipcocodigo in(1,2) then
			 insert into libro_venta(
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
			 values(
			 ultCodLibroVenta, 
			 ven_codigo, 
			 0, 
			 0, 
			 0, 
			 notvenfecha, 
			 notvennumeronota, 
			 'ACTIVO', 
			 tipcocodigo
			);
		 end if;
		 -- Generamos un mensaje al terminar la insercion
		 raise notice 'LA NOTA DE VENTA FUE REGISTRADA CON EXITO';
		end if;
    end if;
	-- Validamos si la operacion es de anulacion
    if operacion = 2 then 
		-- Actualizamos el estado de nota venta
    	update nota_venta_cab 
		set notven_estado='ANULADO', usu_codigo=usucodigo
		where notven_codigo=notvencodigo;
		-- Si la nota es de credito 
		if tipcocodigo = 1 then
			-- Actualizamos estado de libro venta
			update libro_venta
			set libven_estado='ANULADO'
			where ven_codigo=vencodigo
			and libven_numcomprobante=nocomnumeronota
			and tipco_codigo=tipcocodigo;
			-- Volvemos stock a como estaba
			for nota in c_nota_venta_det loop
				update stock set st_cantidad=st_cantidad-nota.notvendet_cantidad 
				where it_codigo=nota.it_codigo 
				and tipit_codigo=nota.tipit_codigo 
				and dep_codigo=nota.dep_codigo
				and suc_codigo=nota.suc_codigo 
				and emp_codigo=nota.emp_codigo;
			end loop;
			-- Guardamos la sumatoria del detalle de nota venta en una variable
			totalSuma := (select coalesce(sum((case nvd.tipit_codigo when 3 then nvd.notvendet_precio else nvd.notvendet_cantidad*nvd.notvendet_precio end)), 0) total
			from nota_venta_det nvd where nvd.notven_codigo=notvencodigo);
			-- Consultamos el estado de venta cabecera
			estadoVenta := (select vc.ven_estado from venta_cab vc where vc.ven_codigo=vencodigo);
			-- Validamos que el monto del detalle sea mayor a cero
			if totalSuma > 0 then
				-- Actualizamos el monto de cuenta cobrar con lo restado en el detalle
				update cuenta_cobrar 
			 	set cuenco_monto=cuenco_monto+totalSuma, 
			 	 	cuenco_saldo=cuenco_saldo+totalSuma,
					cuenco_estado='ACTIVO',
				 	tipco_codigo=tipcocodigo
			 	where ven_codigo=vencodigo;
				-- Validamos el estado de venta
				if estadoVenta = 'ANULADO' then
					-- En caso de estar anulado procedemos con su actualizacion
					update venta_cab set ven_estado='ACTIVO', usu_codigo=usucodigo where ven_codigo=vencodigo; 
				end if;
		end if;
		-- Si la nota es de debito
		elseif tipcocodigo = 2 then
			-- Actualizamos estado de libro venta
			update libro_venta
			set libven_estado='ANULADO'
			where ven_codigo=vencodigo
			and libven_numcomprobante=nocomnumeronota
			and tipco_codigo=tipcocodigo;
			-- Volvemos stock a como estaba
			for nota in c_nota_venta_det loop
				update stock set st_cantidad=st_cantidad+nota.notvendet_cantidad 
				where it_codigo=nota.it_codigo 
				and tipit_codigo=nota.tipit_codigo 
				and dep_codigo=nota.dep_codigo
				and suc_codigo=nota.suc_codigo 
				and emp_codigo=nota.emp_codigo;
			end loop;
			-- Guardamos la sumatoria del detalle de nota venta en una variable
			totalSuma := (select coalesce(sum((case nvd.tipit_codigo when 3 then nvd.notvendet_precio else nvd.notvendet_cantidad*nvd.notvendet_precio end)), 0) total
			from nota_venta_det nvd where nvd.notven_codigo=notvencodigo);
			-- Validamos que el monto del detalle sea mayor a cero
			if totalSuma > 0 then
				-- Actualizamos el monto de cuenta cobrar con lo sumado en el detalle
				update cuenta_cobrar 
			 	set cuenco_monto=cuenco_monto-totalSuma, 
			 	 	cuenco_saldo=cuenco_saldo-totalSuma,
					cuenco_estado='ACTIVO',
				 	tipco_codigo=tipcocodigo
			 	where ven_codigo=vencodigo;
			end if;
		end if;
		-- Generamos un mensaje al terminar la insercion
		raise notice 'LA NOTA DE VENTA FUE ANULADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Nota Venta Detalle
create or replace function sp_nota_venta_det(
    notvencodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    notvendetcantidad integer,
    notvendetprecio numeric,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    tipcocodigo integer,
    vencodigo integer, 
    libvennumcomprobante varchar,
    tipimcodigo integer,
    usucodigo integer,
    operacion integer
) returns void as
$function$
-- Declaramos las variables a utilizar
declare monto numeric;
		montoIva5 numeric := 0;
		montoIva10 numeric := 0;
		montoIvaExenta numeric := 0;
		montoCuenta numeric := 0;
	    ventaEstado varchar;
begin 
	 -- Validamos si la operacion es de insercion
     if operacion = 1 then
		-- Validamos que no se repita el item en el detalle
     	perform * from nota_venta_det
     	where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		and suc_codigo=succodigo and emp_codigo=empcodigo and notven_codigo=notvencodigo;
     	if found then
			 -- En caso de repetirse un item, generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
			 -- Insertamos un registro en nota venta detalle, independientemente del tipo de comprobante
		     insert into nota_venta_det(
				 notven_codigo, 
				 it_codigo, 
				 tipit_codigo, 
				 notvendet_cantidad, 
				 notvendet_precio,
				 dep_codigo,
				 suc_codigo,
				 emp_codigo
			 )
			 values(
				 notvencodigo, 
				 itcodigo, 
				 tipitcodigo, 
				 notvendetcantidad, 
				 notvendetprecio,
				 depcodigo,
				 succodigo,
				 empcodigo);
			 -- Actualizamos registro en cuenta cobrar, libro venta y stock, solo en caso de ser una nota de credito o debito
			 if tipcocodigo in(1,2) then
			     -- Actualizamos la cantidad de item en stock
			 	 update stock
				 set st_cantidad = case when tipcocodigo = 1 then st_cantidad + notvendetcantidad else st_cantidad - notvendetcantidad end 
				 where it_codigo = itcodigo
				 and tipit_codigo = tipitcodigo
				 and dep_codigo = depcodigo
				 and suc_codigo = succodigo
				 and emp_codigo = empcodigo;
				 --Definicion de monto para cuenta cobrar
				 if tipcocodigo = 1 then
					-- Si el tipo de comprobante es credito, multiplicamos cantidad por precio y lo convertimos en negativo
				 	monto := (notvendetcantidad*notvendetprecio)*-1; 
				 else
					-- Si no es credito es debito, por ende multiplicamos cantidad por precio y lo dejamos en positivo
					monto := (notvendetcantidad*notvendetprecio); 
				 end if;
				 -- Para repartir el valor en libro venta, validamos el tipo de impuesto
				 if tipimcodigo = 1 then -- Iva 5%
					montoIva5 := monto;
				 elseif tipimcodigo = 2 then -- Iva 10% 
					montoIva10 := monto;
				 else -- Iva exenta
					montoIvaExenta := monto;
				 end if;
				 -- Llamamos al sp de cuenta cobrar y libro venta y le pasamos los parametros necesarios para ejecutarse
				 -- Cuenta Cobrar
				 perform sp_cuenta_cobrar(vencodigo, monto, monto, tipcocodigo, operacion);
				 -- Libro Venta
				 perform sp_libro_venta(vencodigo, montoIvaExenta, montoIva5, montoIva10, libvennumcomprobante, tipcocodigo, operacion);
				 -- Validamos el tipo de comprobante para actualizar o no los estados
				 if tipcocodigo = 1 then 
					--En caso de ser una nota de credito, consultamos el monto de cuenta cobrar
					select cc.cuenco_monto into montoCuenta from cuenta_cobrar cc where cc.ven_codigo=vencodigo;
					-- Validamos el monto de cuena cobrar
					if montoCuenta = 0 then 
						-- En caso de ser 0, procedemos con la actualizacion de estado a anulado
						-- Cuenta cobrar
						update cuenta_cobrar set cuenco_estado='ANULADO' where ven_codigo=vencodigo;
						-- Venta cabecera
						update venta_cab set ven_estado='ANULADO', usu_codigo=usucodigo  where ven_codigo=vencodigo;
					end if;
				 end if;
			 end if;
			 -- Enviamos un mensaje de confirmacion de insercion
			 raise notice 'LA NOTA DE VENTA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	-- Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		-- Procedemos con la eliminacion del registro en este caso una eliminacion fisica
    	delete from nota_venta_det 
    	where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		and suc_codigo=succodigo and emp_codigo=empcodigo and notven_codigo=notvencodigo;
		-- Actualizamos registro en cuenta cobrar, libro venta y stock, solo en caso de ser una nota de credito o debito
		if tipcocodigo in(1,2) then
			-- Actualizamos la cantidad de item en stock
			update stock
			set st_cantidad = case when tipcocodigo = 1 then st_cantidad - notvendetcantidad else st_cantidad + notvendetcantidad end 
			where it_codigo = itcodigo
			and tipit_codigo = tipitcodigo
			and dep_codigo = depcodigo
			and suc_codigo = succodigo
			and emp_codigo = empcodigo;
			--Definicion de monto para cuenta cobrar
			if tipcocodigo = 1 then
				-- Si el tipo de comprobante es credito, multiplicamos cantidad por precio y lo convertimos en negativo
				 monto := (notvendetcantidad*notvendetprecio)*-1; 
			else
				-- Si no es credito es debito, por ende multiplicamos cantidad por precio y lo dejamos en positivo
				monto := (notvendetcantidad*notvendetprecio); 
			end if;
			-- Para repartir el valor en libro venta, validamos el tipo de impuesto
			if tipimcodigo = 1 then -- Iva 5%
				montoIva5 := monto;
			elseif tipimcodigo = 2 then -- Iva 10% gugu
				montoIva10 := monto;
			else -- Iva exenta
				montoIvaExenta := monto;
			end if;
			-- Llamamos al sp de cuenta cobrar y libro venta y le pasamos los parametros necesarios para ejecutarse
			-- Cuenta Cobrar
			perform sp_cuenta_cobrar(vencodigo, monto, monto, tipcocodigo, operacion);
			-- Libro Venta
			perform sp_libro_venta(vencodigo, montoIvaExenta, montoIva5, montoIva10, libvennumcomprobante, tipcocodigo, operacion);
			-- Validamos el tipo de comprobante para actualizar o no los estados
			if tipcocodigo = 1 then 
				--En caso de ser una nota de credito, consultamos el monto de cuenta cobrar y el estado de venta cabecera
				select cc.cuenco_monto into montoCuenta from cuenta_cobrar cc where cc.ven_codigo=vencodigo;
				select ven_estado into ventaEstado from venta_cab where ven_codigo=vencodigo;
				-- Validamos el monto de cuena cobrar
				if montoCuenta > 0 and ventaEstado = 'ANULADO' then 
					-- En caso de ser mayor a 0 y tener el estado de venta en anulado, procedemos con la actualizacion de estado a activo
					-- Cuenta cobrar
					update cuenta_cobrar set cuenco_estado='ACTIVO' where ven_codigo=vencodigo;
					-- Venta cabecera
					update venta_cab set ven_estado='ACTIVO', usu_codigo=usucodigo  where ven_codigo=vencodigo;
				end if;
			end if;
		end if;
		-- Enviamos un mensaje de confirmacion de eliminacion
		raise notice 'LA NOTA DE VENTA DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

