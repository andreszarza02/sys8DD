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

   $estado = $_POST['asigperm_estado'];
   $asigperm_estado = str_replace("'", "''", $estado);

   $usuLoginReg = $_POST['usu_login_reg'];
   $usu_login_reg = str_replace("'", "''", $usuLoginReg);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $perfDescripcion = $_POST['perf_descripcion'];
   $perf_descripcion = str_replace("'", "''", $perfDescripcion);

   $permDescripcion = $_POST['perm_descripcion'];
   $perm_descripcion = str_replace("'", "''", $permDescripcion);

   $sql = "select sp_asignacion_permiso_usuario(
   {$_POST['asigperm_codigo']}, 
   {$_POST['usu_codigo']}, 
   {$_POST['perfpe_codigo']}, 
   {$_POST['perf_codigo']}, 
   {$_POST['perm_codigo']},
   '$asigperm_estado',
   {$_POST['operacion']},
   {$_POST['usu_codigo_reg']},
   '$usu_login_reg',
   '$procedimiento2',
   '$usu_login',
   '$perf_descripcion',
   '$perm_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA EXISTE LA ASIGNACIÓN",
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
   $sql = "select coalesce(max(asigperm_codigo),0)+1 as asigperm_codigo from asignacion_permiso_usuario;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
            apu.asigperm_codigo,
            apu.usu_codigo,
            apu.perfpe_codigo,
            apu.perf_codigo,
            apu.perm_codigo,
            apu.asigperm_estado,
            u.usu_login ,
            p.perf_descripcion,
            p2.perm_descripcion
         from asignacion_permiso_usuario apu
            join usuario u on u.usu_codigo=apu.usu_codigo
            join perfiles_permisos pp on pp.perfpe_codigo=apu.perfpe_codigo 
            and pp.perf_codigo=apu.perf_codigo and pp.perm_codigo=apu.perm_codigo
            join perfil p on p.perf_codigo=pp.perf_codigo
            join permisos p2 on p2.perm_codigo=pp.perm_codigo
         order by apu.asigperm_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>