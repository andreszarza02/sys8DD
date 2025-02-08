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
    $("#it_codigo").val(respuesta.it_codigo);
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
        tabla += objeto.it_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipit_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.it_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipim_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.it_costo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.it_precio;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.mod_codigomodelo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tall_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.unime_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.it_estado;
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
  $(".est").attr("class", "form-line est focused");
  $(".tipit").attr("class", "form-line tipit");
  $(".tipim").attr("class", "form-line tipim");
  $(".foco").attr("class", "form-line foco");
  $(".mod").attr("class", "form-line mod");
  $(".tall").attr("class", "form-line tall");
  $("#it_estado").val("ACTIVO");
  $("#tipit_codigo").val("");
  $("#tipit_descripcion").val("");
  $("#tipim_codigo").val("");
  $("#tipim_descripcion").val("");
  $("#it_descripcion").val("");
  $("#it_costo").val("");
  $("#it_precio").val("");
  $("#mod_codigo").val("");
  $("#mod_codigomodelo").val("");
  $("#tall_codigo").val("");
  $("#tall_descripcion").val("");
  habilitarBotones(false);
  $("#items").attr("style", "display: none");
};

const modificar = () => {
  $("#operacion").val(2);
  $("#procedimiento").val("MODIFICACION");
  $("#it_estado").val("ACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarCampos();
  habilitarBotones(false);
};

const borrar = () => {
  $("#operacion").val(3);
  $("#procedimiento").val("BAJA");
  $("#it_estado").val("INACTIVO");
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
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      it_descripcion: $("#it_descripcion").val(),
      it_costo: $("#it_costo").val(),
      it_precio: $("#it_precio").val(),
      it_estado: $("#it_estado").val(),
      mod_codigo: $("#mod_codigo").val(),
      tall_codigo: $("#tall_codigo").val(),
      tipim_codigo: $("#tipim_codigo").val(),
      unime_codigo: $("#unime_codigo").val(),
      operacion: $("#operacion").val(),
      usu_codigo: $("#usu_codigo").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
      tipit_descripcion: $("#tipit_descripcion").val(),
      tipim_descripcion: $("#tipim_descripcion").val(),
      mod_codigomodelo: $("#mod_codigomodelo").val(),
      tall_descripcion: $("#tall_descripcion").val(),
      unime_descripcion: $("#unime_descripcion").val(),
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

  if ($("#it_codigo").val() == 0) {
    condicion = true;
  } else if ($("#tipit_descripcion").val() == "") {
    condicion = true;
  } else if ($("#it_descripcion").val() == "") {
    condicion = true;
  } else if ($("#it_costo").val() == "") {
    condicion = true;
  } else if ($("#it_precio").val() == "") {
    condicion = true;
  } else if ($("#it_estado").val() == "") {
    condicion = true;
  } else if ($("#mod_codigomodelo").val() == "") {
    condicion = true;
  } else if ($("#tall_descripcion").val() == "") {
    condicion = true;
  } else if ($("#tipim_descripcion").val() == "") {
    condicion = true;
  } else if ($("#unime_descripcion").val() == "") {
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
  $(".tipit").attr("class", "form-line tipit focused");
  $(".tipim").attr("class", "form-line tipim focused");
  $(".foco").attr("class", "form-line foco focused");
  $(".mod").attr("class", "form-line mod focused");
  $(".tall").attr("class", "form-line tall focused");
  $(".unime").attr("class", "form-line unime focused");
  $(".est").attr("class", "form-line est focused");
};

const seleccionTipoItem = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTIt").html();
  $("#listaTIt").attr("style", "display: none;");
  $(".tipit").attr("class", "form-line tipit focused");
};

const getTipoItem = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaTipoItem.php",
    data: {
      tipit_descripcion: $("#tipit_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionTipoItem(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.tipit_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulTIt").html(fila);
      //hacemos visible la lista
      $("#listaTIt").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionTipoImpuesto = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTIm").html();
  $("#listaTIm").attr("style", "display: none;");
  $(".tipim").attr("class", "form-line tipim focused");
};

const getTipoImpuesto = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaTipoImpuesto.php",
    data: {
      tipim_descripcion: $("#tipim_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionTipoImpuesto(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.tipim_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulTIm").html(fila);
      //hacemos visible la lista
      $("#listaTIm").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionModelo = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulModelo").html();
  $("#listaModelo").attr("style", "display: none;");
  $(".mod").attr("class", "form-line mod focused");
};

const getModelo = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaModelo.php",
    data: {
      mod_codigomodelo: $("#mod_codigomodelo").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionModelo(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.mod_codigomodelo +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulModelo").html(fila);
      //hacemos visible la lista
      $("#listaModelo").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionTalle = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTalle").html();
  $("#listaTalle").attr("style", "display: none;");
  $(".tall").attr("class", "form-line tall focused");
};

const getTalle = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaTalle.php",
    data: {
      tall_descripcion: $("#tall_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionTalle(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.tall_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulTalle").html(fila);
      //hacemos visible la lista
      $("#listaTalle").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionUnidadMedida = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulUnidadMedida").html();
  $("#listaUnidadMedida").attr("style", "display: none;");
  $(".unime").attr("class", "form-line unime focused");
};

const getUnidadMedida = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaUnidadMedida.php",
    data: {
      unime_descripcion: $("#unime_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionUnidadMedida(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.unime_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulUnidadMedida").html(fila);
      //hacemos visible la lista
      $("#listaUnidadMedida").attr(
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

listar();
