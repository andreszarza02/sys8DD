<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Definimos las variables a utilizar
$proter_codigo = $_POST['proter_codigo'];
$it_descripcion = pg_escape_string($conexion, $_POST['it_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select distinct
            opd.it_codigo,
            opd.tipit_codigo,
            i.it_descripcion,
            i.it_costo as merdet_precio,
            um.unime_codigo,
            um.unime_descripcion 
         from produccion_terminada_cab ptc 
            join produccion_cab pc on pc.prod_codigo=ptc.prod_codigo 
               join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
                  join orden_produccion_det2 opd on opd.orpro_codigo=opc.orpro_codigo
                     join componente_produccion_det cpd on cpd.compro_codigo=opd.compro_codigo 
                     and cpd.it_codigo=opd.it_codigo and cpd.tipit_codigo=opd.tipit_codigo 
                        join items i on i.it_codigo=cpd.it_codigo 
                        and i.tipit_codigo=cpd.tipit_codigo 
                           join unidad_medida um on um.unime_codigo=i.unime_codigo 
         where ptc.proter_codigo=1
            and i.it_estado='ACTIVO'
            and i.tipit_codigo=1
            and i.it_descripcion ilike '%$it_descripcion%'
         order by opd.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>