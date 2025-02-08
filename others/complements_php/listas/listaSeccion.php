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

//Establecemos y mostramos la consulta
$sql = "select 
         s.secc_codigo,
         s.secc_descripcion
      from seccion s 
         where (s.suc_codigo=$sucursal and s.emp_codigo=$empresa) 
         and s.secc_estado = 'ACTIVO'";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['secc_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>