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
   $funpro_nombre = pg_escape_string($conexion, $_POST['funpro_nombre']);

   $funpro_apellido = pg_escape_string($conexion, $_POST['funpro_apellido']);

   $funpro_documento = pg_escape_string($conexion, $_POST['funpro_documento']);

   $tipro_descripcion = pg_escape_string($conexion, $_POST['tipro_descripcion']);

   $pro_razonsocial = pg_escape_string($conexion, $_POST['pro_razonsocial']);

   $funpro_estado = pg_escape_string($conexion, $_POST['funpro_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $sql = "select sp_funcionario_proveedor(
   {$_POST['funpro_codigo']}, 
   '$funpro_nombre', 
   '$funpro_apellido', 
   '$funpro_documento', 
   '$funpro_estado', 
   {$_POST['pro_codigo']},
   {$_POST['tipro_codigo']},
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento',
   '$pro_razonsocial',
   '$tipro_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "funcionario") !== false) {
      $response = array(
         "mensaje" => "YA SE ENCUENTRA REGISTRADO EL FUNCIONARIO PROVEEDOR",
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
   $sql = "select coalesce(max(funpro_codigo),0)+1 as funpro_codigo from funcionario_proveedor;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               fp.funpro_codigo,
               fp.funpro_nombre,
               fp.funpro_apellido,
               fp.funpro_documento,
               fp.funpro_estado,
               fp.pro_codigo,
               fp.tipro_codigo,
               p.pro_razonsocial,
               tp.tipro_descripcion 
            from funcionario_proveedor fp 
               join proveedor p on p.pro_codigo=fp.pro_codigo 
               and p.tipro_codigo=fp.tipro_codigo 
                  join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
            order by fp.funpro_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>