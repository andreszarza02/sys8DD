<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$per_numerodocumento = pg_escape_string($conexion, $_POST['per_numerodocumento']);
$suc_codigo = $_POST['suc_codigo'];
$emp_codigo = $_POST['emp_codigo'];

//Establecemos y mostramos la consulta
$sql = "select 
         pvc.peven_codigo,
         'PEDIDO VENTA N°'||pvc.peven_codigo||' '||to_char(pvc.peven_fecha , 'DD-MM-YYYY') as pedido,
         pvc.cli_codigo,
         p.per_nombre||' '||p.per_apellido as cliente,
         p.per_numerodocumento 
      from pedido_venta_cab pvc
         join cliente c on c.cli_codigo=pvc.cli_codigo
        	join personas p on p.per_codigo=c.per_codigo
      where p.per_numerodocumento ilike '%$per_numerodocumento%' 
         and pvc.peven_estado='TERMINADA'
         and pvc.suc_codigo=$suc_codigo
         and pvc.emp_codigo=$emp_codigo
      order by pvc.peven_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['peven_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>