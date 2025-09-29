/* Solicitud Presupuesto */

//Controla que los inputs no se queden vacios al perder el foco y que solo contengan numeros
const validacionInputsVacios3 = () => {
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

//Controla que los inputs no se queden vacios al perder el foco y que solo contengan letras, numeros y el simbolo -
const validacionInputsVacios4 = () => {
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
        const tieneSimbolo = /[¨!°¬@#$%^&*()_~+\=\[\]{};':"\\|,.<>\/?]/;

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
          // Si no está vacío, comprobamos si tiene simbolos distintos a -
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene simbolos distintos a -
          if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} solo acepta letras, números y el simbolo guion(-)`;
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

// Envia la solicitud por correo al proveedor
const enviarSolicitud = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "/sys8DD/others/complements_php/correo/correo_envio_solicitud_presupuesto.php",
    data: {
      solpre_codigo: $("#solpre_codigo").val(),
    },
  }) //Establecemos un mensaje segun el contenido de la respuesta
    .done(function (respuesta) {
      swal({
        title: "RESPUESTA!!",
        text: respuesta.mensaje,
        type: respuesta.tipo,
      });
    });
};

//Consulta  y establece el codigo de solicitud presupuesto cabecera
const getCodigo2 = () => {
  $.ajax({
    method: "POST",
    url: "controlador2.php",
    data: {
      consulta2: 1,
    },
  }).done(function (respuesta) {
    $("#solpre_codigo").val(respuesta.solpre_codigo);
  });
};

//Consulta y lista los datos en solicitud presupuesto cabecera
const listar2 = () => {
  $.ajax({
    //solicitamos los datos al controlador
    method: "GET",
    url: "controlador2.php",
  })
    .done(function (respuesta) {
      //individualizamos el array de objetos y lo separamos por filas
      let tabla = "";
      for (objeto of respuesta) {
        tabla +=
          "<tr onclick='seleccionarFila3(" +
          JSON.stringify(objeto).replace(/'/g, "&#39;") +
          ")'>";
        tabla += "<td>";
        tabla += objeto.solpre_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.solpre_fecha;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pedco_codigo2;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pro_razonsocial;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.solpre_correo_proveedor;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.usu_login2;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.suc_descripcion2;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.emp_razonsocial2;
        tabla += "</td>";
        tabla += "</tr>";
      }
      //establecemos el body y el formato de la tabla
      $("#tabla_cuerpo2").html(tabla);
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Consulta y lista los datos en solicitud presupuesto detalle
const listarDetalle2 = () => {
  $.ajax({
    //solicitamos los datos al controladorDetalle
    method: "POST",
    url: "controlador2.php",
    data: {
      solpre_codigo: $("#solpre_codigo").val(),
      consulta3: 1,
    },
  })
    .done(function (respuesta) {
      //individualizamos el array de objetos y lo separamos por filas
      let tabla = "";
      for (objeto of respuesta) {
        tabla +=
          "<tr onclick='seleccionarFila4(" +
          JSON.stringify(objeto).replace(/'/g, "&#39;") +
          ")'>";
        tabla += "<td>";
        tabla += objeto.it_descripcion2;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipit_descripcion2;
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(
          objeto.solpredet_cantidad
        );
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.unime_descripcion2;
        tabla += "</td>";
        tabla += "</tr>";
      }

      //establecemos el body y el foot
      $("#tabla_detalle2").html(tabla);
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Habilita botones en cabecera2
const habilitarBotones3 = (booleano) => {
  if (booleano) {
    $(".botonesExtra5").attr("style", "display: block;");
    $(".botonesExtra6").attr("style", "display: none;");
  } else {
    $(".botonesExtra6").attr("style", "display: block;");
    $(".botonesExtra5").attr("style", "display: none;");
  }
};

//Habilita botones en detalle2
const habilitarBotones4 = (booleano) => {
  if (booleano) {
    $(".botonesExtra7").attr("style", "display: block;");
    $(".botonesExtra8").attr("style", "display: none;");
  } else {
    $(".botonesExtra8").attr("style", "display: block;");
    $(".botonesExtra7").attr("style", "display: none;");
  }
};

//Saca el disabled de los inputs de cabecera2
const habilitarCampos2 = (booleano) => {
  if (booleano) {
    $(".no-disabled3").removeAttr("disabled");
  } else {
    $(".no-disabled4").removeAttr("disabled");
  }
};

// Limpia campos de detalle2
const limpiarCamposDetalle2 = () => {
  $("#it_codigo2").val(0);
  $("#tipit_codigo2").val(0);
  $("#it_descripcion2").val("");
  $("#solpredet_cantidad").val("");
  $("#unime_codigo2").val(0);
  $("#unime_descripcion2").val("");
  $(".it2").attr("class", "form-line it2");
};

//Metodo que establece el alta de cabecera2
const nuevo2 = () => {
  $("#operacion_cabecera2").val(1);
  habilitarCampos2(true);
  $(".activar2").attr("class", "form-line activar2 focused");
  getCodigo2();
  $(".fecha2").attr("class", "form-line fecha2 focused");
  $("#solpre_fecha").val(getDate());
  $("#pedco_codigo2").val("");
  $("#pro_codigo").val(0);
  $("#tipro_codigo").val(0);
  $("#pro_razonsocial").val("");
  $("#solpre_correo_proveedor").val("");
  $(".pe").attr("class", "form-line pe");
  $(".pro").attr("class", "form-line pro");
  habilitarBotones3(false);
  $("#cabecera2").attr("style", "display: none");
  $("#detalle2").attr("style", "display: none");
  validacionInputsVacios3();
  validacionInputsVacios4();
};

//Metodo que establece el alta del detalle2
const nuevoDetalle2 = () => {
  $("#operacion_detalle2").val(1);
  limpiarCamposDetalle2();
  habilitarCampos2(false);
  habilitarBotones4(false);
  validacionInputsVacios1();
  validacionInputsVacios2();
};

//Metodo que establece la baja en solicitud presupuesto cabecera
const eliminar2 = () => {
  $("#operacion_cabecera2").val(2);
  habilitarBotones3(false);
};

//Metodo que establece la baja en solicitud presupuesto detalle
const eliminar3 = () => {
  $("#operacion_detalle2").val(2);
  habilitarBotones4(false);
};

//Pasa parametros en el controlador2 para guardarlos en solicitud presupuesto cabecera
const grabar2 = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador2.php",
    data: {
      solpre_codigo: $("#solpre_codigo").val(),
      solpre_fecha: $("#solpre_fecha").val(),
      pedco_codigo2: $("#pedco_codigo2").val(),
      pro_codigo: $("#pro_codigo").val(),
      tipro_codigo: $("#tipro_codigo").val(),
      solpre_correo_proveedor: $("#solpre_correo_proveedor").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
      operacion_cabecera2: $("#operacion_cabecera2").val(),
      consulta1: 1,
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
            if ($("#operacion_cabecera2").val() == "2") {
              limpiarCampos();
            } else {
              habilitarBotones3(true);
              listar2();
              $("#cabecera2").attr("style", "display: block");
              $("#detalle2").attr("style", "display: block;");
            }
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

//Pasa parametros en el controlador2 para guardarlos en solicitud presupuesto detalle
const grabarDetalle2 = () => {
  $.ajax({
    //Enviamos datos al controlador detalle
    method: "POST",
    url: "controlador2.php",
    data: {
      solpre_codigo: $("#solpre_codigo").val(),
      pedco_codigo2: $("#pedco_codigo2").val(),
      pro_codigo: $("#pro_codigo").val(),
      tipro_codigo: $("#tipro_codigo").val(),
      it_codigo2: $("#it_codigo2").val(),
      tipit_codigo2: $("#tipit_codigo2").val(),
      solpredet_cantidad: $("#solpredet_cantidad").val(),
      operacion_detalle2: $("#operacion_detalle2").val(),
      consulta4: 1,
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
            //limpiarCampos();
            habilitarBotones4(true);
            listarDetalle2();
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

//Controla que todos los inputs de solicitud presupuesto cabecera no se pasen con valores vacios
const controlVacio3 = () => {
  // Definimos el contenedor de objetos
  const campos = [];

  // Rellenamos el array campos con objetos, guardando el id y descripciond el label
  document
    .querySelectorAll(".cabecera-solicitud input[id]")
    .forEach((input) => {
      const label = input
        .closest("div.form-line")
        .querySelector("label.form-label");
      if (label) {
        campos.push({
          selector: `#${input.id}`,
          nombre: label.textContent.trim(),
        });
      }
    });

  // Filtramos los campos vacíos
  const vacios = campos.filter((campo) => $(campo.selector).val() === "");

  //Validamos si el array vacio tiene campos vacios
  if (vacios.length > 0) {
    // En caso de ser asi, guardamos los mismos en una variable y la mostramos por swal
    const nombresVacios = vacios.map((campo) => campo.nombre).join(", ");
    swal({
      title: "RESPUESTA!!",
      text: `COMPLETE LOS SIGUIENTES CAMPOS DE SOLICITUD PRESUPUESTO: ${nombresVacios.toUpperCase()}`,
      type: "error",
    });
  } else {
    confirmar3();
  }
};

//Controla que todos los inputs de solicitud presupuesto detalle no se pasen con valores vacios
const controlVacio4 = () => {
  // Definimos el contenedor de objetos
  const campos = [];

  // Rellenamos el array campos con objetos, guardando el id y descripciond el label
  document.querySelectorAll(".detalle-solicitud input[id]").forEach((input) => {
    const label = input
      .closest("div.form-line")
      .querySelector("label.form-label");
    if (label) {
      campos.push({
        selector: `#${input.id}`,
        nombre: label.textContent.trim(),
      });
    }
  });

  // Filtramos los campos vacíos
  const vacios = campos.filter((campo) => $(campo.selector).val() === "");

  //Validamos si el array vacio tiene campos vacios
  if (vacios.length > 0) {
    // En caso de ser asi, guardamos los mismos en una variable y la mostramos por swal
    const nombresVacios = vacios.map((campo) => campo.nombre).join(", ");
    swal({
      title: "RESPUESTA!!",
      text: `COMPLETE LOS SIGUIENTES CAMPOS DE DETALLE DE SOLICITUD PRESUPUESTO: ${nombresVacios.toUpperCase()}`,
      type: "error",
    });
  } else {
    confirmar4();
  }
};

//Establece los mensajes pára agregar y eliminar cabecera2
const confirmar3 = () => {
  //solicitamos el value del input operacion_cabecera
  var oper = $("#operacion_cabecera2").val();

  preg = "¿Desea agregar el registro?";

  if (oper == 2) {
    preg = "¿Desea eliminar el registro?";
  }

  swal(
    {
      title: "ATENCIÓN!!!",
      text: preg.toUpperCase(),
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
        grabar2();
      } else {
        //Si cancelamos la operacion_cabecera realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

//Establece los mensajes pára agregar y eliminar detalle2
const confirmar4 = () => {
  //solicitamos el value del input operacion_cabecera
  var oper = $("#operacion_detalle2").val();

  preg = "¿Desea agregar el registro?";

  if (oper == 2) {
    preg = "¿Desea eliminar el registro?";
  }

  swal(
    {
      title: "ATENCIÓN!!!",
      text: preg.toUpperCase(),
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
        grabarDetalle2();
      } else {
        //Si cancelamos la operacion_cabecera realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

//Envia a los input de proveedor lo seleccionado en el autocompletado de proveedor
const seleccionProveedor = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulProveedor").html();
  $("#listaProvedor").attr("style", "display: none;");
  $(".pro").attr("class", "form-line pro focused");
};

//Busca, filtra y muestra los proveedores
const getProveedor = () => {
  $.ajax({
    //Solicitamos los datos a listaProveedor
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaProveedor.php",
    data: {
      pro_razonsocial: $("#pro_razonsocial").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionProveedor(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.pro_razonsocial +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulProveedor").html(fila);
      //hacemos visible la lista
      $("#listaProvedor").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a los inputs de cabecera2 lo seleccionado en la tabla de cabecera2
const seleccionarFila3 = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".activar2").attr("class", "form-line activar2 focused");
  $(".fecha2").attr("class", "form-line fecha2 focused");
  $(".pe").attr("class", "form-line pe focused");
  $(".pro").attr("class", "form-line pro focused");
  $("#detalle2").attr("style", "display: block;");
  listarDetalle2();
  limpiarCamposDetalle2();
};

//Envia a los inputs de detalle2 lo seleccionado en la tabla de detalle2
const seleccionarFila4 = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".it2").attr("class", "form-line it2 focused");
};

//Envia a los input de pedido compra cabecera lo seleccionado en el autocompletado de pedido compra cabecera
const seleccionPedidoCompra = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulPedido").html();
  $("#listaPedido").attr("style", "display: none;");
  $(".pe").attr("class", "form-line pe focused");
};

//Busca, filtra y muestra los pedidos de compra cabecera
const getPedidoCompra = () => {
  $.ajax({
    //Solicitamos los datos a listaPedidoCompra
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaPedidoCompra2.php",
    data: {
      pedco_codigo2: $("#pedco_codigo2").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionPedidoCompra(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.pedido +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulPedido").html(fila);
      //hacemos visible la lista
      $("#listaPedido").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a los input de item2 lo seleccionado en el autocompletado de item
const seleccionItem2 = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulItem2").html();
  $("#listaItem2").attr("style", "display: none;");
  $(".it2").attr("class", "form-line it2 focused");
};

//Busca, filtra y muestra los items2
const getItem2 = () => {
  $.ajax({
    //Solicitamos los datos a listaItemsSolicitudPresupuesto
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaItemsSolicitudPresupuesto.php",
    data: {
      pedco_codigo2: $("#pedco_codigo2").val(),
      it_descripcion2: $("#it_descripcion2").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionItem2(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.it_descripcion2 +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulItem2").html(fila);
      //hacemos visible la lista
      $("#listaItem2").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

/* Pedido Compra */

//Controla que los inputs no se queden vacios al perder el foco y que no contengan simbolos
const validacionInputsVacios1 = () => {
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

//Controla que los inputs no se queden vacios al perder el foco y que no contengan letras o simbolos excepto la coma (,) y el punto (.)
const validacionInputsVacios2 = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase numeros-algunos-simbolos realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("numeros-algunos-simbolos")
      ) {
        //Definimos variables a utilizar
        let mensaje = "";
        const tieneMinuscula = /[a-z]/;
        const tieneMayuscula = /[A-Z]/;
        const tieneSimbolo = /[¨!°¬@#$^&*()_~+\-=\[\]{};':"\\|<>\/?]/;

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
          // Si no está vacío, comprobamos si contiene letras o simbolos distintos a , y .
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene letras o simbolos distintos a , y .
          if (
            tieneSimbolo.test(input.value) &&
            (tieneMayuscula.test(input.value) ||
              tieneMinuscula.test(input.value))
          ) {
            mensaje = `El campo ${labelText} contiene letras y símbolos distintos a punto(.) y coma(,)`;
          } else if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} contiene símbolos distintos a punto(.) y coma(,)`;
          } else if (
            tieneMayuscula.test(input.value) ||
            tieneMinuscula.test(input.value)
          ) {
            mensaje = `El campo ${labelText} contiene letras`;
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

// Valida si el pedido esta asociado a un presupuesto
const consultaAsociacion = (escenario, mensaje) => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      pedco_codigo: $("#pedco_codigo").val(),
      consulta: 2,
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (respuesta) {
      if (respuesta.validacion == "asociado") {
        swal(
          {
            title: "VALIDACION " + escenario.toUpperCase(),
            text: mensaje.toUpperCase(),
            type: "error",
            confirmButtonText: "OK",
          },
          function (isConfirm) {
            if (isConfirm) {
              window.location.reload(true);
            }
          }
        );
      }
    });
};

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

//Permite aplicar un formato de tabla a la lista de pedido compra cabecera
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

//Consulta  y establece el codigo de pedido compra en cabecera
const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta: 1,
    },
  }).done(function (respuesta) {
    $("#pedco_codigo").val(respuesta.pedco_codigo);
  });
};

//Consulta y lista los datos en pedido compra cabecera
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
        tabla += objeto.pedco_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.pedco_fecha;
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
        tabla += objeto.pedco_estado;
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

//Consulta y lista los datos en pedido compra detalle
const listarDetalle = () => {
  $.ajax({
    //solicitamos los datos al controladorDetalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      pedido: $("#pedco_codigo").val(),
    },
  })
    .done(function (respuesta) {
      //individualizamos el array de objetos y lo separamos por filas
      let tabla = "";
      let totalGral = 0;
      for (objeto of respuesta) {
        totalGral += parseFloat(objeto.subtotal);
        tabla +=
          "<tr onclick='seleccionarFila2(" +
          JSON.stringify(objeto).replace(/'/g, "&#39;") +
          ")'>";
        tabla += "<td>";
        tabla += objeto.it_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipit_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(
          objeto.pedcodet_cantidad
        );
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.unime_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += new Intl.NumberFormat("us-US").format(objeto.pedcodet_precio);
        tabla += "</td>";
        tabla += "</tr>";
      }

      //Mostramos los subtotales y totales
      let lineafoot;
      lineafoot += "<tr class='bg-blue'>";
      lineafoot += "<th colspan='5'>";
      lineafoot += "TOTAL GENERAL";
      lineafoot += "</th>";
      lineafoot += "<th>";
      lineafoot += new Intl.NumberFormat("us-US").format(totalGral.toFixed(2));
      lineafoot += "</th>";
      lineafoot += "</tr>";

      //establecemos el body
      $("#tabla_detalle").html(tabla);
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Habilita botones en cabecera
const habilitarBotones = (booleano) => {
  if (booleano) {
    $(".botonesExtra1").attr("style", "display: block;");
    $(".botonesExtra2").attr("style", "display: none;");
  } else {
    $(".botonesExtra2").attr("style", "display: block;");
    $(".botonesExtra1").attr("style", "display: none;");
  }
};

//Habilita botones en detalle
const habilitarBotones2 = (booleano) => {
  if (booleano) {
    $(".botonesExtra3").attr("style", "display: block;");
    $(".botonesExtra4").attr("style", "display: none;");
  } else {
    $(".botonesExtra4").attr("style", "display: block;");
    $(".botonesExtra3").attr("style", "display: none;");
  }
};

//Saca el disabled de los inputs de cabecera
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

// Limpia campos de detalle
const limpiarCamposDetalle = () => {
  $("#it_codigo").val(0);
  $("#tipit_codigo").val(0);
  $("#it_descripcion").val("");
  $("#pedcodet_cantidad").val("");
  $("#unime_codigo").val(0);
  $("#unime_descripcion").val("");
  $("#pedcodet_precio").val("");
  $(".it").attr("class", "form-line it");
  $(".foco2").attr("class", "form-line foco2");
};

//Metodo que establece el alta de cabecera
const nuevo = () => {
  $("#operacion_cabecera").val(1);
  $("#procedimiento").val("ALTA");
  habilitarCampos(true);
  $(".activar").attr("class", "form-line activar focused");
  getCodigo();
  $(".est").attr("class", "form-line est focused");
  $(".fecha").attr("class", "form-line fecha focused");
  $("#pedco_estado").val("PENDIENTE");
  $("#pedco_fecha").val(getDate());
  habilitarBotones(false);
  actualizacionCabecera();
  $("#cabecera").attr("style", "display: none");
  $("#detalle").attr("style", "display: none");
};

//Metodo que establece el alta del detalle
const nuevoDetalle = () => {
  $("#operacion_detalle").val(1);
  limpiarCamposDetalle();
  habilitarCampos(false);
  habilitarBotones2(false);
  validacionInputsVacios1();
  validacionInputsVacios2();
  consultaAsociacion(
    "Nuevo",
    "Este pedido ya está asociado a un presupuesto; no se pueden añadir más ítems."
  );
};

//Metodo que establece la baja en pedido compra cabecera
const anular = () => {
  $("#operacion_cabecera").val(2);
  $("#procedimiento").val("BAJA");
  $("#pedco_estado").val("ANULADO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

//Metodo que establece la baja en pedido compra detalle
const eliminar = () => {
  $("#operacion_detalle").val(2);
  habilitarBotones2(false);
  consultaAsociacion(
    "Eliminar",
    "Este pedido ya está asociado a un presupuesto; no se pueden eliminar ítems."
  );
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload(true);
};

//Pasa parametros en el controlador para guardarlos en pedido compra cabecera
const grabar = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      pedco_codigo: $("#pedco_codigo").val(),
      pedco_fecha: $("#pedco_fecha").val(),
      pedco_estado: $("#pedco_estado").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
      operacion_cabecera: $("#operacion_cabecera").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
      emp_razonsocial: $("#emp_razonsocial").val(),
      suc_descripcion: $("#suc_descripcion").val(),
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

//Pasa parametros en el controlador de detalle para guardarlos en pedido compra detalle
const grabarDetalle = () => {
  $.ajax({
    //Enviamos datos al controlador detalle
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      pedco_codigo: $("#pedco_codigo").val(),
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      pedcodet_cantidad: $("#pedcodet_cantidad").val(),
      pedcodet_precio: $("#pedcodet_precio").val(),
      operacion_detalle: $("#operacion_detalle").val(),
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
            habilitarBotones2(true);
            listarDetalle();
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

//Establece los mensajes pára agregar y anular cabecera
const confirmar = () => {
  //solicitamos el value del input operacion_cabecera
  var oper = $("#operacion_cabecera").val();

  preg = "¿Desea agregar el registro?";

  if (oper == 2) {
    preg = "¿Desea anular el registro?";
  }

  swal(
    {
      title: "ATENCIÓN!!!",
      text: preg.toUpperCase(),
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
        grabar();
      } else {
        //Si cancelamos la operacion_cabecera realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

//Establece los mensajes pára agregar y eliminar detalle
const confirmar2 = () => {
  //solicitamos el value del input operacion_detalle
  var oper = $("#operacion_detalle").val();

  preg = "¿Desea agregar el registro?";

  if (oper == 2) {
    preg = "¿Desea eliminar el registro?";
  }

  swal(
    {
      title: "ATENCIÓN!!!",
      text: preg.toUpperCase(),
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "SI",
      cancelButtonText: "NO",
      closeOnConfirm: false,
      closeOnCancel: false,
    },
    function (isConfirm) {
      //Si la operacion_detalle es correcta llamamos al metodo grabarDetalle
      if (isConfirm) {
        grabarDetalle();
      } else {
        //Si cancelamos la operacion realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

//Controla que todos los inputs de cabecera no se pasen con valores vacios
const controlVacio = () => {
  let condicion;

  if ($("#pedco_codigo").val() == "") {
    condicion = true;
  } else if ($("#pedco_fecha").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
    condicion = true;
  } else if ($("#pedco_estado").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "COMPLETE TODOS LOS CAMPOS DE CABECERA QUE ESTÉN EN BLANCO",
      type: "error",
    });
  } else {
    confirmar();
  }
};

//Controla que todos los inputs de detalle no se pasen con valores vacios
const controlVacio2 = () => {
  let condicion;

  if ($("#it_descripcion").val() == "") {
    condicion = true;
  } else if ($("#pedcodet_cantidad").val() == "") {
    condicion = true;
  } else if ($("#unime_descripcion").val() == "") {
    condicion = true;
  } else if ($("#pedcodet_precio").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "COMPLETE TODOS LOS CAMPOS DE DETALLE QUE ESTÉN EN BLANCO",
      type: "error",
    });
  } else {
    if (
      $("#tipit_codigo").val() == "3" &&
      $("#pedcodet_cantidad").val() !== "0"
    ) {
      swal({
        title: "RESPUESTA!!",
        text: "LA CANTIDAD, EN CASO DE SOLICITAR UN SERVICIO, ES CERO(0)",
        type: "error",
      });
    } else {
      confirmar2();
    }
  }
};

//Envia a los inputs de cabecera los seleccionado en la tabla de cabecera
const seleccionarFila = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".activar").attr("class", "form-line activar focused");
  $(".foco").attr("class", "form-line foco focused");
  $(".fecha").attr("class", "form-line fecha focused");
  $(".est").attr("class", "form-line est focused");
  $("#detalle").attr("style", "display: block;");
  actualizacionCabecera();
  listarDetalle();
  limpiarCamposDetalle();
};

//Envia a los inputs de detalle lo seleccionado en la tabla de detalle
const seleccionarFila2 = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".it").attr("class", "form-line it focused");
  $(".foco2").attr("class", "form-line foco2 focused");
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
  controlServicio();
};

//Busca, filtra y muestra los items
const getItem = () => {
  $.ajax({
    //Solicitamos los datos a listaItemsPedidoCompra
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaItemsPedidoCompra.php",
    data: {
      it_descripcion: $("#it_descripcion").val(),
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
            objeto.it_descripcion +
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

//Te envia al menu
const salir = () => {
  window.location = "/sys8DD/menu.php";
};

//En caso de que se seleccione un servicio en item, cantidad se establece con cero (0)
const controlServicio = () => {
  if ($("#tipit_codigo").val() == "3") {
    $("#pedcodet_cantidad").val("0");
    $(".foco2").attr("class", "form-line foco2 focused");
  } else {
    $("#pedcodet_cantidad").val("");
    $(".foco2").attr("class", "form-line foco2");
  }
};

listar();
listar2();
