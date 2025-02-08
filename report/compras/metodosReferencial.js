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

const ciudad = (desde, hasta) => {
  window.location =
    "reporte/reporte_ciudad.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const empresa = (desde, hasta) => {
  window.location =
    "reporte/reporte_empresa.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const sucursal = (desde, hasta) => {
  window.location =
    "reporte/reporte_sucursal.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const tipoImpuesto = (desde, hasta) => {
  window.location =
    "reporte/reporte_tipo_impuesto.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const tipoProveedor = (desde, hasta) => {
  window.location =
    "reporte/reporte_tipo_proveedor.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const tipoItem = (desde, hasta) => {
  window.location =
    "reporte/reporte_tipo_item.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const proveedor = (desde, hasta) => {
  window.location =
    "reporte/reporte_proveedor.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const deposito = (desde, hasta) => {
  window.location =
    "reporte/reporte_deposito.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const items = (desde, hasta) => {
  window.location =
    "reporte/reporte_items.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const imprimir = () => {
  let tabla = document.getElementById("tablas").value;
  let desde = $("#desde").val();
  let hasta = $("#hasta").val();

  if (tabla == "CIUDAD") {
    ciudad(desde, hasta);
  } else if (tabla == "EMPRESA") {
    empresa(desde, hasta);
  } else if (tabla == "SUCURSAL") {
    sucursal(desde, hasta);
  } else if (tabla == "TIPO IMPUESTO") {
    tipoImpuesto(desde, hasta);
  } else if (tabla == "TIPO PROVEEDOR") {
    tipoProveedor(desde, hasta);
  } else if (tabla == "TIPO ITEM") {
    tipoItem(desde, hasta);
  } else if (tabla == "PROVEEDOR") {
    proveedor(desde, hasta);
  } else if (tabla == "DEPOSITO") {
    deposito(desde, hasta);
  } else if (tabla == "ITEMS") {
    items(desde, hasta);
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
    //Solicitamos los datos a listaReferencialesSeguridad
    method: "GET",
    url: "/sys8DD/others/complements_php/listasModulos/listaReferencialesCompras.php",
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
