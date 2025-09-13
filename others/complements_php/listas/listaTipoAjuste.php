<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Establecemos el array asociativo con lOS tipos de ajuste
$datos = [['ajus_tipoajuste' => 'POSITIVO'], ['ajus_tipoajuste' => 'NEGATIVO']];

//Convertimos el array a un formato JSON
echo json_encode($datos);

?>