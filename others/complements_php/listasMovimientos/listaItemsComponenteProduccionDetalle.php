<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$item3 = pg_escape_string($conexion, $_POST['item3']);

//Establecemos y mostramos la consulta
$sql = "select
         i.it_codigo,
         i.tipit_codigo,
         i.it_descripcion as item3,
         um.unime_codigo,
         um.unime_descripcion 
      from items i 
         join unidad_medida um on um.unime_codigo=i.unime_codigo
      where i.it_descripcion ilike '%$item3%'
         and i.it_estado='ACTIVO'
         and i.tipit_codigo=1
      order by i.it_codigo;
";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>