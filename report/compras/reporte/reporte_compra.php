<?php

//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$desde = $_GET['desde'];
$hasta = $_GET['hasta'];

$sql = "select 
         cc.*,
         p.pro_razonsocial,
         tp.tipro_descripcion,
         s.suc_descripcion,
         e.emp_razonsocial,
         u.usu_login,
         oc.orcom_codigo
      from compra_cab cc
         join orden_compra oc on oc.comp_codigo=cc.comp_codigo
         join proveedor p on p.pro_codigo=cc.pro_codigo
         and p.tipro_codigo=cc.tipro_codigo
         join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
         join usuario u on u.usu_codigo=cc.usu_codigo
         join sucursal s on s.suc_codigo=cc.suc_codigo
         and s.emp_codigo=cc.emp_codigo
         join empresa e on e.emp_codigo=s.emp_codigo
         where cc.comp_fecha between '$desde' and '$hasta'
      order by cc.comp_codigo";

$resultado = pg_query($conexion, $sql);
$cabecera = pg_fetch_all($resultado);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Reporte Compra</title>
   <style>
      .caja {
         border: 1px solid #009688;
         background-color: #009688;
         padding-left: 5px;
         display: block;
         border-radius: 10px;
         color: white;
      }

      .encabezado,
      .sub,
      .tot {
         color: white;
      }

      body {
         font-family: 'Times New Roman', Times, serif;
      }

      table {
         width: 100%;
         border-collapse: collapse;
         page-break-inside: avoid;
      }

      h3 {
         text-align: center;
      }

      h4 {
         text-align: left;
      }

      th,
      td {
         padding: 8px;
         text-align: left;
         border: 1px solid #ddd;
      }

      th,
      .sub,
      .tot {
         background-color: #009688;
      }

      .cabecera {
         border: none;
      }
   </style>
</head>

<body>
   <h3>8 DE DICIEMBRE</h3>

   <div class="caja">
      <h4>Compras</h4>
   </div>
   <?php

   foreach ($cabecera as $valor) {

      $nroCompra = $valor['comp_codigo'];

      $sql2 = "select 
                  cd.*,
                  i.it_descripcion,
                  d.dep_descripcion,
                  su.suc_descripcion,
                  e.emp_razonsocial,
                  um.unime_descripcion,
                  (case i.tipim_codigo when 1 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as grav5,
                  (case i.tipim_codigo when 2 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as grav10,
                  (case i.tipim_codigo when 3 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as exenta
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
                  join sucursal su on su.suc_codigo=d.suc_codigo
                  and su.emp_codigo=d.emp_codigo
                  join empresa e on e.emp_codigo=su.emp_codigo
                  join unidad_medida um on um.unime_codigo=s.unime_codigo
                  where cd.comp_codigo=$nroCompra
               order by cd.comp_codigo";

      $resultado2 = pg_query($conexion, $sql2);
      $detalle = pg_fetch_all($resultado2);

      ?>
      <table>
         <tr>
            <td class="cabecera">
               <p><b>N° Compra: </b>
                  <?php echo $valor['comp_codigo'] ?>
               </p>
               <p><b>Fecha:
                  </b>
                  <?php echo $valor['comp_fecha'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>N° Orden:</b>
                  <?php echo $valor['orcom_codigo'] ?>
               </p>
               <p><b>N° Factura:
                  </b>
                  <?php echo $valor['com_numfactura'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>Tipo Factura:</b>
                  <?php echo $valor['comp_tipofactura'] ?>
               </p>
               <p><b>Cuota:</b>
                  <?php echo $valor['comp_cuota'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>Intervalo:</b>
                  <?php echo $valor['comp_interfecha'] ?>
               </p>
               <p><b>Proveedor:</b>
                  <?php echo $valor['pro_razonsocial'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>Tipo Proveedor:</b>
                  <?php echo $valor['tipro_descripcion'] ?>
               </p>
               <p><b>Empresa:</b>
                  <?php echo $valor['emp_razonsocial'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>Sucursal:</b>
                  <?php echo $valor['suc_descripcion'] ?>
               </p>
               <p><b>Usuario:</b>
                  <?php echo $valor['usu_login'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>Estado:</b>
                  <?php echo $valor['comp_estado'] ?>
               </p>
            </td>
         </tr>
         <tr class="encabezado">
            <th>ITEM</th>
            <th>DEPOSITO</th>
            <th>EMPRESA</th>
            <th>SUCURSAL</th>
            <th>CANTIDAD</th>
            <th>UNIDAD MEDIDA</th>
            <th>PRECIO</th>
            <th>EXENTA</th>
            <th>IVA 5%</th>
            <th>IVA 10%</th>
         </tr>
         <?php

         $totalExe = 0;
         $totalIva5 = 0;
         $totalIva10 = 0;
         $totalGeneral = 0;
         $iva5 = 0;
         $iva10 = 0;

         foreach ($detalle as $valor2) {
            $totalExe += floatval($valor2['exenta']);
            $totalIva5 += floatval($valor2['grav5']);
            if ($valor2['tipit_codigo'] == '3') {
               $totalIva10 += floatval($valor2['compdet_precio']);
            } else {
               $totalIva10 += floatval($valor2['grav10']);
            }
            ?>
            <tr>
               <td>
                  <?php echo $valor2['it_descripcion'] ?>
               </td>
               <td>
                  <?php echo $valor2['dep_descripcion'] ?>
               </td>
               <td>
                  <?php echo $valor2['emp_razonsocial'] ?>
               </td>
               <td>
                  <?php echo $valor2['suc_descripcion'] ?>
               </td>
               <td>
                  <?php echo $valor2['compdet_cantidad'] ?>
               </td>
               <td>
                  <?php echo $valor2['unime_descripcion'] ?>
               </td>
               <td>
                  <?php echo $valor2['compdet_precio'] ?>
               </td>
               <td>
                  <?php echo $valor2['exenta'] ?>
               </td>
               <td>
                  <?php echo $valor2['grav5'] ?>
               </td>
               <?php if ($valor2['tipit_codigo'] == '3') { ?>
                  <td>
                     <?php echo $valor2['compdet_precio'] ?>
                  </td>
               <?php } else { ?>
                  <td>
                     <?php echo $valor2['grav10'] ?>
                  </td>
               <?php } ?>
            </tr>
         <?php }
         $iva5 = $totalIva5 / 21;
         $iva10 = $totalIva10 / 11;
         $totalGeneral = $totalExe + $totalIva5 + $totalIva10;
         $totalIva = $iva5 + $iva10;
         $numeroComa = number_format($totalIva, 2, ',', '');
         ?>
         <tr>
            <td colspan="7"><strong>SUBTOTALES</strong></td>
            <td>
               <?php echo $totalExe ?>
            </td>
            <td>
               <?php echo $totalIva5 ?>
            </td>
            <td>
               <?php echo $totalIva10 ?>
            </td>
         </tr>
         <tr>
            <td colspan="8"><strong>LIQUIDACION IVA</strong></td>
            <td>
               <?php echo number_format($iva5, 2, ',', ''); ?>
            </td>
            <td>
               <?php echo number_format($iva10, 2, ',', ''); ?>
            </td>
         </tr>
         <tr class="tot">
            <td colspan="9"><strong>TOTAL IVA</strong></td>
            <td>
               <?php echo $numeroComa; ?>
            </td>
         </tr>
         <tr class="tot">
            <td colspan="9"><strong>TOTAL GENERAL</strong></td>
            <td>
               <?php echo $totalGeneral ?>
            </td>
         </tr>
      </table>
   <?php } ?>
</body>

</html>

<?php

$html = ob_get_clean();

require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/vendor/autoload.php";

use Dompdf\Dompdf;

$dompdf = new Dompdf();

$dompdf->loadHtml($html);

$dompdf->setPaper('A4', 'landscape'); //portrait -> vertical landscape -> horizontal

$dompdf->render();

$dompdf->stream("reporte_orden_compra.pdf", array('Attachment' => false));

?>