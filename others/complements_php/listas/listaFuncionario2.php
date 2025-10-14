<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$per_numerodocumento = pg_escape_string($conexion, $_POST['per_numerodocumento2']);
;

//Establecemos y mostramos la consulta
$sql = "select 
         f.func_codigo as notven_funcionario,
         p.per_nombre||' '||p.per_apellido as funcionario,
         p.per_numerodocumento as per_numerodocumento2
      from funcionario f
         join personas p on p.per_codigo=f.per_codigo
         where p.per_numerodocumento ilike '%$per_numerodocumento%'
         and f.func_estado = 'ACTIVO';";

$resultado = pg_query($conexion, $sql);

$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['notven_funcionario'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>