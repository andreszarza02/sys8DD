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
   $vendet_cantidad = str_replace(",", ".", $_POST['vendet_cantidad']);

   $vendet_precio = str_replace(",", ".", $_POST['vendet_precio']);

   $it_descripcion = pg_escape_string($conexion, $_POST['item']);

   $tall_descripcion = pg_escape_string($conexion, $_POST['tall_descripcion']);

   $sql = "select sp_venta_det(
      {$_POST['ven_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      {$_POST['dep_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      $vendet_cantidad, 
      $vendet_precio,  
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

      // Validamos que el item no llego al stock minimo
      $sql2 = "select round(i.it_stock_min) as minimo from items i where i.it_codigo={$_POST['it_codigo']} and i.tipit_codigo=2;";

      $sql3 = "select s.st_cantidad as cantidad_item from stock s where s.it_codigo={$_POST['it_codigo']} and s.tipit_codigo={$_POST['tipit_codigo']} and s.dep_codigo={$_POST['dep_codigo']} and s.suc_codigo={$_POST['suc_codigo']} and s.emp_codigo={$_POST['emp_codigo']};";

      $resultado2 = pg_query($conexion, $sql2);

      $resultado3 = pg_query($conexion, $sql3);

      $minimo = pg_fetch_assoc($resultado2);

      $cantidad_stock = pg_fetch_assoc($resultado3);

      if ((int) $cantidad_stock['cantidad_item'] <= (int) $minimo['minimo']) {
         // Si es asi enviams un mensaje de alerta
         $response = array(
            "mensaje" => pg_last_notice($conexion) . ", EL ITEM: $it_descripcion TALLE $tall_descripcion ALCANZÓ SU STOCK MÍNIMO EN EL DEPOSITO.",
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

   //Consultamos si el numero de venta ya se encuentra asociado a una nota de venta 
   $sql = "select 1 from nota_venta_cab
            where ven_codigo = {$_POST['ven_codigo']}
              and notven_estado <> 'ANULADO'";

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

} else if (isset($_POST['venta'])) {

   $venta = $_POST['venta'];
   $sql = "select * from v_venta_det vvd where vvd.ven_codigo=$venta";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);
}

?>