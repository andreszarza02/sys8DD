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

   $facven_numero = pg_escape_string($conexion, $_POST['facven_numero']);

   $sql = "select sp_factura_venta(
   {$_POST['suc_codigo']}, 
   {$_POST['emp_codigo']}, 
   {$_POST['caj_codigo']}, 
   '$facven_numero', 
   {$_POST['operacion']}
   )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   //Si ocurre un error lo capturamos y lo enviamos al front-end
   if (strpos($error, "punto_venta") !== false) {
      $response = array(
         "mensaje" => "EL REGISTRO DE FACTURA DE SUCURSAL Y CAJA YA SE ENCUENTRA ALMACENADO",
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
               e.emp_razonsocial,
               s.suc_descripcion,
               c.caj_descripcion,
               lpad(cast(fv.suc_codigo as text), 3, '0')|| '-' || 
               lpad(cast(fv.caj_codigo as text), 3, '0')|| '-' || 
               fv.facven_numero as factura
            from factura_venta fv 
            join sucursal s on s.suc_codigo=fv.suc_codigo and s.emp_codigo=fv.emp_codigo 
               join empresa e on e.emp_codigo=s.emp_codigo 
            join caja c on c.caj_codigo=fv.caj_codigo 
            order by fv.suc_codigo, fv.caj_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>