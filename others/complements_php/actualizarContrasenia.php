<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
   <title>Actualizacion Contraseña</title>

   <?php include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/link_css.php" ?>

   <!-- Fondo Css -->
   <link href="/sys8DD/others/complements_css/index.css" rel="stylesheet">
</head>

<body class="login-page fondo">
   <div class="login-box">
      <div class="logo bg-teal">
         <a href="javascript:void(0);">8 de <b>Diciembre</b></a>
         <small><b>ACTUALIZACION DE CONTRASEÑA USUARIO</b></small>
      </div>
      <div class="card">
         <div class="body">
            <div class="msg titulo1" style="display: block;"><b>INGRESE SU USUARIO</b></div>
            <div class="msg titulo2" style="display: none;"><b>INGRESE EL DIGITO VERIFICADOR</b></div>
            <div class="msg titulo3" style="display: none;"><b>INGRESE SU NUEVA CONTRASEÑA</b></div>
            <div class="msg titulo4" style="display: none;"><b>CONTRASEÑA ACTUALIZADA DE FORMA CORRECTA</b></div>
            <div class="input-group usuario">
               <span class="input-group-addon">
                  <i class="material-icons">person</i>
               </span>
               <div class="form-line">
                  <input type="text" class="form-control" id="usu_login" placeholder="Usuario" required autofocus>
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
            <div class="input-group contrasenia" style="display: none;">
               <span class="input-group-addon">
                  <i class="material-icons">done</i>
               </span>
               <div class="form-line">
                  <input type="password" class="form-control" id="usu_contrasenia" placeholder="Nueva contraseña"
                     required>
               </div>
            </div>
            <div class="input-group contrasenia" style="display: none;">
               <span class="input-group-addon">
                  <i class="material-icons">done_all</i>
               </span>
               <div class="form-line">
                  <input type="password" class="form-control" id="usu_contrasenia_confirmacion"
                     placeholder="Confirme contraseña" required>
               </div>
            </div>
            <div class="row">
               <div class="col-xs-12" id="botonIngresar" style="display: block">
                  <button class="btn btn-block bg-teal waves-effect" type="button" onclick="controlVacio4()">ENVIAR
                     DIGITO VERIFICADOR</button>
               </div>
               <div class="col-xs-12" id="botonVerificar"
                  style="display: none; justify-content: space-between; align-items: center;">
                  <div>
                     <button class="btn bg-teal waves-effect" type="button" onclick="controlVacio5()">VERIFICAR</button>
                  </div>
                  <div>
                     <button class="btn btn-danger waves-effect" type="button" onclick="cancelar3()">
                        <i class="material-icons">cancel</i>
                     </button>
                     <button class="btn btn-primary bg-teal waves-effect" type="button" onclick="enviarClave2()">
                        <i class="material-icons">autorenew</i>
                     </button>
                  </div>
               </div>
               <div class="col-xs-12" id="botonActualizar"
                  style="display: none; justify-content: space-between; align-items: center;">
                  <div>
                     <button class="btn bg-teal waves-effect btnActualizar" type="button"
                        onclick="controlVacio6()">ACTUALIZAR</button>
                  </div>
                  <div>
                     <button class="btn btn-primary waves-effect" type="button" onclick="cancelar3()">VOLVER AL
                        LOGIN</button>
                  </div>
               </div>

            </div>
            <div class="alert bg-teal" id="alertaVerificacion" style="display: none;">
               <div class="mensajeAlert" style="font-size: 12px; font-weight:bold;">
               </div>
            </div>
         </div>
      </div>
   </div>

   <?php include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/link_js.php" ?>

   <script src="/sys8DD/others/complements_js/actualizacionContrasenia.js"></script>

</body>

</html>