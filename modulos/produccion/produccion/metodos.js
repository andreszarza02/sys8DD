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

//Consulta  y establece el codigo de produccion en cabecera
const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta: 1,
    },
  }).done(function (respuesta) {
    $("#prod_codigo").val(respuesta.prod_codigo);
  });
};

//Permite aplicar un formato de tabla a la lista de produccion cabecera
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

//Consulta y lista los registros de produccion cabecera
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
        tabla += objeto.prod_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.prod_fecha;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.orpro_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.secc_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.orpro_fechainicio;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.orpro_fechaculminacion;
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
        tabla += objeto.prod_estado;
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

//Consulta y lista los registros de produccion detalle
const listarDetalle = () => {
  $.ajax({
    //solicitamos los datos al controladorDetalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      produccion: $("#prod_codigo").val(),
    },
  })
    .done(function (respuesta) {
      //individualizamos el array de objetos y lo separamos por filas
      let tabla = "";
      let totalCantidad = 0;
      for (objeto of respuesta) {
        totalCantidad += parseInt(objeto.prodet_cantidad);
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
        tabla += objeto.prodet_cantidad;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.unime_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.prodet_fechainicio;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.prodet_fechafinal;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.prodet_observacion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.prodet_estado;
        tabla += "</td>";
        tabla += "</tr>";
      }
      //Mostramos los subtotales y totales
      let lineafoot;

      lineafoot += "<tr class='bg-blue'>";
      lineafoot += "<th colspan='7'>";
      lineafoot += "TOTAL PRODUCCION";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += totalCantidad + " UNIDADES DE PRENDAS";
      lineafoot += "</th>";
      lineafoot += "</tr>";
      //establecemos el body y foot
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

//Metodo que establece el alta de cabecera
const nuevo = () => {
  $("#operacion_cabecera").val(1);
  $("#procedimiento").val("ALTA");
  habilitarCampos(true);
  $(".activar").attr("class", "form-line activar focused");
  getCodigo();
  $(".fecha").attr("class", "form-line fecha focused");
  $("#prod_fecha").val(getDate());
  $(".or").attr("class", "form-line or");
  $(".est").attr("class", "form-line est focused");
  $("#prod_estado").val("ACTIVO");
  $("#secc_descripcion").val("");
  $("#orpro_codigo").val("");
  $("#orpro_fechainicio").val("");
  $("#orpro_fechaculminacion").val("");
  actualizacionCabecera();
  habilitarBotones(false);
  $("#cabecera").attr("style", "display: none");
  $("#detalle").attr("style", "display: none");
};

//Metodo que establece el alta del detalle
const nuevoDetalle = () => {
  $("#operacion_detalle").val(1);
  $("#it_codigo").val(0);
  $("#tipit_codigo").val(0);
  $("#item").val("");
  $("#tall_descripcion").val("");
  $("#prodet_cantidad").val("");
  $("#unime_codigo").val(0);
  $("#unime_descripcion").val("");
  $("#prodet_fechainicio").val("");
  $("#prodet_fechafinal").val("");
  $("#prodet_observacion").val("");
  $("#prodet_estado").val("ACTIVO");
  $(".it").attr("class", "form-line it");
  $(".foco3").attr("class", "form-line foco3");
  $(".est2").attr("class", "form-line est2 focused");
  setObs();
  habilitarCampos(false);
  habilitarBotones2(false);
};

//Metodo que establece la baja en cabecera
const anular = () => {
  $("#operacion_cabecera").val(2);
  $("#procedimiento").val("BAJA");
  $("#prod_estado").val("ANULADO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

//Metodo que establece la baja en el detalle
const eliminar = () => {
  $("#operacion_detalle").val(2);
  habilitarBotones2(false);
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload(true);
};

//Pasa parametros en el controlador para guardarlos en produccion cabecera
const grabar = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      prod_codigo: $("#prod_codigo").val(),
      prod_fecha: $("#prod_fecha").val(),
      prod_estado: $("#prod_estado").val(),
      orpro_codigo: $("#orpro_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      operacion_cabecera: $("#operacion_cabecera").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
      secc_descripcion: $("#secc_descripcion").val(),
      orpro_fechainicio: $("#orpro_fechainicio").val(),
      orpro_fechaculminacion: $("#orpro_fechaculminacion").val(),
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

//Pasa parametros en el controlador de detalle para guardarlos en produccion detalle
const grabarDetalle = () => {
  $.ajax({
    //Enviamos datos al controlador detalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      prod_codigo: $("#prod_codigo").val(),
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      prodet_cantidad: $("#prodet_cantidad").val(),
      prodet_fechainicio: $("#prodet_fechainicio").val(),
      prodet_fechafinal: $("#prodet_fechafinal").val(),
      prodet_observacion: $("#prodet_observacion").val(),
      prodet_estado: $("#prodet_estado").val(),
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

  if ($("#prod_codigo").val() == "") {
    condicion = true;
  } else if ($("#prod_fecha").val() == "") {
    condicion = true;
  } else if ($("#secc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#orpro_codigo").val() == "") {
    condicion = true;
  } else if ($("#orpro_fechainicio").val() == "") {
    condicion = true;
  } else if ($("#orpro_fechaculminacion").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
    condicion = true;
  } else if ($("#prod_estado").val() == "") {
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

  if ($("#item").val() == "") {
    condicion = true;
  } else if ($("#tall_descripcion").val() == "") {
    condicion = true;
  } else if ($("#prodet_cantidad").val() == "") {
    condicion = true;
  } else if ($("#unime_descripcion").val() == "") {
    condicion = true;
  } else if ($("#prodet_fechainicio").val() == "") {
    condicion = true;
  } else if ($("#prodet_fechafinal").val() == "") {
    condicion = true;
  } else if ($("#prodet_observacion").val() == "") {
    condicion = true;
  } else if ($("#prodet_estado").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "Cargue todos los campos en blanco",
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
  $(".or").attr("class", "form-line or focused");
  $(".foco").attr("class", "form-line foco focused");
  $(".est").attr("class", "form-line est focused");
  $("#detalle").attr("style", "display: block;");
  actualizacionCabecera();
  listarDetalle();
};

//Envia a los inputs de detalle lo seleccionado en la tabla de detalle
const seleccionarFila2 = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".it").attr("class", "form-line it focused");
  $(".foco2").attr("class", "form-line foco2 focused");
  $(".foco3").attr("class", "form-line foco3 focused");
  $(".est2").attr("class", "form-line est2 focused");
};

//Envia a los input de orden produccion lo seleccionado en el autocompletado
const seleccionOrdenProduccion = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulOrden").html();
  $("#listaOrden").attr("style", "display: none;");
  $(".or").attr("class", "form-line or focused");
};

//Busca, filtra y muestra las ordenes de produccion
const getOrdenProduccion = () => {
  $.ajax({
    //Solicitamos los datos a listaOrdenProduccion
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaOrdenProduccion.php",
    data: {
      secc_descripcion: $("#secc_descripcion").val(),
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
            "<li class='list-group-item' onclick='seleccionOrdenProduccion(" +
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
    //Solicitamos los datos a listaItemsProduccion
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaItemsProduccion.php",
    data: {
      orpro_codigo: $("#orpro_codigo").val(),
      it_descripcion: $("#item").val(),
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

//Te envia al menu
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

//Establece un valor por defecto en observacion
const setObs = () => {
  $("#prodet_observacion").val("SIN OBS");
  $(".foco3").attr("class", "form-line foco3 focused");
};

//En caso de querer modificar el valor de la observacion limpia el campo
const cleanObs = () => {
  $("#prodet_observacion").val("");
};

listar();
