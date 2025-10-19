<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Definimos las variables a utilizar
$orpro_codigo = $_POST['orpro_codigo'];
$it_descripcion = pg_escape_string($conexion, $_POST['it_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select 
         opd.it_codigo,
         opd.tipit_codigo,
         i.it_descripcion||', MODELO:'||m.mod_codigomodelo as it_descripcion,
         i.it_descripcion||', <b>MODELO:</b>'||m.mod_codigomodelo||', <b>TALLE:</b>'||t.tall_descripcion as it_descripcion2,
         t.tall_descripcion,
         opd.orprodet_cantidad as prodet_cantidad,
         um.unime_codigo,
         um.unime_descripcion 
      from orden_produccion_det opd
         join items i on i.it_codigo=opd.it_codigo
         and i.tipit_codigo=opd.tipit_codigo
            join modelo m on m.mod_codigo=i.mod_codigo
            join talle t on t.tall_codigo=i.tall_codigo
            join unidad_medida um on um.unime_codigo=i.unime_codigo 
         where (i.it_descripcion ilike '%$it_descripcion%'
         or m.mod_codigomodelo ilike '%$it_descripcion%'
         or t.tall_descripcion ilike '%$it_descripcion%') 
         and i.tipit_codigo=2
         and opd.orpro_codigo=$orpro_codigo
      order by opd.orpro_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>