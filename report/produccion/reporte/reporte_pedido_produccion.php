<?php

//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$desde = $_GET['desde'];
$hasta = $_GET['hasta'];

$sql = "select 
            pcc.*,
            s.suc_descripcion,
            e.emp_razonsocial,
            u.usu_login 
         from pedido_compra_cab pcc
            join sucursal s on s.suc_codigo=pcc.suc_codigo
            and s.emp_codigo=pcc.emp_codigo
            join empresa e on e.emp_codigo=s.emp_codigo 
            join usuario u on u.usu_codigo=pcc.usu_codigo
         where pcc.pedco_fecha between '$desde' and '$hasta'
         order by pcc.pedco_codigo";

$resultado = pg_query($conexion, $sql);
$cabecera = pg_fetch_all($resultado);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Reporte Pedido Compra</title>
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
         width: 100px;
      }
   </style>
</head>

<body>
   <h3>8 DE DICIEMBRE</h3>

   <div class="caja">
      <h4>Pedidos de Compra</h4>
   </div>
   <?php

   foreach ($cabecera as $valor) {

      $nroPedido = $valor['pedco_codigo'];

      $sql2 = "select
               pcd.*,
               i.it_descripcion,
               ti.tipit_descripcion,
               (case i.tipim_codigo when 1 then pcd.pedcodet_cantidad * pcd.pedcodet_precio else 0 end) as grav5,
               (case i.tipim_codigo when 2 then pcd.pedcodet_cantidad * pcd.pedcodet_precio else 0 end) as grav10,
               (case i.tipim_codigo when 3 then pcd.pedcodet_cantidad * pcd.pedcodet_precio else 0 end) as exenta
            from pedido_compra_det pcd 
               join items i on i.it_codigo=pcd.it_codigo
               and i.tipit_codigo=pcd.tipit_codigo
               join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
               join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
            where pcd.pedco_codigo=$nroPedido
            order by pcd.pedco_codigo";

      $resultado2 = pg_query($conexion, $sql2);
      $detalle = pg_fetch_all($resultado2);

      ?>
      <table>
         <tr>
            <td class="cabecera">
               <p><b>N° Pedido: </b>
                  <?php echo $valor['pedco_codigo'] ?>
               </p>
               <p><b>Fecha:
                  </b>
                  <?php echo $valor['pedco_fecha'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>Usuario:</b>
                  <?php echo $valor['usu_login'] ?>
               </p>
               <p><b>Empresa:</b>
                  <?php echo $valor['emp_razonsocial'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>Sucursal:</b>
                  <?php echo $valor['suc_descripcion'] ?>
               </p>
               <p><b>Estado:</b>
                  <?php echo $valor['pedco_estado'] ?>
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

         foreach ($detalle as $valor2) {
            $totalExe += floatval($valor2['exenta']);
            $totalIva5 += floatval($valor2['grav5']);
            $totalIva10 += floatval($valor2['grav10']);

            ?>
            <tr>
               <td>
                  <?php echo $valor2['it_descripcion'] ?>
               </td>
               <td>
                  <?php echo $valor2['tipit_descripcion'] ?>
               </td>
               <td>
                  <?php echo $valor2['pedcodet_cantidad'] ?>
               </td>
               <td>
                  <?php echo $valor2['pedcodet_precio'] ?>
               </td>
               <td>
                  <?php echo $valor2['exenta'] ?>
               </td>
               <td>
                  <?php echo $valor2['grav5'] ?>
               </td>
               <td>
                  <?php echo $valor2['grav10'] ?>
               </td>
            </tr>
         <?php }
         $totalGeneral = $totalExe + $totalIva5 + $totalIva10;
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

$dompdf->stream("reporte_pedido_compra.pdf", array('Attachment' => false));

?>