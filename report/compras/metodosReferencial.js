//Controla que los inputs no se queden vacios al perder el foco y que no contengan numeros o simbolos
const validacionInputsVacios1 = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase solo-letras realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("solo-letras")
      ) {
        //Definimos variables a utilizar
        let mensaje = "";
        const tieneNumero = /[0-9]/;
        const tieneSimbolo = /[¨!°¬@#$%^&*()_~+\-=\[\]{};':"\\|,.<>\/?]/;

        // Comprobamos si el input esta vacio
        if (input.value.trim() === "") {
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");

          // Armamos el mensaje a mostrar
          const labelText = label ? label.textContent.trim() : "VACIO";
          mensaje = `El campo ${labelText} se encuentra vacío.`;
        } else {
          // Si no está vacío, comprobamos si contiene números o símbolos
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene números o símbolos
          if (tieneNumero.test(input.value) && tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} contiene números y símbolos`;
          } else if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} contiene símbolos`;
          } else if (tieneNumero.test(input.value)) {
            mensaje = `El campo ${labelText} contiene números`;
          }
        }

        // Si mensaje no está vacío, mostramos la alerta
        if (mensaje !== "") {
          swal({
            title: "VALIDACION DE CAMPO",
            text: mensaje.toUpperCase(),
            type: "info",
          });
          // Limpiamos el valor del input
          input.value = "";
        }
      }
    },
    true
  ); // usa true para captar el evento en la fase de captura y asegurar que blur funciona bien
};

//Controla que los inputs no se queden vacios al perder el foco y que solo contengan numeros
const validacionInputsVacios2 = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase solo-numeros realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("solo-numeros")
      ) {
        //Definimos variables a utilizar
        let mensaje = "";
        const tieneMinuscula = /[a-z]/;
        const tieneMayuscula = /[A-Z]/;
        const tieneSimbolo = /[¨!°¬@#$%^&*()_~+\-=\[\]{};':"\\|,.<>\/?]/;

        // Comprobamos si el input esta vacio
        if (input.value.trim() === "") {
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");

          // Armamos el mensaje a mostrar
          const labelText = label ? label.textContent.trim() : "VACIO";
          mensaje = `El campo ${labelText} se encuentra vacío.`;
        } else {
          // Si no está vacío, comprobamos si contiene letras o símbolos
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene números o símbolos
          if (
            tieneMayuscula.test(input.value) ||
            tieneMinuscula.test(input.value) ||
            tieneSimbolo.test(input.value)
          ) {
            mensaje = `El campo ${labelText} solo acepta valores numéricos, Ej: 123456...`;
          }
        }

        // Si mensaje no está vacío, mostramos la alerta
        if (mensaje !== "") {
          swal({
            title: "VALIDACION DE CAMPO",
            text: mensaje.toUpperCase(),
            type: "info",
          });
          // Limpiamos el valor del input
          input.value = "";
        }
      }
    },
    true
  ); // usa true para captar el evento en la fase de captura y asegurar que blur funciona bien
};

//Controla que los inputs no se queden vacios al perder el foco y que solo contengan letras, numeros y el simbolo .
const validacionInputsVacios3 = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase letras-numeros-algunos-simbolos realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("letras-numeros-algunos-simbolos")
      ) {
        //Definimos variables a utilizar
        let mensaje = "";
        const tieneSimbolo = /[¨!°¬@#$%^&*()_~+\-=\[\]{};':"\\|,<>\/?]/;

        // Comprobamos si el input esta vacio
        if (input.value.trim() === "") {
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");

          // Armamos el mensaje a mostrar
          const labelText = label ? label.textContent.trim() : "VACIO";
          mensaje = `El campo ${labelText} se encuentra vacío.`;
        } else {
          // Si no está vacío, comprobamos si tiene simbolos distintos a .
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene simbolos distintos a .
          if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} solo acepta letras, números y el simbolo punto(.)`;
          }
        }

        // Si mensaje no está vacío, mostramos la alerta
        if (mensaje !== "") {
          swal({
            title: "VALIDACION DE CAMPO",
            text: mensaje.toUpperCase(),
            type: "info",
          });
          // Limpiamos el valor del input
          input.value = "";
        }
      }
    },
    true
  ); // usa true para captar el evento en la fase de captura y asegurar que blur funciona bien
};

//Controla que los inputs no se queden vacios al perder el foco y que no contengan simbolos
const validacionInputsVacios4 = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase letras_numeros realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("letras_numeros")
      ) {
        //Definimos variables a utilizar
        let mensaje = "";
        const tieneSimbolo = /[¨!°¬@#$%^&*()_~+\-=\[\]{};':"\\|,.<>\/?]/;

        // Comprobamos si el input esta vacio
        if (input.value.trim() === "") {
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");

          // Armamos el mensaje a mostrar
          const labelText = label ? label.textContent.trim() : "VACIO";
          mensaje = `El campo ${labelText} se encuentra vacío.`;
        } else {
          // Si no está vacío, comprobamos si contiene símbolos
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene simbolos
          if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} contiene símbolos`;
          }
        }

        // Si mensaje no está vacío, mostramos la alerta
        if (mensaje !== "") {
          swal({
            title: "VALIDACION DE CAMPO",
            text: mensaje.toUpperCase(),
            type: "info",
          });
          // Limpiamos el valor del input
          input.value = "";
        }
      }
    },
    true
  ); // usa true para captar el evento en la fase de captura y asegurar que blur funciona bien
};

//Te envia al menu
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload();
};

// Se encarga de habilitar filtros
const habilitarFiltros = () => {
  if ($("#codigo_informe").val() == 1) {
    $("#div_tablas").attr("class", "col-sm-2");
    $(".filtro_item").attr("style", "display: none;");
    $(".filtro_sucursal").attr("style", "display: none;");
    $(".filtro_proveedor").attr("style", "display: block;");
  } else if ($("#codigo_informe").val() == 2) {
    $("#div_tablas").attr("class", "col-sm-2");
    $(".filtro_item").attr("style", "display: none;");
    $(".filtro_sucursal").attr("style", "display: block;");
    $(".filtro_proveedor").attr("style", "display: none;");
  } else if ($("#codigo_informe").val() == 3) {
    $("#div_tablas").attr("class", "col-sm-2");
    $(".filtro_item").attr("style", "display: block;");
    $(".filtro_sucursal").attr("style", "display: none;");
    $(".filtro_proveedor").attr("style", "display: none;");
  }
};

//Se encarga de generar el reporte de la referencial sucursal
const sucursal = () => {
  // Capturamos los valores
  const desde = document.getElementById("desdeSucursal").value;
  const hasta = document.getElementById("hastaSucursal").value;
  const ciudad = document.getElementById("ciu_codigo").value;
  const descripcion = document.getElementById("suc_descripcion").value;

  // Construimos los parámetros
  let params = [];

  // Regla 1: si se pasa desde y hasta
  if (desde && hasta) {
    params.push(`desde=${encodeURIComponent(desde)}`);
    params.push(`hasta=${encodeURIComponent(hasta)}`);
  }

  // Regla 2: si se pasa "hasta", entonces "desde" se fuerza a 1
  if (hasta && !desde) {
    params.push(`desde=1`);
    params.push(`hasta=${encodeURIComponent(hasta)}`);
  }

  // Regla 3: si se pasa "desde"
  if (!hasta && desde) {
    params.push(`desde=${encodeURIComponent(desde)}`);
  }

  // Regla 4: si no hay parametros → reporte general
  if (!desde && !hasta && !ciudad && !descripcion) {
    params.push(`general=1`);
  }

  // Regla 5: si se pasa ciudad
  if (ciudad) {
    params.push(`ciudad=${encodeURIComponent(ciudad)}`);
  }

  // Regla 5: si se pasa descripción (filtro por ilike)
  if (descripcion) {
    params.push(`descripcion=${encodeURIComponent(descripcion)}`);
  }

  // Armamos la URL final
  const url = `reporte/reporte_sucursal.php?${params.join("&")}`;

  // Redirigimos
  window.location = url;
};

//Se encarga de generar el reporte de la referencial proveedor
const proveedor = () => {
  // Capturamos los valores
  const desde = document.getElementById("desdeProveedor").value;
  const hasta = document.getElementById("hastaProveedor").value;
  const tipoProveedor = document.getElementById("tipro_codigo").value;
  const razonSocial = document.getElementById("pro_razonsocial").value;

  // Construimos los parámetros
  let params = [];

  // Regla 1: si se pasa desde y hasta
  if (desde && hasta) {
    params.push(`desde=${encodeURIComponent(desde)}`);
    params.push(`hasta=${encodeURIComponent(hasta)}`);
  }

  // Regla 2: si se pasa "hasta", entonces "desde" se fuerza a 1
  if (hasta && !desde) {
    params.push(`desde=1`);
    params.push(`hasta=${encodeURIComponent(hasta)}`);
  }

  // Regla 3: si se pasa "desde"
  if (!hasta && desde) {
    params.push(`desde=${encodeURIComponent(desde)}`);
  }

  // Regla 4: si no hay parametros → reporte general
  if (!desde && !hasta && !tipoProveedor && !razonSocial) {
    params.push(`general=1`);
  }

  // Regla 5: si se pasa tipoProveedor
  if (tipoProveedor) {
    params.push(`tipoProveedor=${encodeURIComponent(tipoProveedor)}`);
  }

  // Regla 5: si se pasa descripción (filtro por ilike)
  if (razonSocial) {
    params.push(`razonSocial=${encodeURIComponent(razonSocial)}`);
  }

  // Armamos la URL final
  const url = `reporte/reporte_proveedor.php?${params.join("&")}`;

  // Redirigimos
  window.location = url;
};

//Se encarga de generar el reporte de la referencial items
const items = () => {
  // Capturamos los valores
  const desde = document.getElementById("desdeItem").value;
  const hasta = document.getElementById("hastaItem").value;
  const tipoItem = document.getElementById("tipit_codigo").value;
  const descripcion = document.getElementById("it_descripcion").value;

  // Construimos los parámetros
  let params = [];

  // Regla 1: si se pasa desde y hasta
  if (desde && hasta) {
    params.push(`desde=${encodeURIComponent(desde)}`);
    params.push(`hasta=${encodeURIComponent(hasta)}`);
  }

  // Regla 2: si se pasa "hasta", entonces "desde" se fuerza a 1
  if (hasta && !desde) {
    params.push(`desde=1`);
    params.push(`hasta=${encodeURIComponent(hasta)}`);
  }

  // Regla 3: si se pasa "desde"
  if (!hasta && desde) {
    params.push(`desde=${encodeURIComponent(desde)}`);
  }

  // Regla 4: si no hay parametros → reporte general
  if (!desde && !hasta && !tipoItem && !descripcion) {
    params.push(`general=1`);
  }

  // Regla 5: si se pasa tipoItem
  if (tipoItem) {
    params.push(`tipoItem=${encodeURIComponent(tipoItem)}`);
  }

  // Regla 5: si se pasa descripción (filtro por ilike)
  if (descripcion) {
    params.push(`descripcion=${encodeURIComponent(descripcion)}`);
  }

  // Armamos la URL final
  const url = `reporte/reporte_items.php?${params.join("&")}`;

  // Redirigimos
  window.location = url;
};

//Se encarga de verificar que reporte se debe de generar
const imprimir = () => {
  if ($("#codigo_informe").val() == 1) {
    proveedor();
    $("#desdeProveedor").val("");
    $("#hastaProveedor").val("");
    $("#tipro_codigo").val("");
    $("#tipro_descripcion").val("");
    $("#pro_razonsocial").val("");
  } else if ($("#codigo_informe").val() == 2) {
    sucursal();
    $("#desdeSucursal").val("");
    $("#hastaSucursal").val("");
    $("#ciu_codigo").val("");
    $("#ciu_descripcion").val("");
    $("#suc_descripcion").val("");
  } else if ($("#codigo_informe").val() == 3) {
    items();
    $("#desdeItem").val("");
    $("#hastaItem").val("");
    $("#tipit_codigo").val("");
    $("#tipit_descripcion").val("");
    $("#it_descripcion").val("");
  }
};

//Controla que los inputs no se pasen con valores vacios
const controlVacio = () => {
  let condicion;

  if ($("#tablas").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "EL CAMPO DE REFERENCIAL SE ENCUENTRA VACIO, NO SE PUEDE GENERAR EL INFORME",
      type: "error",
    });
  } else {
    imprimir();
  }
};

//Envia al input de tablas lo seleccionado en el autocompletado
const seleccionTablas = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTablas").html();
  $("#listaTablas").attr("style", "display: none;");
  $(".t").attr("class", "form-line t focused");
  // Dependiendo de la tabla seleccionada habilitamos los filtros
  habilitarFiltros();
};

//Busca y muestra las referenciales de compras
const getTablas = () => {
  $.ajax({
    //Solicitamos los datos a listaReferencialesSeguridad
    method: "GET",
    url: "/sys8DD/others/complements_php/listasModulos/listaReferencialesCompras.php",
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
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a su respectivo input lo seleccionado por el usuario en la lista
const seleccionTipoItem = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTIt").html();
  $("#listaTIt").attr("style", "display: none;");
  $(".tipit").attr("class", "form-line tipit focused");
};

//Obtiene los datos del tipo de item y los muestra en una lista
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

//Envia a su respectivo input lo seleccionado por el usuario en la lista
const seleccionCiudad = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulCiudad").html();
  $("#listaCiudad").attr("style", "display: none;");
  $(".ciu").attr("class", "form-line ciu focused");
};

//Obtiene los datos de la ciudad y los muestra en una lista
const getCiudad = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaCiudad.php",
    data: {
      ciu_descripcion: $("#ciu_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionCiudad(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.ciu_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulCiudad").html(fila);
      //hacemos visible la lista
      $("#listaCiudad").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a su respectivo input lo seleccionado por el usuario en la lista
const seleccionTipoProveedor = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTP").html();
  $("#listaTP").attr("style", "display: none;");
  $(".tip").attr("class", "form-line tip focused");
};

//Obtiene los datos del tipo proveedor y los muestra en una lista
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

validacionInputsVacios1();
validacionInputsVacios2();
validacionInputsVacios3();
validacionInputsVacios4();
