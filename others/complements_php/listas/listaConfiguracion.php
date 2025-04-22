<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$config_descripcion = pg_escape_string($conexion, $_POST['config_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select
            c.config_codigo,
            c.config_validacion,
            c.config_descripcion 
         from configuraciones c 
         where c.config_descripcion ilike '%$config_descripcion%'
            and c.config_estado='ACTIVO'
         order by c.config_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['config_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);