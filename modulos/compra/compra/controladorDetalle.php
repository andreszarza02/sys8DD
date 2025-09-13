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
   $compdet_cantidad = str_replace(",", ".", $_POST['compdet_cantidad']);

   $compdet_precio = str_replace(",", ".", $_POST['compdet_precio']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $it_descripcion = pg_escape_string($conexion, $_POST['it_descripcion']);

   $comp_cuota = str_replace(",", ".", $_POST['comp_cuota']);

   $sql = "select sp_compra_det(
      {$_POST['comp_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      {$_POST['dep_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      $compdet_cantidad, 
      $compdet_precio,  
      {$_POST['usu_codigo']}, 
      '$usu_login',
      $comp_cuota,
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
   } else if (strpos($error, "item_stock") !== false) {
      $response = array(
         "mensaje" => "EL ITEM YA SE ENCUENTRA REGISTRADO EN STOCK",
         "tipo" => "error"
      );
   } else {

      // Validamos que el item no llego al stock maximo
      $sql2 = "select round(i.it_stock_max) as maximo from items i where i.it_codigo={$_POST['it_codigo']};";

      $sql3 = "select s.st_cantidad as cantidad_item from stock s where s.it_codigo={$_POST['it_codigo']} and s.tipit_codigo={$_POST['tipit_codigo']} and s.dep_codigo={$_POST['dep_codigo']} and s.suc_codigo={$_POST['suc_codigo']} and s.emp_codigo={$_POST['emp_codigo']};";

      $resultado2 = pg_query($conexion, $sql2);

      $resultado3 = pg_query($conexion, $sql3);

      $maximo = pg_fetch_assoc($resultado2);

      $cantidad_stock = pg_fetch_assoc($resultado3);

      if ((int) $cantidad_stock['cantidad_item'] >= (int) $maximo['maximo']) {
         // Si es asi enviams un mensaje de alerta
         $response = array(
            "mensaje" => pg_last_notice($conexion) . ", EL ITEM: $it_descripcion ALCANZÓ SU STOCK MÁXIMO EN EL DEPOSITO.",
            "tipo" => "info"
         );

      } else {
         // Sino enviamos un mensaje normal
         $response = array(
            "mensaje" => pg_last_notice($conexion),
            "tipo" => "info"
         );
      }
   }

   echo json_encode($response);

} else if (isset($_POST['consulta1'])) {

   //Consultamos si el numero de compra ya se encuentra asociado a una nota de compra 
   $sql = "select 1 from nota_compra_cab ncc 
		     where ncc.comp_codigo={$_POST['comp_codigo']} 
           and ncc.nocom_estado <> 'ANULADO';";

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

} else if (isset($_POST['compra'])) {

   $compra = $_POST['compra'];

   $sql = "select 
               * 
            from v_compra_det vcd 
            where vcd.comp_codigo=$compra";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);
}

?>