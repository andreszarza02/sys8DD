<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$perfil = $_POST['perf_codigo'];

//Establecemos y mostramos la consulta
$sql = "select 
            pp.perm_codigo, 
            pp.perfpe_codigo, 
            p.perm_descripcion 
         from perfiles_permisos pp 
            join permisos p on p.perm_codigo=pp.perm_codigo 
         where pp.perf_codigo=$perfil and pp.perfpe_estado = 'ACTIVO';";

$resultado = pg_query($conexion, query: $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['perm_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>