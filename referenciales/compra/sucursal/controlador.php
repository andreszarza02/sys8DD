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

   $descripcion = $_POST['suc_descripcion'];
   $suc_descripcion = str_replace("'", "''", $descripcion);

   $direccion = $_POST['suc_direccion'];
   $suc_direccion = str_replace("'", "''", $direccion);

   $telefono = $_POST['suc_telefono'];
   $suc_telefono = str_replace("'", "''", $telefono);

   $estado = $_POST['suc_estado'];
   $suc_estado = str_replace("'", "''", $estado);

   $email = $_POST['suc_email'];
   $suc_email = str_replace("'", "''", $email);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $ciuDescripcion = $_POST['ciu_descripcion'];
   $ciu_descripcion = str_replace("'", "''", $ciuDescripcion);

   $empRazonSocial = $_POST['emp_razonsocial'];
   $emp_razonsocial = str_replace("'", "''", $empRazonSocial);

   $sql = "select sp_sucursal(
   {$_POST['suc_codigo']}, 
   {$_POST['emp_codigo']},
   '$suc_descripcion', 
   '$suc_direccion',
   '$suc_telefono', 
   '$suc_estado',
   {$_POST['ciu_codigo']}, 
   '$suc_email', 
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento2',
   '$ciu_descripcion',
   '$emp_razonsocial')";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA EXISTE LA SUCURSAL",
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
   $sql = "select coalesce(max(suc_codigo),0)+1 as suc_codigo from sucursal;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select
            s.suc_codigo,
            s.emp_codigo,
            s.suc_descripcion,
            s.suc_direccion,
            s.suc_telefono,
            s.suc_estado,
            s.suc_email,
            s.ciu_codigo,
            e.emp_razonsocial,
            c.ciu_descripcion
         from sucursal s
            join empresa e on e.emp_codigo=s.emp_codigo
            join ciudad c on c.ciu_codigo=s.ciu_codigo
            order by s.suc_codigo";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>