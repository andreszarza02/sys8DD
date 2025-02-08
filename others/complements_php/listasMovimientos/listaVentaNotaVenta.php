<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Creamos y cargamos las variables
$tipoComprobante = $_POST['tipco_codigo'];
$cedula = $_POST['cedula'];

//Validamos la consulta por el tipo de comprobante
if (($tipoComprobante == '2') || ($tipoComprobante == '3')) {

   //Establecemos y mostramos la consulta
   $sql = "select 
            vc.ven_codigo,
            vc.ven_tipofactura,
            vc.vent_montocuota,
            c.cli_codigo,
            p.per_nombre||' '||p.per_apellido as cliente,
            'N° Venta: '||vc.ven_codigo||' Factura: '||vc.ven_numfactura as venta,
            vc.ven_numfactura as factura,
            p.per_numerodocumento as cedula
         from venta_cab vc
            join cliente c on c.cli_codigo=vc.cli_codigo
            join personas p on p.per_codigo=c.per_codigo
            where p.per_numerodocumento ilike '%$cedula%'
            and vc.ven_estado = 'ACTIVO'
         order by vc.ven_numfactura;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

   //validamos si se encontro algun valor
   if (!isset($datos[0]['ven_codigo'])) {
      $datos = [['venta' => 'No se encuentra']];
   }

   echo json_encode($datos);

} else {

   //Establecemos y mostramos la consulta
   $sql = "select 
            vc.ven_codigo,
            vc.ven_tipofactura,
            vc.vent_montocuota,
            c.cli_codigo,
            p.per_nombre||' '||p.per_apellido as cliente,
            'N° Venta: '||vc.ven_codigo||' Factura: '||vc.ven_numfactura as venta,
            vc.ven_numfactura as factura,
            p.per_numerodocumento as cedula
         from venta_cab vc
            join cliente c on c.cli_codigo=vc.cli_codigo
            join personas p on p.per_codigo=c.per_codigo
            where p.per_numerodocumento ilike '%$cedula%'
            and vc.ven_estado <> 'ANULADO' and ((current_date-vc.ven_fecha)<=7)
         order by vc.ven_numfactura;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

   //validamos si se encontro algun valor
   if (!isset($datos[0]['ven_codigo'])) {
      $datos = [['venta' => 'No se encuentra o vencio la fecha limite', 'ven_codigo' => '0']];
   }

   echo json_encode($datos);

}

?>