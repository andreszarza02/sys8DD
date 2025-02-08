<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion  
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$item = $_POST['descripcion'];
$tipoComprobante = $_POST['tipco_codigo'];
$venta = $_POST['ven_codigo'];

if ($tipoComprobante == "1" || $tipoComprobante == "3") {

   //Establecemos y mostramos la consulta
   $sql = "select 
            i.it_codigo,
            i.tipit_codigo,
            i.tipim_codigo,
            i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as descripcion,
            vd.vendet_cantidad as notvendet_cantidad,
            i.it_precio as notvendet_precio,
            i.it_descripcion,
            t.tall_descripcion,
            um.unime_descripcion
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
            join modelo m on m.mod_codigo=i.mod_codigo 
            join talle t on t.tall_codigo=i.tall_codigo
            join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
            join unidad_medida um on um.unime_codigo=s.unime_codigo
         where (i.it_descripcion ilike '%$item%' or m.mod_codigomodelo ilike '%$item%') 
         and vc.ven_estado <> 'ANULADO' and i.tipit_codigo=2 and vc.ven_codigo=$venta
         order by i.it_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

} else {

   //Establecemos y mostramos la consulta
   $sql = "select 
            i.it_codigo,
            i.tipit_codigo,
            i.tipim_codigo,
            i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as descripcion,
            i.it_precio as notvendet_precio,
            i.it_descripcion,
            t.tall_descripcion,
            um.unime_descripcion
         from items i
            join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
            join talle t on t.tall_codigo=i.tall_codigo
            join modelo m on m.mod_codigo=i.mod_codigo
            join stock s on s.it_codigo=i.it_codigo
            and s.tipit_codigo=i.tipit_codigo
            join unidad_medida um on um.unime_codigo=s.unime_codigo
         where i.it_descripcion ilike '%$item%' and i.it_estado = 'ACTIVO'
         and (i.tipit_codigo = 2 or i.tipit_codigo = 3)
         order by i.it_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

}

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['descripcion' => 'No se encuentra']];
}

echo json_encode($datos);

?>