<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$orcom_codigo = $_POST['orcom_codigo'];
$it_descripcion = pg_escape_string($conexion, $_POST['it_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select 
            ocd.it_codigo,
            ocd.it_codigo,
            ocd.tipit_codigo,
            i.tipim_codigo,
            i.it_descripcion,
            ocd.orcomdet_cantidad as compdet_cantidad,
            ocd.orcomdet_precio as compdet_precio,
            um.unime_codigo,
            um.unime_descripcion 
         from orden_compra_det ocd 
            join orden_compra_cab occ on occ.orcom_codigo=ocd.orcom_codigo 
            join items i on i.it_codigo=ocd.it_codigo 
            and i.tipit_codigo=ocd.tipit_codigo 
            join unidad_medida um on um.unime_codigo=i.unime_codigo
         where ocd.orcom_codigo=$orcom_codigo 
            and i.it_estado='ACTIVO'
            and occ.orcom_estado='COMPLETADO'
            and i.it_descripcion ilike '%$it_descripcion%'
            and i.tipit_codigo <> 2
         order by i.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>