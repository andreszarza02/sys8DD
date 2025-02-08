<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$empresa = $_POST['emp_codigo'];

//Establecemos y mostramos la consulta
$sql = "select 
            s.suc_codigo, 
            s.suc_descripcion 
         from sucursal s 
         where s.emp_codigo = $empresa and s.suc_estado = 'ACTIVO';";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

if (!isset($datos[0]['suc_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'No se encuentra']];
}

echo json_encode($datos);