<?php
//Habilitamos las variables de sesión
session_start();
header('Content-type: application/json; charset=utf-8');

//importamos la clase Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$usuario = $_POST['usu_login'];
$contrasenia = $_POST['usu_contrasenia'];

$sql = "select 
	u.*,
	p.per_nombre,
	p.per_apellido,
	p.per_email,
	p2.perf_descripcion,
	su.suc_descripcion,
	su.suc_codigo,
	e.emp_codigo,
	e.emp_razonsocial,
	m.modu_descripcion
from usuario u 
	join funcionario f on f.func_codigo = u.func_codigo
	join personas p on p.per_codigo = f.per_codigo
	join sucursal su on su.suc_codigo = f.suc_codigo
	join empresa e on su.emp_codigo=e.emp_codigo
	join modulo m on m.modu_codigo = u.modu_codigo
	join perfil p2 on p2.perf_codigo = u.perf_codigo
where u.usu_login = '$usuario' and u.usu_contrasenia = md5('$contrasenia')";

//Consultamos a la base de datos
$resultado = pg_query($conexion, $sql);

//Convertimos el resultado de la base de datos en un array asociativo
$datos = pg_fetch_assoc($resultado);

if (!(!$datos)) {
   //Establecemos la variable de sesión
   $_SESSION['usuario'] = $datos;
}

//Convertimos el array asociativo en un json
echo json_encode($datos);
?>