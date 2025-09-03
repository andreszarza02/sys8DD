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
   $marve_descripcion = pg_escape_string($conexion, $_POST['marve_descripcion']);

   $marve_estado = pg_escape_string($conexion, $_POST['marve_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $sql = "select sp_marca_vehiculo(
   {$_POST['marve_codigo']}, 
   '$marve_descripcion',
   '$marve_estado',
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "descripcion") !== false) {
      $response = array(
         "mensaje" => "YA SE ENCUENTRA REGISTRADA LA MARCA DE VEHICULO",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

   //Consulta,os si existe la variable consulta y si es igual a 1
} else if (isset($_POST['consulta']) == 1) {

   //Consultamos y enviamos el ultimo codigo
   $sql = "select coalesce(max(marve_codigo),0)+1 as marve_codigo from marca_vehiculo";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               mv.marve_codigo,
               mv.marve_descripcion,
               mv.marve_estado 
            from marca_vehiculo mv 
            order by mv.marve_codigo;;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>