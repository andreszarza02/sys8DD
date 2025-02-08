<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$usuario = $_POST['usu_login'];
$clave = $_POST['usu_clave'];
$intento = 0;

//Consultamos la clave mas reciente generada por el usuario
$sql = "select 
            ac.accon_codigo,
            ac.accon_clave, 
            ac.accon_intentos
         from acceso_control ac 
            where ac.accon_usuario ilike '%$usuario%' 
         order by ac.accon_codigo desc 
         limit 1;";

//Ejecutamos la consulta
$resultado = pg_query($conexion, $sql);
$datosVerificacion = pg_fetch_assoc($resultado);

$intento = intval($datosVerificacion['accon_intentos']) + 1;

if ($intento < 4) {

   if ($clave == $datosVerificacion['accon_clave']) {

      //Cargamos la tabla acceso control con el dato de intento de sesion
      $sql = "update acceso_control
           set 
            accon_observacion='INGRESO LA CLAVE DE FORMA CORRECTA', 
            accon_intentos=$intento
           where accon_codigo={$datosVerificacion['accon_codigo']};";

      //Ejecutamos la consulta
      $resultado = pg_query($conexion, $sql);

      $response = array(
         "mensaje" => "ingreso"
      );

   } else {

      //Cargamos la tabla acceso control con el dato de intento de sesion
      $sql = "update acceso_control
           set 
            accon_observacion='NO INGRESO LA CLAVE CORRECTA', 
            accon_intentos=$intento
           where accon_codigo={$datosVerificacion['accon_codigo']};";

      //Ejecutamos la consulta
      $resultado = pg_query($conexion, $sql);

      $response = array(
         "mensaje" => "no_ingreso"
      );

   }
} else {

   $response = array(
      "mensaje" => "volver"
   );

}

echo json_encode($response);

?>