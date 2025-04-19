--Procedimiento Almacenado
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

--Factura Venta
create or replace function sp_factura_venta(
    succodigo integer,
    empcodigo integer,
    cajcodigo integer,
    facvennumero varchar,
    operacion integer
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si ya se encuentra el registro
	 	perform * from factura_venta 
		where suc_codigo=succodigo
		and emp_codigo=empcodigo 
		and caj_codigo=cajcodigo;
     	if found then
			 --En caso de que si, generamos una excepcion
     		 raise exception 'punto_venta';
     	elseif operacion = 1 then
			 --En caso de que no procedemos con la insercion del nuevo registro
			 insert into factura_venta(suc_codigo, emp_codigo, caj_codigo, facven_numero)
		     values(succodigo, empcodigo, cajcodigo, facvennumero);
		end if;
		 raise notice 'EL REGISTRO DE FACTURA VENTA SE INSERTO CON EXITO';
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
declare ultcod integer;
begin 
     if operacion = 1 then
     	perform * from apertura_cierre
     	where (caj_codigo=cajcodigo and apercie_estado='ABIERTO' and apercie_codigo<>aperciecodigo);
     	if found then
     		 raise exception 'caja';
     	elseif operacion = 1 then
	     insert into apertura_cierre(apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo,
	     apercie_fechahoraapertura, apercie_fechahoracierre, apercie_montoapertura, apercie_montocierre, apercie_estado)
		 values(aperciecodigo, succodigo, empcodigo, cajcodigo, usucodigo, aperciefechahoraapertura, aperciefechahoracierre,
		 aperciemontoapertura, aperciemontocierre, 'ABIERTO');
		 raise notice 'CAJA ABIERTA EXITOSAMENTE';
		end if;
    end if;
    if operacion = 2 then 
    	update apertura_cierre 
		set apercie_fechahoracierre=aperciefechahoracierre, apercie_montocierre=aperciemontocierre,
		apercie_estado='CERRADO', usu_codigo=usucodigo
		where apercie_codigo=aperciecodigo;
		raise notice 'CAJA CERRADA EXITOSAMENTE';
    end if;
end
$function$ 
language plpgsql;

--Venta cabecera
create or replace function sp_venta_cab(
    vencodigo integer,
    venfecha date,
    vennumfactura varchar,
    ventimbrado varchar,
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
) returns void as
$function$
declare ventaDet record;
		usuario varchar;
		sucursal varchar;
		empresa varchar;
		c_pedido cursor is
		select 
	 	pvc.peven_fecha,
	 	pvc.cli_codigo,
	 	p.per_nombre||' '||p.per_apellido as cliente,
	 	p.per_numerodocumento,
	 	pvc.peven_estado,
		pvc.peven_audit 
		from pedido_venta_cab pvc
		join cliente c on c.cli_codigo=pvc.cli_codigo 
		join personas p on p.per_codigo=c.per_codigo 
		where pvc.peven_codigo=pevencodigo;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si se repite el numero de factura
     	perform * from venta_cab
     	where ven_numfactura=vennumfactura and ven_estado='ACTIVO';
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'factura';
     	elseif operacion = 1 then
			 --Procedemos a insertar el nuevo registro en venta cabecera
		     insert into venta_cab(
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
			 values(
			 vencodigo, 
			 venfecha, 
			 vennumfactura, 
			 ventipofactura, 	
			 vencuota, 
			 venmontocuota, 
			 upper(veninterfecha), 
			 'ACTIVO',
			 usucodigo, 
			 clicodigo, 
			 succodigo, 	
			 empcodigo,
			 tipcocodigo,
			 ventimbrado
			 );
			 --Cargamos pedido venta
			 insert into pedido_venta(ven_codigo, peven_codigo, pedven_codigo)
		 	 values(vencodigo, pevencodigo, (select coalesce(max(pedven_codigo),0)+1 from pedido_venta));
		 	 --Cargamos libro venta
		 	 insert into libro_venta(
			 libven_codigo, 
			 ven_codigo, 
			 libven_exenta, 
			 libven_iva5, 
			 libven_iva10, 
			 libven_fecha,
		 	 libven_numcomprobante, 	
			 libven_estado,
			 tipco_codigo)
		 	 values(
			 (select coalesce(max(libven_codigo),0)+1 from libro_venta), 
			 vencodigo, 
			 0, 
			 0, 
			 0, 
			 venfecha,
		 	 vennumfactura, 
			 'ACTIVO',
			 tipcocodigo
			 );
		 	 --Cargamos cuenta cobrar
		 	 insert into cuenta_cobrar(
			 ven_codigo, 
			 cuenco_nrocuota, 
			 cuenco_monto, 
			 cuenco_saldo, 
			 cuenco_estado,
			 tipco_codigo
			 )
		 	 values(
			 vencodigo, 
			 vencuota, 
			 0, 
			 0, 
			 'ACTIVO',
			 tipcocodigo
			 );
		 	 --Actualizamos estado del pedido de venta
		 	 update pedido_venta_cab set peven_estado='VENDIDO', usu_codigo=usucodigo where peven_codigo=pevencodigo;
			 --Una vez insertado el nuevo registro, actualizamos el numero de factura en la tabla factura venta
			 update 
					factura_venta 
			 set facven_numero=split_part(vennumfactura, '-', 3)
			 where suc_codigo=succodigo
			 and emp_codigo=empcodigo
			 and caj_codigo=cajcodigo;
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'LA VENTA FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
        --En este caso realizamos un borrado logico
    	update venta_cab 
		set usu_codigo=usucodigo, ven_estado='ANULADO'
		where ven_codigo=vencodigo;
	    --Anulamos libro venta
	    update libro_venta set libven_estado='ANULADO' where ven_codigo=vencodigo;
	    --Anulamos cuenta cobrar
	    update cuenta_cobrar set cuenco_estado='ANULADO' where ven_codigo=vencodigo;
	    --Activamos el pedido de venta seleccionada
	    update pedido_venta_cab set peven_estado='TERMINADA', usu_codigo=usucodigo where peven_codigo=pevencodigo;
	    --Actualizamos el stock 
	    for ventaDet in select * from venta_det where ven_codigo=vencodigo loop
	       	update stock set st_cantidad=st_cantidad+ventaDet.vendet_cantidad 
			where it_codigo=ventaDet.it_codigo and tipit_codigo=ventaDet.tipit_codigo and dep_codigo=ventaDet.dep_codigo
	        and suc_codigo=ventaDet.suc_codigo and emp_codigo=ventaDet.emp_codigo;
        end loop;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA VENTA FUE ANULADA CON EXITO';
    end if;
	--Auditamos pedido venta
	for pedido in c_pedido loop
		--Consultamos el usuario de venta cabecera
		usuario := (select usu_login from usuario where usu_codigo=usucodigo);
		--Consultamos la sucursal de venta cabecera
		sucursal := (select suc_descripcion from sucursal where suc_codigo=succodigo);
		--Consultamos la empresa de venta cabecera
		empresa := (select emp_razonsocial from empresa where emp_codigo=empcodigo);
		--Actualizamos el audit de pedido venta
		update pedido_venta_cab 
		set peven_audit = pedido.peven_audit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usuario,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'peven_fecha', pedido.peven_fecha,
		'cli_codigo', pedido.cli_codigo,
		'cliente', pedido.cliente,
		'per_numerodocumento', pedido.per_numerodocumento,
		'emp_codigo', empcodigo,
		'emp_razonsocial', empresa,
		'suc_codigo', succodigo,
		'suc_descripcion', sucursal,
		'peven_estado', pedido.peven_estado
		)||','
		where peven_codigo = pevencodigo;
	end loop;
end
$function$ 
language plpgsql;

--Venta Detalle
create or replace function sp_venta_det(
    vencodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    vendetcantidad integer,
    vendetprecio numeric,
    operacion integer
) returns void as
$function$
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos que no se repita el item
     	perform * from venta_det
     	where it_codigo=itcodigo and dep_codigo=depcodigo and ven_codigo=vencodigo;
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
     	 	 --Insertamos nuevo registro en venta detalle
		     insert into venta_det(
			 ven_codigo, 
			 it_codigo, 
			 tipit_codigo, 
			 dep_codigo, 
			 suc_codigo,
		     emp_codigo, 
			 vendet_cantidad, 
			 vendet_precio
			 )
			 values(
			 vencodigo, 
			 itcodigo, 
			 tipitcodigo, 
			 depcodigo, 
			 succodigo, 
			 empcodigo, 
			 vendetcantidad, 
			 vendetprecio
			 );
			 --Actualizamos el stock 
			 update stock set st_cantidad=st_cantidad-vendetcantidad 
			 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			 and suc_codigo=succodigo and emp_codigo=empcodigo;
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'LA VENTA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
    	--En este caso realizamos un borrado fisico
    	delete from venta_det 
    	where ven_codigo=vencodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
        and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
       	--Actualizamos el stock 
		update stock set st_cantidad=st_cantidad+vendetcantidad 
		where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		and suc_codigo=succodigo and emp_codigo=empcodigo;
		--Enviamos un mensaje de de confirmacion de eliminacion
		raise notice 'LA VENTA DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Libro venta
create or replace function sp_libro_venta(
    vencodigo integer,
    libvenexenta numeric,
    libveniva5 numeric,
    libveniva10 numeric,
    libvennumcomprobante varchar,
    tipcocodigo integer,
    operacion integer
) returns void as
$function$
begin 
	--Validamos si la operacion es 1 0 2
	if operacion = 1 then
	 --En caso de ser 1 procedemos a sumar el monto que nos pasan por parametro
     update libro_venta 
	 set libven_exenta=libven_exenta+libvenexenta, 
		 libven_iva5=libven_iva5+libveniva5, 
     	 libven_iva10=libven_iva10+libveniva10 
	 where ven_codigo=vencodigo
	 and libven_numcomprobante=libvennumcomprobante
	 and tipco_codigo=tipcocodigo;
    end if;
    if operacion = 2 then
	--En caso de ser 2 procedemos a restar el monto que nos pasan por parametro
     update libro_venta 
	 set libven_exenta=libven_exenta-libvenexenta, 
		 libven_iva5=libven_iva5-libveniva5, 
     	 libven_iva10=libven_iva10-libveniva10 
	 where ven_codigo=vencodigo
	 and libven_numcomprobante=libvennumcomprobante
	 and tipco_codigo=tipcocodigo;
    end if;
end
$function$ 
language plpgsql;

--Cuenta Cobrar
create or replace function sp_cuenta_cobrar(
    vencodigo integer,
    cuencomonto numeric,
    cuencosaldo numeric,
    tipcocodigo integer,
    operacion integer
) returns void as
$function$
begin 
	--Validamos si la operacion es 1 0 2
	if operacion = 1 then
	  --En caso de ser 1 procedemos a sumar el monto que nos pasan por parametro
	 update	cuenta_cobrar 
	 set cuenco_monto=cuenco_monto+cuencomonto, 
	 	 cuenco_saldo=cuenco_saldo+cuencosaldo,
		 tipco_codigo=tipcocodigo
	 where ven_codigo=vencodigo;
	end if;
	if operacion = 2 then 
	 --En caso de ser 2 procedemos a restar el monto que nos pasan por parametro
	 update	cuenta_cobrar 
	 set cuenco_monto=cuenco_monto-cuencomonto, 
	 	 cuenco_saldo=cuenco_saldo-cuencosaldo,
		 tipco_codigo=tipcocodigo
	 where ven_codigo=vencodigo;
	end if;
end
$function$ 
language plpgsql;

--Cobro Cabecera
create or replace function sp_cobro_cab(
    cobcodigo integer,
    cobfecha timestamp,
    cobestado varchar,
    aperciecodigo integer,
    succodigo integer,
    empcodigo integer,
    cajcodigo integer,
    usucodigo integer,
    tipcocodigo integer,
    operacion integer 
) returns void as
$function$
declare cobroDet record;
		ventaEstado varchar;
begin 
	 --Validamos si la operacion es de insercion 
     if operacion = 1 then
      	--Procedemos a insertar el nuevo registro en cobro cabecera
		insert into cobro_cab(
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
		values(
		cobcodigo, 
		cobfecha, 
		'ACTIVO', 
		aperciecodigo, 
		succodigo, 
		empcodigo, 
		cajcodigo, 
		usucodigo,
		tipcocodigo
		);
		--Enviamos un mensaje de confirmacion de insercion
		raise notice 'EL COBRO FUE REGISTRADO CON EXITO';
    end if;
	--Validamos si la operacion es de anulacion
    if operacion = 2 then 
		--Consultamos el estado de venta cabecera
		ventaEstado := (select ven_estado from venta_cab where ven_codigo=(select distinct cd.ven_codigo from cobro_det cd where cd.cob_codigo=cobcodigo));
        --En este caso realizamos un borrado logico
    	update cobro_cab 
		set cob_estado='ANULADO', usu_codigo=usucodigo
		where cob_codigo=cobcodigo;
		--Actualizamos el monto saldo de cuentas a cobrar asociado al cobro anulado
	    for cobroDet in select * from cobro_det where cob_codigo=cobcodigo loop
	       	update cuenta_cobrar 
			set 
			cuenco_saldo=cuenco_saldo+cobroDet.cobdet_monto, 
			cuenco_estado='ACTIVO', 
			tipco_codigo=5
			where ven_codigo=cobroDet.ven_codigo;
        end loop;
		--Actualizamos el estado de venta cabecera en caso de que sea cancelado
		if ventaEstado = 'CANCELADO' then
			update venta_cab 
			set ven_estado='ACTIVO',
			usu_codigo=usucodigo  
			where ven_codigo=(select distinct cd.ven_codigo from cobro_det cd where cd.cob_codigo=cobcodigo);
		end if;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'EL COBRO FUE ANULADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Cobro Detalle
create or replace function sp_cobro_det(
    cobdetcodigo integer,
    cobcodigo integer,
    vencodigo integer,
    cobdetmonto numeric,
    cobdetnumerocuota integer,
    forcocodigo integer,
    cochenumero varchar,
    entcodigo integer,
    usucodigo integer,
    cobtatransaccion varchar,
    redpacodigo integer,
    operacion integer 
) returns void as
$function$
declare ventaEstado varchar;
begin 
   --Validamos la operacion en este caso la insercion
   --Validamos si es una insercion y si la forma de cobro es tarjeta
   if operacion = 1 and forcocodigo = 2 then
	   --Validamos que no se repita el numero de transaccion y la red de pago 
      	perform * from cobro_tarjeta	
     	where cobta_transaccion=cobtatransaccion and redpa_codigo=redpacodigo;
     	if found then
		     --En caso de ser asi generamos una excepcion
     		 raise exception 'tarjeta';
		end if;
   end if;
   --Validamos si es una insercion y si la forma de cobro es cheque 
   if operacion = 1 and forcocodigo = 3 then
      	--Validamos que no se repita el numero de cheque 
      	perform * from cobro_cheque	
     	where coche_numero=cochenumero and ent_codigo=entcodigo;
     	if found then
		     --En caso de ser asi generamos una excepcion
     		 raise exception 'cheque';
		end if;
    end if;
	--Validamos si la operacion es de insercion y si la forma de cobro es efectivo
	if operacion = 1 and forcocodigo = 1 then
		--Validamos que no se repita 2 veces la forma de cobro efectivo en el detalle
      	perform * from cobro_det	
     	where forco_codigo=forcocodigo and cob_codigo=cobcodigo and ven_codigo=vencodigo;
     	if found then
		     --En caso de ser asi generamos una excepcion
     		 raise exception 'efectivo';
		end if;
    end if;
	--Validamos si la operacion es de insercion
    if operacion = 1 then
		--Insertamos nuevo registro en cobro detalle
		insert into cobro_det(
		cobdet_codigo, 
		cob_codigo, 
		ven_codigo, 	
		cobdet_monto, 
		cobdet_numerocuota, 	
		forco_codigo
		)
		values(
		(select coalesce(max(cobdet_codigo),0)+1 from cobro_det), 
		cobcodigo, 
		vencodigo, 
		cobdetmonto, 
		cobdetnumerocuota, 
		forcocodigo
		);
		--Actualizamos saldo y tipo de comprobante en cuenta cobrar
		update cuenta_cobrar 
		set cuenco_saldo=cuenco_saldo-cobdetmonto, 
		tipco_codigo=5
		where ven_codigo=vencodigo;
		--Enviamos un mensaje de confirmacion de insercion
		raise notice 'EL DETALLE DEL COBRO FUE REGISTRADO CON EXITO';
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--Consultamos el estado de venta cabecera
		ventaEstado := (select ven_estado from venta_cab where ven_codigo=vencodigo);
        --Eliminamos el registro de cobro tarjeta en caso de que toque
    	if forcocodigo = 2 then
    	 delete from cobro_tarjeta where cobdet_codigo=cobdetcodigo;
    	end if;
		--Eliminamos el registro de cobro cheque en caso de que toque
    	if forcocodigo = 3 then
    	 delete from cobro_cheque where cobdet_codigo=cobdetcodigo;
    	end if;
		--Realizamos un borrado fisico de cobro detalle
    	delete from cobro_det where cobdet_codigo=cobdetcodigo;
		--Actualizamos registro de cuenta cobrar
    	update cuenta_cobrar 
		set cuenco_saldo=cuenco_saldo+cobdetmonto, 
			cuenco_estado='ACTIVO',
			tipco_codigo=5
		where ven_codigo=vencodigo;
		--Actualizamos registro de venta cabecera en caso de que el mismo sea cancelado
		if ventaEstado = 'CANCELADO' then
			update venta_cab 
			set ven_estado='ACTIVO',
			usu_codigo=usucodigo  
			where ven_codigo=vencodigo;
		end if;
		--Enviamos un mensaje de de confirmacion de eliminacion
		raise notice 'EL DETALLE DEL COBRO FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

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
    operacion integer --1:insert 2:update
) returns void as
$function$
declare ultcod integer;
begin 
     if operacion = 1 then
     	perform * from nota_venta_cab
     	where notven_numeronota=notvennumeronota and notvenestado='ACTIVO';
     	if found then
     		 raise exception 'nota';
     	elseif operacion = 1 then
     	 ultcod = (select coalesce(max(notven_codigo),0)+1 from nota_venta_cab);
	     insert into nota_venta_cab(notven_codigo, notven_fecha, notven_numeronota, notven_concepto, 
	     notven_estado, tipco_codigo, ven_codigo, suc_codigo, emp_codigo, usu_codigo, cli_codigo)
		 values(ultcod, notvenfecha, notvennumeronota, upper(notvenconcepto), 
		 'ACTIVO', tipcocodigo, vencodigo, succodigo, empcodigo, usucodigo, clicodigo);
		 raise notice 'LA NOTA DE VENTA FUE REGISTRADA CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
    	update nota_venta_cab 
		set notven_estado='ANULADO'
		where notven_codigo=notvencodigo;
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
    operacion integer --1:insert 2:update
) returns void as
$function$
begin 
     if operacion = 1 then
     	perform * from nota_venta_det
     	where it_codigo=itcodigo and notven_codigo=notvencodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
		     insert into nota_venta_det(notven_codigo, it_codigo, tipit_codigo, notvendet_cantidad, notvendet_precio)
			 values(notvencodigo, itcodigo, tipitcodigo, notvendetcantidad, notvendetprecio);
			 raise notice 'LA NOTA DE VENTA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
    	delete from nota_venta_det 
    	where notven_codigo=notvencodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'LA NOTA DE VENTA DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

