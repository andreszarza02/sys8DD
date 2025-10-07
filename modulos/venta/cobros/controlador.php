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
   $cob_estado = pg_escape_string($conexion, $_POST['cob_estado']);

   $sql = "select sp_cobro_cab(
      {$_POST['cob_codigo']}, 
      '{$_POST['cob_fecha']}', 
      '$cob_estado', 
      {$_POST['cob_numerocuota']},
      {$_POST['apercie_codigo']},
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['caj_codigo']}, 
      {$_POST['usu_codigo']},  
      {$_POST['tipco_codigo']},  
      {$_POST['ven_codigo']},  
      '{$_POST['cob_num_recibo']}', 
      {$_POST['operacion_cabecera']}
      )";

   //ejecutamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "recibo") !== false) {
      $response = array(
         "mensaje" => "EL NUMERO DE RECIBO YA SE ENCUENTRA REGISTRADO, POR FAVOR VERIFIQUE E INTENTE NUEVAMENTE",
         "tipo" => "error"
      );
   } else if (strpos($error, "cuota") !== false) {
      $response = array(
         "mensaje" => "PARA ANULAR EL COBRO SE DEBE DE ANULAR EL O LOS COBROS SUPERIORES",
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
   $sql = "select coalesce(max(cob_codigo),0)+1 as cob_codigo from cobro_cab;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else if (isset($_POST['consulta2'])) {

   //Consultamos y enviamos el ultimo codigo
   $sql = "select 
            lpad(cast((max(cast(t.timb_numero_comp as integer))+1) as text), 7, '0') as cob_num_recibo,
            (max(cast(t.timb_numero_comp as integer))+1) as proximo_numero,
            t.timb_numero_comp_lim as limite
         from timbrados t where tipco_codigo=5
         group by timb_numero_comp, t.timb_numero_comp_lim;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);

   // Validación contra el límite
   if ((int) $datos['proximo_numero'] > (int) $datos['limite']) {
      echo json_encode([
         "error" => true,
         "mensaje" => "Se alcanzó el máximo de recibos permitidos. Debe ampliar el rango."
      ]);
   } else {
      echo json_encode($datos);
   }

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               * 
            from v_cobro_cab vcc 
             where vcc.cob_estado <> 'ANULADO';";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);
}

?>