<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$ven_codigo = $_POST['ven_codigo'];
$cob_codigo = $_POST['cob_codigo'];
$condicion = false;

//Consultamos todas las formas de cobro
$sql = "select 
         fc.forco_codigo,
         fc.forco_descripcion 
      from forma_cobro fc 
      where forco_estado = 'ACTIVO'
      order by forco_codigo;";

$resultado = pg_query($conexion, $sql);

$datos = pg_fetch_all($resultado);

//Consultamos las formas de cobro asociadas a un cobro
$sql2 = "select 
            fc.forco_descripcion 
         from cobro_det cd 
         join forma_cobro fc on fc.forco_codigo=cd.forco_codigo 
         where cd.ven_codigo=$ven_codigo 
         and cd.cob_codigo=$cob_codigo;";

$resultado2 = pg_query($conexion, $sql2);

$datos2 = pg_fetch_all($resultado2);

//Recorremos el array de formas de cobro asociadas a un cobro
foreach ($datos2 as $dato) {
   //En caso de ya encontrarse efectivo, cambimos el valor de la variable condicion
   if (in_array('EFECTIVO', $dato)) {
      $condicion = true;
   }
}

//Si condicion es true, eliminamos la forma de cobro efectivo
if ($condicion) {
   unset($datos[0]);
}

//Si no se encuentra ninguna forma de cobro, se envia un mensaje de error
if (!isset($datos[0]['forco_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>