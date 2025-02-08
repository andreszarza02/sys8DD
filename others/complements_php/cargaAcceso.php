<?php
//importamos la clase conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//guardamos las varibales recibidas
$usuario = $_POST['usuario'];
$fecha = $_POST['fecha'];
$hora = $_POST['hora'];
$observacion = $_POST['observacion'];

//css/style.css/7565
//creamos la sentencia 
$sql = "INSERT INTO acceso(acc_codigo, acc_usuario, acc_fecha, acc_hora, acc_obs)
VALUES((SELECT coalesce(max(acc_codigo),0)+1 FROM acceso a), '$usuario', '$fecha', '$hora', '$observacion');";

//Consultamos a la base de datos
pg_query($conexion, $sql);

?>