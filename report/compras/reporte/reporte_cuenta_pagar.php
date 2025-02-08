<?php

//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$desde = $_GET['desde'];
$hasta = $_GET['hasta'];

$sql = "select
            cb.comp_codigo,
            cb.comp_fecha,
            cb.com_numfactura,
            cb.comp_tipofactura,
	         cb.comp_interfecha,
            p.pro_razonsocial,
            tp.tipro_descripcion,
            s.suc_descripcion,
            e.emp_razonsocial,
            u.usu_login
         from 
            compra_cab cb
            join proveedor p on p.pro_codigo=cb.pro_codigo
            and p.tipro_codigo=cb.tipro_codigo
            join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
            join sucursal s on s.suc_codigo=cb.suc_codigo
            and s.emp_codigo=cb.emp_codigo
            join empresa e on e.emp_codigo=s.emp_codigo
            join usuario u on u.usu_codigo=cb.usu_codigo
            join funcionario f on f.func_codigo=u.func_codigo
            join personas pe on pe.per_codigo=f.per_codigo
            where cb.comp_fecha between '$desde' and '$hasta'
         order by cb.comp_codigo";

$resultado = pg_query($conexion, $sql);
$cabecera = pg_fetch_all($resultado);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Reporte Cuentas a Pagar</title>
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
      <h4>Cuentas a Pagar</h4>
   </div>
   <?php

   foreach ($cabecera as $valor) {

      $nroCompra = $valor['comp_codigo'];

      $sql2 = "select 
                  cp.cuenpa_nrocuota,
                  cp.cuenpa_montototal,
                  cp.cuenpa_montosaldo,
                  cp.cuenpa_estado,
	               cb.comp_interfecha
               from 
                  cuenta_pagar cp
                  join compra_cab cb on cb.comp_codigo=cp.comp_codigo
                  where cp.comp_codigo = $nroCompra
               order by cp.comp_codigo";

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
               <p><b>Empresa:</b>
                  <?php echo $valor['emp_razonsocial'] ?>
               </p>
               <p><b>Sucursal:</b>
                  <?php echo $valor['suc_descripcion'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>Proveedor:</b>
                  <?php echo $valor['pro_razonsocial'] ?>
               </p>
               <p><b>Tipo Proveedor:</b>
                  <?php echo $valor['tipro_descripcion'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>N° Factura:</b>
                  <?php echo $valor['com_numfactura'] ?>
               </p>
               <p><b>Tipo Factura:</b>
                  <?php echo $valor['comp_tipofactura'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>Usuario:</b>
                  <?php echo $valor['usu_login'] ?>
               </p>
            </td>
         </tr>
         <tr class="encabezado">
            <th>N° DE CUOTAS</th>
            <th>INTERVALO</th>
            <th>MONTO TOTAL</th>
            <th>MONTO SALDO</th>
            <th>ESTADO</th>
         </tr>
         <?php

         foreach ($detalle as $valor2) {

            ?>
            <tr>
               <td>
                  <?php echo $valor2['cuenpa_nrocuota'] ?>
               </td>
               <td>
                  <?php echo $valor2['comp_interfecha'] ?>
               </td>
               <td>
                  <?php echo $valor2['cuenpa_montototal'] ?>
               </td>
               <td>
                  <?php echo $valor2['cuenpa_montosaldo'] ?>
               </td>
               <td>
                  <?php echo $valor2['cuenpa_estado'] ?>
               </td>
            </tr>
         <?php }
         ?>
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

$dompdf->stream("reporte_cuenta_pagar.pdf", array('Attachment' => false));

?>