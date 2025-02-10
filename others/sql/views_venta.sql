create or replace view v_pedido_venta_det as
select 
	pvd.*,
	(case 
			pvd.tipit_codigo
	     when 2
	        then 
	         	i.it_descripcion||' '||m.mod_codigomodelo
	        else 
	         	i.it_descripcion 
     end) as item,
	t.tall_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	ti.tipit_descripcion,
	(case i.tipim_codigo when 1 then pvd.pevendet_cantidad * pvd.pevendet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then pvd.pevendet_cantidad * pvd.pevendet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then pvd.pevendet_cantidad * pvd.pevendet_precio else 0 end) as exenta
from pedido_venta_det pvd
	join items i on i.it_codigo=pvd.it_codigo
	and i.tipit_codigo=pvd.tipit_codigo
		join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
		join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
		join modelo m on m.mod_codigo=i.mod_codigo
		join talle t on t.tall_codigo=i.tall_codigo
		join unidad_medida um on um.unime_codigo=i.unime_codigo
order by pvd.peven_codigo;

create or replace view v_pedido_venta_cab as
select 
	pvc.peven_codigo,
	pvc.peven_fecha,
	pvc.peven_estado,
	pvc.suc_codigo,
	pvc.emp_codigo,
	pvc.cli_codigo,
	pvc.usu_codigo,
	p.per_nombre||' '||p.per_apellido as cliente,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	p.per_numerodocumento
from pedido_venta_cab pvc
	join usuario u on u.usu_codigo=pvc.usu_codigo 
	join cliente c on c.cli_codigo=pvc.cli_codigo
	join personas p on p.per_codigo=c.per_codigo
	join sucursal s on s.suc_codigo=pvc.suc_codigo
	and s.emp_codigo=pvc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
order by pvc.peven_codigo;

create or replace view v_venta_cab as
select 
	vc.*,
	p.per_numerodocumento,
	p.per_nombre||' '||p.per_apellido as cliente,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	pv.peven_codigo
from venta_cab vc
	join pedido_venta pv on pv.ven_codigo=vc.ven_codigo
	join usuario u on u.usu_codigo=vc.usu_codigo
	join cliente c on c.cli_codigo=vc.cli_codigo
		join personas p on p.per_codigo=c.per_codigo
	join sucursal s on s.suc_codigo=vc.suc_codigo 
	and s.emp_codigo=vc.emp_codigo
		join empresa e on e.emp_codigo=s.emp_codigo 
order by vc.ven_codigo; 

create or replace view v_venta_det as
select 
	vd.*,
	(case 
		vd.tipit_codigo 
     when 2
        then 
         	i.it_descripcion||' '||m.mod_codigomodelo
         else 
         	i.it_descripcion 
     end) as item,
	t.tall_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	d.dep_descripcion,
	i.tipim_codigo,
	(case i.tipim_codigo when 1 then vd.vendet_cantidad * vd.vendet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then vd.vendet_cantidad * vd.vendet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then vd.vendet_cantidad * vd.vendet_precio else 0 end) as exenta
from venta_det vd
	join stock s on s.it_codigo=vd.it_codigo
	and s.tipit_codigo=vd.tipit_codigo
	and s.dep_codigo=vd.dep_codigo 
	and s.suc_codigo=vd.suc_codigo
	and s.emp_codigo=vd.emp_codigo
		join items i on i.it_codigo=s.it_codigo
		and i.tipit_codigo=s.tipit_codigo
			join modelo m on m.mod_codigo=i.mod_codigo
			join talle t on t.tall_codigo=i.tall_codigo
			join unidad_medida um on um.unime_codigo=i.unime_codigo
		join deposito d on d.dep_codigo=s.dep_codigo 
		and d.suc_codigo=s.suc_codigo
		and d.emp_codigo=s.emp_codigo
			join sucursal su on su.suc_codigo=d.suc_codigo
			and su.emp_codigo=d.emp_codigo
				join empresa e on e.emp_codigo=su.emp_codigo 
order by vd.ven_codigo, i.it_codigo;

create or replace view v_cobro_cab as
select 
	cc.cob_codigo,
	cc.cob_fecha,
	c.caj_descripcion,
	u.usu_login,
	e.emp_razonsocial,
	s.suc_descripcion,
	cc.cob_estado
from cobro_cab cc
	join apertura_cierre ac on ac.apercie_codigo=cc.apercie_codigo
	join caja c on c.caj_codigo=ac.caj_codigo
	join sucursal s on s.suc_codigo=ac.suc_codigo
	and s.emp_codigo=ac.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
	join usuario u on u.usu_codigo=ac.usu_codigo
order by cc.cob_codigo;

create or replace view v_cobro_det as
select
	cd.cob_codigo, 
	vc.ven_numfactura as factura,
	p.per_nombre||' '||p.per_apellido as cliente,
	fc.forco_descripcion,
	cd.cobdet_numerocuota,
	cd.cobdet_monto,
	vc.ven_cuota as cuota,
	cc.cuenco_montosaldo as saldo,
	cd.cobdet_codigo,
	cc.ven_codigo,
	vc.vent_montocuota,
	vc.ven_interfecha,
	cd.forco_codigo,
	ct.cobta_numero,
	ct.cobta_monto,
	ct.cobta_tipotarjeta,
	ct.entad_codigo,
	ct.ent_codigo,
	ct.marta_codigo,
	cc2.coche_numero,
	cc2.coche_monto,
	cc2.coche_tipocheque,
	cc2.coche_fechavencimiento,
	cc2.ent_codigo as ent_codigo2,
	ee.ent_razonsocial,
	mt.marta_descripcion,
	ee2.ent_razonsocial as ent_razonsocial2
from cobro_det cd
	join cobro_cab cc3 on cc3.cob_codigo=cd.cob_codigo
	join cuenta_cobrar cc on cc.ven_codigo=cd.ven_codigo
	join venta_cab vc on vc.ven_codigo=cc.ven_codigo
	join cliente c on c.cli_codigo=vc.cli_codigo
	join personas p on p.per_codigo=c.per_codigo
	join forma_cobro fc on fc.forco_codigo=cd.forco_codigo
		left join cobro_tarjeta ct on ct.cob_codigo=cd.cob_codigo 
		and ct.ven_codigo=cd.ven_codigo
		and ct.cobdet_codigo=cd.cobdet_codigo
		left join entidad_adherida ea on ea.entad_codigo=ct.entad_codigo
		and ea.ent_codigo=ct.ent_codigo
		and ea.marta_codigo=ct.marta_codigo
		left join entidad_emisora ee on ee.ent_codigo=ea.ent_codigo
		left join marca_tarjeta mt on mt.marta_codigo=ea.marta_codigo
		left join cobro_cheque cc2 on cc2.cob_codigo=cd.cob_codigo
		and cc2.ven_codigo=cd.ven_codigo
		and cc2.cobdet_codigo=cd.cobdet_codigo
		left join entidad_emisora ee2 on ee2.ent_codigo=cc2.ent_codigo
order by cd.cobdet_codigo;

create or replace view v_nota_venta_cab as
select 
	nvc.*,
	vc.ven_numfactura as factura,
	vc.ven_tipofactura,
	vc.vent_montocuota,
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
	i.tipim_codigo,
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