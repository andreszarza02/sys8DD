<?php
//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Solicitamos la librerias del vendor
require "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/vendor/autoload.php";

//Incluimos el archivo de funciones
include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/funciones/funciones.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

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

//Cargamos la tabla acceso control con el dato de intento de sesion
$sql2 = "INSERT INTO acceso_control (accon_codigo, accon_usuario, accon_clave, accon_fecha, accon_hora, accon_observacion, accon_intentos, accon_ip, accon_ip_pais, accon_ip_region, accon_ip_ciudad)
VALUES((select coalesce(max(accon_codigo),0)+1 from acceso_control), '$usuario', '$numeroRandom', current_date, current_time, 'SE ENVIO LA CLAVE DE VERIFICACION', 0, '$ip', '$pais', '$region', '$ciudad');";

//Ejecutamos la consulta
$resultado2 = pg_query($conexion, $sql2);

//Llamamos a la libreria PHP Mailer
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

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
   $mail->Subject = "DIGITO DE VERIFICACION DE USUARIO";
   $mail->Body = '
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
            <p>Gracias por registrarte. Tu código de verificación es:</p>
            <p class="code">' . $numeroRandom . '</p>
            <p>Por favor, ingresa este código en el login del sistema para verificar tu usuario.</p>
            <p>Si no solicitaste este código, puedes ignorar este correo.</p>
         </div>
         <div class="footer">
            <p>Este es un correo automático, por favor no respondas.</p>
         </div>
      </body>
      </html>';

   // Enviar el correo
   $mail->send();

   //echo 'Correo enviado con éxito';
   $response = array(
      "mensaje" => "SE ENVIO EL DIGITO AL CORREO DEL USUARIO"
   );

   echo json_encode($response);

} catch (Exception $e) {

   //echo "El correo no pudo ser enviado. Error: {$mail->ErrorInfo}";
   $response = array(
      "mensaje" => "NO SE ENVIO EL DIGITO AL CORREO DEL USUARIO"
   );

   echo json_encode($response);
}



?>