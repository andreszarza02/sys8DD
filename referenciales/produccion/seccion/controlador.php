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

   $descripcion = $_POST['secc_descripcion'];
   $secc_descripcion = str_replace("'", "''", $descripcion);

   $estado = $_POST['secc_estado'];
   $secc_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $empRazonSocial = $_POST['emp_razonsocial'];
   $emp_razonsocial = str_replace("'", "''", $empRazonSocial);

   $sucDescripcion = $_POST['suc_descripcion'];
   $suc_descripcion = str_replace("'", "''", $sucDescripcion);

   $sql = "select sp_seccion(
   {$_POST['secc_codigo']}, 
   '$secc_descripcion', 
   '$secc_estado', 
   {$_POST['suc_codigo']}, 
   {$_POST['emp_codigo']}, 
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento2',
   '$emp_razonsocial',
   '$suc_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA EXISTE LA SECCION EN LA SUCURSAL",
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
   $sql = "select coalesce(max(secc_codigo),0)+1 as secc_codigo from seccion;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               s.secc_codigo,
               s.secc_descripcion,
               s.secc_estado,
               s.suc_codigo,
               s.emp_codigo,
               su.suc_descripcion,
               e.emp_razonsocial
         from seccion s 
               join sucursal su on su.suc_codigo=s.suc_codigo
               and su.emp_codigo=s.emp_codigo
               join empresa e on e.emp_codigo=su.emp_codigo
         order by s.secc_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>