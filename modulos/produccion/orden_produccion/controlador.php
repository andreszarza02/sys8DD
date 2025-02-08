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
   $orpro_estado = pg_escape_string($conexion, $_POST['orpro_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $secc_descripcion = pg_escape_string($conexion, $_POST['secc_descripcion']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);


   $sql = "select sp_orden_produccion_cab(
      {$_POST['orpro_codigo']}, 
      '{$_POST['orpro_fecha']}', 
      '{$_POST['orpro_fechainicio']}', 
      '{$_POST['orpro_fechaculminacion']}', 
      '$orpro_estado', 
      {$_POST['usu_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['secc_codigo']}, 
      {$_POST['pres_codigo']}, 
      {$_POST['peven_codigo']}, 
      {$_POST['operacion_cabecera']},
      '$usu_login',
      '$procedimiento',
      '$secc_descripcion',
      '$emp_razonsocial',
      '$suc_descripcion'
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "fecha_registro") !== false) {
      $response = array(
         "mensaje" => "LA FECHA DE REGISTO ES MAYOR A LA FECHA DE INICIO",
         "tipo" => "error"
      );
   } else if (strpos($error, "fecha_inicio") !== false) {
      $response = array(
         "mensaje" => "LA FECHA DE INICIO ES MAYOR A LA FECHA DE CULMINACION",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   //Enviamos una respuesta
   echo json_encode($response);

} else if (isset($_POST['consulta']) == 1) {

   //Consultamos y enviamos el ultimo codigo
   $sql = "select coalesce(max(orpro_codigo),0)+1 as orpro_codigo from orden_produccion_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * from v_orden_produccion_cab vopc where vopc.orpro_estado <> 'ANULADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>