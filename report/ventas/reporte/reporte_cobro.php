<?php
//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$cobro = $_GET['cob_codigo'];

$sql = "select 
         cc.cob_codigo,
         cc.cob_fecha,
         ac.apercie_codigo,
         c.caj_descripcion,
         u.usu_login,
         e.emp_razonsocial,
         s.suc_descripcion,
         cc.cob_estado
      from cobro_cab cc
         join apertura_cierre ac on ac.apercie_codigo=cc.apercie_codigo
         join caja c on c.caj_codigo=ac.caj_codigo
         join sucursal s on s.suc_codigo=ac.suc_codigo
         and s.emp_codigo=ac.emp_codigo
         join empresa e on e.emp_codigo=s.emp_codigo
         join usuario u on u.usu_codigo=ac.usu_codigo
      where cc.cob_codigo=$cobro";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_assoc($resultado);

$sql2 = "select distinct
            vc.ven_numfactura as factura,
            p.per_nombre||' '||p.per_apellido as cliente,
            cd.cobdet_numerocuota,
            cc.cuenco_montosaldo as saldo,
            vc.vent_montocuota,
            vc.ven_interfecha,
            cc.cuenco_montototal 
         from cobro_det cd
            join cobro_cab cc3 on cc3.cob_codigo=cd.cob_codigo
            join cuenta_cobrar cc on cc.ven_codigo=cd.ven_codigo
            join venta_cab vc on vc.ven_codigo=cc.ven_codigo
            join cliente c on c.cli_codigo=vc.cli_codigo
            join personas p on p.per_codigo=c.per_codigo
         where cd.cob_codigo=$cobro;";

$resultado2 = pg_query($conexion, $sql2);
$datos2 = pg_fetch_assoc($resultado2);

$sql3 = "select 
            sum(case when cd.forco_codigo=1 then cd.cobdet_monto else 0 end) as efectivo,
            sum(case when cd.forco_codigo=2 then cd.cobdet_monto else 0 end) as tarjeta,
            sum(case when cd.forco_codigo=3 then cd.cobdet_monto else 0 end) as cheque 
         from cobro_det cd
            join cobro_cab cc3 on cc3.cob_codigo=cd.cob_codigo
            join cuenta_cobrar cc on cc.ven_codigo=cd.ven_codigo
            join venta_cab vc on vc.ven_codigo=cc.ven_codigo
            join cliente c on c.cli_codigo=vc.cli_codigo
            join personas p on p.per_codigo=c.per_codigo
            join forma_cobro fc on fc.forco_codigo=cd.forco_codigo
         where cd.cob_codigo=$cobro;";

$resultado3 = pg_query($conexion, $sql3);
$datos3 = pg_fetch_assoc($resultado3);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Recibo de Cobro</title>
   <style>
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
         font-size: 12px;
         padding: 10px;
         border: 1px solid black;
      }

      h1 {
         color: #333;
         font-size: 20px;
         text-align: center;
         text-transform: uppercase;
         letter-spacing: -1px;
         font-family: 'Times New Roman', Times, serif;
      }

      h4 {
         font-weight: bold;
         font-size: 15px;
         text-align: center;
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
         width: 218px;
         font-size: 10px;
         border: 0px;
         padding-top: 10px;
      }

      .cabeceraCuerpoIntermedia {
         width: 218px;
         font-size: 10px;
         border: 0px;
         padding-top: 10px;
      }

      .cabeceraCuerpoDerecha {
         width: 218px;
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
   </style>
</head>

<body>
   <h1>8 DE DICIEMBRE CONFECCIONES</h1>

   <h4>RECIBO</h4>

   <table class="cabecera">
      <thead>
         <tr class="cabeceraFila">
            <td class="cabeceraIzquierda">
               <b>N° COBRO:</b>
               <?php echo $datos['cob_codigo']; ?>
            </td>
            <td class="cabeceraIntermedia">
               <b>FECHA:</b>
               <?php echo $datos['cob_fecha']; ?>
            </td>
            <td class="cabeceraIntermedia">
               <b>N° APERTURA:</b>
               <?php echo $datos['apercie_codigo']; ?>
            </td>
            <td class="cabeceraDerecha">
               <b>CAJA:</b>
               <?php echo $datos['caj_descripcion']; ?>
            </td>
         </tr>
         <tr class="cabeceraFila">
            <td class="cabeceraIzquierda">
               <b>USUARIO:</b>
               <?php echo $datos['usu_login']; ?>
            </td>
            <td class="cabeceraIntermedia">
               <b>SUCURSAL:</b>
               <?php echo $datos['suc_descripcion']; ?>
            </td>
            <td class="cabeceraIntermedia">
               <b>EMPRESA:</b>
               <?php echo $datos['emp_razonsocial']; ?>
            </td>
            <td class="cabeceraDerecha">
               <b>ESTADO:</b>
               <?php echo $datos['cob_estado']; ?>
            </td>
         </tr>
      </thead>
   </table>

   <table class="detalle1">
      <thead>
         <tr class="cabeceraFila2">
            <td class="cabeceraIzquierda2">
               <b>FACTURA:</b>
               <?php if (isset($datos2['factura'])) {
                  echo $datos2['factura'];
               } else {
                  echo '-';
               } ?>
            </td>
            <td class="cabeceraIntermedia2">
               <b>CLIENTE:</b>
               <?php if (isset($datos2['cliente'])) {
                  echo $datos2['cliente'];
               } else {
                  echo '-';
               } ?>
            </td>
            <td class="cabeceraIntermedia2">
               <b>MONTO CUOTA:</b>
               <?php if (isset($datos2['vent_montocuota'])) {
                  echo $datos2['vent_montocuota'];
               } else {
                  echo '-';
               } ?>
            </td>
            <td class="cabeceraDerecha2">
               <b>N° CUOTA:</b>
               <?php if (isset($datos2['cobdet_numerocuota'])) {
                  echo $datos2['cobdet_numerocuota'];
               } else {
                  echo '-';
               } ?>
            </td>
         </tr>
         <tr class="cabeceraFila2">
            <td class="cabeceraIzquierda2">
               <b>INTERVALO:</b>
               <?php if (isset($datos2['ven_interfecha'])) {
                  echo $datos2['ven_interfecha'];
               } else {
                  echo '-';
               } ?>
            </td>
         </tr>
      </thead>
   </table>

   <table class="detalle2">
      <thead>
         <tr class="cabeceraCuerpo">
            <th class="cabeceraCuerpoIzquierda">EFECTIVO</th>
            <th class="cabeceraCuerpoIntermedia">CHEQUE</th>
            <th class="cabeceraCuerpoDerecha">TARJETA</th>
         </tr>
      </thead>
      <tbody>
         <tr>
            <td>
               <?php if (isset($datos3['efectivo'])) {
                  echo number_format($datos3['efectivo']);
               } else {
                  echo '-';
               } ?>
            </td>
            <td>
               <?php if (isset($datos3['cheque'])) {
                  echo number_format($datos3['cheque']);
               } else {
                  echo '-';
               } ?>
            </td>
            <td>
               <?php if (isset($datos3['tarjeta'])) {
                  echo number_format($datos3['tarjeta']);
               } else {
                  echo '-';
               } ?>
            </td>
         </tr>
      </tbody>
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