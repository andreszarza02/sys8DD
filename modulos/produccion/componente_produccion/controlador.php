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

   //Recibimos y definimos las variables
   $compro_estado = pg_escape_string($conexion, $_POST['compro_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $it_descripcion = pg_escape_string($conexion, $_POST['item']);

   $mod_codigomodelo = pg_escape_string($conexion, $_POST['mod_codigomodelo']);

   $col_descripcion = pg_escape_string($conexion, $_POST['col_descripcion']);

   $tall_descripcion = pg_escape_string($conexion, $_POST['tall_descripcion']);

   $tipit_descripcion = pg_escape_string($conexion, $_POST['tipit_descripcion']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);

   $sql = "select sp_componente_produccion_cab(
      {$_POST['compro_codigo']}, 
      '{$_POST['compro_fecha']}', 
      '$compro_estado', 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      {$_POST['usu_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['operacion_cabecera']},
      '$usu_login',
      '$procedimiento',
      '$it_descripcion',
      '$mod_codigomodelo',
      '$col_descripcion',
      '$tall_descripcion',
      '$tipit_descripcion',
      '$emp_razonsocial',
      '$suc_descripcion'
      )";

   //ejecutamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "item_repetido") !== false) {
      $response = array(
         "mensaje" => "EL PRODUCTO YA SE ENCUENTRA REGISTRADO EN CABECERA",
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
   $sql = "select coalesce(max(compro_codigo),0)+1 as compro_codigo from componente_produccion_cab;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               * 
            from v_componente_produccion_cab vcpc 
            where vcpc.compro_estado <> 'ANULADO';";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);

}

?>