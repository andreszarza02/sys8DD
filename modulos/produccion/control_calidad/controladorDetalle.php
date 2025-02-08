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

   $sql = "select sp_control_calidad_det(
      {$_POST['conca_codigo']}, 
      {$_POST['it_codigo']}, 
      {$_POST['tipit_codigo']}, 
      {$_POST['pacoca_codigo']}, 
      {$_POST['concadet_cantidadfallida']}, 
      {$_POST['operacion_detalle']}
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "item_parametro") !== false) {
      $response = array(
         "mensaje" => "EL ITEM Y EL PARAMETRO DE CONTROL YA SE ENCUENTRAN REGISTRADOS EN EL DETALLE",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['control'])) {

   $control = $_POST['control'];
   $sql = "select * from v_control_calidad_det vccd where vccd.conca_codigo=$control;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);

} else if (isset($_POST['consulta']) == 1) {

   //Consultamos el listado de productos separado por control
   $sql = "select 
            ptd.it_codigo,
            i.it_descripcion||' COD:'||m.mod_codigomodelo||' TALL:'||t.tall_descripcion as item2,
            ptd.proterdet_cantidad as cantidad_total,
            (select 
               coalesce(sum(ccd.concadet_cantidadfallida), 0)
            from control_calidad_det ccd 
               join control_calidad_cab ccc on ccc.conca_codigo=ccd.conca_codigo 
            where ccc.proter_codigo={$_POST['proter_codigo']}
            and ccd.it_codigo=ptd.it_codigo
            ) as cantidad_fallida,
            (ptd.proterdet_cantidad)
            -
            (select 
               coalesce(sum(ccd.concadet_cantidadfallida),0) 
            from control_calidad_det ccd 
               join control_calidad_cab ccc on ccc.conca_codigo=ccd.conca_codigo 
            where ccc.proter_codigo={$_POST['proter_codigo']}
            and ccd.it_codigo=ptd.it_codigo
            ) as cantidad_item_correcto
         from produccion_terminada_det ptd 
         join stock s on s.it_codigo=ptd.it_codigo 
            and s.tipit_codigo=ptd.tipit_codigo 
            and s.dep_codigo=ptd.dep_codigo 
            and s.suc_codigo=ptd.suc_codigo 
            and s.emp_codigo=ptd.emp_codigo 
               join items i on i.it_codigo=s.it_codigo 
               and i.tipit_codigo=s.tipit_codigo 
                  join modelo m on m.mod_codigo=i.mod_codigo 
                  join talle t on t.tall_codigo=i.tall_codigo 
                  join unidad_medida um on um.unime_codigo=i.unime_codigo
         where ptd.proter_codigo={$_POST['proter_codigo']};";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);

}

?>