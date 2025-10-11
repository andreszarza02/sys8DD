<?php

//Requerimos conexion 
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

// Creamos una instancia de conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

// Definimos variables a utilizar
$ven_codigo = $_GET['ven_codigo'] ?? 0;

$contador = 0;
$totalIva10 = 0;
$totalIva5 = 0;
$totalExenta = 0;
$iva10 = 0;
$iva5 = 0;
$totalGral = 0;
$totalIva = 0;
$enlace = "DE";

$sql = "select 
               vc.ven_timbrado,
               to_char((select distinct ta.timb_numero_fecha_inic from timbrados_auditoria ta 
               where ta.timb_numero=cast(vc.ven_timbrado as integer)) , 'DD-MM-YYYY') as ven_timbrado_inic,
               to_char(vc.ven_timbrado_venc , 'DD-MM-YYYY') ven_timbrado_venc,
               e.emp_ruc,
               vc.ven_numfactura,
               e.emp_razonsocial,
               e.emp_actividad,
               s.suc_descripcion,
               s.suc_direccion,
               s.suc_telefono,
               c.ciu_descripcion||' - '||'PARAGUAY' as ciu_descripcion,
               UPPER(to_char(vc.ven_fecha ,'DD \"de\" TMMonth \"de\" YYYY')) as ven_fecha,
               vc.ven_tipofactura,
               p.per_nombre||' '||p.per_apellido as cliente,
               p.per_numerodocumento,
               c2.cli_direccion,
               p.per_telefono
            from venta_cab vc 
               join sucursal s on s.suc_codigo=vc.suc_codigo
               and s.emp_codigo=vc.emp_codigo 
                  join empresa e on e.emp_codigo=s.emp_codigo 
               join ciudad c on c.ciu_codigo=s.ciu_codigo 
               join cliente c2 on c2.cli_codigo=vc.cli_codigo 
                  join personas p on p.per_codigo=c2.per_codigo 
            where vc.ven_codigo = $ven_codigo;";

$resultado = pg_query($conexion, $sql);
$cabecera = pg_fetch_assoc($resultado);

$sql2 = "select 
            vvd.tipit_codigo,
            (case
               when vvd.vendet_cantidad = 0 then '-'
               else cast(vvd.vendet_cantidad as varchar)
            end) as vendet_cantidad,
            (case
               when vvd.tipit_codigo = 3 then vvd.item 
               else vvd.item||'; TALLE '||vvd.tall_descripcion
            end) as it_descripcion,
            vvd.vendet_precio,
            vvd.grav5,
            vvd.grav10,
            vvd.exenta 
         from v_venta_det vvd 
         where vvd.ven_codigo=$ven_codigo;";

$resultado2 = pg_query($conexion, $sql2);
$detalle = pg_fetch_all($resultado2);

//Creamos una instancia de la clase NumberForamtter
$formatter = new NumberFormatter('es', NumberFormatter::SPELLOUT);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="es">

<head>
   <meta charset="utf-8" />
   <meta name="viewport" content="width=device-width,initial-scale=1" />
   <title>Factura - Formato</title>
   <style>
      * {
         box-sizing: border-box;
         margin: 0;
         padding: 0;
      }

      body {
         font-family: "Arial", "Helvetica", sans-serif;
         color: #000;
         background: #fff;
         padding: 20px;
      }

      .factura {
         width: 97%;
         /* A4 width */
         max-width: 100%;
         margin: 0px;
         border: 1px solid #000;
         padding: 10px;
      }

      /* Encabezado principal: se arma con una tabla para evitar grid/flex */
      .hdr {
         width: 100%;
         border-collapse: collapse;
         margin: 10px 0px;
      }

      .hdr td {
         vertical-align: top;
      }

      .empresa {
         padding-left: 8px;
         font-size: 12px;
         line-height: 1.88;
         border: 1px solid #000;
         border-radius: 8px;
         padding: 8px 8px;
      }

      .timbrado {
         width: 48%;
         padding-left: 20px;
      }

      .timbrado .box {
         display: inline-block;
         border: 1px solid #000;
         border-radius: 8px;
         padding: 17px;
         text-align: center;
         width: 300px;
         font-size: 11px;
         line-height: 1;
      }

      .timbrado .box .title {
         font-weight: 700;
         letter-spacing: 1px;
      }

      /* Datos del receptor y fecha */
      .info {
         width: 100%;
         border-collapse: collapse;
         margin: 16px 5px 12px;
      }

      .cliente {
         border: 1px solid #000;
         border-radius: 8px;
      }

      .info td {
         padding: 6px;
         font-size: 12px;
      }

      .info .label {
         width: 18%;
         font-weight: 700;
         text-align: left;
         padding-left: 8px;
      }

      .info .value {
         text-align: left;
         padding-left: 5px;
         max-width: 18%;
         white-space: nowrap;
         /* borde con puntos */
      }

      /* Tabla de conceptos (celdas con lineas horizontales como en la imagen) */
      .items {
         width: 100%;
         border-collapse: collapse;
         font-size: 12px;
         margin-top: 10px;
      }

      .items thead th {
         border: 1px solid #000;
         background: #efefef;
         padding: 6px;
         text-align: center;
         font-weight: 700;
      }

      .items tbody td {
         border-bottom: 1px solid #000;
         border-top: 1px solid #000;
         border-left: 1px solid #000;
         border-right: 1px solid #000;
         padding: 6px;
         vertical-align: top;
      }


      /* Column widths aproximadas para 6 columnas (cantidad/desc/precio/exentas/iva10/iva5 etc) */
      .col-cant {
         width: 8%;
         text-align: center;
      }

      .col-desc {
         width: 44%;
         text-align: left;
         padding-left: 8px;
      }

      .col-unit {
         width: 12%;
         text-align: right;
      }

      .col-ex {
         width: 9%;
         text-align: right;
      }

      .col-iva5 {
         width: 9%;
         text-align: right;
      }

      .col-iva10 {
         width: 9%;
         text-align: right;
      }

      .gris {
         background: #efefef;
      }
   </style>
</head>

<body>

   <div class="factura">
      <!-- ENCABEZADO -->
      <table class="hdr">
         <tr>
            <div class="empresa">
               <span style="font-size:16px"><strong><?php echo $cabecera['emp_razonsocial'] ?></strong></span>
               <br>
               <?php echo $cabecera['emp_actividad'] ?><br>
               <b>SUCURSAL:</b> <?php echo $cabecera['suc_descripcion'] ?><br>
               <b>DIRECCION:</b> <?php echo $cabecera['suc_direccion'] ?><br>
               <b>TEL: </b><?php echo $cabecera['suc_telefono'] ?><br>
            </div>
            <td class="timbrado">
               <div class="box">
                  <div class="title">TIMBRADO N° <?php echo $cabecera['ven_timbrado'] ?></div>
                  <div style="font-size:12px; margin-top:6px;">Fecha Inicio Vigencia:
                     <?php echo $cabecera['ven_timbrado_inic'] ?>
                  </div>
                  <div style="font-size:12px; margin-top:4px;">Fecha Fin Vigencia:
                     <?php echo $cabecera['ven_timbrado_venc'] ?>
                  </div>
                  <div style="font-size:12px; margin-top:6px;">RUC.: <?php echo $cabecera['emp_ruc'] ?></div>
                  <div style="font-size:14px; margin-top:6px; ; font-weight: bold;">FACTURA</div>
                  <div style="font-size:14px; margin-top:6px;"><?php echo $cabecera['ven_numfactura'] ?></div>
               </div>
            </td>
         </tr>
      </table>

      <!-- DATOS DE EMISIÓN Y CLIENTE -->
      <div class="cliente">
         <table class="info">
            <tr>
               <td class="label">FECHA EMISIÓN:</td>
               <td class="value"><?php echo $cabecera['ven_fecha'] ?></td>
               <td class="label">CONDICIÓN:</td>
               <td class="value"><?php echo $cabecera['ven_tipofactura'] ?></td>
            </tr>
            <tr>
               <td class="label">NOMBRE / RAZÓN SOCIAL:</td>
               <td class="value"><?php echo $cabecera['cliente'] ?></td>
               <td class="label">R.U.C. O C.I.:</td>
               <td class="value"><?php echo $cabecera['per_numerodocumento'] ?></td>
            </tr>
            <tr>
               <td class="label">DIRECCIÓN:</td>
               <td class="value"><?php echo $cabecera['cli_direccion'] ?></td>
               <td class="label">TEL:</td>
               <td class="value"><?php echo $cabecera['per_telefono'] ?></td>
            </tr>
         </table>
      </div>

      <!-- TABLA DE ITEMS -->
      <table class="items">
         <thead>
            <tr>
               <th class="col-cant">CANTIDAD</th>
               <th class="col-desc">DESCRIPCION</th>
               <th class="col-unit">PRECIO UNITARIO</th>
               <th class="col-ex">EXENTA</th>
               <th class="col-iva5">IVA 5%</th>
               <th class="col-iva10">IVA 10%</th>
            </tr>
         </thead>
         <tbody>

            <?php foreach ($detalle as $posicion => $datos) {
               $totalExenta += intval($datos['exenta']);
               $totalIva5 += intval($datos['grav5']);
               if ($datos['tipit_codigo'] == '3') {
                  $totalIva10 += intval($datos['vendet_precio']);
               } else {
                  $totalIva10 += intval($datos['grav10']);
               }
               ?>
               <tr>
                  <td class="col-cant"><?php echo $datos['vendet_cantidad'] ?></td>
                  <td class="col-desc"><?php echo $datos['it_descripcion'] ?></td>
                  <td class="col-unit"><?php echo number_format($datos['vendet_precio'], 0, ',', '.'); ?></td>
                  <td class="col-ex"><?php echo number_format($datos['exenta'], 0, ',', '.'); ?></td>
                  <td class="col-iva5"><?php echo number_format($datos['grav5'], 0, ',', '.'); ?></td>
                  <?php if ($datos['tipit_codigo'] == '3') { ?>
                     <td class="col-iva10"><?php echo number_format($datos['vendet_precio'], 0, ',', '.'); ?></td>
                  <?php } else { ?>
                     <td class="col-iva10"><?php echo number_format($datos['grav10'], 0, ',', '.'); ?></td>
                  <?php } ?>
               </tr>
            <?php }
            $iva10 = intval($totalIva10 / 11);
            $iva5 = intval($totalIva5 / 21);
            $totalGral = $totalExenta + $totalIva5 + $totalIva10;
            ?>

            <tr>
               <td colspan="3" class="gris"><strong>SUBTOTALES</strong></td>
               <td><?php echo number_format($totalExenta, 0, ',', '.'); ?></td>
               <td><?php echo number_format($totalIva5, 0, ',', '.'); ?></td>
               <td><?php echo number_format($totalIva10, 0, ',', '.'); ?></td>
            </tr>
            <tr>
               <td colspan="5" class="gris"><strong>TOTAL GENERAL</strong></td>
               <td><?php echo number_format($totalGral, 0, ',', '.'); ?></td>
            </tr>
            <tr>
               <td colspan="6" class="gris"><strong>TOTAL A PAGAR (en
                     letras): </strong><?php echo strtoupper($formatter->format($totalGral)); ?></td>
            </tr>
            <tr>
               <td colspan="2" class="gris"><strong>LIQUIDACION IVA</strong></td>
               <td style="font-size:8px;">(5%) <div style="font-size:8px; text-align: right;">
                     <?php echo number_format($iva5, 0, ',', '.'); ?>
                  </div>
               </td>
               <td style="font-size:8px;">(10%) <div style="font-size:8px; text-align: right;">
                     <?php echo number_format($iva10, 0, ',', '.'); ?>
                  </div>
               </td>
               <td colspan="2" style="font-size:8px;"> TOTAL: <div style="font-size:8px; text-align: right;">
                     <?php echo number_format(($iva5 + $iva10), 0, ',', '.'); ?>
                  </div>
               </td>
            </tr>
         </tbody>
      </table>

   </div>

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

$dompdf->stream("8_DE_DICIEMBRE_OC_Nro_.pdf", array('Attachment' => false));

?>