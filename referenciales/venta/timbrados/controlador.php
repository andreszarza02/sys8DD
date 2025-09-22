<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Consultamos si existe la variable operacion
if (isset($_POST['operacion'])) {

   $timb_numero = pg_escape_string($conexion, $_POST['timb_numero']);

   $timb_numero_comp = pg_escape_string($conexion, $_POST['timb_numero_comp']);

   $timb_numero_comp_inic = pg_escape_string($conexion, $_POST['timb_numero_comp_inic']);

   $timb_numero_comp_lim = pg_escape_string($conexion, $_POST['timb_numero_comp_lim']);

   $timb_estado = pg_escape_string($conexion, $_POST['timb_estado']);

   $sql = "select sp_timbrados(
   {$_POST['timb_codigo']}, 
   {$_POST['suc_codigo']}, 
   {$_POST['emp_codigo']}, 
   {$_POST['caj_codigo']}, 
   {$_POST['tipco_codigo']}, 
   {$_POST['timb_numero']}, 
   '{$_POST['timb_numero_fecha_inic']}', 
   '{$_POST['timb_numero_fecha_venc']}', 
   '$timb_numero_comp', 
   $timb_numero_comp_inic, 
   $timb_numero_comp_lim, 
   '$timb_estado', 
   {$_POST['usu_codigo']}, 
   {$_POST['operacion']}
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "fecha_venc") !== false) {
      $response = array(
         "mensaje" => "LA FECHA DE VENCIMIENTO NO PUEDE SER MENOR A LA FECHA DE INICIO",
         "tipo" => "error"
      );
   } else if (strpos($error, "numero_limite") !== false) {
      $response = array(
         "mensaje" => "EL NUMERO LIMITE NO PUEDE SER MENOR AL NUMERO DE INICIO",
         "tipo" => "error"
      );
   } else if (strpos($error, "timbrado") !== false) {
      $response = array(
         "mensaje" => "EL NUMERO DE TIMBRADO YA SE ENCUENTRA REGISTRADO",
         "tipo" => "error"
      );
   } else if (strpos($error, "comprobante") !== false) {
      $response = array(
         "mensaje" => "EL COMPROBANTE YA SE ENCUENTRA REGISTRADO",
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
   $sql = "select coalesce(max(timb_codigo),0)+1 as timb_codigo from timbrados;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               t.*,
               s.suc_descripcion,
               e.emp_razonsocial,
               c.caj_descripcion,
               tc.tipco_descripcion,
               lpad(cast(t.suc_codigo as text), 3, '0')|| '-' || 
               lpad(cast(t.caj_codigo as text), 3, '0')|| '-' || t.timb_numero_comp as comprobante
            from timbrados t 
               join sucursal s on s.suc_codigo=t.suc_codigo 
               and s.emp_codigo=t.emp_codigo 
                  join empresa e on e.emp_codigo=s.emp_codigo 
               join caja c on c.caj_codigo=t.caj_codigo 
               join tipo_comprobante tc on tc.tipco_codigo=t.tipco_codigo 
            order by t.timb_codigo;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);
}

?>