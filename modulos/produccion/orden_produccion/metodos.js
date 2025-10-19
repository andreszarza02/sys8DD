//Controla que los inputs no se queden vacios al perder el foco y que no contengan letras o simbolos excepto el guion -
const validacionInputsVacios1 = () => {
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
        const tieneSimbolo = /[¨!°¬@#$^&*()_~+\=\[\]{};':"\\|,.<>\/?]/;

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
          // Si no está vacío, comprobamos si contiene letras o simbolo distinto a -
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene letras o simbolo distinto a -
          if (
            tieneSimbolo.test(input.value) &&
            (tieneMayuscula.test(input.value) ||
              tieneMinuscula.test(input.value))
          ) {
            mensaje = `El campo ${labelText} contiene letras y símbolos distintos a guion(-)`;
          } else if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} contiene símbolos distintos a guion(-)`;
          } else if (
            tieneMayuscula.test(input.value) ||
            tieneMinuscula.test(input.value)
          ) {
            mensaje = `El campo ${labelText} contiene letras`;
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

//Controla que los inputs no se queden vacios al perder el foco y que solo contengan letras y numeros
const validacionInputsVacios2 = () => {
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
          // Si no está vacío, comprobamos si contiene letras o símbolos
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene números o símbolos
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

//Consulta  y establece el codigo de orden produccion en cabecera
const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta1: 1,
    },
  }).done(function (respuesta) {
    $("#orpro_codigo").val(respuesta.orpro_codigo);
  });
};

// Valida si la orden de produccion esta asociada a una produccion
const consultaAsociacion = (escenario, mensaje) => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      orpro_codigo: $("#orpro_codigo").val(),
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

//Permite aplicar un formato de tabla a la lista de orden produccion cabecera
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

//Permite aplicar un formato de tabla a la lista de orden produccion detalle
function formatoTabla2() {
  //Exportable table
  $(".js-exportable2").DataTable({
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

//Permite aplicar un formato de tabla a la lista de orden produccion detalle2
function formatoTabla3() {
  //Exportable table
  $(".js-exportable3").DataTable({
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

//Consulta y lista los registros de orden produccion cabecera
const listar = () => {
  $.ajax({
    //solicitamos los datos al controlador
    method: "GET",
    url: "controlador.php",
  })
    .done(function (respuesta) {
      //Verifica si la tabla ya esta definida como dataTable en caso de ser asi elimina la instancia para que en un futuro se pueda volver a definir
      if ($.fn.dataTable.isDataTable(".js-exportable")) {
        $(".js-exportable").DataTable().destroy();
      }

      //individualizamos el array de objetos y lo separamos por filas
      let tabla = "";
      for (objeto of respuesta) {
        tabla +=
          "<tr onclick='seleccionarFila(" +
          JSON.stringify(objeto).replace(/'/g, "&#39;") +
          ")'>";
        tabla += "<td>";
        tabla += objeto.orpro_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.orpro_fecha;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.orpro_fechainicio;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.orpro_fechaculminacion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.cliente;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pres_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.secc_descripcion;
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
        tabla += objeto.orpro_estado;
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

//Consulta y lista los registros de orden produccion detalle 2
const listarDetalle2 = () => {
  $.ajax({
    //solicitamos los datos al controladorDetalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      orden2: $("#orpro_codigo").val(),
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
    },
  })
    .done(function (respuesta) {
      //Verifica si la tabla ya esta definida como dataTable en caso de ser asi elimina la instancia para que en un futuro se pueda volver a definir
      if ($.fn.dataTable.isDataTable(".js-exportable3")) {
        $(".js-exportable3").DataTable().destroy();
      }

      //individualizamos el array de objetos y lo separamos por filas
      let tabla = "";
      for (objeto of respuesta) {
        tabla += "<tr>";
        tabla += "<td>";
        tabla += objeto.it_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(
          objeto.orprocomdet_cantidad
        );
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(
          objeto.orprocomdet_costo
        );
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.unime_descripcion;
        tabla += "</td>";
        tabla += "</tr>";
      }
      //establecemos el body Y definimos propiedades
      $("#tabla_detalle2").html(tabla);
      $("#detalle2").attr("class", "col-lg-6 col-md-6 col-sm-6");
      $("#detalle3").attr("style", "display:block");
      formatoTabla3();
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Consulta y lista los registros de orden produccion detalle
const listarDetalle = () => {
  $.ajax({
    //solicitamos los datos al controladorDetalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      orden: $("#orpro_codigo").val(),
    },
  })
    .done(function (respuesta) {
      //Verifica si la tabla ya esta definida como dataTable en caso de ser asi elimina la instancia para que en un futuro se pueda volver a definir
      if ($.fn.dataTable.isDataTable(".js-exportable2")) {
        $(".js-exportable2").DataTable().destroy();
      }

      //individualizamos el array de objetos y lo separamos por filas
      let tabla = "";
      let totalCantidad = 0;
      let lineafoot;
      for (objeto of respuesta) {
        totalCantidad += parseInt(objeto.orprodet_cantidad);
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
        tabla += objeto.orprodet_cantidad;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.unime_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.dep_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.orprodet_especificacion;
        tabla += "</td>";
        tabla += "</tr>";
      }

      lineafoot += "<tr class='bg-blue'>";
      lineafoot += "<th colspan='5'>";
      lineafoot += "TOTAL A PRODUCIR";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += totalCantidad + " UNIDADES DE PRENDAS";
      lineafoot += "</th>";
      lineafoot += "</tr>";
      //establecemos el body, el foot y las propiedades
      $("#tabla_detalle").html(tabla);
      $("#pie_detalle").html(lineafoot);
      $("#detalle2").attr("class", "col-lg-12 col-md-12 col-sm-12");
      $("#detalle3").attr("style", "display:none");
      $("#tabla_detalle2").html("");
      formatoTabla2();
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
  $(".activar").attr("class", "form-line activar focused");
  getCodigo();
  $(".fecha").attr("class", "form-line fecha focused");
  $(".est").attr("class", "form-line est focused");
  $(".pre").attr("class", "form-line pre");
  $(".secc").attr("class", "form-line secc");
  $("#orpro_estado").val("ACTIVO");
  $("#orpro_fecha").val(getDate());
  $("#orpro_fechainicio").val("");
  $("#orpro_fechaculminacion").val("");
  $("#per_numerodocumento").val("");
  $("#cliente").val("");
  $("#peven_codigo").val(0);
  $("#pres_codigo").val("");
  $("#secc_codigo").val(0);
  $("#secc_descripcion").val("");
  actualizacionCabecera();
  habilitarBotones(false);
  $("#cabecera").attr("style", "display: none");
  $("#detalle").attr("style", "display: none");
  validacionInputsVacios1();
  validacionInputsVacios2();
};

// Metodo que se encarga de limpiar los campos del detalle
const limpiarCamposDetalle = () => {
  $("#dep_codigo").val(0);
  $("#dep_descripcion").val("");
  $("#it_codigo").val(0);
  $("#tipit_codigo").val(0);
  $("#it_descripcion").val("");
  $("#tall_descripcion").val("");
  $("#orprodet_cantidad").val("");
  $("#unime_codigo").val(0);
  $("#unime_descripcion").val("");
  $("#orprodet_especificacion").val("");
  $(".dep").attr("class", "form-line dep");
  $(".it").attr("class", "form-line it");
  $(".foco2").attr("class", "form-line foco2");
};

//Metodo que establece el alta del detalle
const nuevoDetalle = () => {
  $("#operacion_detalle").val(1);
  limpiarCamposDetalle();
  setEspe();
  habilitarCampos(false);
  habilitarBotones2(false);
  validacionInputsVacios2();
  consultaAsociacion(
    "Nuevo",
    "Esta orden de producción ya está asociada a una producción; no se pueden añadir más ítems."
  );
};

//Metodo que establece la baja en cabecera
const anular = () => {
  $("#operacion_cabecera").val(2);
  $("#procedimiento").val("BAJA");
  $("#orpro_estado").val("ANULADO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

//Metodo que establece la baja en el detalle
const eliminar = () => {
  $("#operacion_detalle").val(2);
  habilitarBotones2(false);
  consultaAsociacion(
    "Eliminar",
    "Esta orden de producción ya está asociada a una producción; no se pueden eliminar más ítems."
  );
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload(true);
};

//Limpia los input de detalle
const reiniciarInputsDetalle = () => {
  $("#dep_codigo").val(0);
  $("#dep_descripcion").val("");
  $("#it_codigo").val(0);
  $("#tipit_codigo").val(0);
  $("#item").val("");
  $("#tall_descripcion").val("");
  $("#orprodet_cantidad").val("");
  $("#unime_codigo").val(0);
  $("#unime_descripcion").val("");
  $("#orprodet_especificacion").val("");
  $(".dep").attr("class", "form-line dep");
  $(".it").attr("class", "form-line it");
  $(".foco2").attr("class", "form-line foco2");
};

//Pasa parametros en el controlador para guardarlos en orden produccion cabecera
const grabar = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      orpro_codigo: $("#orpro_codigo").val(),
      orpro_fecha: $("#orpro_fecha").val(),
      orpro_fechainicio: $("#orpro_fechainicio").val(),
      orpro_fechaculminacion: $("#orpro_fechaculminacion").val(),
      orpro_estado: $("#orpro_estado").val(),
      usu_codigo: $("#usu_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      secc_codigo: $("#secc_codigo").val(),
      pres_codigo: $("#pres_codigo").val(),
      peven_codigo: $("#peven_codigo").val(),
      operacion_cabecera: $("#operacion_cabecera").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
      secc_descripcion: $("#secc_descripcion").val(),
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

//Pasa parametros en el controlador de detalle para guardarlos en orden produccion detalle
const grabarDetalle = () => {
  $.ajax({
    //Enviamos datos al controlador detalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      orpro_codigo: $("#orpro_codigo").val(),
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      orprodet_especificacion: $("#orprodet_especificacion").val(),
      orprodet_cantidad: $("#orprodet_cantidad").val(),
      dep_codigo: $("#dep_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
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

  if ($("#orpro_codigo").val() == "") {
    condicion = true;
  } else if ($("#orpro_fecha").val() == "") {
    condicion = true;
  } else if ($("#orpro_fechainicio").val() == "") {
    condicion = true;
  } else if ($("#orpro_fechaculminacion").val() == "") {
    condicion = true;
  } else if ($("#per_numerodocumento").val() == "") {
    condicion = true;
  } else if ($("#cliente").val() == "") {
    condicion = true;
  } else if ($("#pres_codigo").val() == "") {
    condicion = true;
  } else if ($("#secc_codigo").val() == "0") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
    condicion = true;
  } else if ($("#orpro_estado").val() == "") {
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
  } else if ($("#it_descripcion").val() == "") {
    condicion = true;
  } else if ($("#tall_descripcion").val() == "") {
    condicion = true;
  } else if ($("#orprodet_cantidad").val() == "") {
    condicion = true;
  } else if ($("#unime_descripcion").val() == "") {
    condicion = true;
  } else if ($("#orprodet_especificacion").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "COMPLETE TODOS LOS CAMPOS DE DETALLE QUE ESTÉN EN BLANCO",
      type: "error",
    });
  } else {
    confirmar2();
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
  $(".foco").attr("class", "form-line foco focused");
  $(".pre").attr("class", "form-line pre focused");
  $(".secc").attr("class", "form-line secc focused");
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
  $(".foco2").attr("class", "form-line foco2 focused");
  listarDetalle2();
};

//Envia a los input de presupuesto lo seleccionado en el autocompletado
const seleccionPresupuestoProduccion = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulPresupuesto").html();
  $("#listaPresupuesto").attr("style", "display: none;");
  $(".pre").attr("class", "form-line pre focused");
};

//Busca, filtra y muestra los presupuestos de produccion
const getPresupuestoProduccion = () => {
  $.ajax({
    //Solicitamos los datos a listaPresupuestoProduccion
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaPresupuestoProduccion.php",
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
            "<li class='list-group-item' onclick='seleccionPresupuestoProduccion(" +
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

//Envia a los input de deposito lo seleccionado en el autocompletado de deposito
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
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulItem").html();
  $("#listaItem").attr("style", "display: none;");
  $(".it").attr("class", "form-line it focused");
  $(".foco2").attr("class", "form-line foco2 focused");
};

//Busca, filtra y muestra los items
const getItem = () => {
  $.ajax({
    //Solicitamos los datos a listaItemsOrdenProduccion
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaItemsOrdenProduccion.php",
    data: {
      pres_codigo: $("#pres_codigo").val(),
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

//Envia a los input de seccion lo seleccionado en el autocompletado de seccion
const seleccionSeccion = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulSeccion").html();
  $("#listaSeccion").attr("style", "display: none;");
  $(".secc").attr("class", "form-line secc focused");
};

//Busca, filtra y muestra las secciones
const getSeccion = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaSeccion.php",
    data: {
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
            "<li class='list-group-item' onclick='seleccionSeccion(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.secc_descripcion +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulSeccion").html(fila);
      //hacemos visible la lista
      $("#listaSeccion").attr(
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

//Establece un valor por defecto en especificacion
const setEspe = () => {
  $("#orprodet_especificacion").val("SIN ESPECIFICACION");
  $(".foco2").attr("class", "form-line foco2 focused");
};

//En caso de querer modificar el valor de la especificacion limpia el campo
const cleanEspe = () => {
  $("#orprodet_especificacion").val("");
};

listar();
