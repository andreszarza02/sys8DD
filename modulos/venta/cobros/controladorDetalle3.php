<?php
//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$consulta = $_POST['consulta'];

//Sirve para aumentar el numero de la cuota
if ($consulta == '2') {

   //guardamos los parametros recibidos
   $ven_codigo = $_POST['ven_codigo'];
   $cob_codigo = $_POST['cob_codigo'];

   $sql = "select coalesce(max(cd.cob_codigo),0) as cob_codigo from cobro_det cd join cobro_cab cc on cc.cob_codigo=cd.cob_codigo
   where ven_codigo = $ven_codigo and cc.cob_estado='ACTIVO'";

   $result = pg_query($conexion, $sql);

   $dato = pg_fetch_assoc($result);

   $cobro_codigo = $dato['cob_codigo'];

   if ($cobro_codigo < $_POST['cob_codigo']) {
      $sql2 = "select coalesce(max(cd.cobdet_numerocuota),0)+1 as cobdet_numerocuota from cobro_det cd join cobro_cab cc on cc.cob_codigo=cd.cob_codigo where ven_codigo = $ven_codigo and cc.cob_estado='ACTIVO'";
      $result2 = pg_query($conexion, $sql2);
      $dato2 = pg_fetch_assoc($result2);
   } else if
   ($cobro_codigo == $_POST['cob_codigo']) {
      $sql2 = "select max(cd.cobdet_numerocuota) as cobdet_numerocuota from cobro_det cd join cobro_cab cc on cc.cob_codigo=cd.cob_codigo where ven_codigo = $ven_codigo and cd.cob_codigo = $cob_codigo and cc.cob_estado='ACTIVO'"
      ;
      $result2 = pg_query($conexion, $sql2);
      $dato2 = pg_fetch_assoc($result2);
   }
   echo json_encode($dato2);

}

//Permite obtener el monto total, para no sobrepasar el monto cuota
if ($consulta == '3') {

   //guardamos los parametros recibidos
   $ven_codigo = $_POST['ven_codigo'];
   $cob_codigo = $_POST['cob_codigo'];

   //calculamos el total por cobro y venta
   $sql = "select coalesce(sum(cd.cobdet_monto), 0) as totalventa from cobro_det cd where cd.ven_codigo=$ven_codigo and cd.cob_codigo=$cob_codigo";

   $result = pg_query($conexion, $sql);

   $dato = pg_fetch_assoc($result);

   echo json_encode($dato, JSON_NUMERIC_CHECK);

}

//Evalua el si la venta ya se pago en su totalidad
if ($consulta == '4') {

   //guardamos los parametros recibidos
   $ven_codigo = $_POST['ven_codigo'];

   //calculamos el total por venta
   $sql = "select coalesce(sum(cd.cobdet_monto), 0) as montoventa from cobro_det cd where cd.ven_codigo = $ven_codigo";

   $result = pg_query($conexion, $sql);

   $dato = pg_fetch_assoc($result);

   echo json_encode($dato, JSON_NUMERIC_CHECK);

}

//Actualiza el estado de la cuenta cobrar una vez la venta fue cancelada en su totalidad
if ($consulta == '5') {

   //guardamos los parametros recibidos
   $ven_codigo = $_POST['ven_codigo'];

   //Actualizamos el estado de la cuentas
   $sql = "update cuenta_cobrar set cuenco_estado = 'CANCELADO' where ven_codigo = $ven_codigo;
   update venta_cab set ven_estado = 'CANCELADO' where ven_codigo = $ven_codigo;";

   $result = pg_query($conexion, $sql);

}

?>