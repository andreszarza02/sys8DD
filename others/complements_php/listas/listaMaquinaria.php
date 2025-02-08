<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$maq_descripcion = pg_escape_string($conexion, $_POST['maq_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select 
         m.maq_codigo,
         m.maq_descripcion,
         m.maq_estado 
      from maquinaria m 
      where m.maq_descripcion ilike '%$maq_descripcion%'
      and m.maq_estado='ACTIVO'
      order by m.maq_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['maq_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>