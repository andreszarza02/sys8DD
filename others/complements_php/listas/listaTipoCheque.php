<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Establecemos el array asociativo con lOS tipos de factura
$datos = [['coche_tipocheque' => 'A LA VISTA'], ['coche_tipocheque' => 'DIFERIDO']];

//Convertimos el array a un formato JSON
echo json_encode($datos);

?>