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
   $pro_telefono = pg_escape_string($conexion, $_POST['pro_telefono']);

   $pro_razonsocial = pg_escape_string($conexion, $_POST['pro_razonsocial']);

   $pro_ruc = pg_escape_string($conexion, $_POST['pro_ruc']);

   $pro_timbrado = pg_escape_string($conexion, $_POST['pro_timbrado']);

   $pro_email = pg_escape_string($conexion, $_POST['pro_email']);

   $pro_direccion = pg_escape_string($conexion, $_POST['pro_direccion']);

   $pro_estado = pg_escape_string($conexion, $_POST['pro_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $tipro_descripcion = pg_escape_string($conexion, $_POST['tipro_descripcion']);

   $sql = "select sp_proveedor(
   {$_POST['pro_codigo']}, 
   {$_POST['tipro_codigo']}, 
   '$pro_razonsocial', 
   '$pro_ruc', 
   '$pro_timbrado', 
   '{$_POST['pro_timbrado_venc']}', 
   '$pro_direccion', 
   '$pro_telefono', 
   '$pro_email', 
   '$pro_estado',
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento',
   '$tipro_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "ruc") !== false) {
      $response = array(
         "mensaje" => "YA SE ENCUENTRA REGISTRADO EL PROVEEDOR",
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
   $sql = "select coalesce(max(pro_codigo),0)+1 as pro_codigo from proveedor";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               p.pro_codigo, 
               p.tipro_codigo,
               p.pro_razonsocial,
               p.pro_ruc,
               p.pro_timbrado,
               p.pro_direccion,
               p.pro_telefono,
               p.pro_email,
               p.pro_estado,
               tp.tipro_descripcion,
               P.pro_timbrado_venc
          from proveedor p 
               join tipo_proveedor tp 
               on p.tipro_codigo=tp.tipro_codigo 
         order by p.pro_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>