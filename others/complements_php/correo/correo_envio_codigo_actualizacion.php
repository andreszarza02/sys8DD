<?php
//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Solicitamos la librerias del vendor
require "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/vendor/autoload.php";

//Incluios el archivo de funciones
include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/funciones/funciones.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Llamamos a la libreria PHP Mailer
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

//Establecemos las variables a utilizar
$usuario = $_POST['usu_login'];
$numeroRandom = generar6DigitosAleatorios();

//Consultamos el nombre y correo de la persona
$sql = "select 
            p.per_nombre||' '||p.per_apellido as persona,
            p.per_email 
         from usuario u 
            join funcionario f on f.func_codigo=u.func_codigo 
            join personas p on p.per_codigo=f.per_codigo
         where u.usu_login ilike '%$usuario%';";

//Ejecutamos la consulta
$resultado = pg_query($conexion, $sql);
$correoUsuario = pg_fetch_assoc($resultado);

//Obtenemos la ip publica de la pc, al consultar el mismo a una api externa, por internet
$ip = file_get_contents('https://api.ipify.org');

//llamamos a la funcion que obtiene los datos de la ip
$datosIp = obtenerDatosIP($ip);

//Guardamos los datos obtenidos en variables, pasamos de un array a variables
list($pais, $region, $ciudad) = $datosIp;

if (!isset($correoUsuario['persona'])) {

   //Enviamos un mensaje confirmando que el usuario no existe
   $response = array(
      "mensaje" => "NSE"
   );

} else {

   //Cargamos la tabla acceso control con el dato de intento de sesion
   $sql2 = "INSERT INTO actualizacion_contrasenia (accontra_codigo, accontra_usuario, accontra_clave, accontra_fecha, accontra_hora, accontra_observacion, accontra_intentos, accontra_ip, accontra_ip_pais, accontra_ip_region, accontra_ip_ciudad)
   VALUES((select coalesce(max(accontra_codigo),0)+1 from actualizacion_contrasenia), '$usuario', '$numeroRandom', current_date, current_time, 'SE ENVIO LA CLAVE DE VERIFICACION', 0, '$ip', '$pais', '$region', '$ciudad');";

   //Ejecutamos la consulta
   $resultado2 = pg_query($conexion, $sql2);

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
   Administracion 8 de Diciembre');
      $mail->addAddress("{$correoUsuario['per_email']}", "{$correoUsuario['persona']}");

      // Contenido del correo
      $mail->isHTML(true);
      $mail->Subject = "DIGITO DE CONFIRMACION DE ACTUALIZACION DE CONTRASENIA";
      $mail->Body = '
      <!DOCTYPE html>
      <html lang="es">
      <head>
         <style>
            body {
                  font-family: Arial, sans-serif;
                  background-color: #f4f4f4;
                  margin: 0;
                  padding: 20px;
            }
            .container {
                  background-color: #ffffff;
                  padding: 20px;
                  border-radius: 5px;
                  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }
            .code {
                  font-size: 24px;
                  font-weight: bold;
                  color: #007bff;
            }
            .footer {
                  margin-top: 20px;
                  font-size: 12px;
                  color: #777;
            }
         </style>
      </head>
      <body>
         <div class="container">
            <h2>¡Hola!</h2>
            <p>Has solicitado un cambio de contraseña. Tu código de verificación es:</p>
            <p class="code">' . $numeroRandom . '</p>
            <p>Por favor, ingresa este código en el sistema para continuar con el proceso de cambio de contraseña.</p>
            <p>Si no solicitaste este cambio, puedes ignorar este correo.</p>
         </div>
         <div class="footer">
            <p>Este es un correo automático, por favor no respondas.</p>
         </div>
      </body>
      </html>';

      // Enviar el correo
      $mail->send();

      //Enviamos un mensaje confirmando el envio del correo
      $response = array(
         "mensaje" => "SE ENVIO EL DIGITO AL CORREO ASOCIADO AL USUARIO",
         "usuario" => $usuario
      );

   } catch (Exception $e) {

      //Enviamos un mensaje confirmando el no envio del correo
      $response = array(
         "mensaje" => "NO SE ENVIO EL DIGITO AL CORREO ASOCIADO AL USUARIO"
      );

      echo json_encode($response);
   }

}

echo json_encode($response);




?>