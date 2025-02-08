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

   $estado = $_POST['eqtra_estado'];
   $eqtra_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $perNumeroDocumento = $_POST['per_numerodocumento'];
   $per_numerodocumento = str_replace("'", "''", $perNumeroDocumento);

   $funcionario1 = $_POST['funcionario'];
   $funcionario2 = str_replace("'", "''", $funcionario1);

   $seccDescripcion = $_POST['secc_descripcion'];
   $secc_descripcion = str_replace("'", "''", $seccDescripcion);

   $sql = "select sp_equipo_trabajo(
   {$_POST['func_codigo']}, 
   {$_POST['secc_codigo']}, 
   '$eqtra_estado', 
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento2',
   '$per_numerodocumento',
   '$funcionario2',
   '$secc_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA ESTA REGISTRADO EL FUNCIONARIO EN LA SECCION",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);


} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
            et.func_codigo,
            et.secc_codigo,
            et.eqtra_estado,
            p.per_nombre||' '||p.per_apellido as funcionario,
            p.per_numerodocumento,
            s.secc_descripcion,
            s2.suc_descripcion,
            e.emp_razonsocial 
      from equipo_trabajo et
            join seccion s on s.secc_codigo=et.secc_codigo
            join funcionario f on f.func_codigo=et.func_codigo
            join personas p on p.per_codigo=f.per_codigo
            join sucursal s2 on s2.suc_codigo=f.suc_codigo
            and s2.emp_codigo=f.emp_codigo
            join empresa e on e.emp_codigo=s.emp_codigo
            order by et.func_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>