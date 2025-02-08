<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Establecemos el array asociativo con la lista de conceptos
$datos = [['notven_concepto' => 'DEVOLUCION'], ['notven_concepto' => 'INTERCAMBIO']];

//Convertimos el array a un formato JSON
echo json_encode($datos);
?>