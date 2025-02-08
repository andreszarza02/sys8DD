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

   //Definimos las variables a pasar al sp de cabecera
   $pres_estado = pg_escape_string($conexion, $_POST['pres_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $per_numerodocumento = pg_escape_string($conexion, $_POST['per_numerodocumento']);

   $cliente = pg_escape_string($conexion, $_POST['cliente']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);

   $sql = "select sp_presupuesto_cab(
      {$_POST['pres_codigo']}, 
      '{$_POST['pres_fecharegistro']}', 
      '{$_POST['pres_fechavencimiento']}', 
      '$pres_estado', 
      {$_POST['peven_codigo']}, 
      {$_POST['usu_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['cli_codigo']}, 
      {$_POST['operacion_cabecera']},
      '$usu_login',
      '$procedimiento',
      '$per_numerodocumento',
      '$cliente',
      '$emp_razonsocial',
      '$suc_descripcion'
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "fecha_mayor") !== false) {
      $response = array(
         "mensaje" => "LA FECHA DE VENCIMIENTO ES MENOR A LA FECHA DE REGISTRO",
         "tipo" => "error"
      );
   } else if (strpos($error, "pedido") !== false) {
      $response = array(
         "mensaje" => "EL PEDIDO YA SE ENCUENTRA ASOCIADO A UN PRESUPUESTO ACTIVO",
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
   $sql = "select coalesce(max(pres_codigo),0)+1 as pres_codigo from presupuesto_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * from v_presupuesto_cab vpc where vpc.pres_estado <> 'ANULADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>