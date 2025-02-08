<?php
//Retorno JSON
header("Content-type: application/json; charset=utf-8");
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Consultamos si existe la variable operacion detalle
if (isset($_POST['operacion_detalle'])) {

   $cantidad = $_POST['peprodet_cantidad'];
   $peprodet_cantidad = str_replace(",", ".", $cantidad);

   $precio = $_POST['peprodet_precio'];
   $peprodet_precio = str_replace(",", ".", $precio);

   $sql = "select sp_presupuesto_proveedor_det(
      {$_POST['prepro_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      $peprodet_cantidad, 
      $peprodet_precio, 
      {$_POST['operacion_detalle']})";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "item") !== false) {
      $response = array(
         "mensaje" => "YA SE REGISTRO EL ITEM",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['presupuesto'])) {

   $presupuesto = $_POST['presupuesto'];
   $sql = "select * from v_presupuesto_proveedor_det vppd where vppd.prepro_codigo=$presupuesto;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>