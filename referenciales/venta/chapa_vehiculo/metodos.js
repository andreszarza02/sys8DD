//Controla que los inputs no se queden vacios al perder el foco y que solo contengan letras y numeros
const validacionInputsVacios = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase letras-numeros realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("letras-numeros")
      ) {
        //Definimos variables a utilizar
        let mensaje = "";
        const tieneSimbolo = /[¨!°¬@#$%^&*()_~+\-=\[\]{};':"\\|,.<>\/?]/;

        // Comprobamos si el input esta vacio
        if (input.value.trim() === "") {
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");

          // Armamos el mensaje a mostrar
          const labelText = label ? label.textContent.trim() : "VACIO";
          mensaje = `El campo ${labelText} se encuentra vacío.`;
        } else {
          // Si no está vacío, comprobamos si contiene simbolos
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene simbolos
          if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} contiene símbolos`;
          }
        }

        // Si mensaje no está vacío, mostramos la alerta
        if (mensaje !== "") {
          swal({
            title: "VALIDACION DE CAMPO",
            text: mensaje.toUpperCase(),
            type: "info",
          });
          // Limpiamos el valor del input
          input.value = "";
        }
      }
    },
    true
  ); // usa true para captar el evento en la fase de captura y asegurar que blur funciona bien
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
    $("#chave_codigo").val(respuesta.chave_codigo);
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
        tabla += objeto.chave_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.modve_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.marve_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.chave_chapa;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.chave_estado;
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
  $(".est").attr("class", "form-line est focused");
  getCodigo();
  $("#chave_estado").val("ACTIVO");
  habilitarBotones(false);
  $(".activar").attr("class", "form-line activar focused");
  $("#chave_chapa").val("");
  $("#modve_codigo").val("");
  $("#marve_codigo").val("");
  $("#modve_descripcion").val("");
  $("#marve_descripcion").val("");
  $("#descripcion").val("");
  $(".foco").attr("class", "form-line foco");
  $(".mod").attr("class", "form-line mod");
  $("#chapas_vehiculos").attr("style", "display: none;");
  validacionInputsVacios();
};

//Metodo que establece la modificacion
const modificar = () => {
  $("#operacion").val(2);
  $("#procedimiento").val("MODIFICACION");
  $("#chave_estado").val("ACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarCampos();
  habilitarBotones(false);
  validacionInputsVacios();
};

//Metodo que establece la baja, en esta caso de manera logica
const borrar = () => {
  $("#operacion").val(3);
  $("#procedimiento").val("BAJA");
  $("#chave_estado").val("INACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

//Limpia los campos del formulario
const limpiarCampos = () => {
  window.location.reload();
};

//Pasa parametros en el controlador para persistir los mismos
const abm = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      chave_codigo: $("#chave_codigo").val(),
      chave_chapa: $("#chave_chapa").val(),
      modve_codigo: $("#modve_codigo").val(),
      marve_codigo: $("#marve_codigo").val(),
      chave_estado: $("#chave_estado").val(),
      operacion: $("#operacion").val(),
      usu_codigo: $("#usu_codigo").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
      modve_descripcion: $("#modve_descripcion").val(),
      marve_descripcion: $("#marve_descripcion").val(),
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
      title: "ATENCIÓN!!!",
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

  if ($("#chave_codigo").val() == "0") {
    condicion = true;
  } else if ($("#chave_chapa").val() == "") {
    condicion = true;
  } else if ($("#modve_descripcion").val() == "") {
    condicion = true;
  } else if ($("#marve_descripcion").val() == "") {
    condicion = true;
  } else if ($("#descripcion").val() == "") {
    condicion = true;
  } else if ($("#chave_estado").val() == "") {
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

  $(".activar").attr("class", "form-line activar focused");
  $(".foco").attr("class", "form-line foco focused");
  $(".mod").attr("class", "form-line mod focused");
  $(".est").attr("class", "form-line est focused");
};

//Envia a su respectivo input lo seleccionado por el usuario en la lista
const seleccionModeloVehiculo = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulModelo").html();
  $("#listaModelo").attr("style", "display: none;");
  $(".mod").attr("class", "form-line mod focused");
};

//Obtiene los datos de modelo vehiculo y los muestra en una lista
const getModeloVehiculo = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaModeloVehiculo.php",
    data: {
      descripcion: $("#descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionModeloVehiculo(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulModelo").html(fila);
      //hacemos visible la lista
      $("#listaModelo").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Te envia al menu
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

listar();
