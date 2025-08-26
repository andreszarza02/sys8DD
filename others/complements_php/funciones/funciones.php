<?php

//Formatea a factura un numero
function formatearNumeroFactura($numero)
{
   // forzamos a que el valor sea una cadena
   $numeroFactura = (string) $numero;

   // Sacamos por parte el numero de factura
   $parte1 = substr($numeroFactura, 0, 3); // Primeros 3 caracteres
   $parte2 = substr($numeroFactura, 3, 3); // Siguientes 3 caracteres
   $parte3 = substr($numeroFactura, 6);     // Resto de la cadena

   // Combina las partes y devolvemos
   return $parte1 . '-' . $parte2 . '-' . $parte3;
}

//Genera 6 valores aleatorios
function generar6DigitosAleatorios()
{
   // Genera un número entre 100000 y 999999
   $numero = random_int(100000, 999999);
   return $numero;
}

//Obtiene la configuraciones aplicada a una sucursal
function obtenerConfiguraciones($conexion, $sucursal, $empresa, $codigoConfiguracion = null)
{
   //Definimos la consulta SQL general para listar todas las configuraciones
   $sql = "select 
               c.config_codigo,
               c.config_validacion 
           from configuraciones_sucursal cs 
               join configuraciones c on c.config_codigo=cs.config_codigo 
               join sucursal s on s.suc_codigo=cs.suc_codigo
               and s.emp_codigo=cs.emp_codigo 
           where cs.suc_codigo=$sucursal
               and cs.emp_codigo=$empresa
               and cs.configsuc_estado='ACTIVO'";

   //Validamos si se recibe un codigo de configuracion en especifico
   if ($codigoConfiguracion == null) {
      //En caso de que no, procedemos trayendo todas las configuraciones
      $resultado = pg_query($conexion, $sql);
      $datos = pg_fetch_all($resultado);
   } else {
      //En caso de que si, procedemos trayendo la configuracion en especifico
      $sql .= " and c.config_codigo=$codigoConfiguracion";
      $resultado = pg_query($conexion, $sql);
      $datos = pg_fetch_assoc($resultado);
   }

   //Retornamos un array asociativo o un array de arrays asociativos
   return $datos;
}

//Obtiene el pais, region y ciudad a partir de una ip
function obtenerDatosIP($ip)
{
   // API que devuelve datos en JSON
   $url = "https://ipwhois.app/json/$ip?lang=es";

   //Obtenemos los datos de la API
   $respuesta = file_get_contents($url);

   //Convertimos la respuesta JSON en un array asociativo
   $datos = json_decode($respuesta, true);

   //Validamos que se hayan obtenido datos
   if ($datos && isset($datos['country'])) {
      //Devuelve un array normal con los datos
      return [$datos['country'], $datos['region'], $datos['city']]; // Devuelve datos asociados a la IP
   } else {
      return "DATOS DE IP NO ENCONTRADOS";
   }
}

?>