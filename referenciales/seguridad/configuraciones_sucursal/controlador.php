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

   //Recibimos y definimos las variables
   $configsuc_estado = pg_escape_string($conexion, $_POST['configsuc_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $config_validacion = pg_escape_string($conexion, $_POST['config_validacion']);

   $config_descripcion = pg_escape_string($conexion, $_POST['config_descripcion']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   //Establecemos el stored procedure a utilizar con sus respectivos parametros
   $sql = "select sp_configuraciones_sucursal(
            {$_POST['configsuc_codigo']}, 
            {$_POST['config_codigo']}, 
            {$_POST['suc_codigo']}, 
            {$_POST['emp_codigo']}, 
            '$configsuc_estado', 
            {$_POST['operacion']},
            {$_POST['usu_codigo']},
            '$usu_login',
            '$procedimiento',
            '$config_validacion', 
            '$config_descripcion', 
            '$suc_descripcion', 
            '$emp_razonsocial'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         //Como no tenemos excepciones de momento, generamos uno generico
         "mensaje" => "YA SE ENCUENTRA REGISTRADA LA SUCURSAL CON LA RESPECTIVA CONFIGURACION",
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
   $sql = "select coalesce(max(configsuc_codigo),0)+1 as configsuc_codigo from configuraciones_sucursal;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_assoc($resultado);

   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               cs.configsuc_codigo,
               cs.config_codigo,
               cs.suc_codigo,
               cs.emp_codigo,
               cs.configsuc_estado,
               e.emp_razonsocial,
               s.suc_descripcion,
               c.config_descripcion,
               c.config_validacion 
            from configuraciones_sucursal cs 
               join configuraciones c on c.config_codigo=cs.config_codigo 
               join sucursal s on s.suc_codigo=cs.suc_codigo 
               and s.emp_codigo=cs.emp_codigo 
                  join empresa e on e.emp_codigo=s.emp_codigo 
            order by cs.configsuc_codigo;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);

}

?>