//Te envia al menu
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload();
};

//Se encarga de generar el reporte de la referencial ciudad
const ciudad = (desde, hasta) => {
  window.location = "reporte/reporte_ciudad.php";
  $("#tablas").val("");
};

//Se encarga de generar el reporte de la referencial empresa
const empresa = (desde, hasta) => {
  window.location =
    "reporte/reporte_empresa.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

//Se encarga de generar el reporte de la referencial sucursal
const sucursal = (desde, hasta) => {
  window.location =
    "reporte/reporte_sucursal.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

//Se encarga de generar el reporte de la referencial tipo impuesto
const tipoImpuesto = (desde, hasta) => {
  window.location =
    "reporte/reporte_tipo_impuesto.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

//Se encarga de generar el reporte de la referencial tipo proveedor
const tipoProveedor = (desde, hasta) => {
  window.location =
    "reporte/reporte_tipo_proveedor.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

//Se encarga de generar el reporte de la referencial tipo item
const tipoItem = (desde, hasta) => {
  window.location =
    "reporte/reporte_tipo_item.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

//Se encarga de generar el reporte de la referencial proveedor
const proveedor = (desde, hasta) => {
  window.location =
    "reporte/reporte_proveedor.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

//Se encarga de generar el reporte de la referencial deposito
const deposito = (desde, hasta) => {
  window.location =
    "reporte/reporte_deposito.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

//Se encarga de generar el reporte de la referencial items
const items = (desde, hasta) => {
  window.location =
    "reporte/reporte_items.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

//Se encarga de verificar que reporte se debe de generar
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

//Controla que los inputs no se pasen con valores vacios
const controlVacio = () => {
  let condicion;

  if ($("#tablas").val() == "") {
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

//Envia al input de tablas lo seleccionado en el autocompletado
const seleccionTablas = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTablas").html();
  $("#listaTablas").attr("style", "display: none;");
  $(".t").attr("class", "form-line t focused");
};

//Busca y muestra las referenciales de compras
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
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};
