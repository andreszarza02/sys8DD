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
$forma_cobro = $_POST['forma'] ?? 0;

//Si la forma es 1 ejecutamos el sp de cobro con tarjeta
if (isset($_POST['forma']) == 1) {

   //Cargamos el procedimiento almacenado
   $sql = "select sp_cobro_tarjeta(
      0, 
      '{$_POST['cobta_numero']}', 
      {$_POST['cobta_monto']}, 
      '{$_POST['cobta_tipotarjeta']}',
      {$_POST['entad_codigo']},
      {$_POST['ent_codigo']},
      {$_POST['marta_codigo']},
      {$_POST['cob_codigo']},
      {$_POST['ven_codigo']},
      {$_POST['cobdet_codigo']},
      {$_POST['operacion_detalle']}
      )";

   //ejecutamos la consulta
   $result = pg_query($conexion, $sql);

   $response = array(
      "mensaje" => pg_last_notice($conexion),
      "tipo" => "success"
   );

   echo json_encode($response);

}

//Si la forma es 2 ejecutamos el sp de cobro con cheque
if (isset($_POST['forma']) == 2) {

   //Cargamos el procedimiento almacenado
   $sql = "select sp_cobro_cheque(
      0, 
      '{$_POST['coche_numero']}', 
      {$_POST['coche_monto']},
      '{$_POST['coche_tipocheque']}',
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
      "mensaje" => pg_last_notice($conexion),
      "tipo" => "success"
   );

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

   // $sql = "select distinct 
   //          fc.forco_descripcion 
   //       from cobro_det cd 
   //       join forma_cobro fc on fc.forco_codigo=cd.forco_codigo 
   //       where cd.cob_codigo={$_POST['cob_codigo']} 
   //       and fc.forco_descripcion='EFECTIVO';";

   // $result = pg_query($conexion, $sql);

   $prueba = ['forco_descripcion' => 'EFECTIVO'];

   // $dato = pg_fetch_assoc($result);
   $dato = $prueba;

   echo json_encode($dato);

}



?>