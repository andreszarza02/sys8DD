<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$peven_codigo = $_POST['peven_codigo'];
$item = $_POST['item'];

//Establecemos y mostramos la consulta
$sql = "select 
            pvd.it_codigo,
            pvd.tipit_codigo,
            i.tipim_codigo,
            (case 
               pvd.tipit_codigo
            when 2
               then 
                     i.it_descripcion||' '||m.mod_codigomodelo
                  else 
                     i.it_descripcion 
            end) as item,
            (case 
               pvd.tipit_codigo
            when 2
               then 
                     i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion 
                  else 
                     i.it_descripcion 
            end) as item2,
            t.tall_descripcion,
            um.unime_codigo,
            um.unime_descripcion,
            pd.presdet_cantidad as vendet_cantidad,
            pd.presdet_precio as vendet_precio
         from pedido_venta_det pvd 
         join items i on i.it_codigo=pvd.it_codigo 
         and i.tipit_codigo=pvd.tipit_codigo 
            join modelo m on m.mod_codigo=i.mod_codigo 
            join talle t on t.tall_codigo=i.tall_codigo 
            join unidad_medida um on um.unime_codigo=i.unime_codigo 
         join pedido_venta_cab pvc on pvc.peven_codigo=pvd.peven_codigo 
            join presupuesto_cab pc on pc.peven_codigo=pvc.peven_codigo 
               join presupuesto_det pd on pd.pres_codigo=pc.pres_codigo 
               and pd.it_codigo=pvd.it_codigo
         where pvd.peven_codigo=$peven_codigo
         and i.it_estado='ACTIVO'
         and pvc.peven_estado='VENDIDO'
         and pc.pres_estado='APROBADO'
         and (i.it_descripcion ilike '%$item%' or m.mod_codigomodelo ilike '%$item%')
         and i.tipit_codigo in (2, 3)
         order by pvd.peven_codigo, pvd.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>