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
   $ajus_estado = pg_escape_string($conexion, $_POST['ajus_estado']);

   $ajus_tipoajuste = pg_escape_string($conexion, $_POST['ajus_tipoajuste']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);

   $sql = "select sp_ajuste_stock_cab(
      {$_POST['ajus_codigo']}, 
      '{$_POST['ajus_fecha']}', 
      '$ajus_tipoajuste', 
      '$ajus_estado', 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['usu_codigo']}, 
      {$_POST['operacion_cabecera']},
      '$usu_login',
      '$procedimiento',
      '$emp_razonsocial',
      '$suc_descripcion'
      )";

   //ejecutamos la consulta
   $result = pg_query($conexion, $sql);

   $response = array(
      "mensaje" => pg_last_notice($conexion),
      "tipo" => "info"
   );

   echo json_encode($response);

} else if (isset($_POST['consulta']) == 1) {

   //Consultamos y enviamos el ultimo codigo
   $sql = "select coalesce(max(ajus_codigo),0)+1 as ajus_codigo from ajuste_stock_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {
   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * from v_ajuste_stock_cab vasc where vasc.ajus_estado <> 'ANULADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>