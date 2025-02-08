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

   $estado = $_POST['func_estado'];
   $func_estado = str_replace("'", "''", $estado);

   $usuLogin = $_POST['usu_login'];
   $usu_login = str_replace("'", "''", $usuLogin);

   $procedimiento1 = $_POST['procedimiento'];
   $procedimiento2 = str_replace("'", "''", $procedimiento1);

   $perNumeroDocumento = $_POST['per_numerodocumento'];
   $per_numerodocumento = str_replace("'", "''", $perNumeroDocumento);

   $persona1 = $_POST['persona'];
   $persona2 = str_replace("'", "''", $persona1);

   $ciuDescripcion = $_POST['ciu_descripcion'];
   $ciu_descripcion = str_replace("'", "''", $ciuDescripcion);

   $carDescripcion = $_POST['car_descripcion'];
   $car_descripcion = str_replace("'", "''", $carDescripcion);

   $empRazonSocial = $_POST['emp_razonsocial'];
   $emp_razonsocial = str_replace("'", "''", $empRazonSocial);

   $sucDescripcion = $_POST['suc_descripcion'];
   $suc_descripcion = str_replace("'", "''", $sucDescripcion);

   $sql = "select sp_funcionario(
   {$_POST['func_codigo']}, 
   '{$_POST['fun_fechaingreso']}', 
   '$func_estado', 
   {$_POST['per_codigo']}, 
   {$_POST['ciu_codigo']}, 
   {$_POST['car_codigo']}, 
   {$_POST['suc_codigo']}, 
   {$_POST['emp_codigo']}, 
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento2',
   '$per_numerodocumento',
   '$persona2',
   '$ciu_descripcion',
   '$car_descripcion',
   '$emp_razonsocial',
   '$suc_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "1") !== false) {
      $response = array(
         "mensaje" => "YA ESTA REGISTRADA LA PERSONA",
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
   $sql = "select coalesce(max(func_codigo),0)+1 as func_codigo from funcionario;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               f.func_codigo,
               f.fun_fechaingreso,
               f.func_estado,
               f.per_codigo,
               f.ciu_codigo,
               f.car_codigo,
               f.suc_codigo,
               f.emp_codigo,
               p.per_nombre||' '||p.per_apellido as persona,
               p.per_numerodocumento,
               c.ciu_descripcion,
               c2.car_descripcion,
               s.suc_descripcion,
               e.emp_razonsocial
         from funcionario f
               join personas p on p.per_codigo=f.per_codigo
               join ciudad c on c.ciu_codigo=f.ciu_codigo
               join cargo c2 on c2.car_codigo=f.car_codigo
               join sucursal s on s.suc_codigo=f.suc_codigo 
               and s.emp_codigo=f.emp_codigo
               join empresa e on e.emp_codigo=s.emp_codigo
         order by f.func_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>