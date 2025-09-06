<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$prepro_codigo = $_POST['prepro_codigo'];
$it_descripcion = pg_escape_string($conexion, $_POST['it_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select 
            i.it_codigo,
            i.tipit_codigo,
            i.it_descripcion,
            um.unime_codigo,
            um.unime_descripcion,
            ppd.peprodet_cantidad as orcomdet_cantidad,
            ppd.peprodet_precio as orcomdet_precio
      from presupuesto_proveedor_det ppd 
            join items i on i.it_codigo=ppd.it_codigo 
            and i.tipit_codigo=ppd.tipit_codigo
            join unidad_medida um on um.unime_codigo=i.unime_codigo 
            where ppd.prepro_codigo=$prepro_codigo 
            and i.it_estado='ACTIVO'
            and i.it_descripcion ilike '%$it_descripcion%'
            and i.tipit_codigo <> 2
      order by ppd.prepro_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>