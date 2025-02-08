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

   $estado = $_POST['entad_estado'];
   $entad_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $entRazonSocial = $_POST['ent_razonsocial'];
   $ent_razonsocial = str_replace("'", "''", $entRazonSocial);

   $martaDescripcion = $_POST['marta_descripcion'];
   $marta_descripcion = str_replace("'", "''", $martaDescripcion);

   $sql = "select sp_entidad_adherida(
   {$_POST['entad_codigo']}, 
   {$_POST['ent_codigo']}, 
   {$_POST['marta_codigo']},
   '$entad_estado',
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento2',
   '$ent_razonsocial',
   '$marta_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA EXISTE LA ENTIDAD ADHERIDA",
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
   $sql = "select coalesce(max(entad_codigo),0)+1 as entad_codigo from entidad_adherida;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {
   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               ea.entad_codigo,
               ea.ent_codigo,
               ea.marta_codigo,
               ea.entad_estado,
               ee.ent_razonsocial,
               mt.marta_descripcion 
         from entidad_adherida ea
               join entidad_emisora ee on ee.ent_codigo=ea.entad_codigo
               join marca_tarjeta mt on mt.marta_codigo=ea.marta_codigo
         order by ea.entad_codigo";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>