<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$entidad = $_POST['ent_razonsocial2'];

//Establecemos y mostramos la consulta
$sql = "select ee.ent_codigo as ent_codigo2, ee.ent_razonsocial as ent_razonsocial2 from entidad_emisora ee where ee.ent_razonsocial ilike '%$entidad%' and ee.ent_estado = 'ACTIVO'";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['ent_codigo2'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>