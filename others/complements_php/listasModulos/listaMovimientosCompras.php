<?php
//Salida formato json
header("Content-type: application/json; charset=utf-8");
//Array de tablas
$tablas = [
   array('tablas' => "PRESUPUESTO PROVEEDOR", 'codigo_informe' => '1'),
   array('tablas' => "LIBRO COMPRA", 'codigo_informe' => '2'),
   array('tablas' => "CUENTA PAGAR", 'codigo_informe' => '3'),
];
//Array en un formato de json string
echo json_encode($tablas);
?>