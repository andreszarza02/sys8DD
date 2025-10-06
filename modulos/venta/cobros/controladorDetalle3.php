<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$consulta = $_POST['consulta'] ?? 0;

//Sirve para aumentar el numero de la cuota
if ($consulta == '2') {

   //Recibimos y definimos las variables
   $ven_codigo = $_POST['ven_codigo'];

   //Consultamos el maximo codigo de cobro registrado en detalle asociado a una venta especifica
   $sql = "select distinct 
               coalesce(max(cc.cob_codigo),0) as cob_codigo 
            from cobro_cab cc
            where cc.ven_codigo = $ven_codigo 
            and cc.cob_estado='ACTIVO'";

   $result = pg_query($conexion, $sql);

   $dato = pg_fetch_assoc($result);

   $cobro_codigo = $dato['cob_codigo'];

   //Validamos si el numero de cobro consultado es menor al codigo de cobro pasado por parametro
   if ((int) $cobro_codigo < (int) $_POST['cob_codigo']) {

      //En caso de ser asi, queire decir que el cobro es nuevo, por lo que se debe obtener el maximo numero de cuota
      $sql2 = "select distinct 
                  coalesce(max(cc.cob_numerocuota),0)+1 as cob_numerocuota 
               from cobro_cab cc 
               where cc.ven_codigo = $ven_codigo 
               and cc.cob_estado='ACTIVO'";

      $result2 = pg_query($conexion, $sql2);

      $dato2 = pg_fetch_assoc($result2);

   }

   echo json_encode($dato2);

}

// Verificar si se usa

//Permite obtener el monto total, para no sobrepasar el monto cuota
// if ($consulta == '3') {

//    //Recibimos y definimos las variables
//    $ven_codigo = $_POST['ven_codigo'];
//    $cob_codigo = $_POST['cob_codigo'];

//    //calculamos el total por cobro y venta
//    $sql = "select 
//                coalesce(sum(cd.cobdet_monto), 0) as totalcobro 
//             from cobro_det cd 
//             where cd.ven_codigo=$ven_codigo 
//             and cd.cob_codigo=$cob_codigo";

//    $result = pg_query($conexion, $sql);

//    $dato = pg_fetch_assoc($result);

//    //El utlimo parametro convierte strings a enteros o decimales, para evitar problemas de formato en el json
//    echo json_encode($dato, JSON_NUMERIC_CHECK);

// }

// Verificar si se usa

//Evalua si la venta ya se pago en su totalidad
// if ($consulta == '4') {

//    //Recibimos y definimos las variables
//    $ven_codigo = $_POST['ven_codigo'];

//    //calculamos el total por venta
//    $sql = "select    
//                coalesce(sum(cd.cobdet_monto), 0) as montoventa 
//           from cobro_det cd 
//           join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
//           where cc.cob_estado='ACTIVO' and
//           cc.ven_codigo = $ven_codigo";

//    $result = pg_query($conexion, $sql);

//    $dato = pg_fetch_assoc($result);

//    echo json_encode($dato, JSON_NUMERIC_CHECK);

// }

// Verificar si se usa

//Actualiza el estado de la cuenta cobrar una vez la venta fue cancelada en su totalidad
// if ($consulta == '5') {

//    //Recibimos y definimos las variables  
//    $ven_codigo = $_POST['ven_codigo'];
//    $usu_codigo = $_POST['usu_codigo'];

//    //Actualizamos el estado de la cuentas
//    $sql = "update cuenta_cobrar  
//            set cuenco_estado = 'CANCELADO', 
//            tipco_codigo = 5    
//            where ven_codigo = $ven_codigo;
//            update venta_cab 
//            set ven_estado = 'CANCELADO',
//            usu_codigo = $usu_codigo 
//            where ven_codigo = $ven_codigo;";

//    $result = pg_query($conexion, $sql);

// }

?>