<?php

// Iniciamos la sesion
session_start();

?>
<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
   <title>Informes Referenciales Compras</title>

   <!-- inluimos los estilos y las fuentes -->
   <?php include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/link_css.php" ?>

   <style>
      .list-group-item:hover {
         background: #4DC18B;
      }

      #ulTablas::-webkit-scrollbar {
         width: 10px;
      }

      #ulTablas::-webkit-scrollbar-track {
         background: #f1f1f1;
      }

      #ulTablas::-webkit-scrollbar-thumb {
         background: #888;
      }

      #ulTablas::-webkit-scrollbar-thumb:hover {
         background: #555;
      }
   </style>

</head>

<body class="theme">

   <?php include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/encabezado.php" ?>

   <section class="content">
      <div class="container-fluid">
         <div class="row clearfix">

            <!-- Formulario Informes Refereciales Compras -->
            <div class="col-lg-12 col-md-12 col-sm-12">
               <div class="card">
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        INFORMES REFERENCIALES COMPRAS
                     </h2>
                  </div>
                  <div class="body">
                     <div class="row clearfix">
                        <div class="col-sm-3" id="div_tablas">
                           <div class="form-group form-float">
                              <div class="form-line t focused">
                                 <input type="hidden" id="codigo_informe" value="0">
                                 <input type="text" class="form-control" id="tablas" onclick="getTablas()">
                                 <label class="form-label">Referenciales Compras</label>
                                 <div id="listaTablas" style="display: none;">
                                    <ul class="list-group" id="ulTablas" Style="height: 200px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="filtro_item" style="display: none;">
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control solo-numeros" id="desdeItem">
                                    <label class="form-label">Desde</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control solo-numeros" id="hastaItem">
                                    <label class="form-label">Hasta</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line tipit focused">
                                    <input type="hidden" id="tipit_codigo">
                                    <input type="text" class="form-control solo-letras" id="tipit_descripcion"
                                       onkeyup="getTipoItem()">
                                    <label class="form-label">Tipo Item</label>
                                    <div id="listaTIt" style="display: none;">
                                       <ul class="list-group" id="ulTIt" Style="height: 100px; overflow: auto"></ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control letras_numeros" id="it_descripcion">
                                    <label class="form-label">Descripcion</label>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="filtro_sucursal" style="display: none;">
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control solo-numeros" id="desdeSucursal">
                                    <label class="form-label">Desde</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control solo-numeros" id="hastaSucursal">
                                    <label class="form-label">Hasta</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line ciu focused">
                                    <input type="hidden" id="ciu_codigo">
                                    <input type="text" class="form-control solo-letras" id="ciu_descripcion"
                                       onkeyup="getCiudad()">
                                    <label class="form-label">Ciudad</label>
                                    <div id="listaCiudad" style="display: none;">
                                       <ul class="list-group" id="ulCiudad" Style="height: 100px; overflow: auto"></ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control solo-letras" id="suc_descripcion">
                                    <label class="form-label">Descripcion</label>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="filtro_proveedor" style="display: none;">
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control solo-numeros" id="desdeProveedor">
                                    <label class="form-label">Desde</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control solo-numeros" id="hastaProveedor">
                                    <label class="form-label">Hasta</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line tip focused">
                                    <input type="hidden" id="tipro_codigo" value="0">
                                    <input type="text" class="form-control solo-letras" id="tipro_descripcion"
                                       onkeyup="getTipoProveedor()">
                                    <label class="form-label">Tipo Proveedor</label>
                                    <div id="listaTP" style="display: none;">
                                       <ul class="list-group" id="ulTP" Style="height: 100px; overflow: auto">
                                       </ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control letras-numeros-algunos-simbolos"
                                       id="pro_razonsocial">
                                    <label class="form-label">Razon Social</label>
                                 </div>
                              </div>
                           </div>

                        </div>
                     </div>

                     <!-- Botones -->
                     <div class=" icon-and-text-button-demo">
                        <button type="button" class="btn bg-red waves-effect" onclick="controlVacio()">
                           <i class="material-icons">content_paste</i>
                           <span>GENERAR</span>
                        </button>
                        <button type="button" class="btn bg-orange waves-effect" onclick="limpiarCampos()">
                           <i class="material-icons">lock</i>
                           <span>CANCELAR</span>
                        </button>
                        <button type="button" class="btn bg-red waves-effect" onclick="salir()">
                           <i class="material-icons">exit_to_app</i>
                           <span>SALIR</span>
                        </button>
                     </div>
                  </div>
               </div>
            </div>

         </div>
      </div>
   </section>

   <!-- referenciamos las librerias a utilizar -->
   <?php include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/link_js.php" ?>

   <!-- JavaScript propio -->
   <script src="metodosReferencial.js"></script>

</body>

</html>