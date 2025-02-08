<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$empresa = $_POST['ent_razonsocial'];

//Establecemos y mostramos la consulta
$sql = "select * from entidad_emisora where ent_razonsocial ilike '%$empresa%' and ent_estado = 'ACTIVO'";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

if (!isset($datos[0]['ent_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>