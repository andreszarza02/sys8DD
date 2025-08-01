<?php
session_start();

$empresa = $_SESSION['usuario']['emp_razonsocial'];
$empresaCodigo = $_SESSION['usuario']['emp_codigo'];

$sucursal = $_SESSION['usuario']['suc_descripcion'];
$sucursalCodigo = $_SESSION['usuario']['suc_codigo'];

?>
<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
   <title>Informe Modulo Produccion</title>

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

            <!-- Formulario Informe Modulo Produccion -->
            <div class="col-lg-12 col-md-12 col-sm-12">
               <div class="card">
                  <!-- Titulo Principal -->
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        INFORME MODULO DE PRODUCCION
                     </h2>
                  </div>
                  <!-- Informe a Generar -->
                  <div class="header">
                     <div class="row clearfix">
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line t focused">
                                 <input type="text" class="form-control" id="tablas" onclick="getTablas()">
                                 <label class="form-label">Informe Solicitado</label>
                                 <div id="listaTablas" style="display: none;">
                                    <ul class="list-group" id="ulTablas"
                                       style="height: 200px; width:340px; overflow: scroll"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </div>
                  </div>
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        PARAMETROS DE INFORME
                     </h2>
                  </div>
                  <div class="body">
                     <div class="row clearfix">
                        <div class="orden_produccion">
                           <div class="col-sm-12" style="color: #b9b9b9;">
                              <p>
                                 Informe Orden de Produccion
                              </p>
                           </div>
                           <div class="col-sm-4">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control">
                                    <label class="form-label">Cliente (Opcional)</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-4">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control">
                                    <label class="form-label">Seccion (Opcional)</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-4">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control">
                                    <label class="form-label">Estado (Opcional)</label>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="control_calidad">
                           <div class="col-sm-12" style="color: #b9b9b9;">
                              <p>
                                 Informe Control de Calidad
                              </p>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control">
                                    <label class="form-label">Produccion Terminada (Opcional)</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="date" class="form-control">
                                    <label class="form-label">Desde</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="date" class="form-control">
                                    <label class="form-label">Hasta</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control">
                                    <label class="form-label">Seccion (Opcional)</label>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="etapas_produccion">
                           <div class="col-sm-12" style="color: #b9b9b9;">
                              <p>
                                 Informe Etapas de Produccion
                              </p>
                           </div>
                           <div class="col-sm-6">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control" placeholder="Este campo es obligatorio">
                                    <label class="form-label">Numero Produccion</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-6">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" class="form-control">
                                    <label class="form-label">Items (Opcional)</label>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </div>
                     <!-- Botones -->
                     <div class="icon-and-text-button-demo">
                        <button type="button" class="btn bg-red waves-effect" onclick="controlVacio()">
                           <i class="material-icons">content_paste</i>
                           <span>GENERAR</span>
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
   <script src="metodosMovimiento.js"></script>

</body>

</html>