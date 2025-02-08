<?php
//Salida formato json
header("Content-type: application/json; charset=utf-8");
//Array de tablas
$tablas = [
   array('tablas' => "PEDIDO COMPRA"),
   array('tablas' => "PRESUPUESTO PROVEEDOR"),
   array('tablas' => "ORDEN COMPRA"),
   array('tablas' => "COMPRA"),
   array('tablas' => "AJUSTE INVENTARIO"),
   array('tablas' => "NOTA COMPRA"),
   array('tablas' => "CUENTA PAGAR"),
   array('tablas' => "LIBRO COMPRA"),
   array('tablas' => "STOCK")
];
//Array en un formato de json string
echo json_encode($tablas);
?>