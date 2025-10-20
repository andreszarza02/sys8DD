<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Consultamos si existe la variable operacion detalle
if (isset($_POST['operacion_detalle'])) {

   //Definimos las variables a pasar al sp de detalle
   $merdet_cantidad = str_replace(",", ".", $_POST['merdet_cantidad']);

   $merdet_precio = str_replace(",", ".", $_POST['merdet_precio']);

   $sql = "select sp_mermas_det(
      {$_POST['mer_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      $merdet_cantidad, 
      $merdet_precio, 
      {$_POST['operacion_detalle']}
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "item") !== false) {
      $response = array(
         "mensaje" => "EL ITEM YA SE ENCUENTRA REGISTRADO EN EL DETALLE",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['merma'])) {

   $merma = $_POST['merma'];
   $sql = "select 
               * 
            from v_mermas_det vmd 
            where vmd.mer_codigo=$merma;";

   $resultado = pg_query($conexion, $sql);

   $datos = pg_fetch_all($resultado);

   echo json_encode($datos);

} else if (isset($_POST['consulta1'])) {

   //Consultamos la cantidad del item a registrar la merma, para no sobrepasar la cantidad de merma por materia prima
   $sql = "select
            i.it_descripcion,
            sum(opcd.orprocomdet_cantidad) as cantidad
         from produccion_terminada_cab ptc 
            join produccion_cab pc on pc.prod_codigo=ptc.prod_codigo 
               join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
                  join orden_produccion_componente_det opcd on opcd.orpro_codigo=opc.orpro_codigo
                     join componente_produccion_det cpd on cpd.compro_codigo=opcd.compro_codigo 
                     and cpd.it_codigo=opcd.it_codigo and cpd.tipit_codigo=opcd.tipit_codigo 
                        join items i on i.it_codigo=cpd.it_codigo 
                        and i.tipit_codigo=cpd.tipit_codigo 
                           join unidad_medida um on um.unime_codigo=i.unime_codigo 
         where ptc.proter_codigo={$_POST['proter_codigo']}
         	and opcd.it_codigo={$_POST['it_codigo']}
         	and opcd.tipit_codigo=1
         group by 1;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);

   // Si es mayor la cantidad del detalle enviamos un mensaje con tipo eeror
   if ((float) $datos['cantidad'] < (float) $_POST['merdet_cantidad']) {
      $response = array(
         "mensaje" => "LA CANTIDAD DE LA MATERIA PRIMA EN MERMAS ES MAYOR A LA CANTIDAD TOTAL DE LA MATERIA PRIMA UTLIZADA PARA LA PRODUCCION",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => "NADA",
         "tipo" => "success"
      );
   }

   echo json_encode($response);
}

?>