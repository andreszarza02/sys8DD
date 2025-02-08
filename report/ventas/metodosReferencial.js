const inputs = () => {
  let tabla = $("#tablas").val();
  if (tabla == "USUARIOS" || tabla == "ACCESO") {
    $("#desde").attr("type", "date");
    $("#hasta").attr("type", "date");
  } else {
    $("#desde").attr("type", "text");
    $("#hasta").attr("type", "text");
  }
};

const salir = () => {
  window.location = "/sys8DD/menu.php";
};

const limpiarCampos = () => {
  window.location.reload();
};

const tipoDocumento = (desde, hasta) => {
  window.location =
    "reporte/reporte_tipo_documento.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const tipoComprobante = (desde, hasta) => {
  window.location =
    "reporte/reporte_tipo_comprobante.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const formaCobro = (desde, hasta) => {
  window.location =
    "reporte/reporte_forma_cobro.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const marcaTarjeta = (desde, hasta) => {
  window.location =
    "reporte/reporte_marca_tarjeta.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const entitdadEmisora = (desde, hasta) => {
  window.location =
    "reporte/reporte_entidad_emisora.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const entidadAdherida = (desde, hasta) => {
  window.location =
    "reporte/reporte_entidad_adherida.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const caja = (desde, hasta) => {
  window.location =
    "reporte/reporte_caja.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const cliente = (desde, hasta) => {
  window.location =
    "reporte/reporte_clientes.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const imprimir = () => {
  let tabla = document.getElementById("tablas").value;
  let desde = $("#desde").val();
  let hasta = $("#hasta").val();

  if (tabla == "TIPO DOCUMENTO") {
    tipoDocumento(desde, hasta);
  } else if (tabla == "TIPO COMPROBANTE") {
    tipoComprobante(desde, hasta);
  } else if (tabla == "FORMA COBRO") {
    formaCobro(desde, hasta);
  } else if (tabla == "MARCA TARJETA") {
    marcaTarjeta(desde, hasta);
  } else if (tabla == "ENTIDAD EMISORA") {
    entitdadEmisora(desde, hasta);
  } else if (tabla == "ENTIDAD ADHERIDA") {
    entidadAdherida(desde, hasta);
  } else if (tabla == "CAJA") {
    caja(desde, hasta);
  } else if (tabla == "CLIENTES") {
    cliente(desde, hasta);
  }

  $("#desde").val("");
  $("#hasta").val("");
};

const controlVacio = () => {
  let condicion;

  if ($("#desde").val() == "") {
    condicion = true;
  } else if ($("#hasta").val() == "") {
    condicion = true;
  } else if ($("#tablas").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "Cargue todos los campos en blanco",
      type: "error",
    });
  } else {
    imprimir();
  }
};

const seleccionTablas = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTablas").html();
  $("#listaTablas").attr("style", "display: none;");
  $(".t").attr("class", "form-line t focused");
};

const getTablas = () => {
  $.ajax({
    //Solicitamos los datos a listaReferencialesVentas
    method: "GET",
    url: "/sys8DD/others/complements_php/listasModulos/listaReferencialesVentas.php",
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionTablas(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.tablas +
          "</li>";
      });

      //cargamos la lista
      $("#ulTablas").html(fila);
      //hacemos visible la lista
      $("#listaTablas").attr(
        "style",
        "display: block; position:absolute; z-index: 3000;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};
