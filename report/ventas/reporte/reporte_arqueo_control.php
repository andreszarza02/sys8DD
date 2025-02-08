<?php

$fechaActual = date('d-m-Y');

//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos el parametro string y los separamos en un array por cada coma (,)
$formaPago = $_GET['forma'];
$formaPago = explode(",", $formaPago);
$datosCabecera = $_GET['cabecera'];
$datosCabecera = explode(",", $datosCabecera);

//Definimos las consultas a mostrar en la tabla
//Montos de arqueo
$sql = "select
            sum(case when cd.forco_codigo=1 then cd.cobdet_monto else 0 end) as efectivo,
            sum(case when cd.forco_codigo=2 then ct.cobta_monto else 0 end) as tarjeta,
            sum(case when cd.forco_codigo=3 then cc2.coche_monto else 0 end) as cheque,
            sum(cd.cobdet_monto) as total
         from cobro_det cd
            join cobro_cab cc on cc.cob_codigo=cd.cob_codigo
            join cobro_cheque cc2 on cc2.cob_codigo=cd.cob_codigo
            join cobro_tarjeta ct on ct.cob_codigo=cd.cob_codigo
            join apertura_cierre ac on ac.apercie_codigo=cc.apercie_codigo
         where ac.apercie_codigo=$datosCabecera[0]";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_assoc($resultado);

//Datos de sucursal
$sql2 = "select 
            e.emp_razonsocial,
            e.emp_ruc,
            s.suc_descripcion,
            s.suc_telefono,
            s.suc_email 
         from sucursal s 
          join empresa e on e.emp_codigo=s.emp_codigo
         where s.suc_descripcion='$datosCabecera[2]';";

$resultado2 = pg_query($conexion, $sql2);
$datos2 = pg_fetch_assoc($resultado2);

//Datos de usuario
$sql3 = "select
         u.usu_login,
         p.per_nombre||' '||p.per_apellido as persona
      from usuario u 
         join funcionario f on f.func_codigo=u.func_codigo 
         join personas p on p.per_codigo=f.per_codigo 
      where u.usu_login='$datosCabecera[3]';";

$resultado3 = pg_query($conexion, $sql3);
$datos3 = pg_fetch_assoc($resultado3);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Reporte Arqueo</title>
   <style>
      body {
         font-family: Arial, Helvetica, sans-serif;
      }

      h1 {
         margin: 0 auto;
         width: 38%;
      }

      h3 {
         margin: 10px auto;
         width: 30%;
         border-radius: 10px;
         background: ##232323;
         color: #fff;
         padding: 1px 0 1px 25px;
         border: 2px solid black;
      }

      span {
         margin: 0 280px;
         font-style: italic;
         font-weight: normal;
         font-size: 18px;
      }

      th {
         padding: 2px;
         border: 2px solid #000;
         font-size: 14px;
         background: #232323;
         color: #fff;
      }

      .espacio {
         width: 20px;
      }

      .espacio2 {
         width: 10px;
      }

      .espacio3 {
         width: 5px;
      }

      .descripcion {
         border-bottom: 1px solid black;
         margin-bottom: 13px;
      }

      .ruc {
         font-size: 10px;
         margin: 0 320px;
         font-weight: bold;
      }

      .proveedor {
         font-size: 12px;
      }

      .intermedio {
         font-size: 12px;
      }

      .cuota {
         font-size: 12px;
      }

      .prologoDetalle {
         font-size: 12px;
         font-style: italic;
         margin-top: -1px;
         margin-bottom: 25px;
      }

      .cabecera2,
      .cabecera3 {
         margin-top: -20px;
      }

      .detalle {
         border-collapse: collapse;
         border: 1px solid #000;
         width: 100%;
      }

      .detalleItems td {
         padding: 2px;
         border: 1px solid #000;
         font-size: 10px;
      }

      .detalleItemsPie td {
         padding: 2px;
         border: 1px solid #000;
         font-size: 12px;
      }

      .foot {
         background: #efeded;
      }

      .pie {
         margin-top: 20px;
      }

      .pieDetalle {
         font-size: 12px;
      }

      .contacto {
         font-size: 10px;
         margin: 0 auto;
         width: 60%;
      }

      .empty {
         font-size: 12px;
      }
   </style>
</head>

<body>

   <h1><?php echo $datos2['emp_razonsocial'] ?></h1>

   <span><?php echo $datos2['suc_descripcion'] ?></span>

   <span class="ruc"><?php echo $datos2['emp_ruc'] ?></span>

   <h3>ARQUEO CONTROL</h3>

   <table class="cabecera1">
      <tr class="proveedor">
         <td>
            <p><b>Elaborado por: </b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $datos3['persona'] ?>
            </p>
         </td>
         <td class="espacio2"></td>
         <td>
            <p><b>Usuario:</b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $datos3['usu_login'] ?>
            </p>
         </td>
      </tr>
   </table>

   <table class="cabecera2">
      <tr class="intermedio">
         <td>
            <p><b>Solicitado por: </b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $datosCabecera[4]; ?>
            </p>
         </td>
         <td class="espacio3"></td>
         <td>
            <p><b>Motivo: </b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo strtoupper($datosCabecera[5]); ?>
            </p>
         </td>
         <td class="espacio3"></td>
         <td>
            <p><b>Caja: </b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $datosCabecera[6]; ?>
            </p>
         </td>
         <td class="espacio3"></td>
         <td>
            <p><b>Fecha: </b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $fechaActual; ?>
            </p>
         </td>
      </tr>
   </table>

   <table class="detalle">
      <thead>
         <tr>
            <th>FORMA DE PAGO</th>
            <th>MONTO</th>
         </tr>
      </thead>
      <tbody class="detalleItems">
         <?php if (in_array('efectivo', $formaPago) || in_array('todos', $formaPago)) { ?>
            <tr>
               <td>EFECTIVO</td>
               <td>
                  <?php if (isset($datos['efectivo'])) {
                     echo number_format($datos['efectivo']) . " Gs";
                  } else {
                     echo 'NO SE ENCUENTRA MONTOS EN EFECTIVO';
                  } ?>
               </td>
            </tr>
         <?php } ?>
         <?php if (in_array('tarjeta', $formaPago) || in_array('todos', $formaPago)) { ?>
            <tr>
               <td>TARJETA</td>
               <td>
                  <?php if (isset($datos['tarjeta'])) {
                     echo number_format($datos['tarjeta']) . " Gs";
                  } else {
                     echo 'NO SE ENCUENTRA MONTOS EN TARJETA';
                  } ?>
               </td>
            </tr>
         <?php } ?>
         <?php if (in_array('cheque', $formaPago) || in_array('todos', $formaPago)) { ?>
            <tr>
               <td>CHEQUE</td>
               <td>
                  <?php if (isset($datos['cheque'])) {
                     echo number_format($datos['cheque']) . " Gs";
                  } else {
                     echo 'NO SE ENCUENTRA MONTOS EN CHEQUE';
                  } ?>
               </td>
            </tr>
         <?php } ?>
      </tbody>
   </table>

   <table class="contacto">
      <tr class="contactoDetalle">
         <td>
            <p><b>Contacto sucursal:</b></p>
         </td>
         <td>
            <p><?php echo $datos2['suc_telefono'] ?>
            </p>
         </td>
         <td class="espacio3"></td>
         <td>
            <p><b>Correo sucursal:</b></p>
         </td>
         <td>
            <p><?php echo $datos2['suc_email'] ?>
            </p>
         </td>
      </tr>
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

$dompdf->stream("reporte_arqueo.pdf", array('Attachment' => false));

?>