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
         pp.pedco_codigo,
         pp.prepro_codigo,
         'PRESUPUESTO PROVEEDOR N°'||pp.prepro_codigo||' '||to_char(ppc.prepro_fechaactual, 'DD-MM-YYYY') as presupuesto,
         ppc.pro_codigo,
         ppc.tipro_codigo,
         p.pro_razonsocial,
         tp.tipro_descripcion 
      from pedido_presupuesto pp
         join presupuesto_proveedor_cab ppc on ppc.prepro_codigo=pp.prepro_codigo
         join proveedor p on p.pro_codigo=ppc.pro_codigo
         join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
         where (p.pro_razonsocial ilike '%$pro_razonsocial%' or p.pro_ruc ilike '%$pro_razonsocial%') and ppc.prepro_estado='ACTIVO'
      order by pp.prepro_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['prepro_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>