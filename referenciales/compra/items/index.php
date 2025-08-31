<?php
//Iniciamos sesion
session_start();
$usuario = $_SESSION['usuario']['usu_codigo'];

//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Creamos sentencia
$sql = "SELECT 
            p.perm_descripcion, 
            apu.asigperm_estado 
         FROM asignacion_permiso_usuario apu 
            JOIN permisos p ON p.perm_codigo = apu.perm_codigo 
         WHERE usu_codigo = $usuario 
         order by p.perm_codigo;";

//Consultamos y convertimos en array
$resultado = pg_query($conexion, $sql);
$permisos = pg_fetch_all($resultado);

?>
<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
   <title>Items</title>

   <!-- inluimos los estilos y las fuentes -->
   <?php include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/link_css.php" ?>

   <style>
      .list-group-item:hover {
         background: #4DC18B;
      }
   </style>

</head>

<body class="theme">

   <?php include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/encabezado.php" ?>

   <section class="content">
      <div class="container-fluid">
         <div class="row clearfix">

            <!-- Formulario Items -->
            <div class="col-lg-12 col-md-12 col-sm-12">
               <div class="card">
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        FORMULARIO DE ITEMS<small style="color: white; font-weight: bold;">Mantener referencial
                           items</small>
                     </h2>
                  </div>
                  <div class="body">
                     <input type="hidden" id="operacion" value="0">
                     <input type="hidden" id="procedimiento" value="">
                     <input type="hidden" id="usu_codigo" value="<?php echo $_SESSION['usuario']['usu_codigo']; ?>">
                     <input type="hidden" id="usu_login" value="<?php echo $_SESSION['usuario']['usu_login']; ?>">
                     <div class="row clearfix">
                        <div class="col-sm-1">
                           <div class="form-group form-float">
                              <div class="form-line activar">
                                 <input type="number" class="form-control" id="it_codigo" disabled>
                                 <label class="form-label">Codigo</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line tipit">
                                 <input type="hidden" id="tipit_codigo" value="0">
                                 <input type="text" class="form-control no-disabled solo-letras" id="tipit_descripcion"
                                    disabled onkeyup="getTipoItem()">
                                 <label class="form-label">Tipo Item</label>
                                 <div id="listaTIt" style="display: none;">
                                    <ul class="list-group" id="ulTIt" Style="height: 100px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line tipim">
                                 <input type="hidden" id="tipim_codigo" value="0">
                                 <input type="text" class="form-control no-disabled letras-numeros-algunos-simbolos"
                                    id="tipim_descripcion" disabled onkeyup="getTipoImpuesto()">
                                 <label class="form-label">Tipo Impuesto</label>
                                 <div id="listaTIm" style="display: none;">
                                    <ul class="list-group" id="ulTIm" Style="height: 100px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line foco">
                                 <input type="text" class="form-control no-disabled letras_numeros" id="it_descripcion"
                                    disabled>
                                 <label class="form-label">Descripcion</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line foco">
                                 <input type="text" class="form-control no-disabled numeros-algunos-simbolos"
                                    id="it_costo" disabled>
                                 <label class="form-label">Costo</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line foco">
                                 <input type="text" class="form-control no-disabled numeros-algunos-simbolos"
                                    id="it_precio" disabled>
                                 <label class="form-label">Precio</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-4">
                           <div class="form-group form-float">
                              <div class="form-line mod">
                                 <input type="hidden" id="mod_codigo" value="0">
                                 <input type="text" class="form-control no-disabled letras_numeros"
                                    id="mod_codigomodelo" disabled onkeyup="getModelo()">
                                 <label class="form-label">Modelo</label>
                                 <div id="listaModelo" style="display: none;">
                                    <ul class="list-group" id="ulModelo" Style="height: 100px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-4">
                           <div class="form-group form-float">
                              <div class="form-line tall">
                                 <input type="hidden" id="tall_codigo" value="0">
                                 <input type="text" class="form-control no-disabled letras_numeros"
                                    id="tall_descripcion" disabled onkeyup="getTalle()">
                                 <label class="form-label">Talle</label>
                                 <div id="listaTalle" style="display: none;">
                                    <ul class="list-group" id="ulTalle" Style="height: 100px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-4">
                           <div class="form-group form-float">
                              <div class="form-line unime">
                                 <input type="hidden" id="unime_codigo" value="0">
                                 <input type="text" class="form-control no-disabled solo-letras" id="unime_descripcion"
                                    disabled onkeyup="getUnidadMedida()">
                                 <label class="form-label">Unidad Medida</label>
                                 <div id="listaUnidadMedida" style="display: none;">
                                    <ul class="list-group" id="ulUnidadMedida" Style="height: 100px; overflow: auto">
                                    </ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-4">
                           <div class="form-group form-float">
                              <div class="form-line st">
                                 <input type="text" class="form-control no-disabled numeros-algunos-simbolos"
                                    id="it_stock_min" disabled>
                                 <label class="form-label">Stock Minimo</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-4">
                           <div class="form-group form-float">
                              <div class="form-line st">
                                 <input type="text" class="form-control no-disabled numeros-algunos-simbolos"
                                    id="it_stock_max" disabled>
                                 <label class="form-label">Stock Maximo</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-4">
                           <div class="form-group form-float">
                              <div class="form-line est">
                                 <input type="text" class="form-control" id="it_estado" disabled>
                                 <label class="form-label">Estado</label>
                              </div>
                           </div>
                        </div>
                     </div>

                     <!-- Botones -->
                     <div class="icon-and-text-button-demo">
                        <div class="botonesExtra1">
                           <?php foreach ($permisos as $permiso) { ?>
                              <?php if (($permiso['perm_descripcion'] === 'AGREGAR') && ($permiso['asigperm_estado'] === 'ACTIVO')) { ?>
                                 <button type="button" class="btn btn-primary waves-effect" onclick="agregar()">
                                    <i class="material-icons">verified_user</i>
                                    <span>AGREGAR</span>
                                 </button>
                              <?php } ?>
                              <?php if (($permiso['perm_descripcion'] === 'MODIFICAR') && ($permiso['asigperm_estado'] === 'ACTIVO')) { ?>
                                 <button type="button" class="btn btn-primary waves-effect" onclick="modificar()">
                                    <i class="material-icons">extension</i>
                                    <span>MODIFICAR</span>
                                 </button>
                              <?php } ?>
                              <?php if (($permiso['perm_descripcion'] === 'BORRAR') && ($permiso['asigperm_estado'] === 'ACTIVO')) { ?>
                                 <button type="button" class="btn btn-primary waves-effect" onclick="borrar()">
                                    <i class="material-icons">report_problem</i>
                                    <span>BORRAR</span>
                                 </button>
                              <?php } ?>
                           <?php } ?>
                           <button type="button" class="btn btn-primary waves-effect" onclick="salir  ()">
                              <i class="material-icons">exit_to_app</i>
                              <span>SALIR</span>
                           </button>
                        </div>
                        <div class="botonesExtra2" style="display: none;">
                           <button type="button" class="btn bg-red waves-effect" onclick="controlVacio()">
                              <i class="material-icons">save</i>
                              <span>CONFIRMAR</span>
                           </button>
                           <button type="button" class="btn bg-red waves-effect" onclick="limpiarCampos()">
                              <i class="material-icons">lock</i>
                              <span>CANCELAR</span>
                           </button>
                        </div>
                     </div>
                  </div>
               </div>
            </div>

            <!-- Grilla Gui -->
            <div id="items" style="display: block;">
               <div class="col-lg-12 col-md-12 col-sm-12">
                  <div class="card">
                     <div class="header" style="background: #4DC18B;">
                        <h2 style="color: white; font-weight: bold;">
                           ITEMS REGISTRADOS <small style="color: white; font-weight: bold;">Lista de items
                              registrados</small>
                        </h2>
                     </div>
                     <div class="body">
                        <div class="table-responsive">
                           <table class="table table-bordered table-striped table-hover dataTable js-exportable">
                              <thead>
                                 <tr>
                                    <th>CODIGO</th>
                                    <th>TIPO ITEM</th>
                                    <th>DESCRIPCION</th>
                                    <th>TIPO IMPUESTO</th>
                                    <th>COSTO</th>
                                    <th>PRECIO</th>
                                    <th>MODELO</th>
                                    <th>TALLE</th>
                                    <th>UNIDAD MEDIDA</th>
                                    <th>STOCK MINIMO</th>
                                    <th>STOCK MAXIMO</th>
                                    <th>ESTADO</th>
                                 </tr>
                              </thead>
                              <tbody id="tabla_cuerpo">
                              </tbody>
                           </table>
                        </div>
                     </div>
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
   <script src="metodos.js"></script>

</body>

</html>