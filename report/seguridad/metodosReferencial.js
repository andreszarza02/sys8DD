const inputs = () => {
  let tabla = $("#tablas").val();
  if (tabla == "USUARIOS" || tabla == "ACCESO") {
    $("#desde").attr("type", "date");
    $("#hasta").attr("type", "date");
  } else {
    $("#desde").attr("type", "text");
    $("#hasta").attr("type", "text");
  }
};

const salir = () => {
  window.location = "/sys8DD/menu.php";
};

const limpiarCampos = () => {
  window.location.reload();
};

const modulo = (desde, hasta) => {
  window.location =
    "reporte/reporte_modulo.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const perfil = (desde, hasta) => {
  window.location =
    "reporte/reporte_perfil.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const permisos = (desde, hasta) => {
  window.location =
    "reporte/reporte_permisos.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const acceso = (desde, hasta) => {
  window.location =
    "reporte/reporte_acceso.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const gui = (desde, hasta) => {
  window.location =
    "reporte/reporte_gui.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const perfilGUI = (desde, hasta) => {
  window.location =
    "reporte/reporte_perfil_gui.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const perfilPermiso = (desde, hasta) => {
  window.location =
    "reporte/reporte_perfiles_permisos.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const usuario = (desde, hasta) => {
  window.location =
    "reporte/reporte_usuario.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const asignacion = (desde, hasta) => {
  window.location =
    "reporte/reporte_asignacion.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const imprimir = () => {
  let tabla = document.getElementById("tablas").value;
  let desde = $("#desde").val();
  let hasta = $("#hasta").val();

  if (tabla == "MODULOS") {
    modulo(desde, hasta);
  } else if (tabla == "PERFILES") {
    perfil(desde, hasta);
  } else if (tabla == "PERMISOS") {
    permisos(desde, hasta);
  } else if (tabla == "ACCESO") {
    acceso(desde, hasta);
  } else if (tabla == "GUI") {
    gui(desde, hasta);
  } else if (tabla == "PERFIL GUI") {
    perfilGUI(desde, hasta);
  } else if (tabla == "PERFIL PERMISOS") {
    perfilPermiso(desde, hasta);
  } else if (tabla == "USUARIOS") {
    usuario(desde, hasta);
  } else if (tabla == "ASIGNACIÓN DE PERMISOS") {
    asignacion(desde, hasta);
  }

  $("#desde").val("");
  $("#hasta").val("");
};

const controlVacio = () => {
  let condicion;

  if ($("#desde").val() == "") {
    condicion = true;
  } else if ($("#hasta").val() == "") {
    condicion = true;
  } else if ($("#tablas").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "Cargue todos los campos en blanco",
      type: "error",
    });
  } else {
    imprimir();
  }
};

const seleccionTablas = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTablas").html();
  $("#listaTablas").attr("style", "display: none;");
  $(".t").attr("class", "form-line t focused");

  inputs();
};

const getTablas = () => {
  $.ajax({
    //Solicitamos los datos a listaReferencialesSeguridad
    method: "GET",
    url: "/sys8DD/others/complements_php/listasModulos/listaReferencialesSeguridad.php",
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        fila +=
          "<li class='list-group-item' onclick='seleccionTablas(" +
          JSON.stringify(objeto) +
          ")'>" +
          objeto.tablas +
          "</li>";
      });

      //cargamos la lista
      $("#ulTablas").html(fila);
      //hacemos visible la lista
      $("#listaTablas").attr(
        "style",
        "display: block; position:absolute; z-index: 3000;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};
