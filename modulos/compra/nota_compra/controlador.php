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

   $nocom_concepto = pg_escape_string($conexion, $_POST['nocom_concepto']);

   $nocom_estado = pg_escape_string($conexion, $_POST['nocom_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $tipco_descripcion = pg_escape_string($conexion, $_POST['tipco_descripcion']);

   $pro_razonsocial = pg_escape_string($conexion, $_POST['pro_razonsocial']);

   $tipro_descripcion = pg_escape_string($conexion, $_POST['tipro_descripcion']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);

   $sql = "select sp_nota_compra_cab(
      {$_POST['nocom_codigo']}, 
      '{$_POST['nocom_fecha']}', 
      '{$_POST['nocom_numeronota']}',
      '$nocom_concepto',
      '$nocom_estado',  
      {$_POST['tipco_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['usu_codigo']}, 
      {$_POST['comp_codigo']}, 
      {$_POST['pro_codigo']}, 
      {$_POST['tipro_codigo']}, 
      {$_POST['operacion_cabecera']},
      '$usu_login',
      '$procedimiento',
      '$tipco_descripcion',
      '$pro_razonsocial',
      '$tipro_descripcion',
      '$emp_razonsocial',
      '$suc_descripcion'
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "nota") !== false) {
      $response = array(
         "mensaje" => "EL NUMERO DE NOTA YA ESTA REGISTRADO",
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
   $sql = "select coalesce(max(nocom_codigo),0)+1 as nocom_codigo from nota_compra_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * from v_nota_compra_cab vncc where vncc.nocom_estado <> 'ANULADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>