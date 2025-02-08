<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$item = $_POST['it_descripcion'];

//Establecemos y mostramos la consulta
$sql = "select *, it_costo as pedprodet_precio from items where it_descripcion ilike '%$item%' and tipit_codigo = 1 and it_estado = 'ACTIVO'";
$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['it_descripcion' => 'No se encuentra']];
}

echo json_encode($datos);
?>