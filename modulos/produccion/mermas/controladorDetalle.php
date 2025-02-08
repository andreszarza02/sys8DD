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

   //Definimos las variables a pasar al sp de detalle
   $cantidad = $_POST['merdet_cantidad'];
   $merdet_cantidad = str_replace(",", ".", $cantidad);

   $precio = $_POST['merdet_precio'];
   $merdet_precio = str_replace(",", ".", $precio);

   $sql = "select sp_mermas_det(
      {$_POST['mer_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      $cantidad, 
      $merdet_precio, 
      {$_POST['operacion_detalle']}
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "item") !== false) {
      $response = array(
         "mensaje" => "EL ITEM YA SE ENCUENTRA REGISTRADO EN EL DETALLE",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['merma'])) {

   $merma = $_POST['merma'];
   $sql = "select * from v_mermas_det vmd where vmd.mer_codigo=$merma;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>