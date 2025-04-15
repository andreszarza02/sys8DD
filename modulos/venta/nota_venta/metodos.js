//Actualiza datos como empresa, sucursal y usuario en cabecera
const actualizacionCabecera = () => {
  $.ajax({
    method: "GET",
    url: "/sys8DD/others/complements_php/actualizacionCabecera.php",
  }).done(function (objeto) {
    Object.keys(objeto).forEach(function (propiedad) {
      $("#" + propiedad).val(objeto[propiedad]);
    });
  });
};

//Consulta  y establece el codigo en cabecera
const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta: 1,
    },
  }).done(function (respuesta) {
    $("#notven_codigo").val(respuesta.notven_codigo);
  });
};

//Permite aplicar un formato de tabla a la lista de cabecera
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

//Consulta y lista los datos en la grilla de cabecera
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
        tabla += objeto.notven_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.notven_fecha;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.factura;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.notven_numeronota;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.notven_concepto;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipco_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.cliente;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.usu_login;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.emp_razonsocial;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.suc_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.notven_estado;
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

//Consulta y lista los datos en la grilla de detalle
const listarDetalle = () => {
  $.ajax({
    //solicitamos los datos al controladorDetalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      nota: $("#notven_codigo").val(),
    },
  })
    .done(function (respuesta) {
      //individualizamos el array de objetos y lo separamos por filas
      let tabla = "";
      let totalExe = 0;
      let totalG5 = 0;
      let totalG10 = 0;
      let iva5 = 0;
      let iva10 = 0;
      let totalIva = 0;
      let totalGral = 0;
      for (objeto of respuesta) {
        totalExe += parseFloat(objeto.exenta);
        totalG5 += parseFloat(objeto.grav5);
        if (objeto.tipit_codigo == "3") {
          totalG10 += parseFloat(objeto.notvendet_precio);
        } else {
          totalG10 += parseFloat(objeto.grav10);
        }
        tabla +=
          "<tr onclick='seleccionarFila2(" +
          JSON.stringify(objeto).replace(/'/g, "&#39;") +
          ")'>";
        if (objeto.tipit_codigo == "3") {
          tabla += "<td>";
          tabla += objeto.it_descripcion;
          tabla += "</td>";
        } else {
          tabla += "<td>";
          tabla += objeto.descripcion;
          tabla += "</td>";
        }
        tabla += "<td>";
        tabla += objeto.tipit_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tall_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.notvendet_cantidad;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.unime_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.notvendet_precio;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.exenta;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.grav5;
        tabla += "</td>";
        if (objeto.tipit_codigo == "3") {
          tabla += "<td>";
          tabla += objeto.notvendet_precio;
          tabla += "</td>";
        } else {
          tabla += "<td>";
          tabla += objeto.grav10;
          tabla += "</td>";
        }
        tabla += "</tr>";
      }
      //Calculamos el iva y los totales
      iva5 = parseInt(totalG5 / 21);
      iva10 = parseInt(totalG10 / 11);
      totalIva = iva5 + iva10;
      totalGral = totalExe + totalG5 + totalG10;

      //Mostramos los subtotales y totales
      let lineafoot = "<tr>";
      lineafoot += "<th colspan='6'>";
      lineafoot += "SUBTOTALES";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += totalExe;
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += totalG5;
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += totalG10;
      lineafoot += "</th>";
      lineafoot += "</tr>";

      lineafoot += "<tr>";
      lineafoot += "<th colspan='7'>";
      lineafoot += "LIQUIDACION DE IVA";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += iva5;
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += iva10;
      lineafoot += "</th>";
      lineafoot += "</tr>";

      lineafoot += "<tr class='bg-green'>";
      lineafoot += "<th colspan='8'>";
      lineafoot += "TOTAL IVA";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += totalIva;
      lineafoot += "</th>";
      lineafoot += "</tr>";

      lineafoot += "<tr class='bg-blue'>";
      lineafoot += "<th colspan='8'>";
      lineafoot += "TOTAL GENERAL";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += totalGral;
      lineafoot += "</th>";
      lineafoot += "</tr>";
      //establecemos el body, foot y el formato de la tabla
      $("#tabla_detalle").html(tabla);
      $("#pie_detalle").html(lineafoot);
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Habilita botones en cabecera
const habilitarBotones = (booleano) => {
  if (booleano) {
    $(".botonesExtra1").attr("style", "display: block;");
    $(".botonesExtra2").attr("style", "display: none;");
  } else {
    $(".botonesExtra2").attr("style", "display: block;");
    $(".botonesExtra1").attr("style", "display: none;");
  }
};

//Habilita botones en el detallle
const habilitarBotones2 = (booleano) => {
  if (booleano) {
    $(".botonesExtra3").attr("style", "display: block;");
    $(".botonesExtra4").attr("style", "display: none;");
  } else {
    $(".botonesExtra4").attr("style", "display: block;");
    $(".botonesExtra3").attr("style", "display: none;");
  }
};

//Saca el disabled de los inputs
const habilitarCampos = (booleano) => {
  if (booleano) {
    $(".no-disabled").removeAttr("disabled");
  } else {
    $(".no-disabled2").removeAttr("disabled");
  }
};

//Obtiene la fecha actual
const getTimestamp = () => {
  const date = new Date();
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  const fecha = `${day}/${month}/${year}`;

  return fecha;
};

//Establece los montos al cargar las notas de credito y debito
const setMontos = () => {
  $.ajax({
    //Enviamos los datos al controladorDetalle2
    method: "POST",
    url: "controladorDetalle2.php",
    data: {
      notven_concepto: $("#notven_concepto").val(),
      notvendet_cantidad: $("#notvendet_cantidad").val(),
      notvendet_precio: $("#notvendet_precio").val(),
      ven_codigo: $("#ven_codigo").val(),
      tipco_codigo: $("#tipco_codigo").val(),
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      tipim_codigo: $("#tipim_codigo").val(),
      ven_tipofactura: $("#ven_tipofactura").val(),
      vent_montocuota: $("#vent_montocuota").val(),
      operacion_detalle: $("#operacion_detalle").val(),
    },
  });
};

//Aplica la anulación en base a los tipos de notas
const setAnulacion = () => {
  $.ajax({
    //Enviamos los datos al controladorDetalle2
    method: "POST",
    url: "controladorDetalle2.php",
    data: {
      notven_concepto: "ninguna",
      notvendet_cantidad: "0",
      notvendet_precio: "0",
      ven_codigo: $("#ven_codigo").val(),
      tipco_codigo: $("#tipco_codigo").val(),
      it_codigo: "0",
      tipit_codigo: "0",
      tipim_codigo: "0",
      ven_tipofactura: $("#ven_tipofactura").val(),
      vent_montocuota: $("#vent_montocuota").val(),
      operacion_detalle: "0",
      operacion_cabecera: $("#operacion_cabecera").val(),
    },
  });
};

//Valida el monto del detalle en caso de ser una nota de credito
const validarMontoCredito = () => {
  $.ajax({
    //Enviamos los datos al controladorDetalle3
    method: "POST",
    url: "controladorDetalle3.php",
    data: {
      notvendet_cantidad: $("#notvendet_cantidad").val(),
      notvendet_precio: $("#notvendet_precio").val(),
      ven_codigo: $("#ven_codigo").val(),
      consulta: "1",
    },
  }).done(function (respuesta) {
    if (respuesta.tipo == "error") {
      swal({
        title: "RESPUESTA!!",
        text: respuesta.mensaje,
        type: respuesta.tipo,
      });
    } else {
      grabarDetalle();
    }
  });
};

//Permite imprimir la nota
const imprimir = () => {
  let nota = $("#notven_codigo").val();
  window.location =
    "/sys8DD/report/ventas/reporte/reporte_notas.php?notven_codigo=" + nota;
};

//Metodo que establece el alta en cabecera
const nuevo = () => {
  $("#operacion_cabecera").val(1);
  habilitarCampos(true);
  //getCodigo();
  $("#notven_numeronota").val("");
  $("#notven_fecha").val(getTimestamp());
  $("#tipco_descripcion").val("");
  $("#notven_concepto").val("");
  $("#per_numerodocumento").val("");
  $("#cliente").val("");
  $("#ven_codigo").val("");
  $("#ven_numfactura").val("");
  $("#notven_estado").val("ACTIVO");
  $(".foco").attr("class", "form-line foco");
  $(".foco2").attr("class", "form-line foco2 focused");
  $(".tip").attr("class", "form-line tip");
  $(".vent").attr("class", "form-line vent");
  $(".est").attr("class", "form-line est focused");
  actualizacionCabecera();
  habilitarBotones(false);
  $("#cabecera").attr("style", "display: none");
  $("#detalle").attr("style", "display: none");
};

const nuevoDetalle = () => {
  $("#operacion_detalle").val(1);
  habilitarCampos(false);
  habilitarBotones2(false);
  $("#descripcion").val("");
  $("#tall_descripcion").val("");
  $("#notvendet_cantidad").val("");
  $("#unime_descripcion").val("");
  $("#notvendet_precio").val("");
  $(".it").attr("class", "form-line it");
  $(".foco3").attr("class", "form-line foco3");
};

const anular = () => {
  $("#operacion_cabecera").val(2);
  habilitarBotones(false);
};

const eliminar = () => {
  $("#operacion_detalle").val(2);
  habilitarBotones2(false);
};

const limpiarCampos = () => {
  window.location.reload(true);
};

const grabar = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      notven_codigo: $("#notven_codigo").val(),
      notven_fecha: $("#notven_fecha").val(),
      notven_numeronota: $("#notven_numeronota").val(),
      notven_concepto: $("#notven_concepto").val(),
      notven_estado: $("#notven_estado").val(),
      tipco_codigo: $("#tipco_codigo").val(),
      ven_codigo: $("#ven_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
      cli_codigo: $("#cli_codigo").val(),
      operacion_cabecera: $("#operacion_cabecera").val(),
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
            setAnulacion();
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

const grabarDetalle = () => {
  $.ajax({
    //Enviamos datos al controlador detalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      notven_codigo: $("#notven_codigo").val(),
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      notvendet_cantidad: $("#notvendet_cantidad").val(),
      notvendet_precio: $("#notvendet_precio").val(),
      operacion_detalle: $("#operacion_detalle").val(),
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
            setMontos();
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
  //solicitamos el value del input operacion_cabecera
  var oper = $("#operacion_cabecera").val();

  preg = "¿Desea agregar el registro?";

  if (oper == 2) {
    preg = "¿Desea anular el registro?";
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
      //Si la operacion_cabecera es correcta llamamos al metodo grabar
      if (isConfirm) {
        grabar();
      } else {
        //Si cancelamos la operacion_cabecera realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

const confirmar2 = () => {
  //solicitamos el value del input operacion_cabecera
  var oper = $("#operacion_detalle").val();

  preg = "¿Desea agregar el registro?";

  if (oper == 2) {
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
      //Si la operacion_cabecera es correcta llamamos al metodo grabar
      if (isConfirm) {
        if (
          $("#tipco_codigo").val() == "1" &&
          $("#operacion_detalle").val() == "1"
        ) {
          validarMontoCredito();
        } else {
          grabarDetalle();
        }
      } else {
        //Si cancelamos la operacion_cabecera realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

const controlVacio = () => {
  let condicion;

  if ($("#notven_codigo").val() == "") {
    condicion = true;
  } else if ($("#notven_numeronota").val() == "") {
    condicion = true;
  } else if ($("#notven_fecha").val() == "") {
    condicion = true;
  } else if ($("#cli_codigo").val() == 0) {
    condicion = true;
  } else if ($("#cliente").val() == "") {
    condicion = true;
  } else if ($("#factura").val() == "") {
    condicion = true;
  } else if ($("#tipco_codigo").val() == 0) {
    condicion = true;
  } else if ($("#tipco_descripcion").val() == "") {
    condicion = true;
  } else if ($("#notven_concepto").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
    condicion = true;
  } else if ($("#cedula").val() == "") {
    condicion = true;
  } else if ($("#ven_tipofactura").val() == "") {
    condicion = true;
  } else if ($("#vent_montocuota").val() == "") {
    condicion = true;
  } else if ($("#notven_estado").val() == "") {
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

const controlVacio2 = () => {
  let condicion;

  if ($("#it_codigo").val() == 0) {
    condicion = true;
  } else if ($("#tipit_codigo").val() == 0) {
    condicion = true;
  } else if ($("#tipim_codigo").val() == 0) {
    condicion = true;
  } else if ($("#it_descripcion").val() == "") {
    condicion = true;
  } else if ($("#tall_descripcion").val() == "") {
    condicion = true;
  } else if ($("#notvendet_cantidad").val() == "") {
    condicion = true;
  } else if ($("#unime_descripcion").val() == "") {
    condicion = true;
  } else if ($("#notvendet_precio").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "Cargue todos los campos en blanco",
      type: "error",
    });
  } else {
    if (
      $("#tipit_codigo").val() == "3" &&
      $("#notvendet_cantidad").val() !== "0"
    ) {
      swal({
        title: "RESPUESTA!!",
        text: "El servicio no lleva cantidad",
        type: "error",
      });
    } else {
      confirmar2();
    }
  }
};

const seleccionarFila = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".foco").attr("class", "form-line foco focused");
  $(".foco2").attr("class", "form-line foco2 focused");
  $(".vent").attr("class", "form-line vent focused");
  $(".tip").attr("class", "form-line tip focused");
  $(".est").attr("class", "form-line est focused");
  $(".con").attr("class", "form-line con focused");

  $("#detalle").attr("style", "display: block;");
  listarDetalle();
  //Mostramos el search de factura
  showBuscador();
};

const seleccionarFila2 = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  if (objetoJSON.tipit_codigo == 3) {
    $("#descripcion").val(objetoJSON.it_descripcion);
  }

  $(".it").attr("class", "form-line it focused");
  $(".foco3").attr("class", "form-line foco3 focused");
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

  //   if ($("#tipco_codigo").val() == "1") {
  //     getConcepto();
  //   }

  //   if ($("#tipco_codigo").val() == "2") {
  //     $("#notven_concepto").val("COSTO EXTRA");
  //     $(".con").attr("class", "form-line con focused");
  //   }

  //   if ($("#tipco_codigo").val() == "3") {
  //     $("#notven_concepto").val("ENVIO");
  //     $(".con").attr("class", "form-line con focused");
  //   }
  //Mostramos el search de factura
  //   showBuscador();
};

//Busca, filtra y muestra los tipos de comprobantes
const getTipoComprobante = () => {
  $.ajax({
    //Solicitamos los datos a listaTipoComprobante
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaTipoComprobante.php",
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
        "display: block; position:absolute; z-index: 3000; width: 100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionItem = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });

  if (datos.tipit_codigo == 3) {
    $("#descripcion").val(datos.it_descripcion);
  }

  $("#ulItem").html();
  $("#listaItem").attr("style", "display: none;");
  $(".it").attr("class", "form-line it focused");
  $(".foco3").attr("class", "form-line foco3 focused");
  controlServicio();
};

const getItem = () => {
  $.ajax({
    //Solicitamos los datos a listaItemsNotaVenta
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaItemsNotaVenta.php",
    data: {
      tipco_codigo: $("#tipco_codigo").val(),
      ven_codigo: $("#ven_codigo").val(),
      descripcion: $("#descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.tipit_codigo !== "3") {
          fila +=
            "<li class='list-group-item' onclick='seleccionItem(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.descripcion +
            "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionItem(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.it_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulItem").html(fila);
      //hacemos visible la lista
      $("#listaItem").attr(
        "style",
        "display: block; position:absolute; z-index: 3000;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionVenta = (datos) => {
  if (datos.ven_codigo == 0) {
    $("#cedula").val("");
    $("#tipco_descripcion").val("");
    $("#notven_concepto").val("");
    $(".vent").attr("class", "form-line vent");
    $(".tip").attr("class", "form-line tip");
    $(".con").attr("class", "form-line con");
    $("#listaVenta").attr("style", "display: none;");
  } else {
    //Enviamos los datos a su respectivo input
    Object.keys(datos).forEach((key) => {
      $("#" + key).val(datos[key]);
    });
    $("#ulVenta").html();
    $("#listaVenta").attr("style", "display: none;");
    $(".vent").attr("class", "form-line vent focused");
  }
};

//Obtenemos la venta para el autcompletado
const getVenta = () => {
  $.ajax({
    //Solicitamos los datos a listaVentaNotaVenta
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaVentaNotaVenta.php",
    data: {
      tipco_codigo: $("#tipco_codigo").val(),
      notven_fecha: $("#notven_fecha").val(),
      cedula: $("#cedula").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionVenta(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.venta +
          "</li>";
      });

      //cargamos la lista
      $("#ulVenta").html(fila);
      //hacemos visible la lista
      $("#listaVenta").attr(
        "style",
        "display: block; position:absolute; z-index: 3000;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionConcepto = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulConcepto").html();
  $("#listaConcepto").attr("style", "display: none;");
  $(".con").attr("class", "form-line con focused");
};

const getConcepto = () => {
  $.ajax({
    //Solicitamos los datos a listaConcepto
    method: "GET",
    url: "/sys8DD/others/complements_php/listas/listaConcepto.php",
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionConcepto(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.notven_concepto +
          "</li>";
      });

      //cargamos la lista
      $("#ulConcepto").html(fila);
      //hacemos visible la lista
      $("#listaConcepto").attr(
        "style",
        "display: block; position:absolute; z-index: 3000;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Muestra el search de facturas
const showBuscador = () => {
  $("#ci").attr("style", "display: block;");
};

const salir = () => {
  window.location = "/sys8DD/menu.php";
};

const controlServicio = () => {
  let tipoItem = $("#tipit_codigo").val();
  if (tipoItem == "3") {
    $("#notvendet_cantidad").val("0");
    $(".foco3").attr("class", "form-line foco3 focused");
    $("#notvendet_precio").removeAttr("disabled");
  }
};

listar();
