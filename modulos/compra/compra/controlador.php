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

   // Definimos y cargamos las variables 
   $numeroFactura = $_POST['comp_numfactura'];
   $numeroFactura = preg_replace('/\D/', '', $numeroFactura);
   $comp_numfactura = formatearNumeroFactura($numeroFactura);

   $comp_montocuota = str_replace(",", ".", $_POST['comp_montocuota']);

   $comp_interfecha = pg_escape_string($conexion, $_POST['comp_interfecha']);

   $comp_estado = pg_escape_string($conexion, $_POST['comp_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $tipco_descripcion = pg_escape_string($conexion, $_POST['tipco_descripcion']);

   $pro_razonsocial = pg_escape_string($conexion, $_POST['pro_razonsocial']);

   $tipro_descripcion = pg_escape_string($conexion, $_POST['tipro_descripcion']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);

   $sql = "select sp_compra_cab(
      {$_POST['comp_codigo']}, 
      '{$_POST['comp_fecha']}', 
      '$comp_numfactura',
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
      '{$_POST['comp_timbrado_venc']}', 
      {$_POST['operacion_cabecera']},
      '$usu_login',
      '$procedimiento',
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
         "mensaje" => "YA SE ENCUENTRA REGISTRADO EL NUMERO DE FACTURA Y TIMBRADO",
         "tipo" => "error"
      );
   } else if (strpos($error, "asociado") !== false) {
      $response = array(
         "mensaje" => "YA SE ENCUENTRA ASOCIADO LA COMPRA A UNA NOTA DE COMPRA",
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

   //Consultamos y enviamos el ultimo codigo
   $sql = "select coalesce(max(comp_codigo),0)+1 as comp_codigo from compra_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               * 
            from v_compra_cab vcc 
            where vcc.comp_estado <> 'ANULADO';";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>