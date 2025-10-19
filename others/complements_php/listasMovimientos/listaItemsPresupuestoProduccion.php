<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos la variable
$peven_codigo = $_POST['peven_codigo'];
$it_descripcion = pg_escape_string($conexion, $_POST['it_descripcion']);

//Establecemos y mostramos la consulta
$sql = "select 
            pvd.it_codigo,
            pvd.tipit_codigo,
            (case 
            pvd.tipit_codigo
         when 2
            then 
                  i.it_descripcion||', MODELO:'||m.mod_codigomodelo
            else 
                  i.it_descripcion 
         end) as it_descripcion,
            (case 
            pvd.tipit_codigo
         when 2
            then 
                  i.it_descripcion||', <b>MODELO:</b> '||m.mod_codigomodelo||' <b>TALLE:</b> '||t.tall_descripcion
            else 
                  i.it_descripcion 
         end) as it_descripcion2,
            pvd.pevendet_cantidad as presdet_cantidad,
            t.tall_descripcion,
            um.unime_codigo,
            um.unime_descripcion,
            i.it_precio as presdet_precio
         from pedido_venta_det pvd
            join items i on i.it_codigo=pvd.it_codigo
            and i.tipit_codigo=pvd.tipit_codigo 
               join modelo m on m.mod_codigo=i.mod_codigo
            join talle t on t.tall_codigo=i.tall_codigo 
               join unidad_medida um on um.unime_codigo=i.unime_codigo
            where pvd.peven_codigo=$peven_codigo
            and (i.it_descripcion ilike '%$it_descripcion%'
            or m.mod_codigomodelo ilike '%$it_descripcion%'
            or t.tall_descripcion ilike '%$it_descripcion%')
            and i.tipit_codigo in(2,3)
         order by pvd.peven_codigo, i.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>