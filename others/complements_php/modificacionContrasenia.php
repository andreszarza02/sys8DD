<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Definimos las variables
$usuario = $_POST['usu_login'];
$contrasenia = pg_escape_string($conexion, $_POST['contrasenia']);

//Pasamos los parametros para actaulizar la contraseña
$sql = "update usuario set usu_contrasenia = md5('$contrasenia') where usu_login = '$usuario';";

//Ejecutamos la consulta
$resultado = pg_query($conexion, $sql);

//Sacamos el codigo idenificador de la clave utilizada para actualizar la contraseña
$sql2 = "select 
            ac.accontra_codigo
         from actualizacion_contrasenia ac 
            where ac.accontra_usuario ilike '%$usuario%' 
         order by ac.accontra_codigo desc 
         limit 1;";

//Ejecutamos la consulta
$resultado2 = pg_query($conexion, $sql2);
$datosActualizacion = pg_fetch_assoc($resultado2);

//Cargamos la tabla actualizacion contrasenia con el dato de actualizacion de contraseña
$sql3 = "update actualizacion_contrasenia
        set 
         accontra_observacion='EL USUARIO ACTUALIZO LA CONTRASEÑA'
        where accontra_codigo={$datosActualizacion['accontra_codigo']};";

//Ejecutamos la consulta
$resultado3 = pg_query($conexion, $sql3);

//Establecemos la respuesta
$response = array(
   "mensaje" => "actualizado",
   "estado" => "LA CONTRASEÑA SE ACTUALIZO DE FORMA CORRECTA"
);

echo json_encode($response);

?>