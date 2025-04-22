//Aplica un formato de tabla a la grilla de cabecera
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

//Consulta y establece el codigo para el nuevo registro
const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta: 1,
    },
  }).done(function (respuesta) {
    $("#configsuc_codigo").val(respuesta.configsuc_codigo);
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
        tabla += objeto.emp_razonsocial;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.suc_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.config_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.config_validacion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.configsuc_estado;
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

//Habilita botones
const habilitarBotones = (booleano) => {
  if (booleano) {
    $(".botonesExtra1").attr("style", "display: block;");
    $(".botonesExtra2").attr("style", "display: none;");
  } else {
    $(".botonesExtra2").attr("style", "display: block;");
    $(".botonesExtra1").attr("style", "display: none;");
  }
};

//Saca el disabled de los inputs
const habilitarCampos = () => {
  $(".no-disabled").removeAttr("disabled");
};

//Metodo que establece el alta de la referencial
const agregar = () => {
  $("#operacion").val(1);
  $("#procedimiento").val("ALTA");
  habilitarCampos();
  getCodigo();
  $("#suc_descripcion").val("");
  $("#config_descripcion").val("");
  $("#config_validacion").val("");
  $(".est").attr("class", "form-line est focused");
  $("#configsuc_estado").val("ACTIVO");
  habilitarBotones(false);
  $(".suc").attr("class", "form-line suc");
  $(".conf").attr("class", "form-line conf");
  $("#configuracionesSucursal").attr("style", "display: none");
};

//Metodo que establece la modificacion de la referencial
const modificar = () => {
  $("#operacion").val(2);
  $("#procedimiento").val("MODIFICACION");
  $("#configsuc_estado").val("ACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarCampos();
  habilitarBotones(false);
};

//Metodo que establece la baja de la referencial
const borrar = () => {
  $("#operacion").val(3);
  $("#procedimiento").val("BAJA");
  $("#configsuc_estado").val("INACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload(true);
};

//Pasa parametros en el controlador para insertar, modifificar o dar de baja un registro
const abm = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      configsuc_codigo: $("#configsuc_codigo").val(),
      config_codigo: $("#config_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      configsuc_estado: $("#configsuc_estado").val(),
      operacion: $("#operacion").val(),
      usu_codigo: $("#usu_codigo").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
      config_validacion: $("#config_validacion").val(),
      config_descripcion: $("#config_descripcion").val(),
      suc_descripcion: $("#suc_descripcion").val(),
      emp_razonsocial: $("#emp_razonsocial").val(),
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

//Establece los mensajes pára agregar, modificar o dar de baja un registro
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

//Controla que todos los inputs no se pasen con valores vacios
const controlVacio = () => {
  let condicion;

  if ($("#configsuc_codigo").val() == 0) {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#config_descripcion").val() == "") {
    condicion = true;
  } else if ($("#config_validacion").val() == "") {
    condicion = true;
  } else if ($("#configsuc_estado").val() == "") {
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

//Envia a los inputs del formulario los seleccionado en la grilla de la referencial
const seleccionarFila = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".suc").attr("class", "form-line suc focused");
  $(".conf").attr("class", "form-line conf focused");
  $(".est").attr("class", "form-line est focused");
};

//Envia a los input de sucursal lo seleccionado en el autocompletado
const seleccionSucursal = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulSucursal").html();
  $("#listaSucursal").attr("style", "display: none;");
  $(".suc").attr("class", "form-line suc focused");
};

//Busca, filtra y muestra las sucursales
const getSucursal = () => {
  $.ajax({
    //Solicitamos los datos a listaSucursal2
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaSucursal2.php",
    data: {
      emp_codigo: $("#emp_codigo").val(),
      suc_descripcion: $("#suc_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionSucursal(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.suc_descripcion +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulSucursal").html(fila);
      //hacemos visible la lista
      $("#listaSucursal").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a los input de configuracion lo seleccionado en el autocompletado
const seleccionConfiguracion = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulConfiguracion").html();
  $("#listaConfiguracion").attr("style", "display: none;");
  $(".conf").attr("class", "form-line conf focused");
};

//Busca, filtra y muestra las configuraciones
const getConfiguracion = () => {
  $.ajax({
    //Solicitamos los datos a listaConfiguracion
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaConfiguracion.php",
    data: {
      config_descripcion: $("#config_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionConfiguracion(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.config_descripcion +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulConfiguracion").html(fila);
      //hacemos visible la lista
      $("#listaConfiguracion").attr(
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

//Siempre que se cargue la pagina se ejecutaran estas funciones
listar();
