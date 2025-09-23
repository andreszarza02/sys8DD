<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$codigo = $_POST['apercie_codigo'];

$sql3 = "select 
            ac.apercie_codigo,
            ac.caj_codigo,
            c.caj_descripcion,
            ac.apercie_estado
         from 
            apertura_cierre ac 
            join caja c on c.caj_codigo=ac.caj_codigo 
            where ac.apercie_codigo = $codigo";

$result3 = pg_query($conexion, $sql3);

$dato3 = pg_fetch_assoc($result3);

// Validamos si el dato existe
if (empty($dato3['apercie_codigo'])) {
   // Si no existe el dato enviamos respuesta 0
   $dato3 = [];
   $dato3 = ["respuesta" => "0"];
} else if ($dato3['apercie_estado'] == "CERRADO") {
   // Si la caja se encuentra cerrada enviamos respuesta 0
   $dato3 = [];
   $dato3 = ["respuesta" => "0"];
}// Si esta abierta, enviamos los datos de la apertura

echo json_encode($dato3);

