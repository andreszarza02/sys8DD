<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$usuario = pg_escape_string($conexion, $_POST['usuario']);

//Establecemos y mostramos la consulta
$sql = "select 
         ac.apercie_codigo as apercie_codigo2,
         c.caj_descripcion as caj_descripcion2,
         c.caj_codigo as caj_codigo2,
         s.suc_descripcion as suc_descripcion2,
         e.emp_razonsocial as emp_razonsocial2,
         u.usu_login as usuario,
         ac.apercie_estado as apercie_estado2,
         u.usu_login||' '||'-'||ac.apercie_fechahoraapertura||' '||'-'||c.caj_descripcion as apertura
      from apertura_cierre ac 
      join caja c on c.caj_codigo=ac.caj_codigo
      join usuario u on u.usu_codigo=ac.usu_codigo
      join sucursal s on s.suc_codigo=ac.suc_codigo
      and s.emp_codigo=ac.emp_codigo
      join empresa e on e.emp_codigo=s.emp_codigo
      where u.usu_login ilike '%$usuario%' and ac.apercie_estado='ABIERTO';";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['apercie_codigo2'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>