<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Definimos las variables a utilizar
$secc_descripcion = pg_escape_string($conexion, $_POST['secc_descripcion']);
$suc_codigo = $_POST['suc_codigo'];

//Establecemos y mostramos la consulta
$sql = "select 
            s.secc_descripcion,
            opc.orpro_codigo,
            'Orden Produccion N°'||opc.orpro_codigo||' '||to_char(opc.orpro_fecha, 'DD-MM-YYYY') as orden
         from orden_produccion_cab opc 
            join seccion s on s.secc_codigo=opc.secc_codigo 
            where opc.orpro_estado <> 'ANULADO'
            and opc.suc_codigo=$suc_codigo
            and opc.orpro_codigo not in (select cpc.orpro_codigo from costo_produccion_cab cpc where cpc.copro_estado='ACTIVO')
            and s.secc_descripcion ilike '%$secc_descripcion%'
         order by opc.orpro_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['orpro_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>