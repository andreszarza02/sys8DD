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

   //Definimos las variables a pasar al sp de detalle
   $orprodet_especificacion = pg_escape_string($conexion, $_POST['orprodet_especificacion']);

   $orprodet_cantidad = str_replace(",", ".", $_POST['orprodet_cantidad']);

   $sql = "select sp_orden_produccion_det(
      {$_POST['orpro_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      '$orprodet_especificacion', 
      $orprodet_cantidad, 
      {$_POST['dep_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['usu_codigo']}, 
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

   //Enviamos una respuesta
   echo json_encode($response);

} else if (isset($_POST['orden'])) {

   //Si se recibe un parametro denominado orden consultamos el detalle
   $orden = $_POST['orden'];
   $sql = "select * from v_orden_produccion_det vopd where vopd.orpro_codigo=$orden";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);

} else if (isset($_POST['orden2'])) {

   //Recibimos el item y el tipo de item para filtar el compro codigo
   $sql = "select 
            compro_codigo as compro_codigo 
          from componente_produccion_cab 
          where it_codigo={$_POST['it_codigo']} 
          and tipit_codigo={$_POST['tipit_codigo']};";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);

   //individualizamos la materia prima por producto y orden de produccion
   $sql2 = "select 
               * 
            from v_orden_produccion_det2 
            where orpro_codigo={$_POST['orden2']} 
            and compro_codigo={$datos['compro_codigo']};";

   $resultado2 = pg_query($conexion, $sql2);

   $datos2 = pg_fetch_all($resultado2);

   echo json_encode($datos2);

} else if (isset($_POST['consulta1'])) {

   //Consultamos si el numero de orden ya se encuentra asociado a una produccion
   $sql = "select 1 
            from produccion_cab pc 
			   where pc.orpro_codigo={$_POST['orpro_codigo']} 
            and pc.prod_estado <> 'ANULADO'";

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