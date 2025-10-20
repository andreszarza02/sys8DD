<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$proter_codigo = $_POST['proter_codigo'];
$it_descripcion = pg_escape_string($conexion, $_POST['it_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select 
            ptd.it_codigo,
            ptd.tipit_codigo,
            i.it_descripcion||', MODELO:'||m.mod_codigomodelo as it_descripcion,
            i.it_descripcion||', <b>MODELO:</b>'||m.mod_codigomodelo||', <b>TALLE:</b>'||t.tall_descripcion as it_descripcion2,
            t.tall_descripcion,
            um.unime_codigo,
            um.unime_descripcion 
         from produccion_terminada_det ptd 
            join stock s on s.it_codigo=ptd.it_codigo 
            and s.tipit_codigo=ptd.tipit_codigo 
            and s.dep_codigo=ptd.dep_codigo 
            and s.suc_codigo=ptd.suc_codigo 
            and s.emp_codigo=ptd.emp_codigo 
               join items i on i.it_codigo=s.it_codigo 
               and i.tipit_codigo=s.tipit_codigo 
                  join modelo m on m.mod_codigo=i.mod_codigo 
                  join talle t on t.tall_codigo=i.tall_codigo 
                  join unidad_medida um on um.unime_codigo=i.unime_codigo
         where ptd.proter_codigo=$proter_codigo
            and i.tipit_codigo=2
            and (i.it_descripcion ilike '%$it_descripcion%'
            or m.mod_codigomodelo ilike '%$it_descripcion%'
            or t.tall_descripcion ilike '%$it_descripcion%')
         order by ptd.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>