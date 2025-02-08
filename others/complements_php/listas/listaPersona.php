<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$persona = $_POST['per_numerodocumento'];

//Establecemos y mostramos la consulta
$sql = "select
            p.per_codigo,
            p.per_nombre||' '||p.per_apellido as persona,
            p.per_numerodocumento 
      from personas p
            where p.per_numerodocumento like '%$persona%' and p.per_estado = 'ACTIVO';";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['per_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>