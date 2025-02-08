<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$secc_descripcion = pg_escape_string($conexion, $_POST['secc_descripcion']);
$suc_codigo = $_POST['suc_codigo'];

//Establecemos y mostramos la consulta
$sql = "select 
            s.secc_descripcion,
            'Produccion N°'||pc.prod_codigo||' '||to_char(pc.prod_fecha,'DD-MM-YYYY') as produccion,
            pc.prod_codigo,
            opc.orpro_fechaculminacion as proter_fechaculminacion
         from produccion_cab pc 
            join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
            join seccion s on s.secc_codigo=opc.secc_codigo 
            where pc.prod_estado='TERMINADO'
            and opc.suc_codigo=$suc_codigo
            and pc.prod_codigo not in (select ptc.prod_codigo from produccion_terminada_cab ptc where ptc.proter_estado='ACTIVO')
            and s.secc_descripcion ilike '%$secc_descripcion%'
         order by pc.prod_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['prod_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>