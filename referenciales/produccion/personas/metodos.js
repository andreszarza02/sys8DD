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
    $("#per_codigo").val(respuesta.per_codigo);
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
        tabla += objeto.per_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.persona;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.per_numerodocumento;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipdo_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.per_telefono;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.per_email;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.per_estado;
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
  $("#personas").attr("style", "display: none");
  $(".activar").attr("class", "form-line activar focused");
  getCodigo();
  $(".est").attr("class", "form-line est focused");
  $(".foco").attr("class", "form-line foco");
  $(".td").attr("class", "form-line td");
  $("#per_estado").val("ACTIVO");
  $("#per_nombre").val("");
  $("#per_apellido").val("");
  $("#tipdo_codigo").val(0);
  $("#tipdo_descripcion").val("");
  $("#per_numerodocumento").val("");
  $("#per_telefono").val("");
  $("#per_email").val("");
  habilitarBotones(false);
};

const modificar = () => {
  $("#operacion").val(2);
  $("#procedimiento").val("MODIFICACION");
  $("#per_estado").val("ACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarCampos();
  habilitarBotones(false);
};

const borrar = () => {
  $("#operacion").val(3);
  $("#procedimiento").val("BAJA");
  $("#per_estado").val("INACTIVO");
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
      per_codigo: $("#per_codigo").val(),
      per_nombre: $("#per_nombre").val(),
      per_apellido: $("#per_apellido").val(),
      per_numerodocumento: $("#per_numerodocumento").val(),
      per_telefono: $("#per_telefono").val(),
      per_email: $("#per_email").val(),
      per_estado: $("#per_estado").val(),
      tipdo_codigo: $("#tipdo_codigo").val(),
      operacion: $("#operacion").val(),
      usu_codigo: $("#usu_codigo").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
      tipdo_descripcion: $("#tipdo_descripcion").val(),
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

  if ($("#per_codigo").val() == "") {
    condicion = true;
  } else if ($("#per_nombre").val() == "") {
    condicion = true;
  } else if ($("#per_apellido").val() == "") {
    condicion = true;
  } else if ($("#per_numerodocumento").val() == "") {
    condicion = true;
  } else if ($("#per_telefono").val() == "") {
    condicion = true;
  } else if ($("#per_email").val() == "") {
    condicion = true;
  } else if ($("#per_estado").val() == "") {
    condicion = true;
  } else if ($("#tipdo_descripcion").val() == "") {
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
  $(".td").attr("class", "form-line td focused");
  $(".est").attr("class", "form-line est focused");
};

const seleccionTipoDocumento = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTD").html();
  $("#listaTD").attr("style", "display: none;");
  $(".td").attr("class", "form-line td focused");
};

const getTipoDocumento = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaTipoDocumento.php",
    data: {
      tipdo_descripcion: $("#tipdo_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionTipoDocumento(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.tipdo_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulTD").html(fila);
      //hacemos visible la lista
      $("#listaTD").attr(
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

const callPedido = () => {
  window.location = "/sys8DD/modulos/venta/pedido_venta/index.php";
};

listar();
