<?php

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$consulta = $_POST['consulta'];

if ($consulta == '1') {

   //Definimos y cargamos las variables
   $vendet_cantidad = intval($_POST['vendet_cantidad']);
   $vendet_precio = floatval($_POST['vendet_precio']);

   //Si el tipo de item es servicio, la cantidad es 1
   if ($_POST['tipit_codigo'] == 3) {
      $vendet_cantidad = 1;
   }

   $tipoImpuesto = $_POST['tipim_codigo'];

   $Libro = $vendet_cantidad * $vendet_precio;
   $totalLibro = str_replace(",", ".", $Libro);

   $total10 = 0;
   $total5 = 0;
   $totalExenta = 0;

   if ($tipoImpuesto == "1") {
      $total5 = $totalLibro;
   } else if ($tipoImpuesto == "2") {
      $total10 = $totalLibro;
   } else {
      $totalExenta = $totalLibro;
   }

   //Cargamos el procedimiento almacenado
   $sql = "select sp_libro_venta(
      {$_POST['ven_codigo']}, 
      $totalExenta, 
      $total5, 
      $total10, 
      '{$_POST['ven_numfactura']}',
      {$_POST['tipco_codigo']},
      {$_POST['operacion_detalle']}
      )";

   //ejecutamos la actualizacion
   pg_query($conexion, $sql);

}

if ($consulta == '2') {

   //Definimos y cargamos las variables
   $vendet_cantidad = intval($_POST['vendet_cantidad']);
   $vendet_precio = floatval($_POST['vendet_precio']);

   //Si el tipo de item es servicio, la cantidad es 1
   if ($_POST['tipit_codigo'] == 3) {
      $vendet_cantidad = 1;
   }

   $cuenta = $vendet_cantidad * $vendet_precio;
   $totalCuenta = str_replace(",", ".", $cuenta);

   //Cargamos el procedimiento almacenado
   $sql = "select sp_cuenta_cobrar(
      {$_POST['ven_codigo']}, 
      $totalCuenta, 
      $totalCuenta,
      {$_POST['tipco_codigo']},
      {$_POST['operacion_detalle']}
      )";

   //ejecutamos la actualizacion
   pg_query($conexion, $sql);

}

?>