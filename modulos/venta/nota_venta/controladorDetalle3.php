<?php
//Retorno JSON
header("Content-type: application/json; charset=utf-8");
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$consulta = $_POST['consulta'];

if ($consulta == '1') {
   //Variables de nota venta detalle credito
   $cantidadValidacion = $_POST['notvendet_cantidad'];
   $precioValidacion = $_POST['notvendet_precio'];
   $totalValidacion = intval($cantidadValidacion) * floatval($precioValidacion);

   $sql = "select cuenco_montototal from cuenta_cobrar where ven_codigo={$_POST['ven_codigo']};";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);

   if (
      ($totalValidacion > floatval($datos['cuenco_montototal']))
   ) {
      $response = ['mensaje' => 'EL MONTO DEL DETALLE ES MAYOR AL MONTO DE LA CUENTA A COBRAR', 'tipo' => 'error'];
   } else {
      $response = ['mensaje' => 'EL MONTO DEL DETALLE NO ES MAYOR', 'tipo' => 'success'];
   }

   echo json_encode($response);
}

// if (($consulta == '2') && ($_POST['tipco_codigo'] == '1')) {

//    $cantidadValidacion2 = $_POST['notvendet_cantidad'];
//    $precioValidacion2 = $_POST['notvendet_precio'];
//    $totalValidacion2 = intval($cantidadValidacion2) * floatval($precioValidacion2);
//    $response2 = ['mensaje' => 'EL MONTO DEL DETALLE NO ES MAYOR', 'tipo' => 'success'];

//    $sql2 = "select cuenco_montosaldo from cuenta_cobrar where ven_codigo={$_POST['ven_codigo']};";

//    $resultado2 = pg_query($conexion, $sql2);
//    $datos2 = pg_fetch_assoc($resultado2);
//    $saldoCuenta = floatval($datos2['cuenco_montosaldo']);

//    if ($saldoCuenta > '0') {
//       if ($totalValidacion2 > $saldoCuenta) {
//          $response2 = ['mensaje' => 'EL MONTO DEL DETALLE ES MAYOR AL MONTO DE LA CUENTA A COBRAR', 'tipo' => 'error'];
//       }
//    } else if ($saldoCuenta <= '0') {
//       //Realizar la suma y comparar con la columna monto total
//       $sql3 = "select cuenco_montototal from cuenta_cobrar where ven_codigo={$_POST['ven_codigo']};";

//       $resultado3 = pg_query($conexion, $sql3);
//       $datos3 = pg_fetch_assoc($resultado3);
//       $saldoTotal = floatval($datos2['cuenco_montototal']);

//       if ($totalValidacion2 > $saldoTotal) {
//          $response2 = ['mensaje' => 'EL MONTO DEL DETALLE ES MAYOR AL MONTO DE LA CUENTA A COBRAR', 'tipo' => 'error'];
//       }
//    }

//    echo json_encode($response2);

// }

?>