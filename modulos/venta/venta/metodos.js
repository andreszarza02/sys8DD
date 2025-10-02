//Controla que los inputs no se queden vacios al perder el foco y que solo contengan letras, numeros y el simbolo /
const validacionInputsVacios1 = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase letras-numeros-algunos-simbolos2 realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("letras-numeros-algunos-simbolos2")
      ) {
        //Definimos variables a utilizar
        let mensaje = "";
        const tieneSimbolo = /[¨!°¬@#$%^&*()_~+\-=\[\]{};':"\\,.<>?]/;

        // Comprobamos si el input esta vacio
        if (input.value.trim() === "") {
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");

          // Armamos el mensaje a mostrar
          const labelText = label ? label.textContent.trim() : "VACIO";
          mensaje = `El campo ${labelText} se encuentra vacío.`;
        } else {
          // Si no está vacío, comprobamos si tiene simbolos distintos a /
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene simbolos distintos a /
          if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} solo acepta letras, números y el simbolo barra(/)`;
          }
        }

        // Si mensaje no está vacío, mostramos la alerta
        if (mensaje !== "") {
          swal({
            title: "VALIDACION DE CAMPO",
            text: mensaje.toUpperCase(),
            type: "info",
          });
          // Limpiamos el valor del input
          input.value = "";
        }
      }
    },
    true
  ); // usa true para captar el evento en la fase de captura y asegurar que blur funciona bien
};

//Controla que los inputs no se queden vacios al perder el foco y que no contengan numeros o simbolos
const validacionInputsVacios2 = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase solo-letras realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("solo-letras")
      ) {
        //Definimos variables a utilizar
        let mensaje = "";
        const tieneNumero = /[0-9]/;
        const tieneSimbolo = /[¨!°¬@#$%^&*()_~+\-=\[\]{};':"\\|,.<>\/?]/;

        // Comprobamos si el input esta vacio
        if (input.value.trim() === "") {
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");

          // Armamos el mensaje a mostrar
          const labelText = label ? label.textContent.trim() : "VACIO";
          mensaje = `El campo ${labelText} se encuentra vacío.`;
        } else {
          // Si no está vacío, comprobamos si contiene números o símbolos
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene números o símbolos
          if (tieneNumero.test(input.value) && tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} contiene números y símbolos`;
          } else if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} contiene símbolos`;
          } else if (tieneNumero.test(input.value)) {
            mensaje = `El campo ${labelText} contiene números`;
          }
        }

        // Si mensaje no está vacío, mostramos la alerta
        if (mensaje !== "") {
          swal({
            title: "VALIDACION DE CAMPO",
            text: mensaje.toUpperCase(),
            type: "info",
          });
          // Limpiamos el valor del input
          input.value = "";
        }
      }
    },
    true
  ); // usa true para captar el evento en la fase de captura y asegurar que blur funciona bien
};

//Controla que los inputs no se queden vacios al perder el foco y que solo contengan numeros
const validacionInputsVacios3 = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase solo-numeros realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("solo-numeros")
      ) {
        //Definimos variables a utilizar
        let mensaje = "";
        const tieneMinuscula = /[a-z]/;
        const tieneMayuscula = /[A-Z]/;
        const tieneSimbolo = /[¨!°¬@#$%^&*()_~+\-=\[\]{};':"\\|,.<>\/?]/;

        // Comprobamos si el input esta vacio
        if (input.value.trim() === "") {
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");

          // Armamos el mensaje a mostrar
          const labelText = label ? label.textContent.trim() : "VACIO";
          mensaje = `El campo ${labelText} se encuentra vacío.`;
        } else {
          // Si no está vacío, comprobamos si contiene letras o símbolos
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene números o símbolos
          if (
            tieneMayuscula.test(input.value) ||
            tieneMinuscula.test(input.value) ||
            tieneSimbolo.test(input.value)
          ) {
            mensaje = `El campo ${labelText} solo acepta valores numéricos, Ej: 123456...`;
          }
        }

        // Si mensaje no está vacío, mostramos la alerta
        if (mensaje !== "") {
          swal({
            title: "VALIDACION DE CAMPO",
            text: mensaje.toUpperCase(),
            type: "info",
          });
          // Limpiamos el valor del input
          input.value = "";
        }
      }
    },
    true
  ); // usa true para captar el evento en la fase de captura y asegurar que blur funciona bien
};

//Controla que los inputs no se queden vacios al perder el foco y que no contengan simbolos
const validacionInputsVacios4 = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase letras-numeros realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("letras-numeros")
      ) {
        //Definimos variables a utilizar
        let mensaje = "";
        const tieneSimbolo = /[¨!°¬@#$%^&*()_~+\-=\[\]{};':"\\|,.<>\/?]/;

        // Comprobamos si el input esta vacio
        if (input.value.trim() === "") {
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");

          // Armamos el mensaje a mostrar
          const labelText = label ? label.textContent.trim() : "VACIO";
          mensaje = `El campo ${labelText} se encuentra vacío.`;
        } else {
          // Si no está vacío, comprobamos si contiene símbolos
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene simbolos
          if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} contiene símbolos`;
          }
        }

        // Si mensaje no está vacío, mostramos la alerta
        if (mensaje !== "") {
          swal({
            title: "VALIDACION DE CAMPO",
            text: mensaje.toUpperCase(),
            type: "info",
          });
          // Limpiamos el valor del input
          input.value = "";
        }
      }
    },
    true
  ); // usa true para captar el evento en la fase de captura y asegurar que blur funciona bien
};

// Valida si la venta esta asociado a una nota de venta
const consultaAsociacion = (escenario, mensaje) => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      ven_codigo: $("#ven_codigo").val(),
      consulta1: 1,
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (respuesta) {
      if (respuesta.validacion == "asociado") {
        swal(
          {
            title: "VALIDACION " + escenario.toUpperCase(),
            text: mensaje.toUpperCase(),
            type: "error",
            confirmButtonText: "OK",
          },
          function (isConfirm) {
            if (isConfirm) {
              window.location.reload(true);
            }
          }
        );
      }
    });
};

// Se encarga de definir el monto de la cuota
const calculoCuota = () => {
  // Definimos variables
  let monto = 0;
  let montoCuota = 0;
  if ($("#ven_cuota").val() > 0) {
    $.ajax({
      method: "POST",
      url: "controlador.php",
      data: {
        peven_codigo: $("#peven_codigo").val(),
        consulta3: 1,
      },
    }).done(function (respuesta) {
      // Dependiendo del tipo de factura, se define el monto de la cuota
      if ($("#ven_tipofactura").val() == "CONTADO") {
        monto = parseInt(respuesta.detallepresupuesto);
        montoCuota = monto / 1;
        $("#ven_montocuota").val(montoCuota.toFixed(0));
      } else {
        monto = parseInt(respuesta.detallepresupuesto);
        montoCuota = monto / parseInt($("#ven_cuota").val());
        $("#ven_montocuota").val(parseInt(montoCuota.toFixed(0)));
      }
      //Activamos el input de monto cuota
      $(".foco2").attr("class", "form-line foco2 focused");
    });
  }
};

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

//Consulta y establece el codigo de venta en cabecera
const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta1: 1,
    },
  }).done(function (respuesta) {
    $("#ven_codigo").val(respuesta.ven_codigo);
  });
};

//Se encarga de generar el numero de factura de venta
const getNumeroFactura = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      caj_codigo: $("#caj_codigo").val(),
      consulta2: 1,
    },
  }).done(function (respuesta) {
    if (respuesta.error) {
      swal({
        title: "RESPUESTA!!",
        text: respuesta.mensaje.toUpperCase(),
        type: "error",
      });
      $("#ven_numfactura").val("");
      $("#ven_timbrado").val("");
      $("#ven_timbrado_venc").val("");
    } else {
      $("#ven_numfactura").val(respuesta.ven_numfactura);
      $("#ven_timbrado").val(respuesta.ven_timbrado);
      $("#ven_timbrado_venc").val(respuesta.ven_timbrado_venc);
      $(".foco3").attr("class", "form-line foco3 focused");
    }
  });
};

//Permite aplicar un formato de tabla a la lista de venta cabecera
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

//Envia datos al controladorDetalle2 para actualizar un registro en libro venta
// const setLibroVenta = () => {
//   $.ajax({
//     //actualizamos el libro
//     method: "POST",
//     url: "controladorDetalle2.php",
//     data: {
//       ven_codigo: $("#ven_codigo").val(),
//       tipim_codigo: $("#tipim_codigo").val(),
//       vendet_cantidad: $("#vendet_cantidad").val(),
//       vendet_precio: $("#vendet_precio").val(),
//       tipit_codigo: $("#tipit_codigo").val(),
//       ven_numfactura: $("#ven_numfactura").val(),
//       tipco_codigo: $("#tipco_codigo").val(),
//       operacion_detalle: $("#operacion_detalle").val(),
//       consulta: 1,
//     },
//   });
// };

//Envia datos al controladorDetalle2 para actualizar un registro en cuenta cobrar
// const setCuentaCobrar = () => {
//   $.ajax({
//     //actualizamos el libro
//     method: "POST",
//     url: "controladorDetalle2.php",
//     data: {
//       ven_codigo: $("#ven_codigo").val(),
//       vendet_cantidad: $("#vendet_cantidad").val(),
//       vendet_precio: $("#vendet_precio").val(),
//       tipit_codigo: $("#tipit_codigo").val(),
//       tipco_codigo: $("#tipco_codigo").val(),
//       operacion_detalle: $("#operacion_detalle").val(),
//       consulta: 2,
//     },
//   });
// };

//Consulta y lista los datos de venta cabecera
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
        tabla += objeto.ven_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.ven_fecha;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.ven_numfactura;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.ven_timbrado;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.ven_timbrado_venc;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.ven_tipofactura;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.ven_cuota;
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(objeto.ven_montocuota);
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.ven_interfecha;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.cliente;
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
        tabla += objeto.ven_estado;
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

//Consulta y lista los datos de venta detalle
const listarDetalle = () => {
  $.ajax({
    //solicitamos los datos al controladorDetalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      venta: $("#ven_codigo").val(),
    },
  }).done(function (respuesta) {
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
        totalG10 += parseFloat(objeto.vendet_precio);
      } else {
        totalG10 += parseFloat(objeto.grav10);
      }
      tabla +=
        "<tr onclick='seleccionarFila2(" +
        JSON.stringify(objeto).replace(/'/g, "&#39;") +
        ")'>";
      tabla += "<td>";
      tabla += objeto.item;
      tabla += "</td>";
      tabla += "<td>";
      tabla += objeto.tall_descripcion;
      tabla += "</td>";
      tabla += "<td>";
      tabla += objeto.tipit_descripcion;
      tabla += "</td>";
      tabla += "<td>";
      tabla += new Intl.NumberFormat("us-US").format(objeto.vendet_cantidad);
      tabla += "</td>";
      tabla += "<td>";
      tabla += objeto.unime_descripcion;
      tabla += "</td>";
      tabla += "<td>";
      tabla += objeto.dep_descripcion;
      tabla += "</td>";
      tabla += "<td>";
      tabla += new Intl.NumberFormat("us-US").format(objeto.vendet_precio);
      tabla += "</td>";
      tabla += "<td>";
      tabla += new Intl.NumberFormat("us-US").format(objeto.exenta);
      tabla += "</td>";
      tabla += "<td>";
      tabla += new Intl.NumberFormat("us-US").format(objeto.grav5);
      tabla += "</td>";
      if (objeto.tipit_codigo == "3") {
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(objeto.vendet_precio);
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
    lineafoot += new Intl.NumberFormat("us-US").format(iva5.toFixed(2));
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
    $("#pie_detalle").html(lineafoot);
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

//Habilita botones en detalle
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
  const month = (date.getMonth() + 1).toString().padStart(2, "0");
  const day = date.getDate().toString().padStart(2, "0");
  const fecha = `${year}-${month}-${day}`;
  return fecha;
};

// Limpia campos de detalle
const limpiarCamposDetalle = () => {
  $("#dep_codigo").val(0);
  $("#dep_descripcion").val("");
  $("#it_codigo").val(0);
  $("#tipit_codigo").val(0);
  $("#tipim_codigo").val(0);
  $("#item").val("");
  $("#tall_descripcion").val("");
  $("#vendet_cantidad").val("");
  $("#unime_codigo").val(0);
  $("#unime_descripcion").val("");
  $("#vendet_precio").val("");
  $(".dep").attr("class", "form-line dep");
  $(".it").attr("class", "form-line it");
};

//Metodo que establece el alta de cabecera
const nuevo = () => {
  //Definimos las variables
  let condicion;

  //Validamos que la caja se encuentre abierta
  if ($("#caj_codigo").val() == 0) {
    condicion = true;
  }

  //Si no esta abierta mostramos un mensaje
  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "LA CAJA NO SE ENCUENTRA ABIERTA, DE ESTA MANERA NO SE PUEDE GENERAR UN NUMERO DE FACTURA",
      type: "info",
    });
  } else {
    //Si esta abierta la caja, procedemos de forma normal
    $("#operacion_cabecera").val(1);
    habilitarCampos(true);
    $(".activar").attr("class", "form-line activar focused");
    getCodigo();
    $(".fecha").attr("class", "form-line fecha focused");
    $("#ven_fecha").val(getDate());
    $(".ped").attr("class", "form-line ped");
    $("#per_numerodocumento").val("");
    $("#cli_codigo").val(0);
    $("#cliente").val("");
    $("#peven_codigo").val("");
    $(".foco2").attr("class", "form-line foco2");
    $(".foco3").attr("class", "form-line foco3");
    $("#tipco_codigo").val(4);
    $(".tp").attr("class", "form-line tp");
    $("#ven_tipofactura").val("");
    $(".foco4").attr("class", "form-line foco4");
    $("#ven_cuota").val("");
    $("#vent_montocuota").val("");
    $("#ven_interfecha").val("");
    $(".est").attr("class", "form-line est focused");
    $("#ven_estado").val("ACTIVO");
    actualizacionCabecera();
    habilitarBotones(false);
    getNumeroFactura();
    $("#cabecera").attr("style", "display: none");
    $("#detalle").attr("style", "display: none");
    validacionInputsVacios1();
    validacionInputsVacios2();
    validacionInputsVacios3();
  }
};

//Metodo que establece el alta del detalle
const nuevoDetalle = () => {
  $("#operacion_detalle").val(1);
  limpiarCamposDetalle();
  habilitarCampos(false);
  habilitarBotones2(false);
  consultaAsociacion(
    "Nuevo",
    "Esta venta ya está asociada a una nota de venta; no se pueden añadir más ítems."
  );
  validacionInputsVacios4();
};

//Metodo que establece la baja en venta cabecera
const anular = () => {
  $("#operacion_cabecera").val(2);
  $("#ven_estado").val("ANULADO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
  consultaAsociacion(
    "Eliminar",
    "Esta venta ya está asociada a una nota de venta; no se pueden eliminar más ítems."
  );
};

//Metodo que establece la baja en venta detalle
const eliminar = () => {
  $("#operacion_detalle").val(2);
  habilitarBotones2(false);
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload(true);
};

//Pasa parametros en el controlador para guardarlos en venta cabecera
const grabar = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      ven_codigo: $("#ven_codigo").val(),
      ven_fecha: $("#ven_fecha").val(),
      ven_numfactura: $("#ven_numfactura").val(),
      ven_timbrado: $("#ven_timbrado").val(),
      ven_timbrado_venc: $("#ven_timbrado_venc").val(),
      ven_tipofactura: $("#ven_tipofactura").val(),
      ven_cuota: $("#ven_cuota").val(),
      ven_montocuota: $("#ven_montocuota").val(),
      ven_interfecha: $("#ven_interfecha").val(),
      ven_estado: $("#ven_estado").val(),
      usu_codigo: $("#usu_codigo").val(),
      cli_codigo: $("#cli_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      tipco_codigo: $("#tipco_codigo").val(),
      peven_codigo: $("#peven_codigo").val(),
      caj_codigo: $("#caj_codigo").val(),
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

//Pasa parametros en el controlador de detalle para guardarlos en venta detalle
const grabarDetalle = () => {
  $.ajax({
    //Enviamos datos al controlador detalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      ven_codigo: $("#ven_codigo").val(),
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      dep_codigo: $("#dep_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      vendet_cantidad: $("#vendet_cantidad").val(),
      vendet_precio: $("#vendet_precio").val(),
      item: $("#item").val(),
      tall_descripcion: $("#tall_descripcion").val(),
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

//Establece los mensajes pára agregar y eliminar detalle
const confirmar2 = () => {
  //solicitamos el value del input operacion_detalle
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
  let condicion;

  if ($("#ven_codigo").val() == "") {
    condicion = true;
  } else if ($("#ven_fecha").val() == "") {
    condicion = true;
  } else if ($("#per_numerodocumento").val() == "") {
    condicion = true;
  } else if ($("#cliente").val() == "") {
    condicion = true;
  } else if ($("#peven_codigo").val() == "") {
    condicion = true;
  } else if ($("#ven_numfactura").val() == "") {
    condicion = true;
  } else if ($("#ven_timbrado").val() == "") {
    condicion = true;
  } else if ($("#ven_timbrado_venc").val() == "") {
    condicion = true;
  } else if ($("#ven_tipofactura").val() == "") {
    condicion = true;
  } else if ($("#ven_cuota").val() == "") {
    condicion = true;
  } else if ($("#ven_montocuota").val() == "") {
    condicion = true;
  } else if ($("#ven_interfecha").val() == "") {
    condicion = true;
  } else if ($("#emp_arzonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
    condicion = true;
  } else if ($("#ven_estado").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "COMPLETE TODOS LOS CAMPOS DE CABECERA QUE ESTÉN EN BLANCO",
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
  } else if ($("#it_codigo").val() == "") {
    condicion = true;
  } else if ($("#tipit_codigo").val() == "") {
    condicion = true;
  } else if ($("#tipim_codigo").val() == "") {
    condicion = true;
  } else if ($("#item").val() == "") {
    condicion = true;
  } else if ($("#tall_descripcion").val() == "") {
    condicion = true;
  } else if ($("#vendet_cantidad").val() == "") {
    condicion = true;
  } else if ($("#unime_codigo").val() == "") {
    condicion = true;
  } else if ($("#unime_descripcion").val() == "") {
    condicion = true;
  } else if ($("#vendet_precio").val() == "") {
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
      $("#vendet_cantidad").val() !== "0"
    ) {
      swal({
        title: "RESPUESTA!!",
        text: "LA CANTIDAD, EN CASO DE REGISTRAR UN SERVICIO, ES CERO(0)",
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
  $(".ped").attr("class", "form-line ped focused");
  $(".foco3").attr("class", "form-line foco3 focused");
  $(".tp").attr("class", "form-line tp focused");
  $(".foco4").attr("class", "form-line foco4 focused");
  $(".foco2").attr("class", "form-line foco2 focused");
  $(".foco").attr("class", "form-line foco focused");
  $(".est").attr("class", "form-line est focused");
  $("#detalle").attr("style", "display: block;");
  actualizacionCabecera();
  listarDetalle();
  limpiarCamposDetalle();
};

//Envia a los inputs de detalle lo seleccionado en la tabla de detalle
const seleccionarFila2 = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".dep").attr("class", "form-line dep focused");
  $(".it").attr("class", "form-line it focused");
};

//Envia a los input de pedido venta lo seleccionado en el autocompletado
const seleccionPedidoVenta = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulPedido").html();
  $("#listaPedido").attr("style", "display: none;");
  $(".ped").attr("class", "form-line ped focused");
};

//Busca, filtra y muestra los pedidos de venta
const getPedidoVenta = () => {
  $.ajax({
    //Solicitamos los datos a listaPedidoVentaVenta
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaPedidoVentaVenta.php",
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
            "<li class='list-group-item' onclick='seleccionPedidoVenta(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.pedido +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulPedido").html(fila);
      //hacemos visible la lista
      $("#listaPedido").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a los input de tipo factura lo seleccionado en el autocompletado
const seleccionTipoFactura = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTipoFactura").html();
  $("#listaTipoFactura").attr("style", "display: none;");
  $(".tp").attr("class", "form-line tp focused");
  controlTipoFactura();
  calculoCuota();
};

//Busca, filtra y muestra los tipos de factura
const getTipoFactura = () => {
  $.ajax({
    //Solicitamos los datos a listaTipoFactura
    method: "GET",
    url: "/sys8DD/others/complements_php/listas/listaTipoFactura.php",
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionTipoFactura(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.ven_tipofactura +
          "</li>";
      });

      //cargamos la lista
      $("#ulTipoFactura").html(fila);
      //hacemos visible la lista
      $("#listaTipoFactura").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a los input de deposito lo seleccionado en el autocompletado
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

//Envia a los input de item lo seleccionado en el autocompletado
const seleccionItem = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulItem").html();
  $("#listaItem").attr("style", "display: none;");
  $(".it").attr("class", "form-line it focused");
};

//Busca, filtra y muestra los items
const getItem = () => {
  $.ajax({
    //Solicitamos los datos a listaItemsPedidoVentaVenta
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaItemsPedidoVentaVenta.php",
    data: {
      peven_codigo: $("#peven_codigo").val(),
      item: $("#item").val(),
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
            objeto.item2 +
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

//Valida el tipo de factura, en caso de ser contado carga valores por defecto
const controlTipoFactura = () => {
  if ($("#ven_tipofactura").val() == "CONTADO") {
    $("#ven_cuota").val("1");
    $("#ven_interfecha").val("S/I");
    $(".foco4").attr("class", "form-line foco4 focused");
  } else {
    $("#ven_cuota").val("");
    $("#ven_interfecha").val("");
    $(".foco4").attr("class", "form-line foco4");
  }
};

//Te envia al menu
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

listar();
