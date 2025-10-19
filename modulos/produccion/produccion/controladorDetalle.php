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
   $prodet_cantidad = str_replace(",", ".", $_POST['prodet_cantidad']);

   $prodet_observacion = pg_escape_string($conexion, $_POST['prodet_observacion']);

   $prodet_estado = pg_escape_string($conexion, $_POST['prodet_estado']);

   $sql = "select sp_produccion_det(
      {$_POST['prod_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      $prodet_cantidad, 
      '{$_POST['prodet_fechainicio']}', 
      '{$_POST['prodet_fechafinal']}', 
      '$prodet_observacion', 
      '$prodet_estado', 
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
   } else if (strpos($error, "fecha_mayor") !== false) {
      $response = array(
         "mensaje" => "LA FECHA DE INICIO NO PUEDE SER MAYOR A LA FECHA DE FINALIZACION EN EL DETALLE",
         "tipo" => "error"
      );
   } else if (strpos($error, "cancelar") !== false) {
      $response = array(
         "mensaje" => "NO SE PUEDE ELIMINAR UN PRODUCTO TERMINADO",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['produccion'])) {

   $produccion = $_POST['produccion'];
   $sql = "select 
               * 
            from v_produccion_det vpd 
            where vpd.prod_codigo=$produccion";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);

} else if (isset($_POST['consulta1'])) {

   //Consultamos si el numero de produccion ya se encuentra asociado a una o varias etapas de produccion
   $sql = "select distinct 1
            from produccion_det pd 
               join etapa_produccion ep on ep.prod_codigo=pd.prod_codigo 
               and ep.it_codigo=pd.it_codigo 
               and ep.tipit_codigo=pd.tipit_codigo 
            where ep.prod_codigo={$_POST['prod_codigo']} and pd.prodet_estado in('ACTIVO', 'TERMINADO')";

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
}

?>