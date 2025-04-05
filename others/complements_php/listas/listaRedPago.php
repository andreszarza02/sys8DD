<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$redpa_descripcion = pg_escape_string($conexion, $_POST['redpa_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select
         rp.redpa_codigo,
         rp.redpa_descripcion 
         from red_pago rp 
      where rp.redpa_descripcion ilike '%$redpa_descripcion%'
      and redpa_estado = 'ACTIVO'
      order by redpa_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['redpa_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>