const cambioInterfaz = (condicion) => {
  if (condicion) {
    $(".movimientos").attr("style", "display: block;");
    $(".stock").attr("style", "display: none;");
  } else {
    $(".movimientos").attr("style", "display: none;");
    $(".stock").attr("style", "display: block;");
  }
};

const salir = () => {
  window.location = "/sys8DD/menu.php";
};

const limpiarCampos = () => {
  window.location.reload();
};

const pedidoCompra = (desde, hasta) => {
  window.location =
    "reporte/reporte_pedido_compra.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const imprimir = () => {
  let tabla = document.getElementById("tablas").value;
  let desde = $("#desde").val();
  let hasta = $("#hasta").val();
  let deposito = $("#dep_codigo").val();

  if (tabla == "PEDIDO COMPRA") {
    pedidoCompra(desde, hasta);
  } else if (tabla == "PRESUPUESTO PROVEEDOR") {
    presupuestoProveedor(desde, hasta);
  } else if (tabla == "ORDEN COMPRA") {
    ordenCompra(desde, hasta);
  } else if (tabla == "COMPRA") {
    compra(desde, hasta);
  } else if (tabla == "NOTA COMPRA") {
    notaCompra(desde, hasta);
  } else if (tabla == "AJUSTE INVENTARIO") {
    ajusteInventario(desde, hasta);
  } else if (tabla == "CUENTA PAGAR") {
    cuentaPagar(desde, hasta);
  } else if (tabla == "LIBRO COMPRA") {
    libroCompra(desde, hasta);
  } else if (tabla == "STOCK") {
    stock(deposito);
  }

  $("#desde").val("");
  $("#hasta").val("");
};

const controlVacio = () => {
  let tabla = document.getElementById("tablas").value;
  let condicion;

  if (tabla == "STOCK") {
    if ($("#dep_codigo").val() == "0") {
      condicion = true;
    }
  } else {
    if ($("#desde").val() == "") {
      condicion = true;
    } else if ($("#hasta").val() == "") {
      condicion = true;
    } else if ($("#tablas").val() == "") {
      condicion = true;
    }
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
    //Solicitamos los datos a listaMovimientosProduccion
    method: "GET",
    url: "/sys8DD/others/complements_php/listasModulos/listaMovimientosProduccion.php",
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
