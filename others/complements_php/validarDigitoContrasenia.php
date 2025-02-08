<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Definimos las variables
$usuario = $_POST['usu_login'];
$clave = $_POST['usu_clave'];
$intento = 0;

//Consultamos la clave mas reciente generada por el usuario
$sql = "select 
            ac.accontra_codigo,
            ac.accontra_clave, 
            ac.accontra_intentos
         from actualizacion_contrasenia ac 
            where ac.accontra_usuario ilike '%$usuario%' 
         order by ac.accontra_codigo desc 
         limit 1;";

//Ejecutamos la consulta
$resultado = pg_query($conexion, $sql);
$datosVerificacion = pg_fetch_assoc($resultado);

//Cargamos la cantidad de intentos
$intento = intval($datosVerificacion['accontra_intentos']) + 1;

//Validamos que los intentos nunca pasen de 3
if ($intento < 4) {

   if ($clave == $datosVerificacion['accontra_clave']) {

      //Cargamos la tabla actualizacion contrasenia con el dato de intento de sesion
      $sql = "update actualizacion_contrasenia
           set 
            accontra_observacion='INGRESO LA CLAVE DE FORMA CORRECTA', 
            accontra_intentos=$intento
           where accontra_codigo={$datosVerificacion['accontra_codigo']};";

      //Ejecutamos la consulta
      $resultado = pg_query($conexion, $sql);

      $response = array(
         "mensaje" => "cambiar"
      );

   } else {

      //Cargamos la tabla actualizacion contrasenia con el dato de intento de sesion
      $sql = "update actualizacion_contrasenia
           set 
            accontra_observacion='NO INGRESO LA CLAVE CORRECTA', 
            accontra_intentos=$intento
           where accontra_codigo={$datosVerificacion['accontra_codigo']};";

      //Ejecutamos la consulta
      $resultado = pg_query($conexion, $sql);

      $response = array(
         "mensaje" => "no_cambiar"
      );

   }
} else {

   $response = array(
      "mensaje" => "volver"
   );

}

echo json_encode($response);

?>