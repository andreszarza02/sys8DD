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
   $emp_telefono = pg_escape_string($conexion, $_POST['emp_telefono']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $emp_ruc = pg_escape_string($conexion, $_POST['emp_ruc']);

   $emp_email = pg_escape_string($conexion, $_POST['emp_email']);

   $emp_actividad = pg_escape_string($conexion, $_POST['emp_actividad']);

   $emp_estado = pg_escape_string($conexion, $_POST['emp_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $sql = "select sp_empresa(
   {$_POST['emp_codigo']}, 
   '$emp_telefono', 
   '$emp_razonsocial', 
   '$emp_ruc', 
   '$emp_email', 
   '$emp_actividad', 
   '$emp_estado',
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "fecha") !== false) {
      $response = array(
         "mensaje" => "LA FECHA DE VENCIMIENTO DEBE SER MAYOR A LA FECHA DE INICIO",
         "tipo" => "error"
      );
   } elseif (strpos($error, "ruc") !== false) {
      $response = array(
         "mensaje" => "YA EXISTE UNA EMPRESA CON ESE RUC",
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