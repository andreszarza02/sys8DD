<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$item = pg_escape_string($conexion, $_POST['item']);

//Establecemos y mostramos la consulta
$sql = "select
            i.it_codigo,
            i.tipit_codigo,
            ti.tipit_descripcion,
            i.it_descripcion as item,
            i.it_descripcion||' COD:'||m.mod_codigomodelo||' COL:'||cp.col_descripcion||' TALL:'||t.tall_descripcion as item2,
            m.mod_codigomodelo,
            cp.col_descripcion,
            t.tall_descripcion
         from items i 
         join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
         join modelo m on m.mod_codigo=i.mod_codigo
         join color_prenda cp on cp.col_codigo=m.col_codigo
         join talle t on t.tall_codigo=i.tall_codigo
         where (i.it_descripcion ilike '%$item%' or m.mod_codigomodelo ilike '%$item%')
         and i.it_estado='ACTIVO'
         and i.tipit_codigo=2
         order by i.it_codigo;
";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>