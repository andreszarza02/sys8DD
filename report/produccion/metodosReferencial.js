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

const cargo = (desde, hasta) => {
  window.location =
    "reporte/reporte_cargo.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const talle = (desde, hasta) => {
  window.location =
    "reporte/reporte_talle.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const colorPrenda = (desde, hasta) => {
  window.location =
    "reporte/reporte_color_prenda.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const maquinaria = (desde, hasta) => {
  window.location =
    "reporte/reporte_maquinaria.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const tipoEtapaProduccion = (desde, hasta) => {
  window.location =
    "reporte/reporte_tipo_etapa_produccion.php?desde=" +
    desde +
    "&hasta=" +
    hasta;
  $("#tablas").val("");
};

const unidadesMedida = (desde, hasta) => {
  window.location =
    "reporte/reporte_unidad_medida.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const parametroControlCalidad = (desde, hasta) => {
  window.location =
    "reporte/reporte_parametro_control_calidad.php?desde=" +
    desde +
    "&hasta=" +
    hasta;
  $("#tablas").val("");
};

const costoServicio = (desde, hasta) => {
  window.location =
    "reporte/reporte_costo_servicio.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const seccion = (desde, hasta) => {
  window.location =
    "reporte/reporte_seccion.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const equipoTrabajo = (desde, hasta) => {
  window.location =
    "reporte/reporte_equipo_trabajo.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const personas = (desde, hasta) => {
  window.location =
    "reporte/reporte_personas.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const funcionario = (desde, hasta) => {
  window.location =
    "reporte/reporte_funcionario.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

const imprimir = () => {
  let tabla = document.getElementById("tablas").value;
  let desde = $("#desde").val();
  let hasta = $("#hasta").val();

  if (tabla == "CARGO") {
    cargo(desde, hasta);
  } else if (tabla == "TALLE") {
    talle(desde, hasta);
  } else if (tabla == "COLOR PRENDA") {
    colorPrenda(desde, hasta);
  } else if (tabla == "MAQUINARIA") {
    maquinaria(desde, hasta);
  } else if (tabla == "TIPO ETAPA PRODUCION") {
    tipoEtapaProduccion(desde, hasta);
  } else if (tabla == "UNIDAD MEDIDA") {
    unidadesMedida(desde, hasta);
  } else if (tabla == "PARAMETRO CONTROL CALIDAD") {
    parametroControlCalidad(desde, hasta);
  } else if (tabla == "COSTO SERVICIO") {
    costoServicio(desde, hasta);
  } else if (tabla == "SECCION") {
    seccion(desde, hasta);
  } else if (tabla == "EQUIPO TRABAJO") {
    equipoTrabajo(desde, hasta);
  } else if (tabla == "PERSONAS") {
    personas(desde, hasta);
  } else if (tabla == "FUNCIONARIO") {
    funcionario(desde, hasta);
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
};

const getTablas = () => {
  $.ajax({
    //Solicitamos los datos a listaReferencialesProduccion
    method: "GET",
    url: "/sys8DD/others/complements_php/listasModulos/listaReferencialesProduccion.php",
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
