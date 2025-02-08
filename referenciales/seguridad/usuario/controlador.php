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

   $login = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $login);

   $contrasenia = $_POST['usu_contrasenia'];
   $usu_contrasenia = str_replace("'", "''", $contrasenia);

   $estado = $_POST['usu_estado'];
   $usu_estado = str_replace("'", "''", $estado);

   $usuLoginReg = $_POST['usu_login_reg'];
   $usu_login_reg = str_replace("'", "''", $usuLoginReg);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $funcionario1 = $_POST['funcionario'];
   $funcionario2 = str_replace("'", "''", $funcionario1);

   $perfDescripcion = $_POST['perf_descripcion'];
   $perf_descripcion = str_replace("'", "''", $perfDescripcion);

   $moduDescripcion = $_POST['modu_descripcion'];
   $modu_descripcion = str_replace("'", "''", $moduDescripcion);

   $sql = "select sp_usuario(
   {$_POST['usu_codigo']}, 
   '$usu_login', 
   '$usu_contrasenia', 
   {$_POST['modu_codigo']},
   {$_POST['perf_codigo']}, 
   {$_POST['func_codigo']},
   '$usu_estado',
   {$_POST['operacion']},
   {$_POST['usu_codigo_reg']},
   '$usu_login_reg',
   '$procedimiento2',
   '$funcionario2',
   '$perf_descripcion',
   '$modu_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA ESTA REGISTRADO EL USUARIO",
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
   $sql = "select coalesce(max(usu_codigo),0)+1 as usu_codigo from usuario;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
            u.usu_codigo,
            u.usu_login,
            u.usu_contrasenia,
            u.usu_estado,
            u.usu_fecha,
            u.modu_codigo,
            u.perf_codigo,
            u.func_codigo,
            m.modu_descripcion,
            p.perf_descripcion,
            p2.per_nombre||' '||p2.per_apellido as funcionario,
	         p2.per_numerodocumento
         from usuario u
            join modulo m on m.modu_codigo=u.modu_codigo
            join perfil p on p.perf_codigo=u.perf_codigo
            join funcionario f on f.func_codigo=u.func_codigo
            join personas p2 on p2.per_codigo=f.per_codigo
         order by u.usu_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>