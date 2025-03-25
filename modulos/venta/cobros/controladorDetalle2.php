<?php
//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

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

if (isset($_POST['consulta']) == '1') {

   $sql = "select coalesce(max(cobdet_codigo),0)+1 as codigodetalle from cobro_det";

   $result = pg_query($conexion, $sql);

   $dato = pg_fetch_assoc($result);

   echo json_encode($dato);

}



?>