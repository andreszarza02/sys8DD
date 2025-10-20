<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$pacoca_descripcion = pg_escape_string($conexion, $_POST['pacoca_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select 
         pcc.pacoca_codigo,
         pcc.pacoca_descripcion,
         pcc.pacoca_estado 
      from parametro_control_calidad pcc 
      where pcc.pacoca_estado='ACTIVO'
      and pacoca_descripcion ilike '%$pacoca_descripcion%';";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['pacoca_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>