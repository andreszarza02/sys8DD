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
   $notvendet_cantidad = str_replace(",", ".", $_POST['notvendet_cantidad']);

   $notvendet_precio = str_replace(",", ".", $_POST['notvendet_precio']);

   $sql = "select sp_nota_venta_det(
      {$_POST['notven_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']},
      $notvendet_cantidad,
      $notvendet_precio, 
      {$_POST['dep_codigo']},
      {$_POST['suc_codigo']},
      {$_POST['emp_codigo']},
      {$_POST['tipco_codigo']},
      {$_POST['ven_codigo']},
      '{$_POST['notven_numeronota']}',
      {$_POST['tipim_codigo']},
      {$_POST['usu_codigo']},
      {$_POST['operacion_detalle']})";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "item") !== false) {
      $response = array(
         "mensaje" => "YA SE REGISTRO EL ITEM",
         "tipo" => "error"
      );
   } else if (strpos($error, "credito") !== false) {
      $response = array(
         "mensaje" => "LA CANTIDAD DEL ITEM A DEVOLVER SUPERA LA CANTIDAD REGISTRADA EN EL DETALLE DE VENTA AL QUE SE HACE REFERENCIA EN NOTA VENTA CABECERA",
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

   //Consultamos y enviamos la cantidad del item del detalle de venta
   $sql = "select 
            vd.vendet_cantidad 
            from venta_det vd 
            where vd.ven_codigo={$_POST['ven_codigo']}
               and vd.it_codigo={$_POST['it_codigo']}
               and vd.tipit_codigo={$_POST['tipit_codigo']}
               and vd.dep_codigo={$_POST['dep_codigo']}
               and vd.suc_codigo={$_POST['suc_codigo']}
               and vd.emp_codigo={$_POST['emp_codigo']};";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else if (isset($_POST['nota'])) {

   $nota = $_POST['nota'];
   $sql = "select * from v_nota_venta_det where notven_codigo=$nota;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);
}

?>