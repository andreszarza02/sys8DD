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
   $dep_descripcion = pg_escape_string($conexion, $_POST['dep_descripcion']);

   $dep_estado = pg_escape_string($conexion, $_POST['dep_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $ciu_descripcion = pg_escape_string($conexion, $_POST['ciu_descripcion']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);

   $sql = "select sp_deposito(
   {$_POST['dep_codigo']}, 
   {$_POST['suc_codigo']},
   {$_POST['emp_codigo']}, 
   '$dep_descripcion', 
   '$dep_estado', 
   {$_POST['ciu_codigo']}, 
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento',
   '$ciu_descripcion',
   '$emp_razonsocial',
   '$suc_descripcion')";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "descripcion") !== false) {
      $response = array(
         "mensaje" => "YA SE ENCUENTRA ASOCIADO UN DEPOSITO CON ESA DESCRIPCION A LA SUCURSAL",
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
   $sql = "select coalesce(max(dep_codigo),0)+1 as dep_codigo from deposito";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               d.dep_codigo,
               d.suc_codigo,
               d.emp_codigo,
               d.dep_descripcion,
               d.dep_estado,
               d.ciu_codigo,
               e.emp_razonsocial,
               s.suc_descripcion,
               c.ciu_descripcion
         from deposito d 
               join ciudad c on c.ciu_codigo=d.ciu_codigo
               join sucursal s on s.suc_codigo=d.suc_codigo 
               and s.emp_codigo=d.emp_codigo
               join empresa e on e.emp_codigo=s.emp_codigo
         order by d.dep_codigo";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>