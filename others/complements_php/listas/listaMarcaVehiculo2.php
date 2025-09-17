<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$marve_descripcion = pg_escape_string($conexion, $_POST['marve_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select 
            mv.marve_codigo,
            mv.marve_descripcion,
            mv.marve_estado 
         from marca_vehiculo mv 
         where mv.marve_descripcion ilike '%$marve_descripcion%'
            and mv.marve_estado = 'ACTIVO'
         order by mv.marve_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

if (!isset($datos[0]['marve_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>