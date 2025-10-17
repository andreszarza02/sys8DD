<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Requerimos conexion 
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

// Creamos una instancia de conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

// Definimos variables a utilizar
$notven_codigo = $_POST['notven_codigo'] ?? 0;

$contador = 0;
$totalIva10 = 0;
$totalIva5 = 0;
$totalExenta = 0;
$iva10 = 0;
$iva5 = 0;
$totalGral = 0;
$totalIva = 0;
$totalGralRemision = 0;

$sql = "select 
            nvc.notven_timbrado,
            to_char((select distinct ta.timb_numero_fecha_inic from timbrados_auditoria ta 
            where ta.timb_numero=cast(nvc.notven_timbrado as integer)) , 'DD-MM-YYYY') as notven_timbrado_inic,
            to_char(nvc.notven_timbrado_venc , 'DD-MM-YYYY') notven_timbrado_venc,
            nvc.notven_concepto,
            e.emp_ruc,
            nvc.notven_numeronota,
            e.emp_razonsocial,
            e.emp_actividad,
            s.suc_descripcion,
            s.suc_direccion,
            s.suc_telefono,
            c.ciu_descripcion||' - '||'PARAGUAY' as ciu_descripcion,
            UPPER(to_char(nvc.notven_fecha ,'DD \"de\" TMMonth \"de\" YYYY')) as notven_fecha,
            p.per_nombre||' '||p.per_apellido as cliente,
            p.per_numerodocumento,
            p.per_email,
            c2.cli_direccion,
            p.per_telefono,
            tc.tipco_descripcion,
            vc.ven_numfactura,
            p2.per_numerodocumento as per_numerodocumento2,
            p2.per_nombre||' '||p2.per_apellido as funcionario,
            cv.chave_chapa,
            mv2.marve_descripcion,
            mv.modve_descripcion
         from nota_venta_cab nvc 
            join venta_cab vc on vc.ven_codigo=nvc.ven_codigo 
            join sucursal s on s.suc_codigo=nvc.suc_codigo
            and s.emp_codigo=nvc.emp_codigo 
               join empresa e on e.emp_codigo=s.emp_codigo 
            join ciudad c on c.ciu_codigo=s.ciu_codigo 
            join cliente c2 on c2.cli_codigo=nvc.cli_codigo 
               join personas p on p.per_codigo=c2.per_codigo 
            join tipo_comprobante tc on tc.tipco_codigo=nvc.tipco_codigo
            left join funcionario f on f.func_codigo=nvc.notven_funcionario 
               left join personas p2 on p2.per_codigo=f.per_codigo 
            left join chapa_vehiculo cv on cv.chave_codigo=nvc.notven_chapa 
               left join modelo_vehiculo mv on mv.modve_codigo=cv.modve_codigo 
                  left join marca_vehiculo mv2 on mv2.marve_codigo=mv.modve_codigo 
         where nvc.notven_codigo = $notven_codigo ";

$resultado = pg_query($conexion, $sql);
$cabecera = pg_fetch_assoc($resultado);

$sql2 = "select 
            vnvd.tipit_codigo,
            (case
               when vnvd.notvendet_cantidad = 0 then '-'
               else cast(vnvd.notvendet_cantidad as varchar)
            end) as notvendet_cantidad,
            (case
               when vnvd.tipit_codigo = 3 then vnvd.it_descripcion 
               else vnvd.it_descripcion ||'; TALLE '||vnvd.tall_descripcion
            end) as it_descripcion,
            vnvd.notvendet_precio,
            vnvd.grav10,
            vnvd.grav5,
            vnvd.exenta,
            (case
               when vnvd.tipit_codigo = 3 then vnvd.notvendet_precio 
               else vnvd.notvendet_cantidad*vnvd.notvendet_precio
            end) as subtotal
         from v_nota_venta_det vnvd 
            where vnvd.notven_codigo=$notven_codigo
            order by vnvd.tipit_codigo;";

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
   <title>Reporte Nota Venta</title>
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

      .nota {
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

      .cliente_remision {
         border: 1px solid #000;
         border-radius: 8px;
         margin-top: 8px;
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

   <div class="nota">
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
                  <div class="title">TIMBRADO N° <?php echo $cabecera['notven_timbrado'] ?></div>
                  <div style="font-size:12px; margin-top:6px;">Fecha Inicio Vigencia:
                     <?php echo $cabecera['notven_timbrado_inic'] ?>
                  </div>
                  <div style="font-size:12px; margin-top:4px;">Fecha Fin Vigencia:
                     <?php echo $cabecera['notven_timbrado_venc'] ?>
                  </div>
                  <div style="font-size:12px; margin-top:6px;">RUC.: <?php echo $cabecera['emp_ruc'] ?></div>
                  <div style="font-size:14px; margin-top:6px; ; font-weight: bold;">NOTA
                     <?php echo $cabecera['tipco_descripcion'] ?>
                  </div>
                  <div style="font-size:14px; margin-top:6px;"><?php echo $cabecera['notven_numeronota'] ?></div>
               </div>
            </td>
         </tr>
      </table>

      <!-- DATOS DE EMISIÓN Y CLIENTE -->
      <div class="cliente">
         <table class="info">
            <tr>
               <td class="label">FECHA EMISIÓN:</td>
               <td class="value"><?php echo $cabecera['notven_fecha'] ?></td>
               <td class="label">N° FACTURA:</td>
               <td class="value"><?php echo $cabecera['ven_numfactura'] ?></td>
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
            <tr>
               <td class="label">CONCEPTO:</td>
               <td class="value"><?php echo $cabecera['notven_concepto'] ?></td>
            </tr>
         </table>
      </div>

      <!-- DATOS EXTRA DE NOTA REMISION -->
      <?php if ($cabecera['tipco_descripcion'] == 'REMISION') { ?>
         <div class="cliente_remision">
            <table class="info">
               <tr>
                  <td class="value"><b>DATOS COURRIER Y VEHICULO DE ENTREGA</b></td>
               </tr>
               <tr>
                  <td class="label">COURRIER:</td>
                  <td class="value"><?php echo $cabecera['funcionario'] ?></td>
                  <td class="label">C.I.:</td>
                  <td class="value"><?php echo $cabecera['per_numerodocumento2'] ?></td>
               </tr>
               <tr>
                  <td class="label">MODELO VEHICULO:</td>
                  <td class="value"><?php echo $cabecera['modve_descripcion'] ?></td>
                  <td class="label">MARCA VEHICULO:</td>
                  <td class="value"><?php echo $cabecera['marve_descripcion'] ?></td>
               </tr>
               <tr>
                  <td class="label">CHAPA VEHICULO:</td>
                  <td class="value"><?php echo $cabecera['chave_chapa'] ?></td>
               </tr>
            </table>
         </div>
      <?php } ?>

      <!-- TABLA DE REMISION -->
      <?php if ($cabecera['tipco_descripcion'] == 'REMISION') { ?>
         <table class="items">
            <thead>
               <tr>
                  <th class="col-cant">CANTIDAD</th>
                  <th class="col-desc">DESCRIPCION</th>
                  <th class="col-unit">PRECIO UNITARIO</th>
                  <th class="col-ex">SUBTOTAL</th>
               </tr>
            </thead>
            <tbody>

               <?php foreach ($detalle as $posicion => $datos) {
                  $totalGralRemision += intval($datos['subtotal']);
                  ?>
                  <tr>
                     <td class="col-cant"><?php echo $datos['notvendet_cantidad'] ?></td>
                     <td class="col-desc"><?php echo $datos['it_descripcion'] ?></td>
                     <td class="col-unit"><?php echo number_format($datos['notvendet_precio'], 0, ',', '.'); ?></td>
                     <td class="col-iva10"><?php echo number_format($datos['subtotal'], 0, ',', '.'); ?></td>

                  </tr>
               <?php } ?>

               <tr>
                  <td colspan="3" class="gris"><strong>TOTAL GENERAL</strong></td>
                  <td style="text-align: right;"><?php echo number_format($totalGralRemision, 0, ',', '.'); ?></td>
               </tr>
               <tr>
                  <td colspan="4" class="gris"><strong>TOTAL FACTURA ASOCIADA (en
                        letras): </strong><?php echo strtoupper($formatter->format($totalGralRemision)); ?></td>
               </tr>
            </tbody>
         </table>

      <?php } else { ?>

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
                     $totalIva10 += intval($datos['notvendet_precio']);
                  } else {
                     $totalIva10 += intval($datos['grav10']);
                  }
                  ?>
                  <tr>
                     <td class="col-cant"><?php echo $datos['notvendet_cantidad'] ?></td>
                     <td class="col-desc"><?php echo $datos['it_descripcion'] ?></td>
                     <td class="col-unit"><?php echo number_format($datos['notvendet_precio'], 0, ',', '.'); ?></td>
                     <td class="col-ex"><?php echo number_format($datos['exenta'], 0, ',', '.'); ?></td>
                     <td class="col-iva5"><?php echo number_format($datos['grav5'], 0, ',', '.'); ?></td>
                     <?php if ($datos['tipit_codigo'] == '3') { ?>
                        <td class="col-iva10"><?php echo number_format($datos['notvendet_precio'], 0, ',', '.'); ?></td>
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

      <?php } ?>

   </div>

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
   $mail->addAddress("{$cabecera['per_email']}", "{$cabecera['cliente']}");

   //Guaradamos el pdf generado y le ponemos un nombre y extension
   $mail->addStringAttachment(
      $output,
      "8_DE_DICIEMBRE_{$cabecera['tipco_descripcion']}_Nro_{$cabecera['notven_numeronota']}.pdf"
   );

   // Contenido del correo
   $mail->isHTML(true);
   $mail->Subject = "CONFIRMACION DE NOTA DE {$cabecera['tipco_descripcion']} - Nro{$cabecera['notven_numeronota']}";
   $mail->Body = '
    <html>
    <head>
        <style>
            body { font-family: Arial, sans-serif; background: #f9f9f9; margin: 0; padding: 0; }
            .content { background: #ffffff; margin: 20px auto; padding: 25px; max-width: 600px; border-radius: 6px; box-shadow: 0 0 12px rgba(0,0,0,0.1); }
            h2 { color: #333333; }
            p { color: #555555; font-size: 15px; line-height: 1.6; }
            strong { color: #000000; }
        </style>
    </head>
    <body>
        <div class="content">
            <h2>Estimado(a) ' . htmlspecialchars($cabecera['cliente']) . ',</h2>
            <p>Esperamos que se encuentre bien. Nos complace informarle que la nota de ' . mb_strtolower($cabecera['tipco_descripcion'], 'UTF-8') . ' correspondiente a su gestión ha sido generada exitosamente en nuestro sistema.</p>
            <p>A continuación, le presentamos los detalles específicos de esta transacción para su control y seguimiento:</p>
            <p><strong>Número de nota de  ' . mb_strtolower($cabecera['tipco_descripcion'], 'UTF-8') . ':</strong> ' . htmlspecialchars($cabecera['notven_numeronota']) . '</p>
            <p>Los ítems o servicios indicados en esta nota de ' . mb_strtolower($cabecera['tipco_descripcion'], 'UTF-8') . ' deberán ser entregados o prestados dependiendo del tipo de nota en la siguiente dirección:</p>
            <p><strong>' . htmlspecialchars($cabecera['cli_direccion']) . '</strong></p>
            <p>Además, adjuntamos un archivo PDF que contiene toda la información detallada y soporte documental para su conveniencia y archivo.</p>
            <p>Le invitamos a revisar la información con atención y, si tiene alguna consulta o requiere mayor información, no dude en contactarnos a través de los canales habituales.</p>
            <p>Agradecemos su confianza y esperamos continuar colaborando estrechamente.</p>
            <p>Atentamente,<br><strong>8 DE DICIEMBRE - ' . htmlspecialchars($cabecera['suc_descripcion']) . '</strong></p>
        </div>
    </body>
</html>
';

   // Enviar el correo
   $mail->send();

   //echo 'Correo enviado con éxito';
   $response = array(
      "mensaje" => "LA NOTA DE {$cabecera['tipco_descripcion']} SE ENVIO A EL CLIENTE {$cabecera['cliente']}",
      "tipo" => "info"
   );

   echo json_encode($response);

} catch (Exception $e) {

   //echo "El correo no pudo ser enviado. Error: {$mail->ErrorInfo}";
   $response = array(
      "mensaje" => "LA NOTA DE {$cabecera['tipco_descripcion']} NO SE ENVIO A EL CLIENTE {$cabecera['cliente']}",
      "tipo" => "error"
   );

   echo json_encode($response);
}

?>