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

   $estado = $_POST['costserv_estado'];
   $costserv_estado = str_replace("'", "''", $estado);

   $sql = "select sp_costo_servicio({$_POST['costserv_codigo']}, {$_POST['costserv_costo']},'$costserv_estado',{$_POST['mod_codigo']},{$_POST['operacion']})";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA SE REGISTRO EL COSTO DEL MODELO",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);


} else {
   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               cs.*,
               m.mod_codigomodelo
         from costo_servicio cs
               join modelo m on m.mod_codigo=cs.mod_codigo
         order by cs.costserv_codigo";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>