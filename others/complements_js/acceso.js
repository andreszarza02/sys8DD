//Definimos variables generales
const fechaActual = new Date();

// Obtener el año, mes y día de la fecha actual
const año = fechaActual.getFullYear();
const mes = fechaActual.getMonth() + 1; // Los meses en JavaScript van de 0 a 11, por lo que se suma 1
const día = fechaActual.getDate();
// Obtener la hora, minuto y segundos
const hora = fechaActual.getHours();
const minuto = fechaActual.getMinutes();
const segundo = fechaActual.getSeconds();

// Formatear la fecha  y la hora en el orden deseado
const fechaFormateada = `${año}-${mes < 10 ? "0" + mes : mes}-${
  día < 10 ? "0" + día : día
}`;
const horaFormateada = `${hora}:${minuto}:${segundo}`;

const cancelar2 = () => {
  window.location.reload(true);
};

//Se encarga de enviar la clave de verifcacion al correo
const enviarClave = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "/sys8DD/others/complements_php/correo/correo_envio_codigo_verificador.php",
    data: {
      usu_login: $("#usu_login").val(),
    },
  }) //Establecemos un mensaje segun el contenido de la respuesta
    .done(function (respuesta) {
      $(".mensajeAlert").html(respuesta.mensaje);
      $("#alertaVerificacion").attr("style", "display: block;");
    });
};

//Consultamos a la base de datos por el metodo post el usuario.
const verificarUsuario = () => {
  $.ajax({
    method: "POST",
    url: "others/complements_php/acceso.php",
    data: {
      usu_login: $("#usu_login").val(),
      usu_contrasenia: $("#usu_contrasenia").val(),
    },
  }).done(function (resultado) {
    //consultamos si el usuario se encuentra activo
    if (resultado.usu_estado == "INACTIVO") {
      //Si no es asi enviamos el mensaje
      let html = "<b>ESTE USUARIO SE ENCUENTRA INACTIVO.</b>";
      $(".alertaIndex").html(html);
      $(".alertaIndex").attr("class", "alert bg-teal alertaIndex");
      $("#usu_login").val("");
      $("#usu_contrasenia").val("");

      //cargamos acceso por intento
      $.ajax({
        method: "POST",
        url: "/sys8DD/others/complements_php/cargaAcceso.php",
        data: {
          usuario: resultado.usu_login,
          fecha: fechaFormateada,
          hora: horaFormateada,
          observacion: "USUARIO INACTIVO INTENTO INGRESAR",
        },
      });
    } else {
      //Si se encuntra activo validamos que concuerden los datos
      if (!resultado) {
        //si no concuerdan enviamos un mensaje
        let html = "<b>NO SE ENCONTRO EL USUARIO, INTENTELO DE NUEVO.</b>";
        $(".alertaIndex").html(html);
        $(".alertaIndex").attr("class", "alert bg-teal alertaIndex");
        $("#usu_contrasenia").val("");

        //cargamos acceso por intento
        $.ajax({
          method: "POST",
          url: "/sys8DD/others/complements_php/cargaAcceso.php",
          data: {
            usuario: $("#usu_login").val(),
            fecha: fechaFormateada,
            hora: horaFormateada,
            observacion: "USUARIO NO REGISTRADO INTENTO INGRESAR",
          },
        });

        //limpiamos cuadro de texto
        $("#usu_login").val("");
      } else {
        //Vacia el primer contenedor de mensaje
        $(".alertaIndex").html("");
        $(".alertaIndex").attr("style", "display: none;");

        //Oculta el primer titulo
        $(".titutlo1").attr("style", "display: none;");

        //Muestra el segundo titulo
        $(".titulo2").attr("style", "display: block;");

        //Guardamos en una variable el usuario
        let mantenerUsuario = $("#usu_login").val();

        //Mostramos en el input de usuario el usuario que quiere ingresar
        $("#usu_login").val(mantenerUsuario);

        //Limpiamos el input de contraseña
        $("#usu_contrasenia").val("");

        //Ocultamos el input de contraseña
        $(".contrasenia").attr("style", "display: none;");

        //Mostramos el input para ingresar el digito verificador
        $(".verificador").prop("style", false);

        //Mantenemos el usuario en el input de usuario
        $("#usu_login").prop("disabled", true);

        //Ocultamos el boton ingresar
        $("#botonIngresar").attr("style", "display: none;");

        //Mostramos los botones de verificar
        $("#botonVerificar").attr(
          "style",
          "display: flex; justify-content: space-between; align-items: center;"
        );

        //Metodo encargado de enviar la clave por email
        enviarClave();
      }
    }
  });
};

//Consulta si el digito ingresado es el correcto
const verificarDigito = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "/sys8DD/others/complements_php/validarDigito.php",
    data: {
      usu_login: $("#usu_login").val(),
      usu_clave: $("#usu_clave").val(),
    },
  }) //Establecemos un mensaje segun el contenido de la respuesta
    .done(function (respuesta) {
      if (respuesta.mensaje == "ingreso") {
        //accedemos al menu
        window.location = "menu.php";

        //cargamos acceso por intento
        $.ajax({
          method: "POST",
          url: "/sys8DD/others/complements_php/cargaAcceso.php",
          data: {
            usuario: $("#usu_login").val(),
            fecha: fechaFormateada,
            hora: horaFormateada,
            observacion: "USUARIO REGISTRADO INGRESO",
          },
        });
      } else if (respuesta.mensaje == "no_ingreso") {
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

//Permite ejecutar el ingreso al presionar enter
// document.addEventListener("keypress", function (e) {
//   if (e.keyCode === 13) {
//     verificarUsuario();
//   }
// });
