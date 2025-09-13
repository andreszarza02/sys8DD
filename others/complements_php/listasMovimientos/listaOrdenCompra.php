<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$pro_razonsocial = pg_escape_string($conexion, $_POST['pro_razonsocial']);

//Establecemos y mostramos la consulta
$sql = "select
         occ.orcom_codigo,
         'ORDEN COMPRA N°'||occ.orcom_codigo||' '||to_char(occ.orcom_fecha, 'DD-MM-YYYY') as orden,
         occ.pro_codigo,
         occ.tipro_codigo,
         tp.tipro_descripcion,
         p.pro_razonsocial,
         occ.orcom_condicionpago as comp_tipofactura,
         occ.orcom_cuota as comp_cuota,
         occ.orcom_montocuota as comp_montocuota,
         occ.orcom_interfecha as comp_interfecha
      from orden_compra_cab occ
         join proveedor p on p.pro_codigo=occ.pro_codigo
         and p.tipro_codigo=occ.tipro_codigo
         join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
         where (p.pro_ruc ilike '%$pro_razonsocial%' or p.pro_razonsocial ilike '%$pro_razonsocial%')
         and occ.orcom_estado='ACTIVO'
      order by occ.orcom_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['orcom_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>