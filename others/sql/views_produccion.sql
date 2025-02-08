create or replace view v_pedido_produccion_cab as
select 
	ppc.*,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial
from pedido_produccion_cab ppc 
join usuario u on u.usu_codigo=ppc.usu_codigo 
join sucursal s on s.suc_codigo=ppc.suc_codigo and s.emp_codigo=ppc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by ppc.pedpro_codigo;

create or replace view v_pedido_produccion_det as
select
	ppd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	(case i.tipim_codigo when 1 then ppd.pedprodet_cantidad * ppd.pedprodet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ppd.pedprodet_cantidad * ppd.pedprodet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ppd.pedprodet_cantidad * ppd.pedprodet_precio else 0 end) as exenta
from pedido_produccion_det ppd 
join items i on i.it_codigo=ppd.it_codigo
and i.tipit_codigo=ppd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
order by ppd.pedpro_codigo;

create or replace view v_presupuesto_cab as
select 
	pc.pres_codigo,
	pc.pres_fecharegistro,
	pc.pres_fechavencimiento,
	p.per_nombre||' '||p.per_apellido as cliente,
	pc.peven_codigo,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	pc.pres_estado 
from presupuesto_cab pc
join usuario u on u.usu_codigo=pc.usu_codigo
join sucursal s on s.suc_codigo=pc.suc_codigo
and s.emp_codigo=pc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
join cliente c on c.cli_codigo=pc.cli_codigo
join personas p on p.per_codigo=c.per_codigo
order by pc.pres_codigo;

create or replace view v_presupuesto_det as
select 
	pd.*,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	t.tall_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	(case i.tipim_codigo when 1 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as exenta
from presupuesto_det pd
join items i on i.it_codigo=pd.it_codigo
and i.tipit_codigo=pd.tipit_codigo
join modelo m on m.mod_codigo=i.mod_codigo
join talle t on t.tall_codigo=i.tall_codigo 
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join unidad_medida um on um.unime_codigo=i.unime_codigo 
order by pd.pres_codigo;

create or replace view v_orden_produccion_det as
select 
	opd.orpro_codigo,
	opd.it_codigo,
	opd.tipit_codigo,
	opd.orprodet_cantidad,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	t.tall_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	case 
        when opd.orprodet_especificacion is null or opd.orprodet_especificacion = '' 
        then 'SIN ESPECIFICACION' 
        else opd.	 
    end as orprodet_especificacion
from orden_produccion_det opd
	join items i on i.it_codigo=opd.it_codigo
	and i.tipit_codigo=opd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
	join unidad_medida um on um.unime_codigo=i.unime_codigo 
order by opd.orpro_codigo;

create or replace view v_orden_produccion_cab as
select 
	opc.orpro_codigo,
	opc.orpro_fecha,
	opc.orpro_fechainicio,
	opc.orpro_fechaculminacion,
	opc.usu_codigo,
	opc.suc_codigo,
	opc.emp_codigo,
	opc.secc_codigo,
	p.per_nombre||' '||p.per_apellido as cliente,
	p.per_numerodocumento,
	op.pres_codigo,
	pc.peven_codigo,
	se.secc_descripcion,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	opc.orpro_estado
from orden_produccion_cab opc
	join usuario u on u.usu_codigo=opc.usu_codigo
	join sucursal s on s.suc_codigo=opc.suc_codigo 
	and s.emp_codigo=opc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
	join seccion se on se.secc_codigo=opc.secc_codigo
	join orden_presupuesto op on op.orpro_codigo=opc.orpro_codigo
	join presupuesto_cab pc on pc.pres_codigo=op.pres_codigo
	join cliente c on c.cli_codigo=pc.cli_codigo
	join personas p on p.per_codigo=c.per_codigo 
order by opc.orpro_codigo;

create or replace view v_produccion_cab as
select 
	pc.prod_codigo,
	pc.prod_fecha,
	pc.prod_estado,
	pc.orpro_codigo,
	pc.usu_codigo,
	pc.suc_codigo,
	pc.emp_codigo,
	opc.orpro_fechainicio,
	opc.orpro_fechaculminacion,
	s.secc_descripcion,
	u.usu_login,
	s2.suc_descripcion,
	e.emp_razonsocial 
from produccion_cab pc 
	join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
	join seccion s on s.secc_codigo=opc.secc_codigo 
	join usuario u on u.usu_codigo=pc.usu_codigo 
	join sucursal s2 on s2.suc_codigo=pc.suc_codigo 
	and s2.emp_codigo=pc.emp_codigo
	join empresa e on e.emp_codigo=s2.emp_codigo 
order by pc.prod_codigo;

create or replace view v_produccion_det as
select 
	pd.*,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	t.tall_descripcion,
	um.unime_codigo,
	um.unime_descripcion
from produccion_det pd
	join items i on i.it_codigo=pd.it_codigo
	and i.tipit_codigo=pd.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo 
	join talle t on t.tall_codigo=i.tall_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo 
order by pd.prod_codigo;

create or replace view v_etapa_produccion as 
select 
	ep.*,
	s.secc_descripcion,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	t.tall_descripcion,
	tep.tipet_descripcion,
	m2.maq_descripcion,
	u.usu_login,
	s2.suc_descripcion,
	e.emp_razonsocial,
	pd.prodet_estado 
from etapa_produccion ep 
	join produccion_det pd on pd.prod_codigo=ep.prod_codigo 
	and pd.it_codigo=ep.it_codigo 
	and pd.tipit_codigo=ep.tipit_codigo 
	join items i on i.it_codigo=pd.it_codigo 
	and i.tipit_codigo=pd.tipit_codigo 
	join modelo m on m.mod_codigo=i.mod_codigo 
	join talle t on t.tall_codigo=i.tall_codigo 
	join produccion_cab pc on pc.prod_codigo=pd.prod_codigo 
	join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo
	join seccion s on s.secc_codigo=opc.secc_codigo 
	join tipo_etapa_produccion tep on tep.tipet_codigo=ep.tipet_codigo 
	join maquinaria m2 on m2.maq_codigo=ep.maq_codigo 
	join usuario u on u.usu_codigo=ep.usu_codigo 
	join sucursal s2 on s2.suc_codigo=ep.suc_codigo 
	and s2.emp_codigo=ep.emp_codigo 
	join empresa e on e.emp_codigo=s2.emp_codigo 
order by ep.prod_codigo;

create or replace view v_orden_produccion_det2 as 
select 
	opd.orpro_codigo,
	opd.compro_codigo,
	i.it_descripcion,
	opd.orprodet2_cantidad,
	um.unime_descripcion 
from orden_produccion_det2 opd 
	join componente_produccion_det cpd on cpd.compro_codigo=opd.compro_codigo 
	and cpd.it_codigo=opd.it_codigo
	and cpd.tipit_codigo=cpd.tipit_codigo 
	join items i on i.it_codigo=cpd.it_codigo
	and i.tipit_codigo=cpd.tipit_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo
order by opd.it_codigo;

select * from v_componente_produccion_det vcpd where vcpd.compro_codigo=1;
create or replace view v_componente_produccion_det as
select 
	cpd.*,
	i.it_descripcion as item2,
	um.unime_codigo,
	um.unime_descripcion 
from componente_produccion_det cpd 
	join items i on i.it_codigo=cpd.it_codigo
	and i.tipit_codigo=cpd.tipit_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo
order by cpd.compro_codigo;

create or replace view v_componente_produccion_cab as
select 
	cpc.compro_codigo,
	cpc.compro_fecha,
	cpc.compro_estado,
	cpc.it_codigo,
	cpc.tipit_codigo,
	cpc.usu_codigo,
	cpc.suc_codigo,
	cpc.emp_codigo,
	i.it_descripcion as item,
	m.mod_codigomodelo,
	cp.col_descripcion,
	t.tall_descripcion,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial 
from componente_produccion_cab cpc 
	join items i on i.it_codigo=cpc.it_codigo
	and i.tipit_codigo=cpc.tipit_codigo 
	join modelo m on m.mod_codigo=i.mod_codigo 
	join color_prenda cp on cp.col_codigo=m.col_codigo 
	join talle t on t.tall_codigo=i.tall_codigo
	join usuario u on u.usu_codigo=cpc.usu_codigo
	join sucursal s on s.suc_codigo=cpc.suc_codigo 
	and s.emp_codigo=cpc.emp_codigo 
	join empresa e on e.emp_codigo=s.emp_codigo 
order by cpc.compro_codigo;

create or replace view v_produccion_terminada_cab as 
select 
	ptc.proter_codigo,
	ptc.proter_fecha,
	ptc.proter_fechaculminacion,
	ptc.proter_estado,
	ptc.prod_codigo,
	ptc.usu_codigo,
	ptc.suc_codigo,
	ptc.emp_codigo,
	s.secc_descripcion,
	p.per_nombre||' '||p.per_apellido as cliente,
	u.usu_login,
	s2.suc_descripcion,
	e.emp_razonsocial 
from produccion_terminada_cab ptc 
	join produccion_cab pc on pc.prod_codigo=ptc.prod_codigo 
	join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
	join seccion s on s.secc_codigo=opc.secc_codigo 
	join orden_presupuesto op on op.orpro_codigo=opc.orpro_codigo 
	join presupuesto_cab pc2 on pc2.pres_codigo=op.pres_codigo 
	join cliente c on c.cli_codigo=pc2.cli_codigo 
	join personas p on p.per_codigo=c.per_codigo 
	join usuario u on u.usu_codigo=ptc.usu_codigo 
	join sucursal s2 on s2.suc_codigo=ptc.suc_codigo 
	and s2.emp_codigo=ptc.emp_codigo 
	join empresa e on e.emp_codigo=s2.emp_codigo 
order by ptc.proter_codigo;

create or replace view v_produccion_terminada_det as 
select 
  	ptd.*,
  	i.it_descripcion||' '||m.mod_codigomodelo as item,
  	i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as item2,
  	t.tall_descripcion,
  	um.unime_codigo,
  	um.unime_descripcion,
  	d.dep_descripcion 
from produccion_terminada_det ptd 
	join stock s on s.it_codigo=ptd.it_codigo 
	and s.tipit_codigo=ptd.tipit_codigo 
	and s.dep_codigo=ptd.dep_codigo
	and s.suc_codigo=ptd.suc_codigo 
	and s.emp_codigo=ptd.emp_codigo 
	join items i on i.it_codigo=s.it_codigo 
	and i.tipit_codigo=s.tipit_codigo 
	join modelo m on m.mod_codigo=i.mod_codigo 
	join talle t on t.tall_codigo=i.tall_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo 
	join deposito d on d.dep_codigo=s.dep_codigo 
	and d.suc_codigo=s.suc_codigo 
	and d.emp_codigo=s.emp_codigo 
order by ptd.it_codigo;

create or replace view v_mermas_cab as
select 
	mc.mer_codigo,
	mc.mer_fecha,
	mc.mer_estado,
	mc.proter_codigo,
	mc.usu_codigo,
	mc.suc_codigo,
	mc.emp_codigo,
	s.secc_descripcion,
	u.usu_login,
	s2.suc_descripcion,
	e.emp_razonsocial 
from mermas_cab mc 
	join produccion_terminada_cab ptc on ptc.proter_codigo=mc.proter_codigo 
		join produccion_cab pc on pc.prod_codigo=ptc.prod_codigo 
			join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
				join seccion s on s.secc_codigo=opc.secc_codigo 
join usuario u on u.usu_codigo=mc.usu_codigo 
join sucursal s2 on s2.suc_codigo=mc.suc_codigo 
	and s2.emp_codigo=mc.emp_codigo 
	join empresa e on e.emp_codigo=s2.emp_codigo 
order by mc.mer_codigo;

create or replace view v_mermas_det as 
select 
	md.*,
	i.it_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	md.merdet_cantidad*md.merdet_precio as subtotal
from mermas_det md 
	join items i on i.it_codigo=md.it_codigo and i.tipit_codigo=md.tipit_codigo 
		join unidad_medida um on um.unime_codigo=i.unime_codigo
order by md.it_codigo;

create or replace view v_control_calidad_cab as
select 
	ccc.conca_codigo,
	ccc.conca_fecha,
	ccc.conca_estado,
	ccc.proter_codigo,
	ccc.usu_codigo,
	ccc.suc_codigo,
	ccc.emp_codigo,
	s.secc_descripcion,
	u.usu_login,
	s2.suc_descripcion,
	e.emp_razonsocial
from control_calidad_cab ccc 
	join produccion_terminada_cab ptc on ptc.proter_codigo=ccc.proter_codigo 
		join produccion_cab pc on pc.prod_codigo=ptc.prod_codigo 
			join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
				join seccion s on s.secc_codigo=opc.secc_codigo 
	join usuario u on u.usu_codigo=ccc.usu_codigo 
	join sucursal s2 on s2.suc_codigo=ccc.suc_codigo and s2.emp_codigo=ccc.emp_codigo 
		join empresa e on e.emp_codigo=s2.emp_codigo 
order by ccc.conca_codigo;

create or replace view v_control_calidad_det as
select 
	ccd.*,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	t.tall_descripcion,
	pcc.pacoca_descripcion,
	um.unime_codigo,
	um.unime_descripcion 
from control_calidad_det ccd 
	join items i on i.it_codigo=ccd.it_codigo and i.tipit_codigo=ccd.tipit_codigo 
		join modelo m on m.mod_codigo=i.mod_codigo 
		join talle t on t.tall_codigo=i.tall_codigo 
		join unidad_medida um on um.unime_codigo=i.unime_codigo 
	join parametro_control_calidad pcc on pcc.pacoca_codigo=ccd.pacoca_codigo 
order by ccd.it_codigo;

create or replace view v_costo_produccion_cab as
select 
	cpc.copro_codigo,
	cpc.copro_fecha,
	cpc.copro_estado,
	cpc.orpro_codigo,
	cpc.usu_codigo,
	cpc.suc_codigo,
	cpc.emp_codigo,
	s.secc_descripcion,
	u.usu_login,
	s2.suc_descripcion,
	e.emp_razonsocial 
from costo_produccion_cab cpc 
	join orden_produccion_cab opc on opc.orpro_codigo=cpc.orpro_codigo 
		join seccion s on s.secc_codigo=opc.secc_codigo 
	join usuario u on u.usu_codigo=cpc.usu_codigo 
	join sucursal s2 on s2.suc_codigo=cpc.suc_codigo 
	and s2.emp_codigo=cpc.emp_codigo 
		join empresa e on e.emp_codigo=s2.emp_codigo 
order by cpc.copro_codigo;

create or replace view v_costo_produccion_det as 
select 
	cpd.*,
	i.it_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	cpd.coprodet_cantidad*cpd.coprodet_costo as subtotal
from costo_produccion_det cpd 
join items i on i.it_codigo=cpd.it_codigo 
and i.tipit_codigo=cpd.tipit_codigo 
join unidad_medida um on um.unime_codigo=i.unime_codigo 
order by cpd.it_codigo;