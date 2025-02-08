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

//Permite aplicar un formato de tabla a la lista de etapa produccion
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

//Permite visualizar el boton de finalizar etapa en caso de que el estado del producto sea activo
const mostrarBoton = () => {
  //Definimos la variable
  let estadoProducto = $("#prodet_estado").val();
  //Validamos el estado
  if (estadoProducto == "ACTIVO") {
    $(".finalizar").removeAttr("style");
  } else {
    $(".finalizar").attr("style", "display: none;");
  }
};

const finalizarEtapaProduccion = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      prod_codigo: $("#prod_codigo").val(),
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      emp_razonsocial: $("#emp_razonsocial").val(),
      suc_codigo: $("#suc_codigo").val(),
      suc_descripcion: $("#suc_descripcion").val(),
      usu_codigo: $("#usu_codigo").val(),
      usu_login: $("#usu_login").val(),
      consulta: 1,
    },
  }).done(function (respuesta) {
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
  });
};

//Consulta y lista los registros de etapa produccion
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
        tabla += objeto.secc_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.item;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tall_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipet_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.maq_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.etpro_fecha;
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
        tabla += objeto.prodet_estado;
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

//Habilita botones en el formularo
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

//Metodo que establece el alta en el formulario
const nuevo = () => {
  $("#operacion").val(1);
  habilitarCampos(true);
  $(".fecha").attr("class", "form-line fecha focused");
  $(".pro").attr("class", "form-line pro");
  $(".it").attr("class", "form-line it");
  $(".tip").attr("class", "form-line tip");
  $(".maq").attr("class", "form-line maq");
  $("#etpro_fecha").val(getDate());
  $("#secc_descripcion").val("");
  $("#prod_codigo").val("");
  $("#it_codigo").val(0);
  $("#tipit_codigo").val(0);
  $("#item").val("");
  $("#tall_descripcion").val("");
  $("#tipet_codigo").val(0);
  $("#tipet_descripcion").val("");
  $("#maq_codigo").val(0);
  $("#maq_descripcion").val("");
  actualizacionCabecera();
  habilitarBotones(false);
  $("#cabecera").attr("style", "display: none");
};

//Metodo que establece la baja en el formulario
const eliminar = () => {
  $("#operacion").val(2);
  habilitarBotones(false);
};

//Metodo que establece la finalizacion de la etapa de produccion en el formulario
const finalizar = () => {
  $("#operacion").val(3);
  habilitarBotones(false);
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload(true);
};

//Pasa parametros en el controlador para guardarlos en etapa produccion
const grabar = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      prod_codigo: $("#prod_codigo").val(),
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      tipet_codigo: $("#tipet_codigo").val(),
      etpro_fecha: $("#etpro_fecha").val(),
      usu_codigo: $("#usu_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      maq_codigo: $("#maq_codigo").val(),
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

//Establece los mensajes pára agregar y eliminar un registro
const confirmar = () => {
  //solicitamos el value del input operacion_cabecera
  var oper = $("#operacion").val();

  preg = "¿Desea agregar el registro?";

  if (oper == 2) {
    preg = "¿Desea eliminar el registro?";
  }

  if (oper == 3) {
    preg = "¿Desea finalizar la etapa de produccion del producto seleccionado?";
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
        if (oper == 3) {
          finalizarEtapaProduccion();
        } else {
          grabar();
        }
      } else {
        //Si cancelamos la operacion_cabecera realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

//Controla que todos los inputs del formulario no se pasen con valores vacios
const controlVacio = () => {
  let condicion;

  if ($("#etpro_fecha").val() == "") {
    condicion = true;
  } else if ($("#secc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#prod_codigo").val() == "") {
    condicion = true;
  } else if ($("#item").val() == "") {
    condicion = true;
  } else if ($("#tall_descripcion").val() == "") {
    condicion = true;
  } else if ($("#tipet_descripcion").val() == "") {
    condicion = true;
  } else if ($("#maq_descripcion").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
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
    confirmar();
  }
};

//Envia a los inputs del formulario los seleccionado en la tabla
const seleccionarFila = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });
  $(".fecha").attr("class", "form-line fecha focused");
  $(".pro").attr("class", "form-line pro focused");
  $(".it").attr("class", "form-line it focused");
  $(".tip").attr("class", "form-line tip focused");
  $(".maq").attr("class", "form-line maq focused");
  $(".foco").attr("class", "form-line foco focused");
  actualizacionCabecera();
  mostrarBoton();
};

//Envia a los input de produccion lo seleccionado en el autocompletado
const seleccionProduccion = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulProduccion").html();
  $("#listaProduccion").attr("style", "display: none;");
  $(".pro").attr("class", "form-line pro focused");
  getItem();
};

//Busca, filtra y muestra las producciones registradas
const getProduccion = () => {
  $.ajax({
    //Solicitamos los datos a listaProduccion
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaProduccion.php",
    data: {
      suc_codigo: $("#suc_codigo").val(),
      secc_descripcion: $("#secc_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionProduccion(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.produccion +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulProduccion").html(fila);
      //hacemos visible la lista
      $("#listaProduccion").attr(
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
    //Solicitamos los datos a listaItemsEtapaProduccion
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaItemsEtapaProduccion.php",
    data: {
      prod_codigo: $("#prod_codigo").val(),
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

//Envia a los input de tipo etapa produccion lo seleccionado en el autocompletado
const seleccionTipoEtapaProduccion = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulEtapa").html();
  $("#listaEtapa").attr("style", "display: none;");
  $(".tip").attr("class", "form-line tip focused");
};

//Busca, filtra y muestra los tipo de etapa prouccion
const getTipoEtapaProduccion = () => {
  $.ajax({
    //Solicitamos los datos a listaTipoEtapaProduccion
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaTipoEtapaProduccion.php",
    data: {
      tipet_descripcion: $("#tipet_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionTipoEtapaProduccion(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.tipet_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulEtapa").html(fila);
      //hacemos visible la lista
      $("#listaEtapa").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a los input de maquinaria lo seleccionado en el autocompletado
const seleccionMaquinaria = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulMaquinaria").html();
  $("#listaMaquinaria").attr("style", "display: none;");
  $(".maq").attr("class", "form-line maq focused");
};

//Busca, filtra y muestra las maquinarias
const getMaquinaria = () => {
  $.ajax({
    //Solicitamos los datos a listaMaquinaria
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaMaquinaria.php",
    data: {
      maq_descripcion: $("#maq_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionMaquinaria(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.maq_descripcion +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulMaquinaria").html(fila);
      //hacemos visible la lista
      $("#listaMaquinaria").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia al usuario al menu
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

listar();
