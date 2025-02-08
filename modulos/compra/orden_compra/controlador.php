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

   $estado = $_POST['orcom_estado'];
   $orcom_estado = str_replace("'", "''", $estado);

   $interfecha = $_POST['orcom_interfecha'];
   $orcom_interfecha = str_replace("'", "''", $interfecha);

   $montoCuota = $_POST['orcom_montocuota'];
   $orcom_montocuota = str_replace(",", ".", $montoCuota);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace(search: "'", replace: "''", subject: $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $proRazonSocial = $_POST['pro_razonsocial'];
   $pro_razonsocial = str_replace("'", "''", $proRazonSocial);

   $tiproDescripcion = $_POST['tipro_descripcion'];
   $tipro_descripcion = str_replace("'", "''", $tiproDescripcion);

   $empRazonSocial = $_POST['emp_razonsocial'];
   $emp_razonsocial = str_replace("'", "''", $empRazonSocial);

   $sucDescripcion = $_POST['suc_descripcion'];
   $suc_descripcion = str_replace("'", "''", $sucDescripcion);


   $sql = "select sp_orden_compra_cab(
      {$_POST['orcom_codigo']}, 
      '{$_POST['orcom_fecha']}', 
      '{$_POST['orcom_condicionpago']}', 
       {$_POST['orcom_cuota']},
      '{$_POST['orcom_interfecha']}',  
      $orcom_montocuota,
      '$orcom_estado', 
      {$_POST['usu_codigo']}, 
      {$_POST['pro_codigo']}, 
      {$_POST['tipro_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['prepro_codigo']}, 
      {$_POST['pedco_codigo']}, 
      {$_POST['operacion_cabecera']},
      '$usu_login',
      '$procedimiento2',
      '$pro_razonsocial',
      '$tipro_descripcion',
      '$emp_razonsocial',
      '$suc_descripcion'
      )";

   //Ejecutamos la consulta
   $result = pg_query($conexion, $sql);

   $response = array(
      "mensaje" => pg_last_notice($conexion),
      "tipo" => "info"
   );

   echo json_encode($response);

} else if (isset($_POST['consulta']) == 1) {

   //Consultamos y enviamos el ultimo codigo
   $sql = "select coalesce(max(orcom_codigo),0)+1 as orcom_codigo from orden_compra_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {
   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * from v_orden_compra_cab vocc where vocc.orcom_estado <> 'ANULADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>