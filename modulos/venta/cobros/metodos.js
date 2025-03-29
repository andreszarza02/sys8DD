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
    $("#cob_codigo").val(respuesta.cob_codigo);
  });
};

//Establece el tamaño de 2 inputs en el detalle
const setInputsDetalle = () => {
  if ($("#forco_codigo").val() == 0 || $("#forco_codigo").val() == 1) {
    $(".cliente").attr("class", "col-sm-4 cliente");
    $(".montoEfectivo").attr("class", "col-sm-3 montoEfectivo");
  } else {
    $(".cliente").attr("class", "col-sm-3 cliente");
    $(".montoEfectivo").attr("class", "col-sm-2 montoEfectivo");
  }
};

//Se encarga de establecer el codigo de la forma de cobro
const setFormaCobro = (descripcion, codigo) => {
  //Validamos el valor de los parametros
  if (descripcion == "EFECTIVO") {
    //Si es efectivo, establecemos el valor de la forma de cobro y ocultamos los inputs de tarjeta y cheque
    $("#forco_codigo").val(codigo);
    $("#forco_descripcion").val(descripcion);
    $("#forco_simbolo").attr("style", "display: none;");
    $("#cobta_transaccion").val("sin_definir");
    $("#redpa_codigo").val("0");
    $("#coche_numero").val("sin_definir");
    $("#ent_codigo2").val("0");
  }

  if (descripcion == "TARJETA") {
    //Si es tarjeta, establecemos el valor de la forma de cobro y ocultamos los inputs de efectivo y cheque
    $("#forco_codigo").val(codigo);
    $("#forco_descripcion").val(descripcion);
    $(".montoEfectivo").attr("style", "display: none;");
    $("#forco_simbolo").attr("style", "display: none;");
    $(".cliente").attr("class", "col-sm-3");
    $(".cuota").attr("class", "col-sm-3");
    $(".montoCuota").attr("class", "col-sm-3");
    $(".intervalo").attr("class", "col-sm-3");
    $("#cobroTarjeta").attr("style", "display: block;");
    $("#coche_numero").val("sin_definir");
    $("#ent_codigo2").val("0");
  }

  if (descripcion == "CHEQUE") {
    //Si es cheque, establecemos el valor de la forma de cobro y ocultamos los inputs de efectivo y tarjeta
    $("#forco_codigo").val(codigo);
    $("#forco_descripcion").val(descripcion);
    $(".montoEfectivo").attr("style", "display: none;");
    $("#forco_simbolo").attr("style", "display: none;");
    $(".cliente").attr("class", "col-sm-3");
    $(".cuota").attr("class", "col-sm-3");
    $(".montoCuota").attr("class", "col-sm-3");
    $(".intervalo").attr("class", "col-sm-3");
    $("#cobroCheque").attr("style", "display: block;");
    $("#cobta_transaccion").val("sin_definir");
    $("#redpa_codigo").val("0");
  }
};

//Consulta las formas de cobro y las establece por boton
const getFormaCobro = () => {
  $.ajax({
    //Solicitamos los datos a listaFormaCobro
    method: "GET",
    url: "/sys8DD/others/complements_php/listas/listaFormaCobro.php",
  }) //Individualizamos los datos del array y lo separamos por fromas de cobro
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        //EFECTIVO
        if (objeto.forco_descripcion == "EFECTIVO") {
          $("#forco_efectivo").attr(
            "onclick",
            "setFormaCobro('" +
              objeto.forco_descripcion +
              "', " +
              objeto.forco_codigo +
              ")"
          );
        }
        //TARJETA
        if (objeto.forco_descripcion == "TARJETA") {
          $("#forco_tarjeta").attr(
            "onclick",
            "setFormaCobro('" +
              objeto.forco_descripcion +
              "', " +
              objeto.forco_codigo +
              ")"
          );
        }
        //CHEQUE
        if (objeto.forco_descripcion == "CHEQUE") {
          $("#forco_cheque").attr(
            "onclick",
            "setFormaCobro('" +
              objeto.forco_descripcion +
              "', " +
              objeto.forco_codigo +
              ")"
          );
        }
      });
    });
};

//Valida que no se muestre el boton de efectivo en caso de que ya se encuentre registrado en la base de datos
const validarTipoEfectivo = () => {
  $.ajax({
    //Consultamos si el tipo efectivo ya se encuentra cargado en en cobro detalle
    method: "POST",
    url: "/sys8DD/modulos/venta/cobros/controladorDetalle2.php",
    data: {
      cob_codigo: $("#cob_codigo").val(),
      consulta: "2",
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      if (lista.forco_descripcion == "EFECTIVO") {
        $(".contenedorEfectivo").attr("style", "display: none;");
      }
    });
};

//Se encarga de validar el monto en el detalle
const validarMontoDetalle = () => {
  let montoSaldo = parseFloat($("#saldo").val());
  let formaCobro = $("#forco_codigo").val();
  let validacion = true;

  if (formaCobro == "1") {
    let efectivo = parseFloat($("#cobdet_monto").val());

    if (efectivo > montoSaldo) {
      swal(
        "AVISO!",
        "EL MONTO EN EFECTIVO ES MAYOR QUE EL SALDO A PAGAR",
        "error"
      );

      validacion = false;
    }
  }

  if (formaCobro == "2") {
    let tarjeta = parseFloat($("#cobta_monto").val());

    if (tarjeta > montoSaldo) {
      swal(
        "AVISO!",
        "EL MONTO EN TARJETA ES MAYOR QUE EL SALDO A PAGAR",
        "error"
      );

      validacion = false;
    }
  }

  if (formaCobro == "3") {
    let cheque = parseFloat($("#coche_monto").val());

    if (cheque > montoSaldo) {
      swal(
        "AVISO!",
        "EL MONTO EN CHEQUE ES MAYOR QUE EL SALDO A PAGAR",
        "error"
      );

      validacion = false;
    }
  }

  if (validacion) {
    confirmar2();
  }
};

//Controla que todos los inputs de detalle no se pasen con valores vacios, esta validacion se realiza en base a la forma de cobro
const controlVacio2 = () => {
  //Definimos las variables a validar
  let formaCobro = $("#forco_descripcion").val();
  let condicion = false;

  //Solo se efectua si es efectivo
  if (formaCobro == "EFECTIVO") {
    if ($("#ven_codigo").val() == "0") {
      condicion = true;
    } else if ($("#ci").val() == "") {
      condicion = true;
    } else if ($("#factura").val() == "") {
      condicion = true;
    } else if ($("#cuota").val() == "") {
      condicion = true;
    } else if ($("#saldo").val() == "") {
      condicion = true;
    } else if ($("#cliente").val() == "") {
      condicion = true;
    } else if ($("#cobdet_numerocuota").val() == "") {
      condicion = true;
    } else if ($("#vent_montocuota").val() == "") {
      condicion = true;
    } else if ($("#ven_interfecha").val() == "") {
      condicion = true;
    } else if (
      $("#cobdet_monto").val() == "0" ||
      $("#cobdet_monto").val() == ""
    ) {
      condicion = true;
    } else if ($("#forco_codigo").val() == "0") {
      condicion = true;
    }
  } else if (formaCobro == "TARJETA") {
    //Solo se efectua si es tarjeta
    if ($("#ven_codigo").val() == "0") {
      condicion = true;
    } else if ($("#ci").val() == "") {
      condicion = true;
    } else if ($("#factura").val() == "") {
      condicion = true;
    } else if ($("#cuota").val() == "") {
      condicion = true;
    } else if ($("#saldo").val() == "") {
      condicion = true;
    } else if ($("#cliente").val() == "") {
      condicion = true;
    } else if ($("#cobdet_numerocuota").val() == "") {
      condicion = true;
    } else if ($("#vent_montocuota").val() == "") {
      condicion = true;
    } else if ($("#ven_interfecha").val() == "") {
      condicion = true;
    } else if ($("#forco_codigo").val() == "0") {
      condicion = true;
    } else if ($("#cobta_numero").val() == "") {
      condicion = true;
    } else if ($("#cobta_monto").val() == "0") {
      condicion = true;
    } else if ($("#cobta_tipotarjeta").val() == "") {
      condicion = true;
    } else if ($("#ent_razonsocial").val() == "") {
      condicion = true;
    } else if ($("#marta_descripcion").val() == "") {
      condicion = true;
    }
  } else if (formaCobro == 3) {
    if ($("#ven_codigo").val() == "0") {
      condicion = true;
    } else if ($("#factura").val() == "") {
      condicion = true;
    } else if ($("#cliente").val() == "") {
      condicion = true;
    } else if ($("#cobdet_numerocuota").val() == "") {
      condicion = true;
    } else if ($("#vent_montocuota").val() == "") {
      condicion = true;
    } else if ($("#ven_interfecha").val() == "") {
      condicion = true;
    } else if ($("#forco_descripcion").val() == "") {
      condicion = true;
    } else if ($("#coche_numero").val() == "") {
      condicion = true;
    } else if ($("#coche_monto").val() == "0") {
      condicion = true;
    } else if ($("#coche_tipocheque").val() == "") {
      condicion = true;
    } else if ($("#coche_fechavencimiento").val() == "") {
      condicion = true;
    } else if ($("#ent_razonsocial2").val() == "") {
      condicion = true;
    }
  } else {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "Cargue todos los campos en blanco",
      type: "error",
    });
  } else {
    validarMontoDetalle();
  }
};

//Limpia los input del detalle
const LimpiarDetalle = () => {
  $("#detalle input").each(function () {
    $(this).val("");
  });
  $("#detalle .header .form-line").each(function () {
    $(this).attr("class", "form-line vent");
  });
  $("#detalle .body .vent").each(function () {
    $(this).attr("class", "form-line vent");
  });
  $("#detalle .body .cob").each(function () {
    $(this).attr("class", "form-line cob");
  });
  $("#detalle .body .cob2").each(function () {
    $(this).attr("class", "form-line cob2");
  });
  $("#detalle .body .form").each(function () {
    $(this).attr("class", "form-line form");
  });
  $("#cobroTarjeta input").each(function () {
    $(this).val("");
  });
  $("#cobroCheque input").each(function () {
    $(this).val("");
  });
};

//Obtienen la clave subrogada de cobro detalle
const getCodigoDetalle = () => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle2.php",
    data: {
      consulta: "1",
    },
  }).done(function (respuesta) {
    $("#cobdet_codigo").val(respuesta.codigodetalle);
  });
};

//Establece el numero de cuota por venta
const getNumeroCuota = () => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle3.php",
    data: {
      ven_codigo: $("#ven_codigo").val(),
      cob_codigo: $("#cob_codigo").val(),
      consulta: "2",
    },
  }).done(function (respuesta) {
    $("#cobdet_numerocuota").val(respuesta.cobdet_numerocuota);
    $(".cob").attr("class", "form-line cob focused");
  });
};

//Actualiza el estado de cuenta a cobrar, una vez se termina de pagar en su totalidad la venta
const actualizarEstadoCuenta = () => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle3.php",
    data: {
      ven_codigo: $("#ven_codigo").val(),
      consulta: "5",
    },
  });
};

//Valida el monto total para actualizar el estado de cuenta a cobrar
const totalCuenta = (montoTotal, montoDetalle) => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle3.php",
    data: {
      ven_codigo: $("#ven_codigo").val(),
      consulta: "4",
    },
  }).done(function (respuesta) {
    let monto = parseFloat(respuesta.montoventa) + parseFloat(montoDetalle);

    if (monto == montoTotal) {
      actualizarEstadoCuenta();
    }
  });
};

//Valida la suma del detalle, para que no supere al monto de la cuota
const sumaValidacionDetalle = (montoDetalle, montoCuota) => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle3.php",
    data: {
      ven_codigo: $("#ven_codigo").val(),
      cob_codigo: $("#cob_codigo").val(),
      consulta: "3",
    },
  }).done(function (respuesta) {
    let sumDetalle = 0;
    sumDetalle = parseFloat(respuesta.totalventa) + parseFloat(montoDetalle);

    if (sumDetalle <= parseFloat(montoCuota)) {
      totalCuenta($("#cuenco_montototal").val(), montoDetalle);
      grabarDetalle();
    } else {
      swal(
        "ERROR",
        "EL MONTO DEL DETALLE EXCEDE EL MONTO DE LA CUOTA",
        "error"
      );
    }
  });
};

//Permite aplicar un formato de tabla a la lista de cobro cabecera
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

//Consulta y lista los datos en cobro cabecera
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
        tabla += objeto.cob_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.cob_fecha;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.caj_descripcion;
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
        tabla += objeto.cob_estado;
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

//Consulta y lista los datos en cobro detalle
const listarDetalle = () => {
  $.ajax({
    //solicitamos los datos al controladorDetalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      codigo: $("#cob_codigo").val(),
    },
  }).done(function (respuesta) {
    //individualizamos el array de objetos y lo separamos por filas
    let tabla = "";
    for (objeto of respuesta) {
      tabla +=
        "<tr onclick='seleccionarFila2(" +
        JSON.stringify(objeto).replace(/'/g, "&#39;") +
        ")'>";
      tabla += "<td>";
      tabla += objeto.factura;
      tabla += "</td>";
      tabla += "<td>";
      tabla += objeto.cliente;
      tabla += "</td>";
      tabla += "<td>";
      tabla += objeto.forco_descripcion;
      tabla += "</td>";
      tabla += "<td>";
      tabla += objeto.cobdet_numerocuota;
      tabla += "</td>";
      tabla += "<td>";
      tabla += objeto.cobdet_monto;
      tabla += "</td>";
      tabla += "</tr>";
    }
    //establecemos el body
    $("#tabla_detalle").html(tabla);
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

//Habilita botones en el detalle
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

//Obtiene la fecha y hora actual
const getTimestamp = () => {
  const date = new Date();
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  const hours = date.getHours();
  const minutes = date.getMinutes();
  const seconds = date.getSeconds();
  const fechaHora = `${day}/${month}/${year} ${hours}:${minutes}:${seconds}`;

  return fechaHora;
};

//Se encarga de generar el reporte de cobro
const imprimir = () => {
  let cobro = $("#cob_codigo").val();
  window.location =
    "/sys8DD/report/ventas/reporte/reporte_cobro.php?cob_codigo=" + cobro;
};

//Metodo que establece el alta en cabecera
const nuevo = () => {
  $("#operacion_cabecera").val(1);
  habilitarCampos(true);
  $(".activar").attr("class", "form-line activar focused");
  getCodigo();
  $("#cob_fecha").val(getTimestamp());
  $("#cob_estado").val("ACTIVO");
  $("#cabecera").attr("style", "display: none");
  $("#detalle").attr("style", "display: none");
  habilitarBotones(false);
  actualizacionCabecera();
  $(".foco").attr("class", "form-line foco focused");
  $(".foco2").attr("class", "form-line foco2 focused");
  $(".est").attr("class", "form-line est focused");
};

//Metodo que establece el alta en detalle
const nuevoDetalle = () => {
  getCodigoDetalle();
  habilitarCampos(false);
  habilitarBotones2(false);
  LimpiarDetalle();
  $("#ven_codigo").val(0);
  $("#cobdet_monto").val(0);
  $(".cob2").attr("class", "form-line cob2 focused");
  //   $("#cobta_monto").val(0);
  //   $(".cobta2").attr("class", "form-line cobta2 focused");
  //   $("#coche_monto").val(0);
  //   $(".coche2").attr("class", "form-line coche2 focused");
  $("#operacion_detalle").val(1);
  $("#tablaDet").attr("style", "display: none");
  $("#forco_codigo").val(404);
  $("#forco_simbolo").attr("style", "display: block;");
};

//Metodo que establece la baja en cabecera
const anular = () => {
  $("#operacion_cabecera").val(2);
  $("#cob_estado").val("ANULADO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

const eliminar = () => {
  $("#coche_numero").val("sin numero");
  $("#ent_codigo2").val("0");
  $("#cobta_numero").val("sin numero");
  $("#entad_codigo").val("0");
  habilitarBotones2(false);
  $("#operacion_detalle").val(2);
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload(true);
};

const grabarCobroTarjeta = () => {
  $.ajax({
    //Enviamos datos al controlador detalle
    method: "POST",
    url: "controladorDetalle2.php",
    data: {
      cobta_numero: $("#cobta_numero").val(),
      cobta_monto: $("#cobta_monto").val(),
      cobta_tipotarjeta: $("#cobta_tipotarjeta").val(),
      entad_codigo: $("#entad_codigo").val(),
      ent_codigo: $("#ent_codigo").val(),
      marta_codigo: $("#marta_codigo").val(),
      cob_codigo: $("#cob_codigo").val(),
      ven_codigo: $("#ven_codigo").val(),
      cobdet_codigo: $("#cobdet_codigo").val(),
      operacion_detalle: $("#operacion_detalle").val(),
      forco_codigo: $("forco_codigo").val(),
      forma: 1,
    },
  });
};

const grabarCobroCheque = () => {
  $.ajax({
    //Enviamos datos al controlador detalle
    method: "POST",
    url: "controladorDetalle2.php",
    data: {
      coche_numero: $("#coche_numero").val(),
      coche_monto: $("#coche_monto").val(),
      coche_tipocheque: $("#coche_tipocheque").val(),
      coche_fechavencimiento: $("#coche_fechavencimiento").val(),
      ent_codigo2: $("#ent_codigo2").val(),
      cob_codigo: $("#cob_codigo").val(),
      ven_codigo: $("#ven_codigo").val(),
      cobdet_codigo: $("#cobdet_codigo").val(),
      operacion_detalle: $("#operacion_detalle").val(),
      forco_codigo: $("forco_codigo").val(),
      forma: 2,
    },
  });
};

//Pasa parametros en el controlador para guardarlos en cabecera
const grabar = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      cob_codigo: $("#cob_codigo").val(),
      cob_fecha: $("#cob_fecha").val(),
      apercie_codigo: $("#apercie_codigo").val(),
      caj_codigo: $("#caj_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
      cob_estado: $("#cob_estado").val(),
      tipco_codigo: $("#tipco_codigo").val(),
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

//Pasa parametros en el controlador de detalle para insertarlos o eliminarlos
const grabarDetalle = () => {
  $.ajax({
    //Enviamos datos al controlador detalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      cobdet_codigo: $("#cobdet_codigo").val(),
      cob_codigo: $("#cob_codigo").val(),
      ven_codigo: $("#ven_codigo").val(),
      cobdet_monto: $("#cobdet_monto").val(),
      cobdet_numerocuota: $("#cobdet_numerocuota").val(),
      forco_codigo: $("#forco_codigo").val(),
      coche_numero: $("#coche_numero").val(),
      ent_codigo2: $("#ent_codigo2").val(),
      usu_codigo: $("#usu_codigo").val(),
      cobta_transaccion: $("#cobta_transaccion").val(),
      redpa_codigo: $("#redpa_codigo").val(),
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
          //Si la respuesta devuelve info, validamos la descripcion de la forma de cobro
          if (respuesta.tipo == "info") {
            if ($("#operacion_detalle").val() == "1") {
              //Si se inserto detalle y la forma de cobro es tarjeta llamamos al respectivo metodo
              if ($("#forco_descripcion").val() == "TARJETA") {
                grabarCobroTarjeta();
              }
              //Si se inserto detalle y la forma de cobro es chque llamamos al respectivo metodo
              if ($("#forco_descripcion").val() == "CHEQUE") {
                grabarCobroCheque();
              }
            }
            //Al terminar ambos la insercion, limpiamos los inputs de detalle
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
  let oper = $("#operacion_detalle").val();

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
      //validamos el monto a cobrar
      if (isConfirm) {
        if ($("#operacion_detalle").val() == 1) {
          if ($("#forco_codigo").val() == 1) {
            sumaValidacionDetalle(
              $("#cobdet_monto").val(),
              $("#vent_montocuota").val()
            );
          } else if ($("#forco_codigo").val() == 2) {
            sumaValidacionDetalle(
              $("#cobta_monto").val(),
              $("#vent_montocuota").val()
            );
          } else if ($("#forco_codigo").val() == 3) {
            sumaValidacionDetalle(
              $("#coche_monto").val(),
              $("#vent_montocuota").val()
            );
          }
        } else {
          grabarDetalle();
        }
      } else {
        //Si cancelamos realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

//Controla que todos los inputs de cabecera no se pasen con valores vacios
const controlVacio = () => {
  let condicion;

  if ($("#cob_codigo").val() == "0") {
    condicion = true;
  } else if ($("#tipco_codigo").val() == "0") {
    condicion = true;
  } else if ($("#cob_fecha").val() == "0") {
    condicion = true;
  } else if ($("#apercie_codigo").val() == "0") {
    condicion = true;
  } else if ($("#caj_codigo").val() == "0") {
    condicion = true;
  } else if ($("#caj_descripcion").val() == "") {
    condicion = true;
  } else if ($("#emp_codigo").val() == "0") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_codigo").val() == "0") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#usu_codigo").val() == "") {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
    condicion = true;
  } else if ($("#cob_estado").val() == "") {
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

//Envia a los inputs de cabecera los seleccionado en la tabla de cabecera
const seleccionarFila = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });
  $(".activar").attr("class", "form-line activar focused");
  $(".foco").attr("class", "form-line foco focused");
  $(".foco2").attr("class", "form-line foco2 focused");
  $(".est").attr("class", "form-line est focused");
  $("#detalle").attr("style", "display: block;");
  listarDetalle();
  getFormaCobro();
  validarTipoEfectivo();
};

const seleccionarFila2 = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".vent").attr("class", "form-line vent focused");
  $(".cob").attr("class", "form-line cob focused");
  $(".cob2").attr("class", "form-line cob2 focused");
  $(".form").attr("class", "form-line form focused");
};

//Envia a los input de ventas lo seleccionado en el autocompletado
const seleccionVenta = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulVenta").html();
  $("#listaVenta").attr("style", "display: none;");
  $(".vent").attr("class", "form-line vent focused");
  getNumeroCuota();
};

//Busca, filtra y muestra las ventas
const getVenta = () => {
  $.ajax({
    //Solicitamos los datos a listaVenta
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaVenta.php",
    data: {
      ci: $("#ci").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionVenta(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.venta +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulVenta").html(fila);

      //hacemos visible la lista
      $("#listaVenta").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionTipoTarjeta = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTipoTar").html();
  $("#listaTipoTar").attr("style", "display: none;");
  $(".tipTar").attr("class", "form-line tipTar focused");
};

const getTipoTarjeta = () => {
  $.ajax({
    //Solicitamos los datos a listaTipoTarjeta
    method: "GET",
    url: "/sys8DD/others/complements_php/listas/listaTipoTarjeta.php",
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionTipoTarjeta(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.cobta_tipotarjeta +
          "</li>";
      });

      //cargamos la lista
      $("#ulTipoTar").html(fila);
      //hacemos visible la lista
      $("#listaTipoTar").attr(
        "style",
        "display: block; position:absolute; z-index: 3000;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionTipoCheque = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTipoChe").html();
  $("#listaTipoChe").attr("style", "display: none;");
  $(".tipChe").attr("class", "form-line tipChe focused");
};

const getTipoCheque = () => {
  $.ajax({
    //Solicitamos los datos a listaTipoCheque
    method: "GET",
    url: "/sys8DD/others/complements_php/listas/listaTipoCheque.php",
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionTipoCheque(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.coche_tipocheque +
          "</li>";
      });

      //cargamos la lista
      $("#ulTipoChe").html(fila);
      //hacemos visible la lista
      $("#listaTipoChe").attr(
        "style",
        "display: block; position:absolute; z-index: 3000;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionEntidad = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulEntidadCheque").html();
  $("#listaEntidadCheque").attr("style", "display: none;");
  $(".ent").attr("class", "form-line ent focused");
};

const getEntidad = () => {
  $.ajax({
    //Solicitamos los datos a listaEntidad
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaEntidad.php",
    data: {
      ent_razonsocial2: $("#ent_razonsocial2").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionEntidad(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.ent_razonsocial2 +
          "</li>";
      });

      //cargamos la lista
      $("#ulEntidadCheque").html(fila);
      //hacemos visible la lista
      $("#listaEntidadCheque").attr(
        "style",
        "display: block; position:absolute; z-index: 3000;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionEntidadAdherida = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulEntidadTarjeta").html();
  $("#listaEntidadTarjeta").attr("style", "display: none;");
  $(".ent").attr("class", "form-line ent focused");
};

const getEntidadAdherida = () => {
  $.ajax({
    //Solicitamos los datos a listaEntidadAdherida
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaEntidadAdherida.php",
    data: {
      ent_razonsocial: $("#ent_razonsocial").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionEntidadAdherida(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.entidades +
          "</li>";
      });

      //cargamos la lista
      $("#ulEntidadTarjeta").html(fila);
      //hacemos visible la lista
      $("#listaEntidadTarjeta").attr(
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

//Siempre que se cargue la pagina se ejecutaran estas funciones
listar();
//Ejecutamos la validaacion de los inputs, cada 1 segundo
setInterval(setInputsDetalle, 10);
