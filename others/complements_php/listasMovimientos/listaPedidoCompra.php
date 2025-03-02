<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$pedido = $_POST['pedco_codigo'];

//Establecemos y mostramos la consulta
$sql = "select 
         pcc.pedco_codigo, 
         'Pedido Compra N°'||pcc.pedco_codigo||' '||to_char(pcc.pedco_fecha, 'DD-MM-YYYY') as pedido 
      from pedido_compra_cab pcc 
         where cast(pcc.pedco_codigo as varchar) ilike '%$pedido%' and
      pedco_estado = 'PENDIENTE';";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['pedco_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>