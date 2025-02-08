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

   $cantidad = $_POST['ajuindet_cantidad'];
   $ajuindet_cantidad = str_replace(",", ".", $cantidad);

   $precio = $_POST['ajuindet_precio'];
   $ajuindet_precio = str_replace(",", ".", $precio);

   $sql = "select sp_ajuste_inventario_det(
      {$_POST['ajuin_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      {$_POST['dep_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      $ajuindet_cantidad, 
      '{$_POST['ajuindet_motivo']}', 
      '{$_POST['ajuin_tipoajuste']}',
      $ajuindet_precio,
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
   $sql = "select * from v_ajuste_inventario_det where ajuin_codigo=$ajuste";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>