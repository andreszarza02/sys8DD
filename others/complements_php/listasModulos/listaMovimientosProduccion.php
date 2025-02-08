<?php
//Salida formato json
header("Content-type: application/json; charset=utf-8");
//Array de tablas
$tablas = [
   array('tablas' => "PEDIDO PRODUCCION"),
   array('tablas' => "PRESUPUESTO"),
   array('tablas' => "ORDEN PRODUCCION"),
   array('tablas' => "PRODUCCION"),
   array('tablas' => "ETAPA PRODUCCION")
];
//Array en un formato de json string
echo json_encode($tablas);
?>