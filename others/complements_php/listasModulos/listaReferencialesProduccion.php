<?php
//Salida formato json
header("Content-type: application/json; charset=utf-8");
//Array de tablas
$tablas = [
   array('tablas' => "CARGO"),
   array('tablas' => "PERSONAS"),
   array('tablas' => "FUNCIONARIO"),
   array('tablas' => "TALLE "),
   array('tablas' => "COLOR PRENDA"),
   array('tablas' => "MODELO"),
   array('tablas' => "MAQUINARIA"),
   array('tablas' => "TIPO ETAPA PRODUCION"),
   array('tablas' => "UNIDAD MEDIDA"),
   array('tablas' => "PARAMETRO CONTROL CALIDAD"),
   array('tablas' => "COSTO SERVICIO"),
   array('tablas' => "SECCION"),
   array('tablas' => "EQUIPO TRABAJO"),
];
//Array en un formato de json string
echo json_encode($tablas);
?>