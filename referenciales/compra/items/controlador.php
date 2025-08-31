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
   $it_descripcion = pg_escape_string($conexion, $_POST['it_descripcion']);

   $it_estado = pg_escape_string($conexion, $_POST['it_estado']);

   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $tipit_descripcion = pg_escape_string($conexion, $_POST['tipit_descripcion']);

   $tipim_descripcion = pg_escape_string($conexion, $_POST['tipim_descripcion']);

   $mod_codigomodelo = pg_escape_string($conexion, $_POST['mod_codigomodelo']);

   $tall_descripcion = pg_escape_string($conexion, $_POST['tall_descripcion']);

   $unime_descripcion = pg_escape_string($conexion, $_POST['unime_descripcion']);

   $it_costo = str_replace(",", ".", $_POST['it_costo']);

   $it_precio = str_replace(",", ".", $_POST['it_precio']);

   $it_stock_min = str_replace(",", ".", $_POST['it_stock_min']);

   $it_stock_max = str_replace(",", ".", $_POST['it_stock_max']);

   $sql = "select sp_items(
   {$_POST['it_codigo']}, 
   {$_POST['tipit_codigo']},
   '$it_descripcion', 
   $it_costo, 
   $it_precio,
   '$it_estado', 
   {$_POST['mod_codigo']}, 
   {$_POST['tall_codigo']}, 
   {$_POST['tipim_codigo']}, 
   {$_POST['unime_codigo']}, 
   $it_stock_min,
   $it_stock_max,
   {$_POST['operacion']},
   {$_POST['usu_codigo']},
   '$usu_login',
   '$procedimiento',
   '$tipit_descripcion',
   '$tipim_descripcion',
   '$mod_codigomodelo',
   '$tall_descripcion',
   '$unime_descripcion'
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);
   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "descripcion") !== false) {
      $response = array(
         "mensaje" => "YA EXISTE EL ITEM",
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
   $sql = "select coalesce(max(it_codigo),0)+1 as it_codigo from items;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select 
               i.it_codigo,
               i.tipit_codigo,
               i.it_descripcion,
               i.it_costo,
               i.it_precio,
               i.it_estado,
               i.mod_codigo,
               i.tall_codigo,
               i.tipim_codigo,
               i.unime_codigo,
               ti.tipit_descripcion,
               m.mod_codigomodelo,
               t.tall_descripcion,
               tim.tipim_descripcion,
               um.unime_descripcion,
               i.it_stock_min, 
               i.it_stock_max
            from items i
               join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
               join modelo m on m.mod_codigo=i.mod_codigo
               join talle t on t.tall_codigo=i.tall_codigo 
               join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
               join unidad_medida um on um.unime_codigo=i.unime_codigo 
            order by i.it_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>