<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Establecemos el array asociativo con lOS tipos de factura
$datos = [['cobta_tipotarjeta' => 'CREDITO'], ['cobta_tipotarjeta' => 'DEBITO']];

//Convertimos el array a un formato JSON
echo json_encode($datos);

?>