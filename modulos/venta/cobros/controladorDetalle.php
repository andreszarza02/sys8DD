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

   //Recibimos y definimos las variables
   $coche_numero = pg_escape_string($conexion, $_POST['coche_numero']);

   $cobta_transaccion = pg_escape_string($conexion, $_POST['cobta_transaccion']);

   $forco_descripcion = pg_escape_string($conexion, $_POST['forco_descripcion']);

   $cobdet_monto = 0;

   //Validamos la forma de cobro, para cargar el monto de detalle
   if ($forco_descripcion == 'EFECTIVO') {
      $cobdet_monto = str_replace(",", ".", $_POST['cobdet_monto']);
   } else if ($forco_descripcion == 'TARJETA') {
      $cobdet_monto = str_replace(",", ".", $_POST['cobta_monto']);
   } else if ($forco_descripcion == 'CHEQUE') {
      $cobdet_monto = str_replace(",", ".", $_POST['coche_monto']);
   }

   //Validamos la operacion detalle, para cargar el monto de detalle
   if ($_POST['operacion_detalle'] == "2") {
      $cobdet_monto = str_replace(",", ".", $_POST['cobdet_monto']);
   }

   //Definimos la sentencia a consultar
   $sql = "select sp_cobro_det(
      {$_POST['cobdet_codigo']}, 
      {$_POST['cob_codigo']}, 
      {$_POST['ven_codigo']}, 
      $cobdet_monto, 
      {$_POST['cobdet_numerocuota']}, 
      {$_POST['forco_codigo']},  
      '$coche_numero',  
      {$_POST['ent_codigo2']},  
      {$_POST['usu_codigo']},  
      '$cobta_transaccion',  
      {$_POST['redpa_codigo']},  
      {$_POST['operacion_detalle']}
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   //Validamos si existe un error al insertar el cobro, se valida por efectivo, tarjeta o cheque
   if (strpos($error, "efectivo") !== false) {

      $response = array(
         "mensaje" => "UNA TRANSACCION EN EFECTIVO YA SE ENCUENTRA REGISTRADA EN ESTE COBRO",
         "tipo" => "error"
      );

   } else if (strpos($error, "tarjeta") !== false) {

      $response = array(
         "mensaje" => "EL NUMERO DE TRANSACCION Y LA RED DE PAGO YA SE ENCUENTRAN REGISTRADOS",
         "tipo" => "error"
      );

   } else if (strpos($error, "cheque") !== false) {

      $response = array(
         "mensaje" => "EL NUMERO DE CHEQUE YA SE ENCUENTRA REGISTRADO",
         "tipo" => "error"
      );

   } else {

      //En caso de que no exsista error, validamos si con la insercion ya se culmino la deuda
      $sql2 = "select    
               coalesce(sum(cd.cobdet_monto), 0) as montoventa 
          from cobro_det cd 
          join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
          where cc.cob_estado='ACTIVO' and
          cd.ven_codigo = {$_POST['ven_codigo']}";

      $result2 = pg_query($conexion, $sql2);

      $dato2 = pg_fetch_assoc($result2);

      if ($dato2['montoventa'] == $_POST['cuenco_monto']) {
         //Si la sumatoria del monto venta es igual al monto de cuenta cobrar, procedemos con la actualizacion de estado
         $sql3 = "update cuenta_cobrar  
           set cuenco_estado = 'CANCELADO', 
           tipco_codigo = 5    
           where ven_codigo = {$_POST['ven_codigo']};
           update venta_cab 
           set ven_estado = 'CANCELADO',
           usu_codigo = {$_POST['usu_codigo']} 
           where ven_codigo = {$_POST['ven_codigo']};";

         $result3 = pg_query($conexion, $sql3);
      }

      //Al terminar enviamos un mensaje de exito
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['cobro'])) {

   //Recibimos y definimos el codigo de cobro
   $cobro = $_POST['cobro'];

   $sql = "select * from v_cobro_det vcd where vcd.cob_codigo=$cobro";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);

}

?>