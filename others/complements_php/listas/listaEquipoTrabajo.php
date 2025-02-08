<?php
//Retorno JSON
header('Content-type: application/json; charset=utf-8');
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$funcionario = $_POST['per_numerodocumento'];

//Establecemos y mostramos la consulta
$sql = "select 
            f.func_codigo,
            p.per_nombre||' '||p.per_apellido as funcionario,
            p.per_numerodocumento,
            f.suc_codigo,
            f.emp_codigo 
        from funcionario f
            join personas p on p.per_codigo=f.per_codigo
            where p.per_numerodocumento ilike '%$funcionario%' and f.func_estado = 'ACTIVO'";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//validamos si se encontro algun valor
if (!isset($datos[0]['func_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);
?>