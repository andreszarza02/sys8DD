create or replace view v_pedido_compra_cab as
select 
	pcc.pedco_codigo,
	pcc.pedco_fecha,
	pcc.pedco_estado,
	pcc.suc_codigo,
	pcc.emp_codigo,
	pcc.usu_codigo,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial
from pedido_compra_cab pcc 
join usuario u on u.usu_codigo=pcc.usu_codigo
join funcionario f on f.func_codigo=u.func_codigo
join personas p on p.per_codigo=f.per_codigo 
join sucursal s on s.suc_codigo=pcc.suc_codigo and s.emp_codigo=pcc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by pcc.pedco_codigo;

create or replace view v_pedido_compra_det as
select
	pcd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	pcd.pedcodet_cantidad*pcd.pedcodet_precio as subtotal
from pedido_compra_det pcd 
join items i on i.it_codigo=pcd.it_codigo
and i.tipit_codigo=pcd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
join unidad_medida um on um.unime_codigo=i.unime_codigo
order by pcd.pedco_codigo;

create or replace view v_presupuesto_proveedor_cab as
select 
	ppc.prepro_codigo,
	ppc.prepro_fechaactual,
	ppc.prepro_fechavencimiento,
	ppc.prepro_estado,	
	u.usu_login,
	p.pro_razonsocial,
	p.pro_ruc,
	tp.tipro_codigo,
	tp.tipro_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	pp.pedco_codigo,
	ppc.pro_codigo 
from presupuesto_proveedor_cab ppc
join usuario u on u.usu_codigo=ppc.usu_codigo
join proveedor p on p.pro_codigo=ppc.pro_codigo
and p.tipro_codigo=ppc.tipro_codigo
join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
join sucursal s on s.suc_codigo=ppc.suc_codigo 
and s.emp_codigo=ppc.emp_codigo 
join empresa e on e.emp_codigo=s.emp_codigo
join pedido_presupuesto pp on pp.prepro_codigo=ppc.prepro_codigo
order by ppc.prepro_codigo;

create or replace view v_presupuesto_proveedor_det as
select
	ppd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	(case i.tipim_codigo when 1 then ppd.peprodet_cantidad * ppd.peprodet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ppd.peprodet_cantidad * ppd.peprodet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ppd.peprodet_cantidad * ppd.peprodet_precio else 0 end) as exenta
from presupuesto_proveedor_det ppd 
join items i on i.it_codigo=ppd.it_codigo
and i.tipit_codigo=ppd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
join unidad_medida um on um.unime_codigo=i.unime_codigo
order by ppd.prepro_codigo, ppd.it_codigo;

create or replace view v_orden_compra_cab as
select 
	occ.orcom_codigo,
	occ.orcom_fecha,
	occ.orcom_condicionpago,
	occ.orcom_cuota,
	occ.orcom_montocuota,
	occ.orcom_interfecha,
	occ.pro_codigo,
	occ.orcom_estado,
	p.pro_razonsocial,
	occ.tipro_codigo,
	tp.tipro_descripcion,
	occ.usu_codigo,
	u.usu_login,
	occ.suc_codigo,
	s.suc_descripcion,
	occ.emp_codigo,
	e.emp_razonsocial,
	po.prepro_codigo,
	pepre.pedco_codigo
from orden_compra_cab occ
join usuario u on u.usu_codigo=occ.usu_codigo
join proveedor p on p.pro_codigo=occ.pro_codigo
and p.tipro_codigo=occ.tipro_codigo
join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
join sucursal s on s.suc_codigo=occ.suc_codigo
and s.emp_codigo=occ.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
join presupuesto_orden po on po.orcom_codigo=occ.orcom_codigo
join pedido_presupuesto pepre on pepre.prepro_codigo=po.prepro_codigo
order by occ.orcom_codigo;

create or replace view v_orden_compra_det as
select 
	ocd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	(case i.tipim_codigo when 1 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as exenta
from orden_compra_det ocd
join items i on i.it_codigo=ocd.it_codigo 
and i.tipit_codigo=ocd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
join unidad_medida um on um.unime_codigo=i.unime_codigo
order by ocd.orcom_codigo;

create or replace view v_ajuste_stock_cab as
select 
	aju.ajus_codigo,
	aju.ajus_fecha,
	aju.ajus_tipoajuste,
	aju.ajus_estado,
	aju.suc_codigo,
	aju.emp_codigo,
	aju.usu_codigo,
	u.usu_login,
	e.emp_razonsocial,
	s.suc_descripcion
from ajuste_stock_cab aju
join usuario u on u.usu_codigo=aju.usu_codigo
join sucursal s on s.suc_codigo=aju.suc_codigo
and s.emp_codigo=aju.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by aju.ajus_codigo;

create or replace view v_ajuste_stock_det as
select
	ajust.*,
	(case 
	when i.tipit_codigo in(1, 3, 4)
		then 
			i.it_descripcion 
		else 
			i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion 
	end) as it_descripcion,
	ti.tipit_descripcion,
	d.dep_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	ajust.ajusdet_cantidad*ajust.ajusdet_precio as subtotal
from ajuste_stock_det ajust
	join stock s on s.it_codigo=ajust.it_codigo
	and s.tipit_codigo=ajust.tipit_codigo and
	s.dep_codigo=ajust.dep_codigo and s.suc_codigo=ajust.suc_codigo
	and s.emp_codigo=ajust.emp_codigo
	join items i on i.it_codigo=s.it_codigo 
	and i.tipit_codigo=s.tipit_codigo 
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
	join deposito d on d.dep_codigo=s.dep_codigo and
	d.suc_codigo=s.suc_codigo and d.emp_codigo=s.emp_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo
	order by ajust.ajus_codigo, ajust.it_codigo;

create or replace view v_compra_cab as
select 
	cc.comp_codigo,
	cc.comp_fecha,
	cc.comp_numfactura,
	cc.comp_tipofactura,
	cc.comp_cuota,
	cc.comp_interfecha,
	cc.comp_estado,
	cc.pro_codigo,
	cc.tipro_codigo,
	cc.suc_codigo,
	cc.emp_codigo,
	cc.usu_codigo,
	cc.comp_montocuota,
	cc.comp_timbrado,
	cc.tipco_codigo,
	cc.comp_timbrado_venc,
	p.pro_razonsocial,
	tp.tipro_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	u.usu_login,
	tc.tipco_descripcion ,
	oc.orcom_codigo
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
order by cc.comp_codigo;

create or replace view v_compra_det as
select 
	cd.*,
	i.tipim_codigo,
	i.it_descripcion,
	ti.tipit_descripcion,
	d.dep_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	(case i.tipim_codigo when 1 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as exenta
from compra_det cd
	join stock s on s.it_codigo=cd.it_codigo
	and s.tipit_codigo=cd.tipit_codigo
	and s.dep_codigo=cd.dep_codigo 
	and s.suc_codigo=cd.suc_codigo
	and s.emp_codigo=cd.emp_codigo
	join items i on i.it_codigo=s.it_codigo
	and i.tipit_codigo=s.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
	join deposito d on d.dep_codigo=s.dep_codigo
	and d.suc_codigo=s.suc_codigo
	and d.emp_codigo=s.emp_codigo 
	join sucursal su on su.suc_codigo=d.suc_codigo
	and su.emp_codigo=d.emp_codigo
	join empresa e on e.emp_codigo=su.emp_codigo
	join unidad_medida um on um.unime_codigo=i.unime_codigo
order by cd.comp_codigo, cd.it_codigo;

create or replace view v_nota_compra_cab as
select 
	ncc.nocom_codigo,
	ncc.nocom_fecha,
	ncc.nocom_numeronota,
	ncc.nocom_concepto,
	ncc.nocom_estado,
	ncc.tipco_codigo,
	ncc.suc_codigo,
	ncc.emp_codigo,
	ncc.usu_codigo,
	ncc.comp_codigo,
	ncc.pro_codigo,
	ncc.tipro_codigo,
	ncc.nocom_timbrado,
	ncc.nocom_timbrado_venc,
	ncc.nocom_chapa,
	nocom_funcionario,
	tc.tipco_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	u.usu_login,
	cc.comp_numfactura,
	p.pro_razonsocial,
	tp.tipro_descripcion,
	cc2.comp_tipofactura,
	cc.comp_cuota
from nota_compra_cab ncc
	join compra_cab cc2 on cc2.comp_codigo=ncc.comp_codigo 
	join tipo_comprobante tc on tc.tipco_codigo=ncc.tipco_codigo
	join sucursal s on s.suc_codigo=ncc.suc_codigo
	and s.emp_codigo=ncc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo 
	join usuario u on u.usu_codigo=ncc.usu_codigo
	join compra_cab cc on cc.comp_codigo=ncc.comp_codigo
	join proveedor p on p.pro_codigo=ncc.pro_codigo
	and p.tipro_codigo=ncc.tipro_codigo
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
order by ncc.nocom_codigo;

create or replace view v_nota_compra_det as
select 
	ncd.*,
	i.tipim_codigo,
	i.it_descripcion,
	ti.tipit_descripcion,
	um.unime_descripcion,
	d.dep_descripcion,
	(case i.tipim_codigo when 1 then ncd.nocomdet_cantidad * ncd.nocomdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ncd.nocomdet_cantidad * ncd.nocomdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ncd.nocomdet_cantidad * ncd.nocomdet_precio else 0 end) as exenta
from nota_compra_det ncd
	join items i on i.it_codigo=ncd.it_codigo
	and i.tipit_codigo=ncd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
	join unidad_medida um on um.unime_codigo=i.unime_codigo
	join deposito d on d.dep_codigo=ncd.dep_codigo
order by ncd.nocom_codigo, ncd.it_codigo;

create or replace view v_nota_venta_cab as
select 
	nvc.*,
	vc.ven_numfactura as factura,
	tc.tipco_descripcion,
	p.per_nombre||' '||p.per_apellido as cliente,
	u.usu_login,
	e.emp_razonsocial,
	s.suc_descripcion,
	p.per_numerodocumento as cedula
from nota_venta_cab nvc
join tipo_comprobante tc on tc.tipco_codigo=nvc.tipco_codigo
join venta_cab vc on vc.ven_codigo=nvc.ven_codigo
join sucursal s on s.suc_codigo=nvc.suc_codigo
and s.emp_codigo=nvc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
join usuario u on u.usu_codigo=nvc.usu_codigo
join cliente c on c.cli_codigo=nvc.cli_codigo
join personas p on p.per_codigo=c.per_codigo
order by nvc.notven_codigo;

create or replace view v_nota_venta_det as
select 
	nvd.*,
	i.it_descripcion||' '||m.mod_codigomodelo as descripcion,
	i.it_descripcion,
	ti.tipit_descripcion,
	t.tall_descripcion,
	um.unime_descripcion,
	(case i.tipim_codigo when 1 then nvd.notvendet_cantidad * nvd.notvendet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then nvd.notvendet_cantidad * nvd.notvendet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then nvd.notvendet_cantidad * nvd.notvendet_precio else 0 end) as exenta
from nota_venta_det nvd
   join nota_venta_cab nvc on nvc.notven_codigo=nvd.notven_codigo
   join items i on i.it_codigo=nvd.it_codigo
   and i.tipit_codigo=nvd.tipit_codigo
   join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
   join talle t on t.tall_codigo=i.tall_codigo
   join modelo m on m.mod_codigo=i.mod_codigo
   join stock s on s.it_codigo=i.it_codigo
   and s.tipit_codigo=i.tipit_codigo
   join unidad_medida um on um.unime_codigo=s.unime_codigo
   join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
order by nvd.notven_codigo;

create or replace view v_gui_referenciales as
select
	table_name,
	--Nombre de las tablas a mostrar
    (case 
    	when table_name='asignacion_permiso_usuario' then
    					'ASIGNACION PERMISO USUARIO'
    	when table_name='caja' then
    					'CAJA'
    	when table_name='cargo' then
    					'CARGO'
    	when table_name='ciudad' then
    					'CIUDAD'
    	when table_name='cliente' then
    					'CLIENTE'
    	when table_name='color_prenda' then
    					'COLOR PRENDA'
    	when table_name='deposito' then
    					'DEPOSITO'
    	when table_name='empresa' then
    					'EMPRESA'
    	when table_name='entidad_adherida' then
    					'ENTIDAD ADHERIDA'
    	when table_name='entidad_emisora' then
    					'ENTIDAD EMISORA'
    	when table_name='equipo_trabajo' then
    					'EQUIPO TRABAJO'
    	when table_name='etapa_produccion' then
    					'ETAPA PRODUCCION'
    	when table_name='forma_cobro' then
    					'FORMA COBRO'
    	when table_name='funcionario' then
    					'FUNCIONARIO'
    	when table_name='gui' then
    					'GUI'
    	when table_name='items' then
    					'ITEMS'
    	when table_name='maquinaria' then
    					'MAQUINARIA'
    	when table_name='modelo' then
    					'MODELO'
    	when table_name='modulo' then
    					'MODULO'
    	when table_name='parametro_control_calidad' then
    					'PARAMETRO CONTROL CALIDAD'
    	when table_name='perfil' then
    					'PERFIL'
    	when table_name='perfil_gui' then
    					'PERFIL GUI'
    	when table_name='perfiles_permisos' then
    					'PERFIL PERMISO'
    	when table_name='permisos' then
    					'PERMISOS'
    	when table_name='personas' then
    					'PERSONAS'
    	when table_name='proveedor' then
    					'PROVEEDOR'
    	when table_name='seccion' then
    					'SECCION'
    	when table_name='sucursal' then
    					'SUCURSAL'
    	when table_name='talle' then
    					'TALLE'
    	when table_name='tipo_comprobante' then
    					'TIPO COMPROBANTE'
    	when table_name='tipo_documento' then
    					'TIPO DOCUMENTO'
    	when table_name='tipo_etapa_produccion' then
    					'TIPO ETAPA PRODUCCION'
    	when table_name='tipo_impuesto' then
    					'TIPO IMPUESTO'
    	when table_name='tipo_item' then
    					'TIPO ITEM'
    	when table_name='tipo_proveedor' then
    					'TIPO PROVEEDOR'
    	when table_name='unidad_medida' then
    					'UNIDAD MEDIDA'
    	when table_name='usuario' then
    					'USUARIO'
    	when table_name='pedido_compra_cab' then
    					'PEDIDO COMPRA'
    	when table_name='presupuesto_proveedor_cab' then
    					'PRESUPUESTO PROVEEDOR'
    	when table_name='orden_compra_cab' then
    					'ORDEN COMPRA'
    	when table_name='compra_cab' then
    					'COMPRA'
    	when table_name='nota_compra_cab' then
    					'NOTA COMPRA'
    	when table_name='presupuesto_cab' then
    					'PRESUPUESTO PRODUCCION'
    	when table_name='orden_produccion_cab' then
    					'ORDEN PRODUCCION'
    	when table_name='produccion_cab' then
    					'PRODUCCION'
    	when table_name='etapa_produccion' then
    					'ETAPA PRODUCCION'
    	when table_name='control_calidad_cab' then
    					'CONTROL CALIDAD'
    	when table_name='produccion_terminada_cab' then
    					'CONTROL CALIDAD'
    	when table_name='mermas_cab' then
    					'MERMAS'
    	when table_name='costo_produccion_cab' then
    					'COSTO PRODUCCION'
    	when table_name='pedido_venta' then
    					'PEDIDO VENTA'
    	when table_name='apertura_cierre' then
    					'APERTURA CIERRE'
    	when table_name='venta_cab' then
    					'VENTA'
    	when table_name='cobro_cab' then
    					'COBRO'
    	when table_name='nota_venta_cab' then
    					'NOTA VENTA'
    	when table_name='pedido_presupuesto' then
    					'REPORTE REFERENCIAL SEGURIDAD'
    	when table_name='presupuesto_orden' then
    					'REPORTE REFERENCIAL COMPRA'
    	when table_name='orden_compra' then
    					'REPORTE MOVIMIENTO COMPRA'
    	when table_name='cuenta_pagar' then
    					'REPORTE REFERENCIAL PRODUCCION'
    	when table_name='libro_compra' then
    					'REPORTE MOVIMIENTO PRODUCCION'
    	when table_name='cuenta_cobrar' then
    					'REPORTE REFERENCIAL VENTA'
    	when table_name='libro_venta' then
    					'REPORTE MOVIMIENTO VENTA'
    	else 'NER'
     end) as gui_referencial,
     --URL de las tablas a mostrar dentro de la carpeta sys8DD
     (case 
    	when table_name='asignacion_permiso_usuario' then
    					'/sys8DD/referenciales/seguridad/asignacion_permiso_usuario/index.php'
    	when table_name='caja' then
    					'/sys8DD/referenciales/venta/caja/index.php'
    	when table_name='cargo' then
    					'/sys8DD/referenciales/produccion/cargo/index.php'
    	when table_name='ciudad' then
    					'/sys8DD/referenciales/compra/ciudad/index.php'
    	when table_name='cliente' then
    					'/sys8DD/referenciales/venta/clientes/index.php'
    	when table_name='color_prenda' then
    					'/sys8DD/referenciales/produccion/color_prenda/index.php'
    	when table_name='deposito' then
    					'/sys8DD/referenciales/compra/deposito/index.php'
    	when table_name='empresa' then
    					'/sys8DD/referenciales/compra/empresa/index.php'
    	when table_name='entidad_adherida' then
    					'/sys8DD/referenciales/venta/entidad_adherida/index.php'
    	when table_name='entidad_emisora' then
    					'/sys8DD/referenciales/venta/entidad_emisora/index.php'
    	when table_name='equipo_trabajo' then
    					'/sys8DD/referenciales/produccion/equipo_trabajo/index.php'
    	when table_name='forma_cobro' then
    					'/sys8DD/referenciales/venta/forma_cobro/index.php'
    	when table_name='funcionario' then
    					'/sys8DD/referenciales/produccion/funcionario/index.php'
    	when table_name='gui' then
    					'/sys8DD/referenciales/seguridad/gui/index.php'
    	when table_name='items' then
    					'/sys8DD/referenciales/compra/items/index.php'
    	when table_name='maquinaria' then
    					'/sys8DD/referenciales/produccion/maquinaria/index.php'
    	when table_name='modelo' then
    					'/sys8DD/referenciales/produccion/modelo/index.php'
    	when table_name='modulo' then
    					'/sys8DD/referenciales/seguridad/modulo/index.php'
    	when table_name='parametro_control_calidad' then
    					'/sys8DD/referenciales/produccion/parametro_control_calidad/index.php'
    	when table_name='perfil' then
    					'/sys8DD/referenciales/seguridad/perfil/index.php'
    	when table_name='perfil_gui' then
    					'/sys8DD/referenciales/seguridad/perfil_gui/index.php'
    	when table_name='perfiles_permisos' then
    					'/sys8DD/referenciales/seguridad/perfiles_permisos/index.php'
    	when table_name='permisos' then
    					'/sys8DD/referenciales/seguridad/permisos/index.php'
    	when table_name='personas' then
    					'/sys8DD/referenciales/produccion/personas/index.php'
    	when table_name='proveedor' then
    					'/sys8DD/referenciales/compra/proveedor/index.php'
    	when table_name='seccion' then
    					'/sys8DD/referenciales/produccion/seccion/index.php'
    	when table_name='sucursal' then
    					'/sys8DD/referenciales/compra/sucursal/index.php'
    	when table_name='talle' then
    					'/sys8DD/referenciales/produccion/talle/index.php'
    	when table_name='tipo_comprobante' then
    					'/sys8DD/referenciales/venta/tipo_comprobante/index.php'
    	when table_name='tipo_documento' then
    					'/sys8DD/referenciales/venta/tipo_documento/index.php'
    	when table_name='tipo_etapa_produccion' then
    					'/sys8DD/referenciales/produccion/tipo_etapa_produccion/index.php'
    	when table_name='tipo_impuesto' then
    					'/sys8DD/referenciales/compra/tipo_impuesto/index.php'
    	when table_name='tipo_item' then
    					'/sys8DD/referenciales/compra/tipo_item/index.php'
    	when table_name='tipo_proveedor' then
    					'/sys8DD/referenciales/compra/tipo_proveedor/index.php'
    	when table_name='unidad_medida' then
    					'/sys8DD/referenciales/produccion/talle/index.php'
    	when table_name='usuario' then
    					'/sys8DD/referenciales/seguridad/usuario/index.php'
    	when table_name='pedido_compra_cab' then
    					'/sys8DD/modulos/compra/pedido_compra/index.php'
    	when table_name='presupuesto_proveedor_cab' then
    					'/sys8DD/modulos/compra/presupuesto_proveedor/index.php'
    	when table_name='orden_compra_cab' then
    					'/sys8DD/modulos/compra/orden_compra/index.php'
    	when table_name='compra_cab' then
    					'/sys8DD/modulos/compra/compra/index.php'
    	when table_name='nota_compra_cab' then
    					'/sys8DD/modulos/compra/nota_compra/index.php'
    	when table_name='presupuesto_cab' then
    					'/sys8DD/modulos/produccion/presupuesto/index.php'
    	when table_name='orden_produccion_cab' then
    					'/sys8DD/modulos/produccion/orden_produccion/index.php'
    	when table_name='produccion_cab' then
    					'/sys8DD/modulos/produccion/produccion/index.php'
    	when table_name='etapa_produccion' then
    					'/sys8DD/modulos/produccion/etapa_produccion/index.php'
    	when table_name='control_calidad_cab' then
    					'/sys8DD/modulos/produccion/control_calidad/index.php'
    	when table_name='produccion_terminada_cab' then
    					'/sys8DD/modulos/produccion/produccion_terminada/index.php'
    	when table_name='mermas_cab' then
    					'/sys8DD/modulos/produccion/mermas/index.php'
    	when table_name='costo_produccion_cab' then
    					'/sys8DD/modulos/produccion/costo_produccion/index.php'
    	when table_name='pedido_venta' then
    					'/sys8DD/modulos/venta/pedido_venta/index.php'
    	when table_name='apertura_cierre' then
    					'/sys8DD/modulos/venta/apertura_cierre/index.php'
    	when table_name='venta_cab' then
    					'/sys8DD/modulos/venta/venta/index.php'
    	when table_name='cobro_cab' then
    					'/sys8DD/modulos/venta/cobros/index.php'
    	when table_name='nota_venta_cab' then
    					'/sys8DD/modulos/venta/nota_venta/index.php'
    	when table_name='pedido_presupuesto' then
    					'/sys8DD/report/seguridad/informe_referencial.php'
    	when table_name='presupuesto_orden' then
    					'/sys8DD/report/compras/informe_referencial.php'
    	when table_name='orden_compra' then
    					'/sys8DD/report/compras/informe_movimiento.php'
    	when table_name='cuenta_pagar' then
    					'/sys8DD/report/produccion/informe_referencial.php'
    	when table_name='libro_compra' then
    					'/sys8DD/report/produccion/informe_movimiento.php'
    	when table_name='cuenta_cobrar' then
    					'/sys8DD/report/ventas/informe_referencial.php'
    	when table_name='libro_venta' then
    					'/sys8DD/report/ventas/informe_movimiento.php'
    	else 'NER'
     end) as gui_link
--Consltamos las tablas del esquema del sistema
from information_schema.tables 
where 
	--Validamos que solo se consulte solo las tablas de usuario
	table_schema not in ('pg_catalog', 'information_schema') 
	--Validamos solo traer las tablas que se crean con el CREATE TABLE
	and table_type in('BASE TABLE', 'VIEW')
	--Validamos traer solo las tablas de la base de datos sys8DD
	and table_catalog = 'sys8DD';

   create or replace view v_gui_movimiento as
select
	pg.perf_codigo,
	(case 
    	when g.gui_descripcion ='PEDIDO COMPRA' then
    					'PEDIDO COMPRA'
    	when g.gui_descripcion ='PRESUPUESTO PROVEEDOR' then
    					'PRESUPUESTO PROVEEDOR'
    	when g.gui_descripcion ='ORDEN COMPRA' then
    					'ORDEN COMPRA'
    	when g.gui_descripcion ='COMPRA' then
    					'COMPRA'
    	when g.gui_descripcion ='AJUSTE INVENTARIO' then
    					'AJUSTE INVENTARIO'
    	when g.gui_descripcion ='NOTA COMPRA' then
    					'NOTA COMPRA'
    	when g.gui_descripcion ='PRESUPUESTO PRODUCCION' then
    					'PRESUPUESTO PRODUCCION'
    	when g.gui_descripcion ='ORDEN PRODUCCION' then
    					'ORDEN PRODUCCION'
    	when g.gui_descripcion ='PRODUCCION' then
    					'PRODUCCION'
    	when g.gui_descripcion ='ETAPA PRODUCCION' then
    					'ETAPA PRODUCCION'
    	when g.gui_descripcion ='CONTROL CALIDAD' then
    					'CONTROL CALIDAD'
    	when g.gui_descripcion ='PRODUCCION TERMINADA' then
    					'PRODUCCION TERMINADA'
    	when g.gui_descripcion ='MERMAS' then
    					'MERMAS'
    	when g.gui_descripcion ='COSTO PRODUCCION' then
    					'COSTO PRODUCCION'
    	when g.gui_descripcion ='PEDIDO VENTA' then
    					'PEDIDO VENTA'
    	when g.gui_descripcion ='APERTURA CIERRE' then
    					'APERTURA CIERRE'
    	when g.gui_descripcion ='VENTA' then
    					'VENTA'
    	when g.gui_descripcion ='COBRO' then
    					'COBRO'
    	when g.gui_descripcion ='NOTA VENTA' then
    					'NOTA VENTA'
    	when g.gui_descripcion ='REPORTE REFERENCIAL SEGURIDAD' then
    					'REPORTE REFERENCIAL SEGURIDAD'
    	when g.gui_descripcion ='REPORTE REFERENCIAL COMPRAS' then
    					'REPORTE REFERENCIAL COMPRAS'
    	when g.gui_descripcion ='REPORTE MOVIMIENTO COMPRAS' then
    					'REPORTE MOVIMIENTO COMPRAS'
    	when g.gui_descripcion ='REPORTE REFERENCIAL PRODUCCION' then
    					'REPORTE REFERENCIAL PRODUCCION'
    	when g.gui_descripcion ='REPORTE MOVIMIENTO PRODUCCION' then
    					'REPORTE MOVIMIENTO PRODUCCION'
    	when g.gui_descripcion ='REPORTE REFERENCIAL VENTAS' then
    					'REPORTE REFERENCIAL VENTAS'
    	when g.gui_descripcion ='REPORTE MOVIMIENTO VENTAS' then
    					'REPORTE MOVIMIENTO VENTAS'
    	else 'NER'
     end) as gui_movimiento,
     (case 
    	when g.gui_descripcion = 'PEDIDO COMPRA' then
    					'/sys8DD/modulos/compra/pedido_compra/index.php'
    	when g.gui_descripcion = 'PRESUPUESTO PROVEEDOR' then
    					'/sys8DD/modulos/compra/presupuesto_proveedor/index.php'
    	when g.gui_descripcion = 'ORDEN COMPRA' then
    					'/sys8DD/modulos/compra/orden_compra/index.php'
    	when g.gui_descripcion = 'COMPRA' then
    					'/sys8DD/modulos/compra/compra/index.php'
    	when g.gui_descripcion = 'AJUSTE INVENTARIO' then
    					'/sys8DD/modulos/compra/ajuste_inventario/index.php'
    	when g.gui_descripcion = 'NOTA COMPRA' then
    					'/sys8DD/modulos/compra/nota_compra/index.php'
    	when g.gui_descripcion = 'PRESUPUESTO PRODUCCION' then
    					'/sys8DD/modulos/produccion/presupuesto/index.php'
    	when g.gui_descripcion = 'ORDEN PRODUCCION' then
    					'/sys8DD/modulos/produccion/orden_produccion/index.php'
    	when g.gui_descripcion = 'PRODUCCION' then
    					'/sys8DD/modulos/produccion/produccion/index.php'
    	when g.gui_descripcion = 'ETAPA PRODUCCION' then
    					'/sys8DD/modulos/produccion/etapa_produccion/index.php'
    	when g.gui_descripcion = 'CONTROL CALIDAD' then
    					'/sys8DD/modulos/produccion/control_calidad/index.php'
    	when g.gui_descripcion ='PRODUCCION TERMINADA' then
    					'/sys8DD/modulos/produccion/produccion_terminada/index.php'
    	when g.gui_descripcion = 'MERMAS' then
    					'/sys8DD/modulos/produccion/mermas/index.php'
    	when g.gui_descripcion = 'COSTO PRODUCCION' then
    					'/sys8DD/modulos/produccion/costo_produccion/index.php'
    	when g.gui_descripcion = 'PEDIDO VENTA' then
    					'/sys8DD/modulos/venta/pedido_venta/index.php'
    	when g.gui_descripcion = 'APERTURA CIERRE' then
    					'/sys8DD/modulos/venta/apertura_cierre/index.php'
    	when g.gui_descripcion = 'VENTA' then
    					'/sys8DD/modulos/venta/venta/index.php'
    	when g.gui_descripcion = 'COBRO' then
    					'/sys8DD/modulos/venta/cobros/index.php'
    	when g.gui_descripcion = 'NOTA VENTA' then
    					'/sys8DD/modulos/venta/nota_venta/index.php'
    	when g.gui_descripcion = 'REPORTE REFERENCIAL SEGURIDAD' then
    					'/sys8DD/report/seguridad/informe_referencial.php'
    	when g.gui_descripcion = 'REPORTE REFERENCIAL COMPRAS' then
    					'/sys8DD/report/compras/informe_referencial.php'
    	when g.gui_descripcion = 'REPORTE MOVIMIENTO COMPRAS' then
    					'/sys8DD/report/compras/informe_movimiento.php'
    	when g.gui_descripcion = 'REPORTE REFERENCIAL PRODUCCION' then
    					'/sys8DD/report/produccion/informe_referencial.php'
    	when g.gui_descripcion = 'REPORTE MOVIMIENTO PRODUCCION' then
    					'/sys8DD/report/produccion/informe_movimiento.php'
    	when g.gui_descripcion = 'REPORTE REFERENCIAL VENTAS' then
    					'/sys8DD/report/ventas/informe_referencial.php'
    	when g.gui_descripcion ='REPORTE MOVIMIENTO VENTAS' then
    					'/sys8DD/report/ventas/informe_movimiento.php'
    	else 'NER'
     end) as gui_link	
from perfil_gui pg 
	join perfil p on p.perf_codigo=pg.perf_codigo 
	join gui g on g.gui_codigo=pg.gui_codigo 
	and g.modu_codigo=pg.modu_codigo
where pg.perfgui_estado='ACTIVO';