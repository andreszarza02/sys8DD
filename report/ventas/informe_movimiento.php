<?php

// Llamamos a la variable de sesión
session_start();

// Establecemos datos de empresa y sucursal
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
   <title>Informe Modulo Vemtas</title>

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

            <!-- Formulario Informe Modulo Ventas -->
            <div class="col-lg-12 col-md-12 col-sm-12">
               <div class="card">
                  <!-- Titulo Principal -->
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        INFORME MODULO DE VENTAS
                     </h2>
                  </div>
                  <!-- Informe a Generar -->
                  <div class="header">
                     <div class="row clearfix">
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line t focused">
                                 <input type="hidden" id="codigo_informe" value="0">
                                 <input type="text" class="form-control" id="tablas" onclick="getTablas()">
                                 <label class="form-label">Informe Solicitado</label>
                                 <div id="listaTablas" style="display: none;">
                                    <ul class="list-group" id="ulTablas" style="height: 100px; overflow: auto"></ul>
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
                        <div class="caja_recaudaciones" style="display: none;">
                           <div class="col-sm-12" style="color: #b9b9b9;">
                              <p>
                                 Informe Caja y Recaudaciones
                              </p>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="hidden" id="suc_codigo" value="0">
                                    <input type="text" class="form-control" id="suc_descripcion"
                                       placeholder="Este campo es obligatorio">
                                    <label class="form-label">Sucursal</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="date" id="desdeCaja" class="form-control">
                                    <label class="form-label">Desde</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="date" id="hastaCaja" class="form-control">
                                    <label class="form-label">Hasta</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="hidden" id="func_codigo" value="0">
                                    <input type="text" id="funcionario" class="form-control">
                                    <label class="form-label">Cajero (Opcional)</label>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="libro_ventas" style="display: none;">
                           <div class="col-sm-12" style="color: #b9b9b9;">
                              <p>
                                 Informe Libro de Ventas
                              </p>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line cli1 focused">
                                    <input type="hidden" id="cli_codigo1" value="0">
                                    <input type="text" id="cliente1" class="form-control"
                                       placeholder="Ingrese el numero de documento" onkeyup="getCliente()">
                                    <label class="form-label">Cliente (Opcional)</label>
                                    <div id="listaCliente1" style="display: none;">
                                       <ul class="list-group" id="ulCliente1" Style="height: 100px; overflow: auto">
                                       </ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="date" id="desdeLibro" class="form-control">
                                    <label class="form-label">Desde</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="date" id="hastaLibro" class="form-control">
                                    <label class="form-label">Hasta</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line tip focused">
                                    <input type="hidden" id="tipco_codigo" value="0">
                                    <input type="text" id="tipco_descripcion" class="form-control"
                                       onkeyup="getTipoComprobante()">
                                    <label class="form-label">Tipo Comprobante (Opcional)</label>
                                    <div id="listaTC" style="display: none;">
                                       <ul class="list-group" id="ulTC" Style="height: 100px; overflow: auto"></ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="cuentas_cobrar" style="display: none;">
                           <div class="col-sm-12" style="color: #b9b9b9;">
                              <p>
                                 Informe Cuentas a Cobrar
                              </p>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="hidden" id="cli_codigo2" value="0">
                                    <input type="text" id="cliente2" class="form-control">
                                    <label class="form-label">Cliente (Opcional)</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="date" id="desdeCuenta" class="form-control">
                                    <label class="form-label">Desde</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="date" id="hastaCuenta" class="form-control">
                                    <label class="form-label">Hasta</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="text" id="estado" class="form-control">
                                    <label class="form-label">Estado (Opcional)</label>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </div>
                     <!-- Botones -->
                     <div class="icon-and-text-button-demo" id="botones" style="display: none;">
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
   <script src="metodosMovimiento.js"></script>

</body>

</html>