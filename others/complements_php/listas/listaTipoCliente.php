<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Creamos el array asociativo con los tipos de clientes
$tipoCliente = [['cli_tipocliente' => 'JURIDICA'], ['cli_tipocliente' => 'FISICA']];

//Le damos formato JSON al array y mostramos
echo json_encode($tipoCliente);
?>