<?php
//Retorno JSON
header("Content-type: application/json; charset=utf-8");
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/funciones/funciones.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Consultamos si existe la variable operacion cabecera
if (isset($_POST['operacion_cabecera'])) {

   $numeroFactura = $_POST['com_numfactura'];
   $numeroFactura = preg_replace('/\D/', '', $numeroFactura);
   $com_numfactura = formatearNumeroFactura($numeroFactura);

   $montoCuota = $_POST['comp_montocuota'];
   $comp_montocuota = str_replace(",", ".", $montoCuota);

   $intervalo = $_POST['comp_interfecha'];
   $comp_interfecha = str_replace("'", "''", $intervalo);

   $estado = $_POST['comp_estado'];
   $comp_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace(search: "'", replace: "''", subject: $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $tipcoDescripcion = $_POST['tipco_descripcion'];
   $tipco_descripcion = pg_escape_string($conexion, $tipcoDescripcion);

   $proRazonSocial = $_POST['pro_razonsocial'];
   $pro_razonsocial = str_replace("'", "''", $proRazonSocial);

   $tiproDescripcion = $_POST['tipro_descripcion'];
   $tipro_descripcion = str_replace("'", "''", $tiproDescripcion);

   $empRazonSocial = $_POST['emp_razonsocial'];
   $emp_razonsocial = str_replace("'", "''", $empRazonSocial);

   $sucDescripcion = $_POST['suc_descripcion'];
   $suc_descripcion = str_replace("'", "''", $sucDescripcion);

   $sql = "select sp_compra_cab(
      {$_POST['comp_codigo']}, 
      '{$_POST['comp_fecha']}', 
      '$com_numfactura',
      '{$_POST['comp_timbrado']}', 
      '{$_POST['comp_tipofactura']}',
      {$_POST['comp_cuota']}, 
      $comp_montocuota, 
      '$comp_interfecha', 
      '$comp_estado', 
      {$_POST['pro_codigo']}, 
      {$_POST['tipro_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['usu_codigo']}, 
      {$_POST['orcom_codigo']}, 
      {$_POST['tipco_codigo']}, 
      {$_POST['operacion_cabecera']},
      '$usu_login',
      '$procedimiento2',
      '$tipco_descripcion',
      '$pro_razonsocial',
      '$tipro_descripcion',
      '$emp_razonsocial',
      '$suc_descripcion'
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "factura") !== false) {
      $response = array(
         "mensaje" => "YA ESTA REGISTRADO EL NUMERO DE FACTURA DEL PROVEEDOR",
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
   $sql = "select coalesce(max(comp_codigo),0)+1 as comp_codigo from compra_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * from v_compra_cab vcc where vcc.comp_estado <> 'ANULADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>