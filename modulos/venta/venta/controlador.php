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

   //Recibimos y definimos las variables
   $ven_numfactura = pg_escape_string($conexion, $_POST['ven_numfactura']);

   $ven_timbrado = pg_escape_string($conexion, $_POST['ven_timbrado']);

   $ven_interfecha = pg_escape_string($conexion, $_POST['ven_interfecha']);

   $ven_estado = pg_escape_string($conexion, $_POST['ven_estado']);

   $sql = "select sp_venta_cab(
      {$_POST['ven_codigo']}, 
      '{$_POST['ven_fecha']}',
      '$ven_numfactura', 
      '$ven_timbrado', 
      '{$_POST['ven_tipofactura']}',
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
         "mensaje" => "EL NUMERO DE FACTURA YA SE ENCUENTRA REGISTRADO EN LA BASE DE DATOS",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['consulta'])) {

   //Si existe la variable, guardamos el valor
   $consulta = $_POST['consulta'];

   //Validamos el valor de la variable
   if ($consulta == 1) {

      //Si es 1, consultamos y enviamos el ultimo codigo
      $sql = "select coalesce(max(ven_codigo),0)+1 as ven_codigo from venta_cab;";
      $resultado = pg_query($conexion, $sql);
      $datos = pg_fetch_assoc($resultado);
      echo json_encode($datos);

   } else {

      //Si la variable es 2, generamos el numero de factura y enviamos el mismo al frontend
      $sql = "select 
               lpad(cast(fv.suc_codigo as text), 3, '0')|| '-' || 
               lpad(cast(fv.caj_codigo as text), 3, '0')|| '-' || 
               lpad(cast((cast(fv.facven_numero as integer)+1) as text), 7, '0') as ven_numfactura
            from factura_venta fv 
            where fv.suc_codigo={$_POST['suc_codigo']}
               and fv.emp_codigo={$_POST['emp_codigo']}
               and fv.caj_codigo={$_POST['caj_codigo']};";

      $resultado = pg_query($conexion, $sql);
      $datos = pg_fetch_assoc($resultado);
      echo json_encode($datos);
   }

} else {

   //Si el post no recibe la operacion o la variable consulta llamamos al view de cabecera
   $sql = "select * from v_venta_cab vvc where vvc.ven_estado <> 'ANULADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>