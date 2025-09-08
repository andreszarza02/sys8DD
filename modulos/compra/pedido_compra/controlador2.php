<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Consultamos si existe la variable consulta1
if (isset($_POST['consulta1'])) {

   // Definimos y cargamos las variables
   $solpre_correo_proveedor = pg_escape_string($conexion, $_POST['solpre_correo_proveedor']);

   $sql = "select sp_solicitud_presupuesto_cab(
      {$_POST['solpre_codigo']}, 
      {$_POST['pedco_codigo2']}, 
      {$_POST['pro_codigo']}, 
      {$_POST['tipro_codigo']}, 
      '{$_POST['solpre_fecha']}', 
      '$solpre_correo_proveedor', 
      {$_POST['usu_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['operacion_cabecera2']}
      )";

   //ejecutamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "pedido") !== false) {
      $response = array(
         "mensaje" => "YA SE ENCUENTRA ASOCIADO EL PEDIDO DE COMPRA A UN PROVEEDOR PARA REALIZAR LA SOLICITUD",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['consulta2'])) {

   //Consultamos y enviamos el ultimo codigo
   $sql = "select coalesce(max(solpre_codigo),0)+1 as solpre_codigo from solicitud_presupuesto_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else if (isset($_POST['consulta3'])) {

   //Si el post recibe la variable consulta3, consultamos el detalle de solicitud presupuesto
   $sql = "select 
               spd.it_codigo as it_codigo2,
               spd.tipit_codigo as tipit_codigo2,
               i.it_descripcion as it_descripcion2,
               spd.solpredet_cantidad,
               ti.tipit_descripcion as tipit_descripcion2,
               um.unime_codigo as unime_codigo2,
               um.unime_descripcion as unime_descripcion2
            from solicitud_presupuesto_det spd 
               join items i on i.it_codigo=spd.it_codigo 
               and i.tipit_codigo=spd.tipit_codigo 
                  join tipo_item ti on ti.tipit_codigo=i.tipit_codigo 
                  join unidad_medida um on um.unime_codigo=i.unime_codigo 
            where spd.solpre_codigo={$_POST['solpre_codigo']}
            order by spd.solpre_codigo, spd.it_codigo;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);

} else if (isset($_POST['consulta4'])) {

   // Definimos y cargamos las variables
   $solpredet_cantidad = str_replace(",", ".", $_POST['solpredet_cantidad']);

   $sql = "select sp_solicitud_presupuesto_det(
      {$_POST['solpre_codigo']}, 
      {$_POST['pedco_codigo2']}, 
      {$_POST['pro_codigo']}, 
      {$_POST['tipro_codigo']}, 
      {$_POST['it_codigo2']}, 
      {$_POST['tipit_codigo2']}, 
      $solpredet_cantidad, 
      {$_POST['operacion_detalle2']}
      )";

   //ejecutamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "item") !== false) {
      $response = array(
         "mensaje" => "YA SE REGISTRO EL ITEM",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else {

   //Si el post no recibe ninguna variable realizamos una consulta
   $sql = "select 
               spc.solpre_codigo,
               spc.solpre_fecha,
               spc.pedco_codigo as pedco_codigo2,
               spc.pro_codigo,
               spc.tipro_codigo,
               p.pro_razonsocial,
               p.pro_email as solpre_correo_proveedor,
               u.usu_login as usu_login2,
               s.suc_descripcion as suc_descripcion2,
               e.emp_razonsocial as emp_razonsocial2
            from solicitud_presupuesto_cab spc 
               join pedido_compra_cab pcc on pcc.pedco_codigo=spc.pedco_codigo 
               join proveedor p on p.pro_codigo=spc.pro_codigo
               and p.tipro_codigo=spc.tipro_codigo 
               join usuario u on u.usu_codigo=spc.usu_codigo 
               join sucursal s on s.suc_codigo=spc.suc_codigo 
               and s.emp_codigo=spc.emp_codigo 
                  join empresa e on e.emp_codigo=s.emp_codigo 
            where pcc.pedco_estado = 'PENDIENTE'
            order by spc.solpre_codigo;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);

}

?>