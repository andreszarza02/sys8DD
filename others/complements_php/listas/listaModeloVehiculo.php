<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$descripcion = pg_escape_string($conexion, $_POST['descripcion']);

//Establecemos y mostramos la consulta
$sql = "select 
            mv.modve_codigo,
            mv.modve_descripcion,
            mv2.marve_codigo,
            mv2.marve_descripcion,
            mv2.marve_descripcion||', '||'MODELO: '||mv.modve_descripcion as descripcion
         from modelo_vehiculo mv 
         join marca_vehiculo mv2 on mv2.marve_codigo=mv.marve_codigo 
         where (mv.modve_descripcion ilike '%$descripcion%' or mv2.marve_descripcion ilike '%$descripcion%')
         and mv.modve_estado='ACTIVO'
         order by mv.modve_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

if (!isset($datos[0]['modve_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>