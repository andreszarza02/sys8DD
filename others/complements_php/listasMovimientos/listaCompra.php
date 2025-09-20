<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos la variable
$proveedor = pg_escape_string($conexion, $_POST['pro_razonsocial']);

//Establecemos y mostramos la consulta
$sql = "select 
         cc.comp_codigo,
         'COMPRA N°'||cc.comp_codigo||' '||to_char(cc.comp_fecha, 'DD-MM-YYYY') as compra,
         cc.pro_codigo,
         cc.comp_tipofactura,
         cc.comp_cuota,
         p.pro_razonsocial,
         cc.tipro_codigo,
         tp.tipro_descripcion,
         cc.comp_numfactura
      from compra_cab cc
         join proveedor p on p.pro_codigo=cc.pro_codigo
         and p.tipro_codigo=cc.tipro_codigo
         join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
         where (p.pro_ruc ilike '%$proveedor%' or p.pro_razonsocial ilike '%$proveedor%') 
         and (cc.comp_estado='ACTIVO' or cc.comp_estado='ANULADO')
      order by cc.comp_codigo;";

//Consultamos y guardamos los resultados
$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['comp_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>