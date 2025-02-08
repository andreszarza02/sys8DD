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

   $estado = $_POST['perfpe_estado'];
   $perfpe_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $perfDescripcion = $_POST['perf_descripcion'];
   $perf_descripcion = str_replace("'", "''", $perfDescripcion);

   $permDescripcion = $_POST['perm_descripcion'];
   $perm_descripcion = str_replace("'", "''", $permDescripcion);

   $sql = "select sp_perfiles_permisos(
   {$_POST['perfpe_codigo']}, 
   {$_POST['perf_codigo']}, 
   {$_POST['perm_codigo']},
   '$perfpe_estado',
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento2',
   '$perf_descripcion',
   '$perm_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA EXISTE EL PERFIL PERMISO",
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
   $sql = "select coalesce(max(perfpe_codigo),0)+1 as perfpe_codigo from perfiles_permisos";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               pp.perfpe_codigo,
               pp.perf_codigo,
               pp.perm_codigo,
               pp.perfpe_estado,
               perf.perf_descripcion,
               perm.perm_descripcion
         from perfiles_permisos pp 
               join perfil perf on perf.perf_codigo=pp.perf_codigo
               join permisos perm on perm.perm_codigo=pp.perm_codigo
         order by perfpe_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>