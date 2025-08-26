//Se encarga de enviar la clave de verifcacion al correo
const enviarClave2 = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "/sys8DD/others/complements_php/correo/correo_envio_codigo_actualizacion.php",
    data: {
      usu_login: $("#usu_login").val(),
    },
  }) //Establecemos un mensaje segun el contenido de la respuesta
    .done(function (respuesta) {
      if (respuesta.mensaje == "NSE") {
        //Borramos el usuario
        $("#usu_login").val("");

        //Establecemos un mensaje de alerta y mostramos
        $(".mensajeAlert").html("EL USUARIO INGRESADO NO EXISTE");
        $("#alertaVerificacion").attr("style", "display: block;");
      } else {
        //Oculta el primer titulo
        $(".titulo1").attr("style", "display: none;");

        //Muestra el segundo titulo
        $(".titulo2").attr("style", "display: block;");

        //Mantenemos el usuario
        $("#usu_login").val(respuesta.usuario);
        $("#usu_login").prop("disabled", true);

        //Mostramos el input de digito verificador
        $(".verificador").prop("style", false);

        //Ocultamos el boton ingresar
        $("#botonIngresar").attr("style", "display: none;");

        //Mostramos los botones de verificar
        $("#botonVerificar").attr(
          "style",
          "display: flex; justify-content: space-between; align-items: center;"
        );

        //Establecemos un mensaje de alerta y mostramos
        $(".mensajeAlert").html(respuesta.mensaje);
        $("#alertaVerificacion").attr("style", "display: block;");
      }
    });
};

//Consulta si el digito ingresado es el correcto
const verificarDigito2 = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "/sys8DD/others/complements_php/validarDigitoContrasenia.php",
    data: {
      usu_login: $("#usu_login").val(),
      usu_clave: $("#usu_clave").val(),
    },
  }) //Establecemos un mensaje segun el contenido de la respuesta
    .done(function (respuesta) {
      if (respuesta.mensaje == "cambiar") {
        //Oculta el primer titulo
        $(".titulo1").attr("style", "display: none;");

        //Oculta el segundo titulo
        $(".titulo2").attr("style", "display: none;");

        //Muestra el tercer titulo titulo
        $(".titulo3").attr("style", "display: block;");

        //Ocultamos el input de clave
        $(".verificador").attr("style", "display: none;");

        //Mostramos el input de ingresar nueva contraseña
        $(".contrasenia").prop("style", false);

        //Establecemos un mensaje de alerta y mostramos
        $(".mensajeAlert").html("");
        $("#alertaVerificacion").attr("style", "display: none;");

        //Ocultamos el boton verificar
        $("#botonVerificar").attr("style", "display: none;");

        //Mostramos los botones de actualizar
        $("#botonActualizar").attr(
          "style",
          "display: flex; justify-content: space-between; align-items: center;"
        );
      } else if (respuesta.mensaje == "no_cambiar") {
        //Limpiamos el input de clave
        $("#usu_clave").val("");

        //Ocultamos contenedor del mensaje de verificacion
        $("#alertaVerificacion").attr("style", "display: none;");

        //Cargamos un nuevo mensaje
        $(".mensajeAlert").html(
          "CLAVE INCORRECTA, RECUERDE QUE TIENE UN TOTAL DE 3 INTENTOS"
        );

        //Mostramos de vuelta el contenedor con el mensaje actualizado
        $("#alertaVerificacion").attr("style", "display: block;");
      } else {
        cancelar2();
      }
    });
};

//Valida que la contraseña cumpla los requisitos
const validarContrasenia = (contra) => {
  // Definimos las expresiones regulares para cada requisito
  const tieneNumero = /[0-9]/;
  const tieneMinuscula = /[a-z]/;
  const tieneMayuscula = /[A-Z]/;
  const tieneSimbolo = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;
  const longitudMinima = 16;

  // Verificamos que cumpla todos los requisitos
  if (
    tieneNumero.test(contra) &&
    tieneMinuscula.test(contra) &&
    tieneMayuscula.test(contra) &&
    tieneSimbolo.test(contra) &&
    contra.length >= longitudMinima
  ) {
    return true;
  } else {
    return false;
  }
};

const erroresContrasenia = (contra) => {
  // Definimos las expresiones regulares para cada requisito
  const tieneNumero = /[0-9]/;
  const tieneMinuscula = /[a-z]/;
  const tieneMayuscula = /[A-Z]/;
  const tieneSimbolo = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;
  const longitudMinima = 16;

  // Array para almacenar los mensajes de error
  let errores = [];

  // Verificamos cada regla y agregamos el mensaje correspondiente si no se cumple
  if (!tieneNumero.test(contra)) {
    errores.push("FALTA UN NUMERO");
  }

  if (!tieneMinuscula.test(contra)) {
    errores.push("FALTA UNA LETRA MINUSCULA");
  }

  if (!tieneMayuscula.test(contra)) {
    errores.push("FALTA UNA LETRA MAYUSCULA");
  }

  if (!tieneSimbolo.test(contra)) {
    errores.push("FALTA UN SIMBOLO ESPECIAL");
  }

  if (contra.length < longitudMinima) {
    errores.push(`DEBE TENER COMO MINIMO ${longitudMinima} CARACTERES`);
  }

  // Si no hay errores, retornamos true
  if (errores.length === 0) {
    return true;
  }

  // Si hay errores, retornamos el array con los mensajes
  return errores;
};

//Compara si las contraseñas son iguales
const compararContrasenia = (contra1, contra2) => {
  return contra1 === contra2;
};

//Actauliza la contraseña del usuario
const actualizarContrasenia = (contra1, contra2) => {
  //Comparamos las 2 contraseñas
  if (compararContrasenia(contra1, contra2)) {
    //Validamos que la nueva contraseña cumpla con los requisitos
    if (validarContrasenia(contra1)) {
      $.ajax({
        //Enviamos datos al controlador
        method: "POST",
        url: "/sys8DD/others/complements_php/modificacionContrasenia.php",
        data: {
          usu_login: $("#usu_login").val(),
          contrasenia: $("#usu_contrasenia").val(),
        },
      }).done(function (respuesta) {
        //Validamos el mensaje
        if (respuesta.mensaje == "actualizado") {
          //Mostramos el mensaje de confirmacion de actualizacion
          $(".mensajeAlert").html(respuesta.estado);
          $("#alertaVerificacion").attr("style", "display: block;");

          //Ocultamos los inputs de contraseña
          $(".contrasenia").attr("style", "display: none;");

          //Ocultamos el boton de actualizar
          $(".btnActualizar").attr("style", "display: none;");

          //Ocultamos todos los titulos menos el ultimo
          $(".titulo1").attr("style", "display: none;");
          $(".titulo2").attr("style", "display: none;");
          $(".titulo3").attr("style", "display: none;");
          $(".titulo4").attr("style", "display: block;");
        }
      });
    } else {
      //Guardamos los errores
      let errores = erroresContrasenia(contra1);
      let htmlError = "";

      //Recorremos los errores
      errores.forEach((error) => {
        htmlError = "<p>" + error + "</p>";
      });

      //Mostramos los errores
      $(".mensajeAlert").html(htmlError);
      $("#alertaVerificacion").attr("style", "display: block;");
    }
  } else {
    //Mostramos que no coinciden las contraseñas
    $(".mensajeAlert").html("LAS CONTRASEÑAS NO COINCIDEN");
    $("#alertaVerificacion").attr("style", "display: block;");
  }
};

//Valida que no se deje vacio el apartado de usuario
const controlVacio4 = () => {
  let condicion;

  if ($("#usu_login").val() == "") {
    condicion = true;
  }

  if (condicion) {
    $(".mensajeAlert").html(
      "CARGUE EL USUARIO AL CUAL QUIERE ACTUALIZAR LA CONTRASEÑA"
    );
    $("#alertaVerificacion").attr("style", "display: block;");
  } else {
    enviarClave2();
  }
};

//Valida que no se deje vacio el apartado de clave
const controlVacio5 = () => {
  let condicion;

  if ($("#usu_clave").val() == "") {
    condicion = true;
  }

  if (condicion) {
    $(".mensajeAlert").html("CARGUE EL DIGITO DE VERIFICACIÓN");
    $("#alertaVerificacion").attr("style", "display: block;");
  } else {
    verificarDigito2();
  }
};

//Valida que no se deje vacio el apartado de clave
const controlVacio6 = () => {
  let condicion;

  if ($("#usu_contrasenia").val() == "") {
    condicion = true;
  } else if ($("#usu_contrasenia_confirmacion").val() == "") {
    condicion = true;
  }

  if (condicion) {
    $(".mensajeAlert").html("CARGUE AMBOS CAMPOS DE CONTRASEÑA");
    $("#alertaVerificacion").attr("style", "display: block;");
  } else {
    let contrasenia1 = $("#usu_contrasenia").val();
    let contrasenia2 = $("#usu_contrasenia_confirmacion").val();
    actualizarContrasenia(contrasenia1, contrasenia2);
  }
};

//Reenvia al usuario al login
const cancelar3 = () => {
  window.location = "/sys8DD/index.php";
};
