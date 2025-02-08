<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Creamos el array asociativo con los sexos
$sexo = [['mod_sexo' => 'M', 'sexo' => 'MASCULINO'], ['mod_sexo' => 'F', 'sexo' => 'FEMENINO']];

//Le damos formato JSON al array y mostramos
echo json_encode($sexo);
?>