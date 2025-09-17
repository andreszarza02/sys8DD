<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$chave_chapa = pg_escape_string($conexion, $_POST['chave_chapa']);

//Establecemos y mostramos la consulta
$sql = "select 
         cv.chave_codigo,
         cv.chave_chapa,
         mv.modve_codigo,
         mv.modve_descripcion,
         mv2.marve_codigo,
         mv2.marve_descripcion,
         'CHAPA:'||cv.chave_chapa||', MODELO:'||mv.modve_descripcion||', MARCA:'||mv2.marve_descripcion as chapa_modelo_marca
      from chapa_vehiculo cv 
         join modelo_vehiculo mv on mv.modve_codigo=cv.modve_codigo 
         join marca_vehiculo mv2 on mv2.marve_codigo=mv.marve_codigo 
         where cv.chave_chapa ilike '%$chave_chapa%'
         and cv.chave_estado = 'ACTIVO'
      order by cv.chave_codigo, cv.chave_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

if (!isset($datos[0]['chave_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>