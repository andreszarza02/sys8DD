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

   // Definimos y cargamos las variables
   $ajusdet_cantidad = str_replace(",", ".", $_POST['ajusdet_cantidad']);

   $ajusdet_precio = str_replace(",", ".", $_POST['ajusdet_precio']);

   $ajusdet_motivo = pg_escape_string($conexion, $_POST['ajusdet_motivo']);

   $ajus_tipoajuste = pg_escape_string($conexion, $_POST['ajus_tipoajuste']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $sql = "select sp_ajuste_stock_det(
      {$_POST['ajus_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      {$_POST['dep_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      $ajusdet_cantidad, 
      $ajusdet_precio, 
      '$ajusdet_motivo', 
      '$ajus_tipoajuste',
      {$_POST['usu_codigo']},
      '$usu_login',
      {$_POST['operacion_detalle']}
      )";

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

} else if (isset($_POST['ajuste'])) {

   $ajuste = $_POST['ajuste'];
   $sql = "select * from v_ajuste_stock_det where ajus_codigo=$ajuste";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>