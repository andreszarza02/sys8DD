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

   $estado = $_POST['prepro_estado'];
   $prepro_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace(search: "'", replace: "''", subject: $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $proRUC = $_POST['pro_ruc'];
   $pro_ruc = str_replace("'", "''", $proRUC);

   $proRazonSocial = $_POST['pro_razonsocial'];
   $pro_razonsocial = str_replace("'", "''", $proRazonSocial);

   $empRazonSocial = $_POST['emp_razonsocial'];
   $emp_razonsocial = str_replace("'", "''", $empRazonSocial);

   $sucDescripcion = $_POST['suc_descripcion'];
   $suc_descripcion = str_replace("'", "''", $sucDescripcion);

   $tiproDescripcion = $_POST['tipro_descripcion'];
   $tipro_descripcion = str_replace("'", "''", $tiproDescripcion);

   $sql = "select sp_presupuesto_proveedor_cab(
      {$_POST['prepro_codigo']}, 
      '{$_POST['prepro_fechaactual']}', 
      '$prepro_estado', 
      '{$_POST['prepro_fechavencimiento']}', 
      {$_POST['usu_codigo']}, 
      {$_POST['pro_codigo']}, 
      {$_POST['tipro_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['pedco_codigo']}, 
      {$_POST['operacion_cabecera']},
      '$usu_login',
      '$procedimiento2',
      '$pro_ruc',
      '$pro_razonsocial',
      '$emp_razonsocial',
      '$suc_descripcion',
      '$tipro_descripcion'
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "LA FECHA DE REGISTRO ES MAYOR A LA FECHA DE VENCIMIENTO",
         "tipo" => "error"
      );
   } else if (strpos($error, "2") !== false) {
      $response = array(
         "mensaje" => "EL PROVEEDOR SELECCIONADO YA TIENE DESIGNADO UN PRESUPUESTO DE ACUERDO AL PEDIDO",
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
   $sql = "select coalesce(max(prepro_codigo),0)+1 as prepro_codigo from presupuesto_proveedor_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * from v_presupuesto_proveedor_cab vppc where vppc.prepro_estado <> 'ANULADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>