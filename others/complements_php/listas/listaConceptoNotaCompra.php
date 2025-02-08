<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Recibimos y definimos la variable
$concepto = $_POST['nocom_concepto'];

//Establecemos el array asociativo con la lista de conceptos
$conceptos = [
   ['nocom_concepto' => 'DEVOLUCION'],
   ['nocom_concepto' => 'DESCUENTO'],
   ['nocom_concepto' => 'REGISTRO'],
   ['nocom_concepto' => 'ITEM EXTRA'],
   ['nocom_concepto' => 'SERVICIO EXTRA'],
   ['nocom_concepto' => 'CAMBIO']
];

//Filtramos el array asociativo anterior para buscar lo que se pasa por parametro-
$resultado = array_filter($conceptos, function ($elemento) use ($concepto) {
   return stripos($elemento['nocom_concepto'], $concepto) !== false;
});

//Definimos un array vacio
$resultado_asociativo = [];

//Iteramos sobre el resultado y el valor lo guardamos dentro del array anterior definido
foreach ($resultado as $elemento) {
   $resultado_asociativo[$elemento['nocom_concepto']] = $elemento;
}

//Validamos el array consultando si esta vacio o no
if (empty($resultado_asociativo)) {
   //Si esta vacio enviamos un 
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
   echo json_encode($datos);

} else {
   //Si no esta vacio  mostramos lo buscado
   echo json_encode(array_values($resultado_asociativo));
}



?>