<?php

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Incluimos el archivo de funciones
include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/funciones/funciones.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//guardamos las varibales recibidas
$usuario = $_POST['usuario'];
$fecha = $_POST['fecha'];
$hora = $_POST['hora'];
$observacion = $_POST['observacion'];

//Obtenemos la ip publica de la pc, al consultar el mismo a una api externa, por internet
$ip = file_get_contents('https://api.ipify.org');

//llamamos a la funcion que obtiene los datos de la ip
$datosIp = obtenerDatosIP($ip);

//Guardamos los datos obtenidos en variables, pasamos de un array a variables
list($pais, $region, $ciudad) = $datosIp;

//creamos la sentencia 
$sql = "INSERT INTO acceso(acc_codigo, acc_usuario, acc_fecha, acc_hora, acc_obs, acc_ip, acc_ip_pais, acc_ip_region, acc_ip_ciudad)
VALUES((SELECT coalesce(max(acc_codigo),0)+1 FROM acceso a), '$usuario', '$fecha', '$hora', '$observacion', '$ip', '$pais', '$region', '$ciudad');";

//Consultamos a la base de datos
pg_query($conexion, $sql);

?>