<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Definimos las variables
$item = pg_escape_string($conexion, $_POST['item']);

//Establecemos y mostramos la consulta
$sql = "select 
         i.it_codigo,
         i.tipit_codigo,
         i.it_descripcion||' '||m.mod_codigomodelo as item,
         i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as item2,
         t.tall_descripcion,
         um.unime_codigo,
         um.unime_descripcion,
         i.it_precio as pevendet_precio
      from items i
         join modelo m on m.mod_codigo=i.mod_codigo
         join talle t on t.tall_codigo=i.tall_codigo 
         join unidad_medida um on um.unime_codigo=i.unime_codigo
         where it_descripcion ilike '%$item%' 
         and tipit_codigo = 2 
         and it_estado = 'ACTIVO'
      order by i.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>