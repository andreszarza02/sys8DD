<?php

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

function generar6DigitosAleatorios()
{
   // Genera un número entre 100000 y 999999
   $numero = random_int(100000, 999999);
   return $numero;
}

?>