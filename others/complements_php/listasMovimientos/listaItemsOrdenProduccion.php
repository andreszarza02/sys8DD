<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$pres_codigo = $_POST['pres_codigo'];
$it_descripcion = pg_escape_string($conexion, $_POST['item']);

//Establecemos y mostramos la consulta
$sql = "select 
         pd.it_codigo,
         pd.tipit_codigo,
         i.it_descripcion||' '||m.mod_codigomodelo as item,
         i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as item2,
         t.tall_descripcion,
         um.unime_codigo,
         um.unime_descripcion,
         pd.presdet_cantidad as orprodet_cantidad
      from presupuesto_det pd
         join items i on i.it_codigo=pd.it_codigo
         and i.tipit_codigo=pd.tipit_codigo
         join modelo m on m.mod_codigo=i.mod_codigo
         join talle t on t.tall_codigo=i.tall_codigo
         join unidad_medida um on um.unime_codigo=i.unime_codigo 
      where pd.pres_codigo=$pres_codigo
      and i.it_descripcion ilike '%$it_descripcion%' 
      and i.it_estado='ACTIVO'
      and i.tipit_codigo=2
      order by pd.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>