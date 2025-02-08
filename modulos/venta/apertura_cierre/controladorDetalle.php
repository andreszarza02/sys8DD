<?php
session_start();
//Retorno JSON
header("Content-type: application/json; charset=utf-8");
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$consulta = $_POST['consulta'];

//Realiza la sumatoria del monto para el cierre
if ($consulta == '1') {

   $sql = "select 
            coalesce(sum(cobdet_monto), 0) as totalcierre 
         from cobro_det cd 
         join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
         join apertura_cierre ac on ac.apercie_codigo=cc.apercie_codigo 
         where cc.cob_fecha between ac.apercie_fechahoraapertura and '{$_POST['apercie_fechahoracierre']}' 
         and cc.cob_estado='ACTIVO' 
         and ac.apercie_codigo={$_POST['apercie_codigo']};";

   $result = pg_query($conexion, $sql);

   $dato = pg_fetch_assoc($result);

   echo json_encode($dato);

}

//Inserta dato en recaudacion a depositar al realizar el cierre
if ($consulta == '2') {

   $sql2 = "select
            coalesce(sum(case when cd.forco_codigo=1 then cd.cobdet_monto else 0 end), 0) as montoefectivo,
            coalesce(sum(case when cd.forco_codigo=3 then cc2.coche_monto else 0 end), 0) as montocheque
         from cobro_det cd
            join cobro_cab cc on cc.cob_codigo=cd.cob_codigo
            join cobro_cheque cc2 on cc2.cob_codigo=cd.cob_codigo
            join apertura_cierre ac on ac.apercie_codigo=cc.apercie_codigo
         where ac.apercie_codigo={$_POST['apercie_codigo']}";

   $result2 = pg_query($conexion, $sql2);

   $dato2 = pg_fetch_assoc($result2);

   $sql3 = "DO $$
               DECLARE
                  ultcod integer;
               BEGIN 
               ultcod = (select coalesce(max(rec_codigo),0)+1 from recaudacion_depositar); 
               insert into recaudacion_depositar(
               rec_codigo, 
               apercie_codigo, 
               suc_codigo, 
               emp_codigo, 
               caj_codigo, 
               usu_codigo, 
               rec_montoefectivo, 
               rec_montocheque, 
               rec_estado
               ) 
               values(
               ultcod, 
               {$_POST['apercie_codigo']}, 
               {$_POST['suc_codigo']}, 
               {$_POST['emp_codigo']}, 
               {$_POST['caj_codigo']}, 
               {$_POST['usu_codigo']}, 
               {$dato2['montoefectivo']}, 
               {$dato2['montocheque']}, 
               'ACTIVO'
               );
            END $$;";

   $result3 = pg_query($conexion, $sql3);

}

//Inserta dato en arqueo control al realizarse
if ($consulta == '3') {

   //Definimos las variables a utilizar
   $observacion = strtoupper(pg_escape_string($conexion, $_POST['observacion']));

   $sql4 = "DO $$
               DECLARE
                  ultcod integer;
               BEGIN
               ultcod = (select coalesce(max(arco_codigo),0)+1 from arqueo_control); 
               insert into arqueo_control(
               arco_codigo, 
               apercie_codigo, 
               suc_codigo, 
               emp_codigo, 
               caj_codigo, 
               usu_codigo, 
               arco_observacion, 
               arco_fecha, 
               func_codigo
               ) 
               values(
               ultcod, 
               {$_POST['apercie_codigo']}, 
               {$_POST['suc_codigo']}, 
               {$_POST['emp_codigo']}, 
               {$_POST['caj_codigo']}, 
               {$_POST['usu_codigo']}, 
               '$observacion', 
               current_date, 
               {$_POST['func_codigo']}
               );
            END $$;";

   $result4 = pg_query($conexion, $sql4);

}

//Permite definir la variable de apertura cuando se reabre la caja
if ($consulta == '4') {

   //Se recibe los datos cargados en los input de reapertura
   $apertura = [
      "numero" => "{$_POST['apercie_codigo']}",
      "habilitado" => "{$_POST['apercie_estado']}",
      'numero_caja' => "{$_POST['caj_codigo']}",
      'caja' => "{$_POST['caj_descripcion']}"
   ];

   //Cargamos las variable de sesion pra que la caja se mantenga abierta
   $_SESSION['apertura'] = $apertura;

}

?>