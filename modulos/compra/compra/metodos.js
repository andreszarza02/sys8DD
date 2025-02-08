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

const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta: 1,
    },
  }).done(function (respuesta) {
    $("#comp_codigo").val(respuesta.comp_codigo);
  });
};

const setLibroCompra = () => {
  $.ajax({
    //actualizamos el libro
    method: "POST",
    url: "controladorDetalle2.php",
    data: {
      comp_codigo: $("#comp_codigo").val(),
      tipim_codigo: $("#tipim_codigo").val(),
      compdet_cantidad: $("#compdet_cantidad").val(),
      compdet_precio: $("#compdet_precio").val(),
      tipco_codigo: $("#tipco_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      tipco_descripcion: $("#tipco_descripcion").val(),
      com_numfactura: $("#com_numfactura").val(),
      operacion_detalle: $("#operacion_detalle").val(),
      usu_codigo: $("#usu_codigo").val(),
      usu_login: $("#usu_login").val(),
      consulta: "1",
    },
  });
};

const setCuentaPagar = () => {
  $.ajax({
    //actualizamos la cuenta
    method: "POST",
    url: "controladorDetalle2.php",
    data: {
      comp_codigo: $("#comp_codigo").val(),
      compdet_cantidad: $("#compdet_cantidad").val(),
      compdet_precio: $("#compdet_precio").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      operacion_detalle: $("#operacion_detalle").val(),
      usu_codigo: $("#usu_codigo").val(),
      usu_login: $("#usu_login").val(),
      consulta: "2",
    },
  });
};

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
        tabla += objeto.comp_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.comp_fecha;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.com_numfactura;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.comp_timbrado;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.comp_tipofactura;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.comp_cuota;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.comp_montocuota;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.comp_interfecha;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pro_razonsocial;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipro_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.usu_login;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.suc_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.emp_razonsocial;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.comp_estado;
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

const listarDetalle = () => {
  $.ajax({
    //solicitamos los datos al controladorDetalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      compra: $("#comp_codigo").val(),
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
          totalG10 += parseFloat(objeto.compdet_precio);
        } else {
          totalG10 += parseFloat(objeto.grav10);
        }
        tabla +=
          "<tr onclick='seleccionarFila2(" +
          JSON.stringify(objeto).replace(/'/g, "&#39;") +
          ")'>";
        tabla += "<td>";
        tabla += objeto.it_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipit_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(objeto.compdet_cantidad);
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.unime_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.dep_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(objeto.compdet_precio);
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(objeto.exenta);
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(objeto.grav5);
        tabla += "</td>";
        if (objeto.tipit_codigo == "3") {
          tabla += "<td>";
          tabla += new Intl.NumberFormat("us-US").format(objeto.compdet_precio);
          tabla += "</td>";
        } else {
          tabla += "<td>";
          tabla += new Intl.NumberFormat("us-US").format(objeto.grav10);
          tabla += "</td>";
        }
        tabla += "</tr>";
      }
      //Calculamos el iva y los totales
      iva5 = parseInt(totalG5 / 21);
      iva10 = parseInt(totalG10 / 11);
      totalIva = iva5 + iva10;
      totalGral = totalExe + totalG5 + totalG10;

      let lineafoot = "<tr>";
      lineafoot += "<th colspan='6'>";
      lineafoot += "SUBTOTALES";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalExe.toFixed(2));
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalG5.toFixed(2));
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalG10.toFixed(2));
      lineafoot += "</th>";
      lineafoot += "</tr>";

      lineafoot += "<tr>";
      lineafoot += "<th colspan='7'>";
      lineafoot += "LIQUIDACION DE IVA";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(iva5.toFixed(2));
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(iva10.toFixed(2));
      lineafoot += "</th>";
      lineafoot += "</tr>";

      lineafoot += "<tr class='bg-green'>";
      lineafoot += "<th colspan='8'>";
      lineafoot += "TOTAL IVA";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalIva.toFixed(2));
      lineafoot += "</th>";
      lineafoot += "</tr>";

      lineafoot += "<tr class='bg-blue'>";
      lineafoot += "<th colspan='8'>";
      lineafoot += "TOTAL GENERAL";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalGral.toFixed(2));
      lineafoot += "</th>";
      lineafoot += "</tr>";
      //establecemos el body y el foot
      $("#pie_detalle").html(lineafoot);
      $("#tabla_detalle").html(tabla);
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

const habilitarBotones2 = (booleano) => {
  if (booleano) {
    $(".botonesExtra3").attr("style", "display: block;");
    $(".botonesExtra4").attr("style", "display: none;");
  } else {
    $(".botonesExtra4").attr("style", "display: block;");
    $(".botonesExtra3").attr("style", "display: none;");
  }
};

const habilitarCampos = (booleano) => {
  if (booleano) {
    $(".no-disabled").removeAttr("disabled");
  } else {
    $(".no-disabled2").removeAttr("disabled");
  }
};

const getDate = () => {
  const date = new Date();
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  const fecha = `${day}/${month}/${year}`;

  return fecha;
};

const nuevo = () => {
  $("#operacion_cabecera").val(1);
  $("#procedimiento").val("ALTA");
  habilitarCampos(true);
  $(".activar").attr("class", "form-line activar focused");
  getCodigo();
  $(".est").attr("class", "form-line est focused");
  $(".fecha").attr("class", "form-line fecha focused");
  $(".foco3").attr("class", "form-line foco3");
  $("#comp_estado").val("ACTIVO");
  $("#comp_fecha").val(getDate());
  $("#orcom_codigo").val("");
  $("#pro_codigo").val(0);
  $("#tipro_codigo").val(0);
  $("#pro_razonsocial").val("");
  $("#com_numfactura").val("");
  $("#comp_tipofactura").val("");
  $("#comp_cuota").val("");
  $("#comp_interfecha").val("");
  $(".orc").attr("class", "form-line orc");
  $("#cabecera").attr("style", "display: none");
  $("#detalle").attr("style", "display: none");
  habilitarBotones(false);
};

const nuevoDetalle = () => {
  $("#operacion_detalle").val(1);
  $("#dep_codigo").val(0);
  $("#dep_descripcion").val("");
  $("#it_codigo").val(0);
  $("#tipit_codigo").val(0);
  $("#it_descripcion").val("");
  $("#compdet_cantidad").val("");
  $("#unime_codigo").val(0);
  $("#unime_descripcion").val("");
  $("#compdet_precio").val("");
  $(".dep").attr("class", "form-line dep");
  $(".it").attr("class", "form-line it");
  $(".foco2").attr("class", "form-line foco2");
  habilitarCampos(false);
  habilitarBotones2(false);
};

const anular = () => {
  $("#operacion_cabecera").val(2);
  $("#procedimiento").val("BAJA");
  $("#comp_estado").val("ANULADO");
  $(".est").attr("class", "form-line est focused");
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
      comp_codigo: $("#comp_codigo").val(),
      comp_fecha: $("#comp_fecha").val(),
      com_numfactura: $("#com_numfactura").val(),
      comp_timbrado: $("#comp_timbrado").val(),
      comp_tipofactura: $("#comp_tipofactura").val(),
      comp_cuota: $("#comp_cuota").val(),
      comp_montocuota: $("#comp_montocuota").val(),
      comp_interfecha: $("#comp_interfecha").val(),
      comp_estado: $("#comp_estado").val(),
      pro_codigo: $("#pro_codigo").val(),
      tipro_codigo: $("#tipro_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
      orcom_codigo: $("#orcom_codigo").val(),
      tipco_codigo: $("#tipco_codigo").val(),
      operacion_cabecera: $("#operacion_cabecera").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
      tipco_descripcion: $("#tipco_descripcion").val(),
      pro_razonsocial: $("#pro_razonsocial").val(),
      tipro_descripcion: $("#tipro_descripcion").val(),
      emp_razonsocial: $("#emp_razonsocial").val(),
      suc_descripcion: $("#suc_descripcion").val(),
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

const grabarDetalle = () => {
  $.ajax({
    //Enviamos datos al controlador detalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      comp_codigo: $("#comp_codigo").val(),
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      dep_codigo: $("#dep_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      compdet_cantidad: $("#compdet_cantidad").val(),
      compdet_precio: $("#compdet_precio").val(),
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
  //solicitamos el value del input operacion_detalle
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
        setLibroCompra();
        setCuentaPagar();
        grabarDetalle();
      } else {
        //Si cancelamos la operacion_cabecera realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

const controlVacio = () => {
  let condicion;

  if ($("#comp_codigo").val() == "") {
    condicion = true;
  } else if ($("#comp_fecha").val() == "") {
    condicion = true;
  } else if ($("#orcom_codigo").val() == "") {
    condicion = true;
  } else if ($("#pro_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#tipro_descripcion").val() == "") {
    condicion = true;
  } else if ($("#com_numfactura").val() == "") {
    condicion = true;
  } else if ($("#comp_timbrado").val() == "") {
    condicion = true;
  } else if ($("#orcom_montocuota").val() == "") {
    condicion = true;
  } else if ($("#comp_interfecha").val() == "") {
    condicion = true;
  } else if ($("#comp_tipofactura").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
    condicion = true;
  } else if ($("#comp_estado").val() == "") {
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

  if ($("#dep_descripcion").val() == "") {
    condicion = true;
  } else if ($("#it_descripcion").val() == "") {
    condicion = true;
  } else if ($("#compdet_cantidad").val() == "") {
    condicion = true;
  } else if ($("#unime_descripcion").val() == "") {
    condicion = true;
  } else if ($("#compdet_precio").val() == "") {
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
      $("#compdet_cantidad").val() !== "0"
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

  $(".activar").attr("class", "form-line activar focused");
  $(".foco").attr("class", "form-line foco focused");
  $(".fecha").attr("class", "form-line fecha focused");
  $(".orc").attr("class", "form-line orc focused");
  $(".tip").attr("class", "form-line tip focused");
  $(".est").attr("class", "form-line est focused");
  $(".foco3").attr("class", "form-line foco3 focused");
  $("#detalle").attr("style", "display: block;");
  actualizacionCabecera();
  listarDetalle();
};

const seleccionarFila2 = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".dep").attr("class", "form-line dep focused");
  $(".it").attr("class", "form-line it focused");
  $(".foco2").attr("class", "form-line foco2 focused");
};

const seleccionItem = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulItem").html();
  $("#listaItem").attr("style", "display: none;");
  $(".it").attr("class", "form-line it focused");
  $(".foco2").attr("class", "form-line foco2 focused");
  controlServicio();
};

const getItem = () => {
  $.ajax({
    //Solicitamos los datos a listaItemsCompra
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaItemsCompra.php",
    data: {
      orcom_codigo: $("#orcom_codigo").val(),
      it_descripcion: $("#it_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
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
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionOrdenCompra = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulOrden").html();
  $("#listaOrden").attr("style", "display: none;");
  $(".orc").attr("class", "form-line orc focused");
};

const getOrdenCompra = () => {
  $.ajax({
    //Solicitamos los datos a listaOrdenCompra
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaOrdenCompra.php",
    data: {
      pro_razonsocial: $("#pro_razonsocial").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionOrdenCompra(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.orden +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulOrden").html(fila);
      //hacemos visible la lista
      $("#listaOrden").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
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
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      dep_descripcion: $("#dep_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionDeposito(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.dep_descripcion +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulDeposito").html(fila);
      //hacemos visible la lista
      $("#listaDeposito").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const salir = () => {
  window.location = "/sys8DD/menu.php";
};

const controlServicio = () => {
  let tipoItem = $("#tipit_codigo").val();
  if (tipoItem == "3") {
    $("#compdet_cantidad").val("0");
    $(".foco2").attr("class", "form-line foco2 focused");
  }
};

listar();
