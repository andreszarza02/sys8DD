<?php

function obtenerPaisPorIP($ip)
{
   $url = "https://ipwhois.app/json/$ip?lang=es";  // API que devuelve datos en JSON
   $respuesta = file_get_contents($url);
   $datos = json_decode($respuesta, true);
   if ($datos && isset($datos['country'])) {
      return [$datos['country'], $datos['region'], $datos['city']]; // Devuelve país asociado a la IP
   } else {
      return "País no encontrado";
   }
}

// Ejemplo de uso:
$ip = file_get_contents('https://api.ipify.org');  // IP del cliente
$datos = obtenerPaisPorIP($ip);

list($pais, $region, $ciudad) = $datos;
echo $pais;   // España
echo $region; // Cataluña
echo $ciudad; // Barcelona

?>