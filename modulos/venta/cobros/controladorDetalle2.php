<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$consulta = $_POST['consulta'] ?? 0;

//Si la forma de cobroo es tarjeta ejecutamos el sp cobro tarjeta
if (isset($_POST['forma']) == "TARJETA") {

   //Recibimos y definimos las variables
   $cobta_numero = pg_escape_string($conexion, $_POST['cobta_numero']);

   $cobta_monto = str_replace(",", ".", $_POST['cobta_monto']);

   $cobta_tipotarjeta = pg_escape_string($conexion, $_POST['cobta_tipotarjeta']);

   $cobta_transaccion = pg_escape_string($conexion, $_POST['cobta_transaccion']);

   //Definimos la sentencia SQL a ejecuatar
   $sql = "select sp_cobro_tarjeta(
      0, 
      '$cobta_numero', 
      $cobta_monto, 
      '$cobta_tipotarjeta',
      {$_POST['entad_codigo']},
      {$_POST['ent_codigo']},
      {$_POST['marta_codigo']},
      {$_POST['cob_codigo']},
      {$_POST['ven_codigo']},
      {$_POST['cobdet_codigo']},
      '$cobta_transaccion',
      {$_POST['redpa_codigo']},
      {$_POST['operacion_detalle']}
      )";

   //ejecutamos la consulta
   $result = pg_query($conexion, $sql);

   $response = array(
      "mensaje" => "INSERCION EXITOSA",
      "tipo" => "success"
   );

   //Devolvemos un mensaje de exito
   echo json_encode($response);

}

//Si la forma de cobro es cheque ejecutamos el sp cobro cheque
if (isset($_POST['forma']) == "CHEQUE") {

   //Recibimos y definimos las variables
   $coche_numero = pg_escape_string($conexion, $_POST['coche_numero']);

   $coche_monto = str_replace(",", ".", $_POST['coche_monto']);

   $coche_tipocheque = pg_escape_string($conexion, $_POST['coche_tipocheque']);

   //Cargamos el procedimiento almacenado
   $sql = "select sp_cobro_cheque(
      0, 
      '$coche_numero', 
      $coche_monto,
      '$coche_tipocheque',
      '{$_POST['coche_fechavencimiento']}',
      {$_POST['ent_codigo2']},
      {$_POST['cob_codigo']},
      {$_POST['ven_codigo']},
      {$_POST['cobdet_codigo']},
      {$_POST['operacion_detalle']}
      )";

   //ejecutamos la consulta
   $result = pg_query($conexion, $sql);

   $response = array(
      "mensaje" => "INSERCION EXITOSA",
      "tipo" => "success"
   );

   //Devolvemos un mensaje de exito
   echo json_encode($response);


}

//Si la consulta es 1, consultamos el codigo de detalle
if ($consulta == '1') {

   $sql = "select coalesce(max(cobdet_codigo),0)+1 as codigodetalle from cobro_det";

   $result = pg_query($conexion, $sql);

   $dato = pg_fetch_assoc($result);

   echo json_encode($dato);

}

//Si la consulta es 2, consultamos si se repite la forma de pago efectivo en el detalle
if ($consulta == '2') {

   $sql = "select distinct 
            fc.forco_descripcion 
         from cobro_det cd 
         join forma_cobro fc on fc.forco_codigo=cd.forco_codigo 
         where cd.cob_codigo={$_POST['cob_codigo']} 
         and fc.forco_descripcion='EFECTIVO';";

   $result = pg_query($conexion, $sql);

   $dato = pg_fetch_assoc($result);

   echo json_encode($dato);

}



?>