<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$funpro_documento = pg_escape_string($conexion, $_POST['funpro_documento']);

//Establecemos y mostramos la consulta
$sql = "select 
            fp.funpro_codigo,
            fp.funpro_documento,
            fp.funpro_nombre,
            fp.funpro_apellido ,
            fp.funpro_nombre||' '||fp.funpro_apellido as funcionario_externo
         from funcionario_proveedor fp 
         where (fp.funpro_documento ilike '%$funpro_documento%'
            or fp.funpro_nombre ilike '%$funpro_documento%'
            or fp.funpro_apellido ilike '%$funpro_documento%')
            and fp.pro_codigo = {$_POST['pro_codigo']}
            and fp.tipro_codigo = {$_POST['tipro_codigo']}
            and funpro_estado = 'ACTIVO'
         order by fp.funpro_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

if (!isset($datos[0]['funpro_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>