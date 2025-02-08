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
    $("#asigperm_codigo").val(respuesta.asigperm_codigo);
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
        tabla += objeto.usu_login;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.perf_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.perm_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.asigperm_estado;
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
  $(".est").attr("class", "form-line est focused");
  $("#asignaciones").attr("style", "display: none");
  $("#ulPermiso").html("");
  $(".usu").attr("class", "form-line usu");
  $(".perf").attr("class", "form-line perf");
  $(".perm").attr("class", "form-line perm");
  getCodigo();
  $("#perfpe_codigo").val(0);
  $("#usu_codigo").val(0);
  $("#perf_codigo").val(0);
  $("#perm_codigo").val(0);
  $("#asigperm_estado").val("ACTIVO");
  $("#usu_login").val("");
  $("#perf_descripcion").val("");
  $("#perm_descripcion").val("");
  habilitarBotones(false);
};

const modificar = () => {
  $("#operacion").val(2);
  $("#procedimiento").val("MODIFICACION");
  $("#asigperm_estado").val("ACTIVO");
  $(".no-disabled2").removeAttr("disabled");
  $(".est").attr("class", "form-line est focused");
  habilitarCampos();
  habilitarBotones(false);
};

const borrar = () => {
  $("#operacion").val(3);
  $("#procedimiento").val("BAJA");
  $("#asigperm_estado").val("INACTIVO");
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
      asigperm_codigo: $("#asigperm_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
      perfpe_codigo: $("#perfpe_codigo").val(),
      perf_codigo: $("#perf_codigo").val(),
      perm_codigo: $("#perm_codigo").val(),
      asigperm_estado: $("#asigperm_estado").val(),
      operacion: $("#operacion").val(),
      usu_codigo_reg: $("#usu_codigo_reg").val(),
      usu_login_reg: $("#usu_login_reg").val(),
      procedimiento: $("#procedimiento").val(),
      usu_login: $("#usu_login").val(),
      perf_descripcion: $("#perf_descripcion").val(),
      perm_descripcion: $("#perm_descripcion").val(),
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

  if ($("#asigperm_codigo").val() == 0) {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
    condicion = true;
  } else if ($("#perf_descripcion").val() == "") {
    condicion = true;
  } else if ($("#perm_descripcion").val() == "") {
    condicion = true;
  } else if ($("#asigperm_estado").val() == "") {
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

  $(".usu").attr("class", "form-line usu focused");
  $(".perf").attr("class", "form-line perf focused");
  $(".perm").attr("class", "form-line perm focused");
  $(".est").attr("class", "form-line est focused");
  getPermisos(objetoJSON.perf_codigo);
};

const seleccionUsuario = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulUsuario").html();
  $("#listaUsuario").attr("style", "display: none;");
  $(".usu").attr("class", "form-line usu focused");
  $(".perf").attr("class", "form-line perf focused");
  getPermisos(datos.perf_codigo);
};

const getUsuario = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaUsuario.php",
    data: {
      usu_login: $("#usu_login").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionUsuario(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.usu_login +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulUsuario").html(fila);
      //hacemos visible la lista
      $("#listaUsuario").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const seleccionPermisos = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulPermiso").html();
  $("#listaPermiso").attr("style", "display: none;");
  $(".perm").attr("class", "form-line perm focused");
};

const getPermisos = (perfilCodigo) => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaPermisoPerfil.php",
    data: {
      perf_codigo: perfilCodigo,
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionPermisos(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.perm_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulPermiso").html(fila);
      //hacemos visible la lista
      $("#listaPermiso").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

const getPermisos2 = () => {
  let perfilCodigo = document.getElementById("perf_codigo").value;
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaPermisoPerfil.php",
    data: {
      perf_codigo: perfilCodigo,
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionPermisos(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.perm_descripcion +
          "</li>";
      });

      //cargamos la lista
      $("#ulPermiso").html(fila);
      //hacemos visible la lista
      $("#listaPermiso").attr(
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

listar();
