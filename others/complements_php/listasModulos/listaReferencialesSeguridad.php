<?php
//Salida formato json
header("Content-type: application/json; charset=utf-8");
//Array de tablas
$tablas = [
   array('tablas' => "ACCESO"),
   array('tablas' => "USUARIOS"),
   array('tablas' => "ASIGNACIÓN DE PERMISOS"),
   array('tablas' => "MODULOS"),
   array('tablas' => "PERMISOS"),
   array('tablas' => "PERFILES"),
   array('tablas' => "GUI"),
   array('tablas' => "PERFIL PERMISOS"),
   array('tablas' => "PERFIL GUI"),
];
//Array en un formato de json string
echo json_encode($tablas);
?>