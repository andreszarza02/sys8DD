<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$ci = $_POST['ci'];

//Establecemos y mostramos la consulta
$sql = "select 
         cc.ven_codigo,
         cc.cuenco_nrocuota as cuota,
         cc.cuenco_montosaldo as saldo,
         cc.cuenco_montototal,
         'N° Venta: '||vc.ven_codigo||' Factura: '||vc.ven_numfactura as venta,
         vc.ven_numfactura as factura,
         p.per_nombre||' '||p.per_apellido as cliente,
         vc.vent_montocuota,
         ven_interfecha
      from cuenta_cobrar cc
         join venta_cab vc on vc.ven_codigo=cc.ven_codigo
         join cliente c on c.cli_codigo=vc.cli_codigo
         join personas p on p.per_codigo=c.per_codigo
      where p.per_numerodocumento ilike '%$ci%' and cc.         cuenco_estado='ACTIVO'
      order by vc.ven_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['ven_codigo'])) {
   $datos = [['venta' => 'No se encuentra']];
}

echo json_encode($datos);
?>