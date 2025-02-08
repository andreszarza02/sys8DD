<?php

//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$desde = $_GET['desde'];
$hasta = $_GET['hasta'];

$sql = "select 
         aic.*,
         u.usu_login,
         e.emp_razonsocial,
         s.suc_descripcion
      from ajuste_inventario_cab aic
         join usuario u on u.usu_codigo=aic.usu_codigo
         join sucursal s on s.suc_codigo=aic.suc_codigo
         and s.emp_codigo=aic.emp_codigo
         join empresa e on e.emp_codigo=s.emp_codigo
      where aic.ajuin_fecha between '$desde' and '$hasta'
      order by aic.ajuin_codigo";

$resultado = pg_query($conexion, $sql);
$cabecera = pg_fetch_all($resultado);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Reporte Ajuste Inventario</title>
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
      <h4>Ajustes de Inventario</h4>
   </div>
   <?php

   foreach ($cabecera as $valor) {

      $nroAjuste = $valor['ajuin_codigo'];

      $sql2 = "select
                  aid.*,
                  i.it_descripcion,
                  ti.tipit_descripcion,
                  d.dep_descripcion,
                  su.suc_descripcion,
                  e.emp_razonsocial,
                  um.unime_descripcion
               from ajuste_inventario_det aid
                  join stock s on s.it_codigo=aid.it_codigo
                  and s.tipit_codigo=aid.tipit_codigo and
                  s.dep_codigo=aid.dep_codigo and s.suc_codigo=aid.suc_codigo
                  and s.emp_codigo=aid.emp_codigo
                  join items i on i.it_codigo=s.it_codigo 
                  and i.tipit_codigo=s.tipit_codigo 
                  join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
                  join deposito d on d.dep_codigo=s.dep_codigo and
                  d.suc_codigo=s.suc_codigo and d.emp_codigo=s.emp_codigo 
                  join sucursal su on su.suc_codigo=d.suc_codigo 
                  and su.emp_codigo=d.emp_codigo
                  join empresa e on e.emp_codigo=su.emp_codigo
                  join unidad_medida um on um.unime_codigo=s.unime_codigo
                  where aid.ajuin_codigo=$nroAjuste
               order by aid.ajuin_codigo;";

      $resultado2 = pg_query($conexion, $sql2);
      $detalle = pg_fetch_all($resultado2);

      ?>
      <table>
         <tr>
            <td class="cabecera">
               <p><b>N° Ajuste: </b>
                  <?php echo $valor['ajuin_codigo'] ?>
               </p>
               <p><b>Fecha:
                  </b>
                  <?php echo $valor['ajuin_fecha'] ?>
               </p>
            </td>
            <td class="cabecera">
               <p><b>Tipo Ajuste:</b>
                  <?php echo $valor['ajuin_tipoajuste'] ?>
               </p>
               <p><b>Usuario:</b>
                  <?php echo $valor['usu_login'] ?>
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
               <p><b>Estado:</b>
                  <?php echo $valor['ajuin_estado'] ?>
               </p>
            </td>
         </tr>
         <tr class="encabezado">
            <th>ITEM</th>
            <th>TIPO ITEM</th>
            <th>DEPOSITO</th>
            <th>CANTIDAD</th>
            <th>SUCURSAL</th>
            <th>MOTIVO</th>
         </tr>
         <?php

         foreach ($detalle as $valor2) {

            ?>
            <tr>
               <td>
                  <?php echo $valor2['it_descripcion'] ?>
               </td>
               <td>
                  <?php echo $valor2['tipit_descripcion'] ?>
               </td>
               <td>
                  <?php echo $valor2['dep_descripcion'] ?>
               </td>
               <td>
                  <?php echo $valor2['ajuindet_cantidad'] ?>
               </td>
               <td>
                  <?php echo $valor2['suc_descripcion'] ?>
               </td>
               <td>
                  <?php echo $valor2['ajuindet_motivo'] ?>
               </td>
            </tr>
         <?php } ?>
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

$dompdf->stream("reporte_ajuste_inventario.pdf", array('Attachment' => false));

?>