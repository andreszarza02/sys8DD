--Procedimientos almacenados
-- Stock
create or replace function sp_stock(
    itcodigo integer,
    tipitcodigo integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    stcantidad numeric,
    operacion integer,
    usucodigo integer,
    usulogin varchar
) returns void as
$function$
-- Definimos las variables a utilizar
declare stAudit text;
		procedimiento varchar;
begin 
	-- Valiados la operacion de insercion
    if operacion = 1 then
		-- Validamos que no se repita el item y deposito
        perform * from stock
        where it_codigo = itcodigo and tipit_codigo = tipitcodigo
        and dep_codigo=depcodigo and suc_codigo=succodigo
        and emp_codigo=empcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'item_stock';
    	elseif operacion = 1 then
				-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro 
	        	insert into stock(it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo, st_cantidad)
				values(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, stcantidad);
				-- Establecemos el valor del procedimiento
				procedimiento := 'ALTA';
				-- Se envia un mensaje de confirmacion
				raise notice 'EL ITEM FUE REGISTRADO EN STOCK CON EXITO';
        end if;
    end if;
	-- Validamos que la operacion sea de modificacion
    if operacion = 2 then 
		-- Establecemos el valor del procedimiento
    	procedimiento := 'MODIFICACION';
    end if;
	-- Consultamos el audit anterior
	select coalesce(st_audit, '') into stAudit from stock where it_codigo = itcodigo and dep_codigo = depcodigo;
	-- Alos datos anteriores le agragamos los nuevos
	update stock 
	set st_audit = stAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'it_codigo', itcodigo,
		'tipit_codigo', tipitcodigo,
		'dep_codigo', depcodigo,
		'suc_codigo', succodigo,
		'emp_codigo', empcodigo,
		'st_cantidad', stcantidad
	)||','
	where it_codigo = itcodigo and dep_codigo = depcodigo;
end
$function$ 
language plpgsql;

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

-- Funcionario Proveedor
create or replace function sp_funcionario_proveedor(
    funprocodigo integer,
    funpronombre varchar,
    funproapellido varchar,
    funprodocumento varchar,
    funproestado varchar,
    procodigo integer,
    tiprocodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    prorazonsocial varchar,
    tiprodescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare funproAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos si se paso un numero de documento
		if funprodocumento is null then
			-- Si no se paso validamos el funcionario por nombre
			perform * from funcionario_proveedor
        	where (funpro_nombre = upper(funpronombre) and funpro_apellido = upper(funproapellido)) and pro_codigo = procodigo and funpro_codigo != funprocodigo;
		else	
			-- Si se paso validamos el numero de cedula
			perform * from funcionario_proveedor
        	where (funpro_documento = funprodocumento) and pro_codigo = procodigo and funpro_codigo != funprocodigo;
		end if;
        if found then
			-- En caso de que ya se encuentre registrado, generamos una excepcion
            raise exception 'funcionario';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into funcionario_proveedor(funpro_codigo, funpro_nombre, funpro_apellido, funpro_documento, funpro_estado, pro_codigo, tipro_codigo)
				values(funprocodigo, upper(funpronombre), upper(funproapellido), funprodocumento, 'ACTIVO', procodigo, tiprocodigo);
				raise notice 'EL FUNCIONARIO PROVEEDOR FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update funcionario_proveedor
				set funpro_nombre=upper(funpronombre), funpro_apellido=upper(funproapellido), funpro_documento=funprodocumento,
				funpro_estado='ACTIVO', pro_codigo=procodigo, tipro_codigo=tiprocodigo
				where funpro_codigo=funprocodigo;
				raise notice 'EL FUNCIONARIO PROVEEDOR FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update funcionario_proveedor
		set funpro_estado='INACTIVO'
		where funpro_codigo=funprocodigo;
		raise notice 'EL FUNCIONARIO PROVEEDOR FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(funpro_audit, '') into funproAudit from funcionario_proveedor where funpro_codigo = funprocodigo;
	-- A los datos anteriores le agregamos los nuevos
	update funcionario_proveedor 
	set funpro_audit = funproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'funpro_nombre', upper(funpronombre),
		'funpro_apellido', upper(funproapellido),
		'funpro_documento', funprodocumento,
		'pro_codigo', procodigo,
		'pro_razonsocial', upper(prorazonsocial),
		'tipro_codigo', tiprocodigo,
		'tipro_descripcion', upper(tiprodescripcion),
		'funpro_estado', upper(funproestado)
	)||','
	where funpro_codigo = funprocodigo;
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

--Solicitud Presupuesto Cabecera
create or replace function sp_solicitud_presupuesto_cab(
    solprecodigo integer,
    pedcocodigo integer,
    procodigo integer,
    tiprocodigo integer,
    solprefecha date,
    solprecorreoproveedor varchar,
    usucodigo integer,
    succodigo varchar,
    empcodigo varchar,
    operacion integer
) returns void as
$function$
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		-- Validamos que no se repita el pedido y el proveedor
		perform * from solicitud_presupuesto_cab spc
		where pedco_codigo=pedcocodigo and pro_codigo=procodigo 
		and tipro_codigo=tiprocodigo and solpre_codigo != solprecodigo;
		if found then
			-- En caso de ser asi, generamos una excepcion
			raise exception 'pedido';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro
		elseif operacion = 1 then
			insert into solicitud_presupuesto_cab(solpre_codigo, pedco_codigo, pro_codigo, tipro_codigo, solpre_fecha, solpre_correo_proveedor,
			usu_codigo, suc_codigo, emp_codigo)
		 	values(solprecodigo, pedcocodigo, procodigo, tiprocodigo, solprefecha, solprecorreoproveedor, usucodigo, succodigo, empcodigo);
			-- Se envia un mensaje de confirmacion
		 	raise notice 'LA SOLICITUD DE PRESUPUESTO CABECERA YA SE REGISTRO, PUEDE PROCEDER CON EL DETALLE';
		end if;
    end if;
	-- Validamos la operacion de eliminacion
    if operacion = 2 then 
		-- Eliminamos el detalle de cabecera
		delete from solicitud_presupuesto_det where solpre_codigo=solprecodigo;
		-- Eliminamos la cabera
		delete from solicitud_presupuesto_cab where solpre_codigo=solprecodigo;
		-- Se envia un mensaje de confirmacion
		raise notice 'LA SOLICITUD DE PRESUPUESTO CABECERA FUE ELIMINADA CON SU RESPECTIVO DETALLE';
    end if;
end
$function$ 
language plpgsql;

-- Solicitud Presupuesto Detalle
create or replace function sp_solicitud_presupuesto_det(
    solprecodigo integer,
    pedcocodigo integer,
    procodigo integer,
    tiprocodigo integer,
    itcodigo integer, 
    tipitcodigo integer,
    solpredetcantidad numeric,
    operacion integer
) returns void as
$function$
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		-- Validamos que no se repita el ítem en el detalle
     	perform * from solicitud_presupuesto_det
     	where it_codigo=itcodigo and solpre_codigo=solprecodigo;
     	if found then
			 -- Si es asi, generamos una excepcion
     		 raise exception 'item';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro
     	elseif operacion = 1 then
		     insert into solicitud_presupuesto_det(solpre_codigo, pedco_codigo, pro_codigo, tipro_codigo, it_codigo, tipit_codigo, solpredet_cantidad)
			 values(solprecodigo, pedcocodigo, procodigo, tiprocodigo, tipitcodigo, solpredetcantidad);
			 raise notice 'LA SOLICITUD DE PRESUPUESTO DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de eliminación
    if operacion = 2 then 
    	delete from solicitud_presupuesto_det	 
    	where solpre_codigo=solprecodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'LA SOLICITUD DE PRESUPUESTO DETALLE FUE ELIMINADA CON EXITO';
    end if;
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
-- Definimos las variables
declare pedcoAudit text;
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
	     insert into pedido_compra_cab(pedco_codigo, pedco_fecha, pedco_estado, suc_codigo, emp_codigo, usu_codigo)
		 values(pedcocodigo, pedcofecha, 'PENDIENTE', succodigo, empcodigo, usucodigo);
		 raise notice 'EL PEDIDO DE COMPRA FUE REGISTRADO CON EXITO';
    end if;
	-- Validamos la operacion de anulacion
    if operacion = 2 then 
		-- Si ya se encuentra asociado un pedido a un presupuesto en un estado distinto a anulado 
		perform 1 from pedido_presupuesto pp 
		join pedido_compra_cab pcc on pcc.pedco_codigo=pp.pedco_codigo 
		join presupuesto_proveedor_cab ppc on ppc.prepro_codigo=pp.prepro_codigo 
		where pp.pedco_codigo=pedcocodigo and ppc.prepro_estado <> 'ANULADO';
		if found then
			-- En caso de ser asi, generamos una excepcion
			raise exception 'asociado';
		elseif operacion = 2 then
			update pedido_compra_cab 
			set pedco_estado='ANULADO', usu_codigo=usucodigo
			where pedco_codigo=pedcocodigo;
			raise notice 'EL PEDIDO DE COMPRA FUE ANULADO CON EXITO';
		end if;
    end if;
	-- Consultamos el audit anterior
	select coalesce(pedco_audit, '') into pedcoAudit from pedido_compra_cab where pedco_codigo = pedcocodigo;
	-- A los datos anteriores le agregamos los nuevos
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
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		-- Validamos que no se repota el ítem en el detalle
     	perform * from pedido_compra_det
     	where it_codigo=itcodigo and pedco_codigo=pedcocodigo;
     	if found then
			 -- Si es asi, generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
		     insert into pedido_compra_det(pedco_codigo, it_codigo, tipit_codigo, pedcodet_cantidad, pedcodet_precio)
			 values(pedcocodigo, itcodigo, tipitcodigo, pedcodetcantidad, pedcodetprecio);
			 raise notice 'EL PEDIDO DE COMPRA DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de eliminación
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
-- Definimos las variables
declare ultCodPedidoPresupuesto integer;
declare preproAudit text;
begin 
	 -- Validamos la operacion de insercion 
     if operacion = 1 then
		 -- Guardamos el serial de pedido_presupuesto
	 	 ultCodPedidoPresupuesto = (select coalesce(max(pedpre_codigo),0)+1 from pedido_presupuesto);
		 -- Validamos si la fecha actual es mayor a la fecha de vencimiento
     	 if preprofechaactual > preprofechavencimiento then
			-- En caso de ser asi, generamos un excepcion
     	 	raise exception 'fecha';
     	 end if;
		 -- Validamos que no se repita el presupuesto de un pedido de compra por el mismo proveedor
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
			 -- En caso de ser asi, generamos un excepcion
     		 raise exception 'pedido';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro 
     	 elseif operacion = 1 then
		     insert into presupuesto_proveedor_cab(prepro_codigo, prepro_fechaactual, prepro_estado, prepro_fechavencimiento, usu_codigo,
		     pro_codigo, tipro_codigo, suc_codigo, emp_codigo)
			 values(preprocodigo, preprofechaactual, 'ACTIVO', preprofechavencimiento, usucodigo, procodigo, tiprocodigo,
			 succodigo, empcodigo);
			 -- Insertamos datos en tabla intermedia de relacion pedido_presupuesto
			 insert into pedido_presupuesto(pedco_codigo, prepro_codigo, pedpre_codigo)
			 values(pedcocodigo, preprocodigo, ultCodPedidoPresupuesto);
			 -- Cargamos la columna de auditoria de pedido presupuesto
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
			 -- Se envia un mensaje de confirmacion
			 raise notice 'EL PRESUPUESTO DEL PROVEEDOR FUE REGISTRADO CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de anulacion
    if operacion = 2 then 
		-- Validamos si ya se encuentra asociado un presupuesto a una orden y tiene un estado distinto a anulado 
		perform 1 from presupuesto_orden po 
		join presupuesto_proveedor_cab ppc on ppc.prepro_codigo=po.prepro_codigo 
		join orden_compra_cab occ on occ.orcom_codigo=po.orcom_codigo 
		where po.prepro_codigo=preprocodigo and occ.orcom_estado <> 'ANULADO';
		if found then
			-- En caso de ser asi, generamos una excepcion
			raise exception 'asociado';		
		elseif operacion = 2 then
			update presupuesto_proveedor_cab 
			set prepro_estado='ANULADO', usu_codigo=usucodigo
			where prepro_codigo=preprocodigo;
			-- Se envia un mensaje de confirmacion
			raise notice 'EL PRESUPUESTO DEL PROVEEDOR FUE ANULADO CON EXITO';
		end if;
    end if;
	-- Consultamos el audit anterior
	select coalesce(prepro_audit, '') into preproAudit from presupuesto_proveedor_cab where prepro_codigo = preprocodigo;
	-- A los datos anteriores le agregamos los nuevos
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
    operacion integer
) returns void as
$function$
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		-- Validamos que no se repota el ítem en el detalle
     	perform * from presupuesto_proveedor_det
     	where it_codigo=itcodigo and prepro_codigo=preprocodigo;
     	if found then
			 -- Si es asi, generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
		     insert into presupuesto_proveedor_det(prepro_codigo, it_codigo, tipit_codigo, peprodet_cantidad, peprodet_precio)
			 values(preprocodigo, itcodigo, tipitcodigo, peprodetcantidad, peprodetprecio);
			 raise notice 'EL PRESUPUESTO PROVEEDOR DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de eliminación
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
-- Definimos las variables
declare 
	ultCodPresupuestoOrden integer;
	orcomAudit text;
	preproAudit text;
	pedcoAudit text;
	c_presupuesto_det cursor is
		select 
  		ppd.it_codigo,
  		ppd.tipit_codigo,
  		ppd.peprodet_cantidad as cantidad,
  		ppd.peprodet_precio as precio
		from presupuesto_proveedor_det ppd 
		where ppd.prepro_codigo=preprocodigo;
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
	 -- Validamos la operacion de insercion 
     if operacion = 1 then
		 -- Guardamos el serial de presupuesto_orden
		 ultCodPresupuestoOrden = (select coalesce(max(presor_codigo),0)+1 from presupuesto_orden);
		 -- Se inserta datos en orden compra cabecera
	     insert into orden_compra_cab(orcom_codigo, orcom_fecha, orcom_condicionpago, orcom_cuota, orcom_interfecha,
	     orcom_estado, usu_codigo, pro_codigo, tipro_codigo, suc_codigo, emp_codigo, orcom_montocuota)
		 values(orcomcodigo, orcomfecha, orcomcondicionpago, orcomcuota, orcominterfecha, 'ACTIVO', usucodigo, procodigo, tiprocodigo,
		 succodigo, empcodigo, orcommontocuota);
		 -- Se inserta datos en presupuesto orden
		 insert into presupuesto_orden(orcom_codigo, prepro_codigo, presor_codigo)
		 values(orcomcodigo, preprocodigo, ultCodPresupuestoOrden);
		 --Actualizamos el estado del presupuesto proveedor cabecera seleccionado
		 update presupuesto_proveedor_cab set prepro_estado='APROBADO', usu_codigo=usucodigo where prepro_codigo=preprocodigo;
		 --Actualizamos el estado del pedido compra cabecera que se haya ordenado
		 update pedido_compra_cab set pedco_estado='APROBADO', usu_codigo=usucodigo where pedco_codigo=pedcocodigo;
		 -- Auditamos movimiento de presupuesto_orden
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
		 -- Insertamos datos de detalle de orden compra 
		 for predet in c_presupuesto_det loop
			-- Recorremos el detalle de presupuesto de forma indivdualizada y cargamos el detalle de orden compra en cada recorrido
			perform sp_orden_compra_det(orcomcodigo, predet.it_codigo, predet.tipit_codigo, predet.cantidad, predet.precio, 1, 0, orcomcuota, usucodigo);
		 end loop;
		 -- Se envia un mensaje de confirmacion
		 raise notice 'LA ORDEN DE COMPRA FUE REGISTRADA CON EXITO';
    end if;
	-- Validamos la operacion de anulacion
    if operacion = 2 then 
	    -- Validamos si ya se encuentra asociado la orden de compra a una compra y si la compra tiene un estado distinto a anulado 
		perform 1 from orden_compra oc 
		join orden_compra_cab occ on occ.orcom_codigo=oc.orcom_codigo
		join compra_cab cc on cc.comp_codigo=oc.comp_codigo 
		where oc.orcom_codigo=orcomcodigo and cc.comp_estado <> 'ANULADO';
		if found then
			-- En caso de ser asi, generamos una excepcion
			raise exception 'asociado';		
		elseif operacion = 2 then
			--Anulamos la orden de compra cabecera
    		update orden_compra_cab 
			set orcom_estado='ANULADO', usu_codigo=usucodigo
			where orcom_codigo=orcomcodigo;
			--Activamos de nuevo el presupesto 
			update presupuesto_proveedor_cab set prepro_estado='ACTIVO', usu_codigo=usucodigo where prepro_codigo=preprocodigo;
			--Activamos el pedido de compra asociado al presupuesto
			update pedido_compra_cab set pedco_estado='ACTIVO', usu_codigo=usucodigo where pedco_codigo=pedcocodigo;
			-- Se envia un mensaje de confirmacion
			raise notice 'LA ORDEN DE COMPRA FUE ANULADA CON EXITO';
		end if;
    end if;
	-- Consultamos el audit anterior
	select coalesce(orcom_audit, '') into orcomAudit from orden_compra_cab where orcom_codigo = orcomcodigo;
	-- A los datos anteriores le agregamos los nuevos
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
    operacion integer,
    cabecera_detalle integer,-- 0 cabecera - 1 detalle
    orcomcuota integer,
    usucodigo integer
) returns void as
$function$
-- Definimos las variables a utilizar
declare suma_detalle numeric;
		monto_cuota numeric;
		orcomAudit text;
		c_orden cursor is
		select 
		occ.usu_codigo,
		u.usu_login,
		occ.orcom_fecha,
		occ.orcom_condicionpago,
		occ.orcom_cuota,
		occ.orcom_montocuota,
		occ.orcom_interfecha,
		occ.pro_codigo,
		p.pro_razonsocial,
		occ.tipro_codigo,
		tp.tipro_descripcion,
		occ.emp_codigo,
		e.emp_razonsocial,
		occ.suc_codigo,
		s.suc_descripcion,
		occ.orcom_estado 
		from orden_compra_cab occ 
		join usuario u on u.usu_codigo=occ.usu_codigo
		join proveedor p on p.pro_codigo=occ.pro_codigo
		and p.tipro_codigo=occ.tipro_codigo 
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
		join sucursal s on s.suc_codigo=occ.suc_codigo 
		and s.emp_codigo=occ.emp_codigo 
		join empresa e on e.emp_codigo=s.emp_codigo 
		where occ.orcom_codigo=orcomcodigo;
begin 
	 -- Validamos la operacion de insercion
     if (operacion = 1 and cabecera_detalle = 0) or (operacion = 1 and cabecera_detalle = 1) then
		-- Validamos que no se repita el ítem en el detalle
     	perform * from orden_compra_det
     	where it_codigo=itcodigo and orcom_codigo=orcomcodigo;
     	if found then
			 -- Si es asi, generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
			 -- Si los parametros pasan la validación, procedemos con la insercion
		     insert into orden_compra_det(orcom_codigo, it_codigo, tipit_codigo, orcomdet_cantidad, orcomdet_precio)
			 values(orcomcodigo, itcodigo, tipitcodigo, orcomdetcantidad, orcomdetprecio);
			 -- Se envia un mensaje de confirmacion
			 raise notice 'LA ORDEN COMPRA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de eliminación
    if (operacion = 2 and cabecera_detalle = 0) or (operacion = 2 and cabecera_detalle = 1) then 
		-- Procedemos con la eliminacion
    	delete from orden_compra_det	 
    	where orcom_codigo=orcomcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'LA ORDEN COMPRA DETALLE FUE ELIMINADA CON EXITO';
    end if;
	-- Validamos que cuando se inserte o elimine en detalle, se actualice el monto cuota de cabecera
	if (operacion = 1 and cabecera_detalle = 1) or (operacion = 2 and cabecera_detalle = 1) then
		-- Realizamos la sumatoria y guardamos en una variable
		select coalesce(sum(case ocd.tipit_codigo when 3 then ocd.orcomdet_precio else ocd.orcomdet_cantidad*ocd.orcomdet_precio end),0) into suma_detalle 
		from orden_compra_det ocd where ocd.orcom_codigo = orcomcodigo;
		-- Calculamos el nuevo monto de orcom_montocuota
		select round(suma_detalle/orcomcuota) into monto_cuota;
		-- Definimos el nuevo orcom_montocuota
		update orden_compra_cab set orcom_montocuota=monto_cuota, usu_codigo=usucodigo where orcom_codigo=orcomcodigo;
		-- Una vez actualizado la cabecera, la auditamos
		-- Consultamos el audit anterior
		select coalesce(orcom_audit, '') into orcomAudit from orden_compra_cab where orcom_codigo = orcomcodigo;
		-- A los datos anteriores le agregamos los nuevos
		for orden in c_orden loop
	       	 	update orden_compra_cab 
				set orcom_audit = orcomAudit||''||json_build_object(
				'usu_codigo', orden.usu_codigo,
				'usu_login', orden.usu_login,
				'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
				'procedimiento', 'MODIFICACION',
				'orcom_fecha', orden.orcom_fecha,
				'orcom_condicionpago', orden.orcom_condicionpago,
				'orcom_cuota', orden.orcom_cuota,
				'orcom_montocuota', orden.orcom_montocuota,
				'orcom_interfecha', upper(orden.orcom_interfecha),
				'pro_codigo', orden.pro_codigo,
				'pro_razonsocial', upper(orden.pro_razonsocial),
				'tipro_codigo', orden.tipro_codigo,
				'tipro_descripcion', upper(orden.tipro_descripcion),
				'emp_codigo', orden.emp_codigo,
				'emp_razonsocial', upper(orden.emp_razonsocial),
				'suc_codigo', orden.suc_codigo,
				'suc_descripcion', upper(orden.suc_descripcion),
				'orcom_estado', upper(orden.orcom_estado)
				)||','
				where orcom_codigo = orcomcodigo;
        end loop;
	end if;
end
$function$ 
language plpgsql;

--Ajuste Stock Cabecera
create or replace function sp_ajuste_stock_cab(
    ajuscodigo integer,
    ajusfecha date,
    ajustipoajuste tipo_ajuste,
    ajusestado varchar,
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
-- Definimos las variables a utilizar
declare ajusteDet record;
		cantidadStockAuditoria numeric;
		ajusAudit text;
begin
	-- Validamos la operacion de insercion
    if operacion = 1 then
		 -- Insertamos un nuevo registro
	     insert into ajuste_stock_cab(ajus_codigo, ajus_fecha, ajus_tipoajuste, ajus_estado, suc_codigo, emp_codigo, usu_codigo)
		 values(ajuscodigo, ajusfecha, ajustipoajuste, 'ACTIVO', succodigo, empcodigo, usucodigo);
		 -- Enviamos un mensaje de confirmacion
		 raise notice 'EL AJUSTE DE STOCK FUE REGISTRADO CON EXITO';
    end if;
	-- Validamos la operacion de anulacion
    if operacion = 2 then 
		-- Actualizamos el estado de cabecera a Anulado
    	update ajuste_stock_cab 
		set ajus_estado='ANULADO', usu_codigo=usucodigo
		where ajus_codigo=ajuscodigo;
		--Actualizamos el stock en caso de anular la cabecera
	    if ajustipoajuste='POSITIVO' then
			-- Si es positivo restamos
	    	for ajusteDet in select * from ajuste_stock_det where ajus_codigo=ajuscodigo loop
	       	 	update stock set st_cantidad=st_cantidad-ajusteDet.ajusdet_cantidad 
				where it_codigo=ajusteDet.it_codigo and tipit_codigo=ajusteDet.tipit_codigo and dep_codigo=ajusteDet.dep_codigo
				and suc_codigo=ajusteDet.suc_codigo and emp_codigo=ajusteDet.emp_codigo;
				-- Auditamos nueva cantidad de stock
				select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=ajusteDet.it_codigo and s.tipit_codigo=ajusteDet.tipit_codigo
				and s.dep_codigo=ajusteDet.dep_codigo and s.suc_codigo=ajusteDet.suc_codigo and s.emp_codigo=ajusteDet.emp_codigo;
				-- Procedemos con el audit del registro modificado
				perform sp_stock(ajusteDet.it_codigo, ajusteDet.tipit_codigo, ajusteDet.dep_codigo, ajusteDet.suc_codigo, 
				ajusteDet.emp_codigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
        	end loop;
        elseif ajustipoajuste='NEGATIVO' then
			-- Si es negativo sumamos
        	for ajusteDet in select * from ajuste_inventario_det where ajuin_codigo=ajuincodigo loop
	       	 	update stock set st_cantidad=st_cantidad+ajusteDet.ajusdet_cantidad 
				where it_codigo=ajusteDet.it_codigo and tipit_codigo=ajusteDet.tipit_codigo and dep_codigo=ajusteDet.dep_codigo
				and suc_codigo=ajusteDet.suc_codigo and emp_codigo=ajusteDet.emp_codigo;
				-- Auditamos nueva cantidad de stock
				select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=ajusteDet.it_codigo and s.tipit_codigo=ajusteDet.tipit_codigo
				and s.dep_codigo=ajusteDet.dep_codigo and s.suc_codigo=ajusteDet.suc_codigo and s.emp_codigo=ajusteDet.emp_codigo;
				-- Procedemos con el audit del registro modificado
				perform sp_stock(ajusteDet.it_codigo, ajusteDet.tipit_codigo, ajusteDet.dep_codigo, ajusteDet.suc_codigo, 
				ajusteDet.emp_codigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
        	end loop;
	    end if;
		-- Enviamos un mensaje de confirmacion
		raise notice 'EL AJUSTE DE STOCK FUE ANULADO CON EXITO';
    end if;
	--AJUSTE STOCK CABECERA AUDITORIA
	-- Consultamos el audit anterior de ajuste inventario cabecera
	select coalesce(aju.ajus_audit, '') into ajusAudit from ajuste_stock_cab aju where aju.ajus_codigo=ajuscodigo;
	-- A los datos anteriores le agregamos los nuevos
	update ajuste_stock_cab
	set ajus_audit = ajusAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'ajus_fecha', ajusfecha,
		'ajus_tipoajuste', ajustipoajuste,
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'ajus_estado', upper(ajusestado)
	)||','
	where ajus_codigo = ajuscodigo;
end
$function$ 
language plpgsql;

--Ajuste Stock Detalle
create or replace function sp_ajuste_stock_det(
    ajuscodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    ajusdetcantidad numeric,
    ajusdetprecio numeric,
    ajusdetmotivo varchar,
    ajustipoajuste varchar,
    usucodigo integer,
    usulogin varchar,
    operacion integer 
) returns void as
$function$
declare cantidadStockAuditoria numeric;
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		-- Validamos que no se repita el item y deposito en un mismo detalle de ajuste
     	perform * from ajuste_stock_det
     	where it_codigo=itcodigo and dep_codigo=depcodigo and ajus_codigo=ajuscodigo;
     	if found then
			 -- En caso de ser asi, generamos una excepcion
     		 raise exception 'item';
		-- Si los parametros superan la validacion se procede con la persistencia
     	elseif operacion = 1 then
     	 	 --Insertamos detalle de ajuste
		     insert into ajuste_stock_det(ajus_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo,
		     emp_codigo, ajusdet_cantidad, ajusdet_precio, ajusdet_motivo)
			 values(ajuscodigo, itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, ajusdetcantidad, ajusdetprecio, upper(ajusdetmotivo));
			 --Actualizamos el stock en caso de que sea positivo o negativo
			 if ajustipoajuste='POSITIVO' then
				-- Si es positivo sumamos
			 	update stock set st_cantidad=st_cantidad+ajusdetcantidad 
			 	where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			 	and suc_codigo=succodigo and emp_codigo=empcodigo;
				-- Auditamos nueva cantidad de stock
				select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
				and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
				-- Procedemos con el audit del registro modificado
				perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
			 elseif ajuintipoajuste='NEGATIVO' then
				-- Si es negativo restamos
			 	update stock set st_cantidad=st_cantidad-ajusdetcantidad 
			 	where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			 	and suc_codigo=succodigo and emp_codigo=empcodigo;
				-- Auditamos nueva cantidad de stock
				select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
				and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
				-- Procedemos con el audit del registro modificado
				perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
			 end if;
			 -- Se envia mensaje de confirmacion
			 raise notice 'EL AJUSTE STOCK DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de eliminacion
    if operacion = 2 then 
    	--Eliminamos el item y devolvemos la cantidad
    	delete from ajuste_stock_det 
    	where ajus_codigo=ajuscodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
        and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
       	--Actualizamos el stock en caso de eliminar un registro
        if ajustipoajuste='POSITIVO' then
			-- Si es positivo restamos
			 update stock set st_cantidad=st_cantidad-ajusdetcantidad 
			 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			 and suc_codigo=succodigo and emp_codigo=empcodigo;
			-- Auditamos nueva cantidad de stock
			select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
			and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			-- Procedemos con el audit del registro modificado
			perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
        elseif ajustipoajuste='NEGATIVO' then
			-- Si es negativo sumamos
        	update stock set st_cantidad=st_cantidad+ajusdetcantidad 
			 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			 and suc_codigo=succodigo and emp_codigo=empcodigo;
			-- Auditamos nueva cantidad de stock
			select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
			and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			-- Procedemos con el audit del registro modificado
			perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
	    end if;
		-- Se envia mensaje de confirmacion
		raise notice 'EL AJUSTE STOCK DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Compra Cabecera
create or replace function sp_compra_cab(
    compcodigo integer,
    compfecha date,
    compnumfactura varchar,
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
    comptimbradovenc date,
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
-- Definimos las variables
declare compraDet record;
		ultCodOrdenCompra integer;
		ultCodLibroCompra integer;
		compAudit text;
		orcomAudit text;
		licomAudit text;
		cuenpaAudit text;
		proAudit text;
		modificacionTimbrado integer;
		cantidadStockAuditoria numeric;
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
		c_proveedor cursor is
		select 
		p.pro_razonsocial,
		p.tipro_codigo,
		tp.tipro_descripcion,
		p.pro_ruc,
		p.pro_timbrado,
		p.pro_timbrado_venc,
		p.pro_direccion,
		p.pro_telefono,
		p.pro_email,
		p.pro_estado
		from proveedor p 
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
		where p.pro_codigo=procodigo;
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		ultCodOrdenCompra = (select coalesce(max(ordencom_codigo),0)+1 from orden_compra);
		ultCodLibroCompra = (select coalesce(max(licom_codigo),0)+1 from libro_compra);
		-- Validamos que no se repita el numero de factura, timbrado y estado activo
     	perform * from compra_cab
     	where comp_numfactura=compnumfactura and comp_timbrado=comptimbrado and comp_estado='ACTIVO';
     	if found then
     		 raise exception 'factura';
		-- Si los paramtros pasan la validacion procedemos con su insercion
     	elseif operacion = 1 then
		     insert into compra_cab(
			 comp_codigo, 
			 comp_fecha, 
			 comp_numfactura, 
			 comp_tipofactura, 
			 comp_cuota, 
			 comp_interfecha,
		     comp_estado, 
			 pro_codigo, 
      	     tipro_codigo, 
     		 suc_codigo, 
			 emp_codigo, 
			 usu_codigo, 	
			 comp_montocuota, 
			 comp_timbrado, 
			 tipco_codigo,
			 comp_timbrado_venc
			 )
			 values(
			 compcodigo, 
			 compfecha, 
			 compnumfactura, 
			 comptipofactura, 
			 compcuota, 
			 upper(compinterfecha), 
			 'ACTIVO', 
			 procodigo, 
			 tiprocodigo,
			 succodigo, 
			 empcodigo, 
			 usucodigo, 
			 compmontocuota, 
			 comptimbrado,  
			 tipcocodigo,
			 comptimbradovenc
			 );
			 -- Insertamos datos en orden compra
			 insert into orden_compra(comp_codigo, orcom_codigo, ordencom_codigo)
		 	 values(compcodigo, orcomcodigo, ultCodOrdenCompra);
			 -- Auditamos orden compra
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
		 	 -- Insertamos datos en libro compra
		 	 insert into libro_compra(licom_codigo, comp_codigo, licom_exenta, licom_iva5, licom_iva10, licom_fecha,
		 	 tipco_codigo, licom_numcomprobante, licom_estado)
		 	 values(ultCodLibroCompra, compcodigo, 0, 0, 0, compfecha, tipcocodigo, compnumfactura, 'ACTIVO');
		 	 -- Insertamos datos en cuenta pagar
		 	 insert into cuenta_pagar(comp_codigo, cuenpa_nrocuota, cuenpa_monto, cuenpa_saldo, cuenpa_estado)
		 	 values(compcodigo, compcuota, 0, 0, 'ACTIVO');
		 	 -- Actualizamos estado de orden
		 	 update orden_compra_cab set orcom_estado='COMPLETADO', usu_codigo=usucodigo where orcom_codigo=orcomcodigo;
			 -- Validamos si los datos de timbrado de proveedor son distintos
			 select (case when p.pro_timbrado <> comptimbrado then 1 else 0 end) 
			 into modificacionTimbrado from proveedor p where p.pro_codigo=procodigo;
			 -- Si son distintos se actualizan el timbrado y fecha vencimiento timbrado del proveedor
			 if modificacionTimbrado = 1 then
				-- Procedmos con la actualizacion
				update proveedor set pro_timbrado=comptimbrado, pro_timbrado_venc=comptimbradovenc where pro_codigo=procodigo;
				-- Auditamos proveedor
				select coalesce(pro_audit, '') into proAudit from proveedor where pro_codigo = procodigo;
				-- Recorremos el cursor de proveedor y actualizamos el audit
				for pro in c_proveedor loop
					update proveedor 
					set pro_audit = proAudit||''||json_build_object(
						'usu_codigo', usucodigo,
						'usu_login', usulogin,
						'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
						'procedimiento', 'MODIFICACION',
						'pro_razonsocial', upper(pro.pro_razonsocial),
						'tipro_codigo', pro.tipro_codigo,
						'tipro_descripcion', upper(pro.tipro_descripcion),
						'pro_ruc', pro.pro_ruc,
						'pro_timbrado', pro.pro_timbrado,
						'pro_timbrado_venc', pro.pro_timbrado_venc,
						'pro_direccion', upper(pro.pro_direccion),
						'pro_telefono', pro.pro_telefono,
						'pro_email', pro.pro_email,
						'pro_estado', upper(pro.pro_estado)
					)||','
					where pro_codigo = procodigo;
				end loop;
			 end if;
			  -- Se envia un mensaje de confirmacion
			 raise notice 'LA COMPRA FUE REGISTRADA CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de anulacion
    if operacion = 2 then 
		-- Validamos si ya se encuentra asociado compra a una nota de compra y si la nota de compra tiene un estado distinto a anulado 
		select 1 from nota_compra_cab ncc 
		where ncc.comp_codigo=compcodigo and ncc.nocom_estado <> 'ANULADO';
		if found then
			-- En caso de ser asi, generamos una excepcion
			raise exception 'asociado';		
		elseif operacion = 2 then
			-- Anulamos compra cabecera
	    	update compra_cab 
			set comp_estado='ANULADO', usu_codigo=usucodigo
			where comp_codigo=compcodigo;
		    -- Anulamos libro compra
		    update libro_compra set licom_estado='ANULADO' where comp_codigo=compcodigo;
		    -- Anulamos cuenta pagar
		    update cuenta_pagar set cuenpa_estado='ANULADO' where comp_codigo=compcodigo;
		    -- Activamos la orden compra seleccionada
		    update orden_compra_cab set orcom_estado='ACTIVO', usu_codigo=usucodigo where orcom_codigo=orcomcodigo;
		    --Actualizamos el stock 
		    for compraDet in select * from compra_det where comp_codigo=compcodigo loop
				-- Se resta cantidad de stock por item de detalle
		       	update stock set st_cantidad=st_cantidad-compraDet.compdet_cantidad 
				where it_codigo=compraDet.it_codigo and tipit_codigo=compraDet.tipit_codigo and dep_codigo=compraDet.dep_codigo
		        and suc_codigo=compraDet.suc_codigo and emp_codigo=compraDet.emp_codigo;
				-- Auditamos stock
				-- Consultamos cantidad recien modificada de stock
				select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo = compraDet.it_codigo and s.tipit_codigo=compraDet.tipit_codigo
				and s.dep_codigo = compraDet.dep_codigo and s.suc_codigo=compraDet.suc_codigo and s.emp_codigo=compraDet.emp_codigo;
				-- Pasamos los parametros para auditar stock
				perform sp_stock(compraDet.it_codigo, compraDet.tipit_codigo, compraDet.dep_codigo, compraDet.suc_codigo, compraDet.emp_codigo,
				cantidadStockAuditoria, 2, usucodigo, usulogin);
	        end loop;
			-- Se envia un mensaje de confirmacion
			raise notice 'LA COMPRA FUE ANULADA CON EXITO';
		end if;
    end if;
 	-- COMPRA CABECERA AUDITORIA
	-- Consultamos el audit anterior de compra cabecera
	select coalesce(cc.comp_audit, '') into compAudit from compra_cab cc where cc.comp_codigo=compcodigo;
	--a los datos anteriores le agregamos los nuevos
	update compra_cab
	set comp_audit = compAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'comp_fecha', compfecha,
		'comp_numfactura', compnumfactura,
		'comp_timbrado', comptimbrado,
		'comp_timbrado_venc', comptimbradovenc,
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
	-- ORDEN COMPRA CABECERA AUDITORIA
	-- Consultamos el audit anterior de orden compra cabecera
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
	-- LIBRO COMPRA AUDITORIA
	-- Consultamos el audit anterior de libro compra
	select coalesce(lc.licom_audit, '') into licomAudit from libro_compra lc where lc.comp_codigo=compcodigo;
	-- A los datos anteriores le agregamos los nuevos
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
	-- CUENTAS PAGAR AUDITORIA
	-- Consultamos el audit anterior de cuenta pagar
	select coalesce(cp.cuenpa_audit, '') into cuenpaAudit from cuenta_pagar cp where cp.comp_codigo=compcodigo;
	-- A los datos anteriores le agregamos los nuevos
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
    usucodigo integer,
    usulogin varchar,
    compcuota integer,
    operacion integer
) returns void as
$function$
declare cantidadStockAuditoria numeric;
		itemCosto numeric;
		suma_detalle numeric;
		monto_cuota numeric;
		itAudit text;
		compAudit text;
		c_items cursor is
		select 
        i.it_codigo,
        i.tipit_codigo,
        i.it_descripcion,
        i.it_costo,
        i.it_precio,
        i.it_estado,
        i.mod_codigo,
        i.tall_codigo,
        i.tipim_codigo,
        i.unime_codigo,
        ti.tipit_descripcion,
        m.mod_codigomodelo,
        t.tall_descripcion,
        tim.tipim_descripcion,
        um.unime_descripcion,
        i.it_stock_min, 
        i.it_stock_max
        from items i
        join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
        join modelo m on m.mod_codigo=i.mod_codigo
        join talle t on t.tall_codigo=i.tall_codigo 
        join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
        join unidad_medida um on um.unime_codigo=i.unime_codigo 
        where i.it_codigo=itcodigo;
		c_compra cursor is
		select 
		cc.comp_codigo,
		cc.comp_fecha,
		cc.comp_numfactura,
		cc.comp_timbrado,
		cc.comp_timbrado_venc,
		cc.comp_tipofactura,
		cc.comp_cuota,
		cc.comp_montocuota,
		cc.comp_interfecha,
		cc.comp_estado,
		cc.pro_codigo,
		cc.tipro_codigo,
		cc.emp_codigo,
		cc.suc_codigo,
		cc.usu_codigo,
		p.pro_razonsocial,
		tp.tipro_descripcion,
		cc.usu_codigo,
		u.usu_login,
		s.suc_descripcion,
		e.emp_razonsocial,
		oc.orcom_codigo,
		cc.tipco_codigo,
		tc.tipco_descripcion 
		from compra_cab cc
		join orden_compra oc on oc.comp_codigo=cc.comp_codigo
		join proveedor p on p.pro_codigo=cc.pro_codigo
		and p.tipro_codigo=cc.tipro_codigo
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
		join tipo_comprobante tc on tc.tipco_codigo=cc.tipco_codigo 
		join usuario u on u.usu_codigo=cc.usu_codigo
		join sucursal s on s.suc_codigo=cc.suc_codigo
		and s.emp_codigo=cc.emp_codigo
		join empresa e on e.emp_codigo=s.emp_codigo
		where cc.comp_codigo=compcodigo;
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		-- Validamos que no se repita el item en el detalle de compra
     	perform * from compra_det
     	where it_codigo=itcodigo and dep_codigo=depcodigo and comp_codigo=compcodigo;
     	if found then
			 -- En caso de ser asi, generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
			 -- Validamos si es que el item junto al deposito existen o esta registrado en stock
			 perform * from stock
     		 where it_codigo=itcodigo and tipit_codigo=tipitcodigo 
			 and dep_codigo=depcodigo and suc_codigo=succodigo 
			 and emp_codigo=empcodigo;
			 if found then
				-- En caso de que si se encuentre, sumamos la cantidad
				 update stock set st_cantidad=st_cantidad+compdetcantidad 
				 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
				 and suc_codigo=succodigo and emp_codigo=empcodigo;
				-- Auditamos nueva cantidad de stock
				select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
				and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
				-- Procedemos con el audit del registro modificado
				perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
			 else	
				 -- Si no existe lo registramos
				 -- Materia prima o utilitario
				 if tipitcodigo in(1, 4) then
					--Si es materia prima o utilitario cargamos el item en stock
					perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, compdetcantidad, 1, usucodigo, usulogin);
				 else
					-- Servicio
					-- Si es un servicio mantenemos la cantidad en 0
					perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, 0, 1, usucodigo, usulogin);
				 end if;
             end if;
     	 	 --Insertamos detalle compra
		     insert into compra_det(comp_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo,
		     emp_codigo, compdet_cantidad, compdet_precio)
			 values(compcodigo, itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, compdetcantidad, compdetprecio);
			 -- Validamos que  el precio del item detalle no sea distinto al almacenado en caso de ser materia prima o utilitario
			 if	tipitcodigo in(1,4) then
				-- Consultamos el costo para validar
				select i.it_costo into itemCosto from items i where i.it_codigo=itcodigo;
				-- Validamos si es distinto a lo pasado en detalle
				if itemCosto <> compdetprecio then
					-- Actualizamos la columna de costo de item
					update items set it_costo=compdetprecio where it_codigo=itcodigo;
					-- Auditamos la modifcacion de items
					select coalesce(it_audit, '') into itAudit from items where it_codigo = itcodigo;
					-- Recorremos el cursor de items
					for item in c_items loop
						update items 
						set it_audit = itAudit||''||json_build_object(
							'usu_codigo', usucodigo,
							'usu_login', usulogin,
							'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
							'procedimiento', 'MODIFICACION',
							'it_descripcion', upper(item.it_descripcion),
							'tipit_codigo', item.tipit_codigo,
							'tipit_descripcion', upper(item.tipit_descripcion),
							'tipim_codigo', item.tipim_codigo,
							'tipim_descripcion', upper(item.tipim_descripcion),
							'it_costo', item.it_costo,
							'it_precio', item.it_precio,
							'mod_codigo', item.mod_codigo,
							'mod_codigomodelo', item.mod_codigomodelo,
							'tall_codigo', item.tall_codigo,
							'tall_descripcion', item.tall_descripcion,
							'unime_codigo', item.unime_codigo,
							'unime_descripcion', upper(item.unime_descripcion),
							'it_stock_min', item.it_stock_min,
							'it_stock_max', item.it_stock_max,
							'it_estado', upper(item.it_estado)
						)||','
						where it_codigo = itcodigo;
					end loop;
				end if;
			 end if;
			 -- Se envia mensaje de confirmacion
			 raise notice 'LA COMPRA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de eliminacion
    if operacion = 2 then 
    	-- Eliminamos el item y devolvemos la cantidad
    	delete from compra_det 
    	where comp_codigo=compcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
        and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
       	-- Actualizamos el stock 
		update stock set st_cantidad=st_cantidad-compdetcantidad 
		where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		and suc_codigo=succodigo and emp_codigo=empcodigo;
		-- Auditamos nueva cantidad de stock
		select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
		and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
		-- Procedemos con el audit del registro modificado
		perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
		-- Se envia mensaje de confirmacion
		raise notice 'LA COMPRA DETALLE FUE ELIMINADA CON EXITO';
    end if;
	-- Validamos la operacion de insercion y eliminacion
	if operacion in(1,2) then
		-- Realizamos la sumatoria del detalle y guardamos en una variable
		select coalesce(sum(case cd.tipit_codigo when 3 then cd.compdet_precio else cd.compdet_cantidad*cd.compdet_precio end), 0) into suma_detalle 
		from compra_det cd where cd.comp_codigo = compcodigo;
		-- Calculamos el nuevo monto de comp_montocuota
		select round(suma_detalle/compcuota) into monto_cuota;
		-- Definimos el nuevo comp_montocuota
		update compra_cab set comp_montocuota=monto_cuota, usu_codigo=usucodigo where comp_codigo=compcodigo;
		-- Una vez actualizado la cabecera, la auditamos
		-- Consultamos el audit anterior de compra cabecera
		select coalesce(cc.comp_audit, '') into compAudit from compra_cab cc where cc.comp_codigo=compcodigo;
		-- A los datos anteriores le agregamos los nuevos
		for compra in c_compra loop
			update compra_cab
			set comp_audit = compAudit||''||json_build_object(
				'usu_codigo', compra.usu_codigo,
				'usu_login', compra.usu_login,
				'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
				'procedimiento', 'MODIFICACION',
				'comp_fecha', compra.comp_fecha,
				'comp_numfactura', compra.comp_numfactura,
				'comp_timbrado', compra.comp_timbrado,
				'comp_timbrado_venc', compra.comp_timbrado_venc,
				'comp_tipofactura', compra.comp_tipofactura,
				'comp_cuota', compra.comp_cuota,
				'comp_montocuota', compra.comp_montocuota,
				'comp_interfecha', upper(compra.comp_interfecha),
				'tipco_codigo', compra.tipco_codigo,
				'tipco_descripcion', upper(compra.tipco_descripcion),
				'pro_codigo', compra.pro_codigo,
				'pro_razonsocial', upper(compra.pro_razonsocial),
				'tipro_codigo', compra.tipro_codigo,
				'tipro_descripcion', upper(compra.tipro_descripcion),
				'emp_codigo', compra.emp_codigo,
				'emp_razonsocial', upper(compra.emp_razonsocial),
				'suc_codigo', compra.suc_codigo,
				'suc_descripcion', upper(compra.suc_descripcion),
				'comp_estado', upper(compra.comp_estado)
			)||','
			where comp_codigo = compcodigo;
		end loop;
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
    nocomtimbrado varchar,
    nocomtimbradovenc date,
    nocomchapa varchar,
    nocomfuncionario integer,
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
declare
    -- Variables de auditoría
    nocomAudit text;
    licomAudit text;
    compAudit text;

    -- Variables de control
    ultCodLibroCompra integer;
    totalSuma numeric := 0;
	cantidadStockAuditoria numeric := 0;

    -- Cursor para recorrer detalles de la nota
    c_nota_det record;
    -- Cursor para recorrer compras relacionadas
    c_compra record;
    -- Cursor para recorrer libro de compras relacionado
    c_libro record;
begin
    -- 1. Operación: Insertar Nota
    if operacion = 1 then
        -- Buscamos siguiente código disponible en libro de compras
        select coalesce(max(licom_codigo),0)+1 into ultCodLibroCompra from libro_compra;

        -- Validamos si ya existe una nota con el mismo número, proveedor y tipo
        if exists (
            select 1 from nota_compra_cab
            where nocom_numeronota = nocomnumeronota
              and nocom_timbrado = nocomtimbrado
              and nocom_estado = 'ACTIVO'
        ) then
            raise exception 'nota';
        end if;

        -- Insertamos nueva cabecera de nota
        insert into nota_compra_cab(
            nocom_codigo, nocom_fecha, nocom_numeronota, nocom_concepto,
            nocom_estado, tipco_codigo, suc_codigo, emp_codigo,
            usu_codigo, comp_codigo, pro_codigo, tipro_codigo,
			nocom_timbrado, nocom_timbrado_venc, nocom_chapa, nocom_funcionario
        ) values (
            nocomcodigo, nocomfecha, nocomnumeronota, upper(nocomconcepto),
            'ACTIVO', tipcocodigo, succodigo, empcodigo,
            usucodigo, compcodigo, procodigo, tiprocodigo,
			nocomtimbrado, nocomtimbradovenc, nocomchapa, nocomfuncionario
        );

        -- Si corresponde, insertamos en libro de compras
        if tipcocodigo in (1,2) then
            insert into libro_compra(
                licom_codigo, comp_codigo, licom_exenta, licom_iva5, licom_iva10,
                licom_fecha, tipco_codigo, licom_numcomprobante, licom_estado
            ) values (
                ultCodLibroCompra, compcodigo, 0, 0, 0,
                nocomfecha, tipcocodigo, nocomnumeronota, 'ACTIVO'
            );
        end if;

        raise notice 'LA NOTA DE COMPRA FUE REGISTRADA CON EXITO';
    end if;

    -- 2. Operación: Anular Nota
    if operacion = 2 then
        -- Marcamos la nota como anulada
        update nota_compra_cab
        set nocom_estado = 'ANULADO', usu_codigo = usucodigo
        where nocom_codigo = nocomcodigo;

        -- Anulamos libro de compras relacionado
        update libro_compra
        set licom_estado = 'ANULADO'
        where comp_codigo = compcodigo
          and licom_numcomprobante = nocomnumeronota
          and tipco_codigo = tipcocodigo;

        -- Recorremos detalles para ajustar stock
        for c_nota_det in
            select it_codigo, tipit_codigo, nocomdet_cantidad, dep_codigo, suc_codigo, emp_codigo
            from nota_compra_det
            where nocom_codigo = nocomcodigo
        loop
            case tipcocodigo
                when 1 then -- Nota crédito: devolvemos stock
                    update stock
                    set st_cantidad = st_cantidad + c_nota_det.nocomdet_cantidad
                    where it_codigo = c_nota_det.it_codigo
                      and tipit_codigo = c_nota_det.tipit_codigo
                      and dep_codigo = c_nota_det.dep_codigo
                      and suc_codigo = c_nota_det.suc_codigo
                      and emp_codigo = c_nota_det.emp_codigo;
					-- Consultamos cantidad recien modificada de stock
					select s.st_cantidad into cantidadStockAuditoria 
					from stock s 
					where s.it_codigo = c_nota_det.it_codigo 
					  and s.tipit_codigo=c_nota_det.tipit_codigo
					  and s.dep_codigo = c_nota_det.dep_codigo 
					  and s.suc_codigo=c_nota_det.suc_codigo 
					  and s.emp_codigo=c_nota_det.emp_codigo;
					-- Pasamos los parametros para auditar stock
					perform sp_stock(c_nota_det.it_codigo, c_nota_det.tipit_codigo, c_nota_det.dep_codigo, 
							c_nota_det.suc_codigo, c_nota_det.emp_codigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
                when 2 then -- Nota débito: restamos stock
                    update stock
                    set st_cantidad = st_cantidad - c_nota_det.nocomdet_cantidad
                    where it_codigo = c_nota_det.it_codigo
                      and tipit_codigo = c_nota_det.tipit_codigo
                      and dep_codigo = c_nota_det.dep_codigo
                      and suc_codigo = c_nota_det.suc_codigo
                      and emp_codigo = c_nota_det.emp_codigo;
					-- Consultamos cantidad recien modificada de stock
					select s.st_cantidad into cantidadStockAuditoria 
					from stock s 
					where s.it_codigo = c_nota_det.it_codigo 
					  and s.tipit_codigo=c_nota_det.tipit_codigo
					  and s.dep_codigo = c_nota_det.dep_codigo 
					  and s.suc_codigo=c_nota_det.suc_codigo 
					  and s.emp_codigo=c_nota_det.emp_codigo;
					-- Pasamos los parametros para auditar stock
					perform sp_stock(c_nota_det.it_codigo, c_nota_det.tipit_codigo, c_nota_det.dep_codigo, 
							c_nota_det.suc_codigo, c_nota_det.emp_codigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
            end case;
        end loop;

        -- Sumamos subtotales de los detalles
        select coalesce(
		sum(case when ncd.tipit_codigo = 3 then ncd.nocomdet_precio else ncd.nocomdet_cantidad*ncd.nocomdet_precio end),0)
		into totalSuma 
		from nota_compra_det ncd 
		where ncd.nocom_codigo = nocomcodigo;

        -- Si hay monto, actualizamos cuentas por pagar
        if totalSuma > 0 then
            perform sp_cuenta_pagar(
                compcodigo, totalSuma, totalSuma,
                tipcocodigo, usucodigo, usulogin
            );
        end if;

        -- Si fue nota crédito, también reactivamos la compra asociada
        if tipcocodigo = 1 and totalSuma > 0 then
            update cuenta_pagar set cuenpa_estado='ACTIVO' where comp_codigo=compcodigo;
            update compra_cab set comp_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;

            -- Auditamos la compra asociada
            for c_compra in
                select cc.*, tc.tipco_descripcion, p.pro_razonsocial,
                       tp.tipro_descripcion, e.emp_razonsocial, s.suc_descripcion
                from compra_cab cc
                join tipo_comprobante tc on tc.tipco_codigo = cc.tipco_codigo
                join proveedor p on p.pro_codigo = cc.pro_codigo
                join tipo_proveedor tp on tp.tipro_codigo = p.tipro_codigo
                join sucursal s on s.suc_codigo = cc.suc_codigo and s.emp_codigo = cc.emp_codigo
                join empresa e on e.emp_codigo = s.emp_codigo
                where cc.comp_codigo = compcodigo
            loop
                select coalesce(comp_audit,'') into compAudit from compra_cab where comp_codigo=compcodigo;

                update compra_cab
                set comp_audit = compAudit || '' || json_build_object(
                    'usu_codigo', usucodigo,
                    'usu_login', usulogin,
                    'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
                    'procedimiento', 'MODIFICACION',
                    'comp_fecha', c_compra.comp_fecha,
                    'comp_numfactura', c_compra.comp_numfactura,
                    'comp_timbrado', c_compra.comp_timbrado,
					'comp_timbrado_venc', c_compra.comp_timbrado_venc,
                    'comp_tipofactura', c_compra.comp_tipofactura,
                    'comp_cuota', c_compra.comp_cuota,
                    'comp_montocuota', c_compra.comp_montocuota,
                    'comp_interfecha', c_compra.comp_interfecha,
                    'tipco_codigo', c_compra.tipco_codigo,
                    'tipco_descripcion', c_compra.tipco_descripcion,
                    'pro_codigo', c_compra.pro_codigo,
                    'pro_razonsocial', c_compra.pro_razonsocial,
                    'tipro_codigo', c_compra.tipro_codigo,
                    'tipro_descripcion', c_compra.tipro_descripcion,
                    'emp_codigo', c_compra.emp_codigo,
                    'emp_razonsocial', c_compra.emp_razonsocial,
                    'suc_codigo', c_compra.suc_codigo,
                    'suc_descripcion', c_compra.suc_descripcion,
                    'comp_estado', c_compra.comp_estado
                ) || ','
                where comp_codigo = compcodigo;
            end loop;
        end if;

        raise notice 'LA NOTA DE COMPRA FUE ANULADA CON EXITO';
    end if;

    -- 3. Auditoría de Nota Compra
    select coalesce(nocom_audit,'') into nocomAudit
    from nota_compra_cab
    where nocom_codigo = nocomcodigo;

    update nota_compra_cab
    set nocom_audit = nocomAudit || '' || json_build_object(
        'usu_codigo', usucodigo,
        'usu_login', usulogin,
        'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
        'procedimiento', upper(procedimiento),
        'nocom_fecha', nocomfecha,
        'nocom_numeronota', nocomnumeronota,
		'nocom_timbrado', nocomtimbrado,
		'nocom_timbrado_venc', nocomtimbradovenc,
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
		'nocom_chapa', nocomchapa,
		'nocom_funcionario', nocomfuncionario,
        'nocom_estado', upper(nocomestado)
    ) || ','
    where nocom_codigo = nocomcodigo;

    -- 4. Auditoría de Libro Compra
    select coalesce(licom_audit,'') into licomAudit
    from libro_compra
    where comp_codigo=compcodigo
      and licom_numcomprobante=nocomnumeronota
      and tipco_codigo=tipcocodigo;

    for c_libro in
        select comp_codigo, licom_exenta, licom_iva5, licom_iva10,
               licom_fecha, tipco_codigo, licom_numcomprobante, licom_estado
        from libro_compra
        where comp_codigo=compcodigo
          and licom_numcomprobante=nocomnumeronota
          and tipco_codigo=tipcocodigo
    loop
        update libro_compra
        set licom_audit = licomAudit || '' || json_build_object(
            'usu_codigo', usucodigo,
            'usu_login', usulogin,
            'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
            'procedimiento', upper(procedimiento),
            'comp_codigo', c_libro.comp_codigo,
            'licom_exenta', c_libro.licom_exenta,
            'licom_iva5', c_libro.licom_iva5,
            'licom_iva10', c_libro.licom_iva10,
            'licom_fecha', c_libro.licom_fecha,
            'tipco_codigo', c_libro.tipco_codigo,
            'tipco_descripcion', upper(tipcodescripcion),
            'licom_numcomprobante', c_libro.licom_numcomprobante,
            'licom_estado', c_libro.licom_estado
        ) || ','
        where comp_codigo=compcodigo
          and licom_numcomprobante=nocomnumeronota
          and tipco_codigo=tipcocodigo;
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
declare 
    -- Variables de trabajo
    notaMonto numeric;          -- monto actual de la cuenta por pagar
    compraEstado varchar;       -- estado actual de la cabecera de compra
    compAudit text;             -- texto acumulado para auditoría
	cantidadStockAuditoria numeric := 0;  --cantidad de stock actualizado para auditoria

    -- Cursor para traer datos de la cabecera de compra (para auditoría)
    c_compra_cab cursor is
        select 
            cc.comp_fecha,
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
        where cc.comp_codigo=compcodigo;
begin 
    -- Consultamos el monto y estado de la compra asociada
    select cp.cuenpa_monto into notaMonto from cuenta_pagar cp where cp.comp_codigo=compcodigo;
    select cc.comp_estado into compraEstado from compra_cab cc where cc.comp_codigo=compcodigo;	

    -- OPERACIÓN INSERT
    if operacion = 1 then
        -- Validamos si ya existe un detalle con los mismos datos
        perform 1 from nota_compra_det
        where it_codigo=itcodigo and tipit_codigo=tipitcodigo 
          and dep_codigo=depcodigo and suc_codigo=succodigo 
          and emp_codigo=empcodigo and nocom_codigo=nocomcodigo;
        if found then
            raise exception 'item'; -- ya existe, lanzamos error
        end if;

        -- Insertamos nuevo detalle
        insert into nota_compra_det(nocom_codigo, it_codigo, tipit_codigo, nocomdet_cantidad, 
									nocomdet_precio, dep_codigo, suc_codigo, emp_codigo)
        values(nocomcodigo, itcodigo, tipitcodigo, nocomdetcantidad, nocomdetprecio, depcodigo, succodigo, empcodigo);

        -- Ajustamos el stock según el tipo de comprobante
        if tipcocodigo = 1 then -- Nota de crédito: se descuenta del stock
            update stock set st_cantidad=st_cantidad-nocomdetcantidad 
            where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
              and suc_codigo=succodigo and emp_codigo=empcodigo;
			-- Auditamos nueva cantidad de stock
			select s.st_cantidad into cantidadStockAuditoria from stock s 
			where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
			 and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			-- Procedemos con el audit del registro modificado
			perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);

            -- Si el monto de la cuenta es 0, anulamos compra y cuenta pagar
            if notaMonto = 0 then 
                update cuenta_pagar set cuenpa_estado='ANULADO' where comp_codigo=compcodigo;
				-- Pasamos operacion 3 solo para auditar
                perform sp_cuenta_pagar(compcodigo, 0, 0, 3, usucodigo, usulogin);

                update compra_cab set comp_estado='ANULADO', usu_codigo=usucodigo where comp_codigo=compcodigo;
                -- Auditoría de compra cabecera
                for compra in c_compra_cab loop
                    select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
                    update compra_cab
                    set comp_audit = compAudit || '' || json_build_object(
                        'usu_codigo', usucodigo,
                        'usu_login', usulogin,
                        'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
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
                    where comp_codigo = compcodigo;
                end loop;
            end if;

        elseif tipcocodigo = 2 then -- Nota de débito: se suma al stock
            update stock set st_cantidad=st_cantidad+nocomdetcantidad 
            where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
              and suc_codigo=succodigo and emp_codigo=empcodigo;
			-- Auditamos nueva cantidad de stock
			select s.st_cantidad into cantidadStockAuditoria from stock s 
			where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
			 and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			-- Procedemos con el audit del registro modificado
			perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);

            -- Si la compra estaba anulada pero hay monto, se reactivan registros
            if notaMonto > 0 and compraEstado = 'ANULADO' then
                update cuenta_pagar set cuenpa_estado='ACTIVO' where comp_codigo=compcodigo;
				-- Pasamos operacion 3 solo para auditar
                perform sp_cuenta_pagar(compcodigo, 0, 0, 3, usucodigo, usulogin);

                update compra_cab set comp_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;

                for compra in c_compra_cab loop
                    select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
                    update compra_cab
                    set comp_audit = compAudit || '' || json_build_object(
                        'usu_codigo', usucodigo,
                        'usu_login', usulogin,
                        'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
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
                    where comp_codigo = compcodigo;
                end loop;
            end if;
        end if;

        raise notice 'LA NOTA DE COMPRA DETALLE FUE REGISTRADA CON EXITO';
    end if;

    -- OPERACIÓN DELETE
    if operacion = 2 then 
        -- Eliminamos el detalle
        delete from nota_compra_det 
        where nocom_codigo=nocomcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
          and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;

        -- Ajustamos stock según comprobante
        if tipcocodigo = 1 then -- Crédito: devolvemos al stock
            update stock set st_cantidad=st_cantidad+nocomdetcantidad 
            where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
              and suc_codigo=succodigo and emp_codigo=empcodigo;
			-- Auditamos nueva cantidad de stock
			select s.st_cantidad into cantidadStockAuditoria from stock s 
			where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
			 and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			-- Procedemos con el audit del registro modificado
			perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);

            if notaMonto > 0 and compraEstado = 'ANULADO' then	
                update cuenta_pagar set cuenpa_estado='ACTIVO' where comp_codigo=compcodigo;
                perform sp_cuenta_pagar(compcodigo, 0, 0, 3, usucodigo, usulogin);

                update compra_cab set comp_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;

                for compra in c_compra_cab loop
                    select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
                    update compra_cab
                    set comp_audit = compAudit || '' || json_build_object(
                        'usu_codigo', usucodigo,
                        'usu_login', usulogin,
                        'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
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
                    where comp_codigo = compcodigo;
                end loop;
            end if;

        elseif tipcocodigo = 2 then -- Débito: quitamos del stock
            update stock set st_cantidad=st_cantidad-nocomdetcantidad 
            where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
              and suc_codigo=succodigo and emp_codigo=empcodigo;
			-- Auditamos nueva cantidad de stock
			select s.st_cantidad into cantidadStockAuditoria from stock s 
			where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
			 and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			-- Procedemos con el audit del registro modificado
			perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
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