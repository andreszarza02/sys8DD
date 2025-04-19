<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Consultamos si existe la variable operacion
if (isset($_POST['operacion'])) {

   //Recibimos y definimos las variables
   $config_validacion = pg_escape_string($conexion, $_POST['config_validacion']);

   $config_descripcion = pg_escape_string($conexion, $_POST['config_descripcion']);

   $config_estado = pg_escape_string($conexion, $_POST['config_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   //Establecemos el stored procedure a utilizar con sus respectivos parametros
   $sql = "select sp_configuraciones(
            {$_POST['config_codigo']}, 
            '$config_validacion', 
            '$config_descripcion', 
            '$config_estado', 
            {$_POST['operacion']},
            {$_POST['usu_codigo']},
            '$usu_login',
            '$procedimiento'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         //Como no tenemos excepciones de momento, generamos uno generico
         "mensaje" => "OCURRE UN ERROR!",
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
   $sql = "select coalesce(max(config_codigo),0)+1 as config_codigo from configuraciones; ";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               config_codigo,
               config_validacion,
               config_descripcion,
               config_estado
            from configuraciones 
            order by config_codigo;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);

}

?>