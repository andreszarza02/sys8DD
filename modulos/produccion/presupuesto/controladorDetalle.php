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
   $presdet_cantidad = str_replace(",", ".", $_POST['presdet_cantidad']);

   $presdet_precio = str_replace(",", ".", $_POST['presdet_precio']);

   $sql = "select sp_presupuesto_det(
      {$_POST['pres_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      $presdet_cantidad, 
      $presdet_precio, 
      {$_POST['operacion_detalle']}
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "item") !== false) {
      $response = array(
         "mensaje" => "YA SE REGISTRO EL ITEM",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['consulta1'])) {

   //Consultamos si el numero de presupuesto ya se ecnuentra asociado a una orden
   $sql = "select 1 from orden_presupuesto op 
				join presupuesto_cab pc on pc.pres_codigo=op.pres_codigo 
				join orden_produccion_cab opc on opc.orpro_codigo=op.orpro_codigo 
			where op.pres_codigo={$_POST['pres_codigo']} 
         and opc.orpro_estado <> 'ANULADO'";

   $resultado = pg_query($conexion, $sql);

   // Si devuelve alguna fila generamos una respuesta con "asociado"
   if (pg_num_rows($resultado) > 0) {
      // Al menos un registro encontrado
      $response = array(
         "validacion" => "asociado",
      );
   } else {
      // Si no, generamos una respuesta con "no_asociado"
      $response = array(
         "validacion" => "no_asociado",
      );
   }

   echo json_encode($response);

} else if (isset($_POST['presupuesto'])) {

   $presupuesto = $_POST['presupuesto'];

   $sql = "select 
               * 
            from v_presupuesto_det vpd 
            where vpd.pres_codigo=$presupuesto";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);

}

?>