<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$pedido = $_POST['pedco_codigo'];
$descripcion = $_POST['it_descripcion'];

//Establecemos y mostramos la consulta
$sql = "select
            i.it_codigo,
            i.tipit_codigo,
            i.it_descripcion,
            um.unime_codigo,
            um.unime_descripcion,
            pcd.pedcodet_cantidad as peprodet_cantidad
         from pedido_compra_det pcd 
            join items i on i.it_codigo=pcd.it_codigo
            and i.tipit_codigo=pcd.tipit_codigo
            join unidad_medida um on um.unime_codigo=i.unime_codigo 
         where pcd.pedco_codigo='$pedido' 
            and i.it_estado = 'ACTIVO' 
            and i.it_descripcion ilike '%$descripcion%' 
            and i.tipit_codigo <> 2
         order by i.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>