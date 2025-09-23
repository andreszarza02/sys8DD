<?php

session_start();

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
   $apercie_estado = pg_escape_string($conexion, $_POST['apercie_estado']);

   $apercie_montoapertura = str_replace(",", ".", $_POST['apercie_montoapertura']);

   $apercie_montocierre = str_replace(",", ".", $_POST['apercie_montocierre']);

   //Validamos por operación para diferenciar si es una inserción o una actualización de registro
   if ($_POST['operacion'] == 1) {

      //insertamos nuevo registro
      $sql = "select sp_apertura_cierre(
         {$_POST['apercie_codigo']}, 
         {$_POST['suc_codigo']}, 
         {$_POST['emp_codigo']},
         {$_POST['caj_codigo']}, 
         {$_POST['usu_codigo']}, 
         '{$_POST['apercie_fechahoraapertura']}', 
         '{$_POST['apercie_fechahoraapertura']}', 
         $apercie_montoapertura, 
         0, 
         '$apercie_estado', 
         {$_POST['operacion']}
         )";

   } else {

      //Actualizamos registro existente
      $sql = "select sp_apertura_cierre(
         {$_POST['apercie_codigo']}, 
         {$_POST['suc_codigo']}, 
         {$_POST['emp_codigo']},
         {$_POST['caj_codigo']}, 
         {$_POST['usu_codigo']}, 
         '{$_POST['apercie_fechahoracierre']}', 
         '{$_POST['apercie_fechahoracierre']}', 
         0, 
         $apercie_montocierre, 
         '$apercie_estado', 
         {$_POST['operacion']}
         )";

   }

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   //En caso de generarse un error enviamos un mensaje
   if (strpos($error, "caja") !== false) {
      $response = array(
         "mensaje" => "EL NUMERO DE CAJA QUE DESEAS ABRIR YA SE ENCUENTRA ABIERTO",
         "tipo" => "error"
      );
   } else {

      //En caso de que no realizamos una consulta para mantener abierto la caja
      $sql2 = "select 
                  ac.apercie_codigo, 
                  ac.apercie_estado, 
                  ac.caj_codigo, 
                  c.caj_descripcion 
               from apertura_cierre ac 
               join caja c on c.caj_codigo=ac.caj_codigo 
               where ac.apercie_codigo = {$_POST['apercie_codigo']}";

      $result2 = pg_query($conexion, $sql2);

      $dato2 = pg_fetch_assoc($result2);

      $apertura = [
         "numero" => "{$dato2['apercie_codigo']}",
         "habilitado" => "{$dato2['apercie_estado']}",
         'numero_caja' => "{$dato2['caj_codigo']}",
         'caja' => "{$dato2['caj_descripcion']}"
      ];

      $_SESSION['apertura'] = $apertura;

      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else {

   //En caso de no enviar ninguna operacion consultamos el último codigo de apertura y cierre
   $sql4 = "select coalesce(max(apercie_codigo),0)+1 as numero_apertura from apertura_cierre";

   $result4 = pg_query($conexion, $sql4);

   $dato4 = pg_fetch_assoc($result4);

   echo json_encode($dato4);

}
