<?php

//Traemmos las variable de sesion
session_start();
$suc_codigo = $_SESSION['usuario']['suc_codigo'];
$emp_codigo = $_SESSION['usuario']['emp_codigo'];

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Solicitamos la clase de Funciones
include_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/funciones/funciones.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimimos y definimos las variables
$per_numerodocumento = $_POST['per_numerodocumento'] ?? 0;

//Guardamos el retorno de la funcion, que en este caso es un array asociativo
$configuracion = obtenerConfiguraciones($conexion, $_POST['suc_codigo'], $_POST['emp_codigo'], 1);

//Establecemos y mostramos la consulta
$sql = "select 
            p.per_numerodocumento,
            c.cli_codigo,
            p.per_nombre||' '||p.per_apellido cliente,
            vc.ven_codigo,
            vc.ven_numfactura,
            '<b>VENTA N°:</b> '||vc.ven_codigo||'  <b>FACTURA:</b> '||vc.ven_numfactura||' '||'<b>FECHA:</b> '||to_char(vc.ven_fecha , 'DD-MM-YYYY') venta,
            vc.ven_tipofactura
         from venta_cab vc 
         join cliente c on c.cli_codigo=vc.cli_codigo 
            join personas p on p.per_codigo=c.per_codigo 
         where p.per_numerodocumento ilike '%$per_numerodocumento%'
            and vc.ven_estado <> 'ANULADO'
            and ((current_date-vc.ven_fecha) <= {$configuracion["config_validacion"]})
            and vc.suc_codigo={$_POST['suc_codigo']}
            and vc.emp_codigo={$_POST['emp_codigo']}
         order by vc.ven_numfactura;";

//Consultamos y mostramos los resultados
$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['ven_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => "NO SE ENCUENTRA LA VENTA O EL PLAZO DE {$configuracion["config_validacion"]} DIAS EXPIRO"]];
}

echo json_encode($datos);


?>