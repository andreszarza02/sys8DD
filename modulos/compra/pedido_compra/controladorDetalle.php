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
   $pedcodet_cantidad = str_replace(",", ".", $_POST['pedcodet_cantidad']);

   $pedcodet_precio = str_replace(",", ".", $_POST['pedcodet_precio']);

   $sql = "select sp_pedido_compra_det(
      {$_POST['pedco_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      $pedcodet_cantidad, 
      $pedcodet_precio, 
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

   // Consultamos si existe la variable consulta y si es igual a 2
} else if (isset($_POST['consulta']) == 2) {

   //Consultamos si el numero de pedido ya se ecnuentra asociado a un prespuesto
   $sql = "select
               1
            from pedido_presupuesto pp 
               join pedido_compra_cab pcc on pcc.pedco_codigo=pp.pedco_codigo 
               join presupuesto_proveedor_cab ppc on ppc.prepro_codigo=pp.prepro_codigo 
            where pp.pedco_codigo={$_POST['pedco_codigo']} and ppc.prepro_estado <> 'ANULADO';";

   $resultado = pg_query($conexion, $sql);

   // Si devuelve alguna fila generamos una respuesta con "asociado"
   if (pg_num_rows($resultado) > 0) {
      // Al menos un registro encontrado
      $response = array(
         "validacion" => "asociado",
      );
   } else {
      // Si no, generamos una respuesta con "no_asociado"
      $response = array(
         "validacion" => "no_asociado",
      );
   }

   echo json_encode($response);

   // Consultamos si existe la variable pedido
} else if (isset($_POST['pedido'])) {

   $pedido = $_POST['pedido'];
   $sql = "select * from v_pedido_compra_det where pedco_codigo=$pedido";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>