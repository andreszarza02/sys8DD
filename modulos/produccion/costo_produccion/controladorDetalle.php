<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

// Consultamos datos del detalle
$sql = "SELECT * FROM fn_resumen_costo_produccion({$_POST['copro_codigo']}, {$_POST['orpro_codigo']});";

$resultado = pg_query($conexion, $sql);

$datos = pg_fetch_all($resultado);

echo json_encode($datos);

?>