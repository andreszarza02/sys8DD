//Controla que los inputs no se queden vacios al perder el foco y que solo contengan letras, numeros y el simbolo -
const validacionInputsVacios1 = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase letras-numeros-algunos-simbolos realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("letras-numeros-algunos-simbolos")
      ) {
        //Definimos variables a utilizar
        let mensaje = "";
        const tieneSimbolo = /[¨!°¬@#$%^&*()_~+\=\[\]{};':"\\|,.<>\/?]/;

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
          // Si no está vacío, comprobamos si tiene simbolos distintos a -
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene simbolos distintos a -
          if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} solo acepta letras, números y el simbolo guion(-)`;
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

//Controla que los inputs no se queden vacios al perder el foco y que no contengan letras y simbolos que no sean . y ,
const validacionInputsVacios4 = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase numeros-algunos-simbolos realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("numeros-algunos-simbolos")
      ) {
        //Definimos variables a utilizar
        let mensaje = "";
        const tieneMinuscula = /[a-z]/;
        const tieneMayuscula = /[A-Z]/;
        const tieneSimbolo = /[¨!°¬@#$^&*()_~+\-=\[\]{};':"\\|<>\/?]/;

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
          // Si no está vacío, comprobamos si contiene letras o simbolos distintos a . y ,
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene letras o simbolos distintos a . y ,
          if (
            tieneSimbolo.test(input.value) &&
            (tieneMayuscula.test(input.value) ||
              tieneMinuscula.test(input.value))
          ) {
            mensaje = `El campo ${labelText} contiene letras y simbolos distintos a .(punto) y ,(coma)`;
          } else if (
            tieneMayuscula.test(input.value) ||
            tieneMinuscula.test(input.value)
          ) {
            mensaje = `El campo ${labelText} contiene letras`;
          } else if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} contiene simbolos distintos a .(punto) y ,(coma)`;
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

//Controla que los inputs no se queden vacios al perder el foco y que solo contengan letras, numeros y el simbolo /
const validacionInputsVacios5 = () => {
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

//Controla que los inputs no se queden vacios al perder el foco y que no contengan simbolos
const validacionInputsVacios6 = () => {
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

// Valida si la orden de compra esta asociada a una compra
const consultaAsociacion = (escenario, mensaje) => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      orcom_codigo: $("#orcom_codigo").val(),
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

// Se enarga de calcular el monto cuota
const calculoCuota = () => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      prepro_codigo: $("#prepro_codigo").val(),
      orcom_cuota: $("#orcom_cuota").val(),
      consulta2: 1,
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (respuesta) {
      $("#orcom_montocuota").val(respuesta.division);
      $(".foco2").attr("class", "form-line foco2 focused");
    });
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

//Permite aplicar un formato de tabla a la lista de orden compra cabecera
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

//Consulta y establece el codigo de orden compra en cabecera
const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta: 1,
    },
  }).done(function (respuesta) {
    $("#orcom_codigo").val(respuesta.orcom_codigo);
  });
};

//Consulta y lista los datos de orden compra cabecera
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
        tabla += objeto.orcom_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.orcom_fecha;
        ("sys8DD");
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.orcom_condicionpago;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.orcom_cuota;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.orcom_montocuota;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.orcom_interfecha;
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
        tabla += objeto.orcom_estado;
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

//Consulta y lista los datos de orden compra detalle
const listarDetalle = () => {
  $.ajax({
    //solicitamos los datos al controladorDetalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      orden: $("#orcom_codigo").val(),
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
          totalG10 += parseFloat(objeto.orcomdet_precio);
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
          objeto.orcomdet_cantidad
        );
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.unime_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(objeto.orcomdet_precio);
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
            objeto.orcomdet_precio
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
      lineafoot += "<th colspan='5'>";
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
      lineafoot += "<th colspan='6'>";
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
      lineafoot += "<th colspan='7'>";
      lineafoot += "TOTAL IVA";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalIva.toFixed(2));
      lineafoot += "</th>";
      lineafoot += "</tr>";

      lineafoot += "<tr class='bg-blue'>";
      lineafoot += "<th colspan='7'>";
      lineafoot += "TOTAL GENERAL";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalGral.toFixed(2));
      lineafoot += "</th>";
      lineafoot += "</tr>";
      //establecemos el body, foot y el formato de la tabla
      $("#pie_detalle").html(lineafoot);
      $("#tabla_detalle").html(tabla);
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
  const month = date.getMonth() + 1;
  const day = date.getDate();
  const fecha = `${day}/${month}/${year}`;

  return fecha;
};

// Limpia campos de detalle
const limpiarCamposDetalle = () => {
  $("#it_codigo").val(0);
  $("#tipit_codigo").val(0);
  $("#it_descripcion").val("");
  $("#orcomdet_cantidad").val("");
  $("#unime_codigo").val(0);
  $("#unime_descripcion").val("");
  $("#orcomdet_precio").val("");
  $(".it").attr("class", "form-line it");
};

// Metodo que establece el alta de cabecera
const nuevo = () => {
  $("#operacion_cabecera").val(1);
  $("#procedimiento").val("ALTA");
  habilitarCampos(true);
  $(".activar").attr("class", "form-line activar focused");
  getCodigo();
  $(".est").attr("class", "form-line est focused");
  $(".fecha").attr("class", "form-line fecha focused");
  $("#orcom_estado").val("ACTIVO");
  $("#orcom_fecha").val(getDate());
  $("#pro_codigo").val(0);
  $("#tipro_codigo").val(0);
  $("#tipro_descripcion").val("");
  $("#pro_razonsocial").val("");
  $("#prepro_codigo").val("");
  $("#orcom_condicionpago").val("");
  $("#orcom_cuota").val("");
  $("#orcom_montocuota").val("");
  $("#orcom_interfecha").val("");
  $(".co").attr("class", "form-line co");
  $(".or").attr("class", "form-line or");
  $(".pro").attr("class", "form-line pro");
  $(".foco2").attr("class", "form-line foco2");
  $("#cabecera").attr("style", "display: none");
  $("#detalle").attr("style", "display: none");
  actualizacionCabecera();
  habilitarBotones(false);
  validacionInputsVacios1();
  validacionInputsVacios2();
  validacionInputsVacios3();
  validacionInputsVacios4();
  validacionInputsVacios5();
};

//Metodo que establece el alta del detalle
const nuevoDetalle = () => {
  $("#operacion_detalle").val(1);
  limpiarCamposDetalle();
  habilitarCampos(false);
  habilitarBotones2(false);
  validacionInputsVacios6();
  consultaAsociacion(
    "Nuevo",
    "Está orden de compra ya está asociada a una compra; no se pueden añadir más ítems."
  );
};

//Metodo que establece la baja de cabecera
const anular = () => {
  $("#operacion_cabecera").val(2);
  $("#procedimiento").val("ALTA");
  $(".est").attr("class", "form-line est focused");
  $("#orcom_estado").val("ANULADO");
  habilitarBotones(false);
};

//Metodo que establece la baja de detalle
const eliminar = () => {
  $("#operacion_detalle").val(2);
  habilitarBotones2(false);
  consultaAsociacion(
    "Eliminar",
    "Está orden de compra ya está asociada a una compra; no se pueden eliminar ítems."
  );
};

// Metodo que se encarga de imprimr
const imprimir = () => {
  let orden = $("#orcom_codigo").val();
  window.location =
    "/sys8DD/report/compras/reporte/reporte_impresion_orden_compra.php?orcom_codigo=" +
    orden;
};

// Envia la orden por correo al proveedor
const enviarOrden = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "/sys8DD/others/complements_php/correo/correo_envio_orden_compra.php",
    data: {
      orcom_codigo: $("#orcom_codigo").val(),
      pro_razonsocial: $("#pro_razonsocial").val(),
      pro_email: $("#pro_email").val(),
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

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload(true);
};

//Pasa parametros en el controlador de cabecera
const grabar = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      orcom_codigo: $("#orcom_codigo").val(),
      orcom_fecha: $("#orcom_fecha").val(),
      orcom_condicionpago: $("#orcom_condicionpago").val(),
      orcom_cuota: $("#orcom_cuota").val(),
      orcom_montocuota: $("#orcom_montocuota").val(),
      orcom_interfecha: $("#orcom_interfecha").val(),
      orcom_estado: $("#orcom_estado").val(),
      usu_codigo: $("#usu_codigo").val(),
      pro_codigo: $("#pro_codigo").val(),
      tipro_codigo: $("#tipro_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      prepro_codigo: $("#prepro_codigo").val(),
      pedco_codigo: $("#pedco_codigo").val(),
      operacion_cabecera: $("#operacion_cabecera").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
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

//Pasa parametros en el controlador de detalle
const grabarDetalle = () => {
  $.ajax({
    //Enviamos datos al controlador detalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      orcom_codigo: $("#orcom_codigo").val(),
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      orcomdet_cantidad: $("#orcomdet_cantidad").val(),
      orcomdet_precio: $("#orcomdet_precio").val(),
      operacion_detalle: $("#operacion_detalle").val(),
      orcom_cuota: $("#orcom_cuota").val(),
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
  let condicion;

  if ($("#orcom_codigo").val() == "") {
    condicion = true;
  } else if ($("#orcom_fecha").val() == "") {
    condicion = true;
  } else if ($("#prepro_codigo").val() == "") {
    condicion = true;
  } else if ($("#orcom_condicionpago").val() == "") {
    condicion = true;
  } else if ($("#orcom_cuota").val() == "") {
    condicion = true;
  } else if ($("#orcom_montocuota").val() == "") {
    condicion = true;
  } else if ($("#orcom_interfecha").val() == "") {
    condicion = true;
  } else if ($("#pro_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#tipro_descripcion").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
    condicion = true;
  } else if ($("#orcom_estado").val() == "") {
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

  if ($("#it_descripcion").val() == "") {
    condicion = true;
  } else if ($("#orcomdet_cantidad").val() == "") {
    condicion = true;
  } else if ($("#unime_descripcion").val() == "") {
    condicion = true;
  } else if ($("#orcomdet_precio").val() == "") {
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
      $("#orcomdet_cantidad").val() !== "0"
    ) {
      swal({
        title: "RESPUESTA!!",
        text: "LA CANTIDAD, EN CASO DE ORDENAR UN SERVICIO, ES CERO(0)",
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
  $(".foco").attr("class", "form-line foco focused");
  $(".fecha").attr("class", "form-line fecha focused");
  $(".pro").attr("class", "form-line pro focused");
  $(".co").attr("class", "form-line co focused");
  $(".est").attr("class", "form-line est focused");
  $(".or").attr("class", "form-line or focused");
  $(".foco2").attr("class", "form-line foco2 focused");
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

  $(".it").attr("class", "form-line it focused");
};

//Envia a los input de item lo seleccionado en el autocompletado de item
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
    //Solicitamos los datos a listaItemsOrdenCompra
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaItemsOrdenCompra.php",
    data: {
      prepro_codigo: $("#prepro_codigo").val(),
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

//Envia a los input de presupuesto proveedor cabecera lo seleccionado en el autocompletado de presupuesto proveedor cabecera
const seleccionPresupuestoProveedor = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulPresupuesto").html();
  $("#listaPresupuesto").attr("style", "display: none;");
  $(".pro").attr("class", "form-line pro focused");
};

//Busca, filtra y muestra los presupuestos de proveedor cabecera
const getPresupuestoProveedor = () => {
  $.ajax({
    //Solicitamos los datos a listaPresupuestoProveedor
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaPresupuestoProveedor.php",
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
            "<li class='list-group-item' onclick='seleccionPresupuestoProveedor(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.presupuesto +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulPresupuesto").html(fila);
      //hacemos visible la lista
      $("#listaPresupuesto").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a los input de condicion pago lo seleccionado en el autocompletado de condicion pago
const seleccionCondicionPago = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulCondicion").html();
  $("#listaCondicion").attr("style", "display: none;");
  $(".co").attr("class", "form-line co focused");
  limpiarCondicion();
};

//Busca y muestra las condiciones de pago
const getCondicionPago = () => {
  $.ajax({
    //Solicitamos los datos a listaCondicionPago
    method: "GET",
    url: "/sys8DD/others/complements_php/listas/listaCondicionPago.php",
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionCondicionPago(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.orcom_condicionpago +
          "</li>";
      });
      //cargamos la lista
      $("#ulCondicion").html(fila);
      //hacemos visible la lista
      $("#listaCondicion").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

// En base a la condicion de pago establece valores por defecto
const limpiarCondicion = () => {
  if ($("#orcom_condicionpago").val() == "CONTADO") {
    $("#orcom_interfecha").val("S/I");
    $(".or").attr("class", "form-line or focused");
  } else {
    $("#orcom_interfecha").val("");
    $(".or").attr("class", "form-line or");
  }
};

//Te envia al menu
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

listar();
