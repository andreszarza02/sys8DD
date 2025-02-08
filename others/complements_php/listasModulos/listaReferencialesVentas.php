<?php
//Salida formato json
header("Content-type: application/json; charset=utf-8");
//Array de tablas
$tablas = [
   array('tablas' => "TIPO DOCUMENTO"),
   array('tablas' => "TIPO COMPROBANTE"),
   array('tablas' => "FORMA COBRO"),
   array('tablas' => "MARCA TARJETA"),
   array('tablas' => "ENTIDAD EMISORA"),
   array('tablas' => "ENTIDAD ADHERIDA"),
   array('tablas' => "CAJA"),
   array('tablas' => "CLIENTES")
];
//Array en un formato de json string
echo json_encode($tablas);
?>