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

//Controla que los inputs no se queden vacios al perder el foco y que no contengan simbolos excepto %
const validacionInputsVacios2 = () => {
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
        const tieneSimbolo = /[¨!°¬@#$^&*()_~+\-=\[\]{};':"\\|,.<>\/?]/;

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
          // Si no está vacío, comprobamos si contiene simbolo distinto a %
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene simbolo distinto a %
          if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} solo acepta el simbolo %`;
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
const validacionInputsVacios3 = () => {
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

//Controla que los inputs no se queden vacios al perder el foco y que no contengan letras y simbolos que no sean . y ,
const validacionInputsVacios4 = () => {
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
          // Si no está vacío, comprobamos si contiene letras o simbolos distintos a . y ,
          // Obtenemos la clase padre del input y sacamos el valor del elemento label
          const label = input
            .closest(".form-line")
            ?.querySelector("label.form-label");
          const labelText = label ? label.textContent.trim() : "VACIO";

          // Verificamos si el input contiene letras o simbolos distintos a . y ,
          if (
            tieneSimbolo.test(input.value) &&
            (tieneMayuscula.test(input.value) ||
              tieneMinuscula.test(input.value))
          ) {
            mensaje = `El campo ${labelText} contiene letras y simbolos distintos a .(punto) y ,(coma)`;
          } else if (
            tieneMayuscula.test(input.value) ||
            tieneMinuscula.test(input.value)
          ) {
            mensaje = `El campo ${labelText} contiene letras`;
          } else if (tieneSimbolo.test(input.value)) {
            mensaje = `El campo ${labelText} contiene simbolos distintos a .(punto) y ,(coma)`;
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

//Permite aplicar un formato de tabla a la lista de la referencial
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

//Consulta y establece el codigo de la referencial
const getCodigo = () => {
  $.ajax({
    method: "POST",
    url: "controlador.php",
    data: {
      consulta: 1,
    },
  }).done(function (respuesta) {
    $("#it_codigo").val(respuesta.it_codigo);
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
        tabla += objeto.it_codigo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipit_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.it_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tipim_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.it_costo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.it_precio;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.mod_codigomodelo;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.tall_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.unime_descripcion;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.it_stock_min;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.it_stock_max;
        tabla += "</td>";
        tabla += "<td>";
        tabla += objeto.it_estado;
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

//Habilita botones de la referencial
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

//Metodo que establece el alta
const agregar = () => {
  $("#operacion").val(1);
  $("#procedimiento").val("ALTA");
  habilitarCampos();
  $(".activar").attr("class", "form-line activar focused");
  getCodigo();
  $(".est").attr("class", "form-line est focused");
  $(".tipit").attr("class", "form-line tipit");
  $(".tipim").attr("class", "form-line tipim");
  $(".foco").attr("class", "form-line foco");
  $(".mod").attr("class", "form-line mod");
  $(".tall").attr("class", "form-line tall");
  $("#it_estado").val("ACTIVO");
  $("#tipit_codigo").val("");
  $("#tipit_descripcion").val("");
  $("#tipim_codigo").val("");
  $("#tipim_descripcion").val("");
  $("#it_descripcion").val("");
  $("#it_costo").val("");
  $("#it_precio").val("");
  $("#mod_codigo").val("");
  $("#mod_codigomodelo").val("");
  $("#tall_codigo").val("");
  $("#tall_descripcion").val("");
  habilitarBotones(false);
  $("#items").attr("style", "display: none");
  validacionInputsVacios1();
  validacionInputsVacios2();
  validacionInputsVacios3();
  validacionInputsVacios4();
};

//Metodo que establece la modificacion
const modificar = () => {
  $("#operacion").val(2);
  $("#procedimiento").val("MODIFICACION");
  $("#it_estado").val("ACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarCampos();
  habilitarBotones(false);
  validacionInputsVacios1();
  validacionInputsVacios2();
  validacionInputsVacios3();
  validacionInputsVacios4();
};

//Metodo que establece la baja, en esta caso de manera logica
const borrar = () => {
  $("#operacion").val(3);
  $("#procedimiento").val("BAJA");
  $("#it_estado").val("INACTIVO");
  $(".est").attr("class", "form-line est focused");
  habilitarBotones(false);
};

//Limpia los campos del formulario
const limpiarCampos = () => {
  window.location.reload();
};

//Pasa parametros en el controlador para persistir los mismos
const abm = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      it_codigo: $("#it_codigo").val(),
      tipit_codigo: $("#tipit_codigo").val(),
      it_descripcion: $("#it_descripcion").val(),
      it_costo: $("#it_costo").val(),
      it_precio: $("#it_precio").val(),
      it_estado: $("#it_estado").val(),
      mod_codigo: $("#mod_codigo").val(),
      tall_codigo: $("#tall_codigo").val(),
      tipim_codigo: $("#tipim_codigo").val(),
      unime_codigo: $("#unime_codigo").val(),
      operacion: $("#operacion").val(),
      usu_codigo: $("#usu_codigo").val(),
      usu_login: $("#usu_login").val(),
      procedimiento: $("#procedimiento").val(),
      tipit_descripcion: $("#tipit_descripcion").val(),
      tipim_descripcion: $("#tipim_descripcion").val(),
      mod_codigomodelo: $("#mod_codigomodelo").val(),
      tall_descripcion: $("#tall_descripcion").val(),
      unime_descripcion: $("#unime_descripcion").val(),
      it_stock_min: $("#it_stock_min").val(),
      it_stock_max: $("#it_stock_max").val(),
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

// Establece los mensajes de confirmacion de las operaciones
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

//Controla que todos los inputs de la referencial no se pasen con valores vacios
const controlVacio = () => {
  let condicion;

  if ($("#it_codigo").val() == 0) {
    condicion = true;
  } else if ($("#tipit_descripcion").val() == "") {
    condicion = true;
  } else if ($("#it_descripcion").val() == "") {
    condicion = true;
  } else if ($("#it_costo").val() == "") {
    condicion = true;
  } else if ($("#it_precio").val() == "") {
    condicion = true;
  } else if ($("#it_estado").val() == "") {
    condicion = true;
  } else if ($("#mod_codigomodelo").val() == "") {
    condicion = true;
  } else if ($("#tall_descripcion").val() == "") {
    condicion = true;
  } else if ($("#tipim_descripcion").val() == "") {
    condicion = true;
  } else if ($("#unime_descripcion").val() == "") {
    condicion = true;
  } else if ($("#it_stock_min").val() == "") {
    condicion = true;
  } else if ($("#it_stock_max").val() == "") {
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
  $(".tipit").attr("class", "form-line tipit focused");
  $(".tipim").attr("class", "form-line tipim focused");
  $(".foco").attr("class", "form-line foco focused");
  $(".st").attr("class", "form-line st focused");
  $(".mod").attr("class", "form-line mod focused");
  $(".tall").attr("class", "form-line tall focused");
  $(".unime").attr("class", "form-line unime focused");
  $(".est").attr("class", "form-line est focused");
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

  if (datos.tipit_codigo == 3) {
    $("#mod_codigo").val(0);
    $("#mod_codigomodelo").val("SIN MODELO");
    $("#tall_codigo").val(0);
    $("#tall_descripcion").val("SIN TALLE");
    $("#unime_codigo").val(4);
    $("#unime_descripcion").val("SIN UNIDAD");
    $("#it_stock_min").val(0);
    $("#it_stock_max").val(0);
    $(".mod").attr("class", "form-line mod focused");
    $(".tall").attr("class", "form-line tall focused");
    $(".unime").attr("class", "form-line unime focused");
    $(".st").attr("class", "form-line st focused");
    $("#mod_codigomodelo").attr("disabled", "true");
    $("#tall_descripcion").attr("disabled", "true");
    $("#unime_descripcion").attr("disabled", "true");
    $("#it_stock_min").attr("disabled", "true");
    $("#it_stock_max").attr("disabled", "true");
  } else {
    $("#mod_codigo").val("");
    $("#mod_codigomodelo").val("");
    $("#tall_codigo").val("");
    $("#tall_descripcion").val("");
    $("#unime_codigo").val("");
    $("#unime_descripcion").val("");
    $("#it_stock_min").val("");
    $("#it_stock_max").val("");
    $(".mod").attr("class", "form-line mod");
    $(".tall").attr("class", "form-line tall");
    $(".unime").attr("class", "form-line unime");
    $(".st").attr("class", "form-line st");
    $("#mod_codigomodelo").removeAttr("disabled");
    $("#tall_descripcion").removeAttr("disabled");
    $("#unime_descripcion").removeAttr("disabled");
    $("#it_stock_min").removeAttr("disabled");
    $("#it_stock_max").removeAttr("disabled");
  }
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
const seleccionTipoImpuesto = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTIm").html();
  $("#listaTIm").attr("style", "display: none;");
  $(".tipim").attr("class", "form-line tipim focused");
};

//Obtiene los datos del tipo de impuesto y los muestra en una lista
const getTipoImpuesto = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaTipoImpuesto.php",
    data: {
      tipim_descripcion: $("#tipim_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionTipoImpuesto(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.tipim_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulTIm").html(fila);
      //hacemos visible la lista
      $("#listaTIm").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a su respectivo input lo seleccionado por el usuario en la lista
const seleccionModelo = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulModelo").html();
  $("#listaModelo").attr("style", "display: none;");
  $(".mod").attr("class", "form-line mod focused");
};

//Obtiene los datos del modelo y los muestra en una lista
const getModelo = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaModelo.php",
    data: {
      mod_codigomodelo: $("#mod_codigomodelo").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionModelo(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.mod_codigomodelo +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulModelo").html(fila);
      //hacemos visible la lista
      $("#listaModelo").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a su respectivo input lo seleccionado por el usuario en la lista
const seleccionTalle = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulTalle").html();
  $("#listaTalle").attr("style", "display: none;");
  $(".tall").attr("class", "form-line tall focused");
};

//Obtiene los datos del talle y los muestra en una lista
const getTalle = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaTalle.php",
    data: {
      tall_descripcion: $("#tall_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionTalle(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.tall_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulTalle").html(fila);
      //hacemos visible la lista
      $("#listaTalle").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a su respectivo input lo seleccionado por el usuario en la lista
const seleccionUnidadMedida = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulUnidadMedida").html();
  $("#listaUnidadMedida").attr("style", "display: none;");
  $(".unime").attr("class", "form-line unime focused");
};

//Obtiene los datos de la unidad de medida y los muestra en una lista
const getUnidadMedida = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaUnidadMedida.php",
    data: {
      unime_descripcion: $("#unime_descripcion").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionUnidadMedida(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.unime_descripcion +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulUnidadMedida").html(fila);
      //hacemos visible la lista
      $("#listaUnidadMedida").attr(
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
