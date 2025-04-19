<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion  
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$it_descripcion = pg_escape_string($conexion, $_POST['it_descripcion']);
$tipco_descripcion = pg_escape_string($conexion, $_POST['tipco_descripcion']);
$ven_codigo = $_POST['ven_codigo'] ?? 0;
$dep_codigo = $_POST['dep_codigo'] ?? 0;
$emp_codigo = $_POST['emp_codigo'] ?? 0;
$suc_codigo = $_POST['suc_codigo'] ?? 0;

//Validamos los tipos de comprobantes 
if ($tipco_descripcion == "CREDITO" || $tipco_descripcion == "REMISION") {

   //Establecemos y mostramos la consulta
   $sql = "select 
            vd.dep_codigo,
            vd.it_codigo,
            vd.tipit_codigo,
            ti.tipit_descripcion,
            i.tipim_codigo,
            (case 
                  ti.tipit_descripcion 
               when 'PRODUCTO'
                     then 
                        i.it_descripcion||' '||m.mod_codigomodelo
                     else 
                        i.it_descripcion 
            end) it_descripcion,
            (case 
                  ti.tipit_descripcion 
               when 'PRODUCTO'
                     then 
                        i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion 
                     else 
                        i.it_descripcion 
            end) it_descripcion2,
            t.tall_descripcion,
            vd.vendet_cantidad notvendet_cantidad,
            um.unime_descripcion,
            vd.vendet_precio as notvendet_precio
            from venta_det vd 
               join venta_cab vc on vc.ven_codigo=vd.ven_codigo 
               join stock s on s.it_codigo=vd.it_codigo 
               and s.tipit_codigo=vd.tipit_codigo 
               and s.dep_codigo=vd.dep_codigo
               and s.suc_codigo=vd.suc_codigo 
               and s.emp_codigo=vd.emp_codigo 
               join items i on i.it_codigo=s.it_codigo 
               and i.tipit_codigo=s.tipit_codigo 
                  join tipo_item ti on ti.tipit_codigo=i.tipit_codigo 
                  join talle t on t.tall_codigo=i.tall_codigo 
                  join modelo m on m.mod_codigo=i.mod_codigo 
                  join unidad_medida um on um.unime_codigo=i.unime_codigo 
               join deposito d on d.dep_codigo=s.dep_codigo 
               and d.suc_codigo=s.suc_codigo 
               and d.emp_codigo=s.emp_codigo 
                  join sucursal s2 on s2.suc_codigo=d.suc_codigo 
                  and s2.emp_codigo=d.emp_codigo 
                     join empresa e on e.emp_codigo=s2.emp_codigo 
            where i.it_estado='ACTIVO'
               and ti.tipit_descripcion in('PRODUCTO', 'SERVICIO')
               and (i.it_descripcion ilike '%$it_descripcion%' or m.mod_codigomodelo ilike '%$it_descripcion%')
               and vc.ven_codigo=$ven_codigo
               and vc.ven_estado <> 'ANULADO'
               and vc.suc_codigo=$suc_codigo and vc.emp_codigo=$emp_codigo
            order by vd.ven_codigo, vd.it_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

} else {

   //Si no es ni crédito ni remision es debito

   //Procedemos a establecer y realizar una consulta
   $sql = "select 
               i.it_codigo,
               i.tipit_codigo,
               ti.tipit_descripcion,
               i.tipim_codigo,
               (case 
                     ti.tipit_descripcion 
                  when 'PRODUCTO'
                     then 
                           i.it_descripcion||' '||m.mod_codigomodelo
                        else 
                           i.it_descripcion 
               end) it_descripcion,
               (case 
                     ti.tipit_descripcion 
                  when 'PRODUCTO'
                     then 
                           i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion 
                        else 
                           i.it_descripcion 
               end) it_descripcion2,
               t.tall_descripcion,
               (case 
                  when ti.tipit_descripcion='PRODUCTO' and s.st_cantidad<=0
                     then 
                           'NO HAY STOCK'
                        else 
                           CAST(s.st_cantidad AS VARCHAR)
               end) notvendet_cantidad,
               um.unime_descripcion,
               i.it_precio as notvendet_precio
            from stock s 
            join items i on i.it_codigo=s.it_codigo 
            and i.tipit_codigo=s.tipit_codigo 
               join tipo_item ti on ti.tipit_codigo=i.tipit_codigo 
               join talle t on t.tall_codigo=i.tall_codigo 
               join modelo m on m.mod_codigo=i.mod_codigo 
               join unidad_medida um on um.unime_codigo=i.unime_codigo 
            join deposito d on d.dep_codigo=s.dep_codigo 
            and d.suc_codigo=s.suc_codigo 
            and d.emp_codigo=s.emp_codigo 
               join sucursal s2 on s2.suc_codigo=d.suc_codigo 
               and s2.emp_codigo=d.emp_codigo 
                  join empresa e on e.emp_codigo=s2.emp_codigo 
            where i.it_estado='ACTIVO'
            and ti.tipit_descripcion in('PRODUCTO', 'SERVICIO')
            and (i.it_descripcion ilike '%$it_descripcion%' or m.mod_codigomodelo ilike '%$it_descripcion%')
            and s.dep_codigo=$dep_codigo and s.suc_codigo=$suc_codigo and s.emp_codigo=$emp_codigo
            order by i.it_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

}

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>