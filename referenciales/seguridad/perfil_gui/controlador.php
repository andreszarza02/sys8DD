<?php
//Retorno JSON
header("Content-type: application/json; charset=utf-8");
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Consultamos si existe la variable operacion
if (isset($_POST['operacion'])) {

   $estado = $_POST['perfgui_estado'];
   $perfgui_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $perfDescripcion = $_POST['perf_descripcion'];
   $perf_descripcion = str_replace("'", "''", $perfDescripcion);

   $guiDescripcion = $_POST['gui_descripcion'];
   $gui_descripcion = str_replace("'", "''", $guiDescripcion);

   $moduDescripcion = $_POST['modu_descripcion'];
   $modu_descripcion = str_replace("'", "''", $moduDescripcion);

   $sql = "select sp_perfil_gui(
   {$_POST['perfgui_codigo']}, 
   {$_POST['perf_codigo']}, 
   {$_POST['gui_codigo']}, 
   {$_POST['modu_codigo']},
   '$perfgui_estado',
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento2',
   '$perf_descripcion',
   '$gui_descripcion',
   '$modu_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA EXISTE EL PERFIL ASIGNADO CON EL GUI",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);


} else if (isset($_POST['consulta']) == 1) {

   //Consultamos y enviamos el ultimo codigo
   $sql = "select coalesce(max(perfgui_codigo),0)+1 as perfgui_codigo from perfil_gui;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {
   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
            pg.perfgui_codigo,
            pg.perf_codigo,
            pg.gui_codigo,
            pg.modu_codigo,
            pg.perfgui_estado,
            p.perf_descripcion,
            g.gui_descripcion,
            m.modu_descripcion
         from perfil_gui pg
            join perfil p on p.perf_codigo=pg.perf_codigo
            join gui g on g.gui_codigo=pg.gui_codigo 
            and g.modu_codigo=pg.modu_codigo
            join modulo m on m.modu_codigo=g.modu_codigo
            order by pg.perfgui_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>