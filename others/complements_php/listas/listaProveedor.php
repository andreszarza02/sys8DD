<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$pro_razonsocial = pg_escape_string($conexion, $_POST['pro_razonsocial']);

//Establecemos y mostramos la consulta
$sql = "select 
         p.pro_codigo,
         p.tipro_codigo,
         p.pro_razonsocial,
         p.pro_ruc,
         tp.tipro_descripcion 
      from proveedor p 
         join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
         where (p.pro_ruc ilike '%$pro_razonsocial%' or p.pro_razonsocial ilike '%$pro_razonsocial%')
         and p.pro_estado = 'ACTIVO' 
      order by p.pro_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['pro_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>