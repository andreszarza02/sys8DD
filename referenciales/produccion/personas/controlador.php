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

   $nombre = $_POST['per_nombre'];
   $per_nombre = str_replace("'", "''", $nombre);

   $apellido = $_POST['per_apellido'];
   $per_apellido = str_replace("'", "''", $apellido);

   $numerodocumento = $_POST['per_numerodocumento'];
   $per_numerodocumento = str_replace("'", "''", $numerodocumento);

   $telefono = $_POST['per_telefono'];
   $per_telefono = str_replace("'", "''", $telefono);

   $email = $_POST['per_email'];
   $per_email = str_replace("'", "''", $email);

   $estado = $_POST['per_estado'];
   $per_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $tipdoDescripcion = $_POST['tipdo_descripcion'];
   $tipdo_descripcion = str_replace("'", "''", $tipdoDescripcion);

   $sql = "select sp_personas(
   {$_POST['per_codigo']}, 
   '$per_nombre',
   '$per_apellido', 
   '$per_numerodocumento',
   '$per_telefono', 
   '$per_email', 
   '$per_estado',
   {$_POST['tipdo_codigo']}, 
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento2',
   '$tipdo_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA ESTA REGISTRADA LA PERSONA",
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
   $sql = "select coalesce(max(per_codigo),0)+1 as per_codigo from personas;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
            p.per_codigo,
            p.per_nombre,
            p.per_apellido,
            p.per_numerodocumento,
            p.per_telefono,
            p.per_email,
            p.per_estado,
            p.tipdo_codigo,
            p.per_nombre||' '||p.per_apellido as persona,
            td.tipdo_descripcion
         from personas p
         join tipo_documento td on td.tipdo_codigo=p.tipdo_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>