<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/vendor/autoload.php"; // Asegúrate de ajustar la ruta según tu estructura de carpetas 

$mail = new PHPMailer(true);

try {
   // Configuración del servidor SMTP
   $mail->isSMTP();
   $mail->Host = 'smtp.gmail.com'; // Especifica el servidor SMTP
   $mail->SMTPAuth = true;
   $mail->Username = 'adm.8DD@gmail.com'; // Tu nombre de usuario SMTP
   $mail->Password = 'upav neje qmtf bvpo'; // Tu contraseña SMTP
   $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS; // Habilitar SSL
   $mail->Port = 465; // Puerto TCP para ssl

   // Remitente y destinatario
   $mail->setFrom('adm.8DD@gmail.com', '
   Admnistracion 8 de Diciembre');
   $mail->addAddress('sisinio.zarza2002@gmail.com', 'Sisinio Zarza');

   // Contenido del correo
   $mail->isHTML(true);
   $mail->Subject = 'prueba';
   $mail->Body = '<b>Este es el cuerpo del mensaje en HTML</b>';
   $mail->AltBody = 'Este es el cuerpo en texto plano para clientes que no soportan HTML';

   // Enviar el correo
   //$mail->SMTPDebug = 2; // Habilitar depuración
   $mail->send();
   echo 'Correo enviado con éxito';
} catch (Exception $e) {
   echo "El correo no pudo ser enviado. Error: {$mail->ErrorInfo}";
}
?>