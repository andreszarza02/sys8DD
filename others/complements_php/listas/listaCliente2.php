<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Definimos las variables
$cliente = pg_escape_string($conexion, $_POST['per_numerodocumento']);

//Establecemos y mostramos la consulta
$sql = "select
            c.cli_codigo as cli_codigo1,
            p.per_numerodocumento,
            p.per_nombre||' '||p.per_apellido as cliente1
         from cliente c
            join personas p on p.per_codigo=c.per_codigo
            where p.per_numerodocumento ilike '%$cliente%' 
            and c.cli_estado='ACTIVO'
         order by c.cli_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['cli_codigo1'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>