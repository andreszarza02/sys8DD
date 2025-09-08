<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Requerimos conexion 
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Requerimos la librerias del vendor
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/vendor/autoload.php";

// Requerimos recursos de composer
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use PhpOffice\PhpSpreadsheet\Style\Border;

// Recibimos el codigo de solicitud presupuesto
$solpre_codigo = $_POST['solpre_codigo'] ?? $_GET['solpre_codigo'];

// Consultamos la cabecera
$sql = "select 
            spc.solpre_codigo,
            spc.pedco_codigo,
            spc.solpre_correo_proveedor,
            p.pro_razonsocial,
            p.pro_ruc,
            p.pro_direccion,
            s.suc_descripcion,
            s.suc_direccion,
            e.emp_razonsocial,
            e.emp_ruc 
         from solicitud_presupuesto_cab spc 
            join proveedor p on p.pro_codigo=spc.pro_codigo 
            and p.tipro_codigo=spc.tipro_codigo 
            join sucursal s on s.suc_codigo=spc.suc_codigo 
            and s.emp_codigo=spc.emp_codigo 
            join empresa e on e.emp_codigo=s.emp_codigo 
         where spc.solpre_codigo=$solpre_codigo;";

$resultado = pg_query($conexion, $sql);
$cabecera = pg_fetch_assoc($resultado);

// Consultamos el detalle
$sql2 = "select 
            spd.it_codigo,
            i.it_descripcion,
            spd.solpredet_cantidad,
            um.unime_descripcion
         from solicitud_presupuesto_det spd 
            join items i on i.it_codigo=spd.it_codigo 
            and i.tipit_codigo=spd.tipit_codigo  
            join unidad_medida um on um.unime_codigo=i.unime_codigo 
            where spd.solpre_codigo=$solpre_codigo
         order by spd.solpre_codigo, spd.it_codigo;";

$resultado2 = pg_query($conexion, $sql2);
$detalle = pg_fetch_all($resultado2);

// Creamos el excel en memoria y le asignamos un nombre al documento
$spreadsheet = new Spreadsheet();
$sheet = $spreadsheet->getActiveSheet();
$sheet->setTitle('SOLICITUD DE PRESUPUESTO N°' . $cabecera['solpre_codigo']);

// Creamos y definimos los datos de cabecera
$sheet->setCellValue('A1', 'N° PEDIDO:');
$sheet->setCellValue('B1', $cabecera['pedco_codigo']);
$sheet->setCellValue('A2', 'FECHA EMISION:');
$sheet->setCellValue('B2', '-');
$sheet->setCellValue('A3', 'PROVEEDOR:');
$sheet->setCellValue('B3', $cabecera['pro_razonsocial']);
$sheet->setCellValue('A4', 'RUC PROVEEDOR:');
$sheet->setCellValue('B4', $cabecera['pro_ruc']);
$sheet->setCellValue('A5', 'DIRECCION:');
$sheet->setCellValue('B5', $cabecera['pro_direccion']);
$sheet->setCellValue('A5', 'VENC. PRESUPUESTO:');
$sheet->setCellValue('B5', 'fecha de vencimiento de la propuesta');

// Datos de la empresa
$sheet->setCellValue('D1', 'EMPRESA:');
$sheet->setCellValue('E1', $cabecera['emp_razonsocial']);
$sheet->setCellValue('D2', 'RUC:');
$sheet->setCellValue('E2', $cabecera['emp_ruc']);
$sheet->setCellValue('D3', 'SUCURSAL:');
$sheet->setCellValue('E3', $cabecera['suc_descripcion']);
$sheet->setCellValue('D4', 'DIRECCION:');
$sheet->setCellValue('E4', $cabecera['suc_direccion']);

// Definimos las colmnas del detalle
$sheet->setCellValue('A7', 'CODIGO ITEM');
$sheet->setCellValue('B7', 'DESCRIPCION');
$sheet->setCellValue('C7', 'CANTIDAD SOLICITADA');
$sheet->setCellValue('D7', 'UNIDAD MEDIDA');
$sheet->setCellValue('E7', 'PRECIO UNITARIO');

// Cargamos datos del detalle
$fila_excel = 8;
foreach ($detalle as $fila) {
   $sheet->setCellValue("A{$fila_excel}", $fila['it_codigo']);
   $sheet->setCellValue("B{$fila_excel}", $fila['it_descripcion']);
   $sheet->setCellValue("C{$fila_excel}", $fila['solpredet_cantidad']);
   $sheet->setCellValue("D{$fila_excel}", $fila['unime_descripcion']);
   $sheet->setCellValue("E{$fila_excel}", 'A DEFINIR');
   $fila_excel++;
}

// Auto Size de columnas
foreach (range('A', 'E') as $col) {
   $sheet->getColumnDimension($col)->setAutoSize(true);
}

// Alinear a la izquierda varios campos
$sheet->getStyle('B1')->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT);
$sheet->getStyle('B4')->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT);
$sheet->getStyle('E2')->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT);

// Fondo verde y fuente blanco
$sheet->getStyle('A7:E7')->applyFromArray([
   'fill' => [
      'fillType' => Fill::FILL_SOLID,
      'startColor' => ['rgb' => '4caf50'] // verde
   ],
   'font' => [
      'bold' => true,
      'color' => ['rgb' => 'ffffff'] // blanco
   ]
]);

$sheet->getStyle('A1:A5')->applyFromArray([
   'fill' => [
      'fillType' => Fill::FILL_SOLID,
      'startColor' => ['rgb' => '4caf50'] // verde
   ],
   'font' => [
      'bold' => true,
      'color' => ['rgb' => 'ffffff'] // blanco
   ]
]);

$sheet->getStyle('D1:D4')->applyFromArray([
   'fill' => [
      'fillType' => Fill::FILL_SOLID,
      'startColor' => ['rgb' => '4caf50'] // verde
   ],
   'font' => [
      'bold' => true,
      'color' => ['rgb' => 'ffffff'] // blanco
   ]
]);

// Agregar borde a la tabla 
// Definimos el rango de datos (desde cabecera hasta última fila cargada)
$rango = "A7:E" . ($fila_excel - 1);

$sheet->getStyle($rango)->applyFromArray([
   'borders' => [
      'allBorders' => [
         'borderStyle' => Border::BORDER_THIN,
         'color' => ['rgb' => '000000']
      ]
   ]
]);

// Guardar excel creado en bufer
$writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
ob_start();
$writer->save('php://output');
$xlsBinary = ob_get_clean();

//Creamos el correo a enviar
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
   $mail->addAddress($cabecera['solpre_correo_proveedor'], $cabecera['pro_razonsocial']);

   //Adjuntamos el excel generado
   $mail->addStringAttachment(
      $xlsBinary,
      "SOLICITUD PRESUPUESTO Nro{$cabecera['solpre_codigo']}.xlsx",
      'base64',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
   );

   // Contenido del correo
   $mail->isHTML(true);
   $mail->Subject = "SOLICITUD DE PRESUPUESTO - Nro{$cabecera['solpre_codigo']}";
   $mail->Body = '
    <!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <style>
    body {
      font-family: Arial, sans-serif; 
      color: #333;
      line-height: 1.6;
    }
    .header, .footer {
      background-color: #f5f5f5; 
      padding: 10px; 
      border-radius: 5px;
    }
    .content {
      margin-top: 20px;
    }
    .highlight {
      font-weight: bold;
    }
  </style>
</head>
<body>
  <div class="header">
    <p><span class="highlight">Empresa: </span>' . htmlspecialchars($cabecera['emp_razonsocial']) . '</p>
    <p><span class="highlight">Sucursal: </span> ' . htmlspecialchars($cabecera['suc_descripcion']) . '</p>
    <p><span class="highlight">Dirección: </span> ' . htmlspecialchars($cabecera['suc_direccion']) . '</p>
  </div>

  <div class="content">
    <p>Estimado proveedor,</p>
    <ul>
      <li><span class="highlight">Proveedor: </span> ' . htmlspecialchars($cabecera['pro_razonsocial']) . '</li>
      <li><span class="highlight">RUC: </span> ' . htmlspecialchars($cabecera['pro_ruc']) . '</li>
      <li><span class="highlight">Dirección: </span> ' . htmlspecialchars($cabecera['pro_direccion']) . '</li>
    </ul>
    <p>Nos dirigimos a usted para solicitar un presupuesto por varios ítems y/o servicios que requerimos.</p>

    <p>Adjunto a este correo encontrará un archivo Excel que contiene el detalle de los ítems y/o servicios requeridos. Le solicitamos amablemente que complete únicamente los siguientes campos:</p>
    <ul>
      <li>Fecha de emisión y vencimiento del presupuesto</li>
      <li>Precio unitario de cada ítem en detalle</li>
    </ul>

    <p>Agradecemos su colaboración y quedamos atentos a que, una vez haya completado el archivo Excel adjunto, nos lo pueda devolver respondiento a este correo con el archivo adjunto. Esto nos permitirá evaluar su propuesta a la brevedad.</p>

    <p>Saludos cordiales,</p>
  </div>
</body>
</html>
';

   // Validamos que el detalle tenga items
   if (pg_num_rows($resultado2) > 0) {
      // Si tiene items enviamos el correo

      // Enviar el correo
      $mail->send();

      //Enviamos un mensaje de confirmacion de correo
      $response = array(
         "mensaje" => "LA SOLICITUD SE ENVIO A EL PROVEEDOR {$cabecera['pro_razonsocial']}",
         "tipo" => "info"
      );

   } else {

      //Si no tiene enviamos un mensaje
      $response = array(
         "mensaje" => "LA SOLICITUD NO SE ENVIO A EL PROVEEDOR {$cabecera['pro_razonsocial']}, YA QUE, LA MISMA NO CUENTA CON ITEMS EN EL DETALLE",
         "tipo" => "error"
      );

   }

   echo json_encode($response);

} catch (Exception $e) {

   //Enviamos un mensaje de no confirmacion de correo
   $response = array(
      "mensaje" => "LA SOLICITUD NO SE ENVIO A EL PROVEEDOR {$cabecera['pro_razonsocial']}",
      "tipo" => "error"
   );

   echo json_encode($response);
}

?>