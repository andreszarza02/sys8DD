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
   $copro_estado = pg_escape_string($conexion, $_POST['copro_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $secc_descripcion = pg_escape_string($conexion, $_POST['secc_descripcion']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);

   $sql = "select sp_costo_produccion_cab(
      {$_POST['copro_codigo']}, 
      '{$_POST['copro_fecha']}', 
      '$copro_estado', 
      {$_POST['orpro_codigo']}, 
      {$_POST['usu_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
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

   if (strpos($error, "orden") !== false) {
      $response = array(
         "mensaje" => "EL NUMERO DE ORDEN PRODUCCION YA SE ENCUENTRA REGISTRADO EN CABECERA",
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
   $sql = "select coalesce(max(copro_codigo),0)+1 as copro_codigo from costo_produccion_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * from v_costo_produccion_cab vcpc where vcpc.copro_estado <> 'ANULADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>