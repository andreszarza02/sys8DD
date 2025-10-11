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
   $coche_numero = $_POST['coche_numero'];

   $ent_codigo2 = $_POST['ent_codigo2'];

   $cobta_transaccion = $_POST['cobta_transaccion'];

   $redpa_codigo = $_POST['redpa_codigo'];

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
      {$_POST['forco_codigo']},  
      $cobdet_monto, 
      '$coche_numero',  
      $ent_codigo2,  
      {$_POST['usu_codigo']},  
      '$cobta_transaccion',  
      $redpa_codigo,  
      {$_POST['ven_codigo']},  
      {$_POST['ven_montocuota']},  
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
         "mensaje" => "EL NUMERO DE CHEQUE Y LA ENTIDAD YA SE ENCUENTRA REGISTRADOS",
         "tipo" => "error"
      );

   } else if (strpos($error, "monto_superado") !== false) {

      $response = array(
         "mensaje" => "CON EL MONTO QUE INTENTA PERSISTIR, SE EXCEDE EL MONTO TOTAL DE LA CUOTA",
         "tipo" => "error"
      );

   } else {

      //En caso de que no exsista error, validamos si con la insercion ya se culmino la deuda
      $sql2 = "select    
                  coalesce(sum(cd.cobdet_monto), 0) as montoventa 
               from cobro_det cd 
                  join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
                  where cc.cob_estado='ACTIVO' and
               cc.ven_codigo = {$_POST['ven_codigo']}";

      $result2 = pg_query($conexion, $sql2);

      $dato2 = pg_fetch_assoc($result2);

      if ((int) $dato2['montoventa'] == (int) $_POST['cuenco_monto']) {
         //Si la sumatoria del cobro filtrando por venta es igual al monto de cuenta cobrar, procedemos con la actualizacion de estado
         $sql3 = "update cuenta_cobrar  
                     set cuenco_estado = 'CANCELADO', tipco_codigo = 5    
                  where ven_codigo = {$_POST['ven_codigo']};
                  update venta_cab 
                     set ven_estado = 'CANCELADO', usu_codigo = {$_POST['usu_codigo']} 
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

} else if (isset($_POST['consulta1'])) {

   //Consultamos si el numero de venta ya se encuentra asociado a una nota de venta 
   $sql = "select 1 from cobro_cab cc 
            where cc.ven_codigo={$_POST['ven_codigo']} 
            and cc.cob_numerocuota > {$_POST['cob_numerocuota']} 
            and cc.cob_estado='ACTIVO'";

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

} else if (isset($_POST['consulta2'])) {

   //Consultamos la sumatoria de detalle de cobro es igual a monto de venta
   $sql = "select 
            sum(cd.cobdet_monto) as sumatoria 
         from cobro_det cd where cd.cob_codigo={$_POST['cob_codigo']} ;";

   $resultado = pg_query($conexion, $sql);
   $dato = pg_fetch_assoc($resultado);

   if ((int) $dato['sumatoria'] == (int) $_POST['ven_montocuota']) {
      $response = array(
         "validacion" => "recargar",
      );
   } else {
      $response = array(
         "validacion" => "no_recargar",
      );
   }

   echo json_encode($response);

} else if (isset($_POST['cobro'])) {

   //Recibimos y definimos el codigo de cobro
   $cobro = $_POST['cobro'];

   $sql = "select 
               * 
           from v_cobro_det vcd 
           where vcd.cob_codigo=$cobro";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);

}

?>