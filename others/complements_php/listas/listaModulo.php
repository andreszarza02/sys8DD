<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$modu_descripcion = $_POST['modu_descripcion'];

//Establecemos y mostramos la consulta
$sql = "select 
         * 
      from modulo m 
         where m.modu_descripcion ilike '%$modu_descripcion%' 
         and m.modu_estado = 'ACTIVO';";
$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

if (!isset($datos[0]['modu_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>