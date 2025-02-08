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
    $("#pro_codigo").val(respuesta.pro_codigo);
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
        tabla += objeto.pro_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipro_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pro_razonsocial;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pro_ruc;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pro_timbrado;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pro_direccion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pro_telefono;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pro_email;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pro_estado;
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
  $(".tip").attr("class", "form-line tip");
  $(".foco").attr("class", "form-line foco");
  $("#pro_estado").val("ACTIVO");
  $("#tipro_codigo").val("");
  $("#tipro_descripcion").val("");
  $("#pro_razonsocial").val("");
  $("#pro_ruc").val("");
  $("#pro_direccion").val("");
  $("#pro_telefono").val("");
  $("#pro_email").val("");
  habilitarBotones(false);
  $("#proveedores").attr("style", "display: none");
};

const modificar = () => {
  $("#operacion").val(2);
  $("#procedimiento").val("MODIFICACION");
  $("#pro_estado").val("ACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarCampos();
  habilitarBotones(false);
};

const borrar = () => {
  $("#operacion").val(3);
  $("#procedimiento").val("BAJA");
  $("#pro_estado").val("INACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

const limpiarCampos = () => {
  window.location.reload(true);
};

const abm = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      pro_codigo: $("#pro_codigo").val(),
      tipro_codigo: $("#tipro_codigo").val(),
      pro_razonsocial: $("#pro_razonsocial").val(),
      pro_ruc: $("#pro_ruc").val(),
      pro_timbrado: $("#pro_timbrado").val(),
      pro_direccion: $("#pro_direccion").val(),
      pro_telefono: $("#pro_telefono").val(),
      pro_email: $("#pro_email").val(),
      pro_estado: $("#pro_estado").val(),
      operacion: $("#operacion").val(),
      usu_codigo: $("#usu_codigo").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
      tipro_descripcion: $("#tipro_descripcion").val(),
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

  if ($("#pro_codigo").val() == 0) {
    condicion = true;
  } else if ($("#tipro_descripcion").val() == "") {
    condicion = true;
  } else if ($("#pro_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#pro_ruc").val() == "") {
    condicion = true;
  } else if ($("#pro_timbrado").val() == "") {
    condicion = true;
  } else if ($("#pro_direccion").val() == "") {
    condicion = true;
  } else if ($("#pro_telefono").val() == "") {
    condicion = true;
  } else if ($("#pro_email").val() == "") {
    condicion = true;
  } else if ($("#pro_estado").val() == "") {
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
  $(".tip").attr("class", "form-line tip focused");
  $(".est").attr("class", "form-line est focused");
};

const seleccionTipoProveedor = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTP").html();
  $("#listaTP").attr("style", "display: none;");
  $(".tip").attr("class", "form-line tip focused");
};

const getTipoProveedor = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaTipoProveedor.php",
    data: {
      tipro_descripcion: $("#tipro_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionTipoProveedor(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.tipro_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulTP").html(fila);
      //hacemos visible la lista
      $("#listaTP").attr(
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
