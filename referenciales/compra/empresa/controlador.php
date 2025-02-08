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

   $telefono = $_POST['emp_telefono'];
   $emp_telefono = str_replace("'", "''", $telefono);

   $razonsocial = $_POST['emp_razonsocial'];
   $emp_razonsocial = str_replace("'", "''", $razonsocial);

   $ruc = $_POST['emp_ruc'];
   $emp_ruc = str_replace("'", "''", $ruc);

   $timbrado = $_POST['emp_timbrado'];
   $emp_timbrado = str_replace("'", "''", $timbrado);

   $email = $_POST['emp_email'];
   $emp_email = str_replace("'", "''", $email);

   $actividad = $_POST['emp_actividad'];
   $emp_actividad = str_replace("'", "''", $actividad);

   $estado = $_POST['emp_estado'];
   $emp_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $sql = "select sp_empresa(
   {$_POST['emp_codigo']}, 
   '$emp_telefono', 
   '$emp_razonsocial', 
   '$emp_ruc', 
   '$timbrado', 
   '$emp_email', 
   '$emp_actividad', 
   '$emp_estado',
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento2')";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA EXISTE LA EMPRESA",
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
   $sql = "select coalesce(max(emp_codigo),0)+1 as emp_codigo from empresa";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               e.emp_codigo,
               e.emp_telefono,
               e.emp_razonsocial,
               e.emp_ruc,
               e.emp_timbrado,
               e.emp_email,
               e.emp_actividad,
               e.emp_estado 
            from empresa e
            order by e.emp_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);

}

?>