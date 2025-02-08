<?php
//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$nota = $_GET['notven_codigo'];
$tipoNota = "";
$exenta = 0;
$iva10 = 0;
$iva5 = 0;

$sql = "select 
            nvc.notven_numeronota,
            nvc.notven_fecha,
            nvc.tipco_codigo,
            tc.tipco_descripcion,
            nvc.notven_concepto,
            p.per_nombre||' '||p.per_apellido as cliente,
            vc.ven_numfactura,
            u.usu_login,
            e.emp_razonsocial,
            s.suc_descripcion,
            nvc.notven_estado
         from nota_venta_cab nvc
            join tipo_comprobante tc on tc.tipco_codigo=nvc.tipco_codigo
            join venta_cab vc on vc.ven_codigo=nvc.ven_codigo
            join sucursal s on s.suc_codigo=nvc.suc_codigo
            and s.emp_codigo=nvc.emp_codigo
            join empresa e on e.emp_codigo=s.emp_codigo
            join usuario u on u.usu_codigo=nvc.usu_codigo
            join cliente c on c.cli_codigo=nvc.cli_codigo
            join personas p on p.per_codigo=c.per_codigo
         where nvc.notven_codigo=$nota;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_assoc($resultado);

$sql2 = "select 
            i.it_descripcion||' '||m.mod_codigomodelo as item,
            ti.tipit_codigo,
            t.tall_descripcion,
            nvd.notvendet_cantidad,
            um.unime_descripcion,
            nvd.notvendet_precio,
            (case i.tipim_codigo when 1 then nvd.notvendet_cantidad * nvd.notvendet_precio else 0 end) as grav5,
            (case i.tipim_codigo when 2 then nvd.notvendet_cantidad * nvd.notvendet_precio else 0 end) as grav10,
            (case i.tipim_codigo when 3 then nvd.notvendet_cantidad * nvd.notvendet_precio else 0 end) as exenta
         from nota_venta_det nvd
            join nota_venta_cab nvc on nvc.notven_codigo=nvd.notven_codigo
            join items i on i.it_codigo=nvd.it_codigo
            and i.tipit_codigo=nvd.tipit_codigo
            join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
            join talle t on t.tall_codigo=i.tall_codigo
            join modelo m on m.mod_codigo=i.mod_codigo
            join stock s on s.it_codigo=i.it_codigo
            and s.tipit_codigo=i.tipit_codigo
            join unidad_medida um on um.unime_codigo=i.unime_codigo
            join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
         where nvd.notven_codigo=$nota;";

$resultado2 = pg_query($conexion, $sql2);
$datos2 = pg_fetch_all($resultado2);

if ($datos['tipco_codigo'] == "1") {
   $tipoNota = "CREDITO";
} else if ($datos['tipco_codigo'] == "2") {
   $tipoNota = "DEBITO";
} else {
   $tipoNota = "REMISION";
}

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Nota</title>
   <style>
      body {
         font-family: Arial, Helvetica, sans-serif;
      }

      thead {
         border: 1px solid black;
      }

      b {
         background-color: teal;
         color: white;
      }

      th,
      .celda {
         border: 1px solid black;
         padding: 5px;
      }

      td {
         font-size: 10px;
         padding: 10px;
         border: 1px solid black;
      }

      h1 {
         color: #333;
         font-size: 20px;
         text-align: center;
         text-transform: uppercase;
         letter-spacing: -1px;
      }

      h4 {
         font-weight: bold;
         font-size: 15px;
         text-align: center;
      }

      .sumatorias {
         color: white;
         background-color: teal;
         font-weight: bold;
      }

      .fila1 {
         width: 65px;
      }

      .fila2 {
         width: 10px;
      }

      .fila3 {
         width: 10px;
      }

      .cabeceraCuerpo {
         width: 125px;
         font-size: 10px;
         border: 0px;
         padding-top: 20px;
      }

      .cabeceraIzquierda {
         width: 125px;
         font-size: 10px;
         border: 0px;
         padding-top: 20px;
      }

      .cabeceraIzquierda2 {
         width: 125px;
         font-size: 10px;
         border: 0px;
         padding-top: 20px;
      }

      .cabeceraIntermedia {
         width: 185px;
         font-size: 10px;
         border: 0px;
         padding-top: 20px;
      }

      .cabeceraIntermedia2 {
         width: 185px;
         font-size: 10px;
         border: 0px;
         padding-top: 20px;
      }

      .cabeceraDerecha {
         width: 100px;
         font-size: 10px;
         border: 0px;
         padding-top: 20px;
      }

      .cabeceraDerecha2 {
         width: 100px;
         font-size: 10px;
         border: 0px;
         padding-top: 20px;
      }

      .cabeceraCuerpoIzquierda {
         width: 60px;
         font-size: 10px;
         border: 0px;
         padding-top: 10px;
      }

      .cabeceraCuerpoIntermedia {
         width: 75px;
         font-size: 10px;
         border: 0px;
         padding-top: 10px;
      }

      .cabeceraCuerpoDerecha {
         width: 78px;
         font-size: 10px;
         border: 0px;
         padding-top: 10px;
      }

      .cabecera {
         margin-left: 0px;
      }

      .detalle1 {
         margin-left: 0px;
         margin-top: 10px;
      }

      .detalle2 {
         margin-left: 0px;
         margin-top: 10px;
         border-collapse: collapse;
      }

      .cabeceraCuerpo {
         background-color: teal;
         color: white;
      }

      .vacio {
         width: 664px;
      }
   </style>
</head>

<body>
   <h1>8 DE DICIEMBRE CONFECCIONES</h1>

   <h4>NOTA DE <?php echo $tipoNota; ?></h4>

   <table class="cabecera">
      <thead>
         <tr class="cabeceraFila">
            <td class="cabeceraIzquierda">
               <b>N° NOTA:</b>
               <?php echo $datos['notven_numeronota']; ?>
            </td>
            <td class="cabeceraIntermedia">
               <b>FECHA:</b>
               <?php echo $datos['notven_fecha']; ?>
            </td>
            <td class="cabeceraIntermedia">
               <b>TIPO COMPROBANTE:</b>
               <?php echo $datos['tipco_descripcion']; ?>
            </td>
            <td class="cabeceraDerecha">
               <b>CONCEPTO:</b>
               <?php echo $datos['notven_concepto']; ?>
            </td>
         </tr>
         <tr class="cabeceraFila">
            <td class="cabeceraIzquierda">
               <b>CLIENTE:</b>
               <?php echo $datos['cliente']; ?>
            </td>
            <td class="cabeceraIntermedia">
               <b>FACTURA:</b>
               <?php echo $datos['ven_numfactura']; ?>
            </td>
            <td class="cabeceraIntermedia">
               <b>USUARIO:</b>
               <?php echo $datos['usu_login']; ?>
            </td>
            <td class="cabeceraDerecha">
               <b>SUCURSAL:</b>
               <?php echo $datos['suc_descripcion']; ?>
            </td>
         </tr>
         <tr class="cabeceraFila">
            <td class="cabeceraIzquierda">
               <b>EMPRESA:</b>
               <?php echo $datos['emp_razonsocial']; ?>
            </td>
            <td class="cabeceraIntermedia">
               <b>ESTADO:</b>
               <?php echo $datos['notven_estado']; ?>
            </td>
         </tr>
      </thead>
   </table>

   <table class="detalle2">
      <?php if (isset($datos2[0])) { ?>
         <thead>
            <tr class="cabeceraCuerpo">
               <th class="cabeceraCuerpoIzquierda">ITEM</th>
               <th class="cabeceraCuerpoIntermedia">TALLE</th>
               <th class="cabeceraCuerpoIntermedia">CANTIDAD</th>
               <th class="cabeceraCuerpoIntermedia">UNIDAD MEDIDA</th>
               <th class="cabeceraCuerpoIntermedia">PRECIO</th>
               <th class="cabeceraCuerpoIntermedia">EXENTA</th>
               <th class="cabeceraCuerpoIntermedia">IVA 5</th>
               <th class="cabeceraCuerpoDerecha">IVA 10</th>
            </tr>
         </thead>
         <tbody>
            <?php foreach ($datos2 as $fila) {
               if ($fila['tipit_codigo'] == "3") {
                  $exenta += floatval($fila['notvendet_precio']);
                  $iva5 += floatval($fila['notvendet_precio']);
                  $iva10 += floatval($fila['notvendet_precio']);
               } else {
                  $exenta += floatval($fila['exenta']);
                  $iva5 += floatval($fila['grav5']);
                  $iva10 += floatval($fila['grav10']);
               }
               ?>
               <tr>
                  <td class="fila1">
                     <?php if (isset($fila['item'])) {
                        echo $fila['item'];
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td class="fila2">
                     <?php if (isset($fila['tall_descripcion'])) {
                        echo $fila['tall_descripcion'];
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td class="fila3">
                     <?php if (isset($fila['notvendet_cantidad'])) {
                        echo $fila['notvendet_cantidad'];
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($fila['unime_descripcion'])) {
                        echo $fila['unime_descripcion'];
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($fila['notvendet_precio'])) {
                        echo number_format($fila['notvendet_precio']);
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($fila['exenta'])) {
                        echo number_format($fila['exenta']);
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($fila['grav5'])) {
                        echo number_format($fila['grav5']);
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($fila['grav10'])) {
                        echo number_format($fila['grav10']);
                     } else {
                        echo '-';
                     } ?>
                  </td>
               </tr>
            <?php } ?>
         </tbody>
         <tfoot>
            <?php $total = $exenta + $iva5 + $iva10; ?>
            <tr>
               <td colspan="6" class="sumatorias">SUBTOTALES</td>
               <td><?php echo number_format($iva5); ?></td>
               <td><?php echo number_format($iva10); ?></td>
            </tr>
            <tr>
               <td colspan="7" class="sumatorias">TOTAL</td>
               <td><?php echo number_format($total); ?></td>
            </tr>
         </tfoot>
      <?php } else { ?>
         <tbody>
            <tr>
               <td colspan="8" class="vacio">NO HAY DETALLE REGISTRADO PARA ESTÁ CABECERA</td>
            </tr>
         </tbody>
      <?php } ?>
   </table>
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

$dompdf->stream("reporte_cobro.pdf", array('Attachment' => false));

?>