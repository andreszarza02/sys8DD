<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos la variable
$per_numerodocumento = pg_escape_string($conexion, $_POST['per_numerodocumento']);
$suc_codigo = $_POST['suc_codigo'];
$emp_codigo = $_POST['emp_codigo'];

//Establecemos y mostramos la consulta
$sql = "select 
         p.per_numerodocumento,
         p.per_nombre||' '||p.per_apellido as cliente,
         pc.pres_codigo,
         pc.peven_codigo,
         'PRESUPUESTO N°'||pc.pres_codigo||' '||to_char(pc.pres_fecharegistro, 'DD-MM-YYYY') as presupuesto
      from presupuesto_cab pc 
         join cliente c on c.cli_codigo=pc.cli_codigo 
         join personas p on p.per_codigo=c.per_codigo 
      where p.per_numerodocumento ilike '%$per_numerodocumento%'
         and pc.suc_codigo=$suc_codigo
         and pc.emp_codigo=$emp_codigo
         and pc.pres_estado='ACTIVO'
      order by pc.pres_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['pres_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>