//Controla que los inputs no se queden vacios al perder el foco
const validacionInputsVacios = () => {
  //Creamos un array de inputs con la clase no-disabled y recorremos cada uno
  document.querySelectorAll("input.no-disabled").forEach((input) => {
    // Quitamos disabled para que pueda el input pueda recibir foco
    input.removeAttribute("disabled");

    //Agregamos un evento blur a cada input
    input.addEventListener("blur", () => {
      // Al perder el foco comprobamos si el valor esta vacio
      if (input.value.trim() === "") {
        // Obtenemos la clase padre del input y sacamos el valor del elemento label
        const label = input
          .closest(".form-line")
          ?.querySelector("label.form-label");

        // Armamos el mensaje a mostrar
        const labelText = label ? label.textContent.trim() : "VACIO";
        const mensaje = `El campo ${labelText} se encuentra vacío.`;

        // Mostramos el mensaje de alerta
        swal({
          title: "VALIDACION DE CAMPO",
          text: mensaje.toUpperCase(),
          type: "info",
        });
      }
    });
  });
};

//Permite aplicar un formato de tabla a la lista de la referencial
function formatoTabla() {
  //Exportable table
  $(".js-exportable").DataTable({
    language: {
      url: "//cdn.datatables.net/plug-ins/1.10.16/i18n/Spanish.json",
    },
    dom:
      "<'row'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
      "<'row'<'col-sm-12'tr>>" +
      "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
    responsive: true,
    buttons: [],
  });
}

//Consulta  y establece el codigo de la referencial
const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta: 1,
    },
  }).done(function (respuesta) {
    $("#emp_codigo").val(respuesta.emp_codigo);
  });
};

//Consulta y lista los datos en la grilla de la referencial
const listar = () => {
  $.ajax({
    //solicitamos los datos al controlador
    method: "GET",
    url: "controlador.php",
  })
    .done(function (respuesta) {
      //individualizamos el array de objetos y lo separamos por filas
      let tabla = "";
      for (objeto of respuesta) {
        tabla +=
          "<tr onclick='seleccionarFila(" +
          JSON.stringify(objeto).replace(/'/g, "&#39;") +
          ")'>";
        tabla += "<td>";
        tabla += objeto.emp_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.emp_telefono;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.emp_razonsocial;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.emp_ruc;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.emp_timbrado;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.emp_timbrado_fec_inic;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.emp_timbrado_fec_venc;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.emp_email;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.emp_actividad;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.emp_estado;
        tabla += "</td>";
        tabla += "</tr>";
      }
      //establecemos el body y el formato de la tabla
      $("#tabla_cuerpo").html(tabla);
      formatoTabla();
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Habilita botones de la referencial
const habilitarBotones = (booleano) => {
  if (booleano) {
    $(".botonesExtra1").attr("style", "display: block;");
    $(".botonesExtra2").attr("style", "display: none;");
  } else {
    $(".botonesExtra2").attr("style", "display: block;");
    $(".botonesExtra1").attr("style", "display: none;");
  }
};

//Saca el disabled de los inputs
const habilitarCampos = () => {
  $(".no-disabled").removeAttr("disabled");
};

//Metodo que establece el alta
const agregar = () => {
  $("#operacion").val(1);
  $("#procedimiento").val("ALTA");
  habilitarCampos();
  $(".activar").attr("class", "form-line activar focused");
  getCodigo();
  $(".est").attr("class", "form-line est focused");
  $("#emp_estado").val("ACTIVO");
  habilitarBotones(false);
  $("#emp_telefono").val("");
  $("#emp_razonsocial").val("");
  $("#emp_ruc").val("");
  $("#emp_email").val("");
  $("#emp_actividad").val("");
  $(".foco").attr("class", "form-line");
  $("#empresas").attr("style", "display: none");
  validacionInputsVacios();
};

//Metodo que establece la modificacion
const modificar = () => {
  $("#operacion").val(2);
  $("#procedimiento").val("MODIFICACION");
  $("#emp_estado").val("ACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarCampos();
  habilitarBotones(false);
  validacionInputsVacios();
};

//Metodo que establece la baja, en esta caso de manera logica
const borrar = () => {
  $("#operacion").val(3);
  $("#procedimiento").val("BAJA");
  $("#emp_estado").val("INACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

//Limpia los campos del formulario
const limpiarCampos = () => {
  window.location.reload(true);
};

//Pasa parametros en el controlador para persistir los mismos
const abm = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      emp_codigo: $("#emp_codigo").val(),
      emp_telefono: $("#emp_telefono").val(),
      emp_razonsocial: $("#emp_razonsocial").val(),
      emp_ruc: $("#emp_ruc").val(),
      emp_timbrado: $("#emp_timbrado").val(),
      emp_timbrado_fec_inic: $("#emp_timbrado_fec_inic").val(),
      emp_timbrado_fec_venc: $("#emp_timbrado_fec_venc").val(),
      emp_email: $("#emp_email").val(),
      emp_actividad: $("#emp_actividad").val(),
      emp_estado: $("#emp_estado").val(),
      operacion: $("#operacion").val(),
      usu_codigo: $("#usu_codigo").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
    },
  }) //Establecemos un mensaje segun el contenido de la respuesta
    .done(function (respuesta) {
      swal(
        {
          title: "RESPUESTA!!",
          text: respuesta.mensaje,
          type: respuesta.tipo,
        },
        function () {
          //Si la respuesta devuelve un success recargamos la pagina
          if (respuesta.tipo == "info") {
            limpiarCampos();
          }
        }
      );
    })
    .fail(function (a, b, c) {
      //obtenemos el error generado y guardamos dentro de una variable
      let errorTexto = a.responseText;
      let inicio = errorTexto.indexOf("{");
      let final = errorTexto.lastIndexOf("}") + 1;
      let errorJson = errorTexto.substring(inicio, final);

      //convertimos el string generado en un objeto
      let errorObjeto = JSON.parse(errorJson);

      //condicionamos la respuesta con el objeto
      if (errorObjeto.tipo == "error") {
        swal({
          title: "RESPUESTA!!",
          text: errorObjeto.mensaje,
          type: errorObjeto.tipo,
        });
      }
    });
};

// Establece los mensajes de confirmacion de las operaciones
const confirmar = () => {
  //solicitamos el value del input operacion
  var oper = $("#operacion").val();

  preg = "¿Desea agregar el registro?";

  /* De acuerdo si la operacion es 2 o 3 modificamos la pregunta */
  if (oper == 2) {
    preg = "¿Desea modificar el registro?";
  }

  if (oper == 3) {
    preg = "¿Desea eliminar el registro?";
  }
  swal(
    {
      title: "Atención!!!",
      text: preg.toUpperCase(),
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "SI",
      cancelButtonText: "NO",
      closeOnConfirm: false,
      closeOnCancel: false,
    },
    function (isConfirm) {
      //Si la operacion es correcta llamamos al metodo grabar
      if (isConfirm) {
        abm();
      } else {
        //Si cancelamos la operacion realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

//Controla que todos los inputs de la referencial no se pasen con valores vacios
const controlVacio = () => {
  let condicion;

  if ($("#emp_codigo").val() == 0) {
    condicion = true;
  } else if ($("#emp_telefono").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#emp_ruc").val() == "") {
    condicion = true;
  } else if ($("#emp_timbrado").val() == "") {
    condicion = true;
  } else if ($("#emp_timbrado_fec_inic").val() == "") {
    condicion = true;
  } else if ($("#emp_timbrado_fec_venc").val() == "") {
    condicion = true;
  } else if ($("#emp_email").val() == "") {
    condicion = true;
  } else if ($("#emp_actividad").val() == "") {
    condicion = true;
  } else if ($("#emp_estado").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "CARGUE TODOS LOS CAMPOS EN BLANCO",
      type: "error",
    });
  } else {
    confirmar();
  }
};

//Envia a los inputs de la referencial lo seleccionado por el usuario en la grilla
const seleccionarFila = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".foco").attr("class", "form-line foco focused");
  $(".activar").attr("class", "form-line activar focused");
  $(".est").attr("class", "form-line est focused");
};

//Te envia al menu
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

listar();
