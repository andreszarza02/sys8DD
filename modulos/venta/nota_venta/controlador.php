<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Solicitamos la clase de Funciones
include_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/funciones/funciones.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();


//Consultamos si existe la variable operacion cabecera
if (isset($_POST['operacion_cabecera'])) {

   // Definimos y cargamos las variables
   $notven_concepto = pg_escape_string($conexion, $_POST['notven_concepto']);

   $notven_estado = pg_escape_string($conexion, $_POST['notven_estado']);

   $sql = "select sp_nota_venta_cab(
      {$_POST['notven_codigo']}, 
      '{$_POST['notven_fecha']}', 
      '{$_POST['notven_timbrado']}', 
      '{$_POST['notven_timbrado_venc']}', 
      '{$_POST['notven_numeronota']}',
      '$notven_concepto',
      {$_POST['notven_funcionario']},
      {$_POST['notven_chapa']},
      '$notven_estado',  
      {$_POST['tipco_codigo']}, 
      {$_POST['ven_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['usu_codigo']}, 
      {$_POST['cli_codigo']}, 
      {$_POST['operacion_cabecera']}
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "nota") !== false) {
      $response = array(
         "mensaje" => "EL NUMERO DE NOTA YA SE ENCUENTRA REGISTRADO",
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
   $sql = "select coalesce(max(notven_codigo),0)+1 as notven_codigo from nota_venta_cab;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else if (isset($_POST['consulta2'])) {

   //Consultamos y validamos si la nota de credito o debito contiene detalle
   $sql = "select 1
            from v_nota_compra_det vncd 
            where vncd.nocom_codigo={$_POST['nocom_codigo']};";

   $resultado = pg_query($conexion, $sql);

   // Validamos si cabecera tiene detalles asociados
   if (pg_num_rows($resultado) > 0) {
      // Al menos un registro encontrado
      $response = array(
         "calculo_cuota" => "si",
         "mensaje" => "NADA"
      );
   } else {
      // Si no, especificamos un mensaje de no calculo
      $response = array(
         "calculo_cuota" => "no",
         "mensaje" => "LA NOTA NO TIENE DETALLE, NO SE PUEDE ACTUALIZAR DATOS DE VENTA"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['consulta3'])) {

   // Consultamos los datos de configuracion sucursal, para generar el numero de nota
   $configuracion = obtenerConfiguraciones($conexion, $_POST['suc_codigo'], $_POST['emp_codigo'], 2);

   //Consultamos y generamos el numero de nota en base al tipo de comprobante
   $sql = "select 
            lpad(cast(t.suc_codigo as text), 3, '0')|| '-' || 
            lpad(cast(t.caj_codigo as text), 3, '0')|| '-' || 
            lpad(cast((cast(t.timb_numero_comp as integer)+1) as text), 7, '0') as notven_numeronota,
            t.timb_numero as notven_timbrado,
            t.timb_numero_fecha_venc as notven_timbrado_venc,
            (cast(t.timb_numero_comp as integer)+1) as proximo_numero,
            t.timb_numero_comp_lim as limite
         from timbrados t 
         where t.suc_codigo={$_POST['suc_codigo']}
            and t.emp_codigo={$_POST['emp_codigo']}
            and t.caj_codigo={$configuracion['config_validacion']}
            and t.tipco_codigo={$_POST['tipco_codigo']};";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else {
   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               * 
            from v_nota_venta_cab vnvc 
            where vnvc.notven_estado <> 'ANULADO'";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);
}

?>