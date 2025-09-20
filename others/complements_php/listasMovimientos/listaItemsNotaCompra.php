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
if ($tipco_codigo == 1) {

   //Establecemos y mostramos la consulta
   $sql = "WITH datos AS (
            -- Parte 1: los ítems de la compra
            SELECT
               cd.dep_codigo,
               d.dep_descripcion,
               cd.it_codigo,
               cd.tipit_codigo,
               i.tipim_codigo,
               i.it_descripcion,
               cd.compdet_cantidad AS cantidad,
               cd.compdet_precio AS precio,
               i.unime_codigo,
               um.unime_descripcion
            FROM compra_det cd
            JOIN stock s 
               ON s.it_codigo = cd.it_codigo
               AND s.tipit_codigo = cd.tipit_codigo
               AND s.dep_codigo = cd.dep_codigo
               AND s.suc_codigo = cd.suc_codigo
               AND s.emp_codigo = cd.emp_codigo
            JOIN items i 
               ON i.it_codigo = s.it_codigo
               AND i.tipit_codigo = s.tipit_codigo
            JOIN deposito d 
               ON d.dep_codigo = s.dep_codigo
               AND d.suc_codigo = s.suc_codigo
               AND d.emp_codigo = s.emp_codigo
            JOIN unidad_medida um 
               ON um.unime_codigo = i.unime_codigo
            WHERE cd.comp_codigo = $comp_codigo
               and i.it_descripcion ilike '%$it_descripcion%'
               and i.it_estado = 'ACTIVO'
               and i.tipit_codigo not in (2, 3)

            UNION ALL

            -- Parte 2: los ítems de la nota de débito asociada
            SELECT
               ncd.dep_codigo,
               d.dep_descripcion,
               ncd.it_codigo,
               ncd.tipit_codigo,
               i.tipim_codigo,
               i.it_descripcion,
               ncd.nocomdet_cantidad AS cantidad,
               ncd.nocomdet_precio AS precio,
               i.unime_codigo,
               um.unime_descripcion
            FROM nota_compra_det ncd
            JOIN nota_compra_cab nc
               ON nc.nocom_codigo = ncd.nocom_codigo
            JOIN items i
               ON i.it_codigo = ncd.it_codigo
               AND i.tipit_codigo = ncd.tipit_codigo
            JOIN deposito d
               ON d.dep_codigo = ncd.dep_codigo
               AND d.suc_codigo = ncd.suc_codigo
               AND d.emp_codigo = ncd.emp_codigo
            JOIN unidad_medida um
               ON um.unime_codigo = i.unime_codigo
            WHERE nc.comp_codigo = $comp_codigo
               AND nc.tipco_codigo = 2 -- solo notas de débito
               and i.it_descripcion ilike '%$it_descripcion%'
               and i.it_estado = 'ACTIVO'
               and i.tipit_codigo not in (2, 3)
         )

         -- Agrupamos para sumar cantidades si el depósito es el mismo
         SELECT
            it_codigo,
            tipit_codigo,
            tipim_codigo,
            it_descripcion,
            dep_descripcion,
            dep_codigo,
            SUM(cantidad) AS nocomdet_cantidad,
            precio AS nocomdet_precio,
            unime_codigo,
            MAX(unime_descripcion) AS unime_descripcion
         FROM datos
         GROUP BY it_codigo, tipit_codigo, tipim_codigo, it_descripcion, dep_descripcion, nocomdet_precio, dep_codigo, unime_codigo
         ORDER BY it_codigo, dep_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

} else if ($tipco_codigo == 3) {

   //Si es remision filtramos el item por compra det
   //Establecemos y mostramos la consulta
   $sql = "select 
            cd.dep_codigo,
            d.dep_descripcion,
            cd.it_codigo,
            cd.tipit_codigo,
            i.tipim_codigo,
            i.it_descripcion,
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
            join deposito d on d.dep_codigo=s.dep_codigo
            and d.suc_codigo=s.suc_codigo
            and d.emp_codigo=s.emp_codigo 
            join unidad_medida um on um.unime_codigo=i.unime_codigo
         where cd.comp_codigo=$comp_codigo
            and i.it_descripcion ilike '%$it_descripcion%'
            and i.it_estado = 'ACTIVO'
            and i.tipit_codigo not in (2)
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
               i.it_costo as nocomdet_precio
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
               and i.tipit_codigo not in (2)
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