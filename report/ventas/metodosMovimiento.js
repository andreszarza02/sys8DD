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

const presupuestoProveedor = (desde, hasta) => {
  window.location =
    "reporte/reporte_presupuesto_proveedor.php?desde=" +
    desde +
    "&hasta=" +
    hasta;
  $("#tablas").val("");
};

const ordenCompra = (desde, hasta) => {
  window.location =
    "reporte/reporte_orden_compra.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const compra = (desde, hasta) => {
  window.location =
    "reporte/reporte_compra.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const notaCompra = (desde, hasta) => {
  window.location =
    "reporte/reporte_nota_compra.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const ajusteInventario = (desde, hasta) => {
  window.location =
    "reporte/reporte_ajuste_inventario.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};
const cuentaPagar = (desde, hasta) => {
  window.location =
    "reporte/reporte_cuenta_pagar.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const libroCompra = (desde, hasta) => {
  window.location =
    "reporte/reporte_libro_compra.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const stock = (deposito) => {
  window.location = "reporte/reporte_stock.php?deposito=" + deposito;
  $("#dep_descripcion").val("");
  $("#dep_codigo").val("0");
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

  if ($("#tablas").val() == "STOCK") {
    cambioInterfaz(false);
  } else {
    cambioInterfaz(true);
  }
};

const getTablas = () => {
  $.ajax({
    //Solicitamos los datos a listaMovimientosCompras
    method: "GET",
    url: "/sys8DD/others/complements_php/listasModulos/listaMovimientosCompras.php",
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

const seleccionDeposito = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulDeposito").html();
  $("#listaDeposito").attr("style", "display: none;");
  $(".dep").attr("class", "form-line dep focused");
};

const getDeposito = () => {
  $.ajax({
    //Solicitamos los datos a listaDeposito
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaDeposito.php",
    data: {
      suc_codigo: $("#sucursalCodigo").val(),
      emp_codigo: $("#empresacodigo").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionDeposito(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.dep_descripcion +
          "</li>";
      });

      //cargamos la lista
      $("#ulDeposito").html(fila);
      //hacemos visible la lista
      $("#listaDeposito").attr(
        "style",
        "display: block; position:absolute; z-index: 3000;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};
