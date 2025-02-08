<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$tipet_descripcion = pg_escape_string($conexion, $_POST['tipet_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select
         tep.tipet_codigo,
         tep.tipet_descripcion,
         tep.tipet_estado 
      from tipo_etapa_produccion tep 
      where tep.tipet_descripcion ilike '%$tipet_descripcion%'
      and tep.tipet_estado = 'ACTIVO' 
      order by tipet_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['tipet_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>