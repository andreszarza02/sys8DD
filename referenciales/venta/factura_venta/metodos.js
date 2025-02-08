//Permite aplicar un formato de tabla a la lista de facturas de venta
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

//Consulta y lista los datos en la grilla de facturas de venta
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
        tabla += "<tr>";
        tabla += "<td>";
        tabla += objeto.emp_razonsocial;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.suc_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.caj_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.factura;
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

//Habilita botones en el formulario
const habilitarBotones = (booleano) => {
  if (booleano) {
    $(".botonesExtra1").attr("style", "display: block;");
    $(".botonesExtra2").attr("style", "display: none;");
  } else {
    $(".botonesExtra2").attr("style", "display: block;");
    $(".botonesExtra1").attr("style", "display: none;");
  }
};

//Habilita campos en el formulario
const habilitarCampos = () => {
  $(".no-disabled").removeAttr("disabled");
};

//Metodo que establece el alta en el formulario
const agregar = () => {
  $("#operacion").val(1);
  habilitarCampos();
  $(".emp").attr("class", "form-line emp focused");
  $(".suc").attr("class", "form-line suc");
  $(".caj").attr("class", "form-line caj");
  $(".foco").attr("class", "form-line foco focused");
  $("#facturas").attr("style", "display: none");
  $("#suc_codigo").val(0);
  $("#suc_descripcion").val("");
  $("#ulSucursal").html("");
  $("#caj_codigo").val(0);
  $("#caj_descripcion").val("");
  $("#facven_numero").val("0000000");
  habilitarBotones(false);
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload();
};

//Pasa parametros a el controlador para insertarlos
const abm = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      emp_codigo: $("#emp_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      caj_codigo: $("#caj_codigo").val(),
      facven_numero: $("#facven_numero").val(),
      operacion: $("#operacion").val(),
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

//Establece los mensajes para confirmar la accion al controlador
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

//Controla que no se pasen valores vacios al controlador
const controlVacio = () => {
  let condicion;

  if ($("#emp_codigo").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_codigo").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#caj_codigo").val() == "") {
    condicion = true;
  } else if ($("#caj_descripcion").val() == "") {
    condicion = true;
  } else if ($("#facven_numero").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
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

//Envia a los input de caja lo seleccionado en el autocompletado
const seleccionCaja = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulCaja").html();
  $("#listaCaja").attr("style", "display: none;");
  $(".caj").attr("class", "form-line caj focused");
};

//Busca, filtra y muestra la caja
const getCaja = () => {
  $.ajax({
    //Solicitamos los datos a listaCaja
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaCaja.php",
    data: {
      caj_descripcion: $("#caj_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionCaja(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.caj_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulCaja").html(fila);
      //hacemos visible la lista
      $("#listaCaja").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    });
};

//Te envia al menu
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

listar();
