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
   $sql = "select sp_etapa_produccion(
      {$_POST['prod_codigo']},  
      {$_POST['it_codigo']},  
      {$_POST['tipit_codigo']},  
      {$_POST['tipet_codigo']},  
      '{$_POST['etpro_fecha']}',
      {$_POST['usu_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['maq_codigo']}, 
      {$_POST['etpro_codigo']}, 
      {$_POST['operacion']}
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "produccion_etapa") !== false) {
      $response = array(
         "mensaje" => "EL ITEM, LA ETAPA, LA MAQUINARIA Y EL CODIGO DE PRODUCCION YA SE ENCUENTRAN REGISTRADOS",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['consulta1'])) {

   //Definimos variables a utilizar 
   $modificarEstados = true;

   //Actualizamos el estado del producto de produccion detalle a terminado
   $sql = "update produccion_det set prodet_estado = 'TERMINADO' where prod_codigo={$_POST['prod_codigo']} and it_codigo={$_POST['it_codigo']} and tipit_codigo={$_POST['tipit_codigo']};";

   $resultado = pg_query($conexion, $sql);

   //Consultamos el estado de todos los productos que conforman la produccion detalle 
   $sql2 = "select 
               pd.prodet_estado
            from produccion_det pd 
            where pd.prod_codigo={$_POST['prod_codigo']};";

   $resultado2 = pg_query($conexion, $sql2);
   $datos2 = pg_fetch_all($resultado2);

   //Validamos si hay algun estado activo en los productos de produccion detalle
   foreach ($datos2 as $dato) {
      if ($dato['prodet_estado'] == 'ACTIVO') {
         //En caso de ser asi actualizamos el valor de la variable a false
         $modificarEstados = false;
      }
   }

   //Si la variable llega a esta seccion siendo true quiere decir que todos los productos de produccion detalle tienen el estado de terminado es decir distinto a activo
   if ($modificarEstados) {
      $sql3 = "DO $$
                  DECLARE
                     prodAudit text;
                     orproAudit text;
                     orproCodigo integer;
                     c_produccion cursor is
                     select 
                     pc.prod_fecha,
                     pc.orpro_codigo,
                     s.secc_descripcion,
                     opc.orpro_fechainicio,
                     opc.orpro_fechaculminacion,
                     pc.prod_estado
                     from produccion_cab pc 
                     join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
                     join seccion s on s.secc_codigo=opc.secc_codigo 
                     where pc.prod_codigo={$_POST['prod_codigo']};
                     c_orden cursor is
                     select 
                     opc.orpro_fecha,
                     opc.orpro_fechainicio,
                     opc.orpro_fechaculminacion,
                     opc.secc_codigo,
                     s.secc_descripcion,
                     opc.orpro_estado
                     from produccion_cab pc 
                     join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
                     join seccion s on s.secc_codigo=opc.secc_codigo 
                     where pc.prod_codigo={$_POST['prod_codigo']};
                  BEGIN
                  --Actualizamos el estado de produccion cabecera
                  update produccion_cab set prod_estado = 'TERMINADO' where prod_codigo = {$_POST['prod_codigo']};
                  --Auditamos el cambio de estado de produccion cabecera
                  --Consultamos el audit anterior
                  select coalesce(prod_audit, '') into prodAudit from produccion_cab where prod_codigo={$_POST['prod_codigo']};
                  --Consultamos los datos del cursor y auditamos
                  for prod in c_produccion loop
                        update produccion_cab 
                        set prod_audit = prodAudit||''||json_build_object(
                        'usu_codigo', {$_POST['usu_codigo']},
                        'usu_login', '{$_POST['usu_login']}',
                        'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
                        'procedimiento', 'MODIFICACION',
                        'prod_fecha', prod.prod_fecha,
                        'orpro_codigo', prod.orpro_codigo,
                        'secc_descripcion', prod.secc_descripcion,
                        'orpro_fechainicio', prod.orpro_fechainicio,
                        'orpro_fechaculminacion', prod.orpro_fechaculminacion,
                        'emp_codigo', {$_POST['emp_codigo']},
                        'emp_razonsocial', '{$_POST['emp_razonsocial']}',
                        'suc_codigo', {$_POST['suc_codigo']},
                        'suc_descripcion', '{$_POST['suc_descripcion']}',
                        'prod_estado', prod.prod_estado
                        )||','
                        where prod_codigo = {$_POST['prod_codigo']};
                  end loop;
                  --Extraemos el codigo de la orden de produccion asociada a la produccion cabecera
                  orproCodigo := (select orpro_codigo from produccion_cab where prod_codigo = {$_POST['prod_codigo']});
                  --Actualizamos el estado de orden produccion cabecera asociado a la produccion cabecera
                  update orden_produccion_cab set orpro_estado = 'TERMINADO' where orpro_codigo = orproCodigo;
                  --Auditamos el cambio de estado de orden produccion cabecera
                  --Consultamos el audit anterior
                  select coalesce(orpro_audit, '') into orproAudit from orden_produccion_cab where orpro_codigo=orproCodigo;
                  --a los datos anteriores le agregamos los nuevos
                  for ord in c_orden loop
                        update orden_produccion_cab 
                        set orpro_audit = orproAudit||''||json_build_object(
                           'usu_codigo', {$_POST['usu_codigo']},
                           'usu_login', '{$_POST['usu_login']}',
                           'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
                           'procedimiento', 'MODIFICACION',
                           'orpro_fecha', ord.orpro_fecha,
                           'orpro_fechainicio', ord.orpro_fechainicio,
                           'orpro_fechaculminacion', ord.orpro_fechaculminacion,
                           'secc_codigo', ord.secc_codigo,
                           'secc_descripcion', ord.secc_descripcion,
                           'emp_codigo', {$_POST['emp_codigo']},
                           'emp_razonsocial', '{$_POST['emp_razonsocial']}',
                           'suc_codigo', {$_POST['suc_codigo']},
                           'suc_descripcion','{$_POST['suc_descripcion']}',
                           'orpro_estado', ord.orpro_estado
                        )||','
                        where orpro_codigo = orproCodigo;
                  end loop;
               END $$;";

      $resultado3 = pg_query($conexion, $sql3);

      //Si se ejecuto la sentencia de forma correcta procedemos a enviar un mensaje de confirmacion
      $response = array(
         "mensaje" => "SE DIO POR FINALIZADO LA ETAPA DE PRODUCCION DEL ULTIMO PRODUCTO QUE COMPONE LA PRODUCCION N°{$_POST['prod_codigo']}",
         "tipo" => "info"
      );

   } else {

      $response = array(
         "mensaje" => 'SE DIO POR FINALIZADO LA ETAPA DE PRODUCCION DEL PRODUCTO SELECCIONADO',
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * from v_etapa_produccion vep where vep.prodet_estado <> 'TERMINADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>