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
   $orcomdet_cantidad = str_replace(",", ".", $_POST['orcomdet_cantidad']);

   $orcomdet_precio = str_replace(",", ".", $_POST['orcomdet_precio']);

   $sql = "select sp_orden_compra_det(
      {$_POST['orcom_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      $orcomdet_cantidad, 
      $orcomdet_precio, 
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

   // Consultamos si existe la variable consulta y si es igual a 2
} else if (isset($_POST['consulta1'])) {

   //Consultamos si el numero de orden de compra ya se ecnuentra asociado a una compra
   $sql = "select 
	            1
            from orden_compra oc 
               join orden_compra_cab occ on occ.orcom_codigo=oc.orcom_codigo
               join compra_cab cc on cc.comp_codigo=oc.comp_codigo 
            where oc.orcom_codigo={$_POST['orcom_codigo']} and cc.comp_estado <> 'ANULADO';";

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

   // Consultamos si existe la variable consulta y si es igual a 3
} else if (isset($_POST['consulta2']) && !empty($_POST['prepro_codigo'])) {

   $prepro_codigo = (int) $_POST['prepro_codigo'];

   //Consultamos la sumatoria de presupuesto proveedor detalle
   $sql = "select 
            (sum(case 
               when vppd.tipit_codigo = 3 then
                  vppd.peprodet_precio
               else
                  vppd.peprodet_cantidad*vppd.peprodet_precio
            end))/{$_POST['orcom_cuota']} as division
            from v_presupuesto_proveedor_det vppd 
            where vppd.prepro_codigo=$prepro_codigo;";

   $resultado = pg_query($conexion, $sql);
   $cuota = pg_fetch_assoc($resultado);
   $cuota['division'] = (int) $cuota['division'];

   echo json_encode($cuota);

   // Consultamos si existe la variable orden
} else if (isset($_POST['orden'])) {
   $orden = $_POST['orden'];
   $sql = "select 
            * 
           from v_orden_compra_det vocd 
           where vocd.orcom_codigo = $orden;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>