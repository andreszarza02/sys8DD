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
   $mer_estado = pg_escape_string($conexion, $_POST['mer_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $secc_descripcion = pg_escape_string($conexion, $_POST['secc_descripcion']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);

   $sql = "select sp_mermas_cab(
      {$_POST['mer_codigo']}, 
      '{$_POST['mer_fecha']}', 
      '$mer_estado', 
      {$_POST['proter_codigo']}, 
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

   if (strpos($error, "produccion_terminada") !== false) {
      $response = array(
         "mensaje" => "EL NUMERO DE PRODUCCION TERMINADA YA SE ENCUENTRA REGISTRADO EN CABECERA",
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
   $sql = "select coalesce(max(mer_codigo),0)+1 as mer_codigo from mermas_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * from v_mermas_cab vmc where vmc.mer_estado <> 'ANULADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>