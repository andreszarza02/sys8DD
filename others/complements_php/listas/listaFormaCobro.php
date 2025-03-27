<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Consultamos todas las formas de cobro
$sql = "select 
         fc.forco_codigo,
         fc.forco_descripcion 
      from forma_cobro fc 
      where forco_estado = 'ACTIVO'
      order by forco_codigo;";

$resultado = pg_query($conexion, $sql);

//Guardamos las formas de cobro en un array
$datos = pg_fetch_all($resultado);

//Devolvemos el array en formato JSON
echo json_encode($datos);

?>