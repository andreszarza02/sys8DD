<?php
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$usuLogin = $_POST['usu_login'];
$usu_login = str_replace(search: "'", replace: "''", subject: $usuLogin);

$tipcoDescripcion = $_POST['tipco_descripcion'];
$tipco_descripcion = pg_escape_string($conexion, $tipcoDescripcion);

$consulta = $_POST['consulta'];
$impuestos = ["nada", "libven_iva5", "libven_iva10", "libven_exenta"];

if ($consulta == '1') {

   //Definimos y cargamos las variables
   $cantidad = floatval($_POST['compdet_cantidad']);
   $precio = floatval($_POST['compdet_precio']);

   //Si el tipo de item es servicio, la cantidad es 1
   if ($_POST['tipit_codigo'] == 3) {
      $cantidad = 1;
   }

   $tipoImpuesto = $_POST['tipim_codigo'];

   $Libro = $cantidad * $precio;
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
   $sql = "select sp_libro_compra(
      {$_POST['comp_codigo']}, 
      $totalExenta, 
      $total5, 
      $total10, 
      {$_POST['tipco_codigo']},
      '$tipco_descripcion',
      '{$_POST['com_numfactura']}',
      {$_POST['operacion_detalle']},
      {$_POST['usu_codigo']},
      '$usu_login'
      )";

   //ejecutamos la actualizacion
   pg_query($conexion, $sql);

}

if ($consulta == '2') {

   //Definimos y cargamos las variables
   $cantidad = floatval($_POST['compdet_cantidad']);
   $precio = floatval($_POST['compdet_precio']);

   //Si el tipo de item es servicio, la cantidad es 1
   if ($_POST['tipit_codigo'] == 3) {
      $cantidad = 1;
   }

   $cuenta = $cantidad * $precio;
   $totalCuenta = str_replace(",", ".", $cuenta);


   //Cargamos el procedimiento almacenado
   $sql = "select sp_cuenta_pagar(
      {$_POST['comp_codigo']}, 
      $totalCuenta, 
      $totalCuenta,
      {$_POST['operacion_detalle']},
      {$_POST['usu_codigo']},
      '$usu_login'
      )";

   //ejecutamos la actualizacion
   pg_query($conexion, $sql);
}

?>