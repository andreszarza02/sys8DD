<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Establecemos el array asociativo con las condiciones de pago
$datos = [['orcom_condicionpago' => 'CONTADO'], ['orcom_condicionpago' => 'CREDITO']];

//Convertimos el array a un formato JSON
echo json_encode($datos);

?>