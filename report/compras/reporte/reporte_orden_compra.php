<?php

//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$desde = $_GET['desde'];
$hasta = $_GET['hasta'];

$sql = "select 
         occ.*,
         u.usu_login,
         p.pro_razonsocial,
         tp.tipro_descripcion,
         s.suc_descripcion,
         e.emp_razonsocial,
         po.prepro_codigo,
         pepre.pedco_codigo
      from orden_compra_cab occ
         join usuario u on u.usu_codigo=occ.usu_codigo
         join proveedor p on p.pro_codigo=occ.pro_codigo
         and p.tipro_codigo=occ.tipro_codigo
         join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
         join sucursal s on s.suc_codigo=occ.suc_codigo
         and s.emp_codigo=occ.emp_codigo
         join empresa e on e.emp_codigo=s.emp_codigo
         join presupuesto_orden po on po.orcom_codigo=occ.orcom_codigo
         join pedido_presupuesto pepre on pepre.prepro_codigo=po.prepro_codigo
         where occ.orcom_fecha between '$desde' and '$hasta'
      order by occ.orcom_codigo";

$resultado = pg_query($conexion, $sql);
$cabecera = pg_fetch_all($resultado);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Reporte Orden Compra</title>
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
      <h4>Ordenes de Compra</h4>
   </div>
   <?php

   foreach ($cabecera as $valor) {

      $nroOrden = $valor['orcom_codigo'];

      $sql2 = "select 
               ocd.*,
               i.it_descripcion,
               ti.tipit_descripcion,
               (case i.tipim_codigo when 1 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as grav5,
               (case i.tipim_codigo when 2 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as grav10,
               (case i.tipim_codigo when 3 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as exenta
            from orden_compra_det ocd
               join items i on i.it_codigo=ocd.it_codigo 
               and i.tipit_codigo=ocd.tipit_codigo
               join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
               join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
               where ocd.orcom_codigo=$nroOrden
            order by ocd.orcom_codigo";

      $resultado2 = pg_query($conexion, $sql2);
      $detalle = pg_fetch_all($resultado2);

      ?>
      <table>
         <tr>
            <td class="cabecera">
               <p><b>N° Orden: </b>
                  <?php echo $valor['orcom_codigo'] ?>
               </p>
               <p><b>Fecha:
                  </b>
                  <?php echo $valor['orcom_fecha'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>N° Presupuesto:</b>
                  <?php echo $valor['prepro_codigo'] ?>
               </p>
               <p><b>Condicion Pago:
                  </b>
                  <?php echo $valor['orcom_condicionpago'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>Cuota:</b>
                  <?php echo $valor['orcom_cuota'] ?>
               </p>
               <p><b>Intervalo:</b>
                  <?php echo $valor['orcom_interfecha'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>Usuario:</b>
                  <?php echo $valor['usu_login'] ?>
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
               </p>
               <p><b>Estado:</b>
                  <?php echo $valor['orcom_estado'] ?>
               </p>
            </td>
         </tr>
         <tr class="encabezado">
            <th>ITEM</th>
            <th>TIPO ITEM</th>
            <th>CANTIDAD</th>
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
               $totalIva10 += floatval($valor2['orcomdet_precio']);
            } else {
               $totalIva10 += floatval($valor2['grav10']);
            }
            ?>
            <tr>
               <td>
                  <?php echo $valor2['it_descripcion'] ?>
               </td>
               <td>
                  <?php echo $valor2['tipit_descripcion'] ?>
               </td>
               <td>
                  <?php echo $valor2['orcomdet_cantidad'] ?>
               </td>
               <td>
                  <?php echo $valor2['orcomdet_precio'] ?>
               </td>
               <td>
                  <?php echo $valor2['exenta'] ?>
               </td>
               <td>
                  <?php echo $valor2['grav5'] ?>
               </td>
               <?php if ($valor2['tipit_codigo'] == '3') { ?>
                  <td>
                     <?php echo $valor2['orcomdet_precio'] ?>
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
            <td colspan="4"><strong>SUBTOTALES</strong></td>
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
            <td colspan="5"><strong>LIQUIDACION IVA</strong></td>
            <td>
               <?php echo number_format($iva5, 2, ',', ''); ?>
            </td>
            <td>
               <?php echo number_format($iva10, 2, ',', ''); ?>
            </td>
         </tr>
         <tr class="tot">
            <td colspan="6"><strong>TOTAL IVA</strong></td>
            <td>
               <?php echo $numeroComa; ?>
            </td>
         </tr>
         <tr class="tot">
            <td colspan="6"><strong>TOTAL GENERAL</strong></td>
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

$dompdf->setPaper('A4', 'portrait'); //portrait -> vertical landscape -> horizontal

$dompdf->render();

$dompdf->stream("reporte_orden_compra.pdf", array('Attachment' => false));

?>