<?php
//Habiltamos variables de sesión
session_start();
//Destruimos las variables de sesión
session_destroy();
?>

<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
   <title>Iniciar Sesión</title>

   <?php include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/link_css.php" ?>

   <!-- Fondo Css -->
   <link href="others/complements_css/index.css" rel="stylesheet">
</head>

<body class="login-page fondo">
   <div class="login-box">
      <div class="logo">
         <a href="javascript:void(0);">8 de <b>Diciembre</b></a>
         <small>Dile adiós al “no tengo que ponerme”</small>
      </div>
      <div class="card">
         <div class="body">
            <div class="msg titutlo1" style="display: block;"><b>INGRESE SUS DATOS</b></div>
            <div class="msg titulo2" style="display: none;"><b>INGRESE EL DIGITO VERIFICADOR</b></div>
            <div class="input-group usuario">
               <span class="input-group-addon">
                  <i class="material-icons">person</i>
               </span>
               <div class="form-line">
                  <input type="text" class="form-control" id="usu_login" placeholder="Usuario" required autofocus>
               </div>
            </div>
            <div class="input-group contrasenia">
               <span class="input-group-addon">
                  <i class="material-icons">lock</i>
               </span>
               <div class="form-line">
                  <input type="password" class="form-control" id="usu_contrasenia" placeholder="Contraseña" required>
               </div>
            </div>
            <div class="input-group verificador" style="display: none;">
               <span class="input-group-addon">
                  <i class="material-icons">check_circle</i>
               </span>
               <div class="form-line">
                  <input type="text" class="form-control" id="usu_clave" placeholder="Digito verificador" required
                     autofocus>
               </div>
            </div>
            <div class="alert bg-teal alertaIndex hidden">
            </div>
            <div class="row">
               <div class="col-xs-12" id="botonIngresar" style="display: block">
                  <button class="btn btn-block bg-teal waves-effect" type="button"
                     onclick="verificarUsuario()">INGRESAR</button>
               </div>
               <div class="col-xs-12" id="botonVerificar"
                  style="display: none; justify-content: space-between; align-items: center;">
                  <div>
                     <button class="btn bg-teal waves-effect" type="button"
                        onclick="verificarDigito()">VERIFICAR</button>
                  </div>
                  <div>
                     <button class="btn btn-danger waves-effect" type="button" onclick="cancelar2()">
                        <i class="material-icons">cancel</i>
                     </button>
                     <button class="btn btn-primary bg-teal waves-effect" type="button" onclick="enviarClave()">
                        <i class="material-icons">autorenew</i>
                     </button>
                  </div>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-12">
                  <a href="others/complements_php/actualizarContrasenia.php" class="btn btn-link waves-effect"
                     style="padding: 0;">
                     ¿Olvidaste tu contraseña?
                  </a>
               </div>
            </div>
            <div class="alert bg-teal alert-dismissible" id="alertaVerificacion" role="alert" style="display: none;">
               <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span
                     aria-hidden="true">×</span></button>
               <div class="mensajeAlert" style="font-size: 12px; font-weight:bold;">
               </div>
            </div>
         </div>
      </div>
   </div>

   <?php include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/link_js.php" ?>

   <script src="/sys8DD/others/complements_js/acceso.js"></script>

</body>

</html>