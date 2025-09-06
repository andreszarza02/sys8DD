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
   $peprodet_cantidad = str_replace(",", ".", $_POST['peprodet_cantidad']);

   $peprodet_precio = str_replace(",", ".", $_POST['peprodet_precio']);

   $sql = "select sp_presupuesto_proveedor_det(
      {$_POST['prepro_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      $peprodet_cantidad, 
      $peprodet_precio, 
      {$_POST['operacion_detalle']})";

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

   // Consultamos si existe la variable consulta y si es igual a 2
} else if (isset($_POST['consulta']) == 2) {

   //Consultamos si el numero de presupuesto ya se encuentra asociado a una orden de compra
   $sql = "select
               1
            from presupuesto_orden po 
               join presupuesto_proveedor_cab ppc on ppc.prepro_codigo=po.prepro_codigo 
               join orden_compra_cab occ on occ.orcom_codigo=po.orcom_codigo 
            where po.prepro_codigo={$_POST['prepro_codigo']}
            and occ.orcom_estado <> 'ANULADO';";

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

   // Consultamos si existe la variable presupeusto
} else if (isset($_POST['presupuesto'])) {

   $presupuesto = $_POST['presupuesto'];
   $sql = "select 
               * 
            from v_presupuesto_proveedor_det vppd where vppd.prepro_codigo=$presupuesto;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>