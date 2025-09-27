<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos la variable
$tipoComprobante = pg_escape_string($conexion, $_POST['tipco_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select 
         tc.tipco_codigo,
         (case
	         when tc.tipco_codigo in(1,2) then
	         'NOTA '||tc.tipco_descripcion
	         else
	         tc.tipco_descripcion 
	      end) as tipco_descripcion,
         tc.tipco_estado 
         from tipo_comprobante tc
            where tc.tipco_descripcion ilike '%$tipoComprobante%'
            and tc.tipco_codigo in(1, 2, 4)
            and tc.tipco_estado = 'ACTIVO'
         order by tc.tipco_codigo;";

//Consultamos y guardamos los resultados
$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['tipco_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>