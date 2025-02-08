<?php

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Definimos las variables
$usu_login = pg_escape_string($conexion, $_POST['usu_login']);

$tipco_descripcion = pg_escape_string($conexion, $_POST['tipco_descripcion']);

$nocom_numeronota = pg_escape_string($conexion, $_POST['nocom_numeronota']);

$tipco_codigo = $_POST['tipco_codigo'];

$tipim_codigo = $_POST['tipim_codigo'];

$consulta = $_POST['consulta'];

$total10 = 0;
$total5 = 0;
$totalExenta = 0;

//Calculamos lo que vamos a pasar a los respectivos sp
$cantidad = floatval($_POST['nocomdet_cantidad']);
$precio = floatval($_POST['nocomdet_precio']);

$totalConComa = $cantidad * $precio;

$totalSinComa = str_replace(",", ".", $totalConComa);

//Consulamos el tipo de comprobante si es negativo convertimos el monto a negativo
if ($tipco_codigo == 1) {
   $totalSinComa = $totalSinComa * -1;
}

//Validamos el tipo de impuesto, en base al enviamos el monto a la columna cuyo impuesto le pertence
if ($tipim_codigo == 1) {
   $total5 = $totalSinComa;
} else if ($tipim_codigo == 2) {
   $total10 = $totalSinComa;
} else {
   $totalExenta = $totalSinComa;
}

if ($tipco_codigo == 1 or $tipco_codigo == 2) {

   //Si consulta es 1 ejecutamos el sp de libro comra
   if ($consulta == '1') {

      //Cargamos el procedimiento almacenado
      $sql = "select sp_libro_compra(
         {$_POST['comp_codigo']}, 
         $totalExenta, 
         $total5, 
         $total10, 
         $tipco_codigo,
         '$tipco_descripcion',
         '$nocom_numeronota',
         {$_POST['operacion_detalle']},
         {$_POST['usu_codigo']},
         '$usu_login'
         )";

      //ejecutamos la actualizacion
      pg_query($conexion, $sql);

   }

   //Si consulta es 2 ejecutamos el sp de cuenta pagar
   if ($consulta == '2') {

      //Cargamos el procedimiento almacenado
      $sql = "select sp_cuenta_pagar(
         {$_POST['comp_codigo']}, 
         $totalSinComa, 
         $totalSinComa,
         {$_POST['operacion_detalle']},
         {$_POST['usu_codigo']},
         '$usu_login'
         )";

      //ejecutamos la actualizacion
      pg_query($conexion, $sql);
   }
}

?>