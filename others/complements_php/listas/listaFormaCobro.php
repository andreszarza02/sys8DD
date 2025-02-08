<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$ven_codigo = $_POST['ven_codigo'];
$cob_codigo = $_POST['cob_codigo'];
$condicion = false;

//Establecemos las consultas
$sql = "select * from forma_cobro where forco_estado = 'ACTIVO' order by forco_codigo";
$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

$sql2 = "select fc.forco_descripcion from cobro_det cd join forma_cobro fc on fc.forco_codigo=cd.forco_codigo 
where cd.ven_codigo=$ven_codigo and cd.cob_codigo=$cob_codigo";
$resultado2 = pg_query($conexion, $sql2);
$datos2 = pg_fetch_all($resultado2);

foreach ($datos2 as $dato) {
   if (in_array('EFECTIVO', $dato)) {
      $condicion = true;
   }
}

if ($condicion) {
   unset($datos[0]);
}

echo json_encode($datos);
?>