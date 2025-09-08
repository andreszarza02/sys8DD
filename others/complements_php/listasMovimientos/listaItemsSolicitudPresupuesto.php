<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$it_descripcion = pg_escape_string($conexion, $_POST['it_descripcion2']);

//Establecemos y mostramos la consulta
$sql = "select
            i.it_codigo as it_codigo2,
            i.tipit_codigo as tipit_codigo2,
            i.it_descripcion as it_descripcion2,
            um.unime_codigo as unime_codigo2,
            um.unime_descripcion as unime_descripcion2,
            pcd.pedcodet_cantidad as solpredet_cantidad
         from pedido_compra_det pcd 
            join items i on i.it_codigo=pcd.it_codigo
            and i.tipit_codigo=pcd.tipit_codigo
            join unidad_medida um on um.unime_codigo=i.unime_codigo 
         where pcd.pedco_codigo={$_POST['pedco_codigo2']} 
            and i.it_estado = 'ACTIVO' 
            and i.it_descripcion ilike '%$it_descripcion%' 
            and i.tipit_codigo <> 2
         order by i.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo2'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>