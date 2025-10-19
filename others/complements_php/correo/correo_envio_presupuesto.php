<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Requerimos conexion 
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos el codigo de presupuesto
$presupuesto = $_POST['pres_codigo'];

//Definimos las variables a utilizar en el reporte a enviar
$contador = 0;
$totalIva10 = 0;
$totalIva5 = 0;
$totalExenta = 0;
$iva10 = 0;
$iva5 = 0;
$totalGral = 0;
$totalIva = 0;

//Establecemos la consulta de cabecera
$sql = "select 
         e.emp_razonsocial,
         s.suc_descripcion,
         'RUC: '||e.emp_ruc as emp_ruc,
         pc.pres_codigo,
         p.per_nombre||' '||p.per_apellido as cliente,
         (case 
         when p.tipdo_codigo=1 then 'CI:' 
         when p.tipdo_codigo=2 then 'RUC:'
         else 'PASAPORTE:'
         end) as tipdo_descripcion,
         p.per_numerodocumento as cliente_documento,
         p.per_email as cliente_correo,
         to_char(pc.pres_fecharegistro, 'DD-MM-YYYY') as pres_fecharegistro,
         to_char(pc.pres_fechavencimiento, 'DD-MM-YYYY') as pres_fechavencimiento,
         pc.peven_codigo,
         p2.per_nombre||' '||p2.per_apellido as funcionario,
         u.usu_login,
         s.suc_telefono,
         s.suc_email
      from presupuesto_cab pc
         join usuario u on u.usu_codigo=pc.usu_codigo
         join sucursal s on s.suc_codigo=pc.suc_codigo
         and s.emp_codigo=pc.emp_codigo
         join empresa e on e.emp_codigo=s.emp_codigo
         join cliente c on c.cli_codigo=pc.cli_codigo
         join personas p on p.per_codigo=c.per_codigo
         join funcionario f on f.func_codigo=u.func_codigo
         join personas p2 on p2.per_codigo=f.per_codigo
      where pc.pres_codigo=$presupuesto;";

$resultado = pg_query($conexion, $sql);
$cabecera = pg_fetch_assoc($resultado);

//Establecemos la consulta del detalle de cabecera
$sql2 = "select 
            pd.*,
            i.it_descripcion||' '||m.mod_codigomodelo as item,
            t.tall_descripcion,
            um.unime_descripcion,
            (case i.tipim_codigo when 1 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as grav5,
            (case i.tipim_codigo when 2 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as grav10,
            (case i.tipim_codigo when 3 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as exenta
         from presupuesto_det pd
            join items i on i.it_codigo=pd.it_codigo
            and i.tipit_codigo=pd.tipit_codigo
            join modelo m on m.mod_codigo=i.mod_codigo
            join talle t on t.tall_codigo=i.tall_codigo 
            join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
            join unidad_medida um on um.unime_codigo=i.unime_codigo 
         where pd.pres_codigo=$presupuesto;";

$resultado2 = pg_query($conexion, $sql2);
$detalle = pg_fetch_all($resultado2);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>PRESUPUESTO DE PRODUCCION</title>
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

      .cliente {
         font-size: 12px;
      }

      .intermedio {
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

   <h3>PRESUPUESTO N°: <?php echo $cabecera['pres_codigo'] ?></h3>

   <table class="cabecera1">
      <tr class="cliente">
         <td>
            <p><b>Cliente: </b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $cabecera['cliente'] ?>
            </p>
         </td>
         <td class="espacio2"></td>
         <td>
            <p><b><?php echo $cabecera['tipdo_descripcion'] ?></b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $cabecera['cliente_documento'] ?>
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
            <p class="descripcion"><?php echo $cabecera['pres_fecharegistro'] ?>
            </p>
         </td>
         <td class="espacio3"></td>
         <td>
            <p><b>Fecha de vencimiento del presupuesto:</b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $cabecera['pres_fechavencimiento'] ?>
            </p>
         </td>
      </tr>
   </table>

   <p class="prologoDetalle">Este presupuesto está asociado al <b>pedido de venta N°
         <?php echo $cabecera['peven_codigo'] ?></b>. Teniendo en cuenta el detalle del mismo se procedió a presupuestar
      los siguientes productos solicitados:
   </p>

   <table class="detalle">
      <thead>
         <tr class="cabeceraCuerpo">
            <th>NRO</th>
            <th>ITEM</th>
            <th>TALLE</th>
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
               $totalExenta += floatval($filaDetalle['exenta']);
               $totalIva5 += floatval($filaDetalle['grav5']);
               if ($filaDetalle['tipit_codigo'] == 3) { //Servicio
                  $totalIva10 += floatval($filaDetalle['presdet_precio']);
               } else {
                  $totalIva10 += floatval($filaDetalle['grav10']);
               }

               ?>
               <tr>
                  <td>
                     <?php echo $indice + 1 ?>
                  </td>
                  <td>
                     <?php if (isset($filaDetalle['item'])) {
                        echo $filaDetalle['item'];
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($filaDetalle['tall_descripcion'])) {
                        echo $filaDetalle['tall_descripcion'];
                     } else {
                        echo '-';
                     } ?>
                  </td>
                  <td>
                     <?php if (isset($filaDetalle['presdet_cantidad'])) {
                        echo $filaDetalle['presdet_cantidad'];
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
                     <?php if (isset($filaDetalle['presdet_precio'])) {
                        echo number_format($filaDetalle['presdet_precio'], 0, ',', '.');
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
                  <td>
                     <?php if (isset($filaDetalle['grav10'])) {
                        if ($filaDetalle['tipit_codigo'] == 3) {// servicio
                           echo number_format($filaDetalle['presdet_precio'], 0, ',', '.');
                        } else {
                           echo number_format($filaDetalle['grav10'], 0, ',', '.');
                        }
                     } else {
                        echo '-';
                     } ?>
                  </td>
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
            <p class="descripcion"><?php echo $cabecera['funcionario'] ?>
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
   $mail->Port = 465; // Puerto TCP para ssl por smtp

   // Remitente y destinatario
   $mail->setFrom('adm.8DD@gmail.com', '
   Administracion 8 de Diciembre');
   $mail->addAddress("{$cabecera['cliente_correo']}", "{$cabecera['cliente']}");

   //Guaradamos el pdf generado y le ponemos un nombre y extension
   $mail->addStringAttachment(
      $output,
      "8_DE_DICIEMBRE_PRESUPUESTO_Nro_{$cabecera['pres_codigo']}.pdf"
   );

   // Contenido del correo
   $mail->isHTML(true);
   $mail->Subject = "CONFIRMACION DE PRESUPUESTO - Nro {$cabecera['pres_codigo']}";
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
         <h2>Estimado(a) ' . htmlspecialchars($cabecera['cliente']) . ',</h2>
         <p>Nos complace informarle que su presupuesto ha sido generado exitosamente. A continuación, encontrará los detalles del presupuesto:</p>
         <p><strong>Número de Presupuesto:</strong> ' . htmlspecialchars($cabecera['pres_codigo']) . '</p>
         <p>Adjunto a este correo encontrará el presupuesto en formato PDF.</p>
         <p>Este presupuesto se realizó en base al detalle de su pedido de venta, especificamente el <b>pedido de venta N°' . htmlspecialchars($cabecera['peven_codigo']) . '</b></p>
         <p>Si tiene alguna pregunta o necesita más información, no dude en ponerse en contacto con nosotros.</p>
         <p>Atentamente,<br><b>8 DE DICIEMBRE - ' . htmlspecialchars($cabecera['suc_descripcion']) . '</b></p>
      </div>
   </body>
   </html>
   ';

   // Enviar el correo
   $mail->send();

   //Definimos una respuesta en caso de envio correcto
   $response = array(
      "mensaje" => "EL PRESUPUESTO SE ENVIO AL CLIENTE {$cabecera['cliente']}",
      "tipo" => "info"
   );

   echo json_encode($response);

} catch (Exception $e) {

   //Definimos una respiuesta en caso de que no se haya eniviado el presupuesto
   $response = array(
      "mensaje" => "EL PRESUPUESTO NO SE ENVIO AL CLIENTE {$cabecera['cliente']}",
      "tipo" => "error"
   );

   echo json_encode($response);
}

?>