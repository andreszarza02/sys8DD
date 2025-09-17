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

   //Definimos y cargamos las variables
   $nocomdet_cantidad = str_replace(",", ".", $_POST['nocomdet_cantidad']);

   $nocomdet_precio = str_replace(",", ".", $_POST['nocomdet_precio']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $sql = "select sp_nota_compra_det(
      {$_POST['nocom_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      $nocomdet_cantidad, 
      $nocomdet_precio, 
      {$_POST['dep_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['tipco_codigo']}, 
      {$_POST['comp_codigo']}, 
      {$_POST['usu_codigo']},  
      {$_POST['operacion_detalle']},
      '$usu_login'
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

} else if (isset($_POST['consulta0'])) {

   //Consultamos y enviamos el ultimo codigo
   $sql = "select coalesce ((select 1 from (select ncd.it_codigo from nota_compra_det ncd where ncd.nocom_codigo={$_POST['nocom_codigo']} and ncd.it_codigo={$_POST['it_codigo']} and ncd.tipit_codigo={$_POST['tipit_codigo']} and ncd.dep_codigo={$_POST['dep_codigo']} and ncd.suc_codigo={$_POST['suc_codigo']} and ncd.emp_codigo={$_POST['emp_codigo']})g),0) as existe_item;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else if (isset($_POST['consulta1'])) {

   //Consultamos y enviamos la cantidad del item del detalle
   $sql = "select 
            cd.compdet_cantidad as cantidad_compra_det 
         from compra_det cd 
         where cd.comp_codigo={$_POST['comp_codigo']} 
            and cd.it_codigo={$_POST['it_codigo']}
            and cd.tipit_codigo={$_POST['tipit_codigo']}
            and cd.dep_codigo={$_POST['dep_codigo']} 
            and cd.suc_codigo={$_POST['suc_codigo']}
            and cd.emp_codigo={$_POST['emp_codigo']};";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else if (isset($_POST['nota'])) {

   $nota = $_POST['nota'];
   $sql = "select 
            * 
          from v_nota_compra_det vncd where vncd.nocom_codigo = $nota";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);
}

?>