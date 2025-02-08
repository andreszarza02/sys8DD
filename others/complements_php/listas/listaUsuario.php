<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$usuario = $_POST['usu_login'];

//Establecemos y mostramos la consulta
$sql = "select 
            u.usu_codigo, 
            u.usu_login, 
            u.perf_codigo, 
            p.perf_descripcion 
         from usuario u 
            join perfil p on p.perf_codigo=u.perf_codigo 
         where usu_login ilike '%$usuario%' 
         and u.usu_estado = 'ACTIVO';";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['usu_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>