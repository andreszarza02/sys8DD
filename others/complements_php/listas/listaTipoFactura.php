<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Establecemos el array asociativo con lOS tipos de factura
$datos = [['ven_tipofactura' => 'CONTADO'], ['ven_tipofactura' => 'CREDITO']];

//Convertimos el array a un formato JSON
echo json_encode($datos);
?>