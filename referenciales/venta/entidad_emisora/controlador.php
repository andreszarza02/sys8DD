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

   $telefono = $_POST['ent_telefono'];
   $ent_telefono = str_replace("'", "''", $telefono);

   $razonsocial = $_POST['ent_razonsocial'];
   $ent_razonsocial = str_replace("'", "''", $razonsocial);

   $ruc = $_POST['ent_ruc'];
   $ent_ruc = str_replace("'", "''", $ruc);

   $email = $_POST['ent_email'];
   $ent_email = str_replace("'", "''", $email);

   $estado = $_POST['ent_estado'];
   $ent_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $sql = "select sp_entidad_emisora(
   {$_POST['ent_codigo']}, 
   '$ent_razonsocial', 
   '$ent_ruc', 
   '$ent_telefono', 
   '$ent_email', 
   '$ent_estado', 
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento2'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA EXISTE LA ENTIDAD EMISORA",
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
   $sql = "select coalesce(max(ent_codigo),0)+1 as ent_codigo from entidad_emisora;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
            ee.ent_codigo,
            ee.ent_razonsocial,
            ee.ent_ruc,
            ee.ent_telefono,
            ee.ent_email,
            ee.ent_estado 
         from entidad_emisora ee 
         order by ee.ent_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>