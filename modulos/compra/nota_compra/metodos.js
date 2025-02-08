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

//Metodo encargado de ejecutar las funciones de detalle
async function ejecutarFunciones() {
  await setLibroCompra();
  await setCuentaPagar();
  await grabarDetalle();
}

//Perimte aplicar un formato de tabla a la lista de compra cabecera
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

//Consulta  y establece el codigo de nota compra en cabecera
const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta: 1,
    },
  }).done(function (respuesta) {
    $("#nocom_codigo").val(respuesta.nocom_codigo);
  });
};

//Muestra el input de deposito
const mostrarInputDeposito = () => {
  let tipoComprobante = $("#tipco_codigo").val();

  if (tipoComprobante == 2) {
    $("#deposito").prop("style", false);
  }
};

//Valida que no se repita el item y deposito en el detalle
const validarItem = () => {
  //Establecemos una varibale que nos guarde la operacion
  let operacionDetalle = $("#operacion_detalle").val();
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      nocom_codigo: $("#nocom_codigo").val(),
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      dep_codigo: $("#dep_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      consulta: 1,
    },
  }) //Establecemos un mensaje segun el contenido de la respuesta
    .done(function (respuesta) {
      if (respuesta.existe_item == "1" && operacionDetalle == 1) {
        swal({
          title: "RESPUESTA!",
          text: "El item con el deposito ya se encuentra registrado en el detalle",
          type: "info",
        });
      } else {
        ejecutarFunciones();
      }
    });
};

//Valida que no se devuelva una cantidad mayor de lo que se compro
const validarCantidadItemCredito = () => {
  if ($("#tipco_codigo").val() == 1) {
    //Variable cantidad de nota compra detalle
    let cantidadNota = $("#nocomdet_cantidad").val();
    $.ajax({
      //Enviamos datos al controlador
      method: "POST",
      url: "controladorDetalle.php",
      data: {
        comp_codigo: $("#comp_codigo").val(),
        it_codigo: $("#it_codigo").val(),
        tipit_codigo: $("#tipit_codigo").val(),
        dep_codigo: $("#dep_codigo").val(),
        suc_codigo: $("#suc_codigo").val(),
        emp_codigo: $("#emp_codigo").val(),
        consulta2: 1,
      },
    }) //Establecemos un mensaje segun el contenido de la respuesta
      .done(function (respuesta) {
        if (
          parseFloat(cantidadNota) > parseFloat(respuesta.cantidad_compra_det)
        ) {
          swal({
            title: "RESPUESTA!",
            text: "La cantidad del item en el detalle es mayor al registrado en compras",
            type: "info",
          });
        }
      });
  }
};

//Pasa parametros a libro compra
const setLibroCompra = () => {
  return new Promise((resolve, reject) => {
    // Lógica de libro_compras
    $.ajax({
      //actualizamos el libro
      method: "POST",
      url: "controladorDetalle2.php",
      data: {
        comp_codigo: $("#comp_codigo").val(),
        tipim_codigo: $("#tipim_codigo").val(),
        tipco_codigo: $("#tipco_codigo").val(),
        nocomdet_cantidad: $("#nocomdet_cantidad").val(),
        nocomdet_precio: $("#nocomdet_precio").val(),
        tipco_descripcion: $("#tipco_descripcion").val(),
        nocom_numeronota: $("#nocom_numeronota").val(),
        operacion_detalle: $("#operacion_detalle").val(),
        usu_codigo: $("#usu_codigo").val(),
        usu_login: $("#usu_login").val(),
        consulta: "1",
      },
    });
    setTimeout(() => {
      resolve(); // Llama a resolve cuando se complete
    }, 1000);
  });
};

//Pasa parametros a cuenta pagar
const setCuentaPagar = () => {
  return new Promise((resolve, reject) => {
    // Lógica de cuentas_pagar
    $.ajax({
      //actualizamos la cuenta
      method: "POST",
      url: "controladorDetalle2.php",
      data: {
        comp_codigo: $("#comp_codigo").val(),
        tipim_codigo: 0,
        tipco_codigo: $("#tipco_codigo").val(),
        nocomdet_cantidad: $("#nocomdet_cantidad").val(),
        nocomdet_precio: $("#nocomdet_precio").val(),
        tipco_descripcion: $("#tipco_descripcion").val(),
        nocom_numeronota: $("#nocom_numeronota").val(),
        operacion_detalle: $("#operacion_detalle").val(),
        usu_codigo: $("#usu_codigo").val(),
        usu_login: $("#usu_login").val(),
        consulta: "2",
      },
    });
    setTimeout(() => {
      resolve(); // Llama a resolve cuando se complete
    }, 1000);
  });
};

//Consulta y lista los datos en nota compra cabecera
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
        tabla += objeto.nocom_numeronota;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.nocom_fecha;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipco_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.nocom_concepto;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pro_razonsocial;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipro_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.comp_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.com_numfactura;
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
        tabla += objeto.nocom_estado;
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

//Consulta y lista los datos en nota compra detalle
const listarDetalle = () => {
  $.ajax({
    //solicitamos los datos al controladorDetalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      nota: $("#nocom_codigo").val(),
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
          totalG10 += parseFloat(objeto.nocomdet_precio);
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
        tabla += new Intl.NumberFormat("us-US").format(
          objeto.nocomdet_cantidad
        );
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.unime_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.dep_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(objeto.nocomdet_precio);
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
            objeto.nocomdet_precio
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

//Habilita botones en datelle
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
const getDate = () => {
  const date = new Date();
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  const fecha = `${day}/${month}/${year}`;

  return fecha;
};

//Metodo que establece el alta de cabecera
const nuevo = () => {
  $("#operacion_cabecera").val(1);
  $("#procedimiento").val("ALTA");
  habilitarCampos(true);
  $(".activar").attr("class", "form-line activar");
  getCodigo();
  $(".fecha").attr("class", "form-line fecha focused");
  $(".tip").attr("class", "form-line tip");
  $(".foco4").attr("class", "form-line foco4");
  $(".comp").attr("class", "form-line comp");
  $(".est").attr("class", "form-line est focused");
  $("#nocom_numeronota").val("");
  $("#nocom_fecha").val(getDate());
  $("#tipco_codigo").val(0);
  $("#tipco_descripcion").val("");
  $("#nocom_concepto").val("");
  $("#pro_codigo").val(0);
  $("#tipro_codigo").val(0);
  $("#tipro_descripcion").val("");
  $("#pro_razonsocial").val("");
  $("#comp_codigo").val("");
  $("#com_numfactura").val("");
  $("#nocom_estado").val("ACTIVO");
  actualizacionCabecera();
  habilitarBotones(false);
  $("#cabecera").attr("style", "display: none");
  $("#detalle").attr("style", "display: none");
};

//Metodo que estbalece el alta del detalle
const nuevoDetalle = () => {
  $("#operacion_detalle").val(1);
  $("#dep_codigo").val(0);
  $("#dep_descripcion").val("");
  $("#it_codigo").val(0);
  $("#tipit_codigo").val(0);
  $("#it_descripcion").val("");
  $("#nocomdet_cantidad").val("");
  $("#unime_codigo").val(0);
  $("#unime_descripcion").val("");
  $("#nocomdet_precio").val("");
  $(".dep").attr("class", "form-line dep");
  $(".it").attr("class", "form-line it");
  $(".foco2").attr("class", "form-line foco2");
  $(".foco3").attr("class", "form-line foco3");
  habilitarCampos(false);
  habilitarBotones2(false);
};

//Metodo que establece la baja en nota compra cabecera
const anular = () => {
  $("#operacion_cabecera").val(2);
  $("#procedimiento").val("BAJA");
  $("#nocom_estado").val("ANULADO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

//Metodo que establece la baja en nota compra detalle
const eliminar = () => {
  $("#operacion_detalle").val(2);
  habilitarBotones2(false);
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload(true);
};

//Pasa parametros en el controlador para guardarlos en nota compra cabececera
const grabar = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      nocom_codigo: $("#nocom_codigo").val(),
      nocom_fecha: $("#nocom_fecha").val(),
      nocom_numeronota: $("#nocom_numeronota").val(),
      nocom_concepto: $("#nocom_concepto").val(),
      nocom_estado: $("#nocom_estado").val(),
      tipco_codigo: $("#tipco_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
      comp_codigo: $("#comp_codigo").val(),
      pro_codigo: $("#pro_codigo").val(),
      tipro_codigo: $("#tipro_codigo").val(),
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

//Pasa parametros en el controlador de detalle para guardarlos en nota compra detalle
const grabarDetalle = () => {
  return new Promise((resolve, reject) => {
    // Lógica de grabarDetalle
    $.ajax({
      //Enviamos datos al controlador detalle
      method: "POST",
      url: "controladorDetalle.php",
      data: {
        nocom_codigo: $("#nocom_codigo").val(),
        it_codigo: $("#it_codigo").val(),
        tipit_codigo: $("#tipit_codigo").val(),
        nocomdet_cantidad: $("#nocomdet_cantidad").val(),
        nocomdet_precio: $("#nocomdet_precio").val(),
        dep_codigo: $("#dep_codigo").val(),
        suc_codigo: $("#suc_codigo").val(),
        emp_codigo: $("#emp_codigo").val(),
        tipco_codigo: $("#tipco_codigo").val(),
        comp_codigo: $("#comp_codigo").val(),
        usu_codigo: $("#usu_codigo").val(),
        operacion_detalle: $("#operacion_detalle").val(),
        usu_login: $("#usu_login").val(),
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
    setTimeout(() => {
      console.log("Datos grabados");
      resolve(); // Llama a resolve cuando se complete
    }, 1000);
  });
};

//Establece los mensajes pára agregar y anular cabecera
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

//Establece los mensajes pára agregar y anular detalle
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
        validarItem();
      } else {
        //Si cancelamos la operacion_cabecera realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

//Controla que todos los inputs de cabecera no se pasen con valores vacios
const controlVacio = () => {
  let condicion;

  if ($("#nocom_codigo").val() == "") {
    condicion = true;
  } else if ($("#nocom_numeronota").val() == "") {
    condicion = true;
  } else if ($("#nocom_fecha").val() == "") {
    condicion = true;
  } else if ($("#tipco_descripcion").val() == "") {
    condicion = true;
  } else if ($("#nocom_concepto").val() == "") {
    condicion = true;
  } else if ($("#pro_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#comp_codigo").val() == "") {
    condicion = true;
  } else if ($("#com_numfactura").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
    condicion = true;
  } else if ($("#nocom_estado").val() == "") {
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

//Controla que todos los inputs de detalle no se pasen con valores vacios
const controlVacio2 = () => {
  let condicion;

  if ($("#dep_descripcion").val() == "") {
    condicion = true;
  } else if ($("#it_descripcion").val() == "") {
    condicion = true;
  } else if ($("#nocomdet_cantidad").val() == "") {
    condicion = true;
  } else if ($("#unime_descripcion").val() == "") {
    condicion = true;
  } else if ($("#nocomdet_precio").val() == "") {
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
      $("#nocomdet_cantidad").val() !== "0"
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

//Envia a los inputs de cabecera los seleccionado en la tabla de cabecera
const seleccionarFila = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".activar").attr("class", "form-line activar focused");
  $(".fecha").attr("class", "form-line fecha focused");
  $(".tip").attr("class", "form-line tip focused");
  $(".foco4").attr("class", "form-line foco4 focused");
  $(".comp").attr("class", "form-line comp focused");
  $(".foco").attr("class", "form-line foco focused");
  $(".est").attr("class", "form-line est focused");
  $("#detalle").attr("style", "display: block;");
  actualizacionCabecera();
  mostrarInputDeposito();
  listarDetalle();
};

//Envia a los inputs de detalle lo seleccionado en la tabla de detalle
const seleccionarFila2 = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".dep").attr("class", "form-line dep focused");
  $(".it").attr("class", "form-line it focused");
  $(".foco2").attr("class", "form-line foco2 focused");
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
};

//Busca, filtra y muestra los tipos de comprobante
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
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia al input de concepto lo seleccionado en el autocompletado
const seleccionConcepto = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulConcepto").html();
  $("#listaConcepto").attr("style", "display: none;");
  $(".foco4").attr("class", "form-line foco4 focused");
};

//Busca y muestra los conceptos
const getConcepto = () => {
  $.ajax({
    //Solicitamos los datos a listaConceptoNotaCompra
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaConceptoNotaCompra.php",
    data: {
      nocom_concepto: $("#nocom_concepto").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionConcepto(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.nocom_concepto +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulConcepto").html(fila);
      //hacemos visible la lista
      $("#listaConcepto").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a los input de compra lo seleccionado en el autocompletado
const seleccionCompra = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulCompra").html();
  $("#listaCompra").attr("style", "display: none;");
  $(".comp").attr("class", "form-line comp focused");
};

//Busca, filtra y muestra las compras
const getCompra = () => {
  $.ajax({
    //Solicitamos los datos a listaCompra
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaCompra.php",
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
            "<li class='list-group-item' onclick='seleccionCompra(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.compra +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulCompra").html(fila);
      //hacemos visible la lista
      $("#listaCompra").attr(
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

//Envia a los input de item lo seleccionado en el autocompletado de item
const seleccionItem = (datos) => {
  let tipoComprobante = $("#tipco_codigo").val();
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });

  if (tipoComprobante == 1) {
    $("#ulItem").html();
    $("#listaItem").attr("style", "display: none;");
    $(".it").attr("class", "form-line it focused");
    $(".foco2").attr("class", "form-line foco2 focused");
    $(".foco3").attr("class", "form-line foco3 focused");
  } else if (tipoComprobante == 3) {
    $("#ulItem").html();
    $("#listaItem").attr("style", "display: none;");
    $(".it").attr("class", "form-line it focused");
    $(".foco2").attr("class", "form-line foco2 focused");
    $(".foco3").attr("class", "form-line foco3 focused");
    $("#nocomdet_cantidad").prop("disabled", true);
  } else {
    $("#ulItem").html();
    $("#listaItem").attr("style", "display: none;");
    $(".it").attr("class", "form-line it focused");

    let tipoItem = $("#tipit_codigo").val();
    if (tipoItem == 1 || tipoItem == 4) {
      $(".foco3").attr("class", "form-line foco3 focused");
    } else {
      $("#nocomdet_cantidad").prop("disabled", true);
      controlServicio();
      $("#nocomdet_precio").prop("disabled", false);
    }
  }
};

//Busca, filtra y muestra los items
const getItem = () => {
  $.ajax({
    //Solicitamos los datos a listaItemsNotaCompra
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaItemsNotaCompra.php",
    data: {
      comp_codigo: $("#comp_codigo").val(),
      dep_codigo: $("#dep_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      it_descripcion: $("#it_descripcion").val(),
      tipco_codigo: $("#tipco_codigo").val(),
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

//Te envia al menu
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

//En caso de ser el item servicio te establece la cantidad en 0
const controlServicio = () => {
  let tipoItem = $("#tipit_codigo").val();
  if (tipoItem == "3") {
    $("#nocomdet_cantidad").val("0");
    $(".foco2").attr("class", "form-line foco2 focused");
  }
};

listar();
