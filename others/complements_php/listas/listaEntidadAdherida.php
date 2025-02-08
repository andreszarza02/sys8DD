<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$entidad = $_POST['ent_razonsocial'];

//Establecemos y mostramos la consulta
$sql = "select 
         ea.entad_codigo,
         ea.ent_codigo,
         ea.marta_codigo,
         ee.ent_razonsocial||' '||mt.marta_descripcion as entidades,
         ee.ent_razonsocial,
         mt.marta_descripcion
      from entidad_adherida ea 
         join entidad_emisora ee on ee.ent_codigo=ea.ent_codigo
         join marca_tarjeta mt on mt.marta_codigo=ea.marta_codigo
      where ee.ent_razonsocial ilike '%$entidad%' and ea.entad_estado = 'ACTIVO'";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['entad_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>