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
        tabla += objeto.costserv_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.mod_codigomodelo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.costserv_costo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.costserv_estado;
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

const habilitarBotones = (booleano) => {
  if (booleano) {
    $(".botonesExtra1").attr("style", "display: block;");
    $(".botonesExtra2").attr("style", "display: none;");
  } else {
    $(".botonesExtra2").attr("style", "display: block;");
    $(".botonesExtra1").attr("style", "display: none;");
  }
};

const habilitarCampos = () => {
  $(".no-disabled").removeAttr("disabled");
};

const agregar = () => {
  $("#operacion").val(1);
  habilitarCampos();
  $(".activar").attr("class", "form-line activar focused");
  $("#costos").attr("style", "display: none");
  $(".est").attr("class", "form-line est focused");
  $(".mo").attr("class", "form-line mo");
  $(".foco").attr("class", "form-line foco");
  $("#costserv_codigo").val(0);
  $("#mod_codigo").val(0);
  $("#costserv_estado").val("ACTIVO");
  $("#mod_codigomodelo").val("");
  $("#costserv_costo").val("");
  habilitarBotones(false);
};

const modificar = () => {
  $("#operacion").val(2);
  $("#costserv_estado").val("ACTIVO");
  habilitarCampos();
  habilitarBotones(false);
};

const borrar = () => {
  $("#operacion").val(3);
  habilitarBotones(false);
};

const limpiarCampos = () => {
  window.location.reload();
};

const abm = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      costserv_codigo: $("#costserv_codigo").val(),
      costserv_costo: $("#costserv_costo").val(),
      costserv_estado: $("#costserv_estado").val(),
      mod_codigo: $("#mod_codigo").val(),
      operacion: $("#operacion").val(),
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
      text: preg,
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

const controlVacio = () => {
  let condicion;

  if ($("#costserv_codigo").val() == "") {
    condicion = true;
  } else if ($("#costserv_costo").val() == "") {
    condicion = true;
  } else if ($("#costserv_estado").val() == "") {
    condicion = true;
  } else if ($("#mod_codigomodelo").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "Cargue todos los campos en blanco",
      type: "error",
    });
  } else {
    confirmar();
  }
};

const seleccionarFila = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".activar").attr("class", "form-line activar focused");
  $(".mo").attr("class", "form-line mo focused");
  $(".foco").attr("class", "form-line foco focused");
  $(".est").attr("class", "form-line est focused");
};

const seleccionModelo = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulModelo").html();
  $("#listaModelo").attr("style", "display: none;");
  $(".mo").attr("class", "form-line mo focused");
};

const getModelo = () => {
  $.ajax({
    //Solicitamos los datos a listaModelo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaModelo.php",
    data: {
      mod_codigomodelo: $("#mod_codigomodelo").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionModelo(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.mod_codigomodelo +
          "</li>";
      });

      //cargamos la lista
      $("#ulModelo").html(fila);
      //hacemos visible la lista
      $("#listaModelo").attr(
        "style",
        "display: block; position:absolute; z-index: 3000;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const salir = () => {
  window.location = "/sys8DD/menu.php";
};

listar();
