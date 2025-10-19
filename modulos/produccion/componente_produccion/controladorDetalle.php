<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Consultamos si existe la variable operacion detalle
if (isset($_POST['operacion_detalle'])) {

   // Definimos y cargamos las variables
   $comprodet_cantidad = str_replace(",", ".", $_POST['comprodet_cantidad']);


   $sql = "select sp_componente_produccion_det(
      {$_POST['compro_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      $comprodet_cantidad, 
      {$_POST['operacion_detalle']}
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "item") !== false) {
      $response = array(
         "mensaje" => "LA MATERIA PRIMA YA SE ENCUENTRA REGISTRADA EN EL DETALLE",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['componente'])) {

   $componente = $_POST['componente'];

   $sql = "select 
               * 
            from v_componente_produccion_det vcpd 
            where vcpd.compro_codigo=$componente";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);

}

?>