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

   // Definimos y cargamos las variables
   $mod_codigomodelo = pg_escape_string($conexion, $_POST['mod_codigomodelo']);

   $mod_observacion = pg_escape_string($conexion, $_POST['mod_observacion']);

   $mod_estado = pg_escape_string($conexion, $_POST['mod_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $col_descripcion = pg_escape_string($conexion, $_POST['col_descripcion']);

   $sql = "select sp_modelo(
   {$_POST['mod_codigo']},
   '$mod_codigomodelo',
   '{$_POST['mod_sexo']}',
   '$mod_observacion', 
   '$mod_estado',
   {$_POST['col_codigo']}, 
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento',
   '$col_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA EXISTE EL MODELO",
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
   $sql = "select coalesce(max(mod_codigo),0)+1 as mod_codigo from modelo;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               m.mod_codigo,
               m.mod_codigomodelo,
               m.mod_sexo,
               m.mod_observacion,
               m.mod_estado,
               m.col_codigo,
               cp.col_descripcion
         from modelo m
               join color_prenda cp on cp.col_codigo=m.col_codigo
         where mod_codigo <> 0
         order by m.mod_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>