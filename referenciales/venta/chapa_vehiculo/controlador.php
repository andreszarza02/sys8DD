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

   // Definimos y cargamos las variables
   $chave_chapa = pg_escape_string($conexion, $_POST['chave_chapa']);

   $chave_estado = pg_escape_string($conexion, $_POST['chave_estado']);

   $modve_descripcion = pg_escape_string($conexion, $_POST['modve_descripcion']);

   $marve_descripcion = pg_escape_string($conexion, $_POST['marve_descripcion']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $sql = "select sp_chapa_vehiculo(
   {$_POST['chave_codigo']}, 
   '$chave_chapa',
   {$_POST['modve_codigo']},
   {$_POST['marve_codigo']},
   '$chave_estado',
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento',
   '$modve_descripcion',
   '$marve_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "chapa") !== false) {
      $response = array(
         "mensaje" => "YA SE ENCUENTRA REGISTRADA LA CHAPA",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

   //Consulta,os si existe la variable consulta y si es igual a 1
} else if (isset($_POST['consulta']) == 1) {

   //Consultamos y enviamos el ultimo codigo
   $sql = "select coalesce(max(chave_codigo),0)+1 as chave_codigo from chapa_vehiculo; ";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
            cv.chave_codigo,
            cv.chave_chapa,
            cv.modve_codigo,
            cv.chave_estado,
            mv.modve_descripcion,
            mv2.marve_codigo,
            mv2.marve_descripcion,
            mv2.marve_descripcion||', '||'MODELO: '||mv.modve_descripcion as descripcion
         from chapa_vehiculo cv 
            join modelo_vehiculo mv on mv.modve_codigo=cv.modve_codigo 
            join marca_vehiculo mv2 on mv2.marve_codigo=mv.marve_codigo 
         order by cv.chave_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>