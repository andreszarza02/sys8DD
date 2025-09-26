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
   $peven_estado = pg_escape_string($conexion, $_POST['peven_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $per_numerodocumento = pg_escape_string($conexion, $_POST['per_numerodocumento']);

   $cliente = pg_escape_string($conexion, $_POST['cliente']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);

   $sql = "select sp_pedido_venta_cab(
      {$_POST['peven_codigo']}, 
      '{$_POST['peven_fecha']}', 
      '$peven_estado', 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['cli_codigo']}, 
      {$_POST['usu_codigo']}, 
      {$_POST['operacion_cabecera']},
      '$usu_login',
      '$procedimiento',
      '$per_numerodocumento',
      '$cliente',
      '$emp_razonsocial',
      '$suc_descripcion'
      )";

   //ejecutamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "asociado") !== false) {
      $response = array(
         "mensaje" => "YA SE ENCUENTRA ASOCIADO EL PEDIDO DE VENTA A UN PRESUPUESTO DE PRODUCCION",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['consulta1'])) {

   //Consultamos y enviamos el ultimo codigo
   $sql = "select coalesce(max(peven_codigo),0)+1 as peven_codigo from pedido_venta_cab;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               * 
           from v_pedido_venta_cab vpvc 
            where vpvc.peven_estado <> 'ANULADO';";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);
}

?>