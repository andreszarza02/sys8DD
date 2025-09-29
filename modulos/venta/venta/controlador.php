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

   // Definimos y cargamos las variables 
   $ven_numfactura = pg_escape_string($conexion, $_POST['ven_numfactura']);

   $ven_timbrado = pg_escape_string($conexion, $_POST['ven_timbrado']);

   $ven_tipofactura = pg_escape_string($conexion, $_POST['ven_tipofactura']);

   $ven_interfecha = pg_escape_string($conexion, $_POST['ven_interfecha']);

   $ven_estado = pg_escape_string($conexion, $_POST['ven_estado']);

   $sql = "select sp_venta_cab(
      {$_POST['ven_codigo']}, 
      '{$_POST['ven_fecha']}',
      '$ven_numfactura', 
      '$ven_timbrado', 
      '{$_POST['ven_timbrado_venc']}', 
      '$ven_tipofactura',
      {$_POST['ven_cuota']}, 
      {$_POST['ven_montocuota']}, 
      '$ven_interfecha', 
      '$ven_estado', 
      {$_POST['usu_codigo']}, 
      {$_POST['cli_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['tipco_codigo']}, 
      {$_POST['peven_codigo']}, 
      {$_POST['caj_codigo']}, 
      {$_POST['operacion_cabecera']}
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   //En caso de encontrar un error generamos el mensaje correspondiente
   if (strpos($error, "factura") !== false) {
      $response = array(
         "mensaje" => "EL NUMERO DE FACTURA CON EL TIMBRADO $ven_timbrado YA SE ENCUENTRA REGISTRADO",
         "tipo" => "error"
      );
   } else if (strpos($error, "asociado") !== false) {
      $response = array(
         "mensaje" => "YA SE ENCUENTRA ASOCIADO LA VENTA A UNA NOTA DE VENTA",
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
   $sql = "select coalesce(max(ven_codigo),0)+1 as ven_codigo from venta_cab;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else if (isset($_POST['consulta2'])) {

   //Generamos el numero de factura y enviamos el mismo al frontend
   $sql = "select 
            lpad(cast(t.suc_codigo as text), 3, '0')|| '-' || 
            lpad(cast(t.caj_codigo as text), 3, '0')|| '-' || 
            lpad(cast((cast(t.timb_numero_comp as integer)+1) as text), 7, '0') as ven_numfactura,
            t.timb_numero as ven_timbrado,
            t.timb_numero_fecha_venc as ven_timbrado_venc
         from timbrados t 
         where t.suc_codigo={$_POST['suc_codigo']}
            and t.emp_codigo={$_POST['emp_codigo']}
            and t.caj_codigo={$_POST['caj_codigo']}
            and t.tipco_codigo=4;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion o la variable consulta llamamos al view de cabecera
   $sql = "select * from v_venta_cab vvc where vvc.ven_estado <> 'ANULADO';";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>