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

//Establecemos y mostramos la consulta
$sql = "select 
         cc.ven_codigo,
         cc.cuenco_nrocuota,
         cc.cuenco_saldo,
         cc.cuenco_monto,
         'VENTA N°:'||vc.ven_codigo||', FECHA:'||to_char(vc.ven_fecha , 'DD-MM-YYYY')||', FACTURA:'||vc.ven_numfactura as venta,
         vc.ven_numfactura,
         p.per_nombre||' '||p.per_apellido as cliente,
         p.per_numerodocumento,
         vc.ven_montocuota,
         vc.ven_interfecha
      from cuenta_cobrar cc
         join venta_cab vc on vc.ven_codigo=cc.ven_codigo
         join cliente c on c.cli_codigo=vc.cli_codigo
         join personas p on p.per_codigo=c.per_codigo
      where p.per_numerodocumento ilike '%$per_numerodocumento%' 
       and cc.cuenco_estado='ACTIVO'
      order by vc.ven_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor, sino se envia un mensaje de error
if (!isset($datos[0]['ven_codigo'])) {
   $datos = [['venta' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>