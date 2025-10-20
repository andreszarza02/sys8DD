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

   $direccion = $_POST['cli_direccion'];
   $cli_direccion = str_replace("'", "''", $direccion);

   $estado = $_POST['cli_estado'];
   $cli_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $persona1 = $_POST['persona'];
   $persona2 = str_replace("'", "''", $persona1);

   $ciuDescripcion = $_POST['ciu_descripcion'];
   $ciu_descripcion = str_replace("'", "''", $ciuDescripcion);

   $sql = "select sp_cliente(
   {$_POST['cli_codigo']}, 
   '$cli_direccion', 
   '$cli_estado', 
   {$_POST['per_codigo']}, 
   {$_POST['ciu_codigo']}, 
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento2',
   '{$_POST['per_numerodocumento']}',
   '$persona2',
   '$ciu_descripcion')";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA ESTA REGISTRADO EL CLIENTE",
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
   $sql = "select coalesce(max(cli_codigo),0)+1 as cli_codigo from cliente";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               c.cli_codigo,
               c.cli_direccion,
               c.cli_estado,
               c.per_codigo,
               c.ciu_codigo,
               p.per_nombre||' '||p.per_apellido as persona,
	           p.per_numerodocumento,
               ci.ciu_descripcion 
         from cliente c
               join personas p on p.per_codigo=c.per_codigo
               join ciudad ci on ci.ciu_codigo=c.ciu_codigo
         order by c.cli_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>