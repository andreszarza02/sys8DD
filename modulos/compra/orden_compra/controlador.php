<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Consultamos si existe la variable operacion cabecera
if (isset($_POST['operacion_cabecera'])) {

   // Definimos y cargamos las variables
   $orcom_estado = pg_escape_string($conexion, $_POST['orcom_estado']);

   $orcom_interfecha = pg_escape_string($conexion, $_POST['orcom_interfecha']);

   $orcom_montocuota = str_replace(",", ".", $_POST['orcom_montocuota']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $pro_razonsocial = pg_escape_string($conexion, $_POST['pro_razonsocial']);

   $tipro_descripcion = pg_escape_string($conexion, $_POST['tipro_descripcion']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);

   $sql = "select sp_orden_compra_cab(
      {$_POST['orcom_codigo']}, 
      '{$_POST['orcom_fecha']}', 
      '{$_POST['orcom_condicionpago']}', 
       {$_POST['orcom_cuota']},
      '{$_POST['orcom_interfecha']}',  
      $orcom_montocuota,
      '$orcom_estado', 
      {$_POST['usu_codigo']}, 
      {$_POST['pro_codigo']}, 
      {$_POST['tipro_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['prepro_codigo']}, 
      {$_POST['pedco_codigo']}, 
      {$_POST['operacion_cabecera']},
      '$usu_login',
      '$procedimiento',
      '$pro_razonsocial',
      '$tipro_descripcion',
      '$emp_razonsocial',
      '$suc_descripcion'
      )";

   //Ejecutamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "asociado") !== false) {
      $response = array(
         "mensaje" => "YA SE ENCUENTRA ASOCIADA LA ORDEN DE COMPRA A UNA COMPRA",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['consulta']) == 1) {

   //Consultamos y enviamos el ultimo codigo
   $sql = "select coalesce(max(orcom_codigo),0)+1 as orcom_codigo from orden_compra_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {
   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * 
           from v_orden_compra_cab vocc 
           where vocc.orcom_estado <> 'ANULADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>