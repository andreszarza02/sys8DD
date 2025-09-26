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

// Habilita el formualrio para cargar los filtros de compra
const habilitacionInterfaz = (codigo_interfaz) => {
  if (codigo_interfaz == 1) {
    $(".presupuesto_compra").attr("style", "display: block;");
    $(".libro_compra").attr("style", "display: none;");
    $(".cuentas_pagar").attr("style", "display: none;");
  } else if (codigo_interfaz == 2) {
    $(".libro_compra").attr("style", "display: block;");
    $(".presupuesto_compra").attr("style", "display: none;");
    $(".cuentas_pagar").attr("style", "display: none;");
  } else {
    $(".cuentas_pagar").attr("style", "display: block;");
    $(".presupuesto_compra").attr("style", "display: none;");
    $(".libro_compra").attr("style", "display: none;");
  }
  // En todas las opciones mostramos los botones
  $("#botones").attr("style", "display: block;");
};

// Se encarga de enviarte al menu principal
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

// Limpia los campos
const limpiarCampos = () => {
  window.location.reload();
};

// Genera el reporte de presupuesto proveedor
const presupuestoProveedor = (parametro1, parametro2) => {
  window.location =
    "reporte/reporte_presupuesto_proveedor.php?desde=" +
    desde +
    "&hasta=" +
    hasta;
  $("#tablas").val("");
};

// Genera el reporte de libro compra
const libroCompra = () => {
  // Capturamos los valores
  const desde = document.getElementById("desdeLibro").value;
  const hasta = document.getElementById("hastaLibro").value;
  const proveedor = document.getElementById("pro_codigo").value;
  const tipoComprobante = document.getElementById("tipco_codigo").value;

  // Armamos la URL dinámicamente
  let url = `reporte/reporte_libro_compra.php?desde=${encodeURIComponent(
    desde
  )}&hasta=${encodeURIComponent(hasta)}`;

  // Solo agregamos los parametros opcionales si no están vacíos
  if (proveedor) {
    url += `&proveedor=${encodeURIComponent(proveedor)}`;
  }
  if (tipoComprobante) {
    url += `&tipo=${encodeURIComponent(tipoComprobante)}`;
  }

  // Redirigimos
  window.location = url;
};

// Genera el reporte de cuenta pagar
const cuentaPagar = (desde, hasta) => {
  window.location =
    "reporte/reporte_cuenta_pagar.php?desde=" + desde + "&hasta=" + hasta;
  $("#tablas").val("");
};

// Genera reporte de compra en base a lo solicitado
const imprimir = () => {
  if ($("#codigo_informe").val() == 1) {
    presupuestoProveedor(desde, hasta);
  } else if ($("#codigo_informe").val() == 2) {
    libroCompra();
  } else if ($("#codigo_informe").val() == 3) {
    cuentaPagar(desde, hasta);
  }

  $("#desde").val("");
  $("#hasta").val("");
};

// Controla que los inputs se completen con todos los datos necesarios
const controlVacio = () => {
  let condicion;
  let mensaje;

  // Control presupuesto proveedor
  if ($("#codigo_informe").val() == 1) {
    if ($("#pedco_codigo").val() == "") {
      condicion = true;
      mensaje =
        "El parametro numero pedido, en el informe de presupuesto proveedor es obligatorio";
    }
  }

  // Control Libro Compra
  if ($("#codigo_informe").val() == 2) {
    if ($("#desdeLibro").val() == "") {
      condicion = true;
      mensaje =
        "Los parametros desde y hasta, en el informe de libro de compras son obligatorios";
    } else if ($("#hastaLibro").val() == "") {
      condicion = true;
      mensaje =
        "Los parametros desde y hasta, en el informe de libro de compras son obligatorios";
    }
  }

  // Control Cuenta Pagar
  if ($("#codigo_informe").val() == 3) {
    if ($("#desdeCuenta").val() == "") {
      condicion = true;
      mensaje =
        "Los parametros desde y hasta, en el informe de cuenta a pagar son obligatorios";
    } else if ($("#hastaCuenta").val() == "") {
      condicion = true;
      mensaje =
        "Los parametros desde y hasta, en el informe de cuenta a pagar son obligatorios";
    }
  }

  // En base a la condicion mostramos el mensaje o imprimimos
  if (condicion) {
    swal({
      title: "VALIDACION DE CAMPOS",
      text: mensaje.toUpperCase(),
      type: "error",
    });
  } else {
    imprimir();
  }
};

// Envia datos a su respectivo input y oculta la lista
const seleccionTablas = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTablas").html();
  $("#listaTablas").attr("style", "display: none;");
  $(".t").attr("class", "form-line t focused");

  // Mostramos el formulario segun la interfaz seleccionada
  habilitacionInterfaz($("#codigo_informe").val());
};

// Consulta las tablas de movimientos compras
const getTablas = () => {
  $.ajax({
    //Solicitamos los datos a listaMovimientosCompras
    method: "GET",
    url: "/sys8DD/others/complements_php/listasModulos/listaMovimientosCompras.php",
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

validacionInputsVacios1();
