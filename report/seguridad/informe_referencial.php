<?php
session_start();
?>
<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
   <title>Informe Referencial Seguridad</title>

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

            <!-- Formulario Informe Referecial Seguridad -->
            <div class="col-lg-12 col-md-12 col-sm-12">
               <div class="card">
                  <div class="header">
                     <h2>
                        INFORME REFERENCIAL SEGURIDAD
                     </h2>
                  </div>
                  <div class="body">
                     <div class="row clearfix">
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line focused">
                                 <input type="text" class="form-control" id="desde">
                                 <label class="form-label">DESDE</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line focused">
                                 <input type="text" class="form-control" id="hasta">
                                 <label class="form-label">HASTA</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line t focused">
                                 <input type="text" class="form-control" id="tablas" onclick="getTablas()">
                                 <label class="form-label">Referenciales Seguridad</label>
                                 <div id="listaTablas" style="display: none;">
                                    <ul class="list-group" id="ulTablas"
                                       style="height: 200px; width:340px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </div>

                     <!-- Botones -->
                     <div class="icon-and-text-button-demo">
                        <button type="button" class="btn bg-red waves-effect" onclick="controlVacio()">
                           <i class="material-icons">content_paste</i>
                           <span>CONSULTAR</span>
                        </button>
                        <button type="button" class="btn bg-red waves-effect" onclick="limpiarCampos()">
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