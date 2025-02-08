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

   $telefono = $_POST['pro_telefono'];
   $pro_telefono = str_replace("'", "''", $telefono);

   $razonsocial = $_POST['pro_razonsocial'];
   $pro_razonsocial = str_replace("'", "''", $razonsocial);

   $ruc = $_POST['pro_ruc'];
   $pro_ruc = str_replace("'", "''", $ruc);

   $timbrado = $_POST['pro_timbrado'];
   $pro_timbrado = str_replace("'", "''", $timbrado);

   $email = $_POST['pro_email'];
   $pro_email = str_replace("'", "''", $email);

   $direccion = $_POST['pro_direccion'];
   $pro_direccion = str_replace("'", "''", $direccion);

   $estado = $_POST['pro_estado'];
   $pro_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $tiproDescripcion = $_POST['tipro_descripcion'];
   $tipro_descripcion = str_replace("'", "''", $tiproDescripcion);

   $sql = "select sp_proveedor(
   {$_POST['pro_codigo']}, 
   {$_POST['tipro_codigo']}, 
   '$pro_razonsocial', 
   '$pro_ruc', 
   '$pro_timbrado', 
   '$pro_direccion', 
   '$pro_telefono', 
   '$pro_email', 
   '$pro_estado',
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento2',
   '$tipro_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA EXISTE EL PROVEEDOR",
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
               tp.tipro_descripcion 
          from proveedor p 
               join tipo_proveedor tp 
               on p.tipro_codigo=tp.tipro_codigo 
         order by p.pro_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>