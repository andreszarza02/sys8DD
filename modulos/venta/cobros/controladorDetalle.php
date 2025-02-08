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

   if ($_POST['forco_codigo'] == 1) {
      $sql = "select sp_cobro_det(
      {$_POST['cobdet_codigo']}, 
      {$_POST['cob_codigo']}, 
      {$_POST['ven_codigo']}, 
      {$_POST['cobdet_monto']}, 
      {$_POST['cobdet_numerocuota']}, 
      {$_POST['forco_codigo']},  
      '{$_POST['cobta_numero']}',  
      {$_POST['entad_codigo']},  
      '{$_POST['coche_numero']}',  
      {$_POST['ent_codigo2']},  
      {$_POST['operacion_detalle']}
      )";
   }

   if ($_POST['forco_codigo'] == 2) {
      $sql = "select sp_cobro_det(
      {$_POST['cobdet_codigo']}, 
      {$_POST['cob_codigo']}, 
      {$_POST['ven_codigo']}, 
      {$_POST['cobta_monto']}, 
      {$_POST['cobdet_numerocuota']}, 
      {$_POST['forco_codigo']},  
      '{$_POST['cobta_numero']}',  
      {$_POST['entad_codigo']},  
      '{$_POST['cobta_numero']}',  
      {$_POST['entad_codigo']}, 
      {$_POST['operacion_detalle']}
      )";
   }

   if ($_POST['forco_codigo'] == 3) {
      $sql = "select sp_cobro_det(
      {$_POST['cobdet_codigo']}, 
      {$_POST['cob_codigo']}, 
      {$_POST['ven_codigo']}, 
      {$_POST['coche_monto']}, 
      {$_POST['cobdet_numerocuota']}, 
      {$_POST['forco_codigo']},
      '{$_POST['coche_numero']}',  
      {$_POST['ent_codigo2']},  
      '{$_POST['coche_numero']}',  
      {$_POST['ent_codigo2']},   
      {$_POST['operacion_detalle']}
      )";
   }

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "tarjeta") !== false) {
      $response = array(
         "mensaje" => "YA SE REGISTRO LA TARJETA",
         "tipo" => "error"
      );

   } else if (strpos($error, "cheque") !== false) {
      $response = array(
         "mensaje" => "YA SE REGISTRO EL NUMERO DE CHEQUE",
         "tipo" => "error"
      );

   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['codigo'])) {
   $cobro = $_POST['codigo'];
   $sql = "select * from v_cobro_det where cob_codigo=$cobro";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>