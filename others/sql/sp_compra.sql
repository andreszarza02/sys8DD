--Procedimientos almacenados
--Ciudad
create or replace function sp_ciudad(
    ciucodigo integer,
    ciudescripcion varchar,
    ciuestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare ciuAudit text;
begin 
    if operacion in(1,2) then
        perform * from ciudad
        where upper(ciu_descripcion) = upper(ciudescripcion)
        and ciu_codigo != ciucodigo;
        if found then
            raise exception 'descripcion';
    	elseif operacion = 1 then
	        	insert into ciudad(ciu_codigo, ciu_descripcion, ciu_estado)
				values(ciucodigo, upper(ciudescripcion), 'ACTIVO');
				raise notice 'LA CIUDAD FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update ciudad
				set ciu_descripcion=upper(ciudescripcion), ciu_estado='ACTIVO'
				where ciu_codigo=ciucodigo;
				raise notice 'LA CIUDAD FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update ciudad
		set ciu_estado='INACTIVO'
		where ciu_codigo=ciucodigo;
		raise notice 'LA CIUDAD FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(ciu_audit, '') into ciuAudit from ciudad where ciu_codigo = ciucodigo;
	--a los datos anteriores le agragamos los nuevos
	update ciudad 
	set ciu_audit = ciuAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'ciu_descripcion', upper(ciudescripcion),
		'ciu_estado', upper(ciuestado)
	)||','
	where ciu_codigo = ciucodigo;
end
$function$ 
language plpgsql;

--Empresa
create or replace function sp_empresa(
    empcodigo integer,
    emptelefono varchar,
    emprazonsocial varchar,
    empruc varchar,
    emptimbrado varchar,
    emptimbradofecinic date,
    emptimbradofecvenc date,
    empemail varchar,
    empactividad varchar,
    empestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Definimos las variables
declare empAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que la fecha de vencimiento del timbrado no sea menor a la fecha de inicio
		if emptimbradofecvenc <= emptimbradofecinic then
			-- En caso de ser asi, generamos una excepcion
     	 	raise exception 'fecha';
     	 end if;
		-- Validamos que no se repita el ruc de la empresa
        perform * from empresa
        where emp_ruc = empruc and emp_codigo != empcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'ruc';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into empresa(emp_codigo, emp_telefono, emp_razonsocial, emp_ruc, emp_email, emp_actividad, emp_estado, emp_timbrado, 
				emp_timbrado_fec_inic, emp_timbrado_fec_venc)
				values(empcodigo, emptelefono, upper(emprazonsocial), empruc, empemail, upper(empactividad), 'ACTIVO', emptimbrado, 
				emptimbradofecinic, emptimbradofecvenc);
				raise notice 'LA EMPRESA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update empresa
				set emp_telefono=emptelefono, emp_razonsocial=upper(emprazonsocial), emp_ruc=empruc,
				emp_email=empemail, emp_actividad=upper(empactividad), emp_estado='ACTIVO', emp_timbrado=emptimbrado,
				emp_timbrado_fec_inic=emptimbradofecinic, emp_timbrado_fec_venc=emptimbradofecvenc 
				where emp_codigo=empcodigo;
				raise notice 'LA EMPRESA FUE MODIFICADA CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de elimianacion (borrado logíco)
    if operacion = 3 then 
    	update empresa
		set emp_estado='INACTIVO'
		where emp_codigo=empcodigo;
		raise notice 'LA EMPRESA FUE BORRADA CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(emp_audit, '') into empAudit from empresa where emp_codigo = empcodigo;
	-- A los datos anteriores le agragamos los nuevos
	update empresa 
	set emp_audit = empAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'emp_telefono', emptelefono,
		'emp_razonsocial', upper(emprazonsocial),
		'emp_ruc', empruc,
		'emp_timbrado', emptimbrado,
		'emp_timbrado_fec_inic', emptimbradofecinic,
		'emp_timbrado_fec_venc', emptimbradofecvenc,
		'emp_email', empemail,
		'emp_actividad', upper(empactividad),
		'emp_estado', upper(empestado)
	)||','
	where emp_codigo = empcodigo;
end
$function$ 
language plpgsql;

--Sucursal
create or replace function sp_sucursal(
    succodigo integer,
    empcodigo integer,
    sucdescripcion varchar,
    sucdireccion varchar,
    suctelefono varchar,
    sucestado varchar,
    ciucodigo integer,
    sucemail varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    ciudescripcion varchar,
    emprazonsocial varchar
) returns void as
$function$
-- Definimos las variables
declare sucAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita la descripcion de la sucursal
        perform * from sucursal
        where (emp_codigo=empcodigo and upper(suc_descripcion)=upper(sucdescripcion))
        and suc_codigo != succodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into sucursal(suc_codigo, emp_codigo, suc_descripcion, suc_direccion, suc_telefono,
	        	suc_estado, ciu_codigo, suc_email)
				values(succodigo, empcodigo, upper(sucdescripcion),
				upper(sucdireccion), suctelefono, 'ACTIVO', ciucodigo, sucemail);
				raise notice 'LA SUCURSAL FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update sucursal
				set emp_codigo=empcodigo, suc_descripcion=upper(sucdescripcion), 
				suc_direccion=upper(sucdireccion), suc_telefono=suctelefono, suc_estado='ACTIVO',
				ciu_codigo=ciucodigo, suc_email=sucemail
				where suc_codigo=succodigo;
				raise notice 'LA SUCURSAL FUE MODIFICADA CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de elimianacion (borrado logíco)
    if operacion = 3 then 
    	update sucursal 
		set suc_estado='INACTIVO'
		where suc_codigo=succodigo;
		raise notice 'LA SUCURSAL FUE BORRADA CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(suc_audit, '') into sucAudit from sucursal where suc_codigo = succodigo;
	-- A los datos anteriores le agragamos los nuevos
	update sucursal 
	set suc_audit = sucAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'suc_descripcion', upper(sucdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'ciu_codigo', ciucodigo,
		'ciu_descripcion', upper(ciudescripcion),
		'suc_direccion', upper(sucdireccion),
		'suc_telefono', suctelefono,
		'suc_email', sucemail,
		'suc_estado', upper(sucestado)
	)||','
	where suc_codigo = succodigo;
end
$function$ 
language plpgsql;

--Tipo Impuesto
create or replace function sp_tipo_impuesto(
    tipimcodigo integer,
    tipimdescripcion varchar,
    tipimestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Definimos las variables
declare tipimAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		  -- Validamos que no se repita la descripcion del tipo de impuesto
        perform * from tipo_impuesto
        where upper(tipim_descripcion) = upper(tipimdescripcion)
        and tipim_codigo != tipimcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into tipo_impuesto(tipim_codigo, tipim_descripcion, tipim_estado)
				values(tipimcodigo, upper(tipimdescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE IMPUESTO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update tipo_impuesto
				set tipim_descripcion=upper(tipimdescripcion), tipim_estado='ACTIVO'
				where tipim_codigo=tipimcodigo;
				raise notice 'EL TIPO DE IMPUESTO FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de elimianacion (borrado logíco)
    if operacion = 3 then 
    	update tipo_impuesto
		set tipim_estado='INACTIVO'
		where tipim_codigo=tipimcodigo;
		raise notice 'EL TIPO DE IMPUESTO FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(tipim_audit, '') into tipimAudit from tipo_impuesto where tipim_codigo = tipimcodigo;
	-- A los datos anteriores le agregamos los nuevos
	update tipo_impuesto 
	set tipim_audit = tipimAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tipim_descripcion', upper(tipimdescripcion),
		'tipim_estado', upper(tipimestado)
	)||','
	where tipim_codigo = tipimcodigo;
end
$function$ 
language plpgsql;

--Tipo Proveedor
create or replace function sp_tipo_proveedor(
    tiprocodigo integer,
    tiprodescripcion varchar,
    tiproestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Definimos las variables
declare tiproAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita la descripcion del tipo de proveedor
        perform * from tipo_proveedor
        where upper(tipro_descripcion) = upper(tiprodescripcion)
        and tipro_codigo != tiprocodigo;
        if found then
			   -- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into tipo_proveedor(tipro_codigo, tipro_descripcion, tipro_estado)
				values(tiprocodigo, upper(tiprodescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE PROVEEDOR FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update tipo_proveedor
				set tipro_descripcion=upper(tiprodescripcion), tipro_estado='ACTIVO'
				where tipro_codigo=tiprocodigo;
				raise notice 'EL TIPO DE PROVEEDOR FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update tipo_proveedor
		set tipro_estado='INACTIVO'
		where tipro_codigo=tiprocodigo;
		raise notice 'EL TIPO DE PROVEEDOR FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(tipro_audit, '') into tiproAudit from tipo_proveedor where tipro_codigo = tiprocodigo;
	-- A los datos anteriores le agregamos los nuevos
	update tipo_proveedor 
	set tipro_audit = tiproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tipro_descripcion', upper(tiprodescripcion),
		'tipro_estado', upper(tiproestado)
	)||','
	where tipro_codigo = tiprocodigo;
end
$function$ 
language plpgsql;

--Tipo Item
create or replace function sp_tipo_item(
    tipitcodigo integer,
    tipitdescripcion varchar,
    tipitestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Definimos las variables
declare tipitAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita la descripcion del tipo de item
        perform * from tipo_item
        where upper(tipit_descripcion) = upper(tipitdescripcion)
        and tipit_codigo != tipitcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into tipo_item(tipit_codigo, tipit_descripcion, tipit_estado)
				values(tipitcodigo, upper(tipitdescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE ITEM FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update tipo_item
				set tipit_descripcion=upper(tipitdescripcion), tipit_estado='ACTIVO'
				where tipit_codigo=tipitcodigo;
				raise notice 'EL TIPO DE ITEM FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update tipo_item
		set tipit_estado='INACTIVO'
		where tipit_codigo=tipitcodigo;
		raise notice 'EL TIPO DE ITEM FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(tipit_audit, '') into tipitAudit from tipo_item where tipit_codigo = tipitcodigo;
	-- A los datos anteriores le agregamos los nuevos
	update tipo_item 
	set tipit_audit = tipitAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tipit_descripcion', upper(tipitdescripcion),
		'tipit_estado', upper(tipitestado)
	)||','
	where tipit_codigo = tipitcodigo;
end
$function$ 
language plpgsql;

--Proveedor
create or replace function sp_proveedor(
    procodigo integer,
    tiprocodigo integer,
    prorazonsocial varchar,
    proruc varchar,
    protimbrado varchar,
    protimbradovenc date,
    prodireccion varchar,
    protelefono varchar,
    proemail varchar,
    proestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    tiprodescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare proAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita el ruc de ningun proveedor
        perform * from proveedor
        where (pro_ruc = proruc or pro_razonsocial = upper(prorazonsocial)) and pro_codigo != procodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'ruc';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into proveedor(pro_codigo, tipro_codigo, pro_razonsocial, pro_ruc, pro_direccion, pro_telefono, 
	        	pro_email, pro_estado, pro_timbrado, pro_timbrado_venc)
				values(procodigo, tiprocodigo, upper(prorazonsocial), proruc, upper(prodireccion), protelefono, proemail, 'ACTIVO', protimbrado, protimbradovenc);
				raise notice 'EL PROVEEDOR FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update proveedor
				set tipro_codigo=tiprocodigo, pro_razonsocial=upper(prorazonsocial), pro_ruc=proruc,
				pro_direccion=upper(prodireccion), pro_telefono=protelefono, pro_email=proemail, pro_estado='ACTIVO',
				pro_timbrado=protimbrado, pro_timbrado_venc=protimbradovenc
				where pro_codigo=procodigo;
				raise notice 'EL PROVEEDOR FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update proveedor
		set pro_estado='INACTIVO'
		where pro_codigo=procodigo;
		raise notice 'EL PROVEEDOR FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(pro_audit, '') into proAudit from proveedor where pro_codigo = procodigo;
	-- A los datos anteriores le agregamos los nuevos
	update proveedor 
	set pro_audit = proAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'pro_razonsocial', upper(prorazonsocial),
		'tipro_codigo', tiprocodigo,
		'tipro_descripcion', upper(tiprodescripcion),
		'pro_ruc', proruc,
		'pro_timbrado', protimbrado,
		'pro_timbrado_venc', protimbradovenc,
		'pro_direccion', upper(prodireccion),
		'pro_telefono', protelefono,
		'pro_email', proemail,
		'pro_estado', upper(proestado)
	)||','
	where pro_codigo = procodigo;
end
$function$ 
language plpgsql;

--Deposito
create or replace function sp_deposito(
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    depdescripcion varchar,
    depestado varchar,
    ciucodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    ciudescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar--1:insert 2:update 3:delete
) returns void as
$function$
-- Definimos las variables
declare depAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
	    -- Validamos que no se repita la descripcion del deposito con la empresa y sucursal
        perform * from deposito
        where (upper(dep_descripcion)=upper(depdescripcion) and emp_codigo=empcodigo and suc_codigo=succodigo)
        and dep_codigo != depcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into deposito(dep_codigo, suc_codigo, emp_codigo, dep_descripcion, dep_estado, ciu_codigo)
				values(depcodigo, succodigo, empcodigo, upper(depdescripcion), 'ACTIVO', ciucodigo);
				raise notice 'EL DEPOSITO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update deposito
				set suc_codigo=succodigo, emp_codigo=empcodigo, 
				dep_descripcion=upper(depdescripcion), dep_estado='ACTIVO',
				ciu_codigo=ciucodigo
				where dep_codigo=depcodigo;
				raise notice 'EL DEPOSITO FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update deposito 
		set dep_estado='INACTIVO'
		where dep_codigo=depcodigo;
		raise notice 'EL DEPOSITO FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(dep_audit, '') into depAudit from deposito where dep_codigo = depcodigo;
	-- A los datos anteriores le agregamos los nuevos
	update deposito 
	set dep_audit = depAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'dep_descripcion', upper(depdescripcion),
		'ciu_codigo', ciucodigo,
		'ciu_descripcion', upper(ciudescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'dep_estado', upper(depestado)
	)||','
	where dep_codigo = depcodigo;
end
$function$ 
language plpgsql;

--Items
create or replace function sp_items(
    itcodigo integer,
    tipitcodigo integer,
    itdescripcion varchar,
    itcosto numeric,
    itprecio numeric,
    itestado varchar,
    modcodigo integer,
    tallcodigo integer,
    tipimcodigo integer,
    unimecodigo integer,
    itstockmin numeric,
    itstockmax numeric,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    tipitdescripcion varchar,
    tipimdescripcion varchar,
    modcodigomodelo varchar,
    talldescripcion varchar,
    unimedescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare itAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion y el tipo de item producto
	if operacion in(1,2) and tipitcodigo=2 then
		-- Validamos que no se repita la descripcion y otros datos del item producto
		perform * from items
        where upper(it_descripcion)=upper(itdescripcion) and tipit_codigo=tipitcodigo and mod_codigo=modcodigo
        and tall_codigo=tallcodigo and tipim_codigo=tipimcodigo and unime_codigo=unimecodigo and it_codigo != itcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into items(
	        	it_codigo, 
	        	tipit_codigo, 
	        	it_descripcion, 
	        	it_costo, 
	        	it_precio,
	        	it_estado,
	        	mod_codigo,
	        	tall_codigo,
	        	tipim_codigo,
				unime_codigo,
				it_stock_min,
				it_stock_max)
				values(itcodigo, tipitcodigo, upper(itdescripcion), itcosto, itprecio, 'ACTIVO', modcodigo,
				tallcodigo, tipimcodigo, unimecodigo, itstockmin, itstockmax);
				raise notice 'EL ITEM FUE REGISTRADO CON EXITO';
		elseif operacion = 2 then
				update items
				set tipit_codigo=tipitcodigo, 
				it_descripcion=upper(itdescripcion), 
				it_costo=itcosto, it_precio=itprecio,
				it_estado='ACTIVO', mod_codigo=modcodigo,
				tall_codigo=tallcodigo, tipim_codigo=tipimcodigo,
				unime_codigo=unimecodigo, it_stock_min=itstockmin,
				it_stock_max=itstockmax
				where it_codigo=itcodigo;
				raise notice 'EL ITEM FUE MODIFICADO CON EXITO';
        end if;
	end if;
	-- Validamos la operacion de insercion o modificacion y que el tipo de item no sea producto
    if operacion in(1,2) and tipitcodigo<>2 then
		-- Validamos que no se repita la descripcion del items
        perform * from items
        where upper(it_descripcion)=upper(itdescripcion) and it_codigo != itcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into items(
	        	it_codigo, 
	        	tipit_codigo, 
	        	it_descripcion, 
	        	it_costo, 
	        	it_precio,
	        	it_estado,
	        	mod_codigo,
	        	tall_codigo,
	        	tipim_codigo,
				unime_codigo,
				it_stock_min,
				it_stock_max)
				values(itcodigo, tipitcodigo, upper(itdescripcion), itcosto, itprecio, 'ACTIVO', modcodigo,
				tallcodigo, tipimcodigo, unimecodigo, itstockmin, itstockmax);
				raise notice 'EL ITEM FUE REGISTRADO CON EXITO';
		elseif operacion = 2 then
				update items
				set tipit_codigo=tipitcodigo, 
				it_descripcion=upper(itdescripcion), 
				it_costo=itcosto, it_precio=itprecio,
				it_estado='ACTIVO', mod_codigo=modcodigo,
				tall_codigo=tallcodigo, tipim_codigo=tipimcodigo,
				unime_codigo=unimecodigo, it_stock_min=itstockmin,
				it_stock_max=itstockmax
				where it_codigo=itcodigo;
				raise notice 'EL ITEM FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update items 
		set it_estado='INACTIVO'
		where it_codigo=itcodigo;
		raise notice 'EL ITEM FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(it_audit, '') into itAudit from items where it_codigo = itcodigo;
	-- A los datos anteriores le agregamos los nuevos
	update items 
	set it_audit = itAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'it_descripcion', upper(itdescripcion),
		'tipit_codigo', tipitcodigo,
		'tipit_descripcion', upper(tipitdescripcion),
		'tipim_codigo', tipimcodigo,
		'tipim_descripcion', upper(tipimdescripcion),
		'it_costo', itcosto,
		'it_precio', itprecio,
		'mod_codigo', modcodigo,
		'mod_codigomodelo', modcodigomodelo,
		'tall_codigo', tallcodigo,
		'tall_descripcion', talldescripcion,
		'unime_codigo', unimecodigo,
		'unime_descripcion', upper(unimedescripcion),
		'it_stock_min', itstockmin,
		'it_stock_max', itstockmax,
		'it_estado', upper(itestado)
	)||','
	where it_codigo = itcodigo;
end
$function$ 
language plpgsql;

--Pedido Compra Cabecera
create or replace function sp_pedido_compra_cab(
    pedcocodigo integer,
    pedcofecha date,
    pedcoestado varchar,
    succodigo integer,
    empcodigo integer,
    usucodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare pedcoAudit text;
begin 
     if operacion = 1 then
	     insert into pedido_compra_cab(pedco_codigo, pedco_fecha, pedco_estado, suc_codigo, emp_codigo, usu_codigo)
		 values(pedcocodigo, pedcofecha, 'PENDIENTE', succodigo, empcodigo, usucodigo);
		 raise notice 'EL PEDIDO DE COMPRA FUE REGISTRADO CON EXITO';
    end if;
    if operacion = 2 then 
    	update pedido_compra_cab 
		set pedco_estado='ANULADO', usu_codigo=usucodigo
		where pedco_codigo=pedcocodigo;
		raise notice 'EL PEDIDO DE COMPRA FUE ANULADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(pedco_audit, '') into pedcoAudit from pedido_compra_cab where pedco_codigo = pedcocodigo;
	--a los datos anteriores le agregamos los nuevos
	update pedido_compra_cab 
	set pedco_audit = pedcoAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'pedco_estado', upper(pedcoestado)
	)||','
	where pedco_codigo = pedcocodigo;
end
$function$ 
language plpgsql;

--Pedido Compra Detalle
create or replace function sp_pedido_compra_det(
    pedcocodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    pedcodetcantidad numeric,
    pedcodetprecio numeric,
    operacion integer --1:insert 2:delete
) returns void as
$function$
begin 
     if operacion = 1 then
     	perform * from pedido_compra_det
     	where it_codigo=itcodigo and pedco_codigo=pedcocodigo;
     	if found then
     		 raise exception 'item repetido';
     	elseif operacion = 1 then
		     insert into pedido_compra_det(pedco_codigo, it_codigo, tipit_codigo, pedcodet_cantidad, pedcodet_precio)
			 values(pedcocodigo, itcodigo, tipitcodigo, pedcodetcantidad, pedcodetprecio);
			 raise notice 'EL PEDIDO DE COMPRA DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
    	delete from pedido_compra_det 
    	where pedco_codigo=pedcocodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'EL PEDIDO DE COMPRA DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Presupuesto Proveedor Cabecera
create or replace function sp_presupuesto_proveedor_cab(
    preprocodigo integer,
    preprofechaactual date,
    preproestado varchar,
    preprofechavencimiento date,
    usucodigo integer,
    procodigo integer,
    tiprocodigo integer,
    succodigo integer,
    empcodigo integer,
    pedcocodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    proruc varchar,
    prorazonsocial varchar, 
    emprazonsocial varchar,
    sucdescripcion varchar,
    tiprodescripcion varchar
) returns void as
$function$
declare ultCodPedidoPresupuesto integer;
declare preproAudit text;
begin 
     if operacion = 1 then
	 	 ultCodPedidoPresupuesto = (select coalesce(max(pedpre_codigo),0)+1 from pedido_presupuesto);
     	 if preprofechaactual > preprofechavencimiento then
     	 	raise exception '1';
     	 end if;
		 perform 
			ppc.prepro_codigo,
			pp.pedco_codigo,
			ppc.pro_codigo
		from presupuesto_proveedor_cab ppc 
			join pedido_presupuesto pp on pp.prepro_codigo = ppc.prepro_codigo
		where pp.pedco_codigo = pedcocodigo 
			and ppc.pro_codigo = procodigo 
			and ppc.prepro_codigo != preprocodigo;
     	 if found then
     		 raise exception '2';
     	 elseif operacion = 1 then
		     insert into presupuesto_proveedor_cab(prepro_codigo, prepro_fechaactual, prepro_estado, prepro_fechavencimiento, usu_codigo,
		     pro_codigo, tipro_codigo, suc_codigo, emp_codigo)
			 values(preprocodigo, preprofechaactual, 'ACTIVO', preprofechavencimiento, usucodigo, procodigo, tiprocodigo,
			 succodigo, empcodigo);
			 insert into pedido_presupuesto(pedco_codigo, prepro_codigo, pedpre_codigo)
			 values(pedcocodigo, preprocodigo, ultCodPedidoPresupuesto);
			 --Cargamos la columna de auditoria de pedido presupuesto
			 update pedido_presupuesto 
			 set pedpre_audit = json_build_object(
				'usu_codigo', usucodigo,
				'usu_login', usulogin,
				'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
				'procedimiento', 'ALTA',
				'pedco_codigo', pedcocodigo,
				'prepro_codigo', preprocodigo
			 )
			 where pedpre_codigo = ultCodPedidoPresupuesto;
			 raise notice 'EL PRESUPUESTO DEL PROVEEDOR FUE REGISTRADO CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
    	update presupuesto_proveedor_cab 
		set prepro_estado='ANULADO', usu_codigo=usucodigo
		where prepro_codigo=preprocodigo;
		raise notice 'EL PRESUPUESTO DEL PROVEEDOR FUE ANULADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(prepro_audit, '') into preproAudit from presupuesto_proveedor_cab where prepro_codigo = preprocodigo;
	--a los datos anteriores le agregamos los nuevos
	update presupuesto_proveedor_cab 
	set prepro_audit = preproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'prepro_fechaactual', preprofechaactual,
		'prepro_fechavencimiento', preprofechavencimiento,
		'pro_codigo', procodigo,
		'pro_ruc', upper(proruc),
		'pro_razonsocial', upper(prorazonsocial),
		'tipro_codigo', tiprocodigo,
		'tipro_descripcion', upper(tiprodescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'prepro_estado', upper(preproestado)
	)||','
	where prepro_codigo = preprocodigo;
end
$function$ 
language plpgsql;

--Presupuesto Proveedor Detalle
create or replace function sp_presupuesto_proveedor_det(
    preprocodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    peprodetcantidad numeric,
    peprodetprecio numeric,
    operacion integer --1:insert 2:delete
) returns void as
$function$
begin 
     if operacion = 1 then
     	perform * from presupuesto_proveedor_det
     	where it_codigo=itcodigo and prepro_codigo=preprocodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
		     insert into presupuesto_proveedor_det(prepro_codigo, it_codigo, tipit_codigo, peprodet_cantidad, peprodet_precio)
			 values(preprocodigo, itcodigo, tipitcodigo, peprodetcantidad, peprodetprecio);
			 raise notice 'EL PRESUPUESTO PROVEEDOR DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
    	delete from presupuesto_proveedor_det	 
    	where prepro_codigo=preprocodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'EL PRESUPUESTO PROVEEDOR DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Orden Compra Cabecera
create or replace function sp_orden_compra_cab(
    orcomcodigo integer,
    orcomfecha date,
    orcomcondicionpago condicion_pago,
    orcomcuota integer,
    orcominterfecha varchar,  
    orcommontocuota numeric,
    orcomestado varchar,
    usucodigo integer,
    procodigo integer,
    tiprocodigo integer, 
    succodigo integer,
    empcodigo integer,
    preprocodigo integer,
    pedcocodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    prorazonsocial varchar,
    tiprodescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare 
	ultCodPresupuestoOrden integer;
	orcomAudit text;
	preproAudit text;
	pedcoAudit text;
	c_presupuesto cursor is
		select 
		ppc.prepro_fechaactual,
		ppc.prepro_estado,
		ppc.prepro_fechavencimiento,
		ppc.pro_codigo,
		p.pro_ruc,
		p.pro_razonsocial,
		ppc.tipro_codigo,
		tp.tipro_descripcion 
		from presupuesto_proveedor_cab ppc
		join proveedor p on p.pro_codigo=ppc.pro_codigo 
		and p.tipro_codigo=ppc.tipro_codigo 
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
		where ppc.prepro_codigo=preprocodigo;
	c_pedido cursor is
		select 
		pcc.pedco_estado
		from pedido_compra_cab pcc
		where pcc.pedco_codigo=pedcocodigo;	
begin 
     if operacion = 1 then
		 ultCodPresupuestoOrden = (select coalesce(max(presor_codigo),0)+1 from presupuesto_orden);
	     insert into orden_compra_cab(orcom_codigo, orcom_fecha, orcom_condicionpago, orcom_cuota, orcom_interfecha,
	     orcom_estado, usu_codigo, pro_codigo, tipro_codigo, suc_codigo, emp_codigo, orcom_montocuota)
		 values(orcomcodigo, orcomfecha, orcomcondicionpago, orcomcuota, orcominterfecha, 'ACTIVO', usucodigo, procodigo, tiprocodigo,
		 succodigo, empcodigo, orcommontocuota);
		 insert into presupuesto_orden(orcom_codigo, prepro_codigo, presor_codigo)
		 values(orcomcodigo, preprocodigo, ultCodPresupuestoOrden);
		 --Actualizamos el estado de presupuesto proveedor seleccionado
		 update presupuesto_proveedor_cab set prepro_estado='APROBADO', usu_codigo=usucodigo where prepro_codigo=preprocodigo;
		 --Actualizamos el estado del pedido compra que se haya ordenado
		 update pedido_compra_cab set pedco_estado='APROBADO', usu_codigo=usucodigo where pedco_codigo=pedcocodigo;
		 update presupuesto_orden 
			 set presor_audit = json_build_object(
				'usu_codigo', usucodigo,
				'usu_login', usulogin,
				'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
				'procedimiento', 'ALTA',
				'orcom_codigo', orcomcodigo,
				'prepro_codigo', preprocodigo
			 )
			 where presor_codigo = ultCodPresupuestoOrden;
		 raise notice 'LA ORDEN DE COMPRA FUE REGISTRADA CON EXITO';
    end if;
    if operacion = 2 then 
    	--Anulamos la orden de compra cabecera
    	update orden_compra_cab 
		set orcom_estado='ANULADO', usu_codigo=usucodigo
		where orcom_codigo=orcomcodigo;
		--Activamos de nuevo el presupesto 
		update presupuesto_proveedor_cab set prepro_estado='ACTIVO', usu_codigo=usucodigo where prepro_codigo=preprocodigo;
		--Activamos el pedido de compra asociado al presupuesto
		update pedido_compra_cab set pedco_estado='ACTIVO', usu_codigo=usucodigo where pedco_codigo=pedcocodigo;
		raise notice 'LA ORDEN DE COMPRA FUE ANULADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(orcom_audit, '') into orcomAudit from orden_compra_cab where orcom_codigo = orcomcodigo;
	--a los datos anteriores le agregamos los nuevos
	update orden_compra_cab 
	set orcom_audit = orcomAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'orcom_fecha', orcomfecha,
		'orcom_condicionpago', orcomcondicionpago,
		'orcom_cuota', orcomcuota,
		'orcom_montocuota', orcommontocuota,
		'orcom_interfecha', upper(orcominterfecha),
		'pro_codigo', procodigo,
		'pro_razonsocial', upper(prorazonsocial),
		'tipro_codigo', tiprocodigo,
		'tipro_descripcion', upper(tiprodescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'orcom_estado', upper(orcomestado)
	)||','
	where orcom_codigo = orcomcodigo;
	--consultamos el audit anterior de presupuesto proveedor cabecera
	select coalesce(prepro_audit, '') into preproAudit from presupuesto_proveedor_cab where prepro_codigo = preprocodigo;
	--recorremos la fila modificada de presupuesto proveedor
	for pre in c_presupuesto loop
		update presupuesto_proveedor_cab
		set prepro_audit = preproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'prepro_fechaactual', pre.prepro_fechaactual,
		'prepro_fechavencimiento', pre.prepro_fechavencimiento,
		'pro_codigo', pre.pro_codigo,
		'pro_ruc', pre.pro_ruc,
		'pro_razonsocial', pre.pro_razonsocial,
		'tipro_codigo', pre.tipro_codigo,
		'tipro_descripcion', pre.tipro_descripcion,
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'prepro_estado', pre.prepro_estado
	)||','
	where prepro_codigo = preprocodigo;
	end loop;
	--consultamos el audit anterior de pedido compra cabecera
	select coalesce(pedco_audit, '') into pedcoAudit from pedido_compra_cab where pedco_codigo = pedcocodigo;
	--recorremos la fila modificada de pedido compra
	for ped in c_pedido loop
		update pedido_compra_cab 
		set pedco_audit = pedcoAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'pedco_estado', ped.pedco_estado
		)||','
		where pedco_codigo = pedcocodigo;
	end loop;
end
$function$ 
language plpgsql;

--Orden Compra Detalle
create or replace function sp_orden_compra_det(
    orcomcodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    orcomdetcantidad numeric,
    orcomdetprecio numeric,
    operacion integer --1:insert 2:delete
) returns void as
$function$
begin 
     if operacion = 1 then
     	perform * from orden_compra_det
     	where it_codigo=itcodigo and orcom_codigo=orcomcodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
		     insert into orden_compra_det(orcom_codigo, it_codigo, tipit_codigo, orcomdet_cantidad, orcomdet_precio)
			 values(orcomcodigo, itcodigo, tipitcodigo, orcomdetcantidad, orcomdetprecio);
			 raise notice 'LA ORDEN COMPRA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
    	delete from orden_compra_det	 
    	where orcom_codigo=orcomcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'LA ORDEN COMPRA DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Ajuste Inventario Cabecera
create or replace function sp_ajuste_inventario_cab(
    ajuincodigo integer,
    ajuinfecha date,
    ajuintipoajuste tipo_ajuste,
    ajuinestado varchar,
    succodigo integer,
    empcodigo integer,
    usucodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare ajusteDet record;
		ajuinAudit text;
begin 
    if operacion = 1 then
	     insert into ajuste_inventario_cab(ajuin_codigo, ajuin_fecha, ajuin_tipoajuste, ajuin_estado, suc_codigo, emp_codigo, usu_codigo)
		 values(ajuincodigo, ajuinfecha, ajuintipoajuste, 'ACTIVO', succodigo, empcodigo, usucodigo);
		 raise notice 'EL AJUSTE DE INVENTARIO FUE REGISTRADO CON EXITO';
    end if;
    if operacion = 2 then 
    	update ajuste_inventario_cab 
		set ajuin_estado='ANULADO'
		where ajuin_codigo=ajuincodigo;
		--Actualizamos el stock en caso de anular el registro
	    if ajuintipoajuste='POSITIVO' then
	    	for ajusteDet in select * from ajuste_inventario_det where ajuin_codigo=ajuincodigo loop
	       	 	update stock set st_cantidad=st_cantidad-ajusteDet.ajuindet_cantidad 
				where it_codigo=ajusteDet.it_codigo and tipit_codigo=ajusteDet.tipit_codigo and dep_codigo=ajusteDet.dep_codigo
				and suc_codigo=ajusteDet.suc_codigo and emp_codigo=ajusteDet.emp_codigo;
        	end loop;
        elseif ajuintipoajuste='NEGATIVO' then
        	for ajusteDet in select * from ajuste_inventario_det where ajuin_codigo=ajuincodigo loop
	       	 	update stock set st_cantidad=st_cantidad+ajusteDet.ajuindet_cantidad 
				where it_codigo=ajusteDet.it_codigo and tipit_codigo=ajusteDet.tipit_codigo and dep_codigo=ajusteDet.dep_codigo
				and suc_codigo=ajusteDet.suc_codigo and emp_codigo=ajusteDet.emp_codigo;
        	end loop;
	    end if;
		raise notice 'EL AJUSTE DE INVENTARIO FUE ANULADO CON EXITO';
    end if;
	--AJUSTE INVENTARIO CABECERA AUDITORIA
	--consultamos el audit anterior de ajuste inventario cabecera
	select coalesce(aic.ajuin_audit, '') into ajuinAudit from ajuste_inventario_cab aic where aic.ajuin_codigo=ajuincodigo;
	--a los datos anteriores le agregamos los nuevos
	update ajuste_inventario_cab
	set ajuin_audit = ajuinAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'ajuin_fecha', ajuinfecha,
		'ajuin_tipoajuste', ajuintipoajuste,
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'ajuin_estado', upper(ajuinestado)
	)||','
	where ajuin_codigo = ajuincodigo;
end
$function$ 
language plpgsql;

--Ajuste Inventario Detalle
create or replace function sp_ajuste_inventario_det(
    ajuincodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    ajuindetcantidad numeric,
    ajuindetmotivo varchar,
    ajuintipoajuste varchar,
    ajuindetprecio numeric,
    operacion integer 
) returns void as
$function$
begin 
     if operacion = 1 then
     	perform * from ajuste_inventario_det
     	where it_codigo=itcodigo and dep_codigo=depcodigo and ajuin_codigo=ajuincodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
     	 	 --Insertamos detalle de ajuste
		     insert into ajuste_inventario_det(ajuin_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo,
		     emp_codigo, ajuindet_cantidad, ajuindet_motivo, ajuindet_precio)
			 values(ajuincodigo, itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, ajuindetcantidad, upper(ajuindetmotivo), ajuindetprecio);
			 --Actualizamos el stock en caso de que sea positivo o negativo
			 if ajuintipoajuste='POSITIVO' then
			 	update stock set st_cantidad=st_cantidad+ajuindetcantidad 
			 	where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			 	and suc_codigo=succodigo and emp_codigo=empcodigo;
			 elseif ajuintipoajuste='NEGATIVO' then
			 	update stock set st_cantidad=st_cantidad-ajuindetcantidad 
			 	where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			 	and suc_codigo=succodigo and emp_codigo=empcodigo;
			 end if;
			 raise notice 'EL AJUSTE INVENTARIO DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
    	--Eliminamos el item y devolvemos la cantidad
    	delete from ajuste_inventario_det 
    	where ajuin_codigo=ajuincodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
        and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
       	--Actualizamos el stock en caso de eliminar un registro
        if ajuintipoajuste='POSITIVO' then
		   update stock set st_cantidad=st_cantidad-ajuindetcantidad 
		   where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		   and suc_codigo=succodigo and emp_codigo=empcodigo;
	    elseif ajuintipoajuste='NEGATIVO' then
		   update stock set st_cantidad=st_cantidad+ajuindetcantidad 
		   where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		   and suc_codigo=succodigo and emp_codigo=empcodigo;
	    end if;
		raise notice 'EL AJUSTE INVENTARIO DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Compra Cabecera
create or replace function sp_compra_cab(
    compcodigo integer,
    compfecha date,
    comnumfactura varchar,
    comptimbrado varchar,
    comptipofactura tipo_factura,
    compcuota integer,
    compmontocuota numeric,
    compinterfecha varchar,
    compestado varchar,
    procodigo integer,
    tiprocodigo integer,
    succodigo integer,
    empcodigo integer,
    usucodigo integer,
    orcomcodigo integer,
    tipcocodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    tipcodescripcion varchar,
    prorazonsocial varchar,
    tiprodescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare compraDet record;
		ultCodOrdenCompra integer;
		ultCodLibroCompra integer;
		compAudit text;
		orcomAudit text;
		licomAudit text;
		cuenpaAudit text;
		c_orden cursor is
		select 
		occ.orcom_fecha,
		occ.orcom_condicionpago,
		occ.orcom_cuota,
		occ.orcom_montocuota,
		occ.orcom_interfecha,
		occ.orcom_estado,
		occ.pro_codigo,
		p.pro_razonsocial,
		occ.tipro_codigo,
		tp.tipro_descripcion
		from orden_compra_cab occ
		join usuario u on u.usu_codigo=occ.usu_codigo
		join proveedor p on p.pro_codigo=occ.pro_codigo
		and p.tipro_codigo=occ.tipro_codigo
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
		where occ.orcom_codigo=orcomcodigo;
		c_libro cursor is
		select 
		lc.comp_codigo,
		lc.licom_exenta,
		lc.licom_iva5,
		lc.licom_iva10,
		lc.licom_fecha,
		lc.tipco_codigo,
		lc.licom_numcomprobante,
		lc.licom_estado
		from libro_compra lc
		where lc.comp_codigo=compcodigo;
		c_cuenta cursor is
		select
		cp.cuenpa_nrocuota,
		cp.cuenpa_monto,
		cp.cuenpa_saldo,
		cp.cuenpa_estado
		from cuenta_pagar cp
		where cp.comp_codigo=compcodigo;
begin 
     if operacion = 1 then
		ultCodOrdenCompra = (select coalesce(max(ordencom_codigo),0)+1 from orden_compra);
		ultCodLibroCompra = (select coalesce(max(licom_codigo),0)+1 from libro_compra);
     	perform * from compra_cab
     	where pro_codigo=procodigo and com_numfactura=comnumfactura;
     	if found then
     		 raise exception 'factura';
     	elseif operacion = 1 then
		     insert into compra_cab(comp_codigo, comp_fecha, com_numfactura, comp_tipofactura, comp_cuota, comp_interfecha,
		     comp_estado, pro_codigo, tipro_codigo, suc_codigo, emp_codigo, usu_codigo, comp_montocuota, comp_timbrado,
			 comp_audit, tipco_codigo)
			 values(compcodigo, compfecha, comnumfactura, comptipofactura, compcuota, upper(compinterfecha), 'ACTIVO', procodigo, tiprocodigo,
			 succodigo, empcodigo, usucodigo, compmontocuota, comptimbrado, '', tipcocodigo);
			 --Cargamos orden compra
			 insert into orden_compra(comp_codigo, orcom_codigo, ordencom_codigo)
		 	 values(compcodigo, orcomcodigo, ultCodOrdenCompra);
			 --Auditamos orden compra
			 update orden_compra 
			 set ordencom_audit = json_build_object(
				'usu_codigo', usucodigo,
				'usu_login', usulogin,
				'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
				'procedimiento', 'ALTA',
				'comp_codigo', compcodigo,
				'orcom_codigo', orcomcodigo
			 )
			 where ordencom_codigo = ultCodOrdenCompra;
		 	 --Cargamos libro compra
		 	 insert into libro_compra(licom_codigo, comp_codigo, licom_exenta, licom_iva5, licom_iva10, licom_fecha,
		 	 tipco_codigo, licom_numcomprobante, licom_estado)
		 	 values(ultCodLibroCompra, compcodigo, 0, 0, 0, compfecha, tipcocodigo, comnumfactura, 'ACTIVO');
		 	 --Cargamos cuenta pagar
		 	 insert into cuenta_pagar(comp_codigo, cuenpa_nrocuota, cuenpa_monto, cuenpa_saldo, cuenpa_estado)
		 	 values(compcodigo, compcuota, 0, 0, 'ACTIVO');
		 	 --Actualizamos estado de orden
		 	 update orden_compra_cab set orcom_estado='COMPLETADO', usu_codigo=usucodigo where orcom_codigo=orcomcodigo;
			 raise notice 'LA COMPRA FUE REGISTRADA CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
        --Anulamos compra cabecera
    	update compra_cab 
		set comp_estado='ANULADO', usu_codigo=usucodigo
		where comp_codigo=compcodigo;
	    --Anulamos libro compra
	    update libro_compra set licom_estado='ANULADO' where comp_codigo=compcodigo;
	    --Anulamos cuenta pagar
	    update cuenta_pagar set cuenpa_estado='ANULADO' where comp_codigo=compcodigo;
	    --Activamos la orden compra seleccionada
	    update orden_compra_cab set orcom_estado='ACTIVO', usu_codigo=usucodigo where orcom_codigo=orcomcodigo;
	    --Actualizamos el stock 
	    for compraDet in select * from compra_det where comp_codigo=compcodigo loop
	       	update stock set st_cantidad=st_cantidad-compraDet.compdet_cantidad 
			where it_codigo=compraDet.it_codigo and tipit_codigo=compraDet.tipit_codigo and dep_codigo=compraDet.dep_codigo
	        and suc_codigo=compraDet.suc_codigo and emp_codigo=compraDet.emp_codigo;
        end loop;
		raise notice 'LA COMPRA FUE ANULADA CON EXITO';
    end if;
 	--COMPRA CABECERA AUDITORIA
	--consultamos el audit anterior de compra cabecera
	select coalesce(cc.comp_audit, '') into compAudit from compra_cab cc where cc.comp_codigo=compcodigo;
	--a los datos anteriores le agregamos los nuevos
	update compra_cab
	set comp_audit = compAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'comp_fecha', compfecha,
		'comp_numfactura', comnumfactura,
		'comp_timbrado', comptimbrado,
		'comp_tipofactura', comptipofactura,
		'comp_cuota', compcuota,
		'comp_montocuota', compmontocuota,
		'comp_interfecha', upper(compinterfecha),
		'tipco_codigo', tipcocodigo,
		'tipco_descripcion', upper(tipcodescripcion),
		'pro_codigo', procodigo,
		'pro_razonsocial', upper(prorazonsocial),
		'tipro_codigo', tiprocodigo,
		'tipro_descripcion', upper(tiprodescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'comp_estado', upper(compestado)
	)||','
	where comp_codigo = compcodigo;
	--ORDEN COMPRA CABECERA AUDITORIA
	--consultamos el audit anterior de orden compra cabecera
	select coalesce(orcom_audit, '') into orcomAudit from orden_compra_cab occ where occ.orcom_codigo = orcomcodigo;
	--a los datos anteriores le agregamos los nuevos
	for ord in c_orden loop
		update orden_compra_cab
		set orcom_audit = orcomAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'orcom_fecha', ord.orcom_fecha,
		'orcom_condicionpago', ord.orcom_condicionpago,
		'orcom_cuota', ord.orcom_cuota,
		'orcom_montocuota', ord.orcom_montocuota,
		'orcom_interfecha', upper(ord.orcom_interfecha),
		'pro_codigo', ord.pro_codigo,
		'pro_razonsocial', upper(ord.pro_razonsocial),
		'tipro_codigo', ord.tipro_codigo,
		'tipro_descripcion', upper(ord.tipro_descripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'orcom_estado', upper(ord.orcom_estado)
		)||','
		where orcom_codigo = orcomcodigo;
	end loop;
	--LIBRO COMPRA AUDITORIA
	--consultamos el audit anterior de libro compra
	select coalesce(lc.licom_audit, '') into licomAudit from libro_compra lc where lc.comp_codigo=compcodigo;
	--a los datos anteriores le agregamos los nuevos
	for lib in c_libro loop
		update libro_compra 
		set licom_audit = licomAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'comp_codigo', lib.comp_codigo,
		'licom_exenta', lib.licom_exenta,
		'licom_iva5', lib.licom_iva5,
		'licom_iva10', lib.licom_iva10,
		'licom_fecha', lib.licom_fecha,
		'tipco_codigo', lib.tipco_codigo,
		'tipco_descripcion', upper(tipcodescripcion),
		'licom_numcomprobante', lib.licom_numcomprobante,
		'licom_estado', lib.licom_estado
		)||','
		where comp_codigo = compcodigo;
	end loop;
	--CUENTAS PAGAR AUDITORIA
	--consultamos el audit anterior de cuenta pagar
	select coalesce(cp.cuenpa_audit, '') into cuenpaAudit from cuenta_pagar cp where cp.comp_codigo=compcodigo;
	--a los datos anteriores le agregamos los nuevos
	for cue in c_cuenta loop
		update cuenta_pagar 
		set cuenpa_audit = cuenpaAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'cuenpa_nrocuota', cue.cuenpa_nrocuota,
		'cuenpa_monto', cue.cuenpa_monto,
		'cuenpa_saldo', cue.cuenpa_saldo,
		'cuenpa_estado', cue.cuenpa_estado
		)||','
		where comp_codigo = compcodigo;
	end loop;
end
$function$ 
language plpgsql;

--Compra Detalle
create or replace function sp_compra_det(
    compcodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    compdetcantidad numeric,
    compdetprecio numeric,
    operacion integer
) returns void as
$function$
begin 
     if operacion = 1 then
     	perform * from compra_det
     	where it_codigo=itcodigo and dep_codigo=depcodigo and comp_codigo=compcodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
			 perform * from stock
     		 where it_codigo=itcodigo and tipit_codigo=tipitcodigo 
			 and dep_codigo=depcodigo and suc_codigo=succodigo 
			 and emp_codigo=empcodigo;
			 if found then
				--Actualizamos el stock 
				 update stock set st_cantidad=st_cantidad+compdetcantidad 
				 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
				 and suc_codigo=succodigo and emp_codigo=empcodigo;
			 else	
				 --Cargamos el nuevo ítem en stock
				 if tipitcodigo in(1, 4) then
					--Si es materia prima o utilitario cargamos la cantidad
					insert into stock(it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo, st_cantidad)
				    values(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, compdetcantidad);
				 else
					--Si es un servicio mantenemos la cantidad en 0
					insert into stock(it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo, st_cantidad)
				    values(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, 0);
				 end if;
            end if;
     	 	 --Insertamos detalle compra
		     insert into compra_det(comp_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo,
		     emp_codigo, compdet_cantidad, compdet_precio)
			 values(compcodigo, itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, compdetcantidad, compdetprecio);
			 raise notice 'LA COMPRA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
    	--Eliminamos el item y devolvemos la cantidad
    	delete from compra_det 
    	where comp_codigo=compcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
        and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
       	--Actualizamos el stock 
		update stock set st_cantidad=st_cantidad-compdetcantidad 
		where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		and suc_codigo=succodigo and emp_codigo=empcodigo;
		raise notice 'LA COMPRA DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Libro Compra
create or replace function sp_libro_compra(
    compcodigo integer,
    licomexenta numeric,
    licomiva5 numeric,
    licomiva10 numeric,
    tipcocodigo integer,
    tipcodescripcion varchar,
    licomnumcomprobante varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar
) returns void as
$function$
declare licomAudit text;
		c_libro cursor is
		select 
		lc.comp_codigo,
		lc.licom_exenta,
		lc.licom_iva5,
		lc.licom_iva10,
		lc.licom_fecha,
		lc.tipco_codigo,
		lc.licom_numcomprobante,
		lc.licom_estado
		from libro_compra lc
		where lc.comp_codigo=compcodigo
		and lc.licom_numcomprobante=licomnumcomprobante;
begin 
	if operacion = 1 then
     update libro_compra set licom_exenta=licom_exenta+licomexenta, licom_iva5=licom_iva5+licomiva5, 
     licom_iva10=licom_iva10+licomiva10 where comp_codigo=compcodigo and licom_numcomprobante=licomnumcomprobante
	 and tipco_codigo=tipcocodigo;
    end if;
    if operacion = 2 then
     update libro_compra set licom_exenta=licom_exenta-licomexenta, licom_iva5=licom_iva5-licomiva5, 
     licom_iva10=licom_iva10-licomiva10 where comp_codigo=compcodigo and licom_numcomprobante=licomnumcomprobante
	 and tipco_codigo=tipcocodigo;
    end if;
	--LIBRO COMPRA AUDITORIA
	--consultamos el audit anterior de libro compra
	select coalesce(lc.licom_audit, '') into licomAudit from libro_compra lc where lc.comp_codigo=compcodigo and lc.licom_numcomprobante=licomnumcomprobante;
	--a los datos anteriores le agregamos los nuevos
	for lib in c_libro loop
		update libro_compra 
		set licom_audit = licomAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'comp_codigo', lib.comp_codigo,
		'licom_exenta', lib.licom_exenta,
		'licom_iva5', lib.licom_iva5,
		'licom_iva10', lib.licom_iva10,
		'licom_fecha', lib.licom_fecha,
		'tipco_codigo', lib.tipco_codigo,
		'tipco_descripcion', upper(tipcodescripcion),
		'licom_numcomprobante', lib.licom_numcomprobante,
		'licom_estado', lib.licom_estado
		)||','
		where comp_codigo = compcodigo and licom_numcomprobante = licomnumcomprobante and tipco_codigo=tipcocodigo;
	end loop;
end
$function$ 
language plpgsql;

--Cuenta Pagar
create or replace function sp_cuenta_pagar(
    compcodigo integer,
    cuenpamonto numeric,
    cuenpasaldo numeric,
    operacion integer,
    usucodigo integer,
    usulogin varchar
) returns void as
$function$
declare cuenpaAudit text;
		c_cuenta cursor is
		select
		cp.cuenpa_nrocuota,
		cp.cuenpa_monto,
		cp.cuenpa_saldo,
		cp.cuenpa_estado
		from cuenta_pagar cp
		where cp.comp_codigo=compcodigo;
begin 
    if operacion = 1 then
	 update	cuenta_pagar set cuenpa_monto=cuenpa_monto+cuenpamonto, 
	 cuenpa_saldo=cuenpa_saldo+cuenpasaldo where comp_codigo=compcodigo;
	end if;
	if operacion = 2 then 
	 update	cuenta_pagar set cuenpa_monto=cuenpa_monto-cuenpamonto, 
	 cuenpa_saldo=cuenpa_saldo-cuenpasaldo where comp_codigo=compcodigo;
	end if;
	--CUENTAS PAGAR AUDITORIA
	--consultamos el audit anterior de cuenta pagar
	select coalesce(cp.cuenpa_audit, '') into cuenpaAudit from cuenta_pagar cp where cp.comp_codigo=compcodigo;
	--a los datos anteriores le agregamos los nuevos
	for cue in c_cuenta loop
		update cuenta_pagar 
		set cuenpa_audit = cuenpaAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'cuenpa_nrocuota', cue.cuenpa_nrocuota,
		'cuenpa_monto', cue.cuenpa_monto,
		'cuenpa_saldo', cue.cuenpa_saldo,
		'cuenpa_estado', cue.cuenpa_estado
		)||','
		where comp_codigo = compcodigo;
	end loop;
end
$function$ 
language plpgsql;

--Nota Compra Cabecera
create or replace function sp_nota_compra_cab(
    nocomcodigo integer,
    nocomfecha date,
    nocomnumeronota varchar,
    nocomconcepto varchar,
    nocomestado varchar,
    tipcocodigo integer,
    succodigo integer,
    empcodigo integer,
    usucodigo integer,
    compcodigo integer,
    procodigo integer,
    tiprocodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    tipcodescripcion varchar,
    prorazonsocial varchar,
    tiprodescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare nocomAudit text;
		licomAudit text;
		licomAudit2 text;
		compAudit text;
		ultCodLibroCompra integer;
		totalSuma NUMERIC := 0;
		numeroFactura varchar;
		filaLibroCompra record;
		c_nota_compra_det cursor is
		select 
		ncd.it_codigo,
		ncd.tipit_codigo,
		ncd.nocomdet_cantidad,
		ncd.dep_codigo,
		ncd.suc_codigo,
		ncd.emp_codigo 
		from nota_compra_det ncd
		where ncd.nocom_codigo=nocomcodigo;
		--Cursor para auditar el registro de nota compra en libro compra
		c_libro cursor is
		select 
		comp_codigo,
		licom_exenta,
		licom_iva5,
		licom_iva10,
		licom_fecha,
		tipco_codigo,
		licom_numcomprobante,
		licom_estado
		from libro_compra
		where comp_codigo=compcodigo
		and licom_numcomprobante=nocomnumeronota
		and tipco_codigo=tipcocodigo;
		c_multiplicacion_nota_compra_det cursor is
		select
			coalesce(ncd.nocomdet_cantidad*ncd.nocomdet_precio, 0) as subtotal
		from nota_compra_det ncd
		where ncd.nocom_codigo=nocomcodigo;
		c_compra_cab cursor is
		select 
			cc.comp_fecha,
			cc.com_numfactura,
			cc.comp_timbrado,
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
			and p.tipro_codigo=cc.tipro_codigo
			join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
			join sucursal s on s.suc_codigo=cc.suc_codigo
			and s.emp_codigo=cc.emp_codigo
			join empresa e on e.emp_codigo=s.emp_codigo
		where cc.comp_codigo=compcodigo;
begin 
     if operacion = 1 then
		ultCodLibroCompra = (select coalesce(max(licom_codigo),0)+1 from libro_compra);
		-- Buscamos si ya existe una nota con el numero de nota, proveedor, de acuerdo al tipo y estado
     	perform * from nota_compra_cab
     	where (nocom_numeronota=nocomnumeronota and pro_codigo=procodigo and tipco_codigo=tipcocodigo) and nocom_estado='ACTIVO';
     	if found then
     		 raise exception 'nota';
     	elseif operacion = 1 then
		 --Si no existe un registro previo, insertamos uno nuevo
	     insert into nota_compra_cab(nocom_codigo, nocom_fecha, nocom_numeronota, nocom_concepto, 
	     nocom_estado, tipco_codigo, suc_codigo, emp_codigo, usu_codigo, comp_codigo, pro_codigo, tipro_codigo)
		 values(nocomcodigo, nocomfecha, nocomnumeronota, upper(nocomconcepto), 
		 'ACTIVO', tipcocodigo, succodigo, empcodigo, usucodigo, compcodigo, procodigo, tiprocodigo);
		 --Cargamos libro compra dependiendo del tipo de comprobante
		 if tipcocodigo in(1,2) then
			 insert into libro_compra(licom_codigo, comp_codigo, licom_exenta, licom_iva5, licom_iva10, licom_fecha,
			 tipco_codigo, licom_numcomprobante, licom_estado)
			 values(ultCodLibroCompra, compcodigo, 0, 0, 0, nocomfecha, tipcocodigo, nocomnumeronota, 'ACTIVO');
		 end if;
		 raise notice 'LA NOTA DE COMPRA FUE REGISTRADA CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
		--Actualizamos estado de nota de compra
    	update nota_compra_cab 
		set nocom_estado='ANULADO', usu_codigo=usucodigo
		where nocom_codigo=nocomcodigo;
		--Si la nota es de credito sumamos stock al anular
		if tipcocodigo = 1 then --suma
			--Actualizamos estado de libro compra
			update libro_compra
			set licom_estado='ANULADO'
			where comp_codigo=compcodigo
			and licom_numcomprobante=nocomnumeronota
			and tipco_codigo=tipcocodigo;
			--Volvemos stock a como estaba
			for nota in c_nota_compra_det loop
				update stock set st_cantidad=st_cantidad+nota.nocomdet_cantidad 
				where it_codigo=nota.it_codigo and tipit_codigo=nota.tipit_codigo and dep_codigo=nota.dep_codigo
				and suc_codigo=nota.suc_codigo and emp_codigo=nota.emp_codigo;
			end loop;
			--LLamamos al curso de multiplicacion nota compra detalle y el valor lo vamos acumulando
			for multiplicacion in c_multiplicacion_nota_compra_det loop
				totalSuma := totalSuma + multiplicacion.subtotal;
			end loop;
			--Validamos que el monto del detalle sea mayor a 0
			if totalSuma > 0 then
				--Actualizamos el estado de cuenta pagar
				update cuenta_pagar set cuenpa_estado='ACTIVO' where comp_codigo=compcodigo;
				--El valor de la suma lo actualizamos en cuenta pagar
				perform sp_cuenta_pagar(compcodigo, totalSuma, totalSuma, 1, usucodigo, usulogin);
				--Actualizamos el estado de compra cab
				update compra_cab set comp_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;
				--Actualizamos el estado de libro compra y compra cab
				for compra in c_compra_cab loop
					--Auditamos compra cabecera 
					--consultamos el audit anterior de compra cabecera
					select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
					--a los datos anteriores le agregamos los nuevos
					update compra_cab
					set comp_audit = compAudit||''||json_build_object(
						'usu_codigo', usucodigo,
						'usu_login', usulogin,
						'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
						'procedimiento', 'MODIFICACION',
						'comp_fecha', compra.comp_fecha,
						'comp_numfactura', compra.com_numfactura,
						'comp_timbrado', compra.comp_timbrado,
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
					)||','
					where comp_codigo = compcodigo;
			    end loop;
			end if;
		--Si la nota es de debito restamos stock al anular
		elseif tipcocodigo = 2 then --resta
			--Actualizamos estado de libro compra
			update libro_compra
			set licom_estado='ANULADO'
			where comp_codigo=compcodigo
			and licom_numcomprobante=nocomnumeronota
			and tipco_codigo=tipcocodigo;
			--Volvemos stock a donde estaba
			for nota in c_nota_compra_det loop
				update stock set st_cantidad=st_cantidad-nota.nocomdet_cantidad 
				where it_codigo=nota.it_codigo and tipit_codigo=nota.tipit_codigo and dep_codigo=nota.dep_codigo
				and suc_codigo=nota.suc_codigo and emp_codigo=nota.emp_codigo;
			end loop;
			--LLamamos al curso de multiplicacion nota compra detalle y el valor lo vamos acumulando
			for multiplicacion in c_multiplicacion_nota_compra_det loop
				totalSuma := totalSuma + multiplicacion.subtotal;
			end loop;
			--El valor de la suma lo actualizamos en cuanta pagar
			if totalSuma > 0 then
				perform sp_cuenta_pagar(compcodigo, totalSuma, totalSuma, 2, usucodigo, usulogin);
			end if;
		end if;
		raise notice 'LA NOTA DE COMPRA FUE ANULADA CON EXITO';
    end if;
	--consultamos el audit anterior de nota compra cabecera
	select coalesce(nocom_audit, '') into nocomAudit from nota_compra_cab where nocom_codigo=nocomcodigo;
	--a los datos anteriores le agregamos los nuevos
	update nota_compra_cab
	set nocom_audit = nocomAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'nocom_fecha', nocomfecha,
		'nocom_numeronota', nocomnumeronota,
		'nocom_concepto', nocomconcepto,
		'comp_codigo', compcodigo,
		'tipco_codigo', tipcocodigo,
		'tipco_descripcion', upper(tipcodescripcion),
		'pro_codigo', procodigo,
		'pro_razonsocial', upper(prorazonsocial),
		'tipro_codigo', tiprocodigo,
		'tipro_descripcion', upper(tiprodescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'nocom_estado', upper(nocomestado)
	)||','
	where nocom_codigo = nocomcodigo;
	--LIBRO COMPRA AUDITORIA
	--consultamos el audit anterior de libro compra
	select coalesce(licom_audit, '') into licomAudit from libro_compra where comp_codigo=compcodigo and licom_numcomprobante=nocomnumeronota and tipco_codigo=tipcocodigo;
	--a los datos anteriores le agregamos los nuevos
	for lib in c_libro loop
		update libro_compra 
		set licom_audit = licomAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'comp_codigo', lib.comp_codigo,
		'licom_exenta', lib.licom_exenta,
		'licom_iva5', lib.licom_iva5,
		'licom_iva10', lib.licom_iva10,
		'licom_fecha', lib.licom_fecha,
		'tipco_codigo', lib.tipco_codigo,
		'tipco_descripcion', upper(tipcodescripcion),
		'licom_numcomprobante', lib.licom_numcomprobante,
		'licom_estado', lib.licom_estado
		)||','
		where comp_codigo=compcodigo and licom_numcomprobante=nocomnumeronota and tipco_codigo=tipcocodigo;
	end loop;
end
$function$ 
language plpgsql;

--Nota Compra Detalle
create or replace function sp_nota_compra_det(
    nocomcodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    nocomdetcantidad numeric,
    nocomdetprecio numeric,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    tipcocodigo integer,
    compcodigo integer,
    usucodigo integer, 
    operacion integer,
    usulogin varchar
) returns void as
$function$ 
declare numeroFactura varchar;
		filaLibroCompra record;
		licomAudit2 text;
		compAudit text;
		notaMonto numeric; 
		compraEstado varchar;
		c_compra_cab cursor is
		select 
		cc.comp_fecha,
		cc.com_numfactura,
		cc.comp_timbrado,
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
		and p.tipro_codigo=cc.tipro_codigo
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
		join sucursal s on s.suc_codigo=cc.suc_codigo
		and s.emp_codigo=cc.emp_codigo
		join empresa e on e.emp_codigo=s.emp_codigo
		where cc.comp_codigo=compcodigo;
begin 
	 --Consultamos el monto de cuenta pagar y la guardamos en una variable
	 select cp.cuenpa_monto into notaMonto from cuenta_pagar cp where cp.comp_codigo=compcodigo;
	 --Consultamos el estado de compra cabecera
	 select cc.comp_estado into compraEstado from compra_cab cc where cc.comp_codigo=compcodigo;	
     if operacion = 1 then
     	perform * from nota_compra_det
     	where it_codigo=itcodigo and tipit_codigo=tipitcodigo 
	    and dep_codigo=depcodigo and suc_codigo=succodigo 
	    and emp_codigo=empcodigo and nocom_codigo=nocomcodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
			 --insertamos los datos en la tabla independientemente del tipo de comprobante
		     insert into nota_compra_det(nocom_codigo, it_codigo, tipit_codigo, nocomdet_cantidad, nocomdet_precio,
			 dep_codigo, suc_codigo, emp_codigo)
			 values(nocomcodigo, itcodigo, tipitcodigo, nocomdetcantidad, nocomdetprecio, depcodigo, succodigo, empcodigo);
			 -- validamos el tipo de comprobante para saber si sumar o restar stock
			 if tipcocodigo = 1 then
				 -- en caso de ser credito se resta el item del stock
				 update stock set st_cantidad=st_cantidad-nocomdetcantidad 
				 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
				 and suc_codigo=succodigo and emp_codigo=empcodigo;
				--validar si el monto = 0
				if notaMonto = 0 then 
					--Actualizamos los estados de las tablas asociadas a compra cab y la misma tabla
					--Actualizamos el estado de cuenta pagar
					update cuenta_pagar set cuenpa_estado='ANULADO', usu_codigo=usucodigo where comp_codigo=compcodigo;
					--Utilizamos el sp de de cuenta pagar para auditar la actualizacion de estado
					perform sp_cuenta_pagar(compcodigo, 0, 0, 3, usucodigo, usulogin);
					--Actualizamos el estado de compra cabecera
					update compra_cab set comp_estado='ANULADO', usu_codigo=usucodigo where comp_codigo=compcodigo;
					--Auditamos compra cab
					for compra in c_compra_cab loop
						--consultamos el audit anterior de compra cabecera
						select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
						--a los datos anteriores le agregamos los nuevos
						update compra_cab
						set comp_audit = compAudit||''||json_build_object(
							'usu_codigo', usucodigo,
							'usu_login', usulogin,
							'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
							'procedimiento', 'MODIFICACION',
							'comp_fecha', compra.comp_fecha,
							'comp_numfactura', compra.com_numfactura,
							'comp_timbrado', compra.comp_timbrado,
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
						)||','
						where comp_codigo = compcodigo;
					end loop;
				end if;
			 elseif tipcocodigo = 2 then 
				 -- en caso de ser debito se suma el item del stock
				 update stock set st_cantidad=st_cantidad+nocomdetcantidad 
				 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
				 and suc_codigo=succodigo and emp_codigo=empcodigo;
				 --Validamos que el monto de cuenta sea mayor a cero y que el estado de compra sea anulado para no auditar de forma innecesaria
				 if notaMonto > 0 and compraEstado = 'ANULADO' then	
					--Actualizamos los estados de las tablas asociadas a compra cab y la misma tabla
					--Actualizamos el estado de cuenta pagar
					update cuenta_pagar set cuenpa_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;
					--Utilizamos el sp de de cuenta pagar para auditar la actualizacion de estado
					perform sp_cuenta_pagar(compcodigo, 0, 0, 3, usucodigo, usulogin);
					--Actualizamos el estado de compra cabecera
					update compra_cab set comp_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;
					--Auditamos compra cab
					for compra in c_compra_cab loop
						--consultamos el audit anterior de compra cabecera
						select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
						--a los datos anteriores le agregamos los nuevos
						update compra_cab
						set comp_audit = compAudit||''||json_build_object(
							'usu_codigo', usucodigo,
							'usu_login', usulogin,
							'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
							'procedimiento', 'MODIFICACION',
							'comp_fecha', compra.comp_fecha,
							'comp_numfactura', compra.com_numfactura,
							'comp_timbrado', compra.comp_timbrado,
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
						)||','
						where comp_codigo = compcodigo;
					end loop;
				 end if;
			 end if;
			 raise notice 'LA NOTA DE COMPRA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
		--eliminamos los datos de la tabla nota compra detalle
    	delete from nota_compra_det 
    	where nocom_codigo=nocomcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
		and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
		-- validamos el tipo de comprobante para saber si sumar o restar stock
		if tipcocodigo = 1 then
			-- en caso de ser credito se suma el item del stock
			update stock set st_cantidad=st_cantidad+nocomdetcantidad 
			where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			and suc_codigo=succodigo and emp_codigo=empcodigo;
			--Validamos que el monto de cuenta sea mayor a cero y que el estado de compra sea anulado para no auditar de forma innecesaria
			if notaMonto > 0 and compraEstado = 'ANULADO' then	
				--Actualizamos los estados de las tablas asociadas a compra cab y la misma tabla
				--Actualizamos el estado de cuenta pagar
				update cuenta_pagar set cuenpa_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;
				--Utilizamos el sp de de cuenta pagar para auditar la actualizacion de estado
				perform sp_cuenta_pagar(compcodigo, 0, 0, 3, usucodigo, usulogin);
				--Actualizamos el estado de compra cabecera
				update compra_cab set comp_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;
				--Auditamos compra cab
				for compra in c_compra_cab loop
					--consultamos el audit anterior de compra cabecera
					select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
					--a los datos anteriores le agregamos los nuevos
					update compra_cab
					set comp_audit = compAudit||''||json_build_object(
						'usu_codigo', usucodigo,
						'usu_login', usulogin,
						'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
						'procedimiento', 'MODIFICACION',
						'comp_fecha', compra.comp_fecha,
						'comp_numfactura', compra.com_numfactura,
						'comp_timbrado', compra.comp_timbrado,
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
					)||','
					where comp_codigo = compcodigo;
				end loop;
			end if;
		elseif tipcocodigo = 2 then --nada
			-- en caso de ser debito se resta el item del stock
			update stock set st_cantidad=st_cantidad-nocomdetcantidad 
			where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			and suc_codigo=succodigo and emp_codigo=empcodigo;
		end if;
		raise notice 'LA NOTA DE COMPRA DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;


--NO USAR
create or replace function sp_nota_compra_det(
    nocomcodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    nocomdetcantidad numeric,
    nocomdetprecio numeric,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    tipcocodigo integer,
    compcodigo integer,
    usucodigo integer, 
    operacion integer,
    usulogin varchar
) returns void as
$function$ 
declare numeroFactura varchar;
		filaLibroCompra record;
		licomAudit2 text;
		compAudit text;
		notaMonto numeric; 
		compraEstado varchar;
		c_compra_cab cursor is
		select 
		cc.comp_fecha,
		cc.com_numfactura,
		cc.comp_timbrado,
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
		and p.tipro_codigo=cc.tipro_codigo
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
		join sucursal s on s.suc_codigo=cc.suc_codigo
		and s.emp_codigo=cc.emp_codigo
		join empresa e on e.emp_codigo=s.emp_codigo
		where cc.comp_codigo=compcodigo;
begin 
	 --Consultamos el monto de cuenta pagar y la guardamos en una variable
	 select cp.cuenpa_monto into notaMonto from cuenta_pagar cp where cp.comp_codigo=compcodigo;
	 --Consultamos el estado de compra cabecera
	 select cc.comp_estado into compraEstado from compra_cab cc where cc.comp_codigo=compcodigo;	
     if operacion = 1 then
     	perform * from nota_compra_det
     	where it_codigo=itcodigo and tipit_codigo=tipitcodigo 
	    and dep_codigo=depcodigo and suc_codigo=succodigo 
	    and emp_codigo=empcodigo and nocom_codigo=nocomcodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
			 --insertamos los datos en la tabla independientemente del tipo de comprobante
		     insert into nota_compra_det(nocom_codigo, it_codigo, tipit_codigo, nocomdet_cantidad, nocomdet_precio,
			 dep_codigo, suc_codigo, emp_codigo)
			 values(nocomcodigo, itcodigo, tipitcodigo, nocomdetcantidad, nocomdetprecio, depcodigo, succodigo, empcodigo);
			 -- validamos el tipo de comprobante para saber si sumar o restar stock
			 if tipcocodigo = 1 then
				 -- en caso de ser credito se resta el item del stock
				 update stock set st_cantidad=st_cantidad-nocomdetcantidad 
				 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
				 and suc_codigo=succodigo and emp_codigo=empcodigo;
				--validar si el monto = 0
				if notaMonto = 0 then 
					--Actualizamos los estados de las tablas asociadas a compra cab y la misma tabla
					--Actualizamos el estado de cuenta pagar
					update cuenta_pagar set cuenpa_estado='ANULADO' where comp_codigo=compcodigo;
					--Utilizamos el sp de de cuenta pagar para auditar la actualizacion de estado
					perform sp_cuenta_pagar(compcodigo, 0, 0, 3, usucodigo, usulogin);
					--Actualizamos el estado de compra cabecera
					update compra_cab set comp_estado='ANULADO', usu_codigo=usucodigo where comp_codigo=compcodigo;
					--Auditamos compra cab
					for compra in c_compra_cab loop
						--consultamos el audit anterior de compra cabecera
						select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
						--a los datos anteriores le agregamos los nuevos
						update compra_cab
						set comp_audit = compAudit||''||json_build_object(
							'usu_codigo', usucodigo,
							'usu_login', usulogin,
							'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
							'procedimiento', 'MODIFICACION',
							'comp_fecha', compra.comp_fecha,
							'comp_numfactura', compra.com_numfactura,
							'comp_timbrado', compra.comp_timbrado,
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
						)||','
						where comp_codigo = compcodigo;
					end loop;
				end if;
			 elseif tipcocodigo = 2 then 
				 -- en caso de ser debito se suma el item del stock
				 update stock set st_cantidad=st_cantidad+nocomdetcantidad 
				 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
				 and suc_codigo=succodigo and emp_codigo=empcodigo;
				 --Validamos que el monto de cuenta sea mayor a cero y que el estado de compra sea anulado para no auditar de forma innecesaria
				 if notaMonto > 0 and compraEstado = 'ANULADO' then	
					--Actualizamos los estados de las tablas asociadas a compra cab y la misma tabla
					--Actualizamos el estado de cuenta pagar
					update cuenta_pagar set cuenpa_estado='ACTIVO' where comp_codigo=compcodigo;
					--Utilizamos el sp de de cuenta pagar para auditar la actualizacion de estado
					perform sp_cuenta_pagar(compcodigo, 0, 0, 3, usucodigo, usulogin);
					--Actualizamos el estado de compra cabecera
					update compra_cab set comp_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;
					--Auditamos compra cab
					for compra in c_compra_cab loop
						--consultamos el audit anterior de compra cabecera
						select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
						--a los datos anteriores le agregamos los nuevos
						update compra_cab
						set comp_audit = compAudit||''||json_build_object(
							'usu_codigo', usucodigo,
							'usu_login', usulogin,
							'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
							'procedimiento', 'MODIFICACION',
							'comp_fecha', compra.comp_fecha,
							'comp_numfactura', compra.com_numfactura,
							'comp_timbrado', compra.comp_timbrado,
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
						)||','
						where comp_codigo = compcodigo;
					end loop;
				 end if;
			 end if;
			 raise notice 'LA NOTA DE COMPRA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
		--eliminamos los datos de la tabla nota compra detalle
    	delete from nota_compra_det 
    	where nocom_codigo=nocomcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
		and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
		-- validamos el tipo de comprobante para saber si sumar o restar stock
		if tipcocodigo = 1 then
			-- en caso de ser credito se suma el item del stock
			update stock set st_cantidad=st_cantidad+nocomdetcantidad 
			where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			and suc_codigo=succodigo and emp_codigo=empcodigo;
			--Validamos que el monto de cuenta sea mayor a cero y que el estado de compra sea anulado para no auditar de forma innecesaria
			if notaMonto > 0 and compraEstado = 'ANULADO' then	
				--Actualizamos los estados de las tablas asociadas a compra cab y la misma tabla
				--Actualizamos el estado de cuenta pagar
				update cuenta_pagar set cuenpa_estado='ACTIVO' where comp_codigo=compcodigo;
				--Utilizamos el sp de de cuenta pagar para auditar la actualizacion de estado
				perform sp_cuenta_pagar(compcodigo, 0, 0, 3, usucodigo, usulogin);
				--Actualizamos el estado de compra cabecera
				update compra_cab set comp_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;
				--Auditamos compra cab
				for compra in c_compra_cab loop
					--consultamos el audit anterior de compra cabecera
					select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
					--a los datos anteriores le agregamos los nuevos
					update compra_cab
					set comp_audit = compAudit||''||json_build_object(
						'usu_codigo', usucodigo,
						'usu_login', usulogin,
						'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
						'procedimiento', 'MODIFICACION',
						'comp_fecha', compra.comp_fecha,
						'comp_numfactura', compra.com_numfactura,
						'comp_timbrado', compra.comp_timbrado,
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
					)||','
					where comp_codigo = compcodigo;
				end loop;
			end if;
		elseif tipcocodigo = 2 then --nada
			-- en caso de ser debito se resta el item del stock
			update stock set st_cantidad=st_cantidad-nocomdetcantidad 
			where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			and suc_codigo=succodigo and emp_codigo=empcodigo;
		end if;
		raise notice 'LA NOTA DE COMPRA DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;