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
      consulta1: 1,
    },
  }).done(function (respuesta) {
    $("#notven_codigo").val(respuesta.notven_codigo);
  });
};

//Consulta y establece los timbrados
const getTimbrados = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      tipco_codigo: $("#tipco_codigo").val(),
      consulta3: 1,
    },
  }).done(function (respuesta) {
    if (respuesta.error) {
      swal({
        title: "RESPUESTA!!",
        text: respuesta.mensaje.toUpperCase(),
        type: "error",
      });
      $("#notven_numeronota").val("");
      $("#notven_timbrado").val("");
      $("#notven_timbrado_venc").val("");
    } else {
      $("#notven_numeronota").val(respuesta.notven_numeronota);
      $("#notven_timbrado").val(respuesta.notven_timbrado);
      $("#notven_timbrado_venc").val(respuesta.notven_timbrado_venc);
      $(".foco").attr("class", "form-line foco focused");
      // Si la nota es de remisión, mostramos el respectivo card
      if ($("#tipco_codigo").val() == 3) {
        $("#nota_remision").attr("style", "display: block;");
      } else {
        $("#nota_remision").attr("style", "display: none;");
      }
    }
  });
};

//Muestra el input de deposito
const mostrarInputDeposito = () => {
  let tipoComprobante = $("#tipco_codigo").val();

  if (tipoComprobante == 2) {
    $("#deposito").prop("style", false);
  } else {
    $("#deposito").attr("style", "display: none;");
  }
};

// Se encarga de preparar la interfaz de nota venta, para actualizar cuota y montocuota de venta_cab
const actualizarMontoCuota = () => {
  if ($("#ven_tipofactura").val() == "CONTADO") {
    $("#ven_cuota").val("1");
    $(".foco5").attr("class", "form-line foco5 focused");
  } else {
    $("#ven_cuota").val("");
    $(".foco5").attr("class", "form-line foco5");
    $("#ven_cuota").prop("disabled", false);
    // Agregar validacion solo-numeros
    //validacionInputsVacios1();
  }
  $("#operacion_cabecera").val(3);
  actualizacionCabecera();
  habilitarBotones(false);
  $("#cantidadCuota").attr("class", "col-sm-1");
  $("#cantidadCuota").attr("style", "display: block;");
  $("#empresaTimbrado").attr("class", "col-sm-2");
};

// Se encarga de verificar que la nota tenga detalle, para poder modificar los datos de venta_cab
const verificarNotaDetalle = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      notven_codigo: $("#notven_codigo").val(),
      consulta2: 1,
    },
  }).done(function (respuesta) {
    if (respuesta.calculo_cuota == "si") {
      actualizarMontoCuota();
    } else {
      swal({
        title: "RESPUESTA!!",
        text: respuesta.mensaje,
        type: "info",
      });
    }
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
        tabla += objeto.notven_numeronota;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.notven_fecha;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipco_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.notven_concepto;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.cliente;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.ven_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.ven_numfactura;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.notven_timbrado;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.notven_timbrado_venc;
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
        tabla += "<td>";
        tabla += objeto.it_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tall_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipit_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.notvendet_cantidad;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.unime_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.dep_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(objeto.notvendet_precio);
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(objeto.exenta);
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(objeto.grav5);
        tabla += "</td>";
        if (objeto.tipit_codigo == "3") {
          tabla += "<td>";
          tabla += new Intl.NumberFormat("us-US").format(
            objeto.notvendet_precio
          );
          tabla += "</td>";
        } else {
          tabla += "<td>";
          tabla += new Intl.NumberFormat("us-US").format(objeto.grav10);
          tabla += "</td>";
        }
        tabla += "</tr>";
      }
      //Calculamos el iva y los totales
      iva5 = parseFloat(totalG5 / 21);
      iva10 = parseFloat(totalG10 / 11);
      totalIva = iva5 + iva10;
      totalGral = totalExe + totalG5 + totalG10;

      //Mostramos los subtotales y totales
      let lineafoot = "<tr>";
      lineafoot += "<th colspan='7'>";
      lineafoot += "SUBTOTALES";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalExe.toFixed(0));
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalG5.toFixed(0));
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalG10.toFixed(0));
      lineafoot += "</th>";
      lineafoot += "</tr>";

      lineafoot += "<tr>";
      lineafoot += "<th colspan='8'>";
      lineafoot += "LIQUIDACION DE IVA";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(iva5.toFixed(0));
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(iva10.toFixed(0));
      lineafoot += "</th>";
      lineafoot += "</tr>";

      lineafoot += "<tr class='bg-green'>";
      lineafoot += "<th colspan='9'>";
      lineafoot += "TOTAL IVA";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalIva.toFixed(0));
      lineafoot += "</th>";
      lineafoot += "</tr>";

      lineafoot += "<tr class='bg-blue'>";
      lineafoot += "<th colspan='9'>";
      lineafoot += "TOTAL GENERAL";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalGral.toFixed(0));
      lineafoot += "</th>";
      lineafoot += "</tr>";

      //establecemos el body y el foot
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

//Permite imprimir la nota
const imprimir = () => {
  let nota = $("#notven_codigo").val();
  window.location =
    "/sys8DD/report/ventas/reporte/reporte_notas.php?notven_codigo=" + nota;
};

// Envia la nota por correo al cliente
const enviarNota = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "/sys8DD/others/complements_php/correo/correo_envio_nota_compra.php",
    data: {
      notven_codigo: $("#notven_codigo").val(),
    },
  }) //Establecemos un mensaje segun el contenido de la respuesta
    .done(function (respuesta) {
      swal({
        title: "RESPUESTA!",
        text: respuesta.mensaje,
        type: respuesta.tipo,
      });
    });
};

// Limpia campos de detalle
const limpiarCamposDetalle = () => {
  $("#dep_descripcion").val("");
  $("#it_descripcion").val("");
  $("#tall_descripcion").val("");
  $("#notvendet_cantidad").val("");
  $("#unime_descripcion").val("");
  $("#notvendet_precio").val("");
  $(".dep").attr("class", "form-line dep");
  $(".it").attr("class", "form-line it");
  $(".foco3").attr("class", "form-line foco3");
};

//Metodo que establece el alta en cabecera
const nuevo = () => {
  $("#operacion_cabecera").val(1);
  habilitarCampos(true);
  getCodigo();
  // Inputs cabecera
  $("#notven_numeronota").val("");
  $("#notven_fecha").val(getTimestamp());
  $("#tipco_descripcion").val("");
  $("#notven_concepto").val("");
  $("#per_numerodocumento").val("");
  $("#cli_codigo").val(0);
  $("#cliente").val("");
  $("#ven_codigo").val("");
  $("#ven_numfactura").val("");
  $("#notven_timbrado").val("");
  $("#notven_timbrado_venc").val("");
  $("#notven_estado").val("ACTIVO");
  $(".foco").attr("class", "form-line foco");
  $(".foco2").attr("class", "form-line foco2 focused");
  $(".tip").attr("class", "form-line tip");
  $(".foco4").attr("class", "form-line foco4");
  $(".vent").attr("class", "form-line vent");
  $(".est").attr("class", "form-line est focused");
  // Inputs remision
  $("#notven_funcionario").val(0);
  $("#per_numerodocumento2").val("");
  $("#funcionario").val("");
  $("#chave_codigo").val(0);
  $("#chave_chapa").val("");
  $("#marve_codigo").val(0);
  $("#marve_descripcion").val("");
  $("#modve_codigo").val(0);
  $("#modve_descripcion").val("");
  $(".func").attr("class", "form-line func");
  $(".ch").attr("class", "form-line ch");
  actualizacionCabecera();
  habilitarBotones(false);
  $("#cabecera").attr("style", "display: none");
  $("#detalle").attr("style", "display: none");
};

//Metodo que establece el alta en detalle
const nuevoDetalle = () => {
  $("#operacion_detalle").val(1);
  limpiarCamposDetalle();
  habilitarCampos(false);
  habilitarBotones2(false);
};

//Metodo que establece la baja en cabecera
const anular = () => {
  $("#operacion_cabecera").val(2);
  $("#notven_estado").val("ANULADO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

//Metodo que establece la baja en detalle
const eliminar = () => {
  $("#operacion_detalle").val(2);
  habilitarBotones2(false);
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload(true);
};

//Pasa parametros en el controlador para guardarlos en cabecera
const grabar = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      notven_codigo: $("#notven_codigo").val(),
      notven_fecha: $("#notven_fecha").val(),
      notven_timbrado: $("#notven_timbrado").val(),
      notven_timbrado_venc: $("#notven_timbrado_venc").val(),
      notven_numeronota: $("#notven_numeronota").val(),
      notven_concepto: $("#notven_concepto").val(),
      notven_funcionario: $("#notven_funcionario").val() || 0,
      notven_chapa: $("#notven_chapa").val() || 0,
      notven_estado: $("#notven_estado").val(),
      tipco_codigo: $("#tipco_codigo").val(),
      ven_codigo: $("#ven_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
      cli_codigo: $("#cli_codigo").val(),
      ven_cuota: $("#ven_cuota").val() || 0,
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

//Pasa parametros en el controlador de detalle para registrarlo en detalle
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
      dep_codigo: $("#dep_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      tipco_codigo: $("#tipco_codigo").val(),
      ven_codigo: $("#ven_codigo").val(),
      notven_numeronota: $("#notven_numeronota").val(),
      tipim_codigo: $("#tipim_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
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
            habilitarBotones2(true);
            listarDetalle();
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

//Establece los mensajes para agregar y anular cabecera
const confirmar = () => {
  //solicitamos el value del input operacion_cabecera
  var oper = $("#operacion_cabecera").val();

  preg = "¿Desea agregar el registro?";

  if (oper == 2) {
    preg = "¿Desea anular el registro?";
  }

  swal(
    {
      title: "ATENCIÓN!!!",
      text: preg.toUpperCase(),
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

//Establece los mensajes para agregar y eliminar detalle
const confirmar2 = () => {
  //solicitamos el value del input operacion_cabecera
  var oper = $("#operacion_detalle").val();

  preg = "¿Desea agregar el registro?";

  if (oper == 2) {
    preg = "¿Desea eliminar el registro?";
  }

  swal(
    {
      title: "ATENCIÓN!!!",
      text: preg.toUpperCase(),
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
        grabarDetalle();
      } else {
        //Si cancelamos la operacion_cabecera realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

//Controla que todos los inputs de cabecera no se pasen con valores vacios
const controlVacio = () => {
  let condicion = false;
  let condicion2 = false;

  if ($("#notven_codigo").val() == "0") {
    condicion = true;
  } else if ($("#notven_numeronota").val() == "") {
    condicion = true;
  } else if ($("#notven_fecha").val() == "") {
    condicion = true;
  } else if ($("#tipco_codigo").val() == 0) {
    condicion = true;
  } else if ($("#tipco_descripcion").val() == "") {
    condicion = true;
  } else if ($("#notven_concepto").val() == "") {
    condicion = true;
  } else if ($("#per_numerodocumento").val() == "") {
    condicion = true;
  } else if ($("#cliente").val() == "") {
    condicion = true;
  } else if ($("#ven_codigo").val() == 0) {
    condicion = true;
  } else if ($("#ven_numfactura").val() == "") {
    condicion = true;
  } else if ($("#notven_timbrado").val() == "") {
    condicion = true;
  } else if ($("#notven_timbrado_venc").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
    condicion = true;
  } else if ($("#notven_estado").val() == "") {
    condicion = true;
  } else if (
    $("#notven_funcionario").val() == 0 &&
    $("#tipco_codigo").val() == 3
  ) {
    condicion2 = true;
  } else if ($("#funcionario").val() == "" && $("#tipco_codigo").val() == 3) {
    condicion2 = true;
  } else if ($("#notven_chapa").val() == 0 && $("#tipco_codigo").val() == 3) {
    condicion2 = true;
  } else if ($("#marve_codigo").val() == 0 && $("#tipco_codigo").val() == 3) {
    condicion2 = true;
  } else if ($("#modve_codigo").val() == 0 && $("#tipco_codigo").val() == 3) {
    condicion2 = true;
  }

  // Dependiendo del tipo de nota, enviamos una
  if (condicion || condicion2) {
    if (condicion2) {
      swal({
        title: "RESPUESTA!!",
        text: "COMPLETE TODOS LOS CAMPOS DE CABECERA QUE ESTÉN EN BLANCO, NO SE OLVIDE LOS DATOS DEL FUNCIONARIO Y VEHICULO DE LA EMPRESA, REFERENTE A LA NOTA DE REMISION",
        type: "error",
      });
    } else {
      swal({
        title: "RESPUESTA!!",
        text: "COMPLETE TODOS LOS CAMPOS DE CABECERA QUE ESTÉN EN BLANCO",
        type: "error",
      });
    }
  } else {
    confirmar();
  }
};

//Controla que todos los inputs de detalle no se pasen con valores vacios
const controlVacio2 = () => {
  let condicion;

  if ($("#dep_codigo").val() == 0) {
    condicion = true;
  } else if ($("#it_codigo").val() == 0) {
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
      text: "COMPLETE TODOS LOS CAMPOS DE DETALLE QUE ESTÉN EN BLANCO",
      type: "error",
    });
  } else {
    if (
      $("#tipit_codigo").val() == "3" &&
      $("#notvendet_cantidad").val() !== "0"
    ) {
      swal({
        title: "RESPUESTA!!",
        text: "LA CANTIDAD REFERENTE AL 3 DEBE DE SER CERO (0)",
        type: "error",
      });
    } else {
      confirmar2();
    }
  }
};

//Controla que el tipo de comprobante credito o debito este definido para poder modificar datos de pago
const controlVacio3 = () => {
  let condicion;

  if ($("#tipco_codigo").val() == 0 || $("#tipco_codigo").val() == 3) {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "LA OPCION SOLO SE ENCUENTRA HABILITADA PARA NOTAS DE CREDITO O DEBITO",
      type: "info",
    });
  } else {
    verificarNotaDetalle();
  }
};

//Envia a los inputs de cabecera los seleccionado en la tabla de cabecera
const seleccionarFila = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".foco").attr("class", "form-line foco focused");
  $(".foco2").attr("class", "form-line foco2 focused");
  $(".tip").attr("class", "form-line tip focused");
  $(".foco4").attr("class", "form-line foco4 focused");
  $(".vent").attr("class", "form-line vent focused");
  $(".est").attr("class", "form-line est focused");

  $("#detalle").attr("style", "display: block;");
  actualizacionCabecera();
  mostrarInputDeposito();
  listarDetalle();
  limpiarCamposDetalle();

  //Si es una nota de remision mostramos los cards
  if ($("#tipco_codigo").val() == "3") {
    $("#nota_remision").attr("style", "display: block;");
    $(".func").attr("class", "form-line func focused");
    $(".ch").attr("class", "form-line ch focused");
  } else {
    $("#nota_remision").attr("style", "display: none;");
  }

  // Input deposito
  if ($("#tipco_codigo").val() == "2") {
    $("#deposito").attr("class", "col-sm-2");
    $("#deposito").attr("style", "display: block;");
    $("#item").attr("class", "col-sm-2");
  } else {
    $("#deposito").attr("class", "col-sm-2");
    $("#deposito").attr("style", "display: none;");
    $("#item").attr("class", "col-sm-4");
  }
};

//Envia a los inputs de detalle lo seleccionado en la tabla de detalle
const seleccionarFila2 = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  //   if (objetoJSON.tipit_codigo == 3) {
  //     $("#descripcion").val(objetoJSON.it_descripcion);
  //   }

  $(".dep").attr("class", "form-line dep focused");
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
  // Establecemos los datos de numero nota, timbrado y vencimiento timbrado
  getTimbrados();
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

//Envia a los input de funcionario lo seleccionado en el autocompletado
const seleccionFuncionario = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulFuncionario").html();
  $("#listaFuncionario").attr("style", "display: none;");
  $(".func").attr("class", "form-line func focused");
};

//Busca, filtra y muestra los funcionarios
const getFuncionario = () => {
  $.ajax({
    //Solicitamos los datos a listaFuncionario2
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaFuncionario2.php",
    data: {
      per_numerodocumento2: $("#per_numerodocumento2").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionFuncionario(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.funcionario +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulFuncionario").html(fila);
      //hacemos visible la lista
      $("#listaFuncionario").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width: 100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a los input de chapa vehiculo lo seleccionado en el autocompletado
const seleccionChapaVehiculo = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulChapa").html();
  $("#listaChapa").attr("style", "display: none;");
  $(".ch").attr("class", "form-line ch focused");
};

//Busca, filtra y muestra los vehiculos por chapa
const getChapaVehiculo = () => {
  $.ajax({
    //Solicitamos los datos a listaChapaVehiculo2
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaChapaVehiculo2.php",
    data: {
      chave_chapa: $("#chave_chapa").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionChapaVehiculo(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.vehiculo +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulChapa").html(fila);
      //hacemos visible la lista
      $("#listaChapa").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width: 100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a los input de venta lo seleccionado en el autocompletado
const seleccionVenta = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulVenta").html();
  $("#listaVenta").attr("style", "display: none;");
  $(".vent").attr("class", "form-line vent focused");
};

//Busca, filtra y muestra las ventas
const getVenta = () => {
  $.ajax({
    //Solicitamos los datos a listaVentaNotaVenta
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaVentaNotaVenta.php",
    data: {
      per_numerodocumento: $("#per_numerodocumento").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
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

//Envia al input de deposito lo seleccionado en el autocompletado
const seleccionDeposito = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulDeposito").html();
  $("#listaDeposito").attr("style", "display: none;");
  $(".dep").attr("class", "form-line dep focused");
};

//Busca, filtra y muestra los depositos
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

//Envia a los input de items lo seleccionado en el autocompletado
const seleccionItem = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulItem").html();
  $("#listaItem").attr("style", "display: none;");
  $(".it").attr("class", "form-line it focused");
  $(".foco3").attr("class", "form-line foco3 focused");
  //Determina que inputs tocar y cuales no
  controlInputsDetalle($("#tipit_codigo").val(), $("#tipco_descripcion").val());
};

//Busca, filtra y muestra los items
const getItem = () => {
  $.ajax({
    //Solicitamos los datos a listaItemsNotaVenta
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaItemsNotaVenta.php",
    data: {
      it_descripcion: $("#it_descripcion").val(),
      tipco_descripcion: $("#tipco_descripcion").val(),
      ven_codigo: $("#ven_codigo").val(),
      dep_codigo: $("#dep_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
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
            objeto.it_descripcion2 +
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

//Te envia al menu
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

//Dependiendo del tipo de item y del tipo de comprobante se habilitaran o deshabilitaran algunos inputs
const controlInputsDetalle = (tipoItem, tipoComprobante) => {
  if (
    tipoItem == "2" &&
    (tipoComprobante == "DEBITO" || tipoComprobante == "CREDITO")
  ) {
    $("#notvendet_cantidad").removeAttr("disabled");
    $("#notvendet_precio").attr("disabled", "");
  } else if (tipoItem == "3" && tipoComprobante == "DEBITO") {
    $("#notvendet_cantidad").val("0");
    $("#notvendet_cantidad").attr("disabled", "");
    $(".foco3").attr("class", "form-line foco3 focused");
    $("#notvendet_precio").removeAttr("disabled");
  } else if (tipoComprobante == "REMISION") {
    $("#notvendet_cantidad").attr("disabled", "");
    $("#notvendet_precio").attr("disabled", "");
  } else if (tipoItem == "3" && tipoComprobante == "CREDITO") {
    $("#notvendet_cantidad").val("0");
    $("#notvendet_cantidad").attr("disabled", "");
    $(".foco3").attr("class", "form-line foco3 focused");
    $("#notvendet_precio").attr("disabled", "");
  }
};

//Siempre que se cargue la pagina se ejecutaran estas funciones
listar();
