// Habilita el formulario para cargar los filtros de venta
const habilitacionInterfaz = (codigo_interfaz) => {
  if (codigo_interfaz == 1) {
    $(".caja_recaudaciones").attr("style", "display: block;");
    $(".libro_ventas").attr("style", "display: none;");
    $(".cuentas_cobrar").attr("style", "display: none;");
  } else if (codigo_interfaz == 2) {
    $(".libro_ventas").attr("style", "display: block;");
    $(".caja_recaudaciones").attr("style", "display: none;");
    $(".cuentas_cobrar").attr("style", "display: none;");
  } else {
    $(".cuentas_cobrar").attr("style", "display: block;");
    $(".caja_recaudaciones").attr("style", "display: none;");
    $(".libro_ventas").attr("style", "display: none;");
  }
  // En todas las opciones mostramos los botones
  $("#botones").attr("style", "display: block;");
};

// Se encarga de enviarte al menu principal
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

// Limpia los campos
const limpiarCampos = () => {
  window.location.reload();
};

const presupuestoProveedor = (desde, hasta) => {
  window.location =
    "reporte/reporte_presupuesto_proveedor.php?desde=" +
    desde +
    "&hasta=" +
    hasta;
  $("#tablas").val("");
};

//Genera el reporte de Libro Venta
const libroVenta = () => {
  // Capturamos los valores
  const desde = document.getElementById("desdeLibro").value;
  const hasta = document.getElementById("hastaLibro").value;
  const cliente = document.getElementById("cli_codigo1").value;
  const tipoComprobante = document.getElementById("tipco_codigo").value;

  // Armamos la URL dinámicamente
  let url = `reporte/reporte_libro_venta.php?desde=${encodeURIComponent(
    desde
  )}&hasta=${encodeURIComponent(hasta)}`;

  // Solo agregamos los parametros opcionales si no están vacíos
  if (cliente) {
    url += `&cliente=${encodeURIComponent(cliente)}`;
  }
  if (tipoComprobante) {
    url += `&tipo=${encodeURIComponent(tipoComprobante)}`;
  }

  // Redirigimos
  window.location = url;
};

const cuentaPagar = (desde, hasta) => {
  window.location =
    "reporte/reporte_cuenta_pagar.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

// Genera reporte de venta en base a lo solicitado
const imprimir = () => {
  if ($("#codigo_informe").val() == 1) {
    presupuestoProveedor(desde, hasta);
  } else if ($("#codigo_informe").val() == 2) {
    libroVenta();
  } else if ($("#codigo_informe").val() == 3) {
    cuentaPagar(desde, hasta);
  }
};

// Controla que los inputs se completen con todos los datos necesarios
const controlVacio = () => {
  let condicion;
  let mensaje;

  // Control presupuesto proveedor
  if ($("#codigo_informe").val() == 1) {
    if ($("#suc_codigo").val() == "") {
      condicion = true;
      mensaje =
        "El parametro sucursal en el informe de caja y recaudaciones es obligatorio";
    } else if ($("#desdeCaja").val() == "") {
      condicion = true;
      mensaje =
        "Los parametros desde y hasta en el informe de caja y recaudaciones son obligatorios";
    } else if ($("#hastaCaja").val() == "") {
      condicion = true;
      mensaje =
        "Los parametros desde y hasta en el informe de caja y recaudaciones son obligatorios";
    }
  }

  // Control Libro Compra
  if ($("#codigo_informe").val() == 2) {
    if ($("#desdeLibro").val() == "") {
      condicion = true;
      mensaje =
        "Los parametros desde y hasta en el informe de libro de ventas son obligatorios";
    } else if ($("#hastaLibro").val() == "") {
      condicion = true;
      mensaje =
        "Los parametros desde y hasta en el informe de libro de ventas son obligatorios";
    }
  }

  // Control Cuenta Pagar
  if ($("#codigo_informe").val() == 3) {
    if ($("#desdeCuenta").val() == "") {
      condicion = true;
      mensaje =
        "Los parametros desde y hasta, en el informe de cuenta a pagar son obligatorios";
    } else if ($("#hastaCuenta").val() == "") {
      condicion = true;
      mensaje =
        "Los parametros desde y hasta, en el informe de cuenta a pagar son obligatorios";
    }
  }

  // En base a la condicion mostramos el mensaje o imprimimos
  if (condicion) {
    swal({
      title: "VALIDACION DE CAMPOS",
      text: mensaje.toUpperCase(),
      type: "error",
    });
  } else {
    imprimir();
  }
};

// Envia datos a su respectivo input y oculta la lista
const seleccionTablas = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTablas").html();
  $("#listaTablas").attr("style", "display: none;");
  $(".t").attr("class", "form-line t focused");

  // Mostramos el formulario segun la interfaz seleccionada
  habilitacionInterfaz($("#codigo_informe").val());
};

// Consulta las tablas de movimientos ventas
const getTablas = () => {
  $.ajax({
    //Solicitamos los datos a listaMovimientosVentas
    method: "GET",
    url: "/sys8DD/others/complements_php/listasModulos/listaMovimientosVentas.php",
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

//Envia a los input de cliente lo seleccionado en el autocompletado
const seleccionCliente = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulCliente1").html();
  $("#listaCliente1").attr("style", "display: none;");
  $(".cli1").attr("class", "form-line cli1 focused");
};

//Busca, filtra y muestra los clientes
const getCliente = () => {
  $.ajax({
    //Solicitamos los datos a listaCliente
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaCliente2.php",
    data: {
      per_numerodocumento: $("#cliente1").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionCliente(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.cliente1 +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulCliente1").html(fila);
      //hacemos visible la lista
      $("#listaCliente1").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a los input de tipo comprobante lo seleccionado en el autocompletado
const seleccionTipoComprobante = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTC").html();
  $("#listaTC").attr("style", "display: none;");
  $(".tip").attr("class", "form-line tip focused");
};

//Busca, filtra y muestra los tipos de comprobante
const getTipoComprobante = () => {
  $.ajax({
    //Solicitamos los datos a listaTipoComprobante
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaTipoComprobante3.php",
    data: {
      tipco_descripcion: $("#tipco_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionTipoComprobante(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.tipco_descripcion +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulTC").html(fila);
      //hacemos visible la lista
      $("#listaTC").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};
