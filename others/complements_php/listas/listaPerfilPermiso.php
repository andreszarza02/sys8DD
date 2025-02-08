<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$perfil = $_POST['perf_descripcion'];

//Establecemos y mostramos la consulta
$sql = "select distinct pp.perf_codigo, p.perf_descripcion 
      from perfiles_permisos pp 
      join perfil p on pp.perf_codigo=p.perf_codigo 
      where p.perf_descripcion ilike '%$perfil%' and pp.perfpe_estado = 'ACTIVO';";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['perf_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>