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
            cv.chave_codigo as notven_chapa,
            cv.chave_chapa,
            mv2.marve_codigo,
            mv2.marve_descripcion,
            mv.modve_codigo,
            mv.modve_descripcion,
            '<b>CHAPA:</b> '||cv.chave_chapa||'  <b>MODELO:</b> '||mv.modve_descripcion||' '||'<b>MARCA:</b> '||mv2.marve_descripcion as vehiculo
         from chapa_vehiculo cv
            join modelo_vehiculo mv on mv.modve_codigo=cv.modve_codigo 
            join marca_vehiculo mv2 on mv2.marve_codigo=mv.marve_codigo 
            where cv.chave_chapa ilike '%$chave_chapa%'
            and cv.chave_estado <> 'ANULADO'
         order by cv.chave_codigo;";

$resultado = pg_query($conexion, $sql);

$datos = pg_fetch_all($resultado);

if (!isset($datos[0]['notven_chapa'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>