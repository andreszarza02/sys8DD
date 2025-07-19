<?php

//Salida formato json
header("Content-type: application/json; charset=utf-8");

//Array de tablas
$tablas = [
   array('tablas' => "CIUDAD"),
   array('tablas' => "EMPRESA"),
   array('tablas' => "SUCURSAL"),
   array('tablas' => "TIPO IMPUESTO"),
   array('tablas' => "TIPO PROVEEDOR"),
   array('tablas' => "TIPO ITEM"),
   array('tablas' => "PROVEEDOR"),
   array('tablas' => "DEPOSITO"),
   array('tablas' => "ITEMS"),
];

//Array en un formato de json string
echo json_encode($tablas);

?>