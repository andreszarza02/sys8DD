<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$prod_codigo = $_POST['prod_codigo'];

//Establecemos y mostramos la consulta
$sql = "select 
         pd.it_codigo,
         pd.tipit_codigo,
         pd.prodet_estado,
         i.it_descripcion||' '||m.mod_codigomodelo as item,
         i.it_descripcion||' COD:'||m.mod_codigomodelo||' TALL:'||t.tall_descripcion as item2,
         t.tall_descripcion 
      from produccion_det pd 
         join produccion_cab pc on pc.prod_codigo=pd.prod_codigo 
         join items i on i.it_codigo=pd.it_codigo 
         and i.tipit_codigo=pd.tipit_codigo 
         join modelo m on m.mod_codigo=i.mod_codigo 
         join talle t on t.tall_codigo=i.tall_codigo 
         where pd.prod_codigo=$prod_codigo
         and pd.prodet_estado='ACTIVO'
         and pc.prod_estado='ACTIVO' 
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