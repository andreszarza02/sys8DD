<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Definimos las variables
$comp_codigo = $_POST['comp_codigo'];
$dep_codigo = $_POST['dep_codigo'];
$suc_codigo = $_POST['suc_codigo'];
$emp_codigo = $_POST['emp_codigo'];
$it_descripcion = pg_escape_string($conexion, $_POST['it_descripcion']);
$tipco_codigo = $_POST['tipco_codigo'];

//Validamos el tipo de comprobante
if (($tipco_codigo == 1 or $tipco_codigo == 3)) {

   //Si es credito o remision filtramos el item por compra det
   //Establecemos y mostramos la consulta
   $sql = "select 
            cd.dep_codigo,
            d.dep_descripcion,
            cd.it_codigo,
            cd.tipit_codigo,
            i.tipim_codigo,
            (case 
                  when i.tipit_codigo in(1, 4)
                  then 
                     i.it_descripcion||' '||d.dep_descripcion 
                  else 
                     i.it_descripcion
                  end) as it_descripcion,
            cd.compdet_cantidad as nocomdet_cantidad,
            i.unime_codigo,
            um.unime_descripcion,
            cd.compdet_precio as nocomdet_precio
         from compra_det cd
            join stock s on s.it_codigo=cd.it_codigo
            and s.tipit_codigo=cd.tipit_codigo
            and s.dep_codigo=cd.dep_codigo 
            and s.suc_codigo=cd.suc_codigo
            and s.emp_codigo=cd.emp_codigo
            join items i on i.it_codigo=s.it_codigo
            and i.tipit_codigo=s.tipit_codigo
            join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
            join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
            join deposito d on d.dep_codigo=s.dep_codigo
            and d.suc_codigo=s.suc_codigo
            and d.emp_codigo=s.emp_codigo 
            join unidad_medida um on um.unime_codigo=i.unime_codigo
         where cd.comp_codigo=$comp_codigo
            and i.it_descripcion ilike '%$it_descripcion%'
            and i.it_estado = 'ACTIVO'
            and i.tipit_codigo <> 2
         order by cd.comp_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

} else {

   //Si es debito filtramos el item por stock
   //Establecemos y mostramos la consulta
   $sql = "select 
               s.it_codigo,
               s.tipit_codigo,
               i.tipim_codigo,
               i.it_descripcion,
               um.unime_codigo,
               um.unime_descripcion,
               (case 
               when i.tipit_codigo in(1, 4)
               then 
                  i.it_costo 
               else 
                  0
               end) as nocomdet_precio
            from stock s 
               join items i on i.it_codigo=s.it_codigo
               and i.tipit_codigo=s.tipit_codigo
               join unidad_medida um on um.unime_codigo=i.unime_codigo
               join modelo m on m.mod_codigo=i.mod_codigo
               join talle t on t.tall_codigo=i.tall_codigo
               where s.dep_codigo=$dep_codigo
               and s.suc_codigo=$suc_codigo
               and s.emp_codigo=$emp_codigo
               and i.it_descripcion ilike '%$it_descripcion%'
               and i.tipit_codigo <> 2
               and i.it_estado='ACTIVO'
            order by s.it_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

}

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>