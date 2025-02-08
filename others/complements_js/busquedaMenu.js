const seleccionMenu = (datos) => {
  //Al seleccionar la interfaz buscada, abrimos el mismo
  window.location = datos.link;
};

const getListaMenu = () => {
  $.ajax({
    //Solicitamos la interfaz a la cual queremos acceder
    method: "POST",
    url: "/sys8DD/others/complements_php/listasModulos/listaMenu.php",
    data: {
      busquedaMenu: $("#busquedaMenu").val(),
    },
  }) //Individualizamos los datos del array y lo separamos por lista
    .done(function (lista) {
      let fila = "";
      $.each(lista, function (i, objeto) {
        if (objeto.dato1 == "NSE") {
          fila += "<li class='list-group-item'>" + objeto.dato2 + "</li>";
        } else {
          fila +=
            "<li class='list-group-item' onclick='seleccionMenu(" +
            JSON.stringify(objeto) +
            ")'>" +
            objeto.gui +
            "</li>";
        }
      });

      //cargamos la lista
      $("#ulBsquedaMenu").html(fila);
      //hacemos visible la lista
      $("#listaBusquedaMenu").attr(
        "style",
        "display: block; position:absolute; z-index: 3000; width:100%;"
      );
    });
};

//Vacia la lista de interfaces
const vaciarLista = () => {
  //vaciamos la lista
  let fila = "";
  $("#ulBsquedaMenu").html(fila);
  //ocultamos la lista
  $("#listaBusquedaMenu").attr("style", "display: none;");
};
