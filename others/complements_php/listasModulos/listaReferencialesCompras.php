<?php

//Salida formato json
header("Content-type: application/json; charset=utf-8");

//Array de tablas
$tablas = [
   array('tablas' => "PROVEEDOR", 'codigo_informe' => '1'),
   array('tablas' => "SUCURSAL", 'codigo_informe' => '2'),
   array('tablas' => "ITEMS", 'codigo_informe' => '3'),
];

//Array en un formato de json string
echo json_encode($tablas);

?>