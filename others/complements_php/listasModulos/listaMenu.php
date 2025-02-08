<?php

//Llamamos a la variable de sesion
session_start();

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Guardamos la descripcion del perfil y la descripcion del input para validar la consulta
$modulo = $_SESSION['usuario']['modu_descripcion'];
$codigoPerfil = $_SESSION['usuario']['perf_codigo'];
$descripcion = $_POST['busquedaMenu'];

//De acuerdo al perfil realizamos la consulta
if ($modulo == 'SISTEMA') {

   //Si tiene el perfil de sistemas consultamos las referenciales
   $sql = "select 
               vgr.gui_referencial as gui,
               vgr.gui_link as link
            from v_gui_referenciales vgr 
            where vgr.gui_referencial <> 'NER'
            and vgr.gui_referencial ilike '%$descripcion%';";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

} else {

   //Si tiene eun perfil distinto a sistemas consultamos los guis de movimiento
   $sql = "select 
            vgm.gui_movimiento as gui,
            vgm.gui_link as link
         from v_gui_movimiento vgm 
         where vgm.perf_codigo = $codigoPerfil
         and vgm.gui_movimiento ilike '%$descripcion%';";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

}

//Enviamos un mensaje en caso de que la consulta nos devuelva null
if (!isset($datos[0]['gui'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO TIENE PERMISO PARA ACCEDER A LA INTERFAZ O NO EXISTE LA MISMA']];
}

echo json_encode($datos);

?>