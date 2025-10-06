//Permite aplicar un formato de tabla a la lista de la referencial
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

//Consulta  y establece el codigo de la referencial
const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta: 1,
    },
  }).done(function (respuesta) {
    $("#mod_codigo").val(respuesta.mod_codigo);
  });
};

//Consulta y lista los datos en la grilla de la referencial
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
        tabla += objeto.mod_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.mod_codigomodelo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.col_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.mod_sexo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.mod_observacion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.mod_estado;
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

const habilitarBotones = (booleano) => {
  if (booleano) {
    $(".botonesExtra1").attr("style", "display: block;");
    $(".botonesExtra2").attr("style", "display: none;");
  } else {
    $(".botonesExtra2").attr("style", "display: block;");
    $(".botonesExtra1").attr("style", "display: none;");
  }
};

const habilitarCampos = () => {
  $(".no-disabled").removeAttr("disabled");
};

const agregar = () => {
  $("#operacion").val(1);
  $("#procedimiento").val("ALTA");
  habilitarCampos();
  $(".activar").attr("class", "form-line activar focused");
  getCodigo();
  $("#modelos").attr("style", "display: none");
  $(".est").attr("class", "form-line est focused");
  $(".foco").attr("class", "form-line foco");
  $(".col").attr("class", "form-line col");
  $(".se").attr("class", "form-line se");
  $("#mod_observacion").val("Sin obs");
  $(".obs").attr("class", "form-line obs focused");
  $("#mod_estado").val("ACTIVO");
  $("#mod_codigomodelo").val("");
  $("#col_codigo").val(0);
  $("#col_descripcion").val("");
  $("#mod_sexo").val("");
  habilitarBotones(false);
};

const modificar = () => {
  $("#operacion").val(2);
  $("#procedimiento").val("MODIFICACION");
  $("#mod_estado").val("ACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarCampos();
  habilitarBotones(false);
};

const borrar = () => {
  $("#operacion").val(3);
  $("#procedimiento").val("BAJA");
  $("#mod_estado").val("INACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

const limpiarCampos = () => {
  window.location.reload();
};

const abm = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      mod_codigo: $("#mod_codigo").val(),
      mod_codigomodelo: $("#mod_codigomodelo").val(),
      col_codigo: $("#col_codigo").val(),
      mod_sexo: $("#mod_sexo").val(),
      mod_observacion: $("#mod_observacion").val(),
      mod_estado: $("#mod_estado").val(),
      operacion: $("#operacion").val(),
      usu_codigo: $("#usu_codigo").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
      col_descripcion: $("#col_descripcion").val(),
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
  //solicitamos el value del input operacion
  var oper = $("#operacion").val();

  preg = "¿Desea agregar el registro?";

  /* De acuerdo si la operacion es 2 o 3 modificamos la pregunta */
  if (oper == 2) {
    preg = "¿Desea modificar el registro?";
  }

  if (oper == 3) {
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
      //Si la operacion es correcta llamamos al metodo grabar
      if (isConfirm) {
        abm();
      } else {
        //Si cancelamos la operacion realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

const controlVacio = () => {
  let condicion;

  if ($("#mod_codigo").val() == "") {
    condicion = true;
  } else if ($("#mod_codigomodelo").val() == "") {
    condicion = true;
  } else if ($("#col_descripcion").val() == "") {
    condicion = true;
  } else if ($("#mod_sexo").val() == "") {
    condicion = true;
  } else if ($("#mod_observacion").val() == "") {
    condicion = true;
  } else if ($("#mod_estado").val() == "") {
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

const seleccionarFila = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".activar").attr("class", "form-line activar focused");
  $(".foco").attr("class", "form-line foco focused");
  $(".col").attr("class", "form-line col focused");
  $(".se").attr("class", "form-line se focused");
  $(".est").attr("class", "form-line est focused");
  $(".obs").attr("class", "form-line obs focused");
};

const seleccionColor = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulColor").html();
  $("#listaColor").attr("style", "display: none;");
  $(".col").attr("class", "form-line col focused");
};

const getColor = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaColorPrenda.php",
    data: {
      col_descripcion: $("#col_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionColor(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.col_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulColor").html(fila);
      //hacemos visible la lista
      $("#listaColor").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionSexo = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulSexo").html();
  $("#listaSexo").attr("style", "display: none;");
  $(".se").attr("class", "form-line se focused");
};

const getSexo = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "GET",
    url: "/sys8DD/others/complements_php/listas/listaSexo.php",
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionSexo(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.sexo +
          "</li>";
      });

      //cargamos la lista
      $("#ulSexo").html(fila);
      //hacemos visible la lista
      $("#listaSexo").attr(
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

const limpiarObservacion = () => {
  $("#mod_observacion").val("");
};

listar();
