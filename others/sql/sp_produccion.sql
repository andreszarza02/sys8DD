--Procedimientos almacenados
--cargo
create or replace function sp_cargo(
    carcodigo integer,
    cardescripcion varchar,
    carestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare carAudit text; 
begin 
    if operacion in(1,2) then
        perform * from cargo
        where upper(car_descripcion) = upper(cardescripcion)
        and car_codigo != carcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into cargo(car_codigo, car_descripcion, car_estado)
				values(carcodigo, upper(cardescripcion), 'ACTIVO');
				raise notice 'EL CARGO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		UPDATE cargo
				SET car_descripcion=upper(cardescripcion), car_estado='ACTIVO'
				WHERE car_codigo=carcodigo;
				raise notice 'EL CARGO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	UPDATE cargo
		SET car_estado='INACTIVO'
		WHERE car_codigo=carcodigo;
		raise notice 'EL CARGO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(car_audit, '') into carAudit from cargo where car_codigo = carcodigo;
	--a los datos anteriores le agregamos los nuevos
	update cargo 
	set car_audit = carAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'car_descripcion', upper(cardescripcion),
		'car_estado', upper(carestado)
	)||','
	where car_codigo = carcodigo;
end
$function$ 
language plpgsql;

--Personas
create or replace function sp_personas(
    percodigo integer,
    pernombre varchar,
    perapellido varchar,
    pernumerodocumento varchar,
    pertelefono varchar,
    peremail varchar,
    perestado varchar,
    tipdocodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    tipdodescripcion varchar
) returns void as
$function$
declare perAudit text; 
begin 
    if operacion in(1,2) then
        perform * from personas
        where per_numerodocumento=pernumerodocumento
        and per_codigo != percodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into personas(per_codigo, per_nombre, per_apellido, per_numerodocumento, per_telefono,
	        	per_email, per_estado, tipdo_codigo)
				values(percodigo, upper(pernombre), upper(perapellido), pernumerodocumento, pertelefono, peremail, 'ACTIVO', tipdocodigo);
				raise notice 'LA PERSONA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update personas
				set per_nombre=upper(pernombre), per_apellido=upper(perapellido), per_numerodocumento=pernumerodocumento, 
				per_telefono=pertelefono, per_email=peremail, per_estado='ACTIVO', tipdo_codigo=tipdocodigo
				where per_codigo=percodigo;
				raise notice 'LA PERSONA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update personas 
		set per_estado='INACTIVO'
		where per_codigo=percodigo;
		raise notice 'LA PERSONA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(per_audit, '') into perAudit from personas where per_codigo = percodigo;
	--a los datos anteriores le agregamos los nuevos
	update personas 
	set per_audit = perAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'per_nombre', upper(pernombre),
		'per_apellido', upper(perapellido),
		'per_numerodocumento', pernumerodocumento,
		'per_email', peremail,
		'tipdo_codigo', tipdocodigo,
		'tipdo_descripcion', upper(tipdodescripcion),
		'per_estado', upper(perestado)
	)||','
	where per_codigo = percodigo;
end
$function$ 
language plpgsql;

--Funcionario
create or replace function sp_funcionario(
    funccodigo integer,
    funfechaingreso date,
    funcestado varchar,
    percodigo integer,
    ciucodigo integer,
    carcodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    pernumerodocumento varchar,
    persona varchar,
    ciudescripcion varchar,
    cardescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare funcAudit text;
begin 
    if operacion in(1,2) then
        perform * from funcionario
        where per_codigo=percodigo
        and func_codigo != funccodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into funcionario(func_codigo, fun_fechaingreso, func_estado, per_codigo, ciu_codigo,
	        	car_codigo, suc_codigo, emp_codigo)
				values(funccodigo, funfechaingreso, 'ACTIVO', percodigo, ciucodigo, carcodigo, succodigo, empcodigo);
				raise notice 'EL FUNCIONARIO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update funcionario
				set fun_fechaingreso=funfechaingreso, func_estado='ACTIVO', per_codigo=percodigo, ciu_codigo=ciucodigo,
				car_codigo=carcodigo, suc_codigo=succodigo, emp_codigo=empcodigo
				where func_codigo=funccodigo;
				raise notice 'EL FUNCIONARIO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update funcionario 
		set func_estado='INACTIVO'
		where func_codigo=funccodigo;
		raise notice 'EL FUNCIONARIO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(func_audit, '') into funcAudit from funcionario where func_codigo = funccodigo;
	--a los datos anteriores le agregamos los nuevos
	update funcionario 
	set func_audit = funcAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'fun_fechaingreso', funfechaingreso,
		'per_codigo', percodigo,
		'per_numerodocumento', pernumerodocumento,
		'persona', upper(persona),
		'ciu_codigo', ciucodigo,
		'ciu_descripcion', upper(ciudescripcion),
		'car_codigo', carcodigo,
		'car_descripcion', upper(cardescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'func_estado', upper(funcestado)
	)||','
	where func_codigo = funccodigo;
end
$function$ 
language plpgsql;

--Maquinaria
create or replace function sp_maquinaria(
    maqcodigo integer,
    maqdescripcion varchar,
    maqestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare maqAudit text;
begin 
    if operacion in(1,2) then
        perform * from maquinaria
        where upper(maq_descripcion) = upper(maqdescripcion)
        and maq_codigo != maqcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into maquinaria(maq_codigo, maq_descripcion, maq_estado)
				values((select coalesce(max(maq_codigo),0)+1 from maquinaria), upper(maqdescripcion), 'ACTIVO');
				raise notice 'LA MAQUINARIA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update maquinaria
				set maq_descripcion=upper(maqdescripcion), maq_estado='ACTIVO'
				where maq_codigo=maqcodigo;
				raise notice 'LA MAQUINARIA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update maquinaria
		set maq_estado='INACTIVO'
		where maq_codigo=maqcodigo;
		raise notice 'LA MAQUINARIA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(maq_audit, '') into maqAudit from maquinaria where maq_codigo = maqcodigo;
	--a los datos anteriores le agregamos los nuevos
	update maquinaria 
	set maq_audit = maqAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'maq_descripcion', upper(maqdescripcion),
		'maq_estado', upper(maqestado)
	)||','
	where maq_codigo = maqcodigo;
end
$function$ 
language plpgsql;

--Talle
create or replace function sp_talle(
    tallcodigo integer,
    talldescripcion varchar,
    tallestado varchar, 
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare tallAudit text; 
begin 
    if operacion in(1,2) then
        perform * from talle
        where upper(tall_descripcion) = upper(talldescripcion)
        and tall_codigo != tallcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into talle(tall_codigo, tall_descripcion, tall_estado)
				values(tallcodigo, upper(talldescripcion), 'ACTIVO');
				raise notice 'EL TALLE FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update talle
				set tall_descripcion=upper(talldescripcion), tall_estado='ACTIVO'
				where tall_codigo=tallcodigo;
				raise notice 'EL TALLE FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update talle
		set tall_estado='INACTIVO'
		where tall_codigo=tallcodigo;
		raise notice 'EL TALLE FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(tall_audit, '') into tallAudit from talle where tall_codigo = tallcodigo;
	--a los datos anteriores le agregamos los nuevos
	update talle 
	set tall_audit = tallAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tall_descripcion', upper(talldescripcion),
		'tall_estado', upper(tallestado)
	)||','
	where tall_codigo = tallcodigo;
end
$function$ 
language plpgsql;

--Color Prenda
create or replace function sp_talle(
    tallcodigo integer,
    talldescripcion varchar,
    tallestado varchar,
    operacion integer 
) returns void as
$function$
begin 
    if operacion in(1,2) then
        perform * from talle
        where upper(tall_descripcion) = upper(talldescripcion)
        and tall_codigo != tallcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into talle(tall_codigo, tall_descripcion, tall_estado)
				values((select coalesce(max(tall_codigo),0)+1 from talle), upper(talldescripcion), 'ACTIVO');
				raise notice 'EL TALLE FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update talle
				set tall_descripcion=upper(talldescripcion), tall_estado='ACTIVO'
				where tall_codigo=tallcodigo;
				raise notice 'EL TALLE FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update talle
		set tall_estado='INACTIVO'
		where tall_codigo=tallcodigo;
		raise notice 'EL TALLE FUE BORRADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Color prenda
create or replace function sp_color_prenda(
    colcodigo integer,
    coldescripcion varchar,
    colestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare colAudit text; 
begin 
    if operacion in(1,2) then
        perform * from color_prenda
        where upper(col_descripcion) = upper(coldescripcion)
        and col_codigo != colcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into color_prenda(col_codigo, col_descripcion, col_estado)
				values(colcodigo, upper(coldescripcion), 'ACTIVO');
				raise notice 'EL COLOR DE PRENDA FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update color_prenda
				set col_descripcion=upper(coldescripcion), col_estado='ACTIVO'
				where col_codigo=colcodigo;
				raise notice 'EL COLOR DE PRENDA FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update color_prenda
		set col_estado='INACTIVO'
		where col_codigo=colcodigo;
		raise notice 'EL COLOR DE PRENDA FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(col_audit, '') into colAudit from color_prenda where col_codigo = colcodigo;
	--a los datos anteriores le agregamos los nuevos
	update color_prenda 
	set col_audit = colAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'col_descripcion', upper(coldescripcion),
		'col_estado', upper(colestado)
	)||','
	where col_codigo = colcodigo;
end
$function$ 
language plpgsql;

--Modelo
create or replace function sp_modelo(
    modcodigo integer,
    modcodigomodelo varchar,
    modsexo sexo,
    modobservacion varchar,
    modestado varchar,
    colcodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    coldescripcion varchar
) returns void as
$function$
declare modAudit text;
begin 
    if operacion in(1,2) then
        perform * from modelo
        where mod_codigomodelo=modcodigomodelo
        and mod_codigo != modcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into modelo(mod_codigo, mod_codigomodelo, mod_sexo, mod_observacion, mod_estado, col_codigo)
				values(modcodigo, modcodigomodelo, modsexo, upper(modobservacion), 'ACTIVO', colcodigo);
				raise notice 'EL MODELO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update modelo
				set mod_codigomodelo=modcodigomodelo, mod_sexo=modsexo, mod_observacion=upper(modobservacion),
				mod_estado='ACTIVO', col_codigo=colcodigo
				where mod_codigo=modcodigo;
				raise notice 'EL MODELO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update modelo 
		set mod_estado='INACTIVO'
		where mod_codigo=modcodigo;
		raise notice 'EL MODELO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(mod_audit, '') into modAudit from modelo where mod_codigo = modcodigo;
	--a los datos anteriores le agregamos los nuevos
	update modelo 
	set mod_audit = modAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'mod_codigomodelo', modcodigomodelo,
		'col_codigo', colcodigo,
		'col_descripcion', upper(coldescripcion),
		'mod_sexo', modsexo,
		'mod_observacion', upper(modobservacion),
		'mod_estado', upper(modestado)
	)||','
	where mod_codigo = modcodigo;
end
$function$ 
language plpgsql;

--Tipo Etapa Produccion
create or replace function sp_tipo_etapa_produccion(
    tipetcodigo integer,
    tipetdescripcion varchar,
    tipetestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare tipetAudit text;
begin 
    if operacion in(1,2) then
        perform * from tipo_etapa_produccion
        where upper(tipet_descripcion) = upper(tipetdescripcion)
        and tipet_codigo != tipetcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into tipo_etapa_produccion(tipet_codigo, tipet_descripcion, tipet_estado)
				values(tipetcodigo, upper(tipetdescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE ETAPA DE PRODUCCION FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update tipo_etapa_produccion
				set tipet_descripcion=upper(tipetdescripcion), tipet_estado='ACTIVO'
				where tipet_codigo=tipetcodigo;
				raise notice 'EL TIPO DE ETAPA DE PRODUCCION FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update tipo_etapa_produccion
		set tipet_estado='INACTIVO'
		where tipet_codigo=tipetcodigo;
		raise notice 'EL TIPO DE ETAPA DE PRODUCCION FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(tipet_audit, '') into tipetAudit from tipo_etapa_produccion where tipet_codigo = tipetcodigo;
	--a los datos anteriores le agregamos los nuevos
	update tipo_etapa_produccion 
	set tipet_audit = tipetAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tipet_descripcion', upper(tipetdescripcion),
		'tipet_estado', upper(tipetestado)
	)||','
	where tipet_codigo = tipetcodigo;
end
$function$ 
language plpgsql;

--Unidad Medida
create or replace function sp_unidad_medida(
    unimecodigo integer,
    unimedescripcion varchar,
    unimeestado varchar,
    unimesimbolo varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare unimeAudit text;
begin 
    if operacion in(1,2) then
        perform * from unidad_medida
        where upper(unime_descripcion) = upper(unimedescripcion)
        and unime_codigo != unimecodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into unidad_medida(unime_codigo, unime_descripcion, unime_estado, unime_simbolo)
				values(unimecodigo, upper(unimedescripcion), 'ACTIVO', lower(unimesimbolo));
				raise notice 'LA UNIDAD DE MEDIDA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update unidad_medida
				set unime_descripcion=upper(unimedescripcion), unime_estado='ACTIVO', unime_simbolo=lower(unimesimbolo)
				where unime_codigo=unimecodigo;
				raise notice 'LA UNIDAD DE MEDIDA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update unidad_medida
		set unime_estado='INACTIVO'
		where unime_codigo=unimecodigo;
		raise notice 'LA UNIDAD DE MEDIDA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(unime_audit, '') into unimeAudit from unidad_medida where unime_codigo = unimecodigo;
	--a los datos anteriores le agregamos los nuevos
	update unidad_medida 
	set unime_audit = unimeAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'unime_descripcion', upper(unimedescripcion),
		'unime_simbolo', lower(unimesimbolo),
		'unime_estado', upper(unimeestado)
	)||','
	where unime_codigo = unimecodigo;
end
$function$ 
language plpgsql;

--Parametro Control Calidad
create or replace function sp_parametro_control_calidad(
    pacocacodigo integer,
    pacocadescripcion varchar,
    pacocaestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare pacocaAudit text;
begin 
    if operacion in(1,2) then
        perform * from parametro_control_calidad
        where upper(pacoca_descripcion) = upper(pacocadescripcion)
        and pacoca_codigo != pacocacodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into parametro_control_calidad(pacoca_codigo, pacoca_descripcion, pacoca_estado)
				values(pacocacodigo, upper(pacocadescripcion), 'ACTIVO');
				raise notice 'EL PARAMETRO DE CONTROL DE CALIDAD FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update parametro_control_calidad
				set pacoca_descripcion=upper(pacocadescripcion), pacoca_estado='ACTIVO'
				where pacoca_codigo=pacocacodigo;
				raise notice 'EL PARAMETRO DE CONTROL DE CALIDAD FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update parametro_control_calidad
		set pacoca_estado='INACTIVO'
		where pacoca_codigo=pacocacodigo;
		raise notice 'EL PARAMETRO DE CONTROL DE CALIDAD FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(pacoca_audit, '') into pacocaAudit from parametro_control_calidad where pacoca_codigo = pacocacodigo;
	--a los datos anteriores le agregamos los nuevos
	update parametro_control_calidad 
	set pacoca_audit = pacocaAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'pacoca_descripcion', upper(pacocadescripcion),
		'pacoca_estado', upper(pacocaestado)
	)||','
	where pacoca_codigo = pacocacodigo;
end
$function$ 
language plpgsql;

--Costo Servicio
create or replace function sp_costo_servicio(
    costservcodigo integer,
    costservcosto numeric,
    costservestado varchar,
    modcodigo integer,
    operacion integer 
) returns void as
$function$
begin 
    if operacion in(1,2) then
        perform * from costo_servicio
        where mod_codigo=modcodigo and costserv_codigo != costservcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into costo_servicio(costserv_codigo, costserv_costo, costserv_estado, mod_codigo)
				values((select coalesce(max(costserv_codigo),0)+1 from costo_servicio), costservcosto, 'ACTIVO', modcodigo);
				raise notice 'EL COSTO SERVICIO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update costo_servicio
				set costserv_costo=costservcosto, costserv_estado='ACTIVO', mod_codigo=modcodigo
				where costserv_codigo=costservcodigo;
				raise notice 'EL COSTO SERVICIO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update costo_servicio
		set costserv_estado='INACTIVO'
		where costserv_codigo=costservcodigo;
		raise notice 'EL COSTO SERVICIO FUE BORRADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Seccion
create or replace function sp_seccion(
    secccodigo integer,
    seccdescripcion varchar,
    seccestado varchar,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare seccAudit text;
begin 
    if operacion in(1,2) then
        perform * from seccion
        where (upper(secc_descripcion)=upper(seccdescripcion) and emp_codigo=empcodigo and suc_codigo=succodigo)
        and secc_codigo != secccodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into seccion(secc_codigo, secc_descripcion, secc_estado, suc_codigo, emp_codigo)
				values(secccodigo, upper(seccdescripcion), 'ACTIVO', succodigo, empcodigo);
				raise notice 'LA SECCION FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update seccion
				set secc_descripcion=upper(seccdescripcion), secc_estado='ACTIVO', 
				suc_codigo=succodigo, emp_codigo=empcodigo
				where secc_codigo=secccodigo;
				raise notice 'LA SECCION FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update seccion   
		set secc_estado='INACTIVO'
		where secc_codigo=secccodigo;
		raise notice 'LA SECCION FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(secc_audit, '') into seccAudit from seccion where secc_codigo = secccodigo;
	--a los datos anteriores le agregamos los nuevos
	update seccion 
	set secc_audit = seccAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'secc_descripcion', upper(seccdescripcion),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'secc_estado', upper(seccestado)
	)||','
	where secc_codigo = secccodigo;
end
$function$ 
language plpgsql;

--Equipo Trabajo
create or replace function sp_equipo_trabajo(
    funccodigo integer,
    secccodigo integer,
    eqtraestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    pernumerodocumento varchar,
    funcionario varchar,
    seccdescripcion varchar
) returns void as
$function$
declare eqtraAudit text;
begin 
    if operacion = 1 then
        perform * from equipo_trabajo
        where func_codigo=funccodigo and secc_codigo=secccodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into equipo_trabajo(func_codigo, secc_codigo, eqtra_estado)
				values(funccodigo, secccodigo, 'ACTIVO');
				raise notice 'EL EQUIPO DE TRABAJO FUE REGISTRADO CON EXITO';
        end if;
    end if;
   if operacion = 2 then 
    	update equipo_trabajo
		set eqtra_estado='ACTIVO'
		where func_codigo=funccodigo and secc_codigo=secccodigo;
		raise notice 'EL EQUIPO DE TRABAJO FUE MODIFICADO CON EXITO';
    end if;
    if operacion = 3 then 
    	update equipo_trabajo 
		set eqtra_estado='INACTIVO'
		WHERE func_codigo=funccodigo and secc_codigo=secccodigo;
		raise notice 'EL EQUIPO DE TRABAJO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(eqtra_audit, '') into eqtraAudit from equipo_trabajo where func_codigo=funccodigo and secc_codigo=secccodigo;
	--a los datos anteriores le agregamos los nuevos
	update equipo_trabajo 
	set eqtra_audit = eqtraAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'func_codigo', funccodigo,
		'funcionario', upper(funcionario),
		'secc_codigo', secccodigo,
		'secc_descripcion', upper(seccdescripcion),
		'eqtra_estado', upper(eqtraestado)
	)||','
	where func_codigo=funccodigo and secc_codigo=secccodigo;
end
$function$ 
language plpgsql;

--Pedido Produccion Cabecera
create or replace function sp_pedido_produccion_cab(
    pedprocodigo integer,
    pedprofecha date,
    pedproestado varchar,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer --1:insert 2:delete
) returns void as
$function$
begin 
     if operacion = 1 then
	     insert into pedido_produccion_cab(pedpro_codigo, pedpro_fecha, pedpro_estado, usu_codigo, suc_codigo, emp_codigo)
		 values((select coalesce(max(pedpro_codigo),0)+1 from pedido_produccion_cab), pedprofecha, 'PENDIENTE',
		 usucodigo, succodigo, empcodigo);
		 raise notice 'EL PEDIDO DE PRODUCCION FUE REGISTRADO CON EXITO';
    end if;
    if operacion = 2 then 
    	update pedido_produccion_cab 
		set pedpro_estado='ANULADO'
		where pedpro_codigo=pedprocodigo;
		raise notice 'EL PEDIDO DE PRODUCCION FUE ANULADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Pedido Produccion Detalle
create or replace function sp_pedido_produccion_det(
    pedprocodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    pedprodetcantidad numeric,
    pedprodetprecio numeric,
    operacion integer --1:insert 2:delete
) returns void as
$function$
begin 
     if operacion = 1 then
     	perform * from pedido_produccion_det
     	where it_codigo=itcodigo and pedpro_codigo=pedprocodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
		     insert into pedido_produccion_det(pedpro_codigo, it_codigo, tipit_codigo, pedprodet_cantidad, pedprodet_precio)
			 values(pedprocodigo, itcodigo, tipitcodigo, pedprodetcantidad, pedprodetprecio);
			 raise notice 'EL PEDIDO DE PRODUCCION DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
    	delete from pedido_produccion_det 
    	where pedpro_codigo=pedprocodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'EL PEDIDO DE PRODUCCION DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Presupuesto Cabecera
create or replace function sp_presupuesto_cab(
    prescodigo integer,
    presfecharegistro date,
    presfechavencimiento date,
    presestado varchar,
    pevencodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    clicodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    pernumerodocumento varchar,
    cliente varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare presAudit text;
		pevenAudit text;
		c_pedido cursor is
		select 
		pvc.peven_codigo,
		pvc.peven_fecha,
		pvc.peven_estado,
		pvc.cli_codigo,	
		p.per_nombre||''||p.per_apellido as cliente,
		p.per_numerodocumento
		from pedido_venta_cab pvc
		join cliente c on c.cli_codigo=pvc.cli_codigo
		join personas p on p.per_codigo=c.per_codigo
		where pvc.peven_codigo=pevencodigo;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		 --Validamos que la fecha de vencimiento no sea menor a la fecha de registro
     	 if presfechavencimiento < presfecharegistro then
			--En caso de que sea asi generamos una excepcion
     	 	raise exception 'fecha_mayor';
     	 end if;
		 --Validamos que no se repita el codigo de pedido venta junto al estado activo
   		 perform * from presupuesto_cab 
   		 where peven_codigo=pevencodigo and pres_estado='ACTIVO';
   		 if found then
			--En caso de que sea asi generamos una excepcion
   		 	raise exception 'pedido';
   		 elseif operacion = 1 then
   		     --Insertamos cabecera 
		     insert into presupuesto_cab(pres_codigo, pres_fecharegistro, pres_fechavencimiento, pres_estado, peven_codigo,
		     usu_codigo, suc_codigo, emp_codigo, cli_codigo)
			 values(prescodigo, presfecharegistro, presfechavencimiento, 'ACTIVO', 
			 pevencodigo, usucodigo, succodigo, empcodigo, clicodigo);
			 --Actualizamos el estado del pedido de venta seleccionado
			 update pedido_venta_cab set peven_estado='PRESUPUESTADO' where peven_codigo=pevencodigo;
		 	 --Enviamos un mensaje de confirmacion
			 raise notice 'EL PRESUPUESTO DE PRODUCCION FUE REGISTRADO CON EXITO';
		 end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--En este caso realizamos un borrado logico
    	update presupuesto_cab 
		set pres_estado='ANULADO'
		where pres_codigo=prescodigo;
		--Actualizamos el estado del pedido de venta asociado a cabecera
	    update pedido_venta_cab set peven_estado='ACTIVO' where peven_codigo=pevencodigo;
		--Enviamos un mensaje de confirmacion
		raise notice 'EL PRESUPUESTO DE PRODUCCION DETALLE FUE ANULADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(pres_audit, '') into presAudit from presupuesto_cab where pres_codigo=prescodigo;
	--a los datos anteriores le agregamos los nuevos
	update presupuesto_cab 
	set pres_audit = presAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'pres_fecharegistro', presfecharegistro,
		'pres_fechavencimiento', presfechavencimiento,
		'peven_codigo', peven_codigo,
		'cli_codigo', clicodigo,
		'cliente', upper(cliente),
		'per_numerodocumento', pernumerodocumento,
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'pres_estado', upper(presestado)
	)||','
	where pres_codigo = prescodigo;
	--Auditamos pedido venta cabecera
	--consultamos el audit anterior de pedido venta cabecera
	select coalesce(peven_audit, '') into pevenAudit from pedido_venta_cab where peven_codigo=pevencodigo;
	--a los datos anteriores le agregamos los nuevos
	--Recorremos el cursor y auditamos los datos
	for ped in c_pedido loop
		update pedido_venta_cab 
		set peven_audit = pevenAudit||''||json_build_object(
			'usu_codigo', usucodigo,
			'usu_login', usulogin,
			'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
			'procedimiento', 'MODIFICACION',
			'peven_fecha', ped.peven_fecha,
			'cli_codigo', ped.cli_codigo,
			'cliente', ped.cliente,
			'per_numerodocumento', ped.per_numerodocumento,
			'emp_codigo', empcodigo,
			'emp_razonsocial', upper(emprazonsocial),
			'suc_codigo', succodigo,
			'suc_descripcion', upper(sucdescripcion),
			'peven_estado', ped.peven_estado
		)||','
		where peven_codigo = pevencodigo;
	end loop;
end
$function$ 
language plpgsql;

--Presupuesto Detalle
create or replace function sp_presupuesto_det(
    prescodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    presdetcantidad integer,
    presdetprecio numeric,
    operacion integer --1:insert 2:delete
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si existe el item en caso de que si generamos una excepcion
     	perform * from presupuesto_det
     	where it_codigo=itcodigo and pres_codigo=prescodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
		     insert into presupuesto_det(pres_codigo, it_codigo, tipit_codigo, presdet_cantidad, presdet_precio)
			 values(prescodigo, itcodigo, tipitcodigo, presdetcantidad, presdetprecio);
			 raise notice 'EL PRESUPUESTO PRODUCCION DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from presupuesto_det	 
    	where pres_codigo=prescodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'EL PRESUPUESTO PRODUCCION DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Orden Produccion Cabecera
create or replace function sp_orden_produccion_cab(
    orprocodigo integer,
    orprofecha date,
    orprofechainicio date,
    orprofechaculminacion date,
    orproestado varchar,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    secccodigo integer,
    prescodigo integer,
    pevencodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    seccdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare orproAudit text;
		presAudit text;
		pevenAudit text;
		ultCodOrdenPresupuesto integer;
		comproCodigo integer;
		cantidadMateriaPrima numeric;
		filaComponenteProduccionDetalle record;
		c_presupuesto cursor is
		select 
		pc.pres_fecharegistro,
		pc.pres_fechavencimiento,
		pc.peven_codigo,
		pc.cli_codigo,
		p.per_nombre||' '||p.per_apellido as cliente,
		p.per_numerodocumento,
		pc.pres_estado 
		from presupuesto_cab pc
		join cliente c on c.cli_codigo=pc.cli_codigo
		join personas p on p.per_codigo=c.per_codigo
		where pc.pres_codigo=prescodigo;
		c_pedido cursor is
		select 
		pvc.peven_fecha,
		pvc.peven_estado,
		pvc.cli_codigo,
		p.per_nombre||' '||p.per_apellido as cliente,
		p.per_numerodocumento
		from pedido_venta_cab pvc
		join cliente c on c.cli_codigo=pvc.cli_codigo
		join personas p on p.per_codigo=c.per_codigo
		where pvc.peven_codigo=pevencodigo;
		c_orden cursor is
		select 
		it_codigo,
		tipit_codigo,
		dep_codigo,
		suc_codigo,
		emp_codigo,
		orprodet_cantidad 
		from orden_produccion_det opd
		where orpro_codigo=orprocodigo;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		 ultCodOrdenPresupuesto := (select coalesce(max(orpre_codigo),0)+1 from orden_presupuesto);
		 --Validamos que la fecha registro no sea mayor a la fecha de inicio
		 if orprofecha > orprofechainicio then
			--En caso de ser asi, lanzamos una excepcion
     	 	raise exception 'fecha_registro';
     	 end if;
		 --Validamos que la fecha de inicio no sea mayor a la fecha de culminacion
         if orprofechainicio > orprofechaculminacion then
			--En caso de ser asi, lanzamos una excepcion
     	 	raise exception 'fecha_inicio';
     	 end if;
     	 --Una vez pasada la validacion, insertamos un nuevo registro en cabecera
	     insert into orden_produccion_cab(orpro_codigo, orpro_fecha, orpro_fechainicio, orpro_fechaculminacion, orpro_estado,
	     usu_codigo, suc_codigo, emp_codigo, secc_codigo)
		 values(orprocodigo, orprofecha, orprofechainicio, orprofechaculminacion, 'ACTIVO', usucodigo, succodigo, empcodigo, secccodigo);
		 --Insertamos nuevo registro en orden presupuesto
		 insert into orden_presupuesto(orpre_codigo, orpro_codigo, pres_codigo)
		 values(ultCodOrdenPresupuesto, orprocodigo, prescodigo);
		 --Actualizamos el estado de presupuesto 
		 update presupuesto_cab set pres_estado='APROBADO' where pres_codigo=prescodigo;
		 --Actualizamos el estado del pedido venta que se haya ordenado
		 update pedido_venta_cab set peven_estado='APROBADO' where peven_codigo=pevencodigo;
		 --Auditamos orden presupuesto
		 update orden_presupuesto 
			 set orpre_audit = json_build_object(
				'usu_codigo', usucodigo,
				'usu_login', usulogin,
				'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
				'procedimiento', 'ALTA',
				'orpro_codigo', orprocodigo,
				'pres_codigo', prescodigo
			 )
			 where orpre_codigo = ultCodOrdenPresupuesto;
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA ORDEN DE PRODUCCION FUE REGISTRADA CON EXITO';
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--En esta caso realizamos un borrado logico
    	update orden_produccion_cab 
		set orpro_estado='ANULADO'
		where orpro_codigo=orprocodigo;
		--Actualizamos el estado de presupuesto 
	    update presupuesto_cab set pres_estado='ACTIVO' where pres_codigo=prescodigo;
		--Actualizamos el estado del pedido venta que se asocio a la orden una vez anulada
	    update pedido_venta_cab set peven_estado='PRESUPUESTADO' where peven_codigo=pevencodigo;
		--Actualizamos el stock, en caso de que se tenga registros asociados en el detalle
		for ord in c_orden loop
			--Sacamos el codigo de componente produccion para individualizar las materias primas por producto
			comproCodigo := (select cpc.compro_codigo from componente_produccion_cab cpc where cpc.it_codigo=ord.it_codigo and cpc.tipit_codigo=ord.tipit_codigo);
			--Sacamos la materia prima por producto
			for filaComponenteProduccionDetalle in select it_codigo, tipit_codigo, comprodet_cantidad 
			from componente_produccion_det cpd where compro_codigo=comproCodigo loop
				--Definimos la cantidad a sumar de materia prima
				cantidadMateriaPrima := ord.orprodet_cantidad * filaComponenteProduccionDetalle.comprodet_cantidad;
				--Actualizamos el stock
		        update stock set st_cantidad=st_cantidad+cantidadMateriaPrima 
				where it_codigo=filaComponenteProduccionDetalle.it_codigo and tipit_codigo=filaComponenteProduccionDetalle.tipit_codigo 
				and dep_codigo=ord.dep_codigo and suc_codigo=ord.suc_codigo and emp_codigo=ord.emp_codigo;
				--Reinciamos la variable cantidadMateriaPrima
				cantidadMateriaPrima := 0;
			end loop;
		end loop;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA ORDEN DE PRODUCCION FUE ANULADA CON EXITO';
    end if;
	--Consultamos el audit anterior
	select coalesce(orpro_audit, '') into orproAudit from orden_produccion_cab where orpro_codigo=orprocodigo;
	--a los datos anteriores le agregamos los nuevos
	update orden_produccion_cab 
	set orpro_audit = orproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'orpro_fecha', orprofecha,
		'orpro_fechainicio', orprofechainicio,
		'orpro_fechaculminacion', orprofechaculminacion,
		'secc_codigo', secccodigo,
		'secc_descripcion', upper(seccdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'orpro_estado', upper(orproestado)
	)||','
	where orpro_codigo = orprocodigo;
	--Auditamos presupuesto cabecera
	--Consultamos el audit anterior de presupuesto cabecera
	select coalesce(pres_audit, '') into presAudit from presupuesto_cab where pres_codigo=prescodigo;
	--a los datos anteriores le agregamos los nuevos
	--Recorremos el cursor y auditamos los datos
	for pre in c_presupuesto loop
		update presupuesto_cab 
		set pres_audit = presAudit||''||json_build_object(
			'usu_codigo', usucodigo,
			'usu_login', usulogin,
			'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
			'procedimiento', 'MODIFICACION',
			'pres_fecharegistro', pre.pres_fecharegistro,
			'pres_fechavencimiento', pre.pres_fechavencimiento,
			'peven_codigo', pre.peven_codigo,
			'cli_codigo', pre.cli_codigo,
			'cliente', pre.cliente,
			'per_numerodocumento', pre.per_numerodocumento,
			'emp_codigo', empcodigo,
			'emp_razonsocial', upper(emprazonsocial),
			'suc_codigo', succodigo,
			'suc_descripcion', upper(sucdescripcion),
			'pres_estado', pre.pres_estado
		)||','
		where pres_codigo = prescodigo;
	end loop;
	--Auditamos pedido venta cabecera
	--consultamos el audit anterior de pedido venta cabecera
	select coalesce(peven_audit, '') into pevenAudit from pedido_venta_cab where peven_codigo=pevencodigo;
	--a los datos anteriores le agregamos los nuevos
	--Recorremos el cursor y auditamos los datos
	for ped in c_pedido loop
		update pedido_venta_cab 
		set peven_audit = pevenAudit||''||json_build_object(
			'usu_codigo', usucodigo,
			'usu_login', usulogin,
			'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
			'procedimiento', 'MODIFICACION',
			'peven_fecha', ped.peven_fecha,
			'cli_codigo', ped.cli_codigo,
			'cliente', ped.cliente,
			'per_numerodocumento', ped.per_numerodocumento,
			'emp_codigo', empcodigo,
			'emp_razonsocial', upper(emprazonsocial),
			'suc_codigo', succodigo,
			'suc_descripcion', upper(sucdescripcion),
			'peven_estado', ped.peven_estado
		)||','
		where peven_codigo = pevencodigo;
	end loop;
end
$function$ 
language plpgsql;

--Orden Produccion Detalle
create or replace function sp_orden_produccion_det(
    orprocodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    orprodetespecificacion varchar,
    orprodetcantidad integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer 
) returns void as
$function$
declare comproCodigo integer;
		filaComponenteProduccionDetalle record;
		cantidadMateriaPrima numeric;
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si existe el item en caso de que si generamos una excepcion
     	perform * from orden_produccion_det
     	where it_codigo=itcodigo and orpro_codigo=orprocodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
			--En caso de que no se genere una excepcion, insertamos en nuevo registro en orden produccion detalle
		     insert into orden_produccion_det(
			 orpro_codigo, 
			 it_codigo, 
			 tipit_codigo, 
			 orprodet_especificacion, 
			 orprodet_cantidad,
			 dep_codigo,
			 suc_codigo,
			 emp_codigo	
			 )
			 values(
			 orprocodigo, 
			 itcodigo, 
			 tipitcodigo, 
			 upper(orprodetespecificacion), 
			 orprodetcantidad,
			 depcodigo,
			 succodigo,
			 empcodigo
			 );
			 --Al insertar el registro en orden produccion detalle procedemos a cargar de forma automatica orden produccion detalle2
			 --Traemos el codigo de componente produccion en base al item del detalle
			 comproCodigo := (select cpc.compro_codigo from componente_produccion_cab cpc where cpc.it_codigo=itcodigo and cpc.tipit_codigo=tipitcodigo);
			 --Creamos un loop en el cual traemos la materia prima a utilizar por producto de componente produccion detalle
			 for filaComponenteProduccionDetalle in select it_codigo, tipit_codigo, comprodet_cantidad 
			 from componente_produccion_det cpd where compro_codigo=comproCodigo loop
			 --Definimmos la cantidad de materia prima a utilizar
			 cantidadMateriaPrima := orprodetcantidad * filaComponenteProduccionDetalle.comprodet_cantidad;
			 --Una vez definido los datos a traer en el loop procedemos a cargar orden produccion detalle2 con la materia prima a utilizar para realizar el 
			 --producto definido en el registro de orden produccion detalle
			 perform sp_orden_produccion_det2(
			 orprocodigo, 
			 comproCodigo, 
			 filaComponenteProduccionDetalle.it_codigo, 
			 filaComponenteProduccionDetalle.tipit_codigo,
			 cantidadMateriaPrima,
			 1
			 );
			 --Descontamos la cantidad de stoct
             update stock set st_cantidad=st_cantidad-cantidadMateriaPrima 
			 where it_codigo=filaComponenteProduccionDetalle.it_codigo and tipit_codigo=filaComponenteProduccionDetalle.tipit_codigo 
			 and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
			 --Reinciamos la variable cantidadMateriaPrima
			 cantidadMateriaPrima := 0;
			 end loop;
			 --Enviamos un mensaje de aviso al insertar el registro en detalle
			 raise notice 'LA ORDEN DE PRODUCCION DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from orden_produccion_det	 
    	where orpro_codigo=orprocodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		--Al eliminar el registro en orden produccion detalle procedemos a elimiar de forma automatica orden produccion detalle2
		--Traemos el codigo de componente produccion en base al item del detalle
		comproCodigo := (select cpc.compro_codigo from componente_produccion_cab cpc where cpc.it_codigo=itcodigo and cpc.tipit_codigo=tipitcodigo);
		--Creamos un loop en el cual traemos la materia prima a utilizar por producto de componente produccion detalle
		for filaComponenteProduccionDetalle in select it_codigo, tipit_codigo, comprodet_cantidad 
			from componente_produccion_det cpd where compro_codigo=comproCodigo loop
			--Definimmos la cantidad de materia prima a restablecer en stock
			cantidadMateriaPrima := orprodetcantidad * filaComponenteProduccionDetalle.comprodet_cantidad;
			--Una vez definido los datos a traer en el loop procedemos a eliminar registros en orden produccion detalle2 
			perform sp_orden_produccion_det2(
			orprocodigo, 
			comproCodigo, 
			filaComponenteProduccionDetalle.it_codigo, 
			filaComponenteProduccionDetalle.tipit_codigo,
			cantidadMateriaPrima,
			2
			);
			--Sumamos la cantidad de stock que se resto
	        update stock set st_cantidad=st_cantidad+cantidadMateriaPrima 
			where it_codigo=filaComponenteProduccionDetalle.it_codigo and tipit_codigo=filaComponenteProduccionDetalle.tipit_codigo 
			and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
			--Reinciamos la variable cantidadMateriaPrima
			cantidadMateriaPrima := 0;
		end loop;
		--Enviamos un  mensaje de aviso al eliminar el registro en detalle
		raise notice 'LA ORDEN DE PRODUCCION DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Orden Produccion Detalle 2
create or replace function sp_orden_produccion_det2(
    orprocodigo integer,
    comprocodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    orprodet2cantidad numeric,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Insertamos los nuevos registros
		insert into orden_produccion_det2(
		orpro_codigo, 
		compro_codigo, 
		it_codigo, 
		tipit_codigo, 
		orprodet2_cantidad
		)
		values(
		orprocodigo, 
		comprocodigo, 
		itcodigo, 
		tipitcodigo, 
		orprodet2cantidad
		);
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from orden_produccion_det2	 
    	where orpro_codigo=orprocodigo and compro_codigo=comprocodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
    end if;
end
$function$ 
language plpgsql;

--Produccion Cabecera
create or replace function sp_produccion_cab(
    prodcodigo integer,
    prodfecha date,
    prodestado varchar,
    orprocodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    seccdescripcion varchar,
    orprofechainicio date,
    orprofechaculminacion date,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare prodAudit text;
		orproAudit text;
		c_orden cursor is
		select 
		opc.orpro_fecha,
		opc.orpro_fechainicio,
		opc.orpro_fechaculminacion,
		opc.secc_codigo,
		s.secc_descripcion,
		opc.orpro_estado
		from orden_produccion_cab opc 
		join seccion s on s.secc_codigo=opc.secc_codigo 
		where orpro_codigo=orprocodigo;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya se encuentra registrado la orden de produccion y si su estado es igual a activo
     	perform * from produccion_cab
     	where orpro_codigo=orprocodigo and prod_estado='ACTIVO';
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'orden';
     	elseif operacion = 1 then
     	 --Una vez pasada la validacion, insertamos un nuevo registro en cabecera
	     insert into produccion_cab(
		 prod_codigo, 
		 prod_fecha, 
		 prod_estado, 
		 orpro_codigo, 
		 usu_codigo,
	     suc_codigo, 
		 emp_codigo
		 )
		 values(
		 prodcodigo, 
		 prodfecha, 
		 'ACTIVO',
		 orprocodigo, 
		 usucodigo, 
		 succodigo, 
		 empcodigo
         );
		 --Actualizamos el estado de la orden de produccion asociada a la produccion
		 update orden_produccion_cab set orpro_estado='EN PRODUCCION' where orpro_codigo=orprocodigo; 
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA PRODUCCION FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--En esta caso realizamos un borrado logico
    	update produccion_cab 
		set prod_estado='ANULADO'
		where prod_codigo=prodcodigo;
		--Actualizamos el estado de la orden de producciona asociada a la produccion anulada
		update orden_produccion_cab set orpro_estado='ACTIVO' where orpro_codigo=orprocodigo;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA PRODUCCION FUE ANULADA CON EXITO';
    end if;
	--Al terminar la insercion o anulacion de la cabecera, procedemos a uditar el mismo
	--Consultamos el audit anterior
	select coalesce(prod_audit, '') into prodAudit from produccion_cab where prod_codigo=prodcodigo;
	--a los datos anteriores le agregamos los nuevos
	update produccion_cab 
	set prod_audit = prodAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'prod_fecha', prodfecha,
		'orpro_codigo', orprocodigo,
		'secc_descripcion', upper(seccdescripcion),
		'orpro_fechainicio', orprofechainicio,
		'orpro_fechaculminacion', orprofechaculminacion,
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'prod_estado', upper(prodestado)
	)||','
	where prod_codigo = prodcodigo;
	--Auditamos orden produccion cabecera
	--Consultamos el audit anterior
	select coalesce(orpro_audit, '') into orproAudit from orden_produccion_cab where orpro_codigo=orprocodigo;
	--a los datos anteriores le agregamos los nuevos
	for ord in c_orden loop
		update orden_produccion_cab 
		set orpro_audit = orproAudit||''||json_build_object(
			'usu_codigo', usucodigo,
			'usu_login', usulogin,
			'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
			'procedimiento', 'MODIFICACION',
			'orpro_fecha', ord.orpro_fecha,
			'orpro_fechainicio', ord.orpro_fechainicio,
			'orpro_fechaculminacion', ord.orpro_fechaculminacion,
			'secc_codigo', ord.secc_codigo,
			'secc_descripcion', ord.secc_descripcion,
			'emp_codigo', empcodigo,
			'emp_razonsocial', upper(emprazonsocial),
			'suc_codigo', succodigo,
			'suc_descripcion', upper(sucdescripcion),
			'orpro_estado', ord.orpro_estado
		)||','
		where orpro_codigo = orprocodigo;
	end loop;
end
$function$ 
language plpgsql;

--Produccion Detalle
create or replace function sp_produccion_det(
    prodcodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    prodetcantidad integer,
    prodetfechainicio date,
    prodetfechafinal date,
    prodetobservacion varchar,
    prodetestado varchar,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si la fecha de incio es mayor a la fecha final
		if prodetfechainicio > prodetfechafinal then
			--En caso de ser asi generamos una excepcion 
			raise exception 'fecha_mayor';
		end if;
		--Validamos que el item no se repita en detalle
     	perform * from produccion_det
     	where it_codigo=itcodigo and prod_codigo=prodcodigo;
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
			 --Insertamos el nuevo registro
		     insert into produccion_det(
			 prod_codigo, 
			 it_codigo, 
			 tipit_codigo, 
			 prodet_cantidad, 
			 prodet_fechainicio, 
		     prodet_fechafinal, 
			 prodet_observacion,
			 prodet_estado
			 )
			 values(
			 prodcodigo, 
			 itcodigo, 
		  	 tipitcodigo, 
			 prodetcantidad, 
			 prodetfechainicio, 
			 prodetfechafinal, 
			 prodetobservacion,
			 prodetestado
			 );
			 --Enviamos un  mensaje de aviso al insertar el registro en detalle
			 raise notice 'LA PRODUCCION DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Validamos que el estado del detalle sea terminado
		if prodetestado = 'TERMINADO' then
			--En caso de ser asi generamos una excepcion 
			raise exception 'cancelar';
		end if;
		--Realizamos un borrado fisico el cual se audita
    	delete from produccion_det 
    	where prod_codigo=prodcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		--Enviamos un  mensaje de aviso al eliminar el registro en detalle
		raise notice 'LA PRODUCCION DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Etapa Produccion
create or replace function sp_etapa_produccion(
    prodcodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    tipetcodigo integer,
    etprofecha date,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    maqcodigo integer,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos que no se repita la produccion, el producto y la etapa
     	perform * from etapa_produccion
     	where (prod_codigo=prodcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo and tipet_codigo=tipetcodigo);
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'produccion_etapa';
     	elseif operacion = 1 then
		 --Una vez pasada la validacion, insertamos un nuevo registro 
	     insert into etapa_produccion(
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
		 values(
		 prodcodigo, 
		 itcodigo, 
		 tipitcodigo, 
		 tipetcodigo, 
		 etprofecha, 
	     usucodigo, 
		 succodigo, 
	     empcodigo, 
		 maqcodigo
		 );
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA ETAPA DE PRODUCCION FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--En esta caso realizamos un borrado fisico el cual se audita
    	delete from etapa_produccion 
		where prod_codigo=prodcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo and tipet_codigo=tipetcodigo;
		--Enviamos un mensaje de confirmacion de eliminacion
		raise notice 'LA ETAPA DE PRODUCCION FUE ANULADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado componente produccion cabecera
select coalesce(max(compro_codigo),0)+1 as compro_codigo from componente_produccion_cab;
create or replace function sp_componente_produccion_cab(
    comprocodigo integer,
    comprofecha date,
    comproestado varchar,
    itcodigo integer,
    tipitcodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    itdescripcion varchar,
    modcodigomodelo varchar,
    coldescripcion varchar,
    talldescripcion varchar,
    tipitdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare comproAudit text;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya existe el item en cabecera
		perform * from componente_produccion_cab cpc 
		where cpc.it_codigo=itcodigo and cpc.tipit_codigo=tipitcodigo and cpc.compro_estado='ACTIVO';
     	if found then
			 --Si es que existe el item generamos una excepcion
     		 raise exception 'item_repetido';
	 	elseif operacion = 1 then
	    	--Una vez pasada la validacion, insertamos un nuevo registro en cabecera
		    insert into componente_produccion_cab(
			compro_codigo, 
			compro_fecha, 
			compro_estado, 
			it_codigo, 
			tipit_codigo,
		    usu_codigo, 
			suc_codigo, 
			emp_codigo
			)
			values(
			comprocodigo, 
			comprofecha, 
			'ACTIVO', 
			itcodigo, 
			tipitcodigo, 
			usucodigo, 
			succodigo, 
			empcodigo
			);
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'EL COMPONENTE DE PRODUCCION FUE REGISTRADO CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--En esta caso realizamos un borrado logico
    	update componente_produccion_cab 
		set compro_estado='ANULADO'
		where compro_codigo=comprocodigo;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'EL COMPONENTE DE PRODUCCION FUE ANULADO CON EXITO';
    end if;
	--Consultamos el audit anterior
	select coalesce(compro_audit, '') into comproAudit from componente_produccion_cab where compro_codigo=comprocodigo;
	--a los datos anteriores le agregamos los nuevos
	update componente_produccion_cab 
	set compro_audit = comproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'compro_fecha', comprofecha,
		'it_codigo', itcodigo,
		'it_descripcion', upper(itdescripcion),
		'mod_codigomodelo', modcodigomodelo,
		'col_descripcion', upper(coldescripcion),
		'tall_descripcion', upper(talldescripcion),
		'tipit_codigo', tipitcodigo,
		'tipit_descripcion', upper(tipitdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'compro_estado', upper(comproestado)
	)||','
	where compro_codigo = comprocodigo;
end
$function$ 
language plpgsql;

--COMPONENTE PRODUCCION
create or replace function sp_componente_produccion_cab(
    comprocodigo integer,
    comprofecha date,
    comproestado varchar,
    itcodigo integer,
    tipitcodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    itdescripcion varchar,
    modcodigomodelo varchar,
    coldescripcion varchar,
    talldescripcion varchar,
    tipitdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare comproAudit text;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya existe el item en cabecera
		perform * from componente_produccion_cab cpc 
		where cpc.it_codigo=itcodigo and cpc.tipit_codigo=tipitcodigo and cpc.compro_estado='ACTIVO';
     	if found then
			 --Si es que existe el item generamos una excepcion
     		 raise exception 'item_repetido';
	 	elseif operacion = 1 then
	    	--Una vez pasada la validacion, insertamos un nuevo registro en cabecera
		    insert into componente_produccion_cab(
			compro_codigo, 
			compro_fecha, 
			compro_estado, 
			it_codigo, 
			tipit_codigo,
		    usu_codigo, 
			suc_codigo, 
			emp_codigo
			)
			values(
			comprocodigo, 
			comprofecha, 
			'ACTIVO', 
			itcodigo, 
			tipitcodigo, 
			usucodigo, 
			succodigo, 
			empcodigo
			);
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'EL COMPONENTE DE PRODUCCION FUE REGISTRADO CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--En esta caso realizamos un borrado logico
    	update componente_produccion_cab 
		set compro_estado='ANULADO'
		where compro_codigo=comprocodigo;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'EL COMPONENTE DE PRODUCCION FUE ANULADO CON EXITO';
    end if;
	--Consultamos el audit anterior
	select coalesce(compro_audit, '') into comproAudit from componente_produccion_cab where compro_codigo=comprocodigo;
	--a los datos anteriores le agregamos los nuevos
	update componente_produccion_cab 
	set compro_audit = comproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'compro_fecha', comprofecha,
		'it_codigo', itcodigo,
		'it_descripcion', upper(itdescripcion),
		'mod_codigomodelo', modcodigomodelo,
		'col_descripcion', upper(coldescripcion),
		'tall_descripcion', upper(talldescripcion),
		'tipit_codigo', tipitcodigo,
		'tipit_descripcion', upper(tipitdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'compro_estado', upper(comproestado)
	)||','
	where compro_codigo = comprocodigo;
end
$function$ 
language plpgsql;

--COMPONENTE PRODUCCION DETALLE
create or replace function sp_componente_produccion_det(
    comprocodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    comprodetcantidad numeric,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si existe el item en caso de que si generamos una excepcion
     	perform * from componente_produccion_det
     	where it_codigo=itcodigo and compro_codigo=comprocodigo;
     	if found then
     		 raise exception 'item';
		--Si no existe el item insertamos el mismo en el detalle
     	elseif operacion = 1 then
		     insert into componente_produccion_det(compro_codigo, it_codigo, tipit_codigo, comprodet_cantidad)
			 values(comprocodigo, itcodigo, tipitcodigo, comprodetcantidad);
			 raise notice 'EL COMPONENTE DE PRODUCCION DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from componente_produccion_det 
    	where compro_codigo=comprocodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'EL COMPONENTE DE PRODUCCION DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--PRODUCCION TERMINADA CABECERA
create or replace function sp_produccion_terminada_cab(
    protercodigo integer,
    proterfecha date,
    proterfechaculminacion date,
    proterestado varchar,
    prodcodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    seccdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare proterAudit text;
		produccionTerminadaDetalle record;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya se encuentra registrado la produccion y si su estado es igual a activo
     	perform * from produccion_terminada_cab
     	where prod_codigo=prodcodigo and proter_estado='ACTIVO';
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'produccion';
     	elseif operacion = 1 then
     	 --Una vez pasada la validacion, insertamos un nuevo registro en cabecera
	     insert into produccion_terminada_cab(
		 proter_codigo, 
		 proter_fecha, 
		 proter_fechaculminacion,
		 proter_estado, 
		 prod_codigo, 
		 usu_codigo,
	     suc_codigo, 
		 emp_codigo
		 )
		 values(
		 protercodigo, 
		 proterfecha,
		 proterfechaculminacion,
		 'ACTIVO',
		 prodcodigo, 
		 usucodigo, 
		 succodigo, 
		 empcodigo
         );
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA CABECERA DE PRODUCCION TERMINADA FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de anulacion
    if operacion = 2 then
		--En este caso realizamos un borrado logico
    	update produccion_terminada_cab 
		set proter_estado='ANULADO'
		where proter_codigo=protercodigo;
		--Actualizamos el stock en caso de que en detalle se haya sumado
	    for produccionTerminadaDetalle in select * from produccion_terminada_det where proter_codigo=protercodigo loop
	       	update stock set st_cantidad=st_cantidad-produccionTerminadaDetalle.proterdet_cantidad 
			where it_codigo=produccionTerminadaDetalle.it_codigo and tipit_codigo=produccionTerminadaDetalle.tipit_codigo 
			and dep_codigo=produccionTerminadaDetalle.dep_codigo and suc_codigo=produccionTerminadaDetalle.suc_codigo 
			and emp_codigo=produccionTerminadaDetalle.emp_codigo;
        end loop;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA CABECERA DE PRODUCCION TERMINADA FUE ANULADA CON EXITO';
    end if;
	--Al terminar la insercion o anulacion de la cabecera, procedemos a auditar el mismo
	--Consultamos el audit anterior
	select coalesce(proter_audit, '') into proterAudit from produccion_terminada_cab where proter_codigo=protercodigo;
	--a los datos anteriores le agregamos los nuevos
	update produccion_terminada_cab 
	set proter_audit = proterAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'proter_fecha', proterfecha,
		'proter_fechaculminacion', proterfechaculminacion,
		'prod_codigo', prodcodigo,
		'secc_descripcion', upper(seccdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'proter_estado', upper(proterestado)
	)||','
	where proter_codigo = protercodigo;
end
$function$ 
language plpgsql;

--PRODUCCION TERMINADA DETALLE
create or replace function sp_produccion_terminada_det(
    protercodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    proterdetcantidad integer,
    operacion integer
) returns void as
$function$
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si no se repite el item en detalle
     	perform * from produccion_terminada_det
     	where it_codigo=itcodigo and proter_codigo=protercodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
			 --Buscamos si es que en stock se encuentra registrado el producto
			 perform * from stock
     		 where it_codigo=itcodigo and tipit_codigo=tipitcodigo 
			 and dep_codigo=depcodigo and suc_codigo=succodigo 
			 and emp_codigo=empcodigo;
			 --Si el produco ya se encuentra registrado en stock procedemos a sumar la cantidad
			 if found then
				 --Actualizamos el stock 
				 update stock set st_cantidad=st_cantidad+proterdetcantidad 
				 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
				 and suc_codigo=succodigo and emp_codigo=empcodigo;
			 else	
				--Cargamos el nuevo ítem en stock
				insert into stock(it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo, st_cantidad)
				values(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, proterdetcantidad);
             end if;
     	 	 --Insertamos produccion terminada detalle
		     insert into produccion_terminada_det(
			 proter_codigo, 
			 it_codigo, 
			 tipit_codigo, 
			 dep_codigo, 
			 suc_codigo,
		     emp_codigo, 
			 proterdet_cantidad
			 )
			 values(
			 protercodigo, 
			 itcodigo, 
			 tipitcodigo, 
			 depcodigo, 
			 succodigo, 
			 empcodigo, 
			 proterdetcantidad
			 );
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'EL PRODUCTO FUE REGISTRADO CON EXITO EN PRODUCCION TERMINADA DETALLE';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
    	--En este caso realizamos un borrado fisico que se audita
    	delete from produccion_terminada_det 
    	where proter_codigo=protercodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
        and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
       	--Actualizamos el stock 
		update stock set st_cantidad=st_cantidad-proterdetcantidad 
		where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		and suc_codigo=succodigo and emp_codigo=empcodigo;
		--Enviamos un mensaje de confirmacion de eliminacion
		raise notice 'EL PRODUCTO FUE ELIMINADO CON EXITO EN PRODUCCION TERMINADA DETALLE';
    end if;
end
$function$ 
language plpgsql;

--MERMAS CABECERA
create or replace function sp_mermas_cab(
    mercodigo integer,
    merfecha date,
    merestado varchar,
    protercodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    seccdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare merAudit text;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya se encuentra registrado la produccion terminada y si su estado es igual a activo
     	perform * from mermas_cab
     	where proter_codigo=protercodigo and mer_estado='ACTIVO';
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'produccion_terminada';
     	elseif operacion = 1 then
     	 --Una vez pasada la validacion, insertamos un nuevo registro en cabecera
	     insert into mermas_cab(
		 mer_codigo, 
		 mer_fecha, 
		 mer_estado, 
		 proter_codigo, 
		 usu_codigo,
	     suc_codigo, 
		 emp_codigo
		 )
		 values(
		 mercodigo, 
		 merfecha,
		 'ACTIVO',
		 protercodigo, 
		 usucodigo, 
		 succodigo, 
		 empcodigo
         );
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA CABECERA DE MERMAS FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de anulacion
    if operacion = 2 then
		--En este caso realizamos un borrado logico
    	update mermas_cab 
		set mer_estado='ANULADO'
		where mer_codigo=mercodigo;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA CABECERA DE MERMAS FUE ANULADA CON EXITO';
    end if;
	--Al terminar la insercion o anulacion de la cabecera, procedemos a auditar el mismo
	--Consultamos el audit anterior
	select coalesce(mer_audit, '') into merAudit from mermas_cab where mer_codigo=mercodigo;
	--a los datos anteriores le agregamos los nuevos
	update mermas_cab 
	set mer_audit = merAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'mer_fecha', merfecha,
		'proter_codigo', protercodigo,
		'secc_descripcion', upper(seccdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'mer_estado', upper(merestado)
	)||','
	where mer_codigo = mercodigo;
end
$function$ 
language plpgsql;

--MERMAS DETALLE
create or replace function sp_mermas_det(
    mercodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    merdetcantidad numeric,
    merdetprecio numeric,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si existe el item en caso de que si generamos una excepcion
     	perform * from mermas_det
     	where it_codigo=itcodigo and mer_codigo=mercodigo;
     	if found then
     		 raise exception 'item';
		--Si no existe el item insertamos el mismo en el detalle
     	elseif operacion = 1 then
		     insert into mermas_det(
			 mer_codigo, 
			 it_codigo, 
			 tipit_codigo, 
			 merdet_cantidad, 
			 merdet_precio
			 )
			 values(
			 mercodigo, 
			 itcodigo, 
			 tipitcodigo, 
			 merdetcantidad, 
			 merdetprecio
			 );
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'LA MATERIA PRIMA FUE REGISTRADA CON EXITO EN MERMAS DETALLE';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from mermas_det 
    	where mer_codigo=mercodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'LA MATERIA PRIMA FUE ELIMINADA CON EXITO EN MERMAS DETALLE';
    end if;
end
$function$ 
language plpgsql;

--CONTROL CALIDAD CABECERA 
create or replace function sp_control_calidad_cab(
    concacodigo integer,
    concafecha date,
    concaestado varchar,
    protercodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    seccdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare concaAudit text;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya se encuentra registrado la produccion terminada y si su estado es igual a activo
     	perform * from control_calidad_cab
     	where proter_codigo=protercodigo and conca_estado='ACTIVO';
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'produccion_terminada';
     	elseif operacion = 1 then
     	 --Una vez pasada la validacion, insertamos un nuevo registro en cabecera
	     insert into control_calidad_cab(
		 conca_codigo, 
		 conca_fecha, 
		 conca_estado, 
		 proter_codigo, 
		 usu_codigo,
	     suc_codigo, 
		 emp_codigo
		 )
		 values(
		 concacodigo, 
		 concafecha,
		 'ACTIVO',
		 protercodigo, 
		 usucodigo, 
		 succodigo, 
		 empcodigo
         );
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA CABECERA DE CONTROL CALIDAD FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de anulacion
    if operacion = 2 then
		--En este caso realizamos un borrado logico
    	update control_calidad_cab 
		set conca_estado='ANULADO'
		where conca_codigo=concacodigo;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA CABECERA DE CONTROL CALIDAD FUE ANULADA CON EXITO';
    end if;
	--Al terminar la insercion o anulacion de la cabecera, procedemos a auditar el mismo
	--Consultamos el audit anterior
	select coalesce(conca_audit, '') into concaAudit from control_calidad_cab where conca_codigo=concacodigo;
	--a los datos anteriores le agregamos los nuevos
	update control_calidad_cab 
	set conca_audit = concaAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'conca_fecha', concafecha,
		'proter_codigo', protercodigo,
		'secc_descripcion', upper(seccdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'conca_estado', upper(concaestado)
	)||','
	where conca_codigo = concacodigo;
end
$function$ 
language plpgsql;

--CONTROL CALIDAD DETALLE
create or replace function sp_control_calidad_det(
    concacodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    pacocacodigo integer,
    concadetcantidadfallida integer,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos que no se repita el item, el parametro de control de calidad y el codigo de control
     	perform * from control_calidad_det
     	where it_codigo=itcodigo and tipit_codigo=tipitcodigo 
		and pacoca_codigo=pacocacodigo and conca_codigo=concacodigo;
     	if found then
			 --En caso de que se repita generamos una excepcion
     		 raise exception 'item_parametro';
		--Si no existe el item insertamos el mismo en el detalle
     	elseif operacion = 1 then
		     insert into control_calidad_det(
			 conca_codigo, 
			 it_codigo, 
			 tipit_codigo, 
			 pacoca_codigo, 
			 concadet_cantidadfallida
			 )
			 values(
			 concacodigo, 
			 itcodigo, 
			 tipitcodigo, 
			 pacocacodigo, 
			 concadetcantidadfallida
			 );
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'EL PRODUCTO FUE REGISTRADO CON EXITO EN CONTROL CALIDAD DETALLE';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from control_calidad_det 
    	where conca_codigo=concacodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo AND pacoca_codigo=pacocacodigo;
		--Enviamos un mensaje de confirmacion de eliminacion
		raise notice 'EL PRODUCTO FUE ELIMINADO CON EXITO DE CONTROL CALIDAD DETALLE';
    end if;
end
$function$ 
language plpgsql;

--COSTO PRODUCCION CABECERA 
create or replace function sp_costo_produccion_cab(
    coprocodigo integer,
    coprofecha date,
    coproestado varchar,
    orprocodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    seccdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$ 
declare coproAudit text;
		ordenProduccionDetalle2 record;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya se encuentra registrado la orden y si su estado es igual a activo
     	perform * from costo_produccion_cab
     	where orpro_codigo=orprocodigo and copro_estado='ACTIVO';
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'orden';
     	elseif operacion = 1 then
     	 --Una vez pasada la validacion, insertamos un nuevo registro en cabecera
	     insert into costo_produccion_cab(
		 copro_codigo, 
		 copro_fecha, 
		 copro_estado, 
		 orpro_codigo, 
		 usu_codigo,
	     suc_codigo, 
		 emp_codigo
		 )
		 values(
		 coprocodigo, 
		 coprofecha,
		 'ACTIVO',
		 orprocodigo, 
		 usucodigo, 
		 succodigo, 
		 empcodigo
         );
		--Una vez insertada la cabecera, procedemos a cargar de forma automatica el detalle de costo produccion
		--Preparamos la consulta para extraer los items de orden produccion det2
		for ordenProduccionDetalle2 in select opd.it_codigo, opd.tipit_codigo, sum(opd.orprodet2_cantidad) as cantidad_materia, i.it_costo
		from orden_produccion_det2 opd join componente_produccion_det cpd on cpd.compro_codigo=opd.compro_codigo  and cpd.it_codigo=opd.it_codigo 
		and cpd.tipit_codigo=opd.tipit_codigo join items i on i.it_codigo=cpd.it_codigo and i.tipit_codigo=cpd.tipit_codigo 
		where opd.orpro_codigo=orprocodigo group by opd.it_codigo, opd.tipit_codigo, i.it_costo loop 
			--Una vez obtenemos los items procedemos a insertar los mismos en costo_produccion_det
			insert into costo_produccion_det(copro_codigo, it_codigo, tipit_codigo, coprodet_cantidad, coprodet_costo)
			values(coprocodigo, ordenProduccionDetalle2.it_codigo, ordenProduccionDetalle2.tipit_codigo, 
			ordenProduccionDetalle2.cantidad_materia, ordenProduccionDetalle2.it_costo);
		end loop;
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA CABECERA DE COSTO PRODUCCION FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de anulacion
    if operacion = 2 then
		--En este caso realizamos un borrado logico
    	update costo_produccion_cab 
		set copro_estado='ANULADO'
		where copro_codigo=coprocodigo;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA CABECERA DE COSTO PRODUCCION FUE ANULADA CON EXITO';
    end if;
	--Al terminar la insercion o anulacion de la cabecera, procedemos a auditar el mismo
	--Consultamos el audit anterior
	select coalesce(copro_audit, '') into coproAudit from costo_produccion_cab where copro_codigo=coprocodigo;
	--a los datos anteriores le agregamos los nuevos
	update costo_produccion_cab 
	set copro_audit = coproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'copro_fecha', coprofecha,
		'orpro_codigo', orprocodigo,
		'secc_descripcion', upper(seccdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'copro_estado', upper(coproestado)
	)||','
	where copro_codigo = coprocodigo;
end
$function$ 
language plpgsql;

