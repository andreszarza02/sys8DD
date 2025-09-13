<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$deposito = $_POST['dep_codigo'];
$sucursal = $_POST['suc_codigo'];
$empresa = $_POST['emp_codigo'];
$descripcion = $_POST['it_descripcion'];

//Establecemos y mostramos la consulta
$sql = "select 
         s.it_codigo,
         s.tipit_codigo,
         (case 
         when i.tipit_codigo in(1, 4)
         then 
         	i.it_descripcion 
         else 
         	i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion 
         end) as it_descripcion,
         (case 
         when i.tipit_codigo in(1, 4) 
         then 
         	i.it_costo
         else 
         	i.it_precio 
         end) as ajusdet_precio,
         um.unime_codigo,
         um.unime_descripcion 
      from stock s 
         join items i on i.it_codigo=s.it_codigo
         and i.tipit_codigo=s.tipit_codigo
         join unidad_medida um on um.unime_codigo=i.unime_codigo
         join modelo m on m.mod_codigo=i.mod_codigo
         join talle t on t.tall_codigo=i.tall_codigo
         where s.dep_codigo=$deposito 
         and s.suc_codigo=$sucursal 
         and s.emp_codigo=$empresa 
         and i.it_descripcion ilike '%$descripcion%'
         and (i.tipit_codigo = 1 or i.tipit_codigo = 2 or i.tipit_codigo = 4)
         and i.it_estado='ACTIVO'
      order by s.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>