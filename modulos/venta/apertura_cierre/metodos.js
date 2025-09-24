//Variables globales
//Crea el array de checkbox
let contenedorPadre = document.getElementById("contenedorCheck");
let checkboxes = contenedorPadre.querySelectorAll('input[type="checkbox"]');
//Almacena checkboxs activos
let valoresCheckboxesActivos = [];

//Controla que los inputs no se queden vacios al perder el foco y que solo contengan letras y numeros
const validacionInputsVacios1 = () => {
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

//Controla que los inputs no se queden vacios al perder el foco y que no contengan numeros o simbolos
const validacionInputsVacios3 = () => {
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

//Actualiza datos como empresa, sucursal y usuario en el formulario
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

//Habilita botones
const habilitarBotones = (numero, estado = "") => {
  if (numero === 1 && estado == "CERRADO") {
    $(".botonesExtra1").attr("style", "display: inline;");
    $(".botonesExtra3").attr("style", "display: inline;");
    $(".botonesExtra2").attr("style", "display: none;");
    $(".botonesExtra4").attr("style", "display: none;");
  } else if (numero === 2 && estado == "ABIERTO") {
    $(".botonesExtra2").attr("style", "display: inline;");
    $(".botonesExtra3").attr("style", "display: inline;");
    $(".botonesExtra1").attr("style", "display: none;");
    $(".botonesExtra4").attr("style", "display: none;");
  } else if (numero === 3) {
    $(".botonesExtra1").attr("style", "display: none;");
    $(".botonesExtra2").attr("style", "display: none;");
    $(".botonesExtra3").attr("style", "display: none;");
    $(".botonesExtra4").attr("style", "display: block;");
  }
};

//Habilita botones de la reapertura
const habilitarBotones2 = (condicion) => {
  if (condicion) {
    $(".botonesExtra5").attr("style", "display: block;");
    $(".botonesExtra6").attr("style", "display: none;");
  } else {
    $(".botonesExtra6").attr("style", "display: block;");
    $(".botonesExtra5").attr("style", "display: none;");
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

//Obtiene y establece el numero de apertura y cierre
const getNumberAperCie = () => {
  $.ajax({
    method: "GET",
    url: "controlador.php",
  }).done(function (respuesta) {
    $("#apercie_codigo").val(respuesta.numero_apertura);
  });
};

//Metodo encargado de mantener abierto la caja
const maintainOpenness = () => {
  $.ajax({
    method: "POST",
    url: "controladorEstado.php",
    data: {
      apercie_codigo: $("#apertura").val(),
    },
  }).done(function (respuesta) {
    if (respuesta.respuesta == 0) {
      $("#apercie_codigo").val("");
      $("#caj_codigo").val(0);
      $("#caj_descripcion").val("");
      $("#apercie_estado").val("");
      $(".activar").attr("class", "form-line activar");
      $(".caj").attr("class", "form-line caj");
      $(".est").attr("class", "form-line est");
      habilitarBotones(1, $("#estadoApertura").val());
    } else {
      $("#apercie_codigo").val(respuesta.apercie_codigo);
      $("#caj_codigo").val(respuesta.caj_codigo);
      $("#caj_descripcion").val(respuesta.caj_descripcion);
      $("#apercie_estado").val(respuesta.apercie_estado);
      $(".activar").attr("class", "form-line activar focused");
      $(".caj").attr("class", "form-line caj focused");
      $(".est").attr("class", "form-line est focused");
      let estado = $("#estadoApertura").val();
      habilitarBotones(2, estado);
    }
  });
};

//Metodo encargado de obtener la fecha y hora actual
const getTimestamp = () => {
  const date = new Date();
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  const hours = date.getHours();
  const minutes = date.getMinutes();
  const seconds = date.getSeconds();
  const fechaHora = `${day}/${month}/${year} ${hours}:${minutes}:${seconds}`;

  return fechaHora;
};

//Se encarga de realizar la sumatoria de cobros y etsablecerlos en monto cierre, en caso de que no haya un registro de cobros devuelve 0
const getMontoCierre = () => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      apercie_codigo: $("#apercie_codigo").val(),
      apercie_fechahoracierre: $("#apercie_fechahoracierre").val(),
      consulta: "1",
    },
  }).done(function (respuesta) {
    $("#apercie_montocierre").val(respuesta.totalcierre);
  });
};

//Se encarga de cargar la tabla de recaudacion a depositar una vez ocurre un cierre de caja
const setRecaudacion = () => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      apercie_codigo: $("#apercie_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      caj_codigo: $("#caj_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
      consulta: "2",
    },
  });
};

//Se encarga de cargar la tabla de arqueo control cada vez que alguien necesite un reporte de arqueo
const setArqueo = () => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      apercie_codigo: $("#apercie_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      caj_codigo: $("#caj_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
      observacion: $("#observacion").val(),
      func_codigo: $("#func_codigo").val(),
      consulta: "3",
    },
  }).done(function (respuesta) {
    //Validamos si se ejecuto de forma correcta la insercion en arqueo control si es asi generamos el reporte
    if (respuesta.insertado == "ok") {
      let cabeceraArqueoControl = [
        $("#apercie_codigo").val(),
        $("#emp_razonsocial").val(),
        $("#suc_descripcion").val(),
        $("#usu_login").val(),
        $("#funcionario").val(),
        $("#observacion").val(),
        $("#caj_descripcion").val(),
      ];

      reporteArqueoControl(valoresCheckboxesActivos, cabeceraArqueoControl);
      limpiarArqueo();
    }
  });
};

//Permite establecer las formas de cobro a generar el reporte
const getFormaCobro = () => {
  contenedorPadre = document.getElementById("contenedorCheck");
  checkboxes = contenedorPadre.querySelectorAll('input[type="checkbox"]');
  let checkboxTodos = document.getElementById("formaTodos");

  //Vaciamos el array por cada cambio
  valoresCheckboxesActivos = [];

  checkboxes.forEach(function (checkbox) {
    //Por cada input checkeado guardamos su valor
    if (checkbox.checked) {
      valoresCheckboxesActivos.push(checkbox.value);
    }

    //Cuando se llegue a un total de 3 selecciones, automaticamente
    //Seleccioanmos el input todos
    if (valoresCheckboxesActivos.length === 3) {
      valoresCheckboxesActivos = [];
      //En el caso de que se seleccione todos como ultimo, establece el array vacio con el valor de todos
      if (checkboxTodos.checked) {
        valoresCheckboxesActivos.push(checkboxTodos.value);
      }
      checkboxTodos.checked = true;
      checkboxes.forEach(function (checkbox) {
        if (checkbox !== checkboxTodos) {
          checkbox.checked = false;
        }
      });
    }
  });

  console.log(valoresCheckboxesActivos);
};

//Genera el reporte de arqueo control
const reporteArqueoControl = (formaPago, datosCabecera) => {
  window.location =
    "/sys8DD/report/ventas/reporte/reporte_arqueo_control.php?forma=" +
    formaPago +
    "&cabecera=" +
    datosCabecera;
};

//Se encarga de habilitar el formulario de reapertura de caja
const reapertura = () => {
  habilitarBotones2(true);
  $(".botonesExtra1").attr("style", "display: none;");
  $(".botonesExtra2").attr("style", "display: none;");
  $(".botonesExtra3").attr("style", "display: none;");
  $(".contenedorApertura").attr("style", "display: block;");
  $("#emp_codigo").val(0);
  $("#emp_razonsocial").val("");
  $("#suc_codigo").val(0);
  $("#suc_descripcion").val("");
  $("#usu_codigo").val(0);
  $("#usu_login").val("");
  $("#apercie_estado").val("");
  $("#apercie_fechahoraapertura").val("");
  $(".foco").attr("class", "form-line foco");
  $(".est").attr("class", "form-line est");
  $(".fechaAper").attr("class", "form-line fechaAper");
  validacionInputsVacios3();
};

//Se encarga de abrir la caja
const abrir = () => {
  //Obtiene el último codigo de apertura
  getNumberAperCie();
  habilitarCampos(true);
  $(".activar").attr("class", "form-line activar focused");
  $(".est").attr("class", "form-line est focused");
  $(".fechaAper").attr("class", "form-line fechaAper focused");
  $("#apercie_estado").val("ABIERTO");
  habilitarBotones(3);
  $("#apercie_fechahoraapertura").val(getTimestamp());
  $("#operacion").val(1);
  validacionInputsVacios1();
  validacionInputsVacios2();
};

//Se encarga de cerrar la caja
let cerrar = () => {
  $("#apercie_fechahoracierre").val(getTimestamp());
  getMontoCierre();
  $(".fechaCie").attr("class", "form-line fechaCie focused");
  $(".montoCie").attr("class", "form-line montoCie focused");
  $("#operacion").val(2);
  $("#apercie_estado").val("CERRADO");
  habilitarBotones(3);
};

//Valida el estado de la caja para decidir cual formulario mostrar
const stateOfBox = () => {
  let stateBox = $("#estadoApertura").val();
  if (stateBox == "CERRADO") {
    $(".apertura").attr("style", "display: block");
    $(".cierre").attr("style", "display: none");
  } else {
    $(".apertura").attr("style", "display: none");
    $(".cierre").attr("style", "display: block");
  }
};

//Se encarga de limpiar los campos
const limpiarCampos = () => {
  window.location.reload(true);
};

//Limpia los campos del formulario de arqueo
const limpiarArqueo = () => {
  $("#funcionario").val("");
  $("#func_codigo").val(0);
  $("#observacion").val("");
  checkboxes.forEach(function (checkbox) {
    checkbox.checked = false;
  });
};

//Pasa parametros en el controlador para insertar o modificar un registro
const grabar = () => {
  $.ajax({
    //Enviamos datos al controlador
    method: "POST",
    url: "controlador.php",
    data: {
      apercie_codigo: $("#apercie_codigo").val(),
      emp_codigo: $("#emp_codigo").val(),
      suc_codigo: $("#suc_codigo").val(),
      usu_codigo: $("#usu_codigo").val(),
      caj_codigo: $("#caj_codigo").val(),
      apercie_estado: $("#apercie_estado").val(),
      apercie_fechahoraapertura: $("#apercie_fechahoraapertura").val(),
      apercie_fechahoracierre: $("#apercie_fechahoracierre").val(),
      apercie_montoapertura: $("#apercie_montoapertura").val(),
      apercie_montocierre: $("#apercie_montocierre").val(),
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
            if ($("#operacion").val() == "2") {
              setRecaudacion();
            }
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

//Se encarga de mostrar los mensajes de confirmacion de aperura o cierre
const confirmar = () => {
  //solicitamos el value del input operacion
  let oper = $("#operacion").val();

  let preg = `¿Desea abrir la caja con el siguiente monto:${$(
    "#apercie_montoapertura"
  ).val()} Gs?`;

  if (oper == 2) {
    preg = "¿Desea cerrar la caja?";
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
        grabar();
      } else {
        //Si cancelamos la operacion realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

//Se encarga de mostrar el mensaje de confirmación de generación de arqueo
const confirmar2 = () => {
  let preg = "¿Desea generar el arqueo control?";

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
      //Si la operacion es correcta generamos y registramos el arqueo
      if (isConfirm) {
        setArqueo();
      } else {
        //Si cancelamos la operacion realizamos un reload
        window.location.reload(true);
      }
    }
  );
};

//Se encarga de validar que los campos no se encuentren vacios
const controlVacio = () => {
  let condicion;
  let mensaje = "Cargue todos los campos en blanco";
  let stateBox = $("#estadoApertura").val();

  //Validación normal de campos
  if ($("#apercie_codigo").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion").val() == "") {
    condicion = true;
  } else if ($("#usu_login").val() == "") {
    condicion = true;
  } else if ($("#caj_descripcion").val() == "") {
    condicion = true;
  } else if ($("#apercie_estado").val() == "") {
    condicion = true;
  }

  //Validacon por estados
  if (stateBox == "CERRADO") {
    if ($("#apercie_fechahoraapertura").val() == "") {
      condicion = true;
    } else if ($("#apercie_montoapertura").val() == "") {
      condicion = true;
    }
  } else {
    if ($("#apercie_fechahoracierre").val() == "") {
      condicion = true;
    } else if ($("#apercie_montocierre").val() == "") {
      condicion = true;
    }
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: mensaje.toUpperCase(),
      type: "error",
    });
  } else {
    confirmar();
  }
};

//Se encarga de validar que los campos de arqueo no se encuentren vacios
const controlVacio3 = () => {
  let condicion = true;
  let seleccion = [];

  contenedorPadre = document.getElementById("contenedorCheck");
  checkboxes = contenedorPadre.querySelectorAll('input[type="checkbox"]');

  checkboxes.forEach(function (checkbox) {
    if (checkbox.checked) {
      seleccion.push(false);
    } else {
      seleccion.push(true);
    }
  });

  for (const indice in seleccion) {
    if (seleccion[indice] == false) {
      condicion = false;
    }
  }

  if ($("#func_codigo").val() == "0") {
    condicion = true;
  } else if ($("#funcionario").val() == "") {
    condicion = true;
  } else if ($("#observacion").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "CARGUE TODOS LOS CAMPOS DEL ARQUEO CONTROL",
      type: "error",
    });
  } else {
    confirmar2();
  }
};

//Se encarga de validar que los campos de reapertura no se encuentren vacios
const controlVacio4 = () => {
  let condicion;

  if ($("#apercie_codigo2").val() == "0") {
    condicion = true;
  } else if ($("#caj_codigo2").val() == "0") {
    condicion = true;
  } else if ($("#caj_descripcion2").val() == "") {
    condicion = true;
  } else if ($("#emp_razonsocial2").val() == "") {
    condicion = true;
  } else if ($("#suc_descripcion2").val() == "") {
    condicion = true;
  } else if ($("#apercie_estado2").val() == "") {
    condicion = true;
  }

  if (condicion) {
    swal({
      title: "RESPUESTA!!",
      text: "CARGUE TODOS LOS CAMPOS EN LA REAPERTURA",
      type: "error",
    });
  } else {
    setReapertura();
  }
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

//Envia a los input de funcionario lo seleccionado en el autocompletado
const seleccionFuncionario = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulFuncionario").html();
  $("#listaFuncionario").attr("style", "display: none;");
};

//Busca, filtra y muestra los funcionarios
const getFuncionario = () => {
  $.ajax({
    //Solicitamos los datos a listaModulo
    method: "POST",
    url: "/sys8DD/others/complements_php/listas/listaFuncionario.php",
    data: {
      per_numerodocumento: $("#funcionario").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionFuncionario(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.funcionario +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulFuncionario").html(fila);
      //hacemos visible la lista
      $("#listaFuncionario").attr(
        "style",
        "display: block; position:absolute; z-index:3000; width:100%;"
      );
    })
    .fail(function (a, b, c) {
      swal("ERROR", c, "error");
    });
};

//Envia a los input de reapertura lo seleccionado en el autocompletado
const seleccionApertura = (datos) => {
  //Enviamos los datos a su respectivo input
  Object.keys(datos).forEach((key) => {
    $("#" + key).val(datos[key]);
  });
  $("#ulApertura").html();
  $("#listaApertura").attr("style", "display: none;");
  $(".aper").attr("class", "form-line aper focused");
};

//Busca, filtra y muestra las cajas que se encuentran abiertas
const getApertura = () => {
  $.ajax({
    //Solicitamos los datos a listaReapertura
    method: "POST",
    url: "/sys8DD/others/complements_php/listasMovimientos/listaReapertura.php",
    data: {
      usuario: $("#usuario").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionApertura(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.apertura +
            "</li>";
        }
      });
      //cargamos la lista
      $("#ulApertura").html(fila);
      //hacemos visible la lista
      $("#listaApertura").attr(
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

//Se encarga de mostrar el formulario de arqueo
const mostrarArqueo = () => {
  $("#contenedorArqueo").attr("style", "display: block;");
};

//Metodo que se encarga de redefinir la variable de sesión de apertura
const setReapertura = () => {
  $.ajax({
    method: "POST",
    url: "controladorDetalle.php",
    data: {
      apercie_codigo: $("#apercie_codigo2").val(),
      apercie_estado: $("#apercie_estado2").val(),
      caj_codigo: $("#caj_codigo2").val(),
      caj_descripcion: $("#caj_descripcion2").val(),
      consulta: "4",
    },
  });

  limpiarCampos();
};

//Agrega un evento de cambio a todos los inputs checkbox
checkboxes.forEach(function (checkbox) {
  checkbox.addEventListener("change", getFormaCobro);
});

//En caso de estar abierto la caja, muestra el formulario de arqueo
if ($("#estadoApertura").val() == "ABIERTO") {
  $("#contenedorArqueo").attr("style", "display: block;");
  validacionInputsVacios2();
  validacionInputsVacios3();
}

//En caso de estar abierto la caja, oculta los botones de reapertura
if ($("#estadoApertura").val() == "ABIERTO") {
  $(".botonesExtra5").attr("style", "display: none;");
  $(".botonesExtra6").attr("style", "display: none;");
}

//Call de metodos
maintainOpenness();
stateOfBox();
