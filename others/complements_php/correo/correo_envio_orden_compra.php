<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Requerimos conexion 
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos el codigo de orden compra
$orden = $_POST['orcom_codigo'];

//Definimos las variables a utilizar en el reporte a enviar
$contador = 0;
$totalIva10 = 0;
$totalIva5 = 0;
$totalExenta = 0;
$iva10 = 0;
$iva5 = 0;
$totalGral = 0;
$totalIva = 0;

$sql = "select
            occ.orcom_codigo,
            e.emp_razonsocial,
            s.suc_descripcion,
            'RUC: '||e.emp_ruc as emp_ruc,
            p.pro_razonsocial,
            p.pro_ruc,
            to_char(occ.orcom_fecha, 'DD-MM-YYYY') as orcom_fecha,
            occ.orcom_condicionpago,
            occ.orcom_cuota,
            occ.orcom_montocuota,
            occ.orcom_interfecha,
            p2.per_nombre||' '||p2.per_apellido as nombre,
            u.usu_login,
            s.suc_telefono,
            s.suc_email,
            s.suc_direccion,
            ci.ciu_descripcion
         from orden_compra_cab occ
            join usuario u on u.usu_codigo=occ.usu_codigo
            join funcionario f on f.func_codigo=u.func_codigo 
            join personas p2 on p2.per_codigo=f.per_codigo 
            join proveedor p on p.pro_codigo=occ.pro_codigo
            and p.tipro_codigo=occ.tipro_codigo
            join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
            join sucursal s on s.suc_codigo=occ.suc_codigo
            and s.emp_codigo=occ.emp_codigo
            join empresa e on e.emp_codigo=s.emp_codigo
            join ciudad ci on ci.ciu_codigo=s.ciu_codigo
         where occ.orcom_codigo=$orden;";

$resultado = pg_query($conexion, $sql);
$cabecera = pg_fetch_assoc($resultado);

$sql2 = "select
            ocd.*,
            i.it_descripcion,
            ti.tipit_descripcion,
            um.unime_codigo,
            um.unime_descripcion,
            (case i.tipim_codigo when 1 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as grav5,
            (case i.tipim_codigo when 2 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as grav10,
            (case i.tipim_codigo when 3 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as exenta
            from orden_compra_det ocd
            join items i on i.it_codigo=ocd.it_codigo
            and i.tipit_codigo=ocd.tipit_codigo
            join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
            join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
            join unidad_medida um on um.unime_codigo=i.unime_codigo
            where ocd.orcom_codigo=$orden;";

$resultado2 = pg_query($conexion, $sql2);
$detalle = pg_fetch_all($resultado2);

?>

<?php

//Guardamos en el buffer todo el html a generar
ob_start();

?>

<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>ORDEN DE COMPRA</title>
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
         width: 36%;
         border-radius: 10px;
         background: ##232323;
         color: #fff;
         padding: 1px 0 1px 6px;
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
         margin: 0 296px;
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
         font-size: 12px;
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

   <h1><?php echo $cabecera['emp_razonsocial'] ?></h1>

   <span><?php echo $cabecera['suc_descripcion'] ?></span>

   <span class="ruc"><?php echo $cabecera['emp_ruc'] ?></span>

   <h3>ORDEN DE COMPRA N°: <?php echo $cabecera['orcom_codigo'] ?></h3>

   <table class="cabecera1">
      <tr class="proveedor">
         <td>
            <p><b>Proveedor: </b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $cabecera['pro_razonsocial'] ?>
            </p>
         </td>
         <td class="espacio2"></td>
         <td>
            <p><b>RUC:</b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $cabecera['pro_ruc'] ?>
            </p>
         </td>
      </tr>
   </table>

   <table class="cabecera2">
      <tr class="intermedio">
         <td>
            <p><b>Fecha de emision:</b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $cabecera['orcom_fecha'] ?>
            </p>
         </td>
         <td class="espacio3"></td>
         <td>
            <p><b>Condicion de pago:</b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $cabecera['orcom_condicionpago'] ?>
            </p>
         </td>
      </tr>
   </table>

   <table class="cabecera3">
      <tr class="cuota">
         <td>
            <p><b>Cantidad de cuotas:</b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $cabecera['orcom_cuota'] ?>
            </p>
         </td>
         <td class="espacio2"></td>
         <td>
            <p><b>Monto por cuota:</b> </p>
         </td>
         <td>
            <p class="descripcion"><?php echo number_format($cabecera['orcom_montocuota'], 0, ',', '.') ?>
            </p>
         </td>
         <td class="espacio2"></td>
         <td>
            <p><b>Intervalo de cuota:</b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $cabecera['orcom_interfecha'] ?>
            </p>
         </td>
      </tr>
   </table>

   <p class="prologoDetalle">Por medio de esta orden de compra se solicitan los siguientes articulos:</p>

   <table class="detalle">
      <thead>
         <tr class="cabeceraCuerpo">
            <th>Nro</th>
            <th>ITEM</th>
            <th>TIPO</th>
            <th>CANTIDAD</th>
            <th>UNIDAD MEDIDA</th>
            <th>PRECIO</th>
            <th>EXENTA</th>
            <th>IVA 5</th>
            <th>IVA 10</th>
         </tr>
      </thead>
      <?php if (isset($detalle[0])) { ?>
         <tbody class="detalleItems">
            <?php foreach ($detalle as $indice => $filaDetalle) {
               if ($filaDetalle['tipit_codigo'] == "3") {
                  $totalIva10 += floatval($filaDetalle['orcomdet_precio']);
               } else {
                  $totalExenta += floatval($filaDetalle['exenta']);
                  $totalIva5 += floatval($filaDetalle['grav5']);
                  $totalIva10 += floatval($filaDetalle['grav10']);
               }
               ?>
               <tr>
                  <td>
                     <?php echo $indice + 1 ?>
                  </td>
                  <td>
                     <?php if (isset($filaDetalle['it_descripcion'])) {
                        echo $filaDetalle['it_descripcion'];
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($filaDetalle['tipit_descripcion'])) {
                        echo $filaDetalle['tipit_descripcion'];
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($filaDetalle['orcomdet_cantidad'])) {
                        echo $filaDetalle['orcomdet_cantidad'];
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($filaDetalle['unime_descripcion'])) {
                        echo $filaDetalle['unime_descripcion'];
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($filaDetalle['orcomdet_precio'])) {
                        echo number_format($filaDetalle['orcomdet_precio'], 0, ',', '.');
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($filaDetalle['exenta'])) {
                        echo number_format($filaDetalle['exenta'], 0, ',', '.');
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($filaDetalle['grav5'])) {
                        echo number_format($filaDetalle['grav5'], 0, ',', '.');
                     } else {
                        echo '-';
                     } ?>
                  </td>

                  <?php
                  if ($filaDetalle['tipit_codigo'] == "3") {
                     ?>
                     <td>
                        <?php if (isset($filaDetalle['orcomdet_precio'])) {
                           echo number_format($filaDetalle['orcomdet_precio'], 0, ',', '.');
                        } else {
                           echo '-';
                        } ?>
                     </td>

                  <?php } else { ?>

                     <td>
                        <?php if (isset($filaDetalle['grav10'])) {
                           echo number_format($filaDetalle['grav10'], 0, ',', '.');
                        } else {
                           echo '-';
                        } ?>
                     </td>

                  <?php } ?>
               </tr>
            <?php } ?>
         </tbody>
         <tfoot class="detalleItemsPie">

            <?php

            $iva5 = floatval($totalIva5 / 21);
            $iva10 = floatval($totalIva10 / 11);
            $totalGral = $totalExenta + $totalIva5 + $totalIva10;
            $totalIva = $iva5 + $iva10;

            ?>

            <tr>
               <td class="foot" colspan="6">SUBTOTALES</td>
               <td><?php echo number_format($totalExenta, 2, ',', '.'); ?></td>
               <td><?php echo number_format($totalIva5, 2, ',', '.'); ?></td>
               <td><?php echo number_format($totalIva10, 2, ',', '.'); ?></td>
            </tr>
            <tr>
               <td class="foot" colspan="7">LIQUIDACION IVA</td>
               <td><?php echo number_format($iva5, 2, ',', '.'); ?></td>
               <td><?php echo number_format($iva10, 2, ',', '.'); ?></td>
            </tr>
            <tr>
               <td class="foot" colspan="8">TOTAL IVA</td>
               <td><?php echo number_format($totalIva, 2, ',', '.'); ?></td>
            </tr>
            <tr>
               <td class="foot" colspan="8">TOTAL GENERAL</td>
               <td><?php echo number_format($totalGral, 2, ',', '.'); ?></td>
            </tr>
         </tfoot>
      <?php } else { ?>
         <tbody>
            <tr>
               <td colspan="9" class="empty"> NO HAY DETALLE REGISTRADO PARA ESTÁ CABECERA</td>
            </tr>
         </tbody>
      <?php } ?>
   </table>

   <table class="pie">
      <tr class="pieDetalle">
         <td>
            <p><b>Elaborado por:</b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $cabecera['nombre'] ?>
            </p>
         </td>
         <td class="espacio2"></td>
         <td>
            <p><b>Usuario:</b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $cabecera['usu_login'] ?>
            </p>
         </td>
         <td class="espacio2"></td>
         <td>
            <p><b>Recibido por: </b> </p>
         </td>
         <td>
            <p>_______________________</p>
         </td>
         <td class="espacio2"></td>
      </tr>
   </table>

   <table class="contacto">
      <tr class="contactoDetalle">
         <td>
            <p><b>Contacto sucursal:</b></p>
         </td>
         <td>
            <p><?php echo $cabecera['suc_telefono'] ?>
            </p>
         </td>
         <td class="espacio3"></td>
         <td>
            <p><b>Correo sucursal:</b></p>
         </td>
         <td>
            <p><?php echo $cabecera['suc_email'] ?>
            </p>
         </td>
      </tr>
   </table>


</body>

</html>

<?php

//Descargamos los datos guardados en el buffer en la variable
$html = ob_get_clean();

//Requerimos la librerias del vendor
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/vendor/autoload.php";

//Llamamos a Dopmpdf
use Dompdf\Dompdf;

//Creamos el objeto que va agenerar el pdf
$dompdf = new Dompdf();

//Cargamos el reporte generado en html
$dompdf->loadHtml($html);

//Establecemos el formato del pdf
$dompdf->setPaper('A4', 'portrait'); //portrait -> vertical landscape -> horizontal

//Renderizamos el pdf
$dompdf->render();

//Obtenemos el contenido del pdf generado
$output = $dompdf->output();

//Llamamos a la libreria PHP Mailer
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

//Requerimos la librerias del vendor
require "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/vendor/autoload.php";

//Creamos el objeto mail
$mail = new PHPMailer(true);

try {

   // Configuración del servidor SMTP
   $mail->isSMTP();
   $mail->Host = 'smtp.gmail.com'; // Especifica el servidor SMTP
   $mail->SMTPAuth = true;
   $mail->Username = 'adm.8DD@gmail.com'; // establecemos el correo desde donde enviar
   $mail->Password = 'upav neje qmtf bvpo'; // Establecemos la contraseña de aplicacion
   $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS; // Habilitar SSL
   $mail->Port = 465; // Puerto TCP para ssl

   // Remitente y destinatario
   $mail->setFrom('adm.8DD@gmail.com', '
   Admnistracion 8 de Diciembre');
   $mail->addAddress("{$_POST['pro_email']}", "{$_POST['pro_razonsocial']}");

   //Guaradamos el pdf generado y le ponemos un nombre y extension
   $mail->addStringAttachment(
      $output,
      "8_DE_DICIEMBRE_OC_Nro_{$cabecera['orcom_codigo']}.pdf"
   );

   // Contenido del correo
   $mail->isHTML(true);
   $mail->Subject = "CONFIRMACION DE ORDEN DE COMPRA - Nro{$cabecera['orcom_codigo']}";
   $mail->Body = '
    <html>
    <head>
        <style>
            body { font-family: Arial, sans-serif; }
            .content { margin: 20px; }
        </style>
    </head>
    <body>
        <div class="content">
            <h2>Estimado(a) ' . htmlspecialchars($_POST['pro_razonsocial']) . ',</h2>
            <p>Nos complace informarle que nuestra orden de compra ha sido generada exitosamente. A continuación, encontrará los detalles de nuestra orden:</p>
            <p><strong>Número de Orden:</strong> ' . htmlspecialchars($cabecera['orcom_codigo']) . '</p>
            <p>Lo solicitado en el detalle de la orden se debera entregar en caso de ser un ítem o brindar en caso de ser un servicio en la siguiente dirección: <strong>' . htmlspecialchars($cabecera['suc_direccion']) . ' - ' . htmlspecialchars($cabecera['ciu_descripcion']) . '</strong> </p>
            <p>Si tiene alguna pregunta o necesita más información, no dude en ponerse en contacto con nosotros.</p>
            <p>Atentamente,<br>8 DE DICIEMBRE - ' . htmlspecialchars($cabecera['suc_descripcion']) . '</p>
        </div>
    </body>
    </html>
';

   // Enviar el correo
   $mail->send();

   //echo 'Correo enviado con éxito';
   $response = array(
      "mensaje" => "LA OC SE ENVIO A EL PROVEEDOR {$_POST['pro_razonsocial']}",
      "tipo" => "info"
   );

   echo json_encode($response);

} catch (Exception $e) {

   //echo "El correo no pudo ser enviado. Error: {$mail->ErrorInfo}";
   $response = array(
      "mensaje" => "LA OC NO SE ENVIO A EL PROVEEDOR {$_POST['pro_razonsocial']}",
      "tipo" => "error"
   );

   echo json_encode($response);
}

?>