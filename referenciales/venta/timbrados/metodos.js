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

//Controla que los inputs no se queden vacios al perder el foco y que solo contengan letras y numeros
const validacionInputsVacios2 = () => {
  // Agregamos un listener al evento blur a nivel de documento
  document.body.addEventListener(
    "blur",
    (event) => {
      // Capturamos el input que disparó el evento, mediante delegacion de eventos
      const input = event.target;

      //Si el input tiene la clase sletras-numeros realizamos las validaciones
      if (
        input.tagName === "INPUT" &&
        input.classList.contains("letras-numeros")
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
          // Si no está vacío, comprobamos si contiene letras o símbolos
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene números o símbolos
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

//Permite aplicar un formato de tabla a la lista de timbrados
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

//Consulta  y establece el codigo de la referencial
const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta: 1,
    },
  }).done(function (respuesta) {
    $("#timb_codigo").val(respuesta.timb_codigo);
  });
};

//Consulta y lista los datos en la grilla de timbrados
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
        tabla += objeto.timb_codigo;
        tabla += "</td>";
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
        tabla += objeto.tipco_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.timb_numero;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.timb_numero_fecha_inic;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.timb_numero_fecha_venc;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.comprobante;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.timb_numero_comp_inic;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.timb_numero_comp_lim;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.timb_estado;
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
  $(".activar").attr("class", "form-line activar focused");
  $(".emp").attr("class", "form-line emp focused");
  $(".suc").attr("class", "form-line suc");
  $(".caj").attr("class", "form-line caj");
  $(".tip").attr("class", "form-line tip");
  $(".foco").attr("class", "form-line foco");
  $(".foco2").attr("class", "form-line foco2 focused");
  $(".est").attr("class", "form-line est focused");
  $("#timb_codigo").val(getCodigo());
  $("#suc_codigo").val(0);
  $("#suc_descripcion").val("");
  $("#caj_codigo").val(0);
  $("#caj_descripcion").val("");
  $("#tipco_codigo").val(0);
  $("#tipco_descripcion").val("");
  $("#timb_numero").val("");
  $("#timb_numero_fecha_inic").val("");
  $("#timb_numero_fecha_venc").val("");
  $("#timb_numero_comp").val("0000000");
  $("#timb_numero_comp_inic").val("");
  $("#timb_numero_comp_lim").val("");
  $("#timb_estado").val("ACTIVO");
  $("#comprobantes").attr("style", "display: none");
  habilitarBotones(false);
  validacionInputsVacios1();
  validacionInputsVacios2();
  validacionInputsVacios3();
};

// Metodo que establece la modificacion
const modificar = () => {
  $("#operacion").val(2);
  $("#timb_estado").val("ACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarCampos();
  habilitarBotones(false);
};

// Metodo que establece la baja, en esta caso de manera logica
const borrar = () => {
  $("#operacion").val(3);
  $("#timb_estado").val("INACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

//Se encarga de limpiar campos
const limpiarCampos = () => {
  window.location.reload();
};

// Pasa parametros en el controlador para persistir los mismos
const abm = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      timb_codigo: $("#timb_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      caj_codigo: $("#caj_codigo").val(),
      tipco_codigo: $("#tipco_codigo").val(),
      timb_numero: $("#timb_numero").val(),
      timb_numero_fecha_inic: $("#timb_numero_fecha_inic").val(),
      timb_numero_fecha_venc: $("#timb_numero_fecha_venc").val(),
      timb_numero_comp: $("#timb_numero_comp").val(),
      timb_numero_comp_inic: $("#timb_numero_comp_inic").val(),
      timb_numero_comp_lim: $("#timb_numero_comp_lim").val(),
      timb_estado: $("#timb_estado").val(),
      usu_codigo: $("#usu_codigo").val(),
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

  if ($("#timb_codigo").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#caj_descripcion").val() == "") {
    condicion = true;
  } else if ($("#tipco_descripcion").val() == "") {
    condicion = true;
  } else if ($("#timb_numero").val() == "") {
    condicion = true;
  } else if ($("#timb_numero_fecha_inic").val() == "") {
    condicion = true;
  } else if ($("#timb_numero_fecha_venc").val() == "") {
    condicion = true;
  } else if ($("#timb_numero_comp").val() == "") {
    condicion = true;
  } else if ($("#timb_numero_comp_inic").val() == "") {
    condicion = true;
  } else if ($("#timb_numero_comp_lim").val() == "") {
    condicion = true;
  } else if ($("#timb_estado").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "CARGUE TODOS LOS CAMPOS EN BLANCO",
      type: "error",
    });
  } else {
    confirmar();
  }
};

//Envia a los inputs de la referencial lo seleccionado por el usuario en la grilla
const seleccionarFila = (objetoJSON) => {
  //Enviamos los datos a su respectivos inputs
  Object.keys(objetoJSON).forEach(function (propiedad) {
    $("#" + propiedad).val(objetoJSON[propiedad]);
  });

  $(".activar").attr("class", "form-line activar focused");
  $(".emp").attr("class", "form-line emp focused");
  $(".suc").attr("class", "form-line suc focused");
  $(".caj").attr("class", "form-line caj focused");
  $(".tip").attr("class", "form-line tip focused");
  $(".foco").attr("class", "form-line foco focused");
  $(".foco2").attr("class", "form-line foco2 focused");
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

//Envia a los input de tipo comprobante lo seleccionado en el autocompletado
const seleccionTipoComprobante = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTC").html();
  $("#listaTC").attr("style", "display: none;");
  $(".tip").attr("class", "form-line tip focused");
};

//Busca, filtra y muestra los tipos de comprobante
const getTipoComprobante = () => {
  $.ajax({
    //Solicitamos los datos a listaTipoComprobante
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaTipoComprobante2.php",
    data: {
      tipco_descripcion: $("#tipco_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionTipoComprobante(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.tipco_descripcion +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulTC").html(fila);
      //hacemos visible la lista
      $("#listaTC").attr(
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

listar();
