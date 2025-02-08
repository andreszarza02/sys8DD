--Procedimento almacenado
--Modulo
create or replace function sp_modulo(
    moducodigo integer,
    modudescripcion varchar,
    moduestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare moduAudit text; 
begin 
    if operacion in(1,2) then
        perform * from modulo
        where upper(modu_descripcion) = upper(modudescripcion)
        and modu_codigo != moducodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into modulo(modu_codigo, modu_descripcion, modu_estado)
				values(moducodigo, upper(modudescripcion), 'ACTIVO');
				raise notice 'EL MODULO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		UPDATE modulo
				SET modu_descripcion=upper(modudescripcion), modu_estado='ACTIVO'
				WHERE modu_codigo=moducodigo;
				raise notice 'EL MODULO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	UPDATE modulo
		SET modu_estado='INACTIVO'
		WHERE modu_codigo=moducodigo;
		raise notice 'EL MODULO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(modu_audit, '') into moduAudit from modulo where modu_codigo = moducodigo;
	--a los datos anteriores le agregamos los nuevos
	update modulo 
	set modu_audit = moduAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'modu_descripcion', upper(modudescripcion),
		'modu_estado', upper(moduestado)
	)||','
	where modu_codigo = moducodigo;
end
$function$ 
language plpgsql;

--Permisos
create or replace function sp_permisos(
    permcodigo integer,
    permdescripcion varchar,
    permestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare permAudit text; 
begin 
    if operacion in(1,2) then
        perform * from permisos
        where upper(perm_descripcion) = upper(permdescripcion)
        and perm_codigo != permcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into permisos(perm_codigo, perm_descripcion, perm_estado)
				values(permcodigo, upper(permdescripcion), 'ACTIVO');
				raise notice 'EL PERMISO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update permisos
				set perm_descripcion=upper(permdescripcion), perm_estado='ACTIVO'
				where perm_codigo=permcodigo;
				raise notice 'EL PERMISO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update permisos
		set perm_estado='INACTIVO'
		WHERE perm_codigo=permcodigo;
		raise notice 'EL PERMISO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(perm_audit, '') into permAudit from permisos where perm_codigo = permcodigo;
	--a los datos anteriores le agregamos los nuevos
	update permisos 
	set perm_audit = permAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'perm_descripcion', upper(permdescripcion),
		'perm_estado', upper(permestado)
	)||','
	where perm_codigo = permcodigo;
end
$function$ 
language plpgsql; 

--Perfil
create or replace function sp_perfil(
    perfcodigo integer,
    perfdescripcion varchar,
    perfestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare perfAudit text; 
begin 
    if operacion in(1,2) then
        perform * from perfil
        where upper(perf_descripcion) = upper(perfdescripcion)
        and perf_codigo != perfcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into perfil(perf_codigo, perf_descripcion, perf_estado)
				values(perfcodigo, upper(perfdescripcion), 'ACTIVO');
				raise notice 'EL PERFIL FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update perfil
				set perf_descripcion=upper(perfdescripcion), perf_estado='ACTIVO'
				where perf_codigo=perfcodigo;
				raise notice 'EL PERFIL FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update perfil
		set perf_estado='INACTIVO'
		WHERE perf_codigo=perfcodigo;
		raise notice 'EL PERFIL FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(perf_audit, '') into perfAudit from perfil where perf_codigo = perfcodigo;
	--a los datos anteriores le agregamos los nuevos
	update perfil 
	set perf_audit = perfAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'perf_descripcion', upper(perfdescripcion),
		'perf_estado', upper(perfestado)
	)||','
	where perf_codigo = perfcodigo;
end
$function$ 
language plpgsql;

--GUI
create or replace function sp_gui(
    guicodigo integer,
    moducodigo integer,
    guidescripcion varchar,
    guiestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    modudescripcion varchar
) returns void as
$function$
declare guiAudit text; 
begin 
    if operacion in(1,2) then
        perform * from gui
        where (upper(gui_descripcion) = upper(guidescripcion) and modu_codigo = moducodigo)
        and gui_codigo != guicodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into gui(gui_codigo, modu_codigo, gui_descripcion, gui_estado)
				values(guicodigo, moducodigo, upper(guidescripcion), 'ACTIVO');
				raise notice 'EL GUI FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update gui
				set gui_descripcion=upper(guidescripcion), modu_codigo=moducodigo, gui_estado='ACTIVO'
				where gui_codigo=guicodigo;
				raise notice 'EL GUI FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update gui 
		set gui_estado='INACTIVO'
		WHERE gui_codigo=guicodigo;
		raise notice 'EL GUI FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(gui_audit, '') into guiAudit from gui where gui_codigo = guicodigo;
	--a los datos anteriores le agregamos los nuevos
	update gui 
	set gui_audit = guiAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'gui_descripcion', upper(guidescripcion),
		'modu_codigo', moducodigo,
		'modu_descripcion', upper(modudescripcion),
		'gui_estado', upper(guiestado)
	)||','
	where gui_codigo = guicodigo;
end
$function$ 
language plpgsql;

--Perfiles Permisos
create or replace function sp_perfiles_permisos(
    perfpecodigo integer,
    perfcodigo integer,
    permcodigo integer,
    perfpeestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    perfdescripcion varchar,
    permdescripcion varchar
) returns void as
$function$
declare perfpeAudit text; 
begin 
    if operacion in(1,2) then
        perform * from perfiles_permisos
        where (perf_codigo=perfcodigo and perm_codigo=permcodigo)
        and perfpe_codigo != perfpecodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into perfiles_permisos(perfpe_codigo, perf_codigo, perm_codigo, perfpe_estado)
				values(perfpecodigo, perfcodigo, permcodigo, 'ACTIVO');
				raise notice 'EL PERMISO DE PERFIL FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update perfiles_permisos
				set perf_codigo=perfcodigo, perm_codigo=permcodigo, perfpe_estado='ACTIVO'
				where perfpe_codigo=perfpecodigo;
				raise notice 'EL PERMISO DE PERFIL FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update perfiles_permisos 
		set perfpe_estado='INACTIVO'
		WHERE perfpe_codigo=perfpecodigo;
		raise notice 'EL PERMISO DE PERFIL FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(perfpe_audit, '') into perfpeAudit from perfiles_permisos where perfpe_codigo = perfpecodigo;
	--a los datos anteriores le agregamos los nuevos
	update perfiles_permisos 
	set perfpe_audit = perfpeAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'perf_codigo', perfcodigo,
		'perf_descripcion', upper(perfdescripcion),
		'perm_codigo', permcodigo,
		'perm_descripcion', upper(permdescripcion),
		'perfpe_estado', upper(perfpeestado)
	)||','
	where perfpe_codigo = perfpecodigo;
end
$function$ 
language plpgsql;

--Perfil_gui
create or replace function sp_perfil_gui(
    perfguicodigo integer,
    perfcodigo integer,
    guicodigo integer,
    moducodigo integer,
    perfguiestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    perfdescripcion varchar,
    guidescripcion varchar,
    modudescripcion varchar
) returns void as
$function$
declare perfguiAudit text; 
begin 
    if operacion in(1,2) then
        perform * from perfil_gui
        where (perf_codigo=perfcodigo and gui_codigo=guicodigo and modu_codigo=moducodigo)
        and perfgui_codigo != perfguicodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into perfil_gui(perfgui_codigo, perf_codigo, gui_codigo, modu_codigo, perfgui_estado)
				values(perfguicodigo, perfcodigo, guicodigo, moducodigo, 'ACTIVO');
				raise notice 'EL GUI DEL PERFIL FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update perfil_gui
				set perf_codigo=perfcodigo, gui_codigo=guicodigo, modu_codigo=moducodigo,
				perfgui_estado='ACTIVO'
				where perfgui_codigo=perfguicodigo;
				raise notice 'EL GUI DEL PERFIL FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update perfil_gui 
		set perfgui_estado='INACTIVO'
		WHERE perfgui_codigo=perfguicodigo;
		raise notice 'EL GUI DEL PERFIL FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(perfgui_audit, '') into perfguiAudit from perfil_gui where perfgui_codigo = perfguicodigo;
	--a los datos anteriores le agregamos los nuevos
	update perfil_gui 
	set perfgui_audit = perfguiAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'perf_codigo', perfcodigo,
		'perf_descripcion', upper(perfdescripcion),
		'gui_codigo', guicodigo,
		'gui_descripcion', upper(guidescripcion),
		'modu_codigo', moducodigo,
		'modu_descripcion', upper(modudescripcion),
		'perfgui_estado', upper(perfguiestado)
	)||','
	where perfgui_codigo = perfguicodigo;
end
$function$ 
language plpgsql;

--Usuario
create or replace function sp_usuario(
    usucodigo integer,
    usulogin varchar,
    usucontrasenia varchar,
    moducodigo integer,
    perfcodigo integer,
    funccodigo integer,
    usuestado varchar,
    operacion integer,
    usucodigoreg integer,
    usuloginreg varchar,
    procedimiento varchar,
    funcionario varchar,
    perfdescripcion varchar,
    modudescripcion varchar
) returns void as
$function$
declare usuAudit text; 
begin 
    if operacion = 1 then
        perform * from usuario
        where usu_login=usulogin;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into usuario(
	        	usu_codigo, 
	        	usu_login, 
	        	usu_contrasenia, 
	        	usu_estado, 
	        	usu_fecha,
	        	modu_codigo,
	        	perf_codigo,
	        	func_codigo)
				values(usucodigo, usulogin, md5(usucontrasenia), 'ACTIVO', current_date, moducodigo, perfcodigo, funccodigo);
				raise notice 'EL USUARIO FUE REGISTRADO CON EXITO';
        end if;
    end if;
   	if operacion = 2 then
   		perform * from usuario
   		where usu_login=usulogin 
   		and usu_codigo != usucodigo;
   		if found then
            raise exception '1';
        elseif operacion = 2 then
		   		update usuario
				set usu_login=usulogin, func_codigo=funccodigo, usu_contrasenia=md5(usucontrasenia), 
				usu_estado='ACTIVO', modu_codigo=moducodigo, perf_codigo=perfcodigo
				where usu_codigo=usucodigo;
				raise notice 'EL USUARIO FUE MODIFICADO CON EXITO';
		end if;
   	end if;
    if operacion = 3 then 
    	update usuario 
		set usu_estado='INACTIVO'
		where usu_codigo=usucodigo;
		raise notice 'EL USUARIO FUE DESACTIVADO CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(usu_audit, '') into usuAudit  from usuario where usu_codigo = usucodigo;
	--a los datos anteriores le agregamos los nuevos
	update usuario 
	set usu_audit = usuAudit||''||json_build_object(
		'USU_CODIGO', usucodigoreg,
		'USU_LOGIN', usuloginreg,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'usu_fecha', to_char(current_date, 'DD-MM-YYYY'),
		'func_codigo', func_codigo,
		'funcionario', upper(funcionario),
		'perf_codigo', perfcodigo,
		'perf_descripcion', upper(perfdescripcion),
		'modu_codigo', moducodigo,
		'modu_descripcion', upper(modudescripcion),
		'usu_estado', upper(usuestado)
	)||','
	where usu_codigo = usucodigo;
end
$function$ 
language plpgsql;

--Asignacion permiso usuario
create or replace function sp_asignacion_permiso_usuario(
    asigpermcodigo integer,
    usucodigo integer,
    perfpecodigo integer,
    perfcodigo integer,
    permcodigo integer,
    asigpermestado varchar,
    operacion integer,
    usucodigoreg integer,
    usuloginreg varchar,
    procedimiento varchar,
    usulogin varchar,
    perfdescripcion varchar,
    permdescripcion varchar
) returns void as
$function$
declare asigpermAudit text;
begin 
    if operacion in(1,2) then
        perform * from asignacion_permiso_usuario
        where (usu_codigo=usucodigo and perfpe_codigo=perfpecodigo and perf_codigo=perfcodigo
        and perm_codigo=permcodigo) and asigperm_codigo != asigpermcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into asignacion_permiso_usuario(asigperm_codigo, usu_codigo, perfpe_codigo, perf_codigo, perm_codigo,
	        	asigperm_estado)
				values(asigpermcodigo, usucodigo, perfpecodigo, perfcodigo, permcodigo, 'ACTIVO');
				raise notice 'LA ASIGNACION FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update asignacion_permiso_usuario
				set usu_codigo=usucodigo, perfpe_codigo=perfpecodigo, perm_codigo=permcodigo,
				asigperm_estado='ACTIVO'
				where asigperm_codigo=asigpermcodigo;
				raise notice 'LA ASIGNACION FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update asignacion_permiso_usuario 
		set asigperm_estado='INACTIVO'
		WHERE asigperm_codigo=asigpermcodigo;
		raise notice 'LA ASIGNACION FUE BORRADA CON CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(asigperm_audit, '') into asigpermAudit from asignacion_permiso_usuario where asigperm_codigo = asigpermcodigo;
	--a los datos anteriores le agregamos los nuevos
	update asignacion_permiso_usuario 
	set asigperm_audit = asigpermAudit||''||json_build_object(
		'USU_CODIGO', usucodigoreg,
		'USU_LOGIN', usuloginreg,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'perfpe_codigo', perfpecodigo,
		'perf_codigo', perfcodigo,
		'perf_descripcion', upper(perfdescripcion),
		'perm_codigo', permcodigo,
		'perm_descripcion', upper(permdescripcion),
		'asigperm_estado', upper(asigpermestado)
	)||','
	where asigperm_codigo = asigpermcodigo;
end
$function$ 
language plpgsql;