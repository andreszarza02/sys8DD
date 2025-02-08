<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$sucursal = $_POST['suc_codigo'];
$empresa = $_POST['emp_codigo'];
$dep_descripcion = pg_escape_string($conexion, $_POST['dep_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select 
         d.dep_codigo,
         d.dep_descripcion
      from deposito d
         where d.suc_codigo=$sucursal 
         and d.emp_codigo=$empresa
         and d.dep_descripcion ilike '%$dep_descripcion%'
         and d.dep_estado='ACTIVO';";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['dep_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>