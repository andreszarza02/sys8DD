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

   $concepto = $_POST['notven_concepto'];
   $notven_concepto = str_replace("'", "''", $concepto);

   $estado = $_POST['notven_estado'];
   $notven_estado = str_replace("'", "''", $estado);

   $sql = "select sp_nota_venta_cab(
      {$_POST['notven_codigo']}, 
      '{$_POST['notven_fecha']}', 
      '{$_POST['notven_numeronota']}',
      '$notven_concepto',
      '$notven_estado',  
      {$_POST['tipco_codigo']}, 
      {$_POST['ven_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['usu_codigo']}, 
      {$_POST['cli_codigo']}, 
      {$_POST['operacion_cabecera']}
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "nota") !== false) {
      $response = array(
         "mensaje" => "EL NUMERO DE NOTA YA ESTA REGISTRADO",
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
   $sql = "select coalesce(max(notven_codigo),0)+1 as notven_codigo from nota_venta_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {
   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * from v_nota_venta_cab";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>