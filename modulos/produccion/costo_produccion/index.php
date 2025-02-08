<?php
//Iniciamos sesion
session_start();
$usuario = $_SESSION['usuario']['usu_codigo'];
$modulo = $_SESSION['usuario']['modu_descripcion'];

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

$btnNuevo = false;
$btnAnular = false;
$btnEliminar = false;

foreach ($permisos as $permiso) {
   if (($permiso['perm_descripcion'] === 'NUEVO') && ($permiso['asigperm_estado'] === 'ACTIVO')) {
      $btnNuevo = true;
   }

   if (($permiso['perm_descripcion'] === 'ANULAR') && ($permiso['asigperm_estado'] === 'ACTIVO')) {
      $btnAnular = true;
   }

   if (($permiso['perm_descripcion'] === 'ELIMINAR') && ($permiso['asigperm_estado'] === 'ACTIVO')) {
      $btnEliminar = true;
   }

}

?>
<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
   <title>Costo Produccion</title>

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

            <!-- Formulario Costo Produccion -->
            <div class="col-lg-12 col-md-12 col-sm-12">
               <div class="card">
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        FORMULARIO COSTO PRODUCCION
                     </h2>
                  </div>
                  <div class="body">
                     <input type="hidden" id="operacion_cabecera" value="0">
                     <input type="hidden" id="procedimiento" value="">
                     <div class="row clearfix">
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line activar">
                                 <input type="text" class="form-control" id="copro_codigo" disabled>
                                 <label class="form-label">N° C. Produccion</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line fecha">
                                 <input type="text" class="form-control" id="copro_fecha" disabled>
                                 <label class="form-label">Fecha</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-6">
                           <div class="form-group form-float">
                              <div class="form-line ord">
                                 <input type="text" class="form-control no-disabled" id="secc_descripcion" disabled
                                    onkeyup="getOrdenProduccion()">
                                 <label class="form-label">Seccion</label>
                                 <div id="listaOrdenProduccion" style="display: none;">
                                    <ul class="list-group" id="ulOrdenProduccion" Style="height: 100px; overflow: auto">
                                    </ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line ord">
                                 <input type="text" class="form-control" id="orpro_codigo" disabled>
                                 <label class="form-label">N° Orden</pelabel>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line foco">
                                 <input type="hidden" id="emp_codigo"
                                    value="<?php echo $_SESSION['usuario']['emp_codigo']; ?>">
                                 <input type="text" class="form-control" id="emp_razonsocial" disabled
                                    value="<?php echo $_SESSION['usuario']['emp_razonsocial']; ?>">
                                 <label class="form-label">Empresa</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line foco">
                                 <input type="hidden" id="suc_codigo"
                                    value="<?php echo $_SESSION['usuario']['suc_codigo']; ?>">
                                 <input type="text" class="form-control" id="suc_descripcion" disabled
                                    value="<?php echo $_SESSION['usuario']['suc_descripcion']; ?>">
                                 <label class="form-label">Sucursal</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line foco">
                                 <input type="hidden" id="usu_codigo"
                                    value="<?php echo $_SESSION['usuario']['usu_codigo']; ?>">
                                 <input type="text" class="form-control" id="usu_login" disabled
                                    value="<?php echo $_SESSION['usuario']['usu_login']; ?>">
                                 <label class="form-label">Usuario</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line est">
                                 <input type="text" class="form-control" id="copro_estado" disabled>
                                 <label class="form-label">Estado</label>
                              </div>
                           </div>
                        </div>
                     </div>

                     <!-- Botones Cabecera -->
                     <div class="icon-and-text-button-demo">
                        <div class="botonesExtra1">
                           <?php if ($btnNuevo === true) { ?>
                              <button type="button" class="btn btn-primary waves-effect" onclick="nuevo()">
                                 <i class="material-icons">add</i>
                                 <span>NUEVO</span>
                              </button>
                           <?php } ?>
                           <?php if ($btnAnular === true) { ?>
                              <button type="button" class="btn btn-primary waves-effect" onclick="anular()">
                                 <i class="material-icons">cancel</i>
                                 <span>ANULAR</span>
                              </button>
                           <?php } ?>
                           <button type="button" class="btn btn-primary waves-effect" onclick="salir()">
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

            <!-- Grilla Costo Produccion Detalle -->
            <div id="detalle" style="display: none;">
               <div class="col-lg-12 col-md-12 col-sm-12">
                  <div class="card">
                     <div class="header" style="background: #4DC18B;">
                        <h2 style="color: white; font-weight: bold;">
                           DETALLE COSTO PRODUCCION
                        </h2>
                     </div>
                     <div class="body">
                        <div class="table-responsive">
                           <table class="table table-bordered table-striped table-hover">
                              <thead>
                                 <tr>
                                    <th>ITEM</th>
                                    <th>CANTIDAD</th>
                                    <th>UNIDAD MEDIDA</th>
                                    <th>PRECIO UNITARIO</th>
                                    <th>SUBTOTAL</th>
                                 </tr>
                              </thead>
                              <tbody id="tabla_detalle">
                              </tbody>
                              <tfoot id="pie_detalle">
                              </tfoot>
                           </table>
                        </div>
                     </div>
                  </div>
               </div>
            </div>

            <!-- Grilla Costo Produccion -->
            <div class="col-lg-12 col-md-12 col-sm-12" id="cabecera" style="display: block;">
               <div class="card">
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        COSTOS DE PRODUCCION REGISTRADOS <small style="color: white; font-weight: bold;">Lista de Costos
                           de Produccion Registrados</small>
                     </h2>
                  </div>
                  <div class="body">
                     <div class="table-responsive">
                        <table class="table table-bordered table-striped table-hover dataTable js-exportable">
                           <thead>
                              <tr>
                                 <th>N° C. PRODUCCION</th>
                                 <th>FECHA</th>
                                 <th>SECCION</th>
                                 <th>N° ORDEN</th>
                                 <th>USUARIO</th>
                                 <th>SUCURSAL</th>
                                 <th>EMPRESA</th>
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
   </section>

   <!-- referenciamos las librerias a utilizar -->
   <?php include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/link_js.php" ?>

   <!-- JavaScript propio -->
   <script src="metodos.js"></script>

</body>

</html>