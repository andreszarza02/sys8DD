<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$item = $_POST['it_descripcion'];

//Establecemos y mostramos la consulta
$sql = "select 
            i.it_codigo,
            i.tipit_codigo,
            i.it_descripcion,
  			   i.unime_codigo,
  			   um.unime_descripcion,
            it_costo as pedcodet_precio 
         from items i
         	join unidad_medida um on um.unime_codigo=i.unime_codigo
         where 
            i.it_descripcion ilike '%$item%' 
            and i.tipit_codigo <> 2
            and i.it_estado = 'ACTIVO'
         order by i.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>