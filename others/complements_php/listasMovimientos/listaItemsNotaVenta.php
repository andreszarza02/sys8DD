<?php

//Retorno JSON
header('Content-type: application/json; charset=utf-8');

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion  
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$it_descripcion = pg_escape_string($conexion, $_POST['it_descripcion']);
$tipco_descripcion = pg_escape_string($conexion, $_POST['tipco_descripcion']);
$ven_codigo = $_POST['ven_codigo'] ?? 0;
$dep_codigo = $_POST['dep_codigo'] ?? 0;
$emp_codigo = $_POST['emp_codigo'] ?? 0;
$suc_codigo = $_POST['suc_codigo'] ?? 0;

//Validamos los tipos de comprobantes 
if ($tipco_descripcion == "CREDITO") {

   //Establecemos y mostramos la consulta
   $sql = "
            WITH datos AS (
               -- Parte 1: Ítems de la venta
               SELECT 
                  vd.dep_codigo,
                  d.dep_descripcion,
                  vd.it_codigo,
                  vd.tipit_codigo,
                  ti.tipit_descripcion,
                  i.tipim_codigo,
                  CASE 
                        WHEN ti.tipit_descripcion = 'PRODUCTO'
                           THEN i.it_descripcion || ' ' || m.mod_codigomodelo
                        ELSE i.it_descripcion 
                  END AS it_descripcion,
                  CASE 
                        WHEN ti.tipit_descripcion = 'PRODUCTO'
                           THEN '<b>PRODUCTO:</b> ' || i.it_descripcion || ' <b>MODELO:</b> ' || m.mod_codigomodelo || ' <b>TALLE:</b> ' || t.tall_descripcion 
                        ELSE '<b>SERVICIO: </b>' || i.it_descripcion 
                  END AS it_descripcion2,
                  t.tall_descripcion,
                  vd.vendet_cantidad AS notvendet_cantidad,
                  um.unime_descripcion,
                  vd.vendet_precio AS notvendet_precio
               FROM venta_det vd
               JOIN venta_cab vc ON vc.ven_codigo = vd.ven_codigo
               JOIN stock s ON s.it_codigo = vd.it_codigo 
                  AND s.tipit_codigo = vd.tipit_codigo 
                  AND s.dep_codigo = vd.dep_codigo
                  AND s.suc_codigo = vd.suc_codigo 
                  AND s.emp_codigo = vd.emp_codigo 
               JOIN items i ON i.it_codigo = s.it_codigo AND i.tipit_codigo = s.tipit_codigo 
               JOIN tipo_item ti ON ti.tipit_codigo = i.tipit_codigo 
               JOIN talle t ON t.tall_codigo = i.tall_codigo 
               JOIN modelo m ON m.mod_codigo = i.mod_codigo 
               JOIN unidad_medida um ON um.unime_codigo = i.unime_codigo 
               JOIN deposito d ON d.dep_codigo = s.dep_codigo 
                  AND d.suc_codigo = s.suc_codigo 
                  AND d.emp_codigo = s.emp_codigo 
               JOIN sucursal s2 ON s2.suc_codigo = d.suc_codigo AND s2.emp_codigo = d.emp_codigo 
               JOIN empresa e ON e.emp_codigo = s2.emp_codigo 
               WHERE ti.tipit_descripcion IN ('PRODUCTO', 'SERVICIO')
                  AND (
                     i.it_descripcion ILIKE '%$it_descripcion%' 
                     OR m.mod_codigomodelo ILIKE '%$it_descripcion%'
                     OR t.tall_descripcion ILIKE '%$it_descripcion%'
                  )
                  AND vc.ven_codigo = $ven_codigo
                  AND vc.ven_estado <> 'ANULADO'
                  AND vc.suc_codigo = $suc_codigo 
                  AND vc.emp_codigo = $emp_codigo

               UNION ALL

               -- Parte 2: Ítems de la nota de débito
               SELECT 
                  nvd.dep_codigo,
                  d.dep_descripcion,
                  nvd.it_codigo,
                  nvd.tipit_codigo,
                  ti.tipit_descripcion,
                  i.tipim_codigo,
                  CASE 
                        WHEN ti.tipit_descripcion = 'PRODUCTO'
                           THEN i.it_descripcion || ' ' || m.mod_codigomodelo
                        ELSE i.it_descripcion 
                  END AS it_descripcion,
                  CASE 
                        WHEN ti.tipit_descripcion = 'PRODUCTO'
                           THEN '<b>PRODUCTO:</b> ' || i.it_descripcion || ' <b>MODELO:</b> ' || m.mod_codigomodelo || ' <b>TALLE:</b> ' || t.tall_descripcion 
                        ELSE '<b>SERVICIO: </b>' || i.it_descripcion 
                  END AS it_descripcion2,
                  t.tall_descripcion,
                  nvd.notvendet_cantidad,
                  um.unime_descripcion,
                  nvd.notvendet_precio
               FROM nota_venta_det nvd
               JOIN nota_venta_cab nvc ON nvc.notven_codigo = nvd.notven_codigo
               JOIN venta_cab vc ON vc.ven_codigo = nvc.ven_codigo 
               JOIN items i ON i.it_codigo = nvd.it_codigo AND i.tipit_codigo = nvd.tipit_codigo 
               JOIN tipo_item ti ON ti.tipit_codigo = i.tipit_codigo 
               JOIN talle t ON t.tall_codigo = i.tall_codigo 
               JOIN modelo m ON m.mod_codigo = i.mod_codigo 
               JOIN unidad_medida um ON um.unime_codigo = i.unime_codigo 
               JOIN deposito d ON d.dep_codigo = nvd.dep_codigo 
                  AND d.suc_codigo = nvd.suc_codigo 
                  AND d.emp_codigo = nvd.emp_codigo 
               JOIN sucursal s2 ON s2.suc_codigo = d.suc_codigo AND s2.emp_codigo = d.emp_codigo 
               JOIN empresa e ON e.emp_codigo = s2.emp_codigo 
               WHERE ti.tipit_descripcion IN ('PRODUCTO', 'SERVICIO')
                  AND (
                     i.it_descripcion ILIKE '%$it_descripcion%' 
                     OR m.mod_codigomodelo ILIKE '%$it_descripcion%'
                     OR t.tall_descripcion ILIKE '%$it_descripcion%'
                  )
                  AND vc.ven_codigo = $ven_codigo
                  AND vc.ven_estado <> 'ANULADO'
                  AND vc.suc_codigo = $suc_codigo 
                  AND vc.emp_codigo = $emp_codigo
                  AND nvc.tipco_codigo = 2
            )
            SELECT
               dep_codigo,
               dep_descripcion,
               it_codigo,
               tipit_codigo,
               tipit_descripcion,
               tipim_codigo,
               it_descripcion,
               it_descripcion2,
               tall_descripcion,
               unime_descripcion,
               SUM(notvendet_cantidad) AS notvendet_cantidad,
               notvendet_precio
            FROM datos
            GROUP BY dep_codigo, dep_descripcion, it_codigo, tipit_codigo, tipit_descripcion, tipim_codigo, it_descripcion, it_descripcion2, tall_descripcion, unime_descripcion, notvendet_precio
            ORDER BY it_codigo;
            ";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

} else if ($tipco_descripcion == "REMISION") {

   //Establecemos y mostramos la consulta
   $sql = "select 
            vd.dep_codigo,
            vd.it_codigo,
            vd.tipit_codigo,
            ti.tipit_descripcion,
            i.tipim_codigo,
            (case 
                  ti.tipit_descripcion 
               when 'PRODUCTO'
                     then 
                        i.it_descripcion||' '||m.mod_codigomodelo
                     else 
                        i.it_descripcion 
            end) it_descripcion,
            (case 
                  ti.tipit_descripcion 
               when 'PRODUCTO'
                     then 
                        '<b>PRODUCTO:</b> '||i.it_descripcion||' <b>MODELO:</b>' ||m.mod_codigomodelo||' <b>TALLE:</b> '||t.tall_descripcion 
                     else 
                        '<b>SERVICIO: </b>'||i.it_descripcion 
            end) it_descripcion2,
            t.tall_descripcion,
            vd.vendet_cantidad notvendet_cantidad,
            um.unime_descripcion,
            vd.vendet_precio as notvendet_precio
            from venta_det vd 
               join venta_cab vc on vc.ven_codigo=vd.ven_codigo 
               join stock s on s.it_codigo=vd.it_codigo 
               and s.tipit_codigo=vd.tipit_codigo 
               and s.dep_codigo=vd.dep_codigo
               and s.suc_codigo=vd.suc_codigo 
               and s.emp_codigo=vd.emp_codigo 
               join items i on i.it_codigo=s.it_codigo 
               and i.tipit_codigo=s.tipit_codigo 
                  join tipo_item ti on ti.tipit_codigo=i.tipit_codigo 
                  join talle t on t.tall_codigo=i.tall_codigo 
                  join modelo m on m.mod_codigo=i.mod_codigo 
                  join unidad_medida um on um.unime_codigo=i.unime_codigo 
               join deposito d on d.dep_codigo=s.dep_codigo 
               and d.suc_codigo=s.suc_codigo 
               and d.emp_codigo=s.emp_codigo 
                  join sucursal s2 on s2.suc_codigo=d.suc_codigo 
                  and s2.emp_codigo=d.emp_codigo 
                     join empresa e on e.emp_codigo=s2.emp_codigo 
            where ti.tipit_descripcion in('PRODUCTO', 'SERVICIO')
               and (i.it_descripcion ilike '%$it_descripcion%' 
               or m.mod_codigomodelo ilike '%$it_descripcion%'
               or t.tall_descripcion ilike '%$it_descripcion%')
               and vc.ven_codigo=$ven_codigo
               and vc.ven_estado <> 'ANULADO'
               and vc.suc_codigo=$suc_codigo 
               and vc.emp_codigo=$emp_codigo
            order by vd.ven_codigo, vd.it_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

} else {

   //Si no es ni crédito ni remision es debito

   //Procedemos a establecer y realizar una consulta
   $sql = "select 
               i.it_codigo,
               i.tipit_codigo,
               ti.tipit_descripcion,
               i.tipim_codigo,
               (case 
                     ti.tipit_descripcion 
                  when 'PRODUCTO'
                     then 
                           i.it_descripcion||' '||m.mod_codigomodelo
                        else 
                           i.it_descripcion 
               end) it_descripcion,
               (case 
                     ti.tipit_descripcion 
                  when 'PRODUCTO'
                     then 
                        '<b>PRODUCTO:</b> '||i.it_descripcion||' <b>MODELO:</b>' ||m.mod_codigomodelo||' <b>TALLE:</b> '||t.tall_descripcion 
                     else 
                        '<b>SERVICIO: </b>'||i.it_descripcion 
               end) it_descripcion2,
               t.tall_descripcion,
               (case 
                  when ti.tipit_descripcion='PRODUCTO' and s.st_cantidad<=0
                     then 
                           'NO HAY STOCK'
                        else 
                           CAST(s.st_cantidad AS VARCHAR)
               end) notvendet_cantidad,
               um.unime_descripcion,
               i.it_precio as notvendet_precio
            from stock s 
            join items i on i.it_codigo=s.it_codigo 
            and i.tipit_codigo=s.tipit_codigo 
               join tipo_item ti on ti.tipit_codigo=i.tipit_codigo 
               join talle t on t.tall_codigo=i.tall_codigo 
               join modelo m on m.mod_codigo=i.mod_codigo 
               join unidad_medida um on um.unime_codigo=i.unime_codigo 
            join deposito d on d.dep_codigo=s.dep_codigo 
            and d.suc_codigo=s.suc_codigo 
            and d.emp_codigo=s.emp_codigo 
               join sucursal s2 on s2.suc_codigo=d.suc_codigo 
               and s2.emp_codigo=d.emp_codigo 
                  join empresa e on e.emp_codigo=s2.emp_codigo 
            where i.it_estado='ACTIVO'
            and ti.tipit_descripcion in('PRODUCTO', 'SERVICIO')
            and (i.it_descripcion ilike '%$it_descripcion%' 
            or m.mod_codigomodelo ilike '%$it_descripcion%'
            or t.tall_descripcion ilike '%$it_descripcion%')
            and s.dep_codigo=$dep_codigo 
            and s.suc_codigo=$suc_codigo 
            and s.emp_codigo=$emp_codigo
            order by i.it_codigo;";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);

}

//validamos si se encontro algun valor
if (!isset($datos[0]['it_codigo'])) {
   $datos = [['dato1' => 'NSE', 'dato2' => 'NO SE ENCUENTRA']];
}

echo json_encode($datos);

?>