<?php
//Retorno JSON
header("Content-type: application/json; charset=utf-8");
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Consultamos si existe la variable operacion cabecera
if (isset($_POST['operacion_cabecera'])) {

   $estado = $_POST['pedpro_estado'];
   $pedpro_estado = str_replace("'", "''", $estado);

   $sql = "select sp_pedido_produccion_cab(
      {$_POST['pedpro_codigo']}, 
      '{$_POST['pedpro_fecha']}', 
      '$pedpro_estado', 
      {$_POST['usu_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['operacion_cabecera']}
      )";

   //ejecutamos la consulta
   $result = pg_query($conexion, $sql);

   $response = array(
      "mensaje" => pg_last_notice($conexion),
      "tipo" => "info"
   );

   echo json_encode($response);

} else {
   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * from v_pedido_produccion_cab";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>