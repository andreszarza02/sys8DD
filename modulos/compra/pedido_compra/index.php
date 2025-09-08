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

   if (($permiso['perm_descripcion'] === 'ENVIAR') && ($permiso['asigperm_estado'] === 'ACTIVO')) {
      $btnEnviar = true;
   }

}

?>
<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
   <title>Pedido de Compra</title>

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

            <!-- Formulario Pedido Compra -->
            <div class="col-lg-12 col-md-12 col-sm-12">
               <div class="card">
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        FORMULARIO DE PEDIDO COMPRA
                     </h2>
                  </div>
                  <div class="body">
                     <input type="hidden" id="operacion_cabecera" value="0">
                     <input type="hidden" id="procedimiento" value="">
                     <div class="row clearfix">
                        <div class="col-sm-1">
                           <div class="form-group form-float">
                              <div class="form-line activar">
                                 <input type="text" class="form-control" id="pedco_codigo" disabled>
                                 <label class="form-label">N° Pedido</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line fecha">
                                 <input type="text" class="form-control" id="pedco_fecha" disabled>
                                 <label class="form-label">Fecha</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-2">
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
                        <div class="col-sm-2">
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
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line est">
                                 <input type="text" class="form-control" id="pedco_estado" disabled>
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

            <!-- Formulario Pedido Compra Detalle -->
            <div id="detalle" style="display: none;">
               <div class="col-lg-12 col-md-12 col-sm-12">
                  <div class="card">
                     <div class="header" style="background: #4DC18B;">
                        <h2 style="color: white; font-weight: bold;">
                           DETALLE PEDIDO COMPRA
                        </h2>
                     </div>
                     <div class="body">
                        <input type="hidden" id="operacion_detalle" value="0">
                        <div class="row clearfix">
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line it">
                                    <input type="hidden" id="it_codigo" value="0">
                                    <input type="hidden" id="tipit_codigo" value="0">
                                    <input type="text" class="form-control no-disabled2 letras_numeros"
                                       id="it_descripcion" disabled onkeyup="getItem()">
                                    <label class="form-label">Item</label>
                                    <div id="listaItem" style="display: none;">
                                       <ul class="list-group" id="ulItem" Style="height: 80px; overflow: auto">
                                       </ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line foco2">
                                    <input type="text" class="form-control no-disabled2 numeros-algunos-simbolos"
                                       id="pedcodet_cantidad" disabled>
                                    <label class="form-label">Cantidad</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line it">
                                    <input type="hidden" id="unime_codigo" value="0">
                                    <input type="text" class="form-control" id="unime_descripcion" disabled>
                                    <label class="form-label">Unidad Medida</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line it">
                                    <input type="text" class="form-control" id="pedcodet_precio" disabled>
                                    <label class="form-label">Precio</label>
                                 </div>
                              </div>
                           </div>
                        </div>

                        <!-- Botones Detalle -->
                        <div class="icon-and-text-button-demo">
                           <div class="botonesExtra3">
                              <?php if ($btnNuevo === true) { ?>
                                 <button type="button" class="btn btn-primary waves-effect" onclick="nuevoDetalle()">
                                    <i class="material-icons">add</i>
                                    <span>NUEVO</span>
                                 </button>
                              <?php } ?>
                              <?php if ($btnEliminar === true) { ?>
                                 <button type="button" class="btn btn-primary waves-effect" onclick="eliminar()">
                                    <i class="material-icons">delete</i>
                                    <span>ELIMINAR</span>
                                 </button>
                              <?php } ?>
                           </div>
                           <div class="botonesExtra4" style="display: none;">
                              <button type="button" class="btn bg-red waves-effect" onclick="controlVacio2()">
                                 <i class="material-icons">save</i>
                                 <span>CONFIRMAR</span>
                              </button>
                              <button type="button" class="btn bg-red waves-effect" onclick="limpiarCampos()">
                                 <i class="material-icons">lock</i>
                                 <span>CANCELAR</span>
                              </button>
                           </div>
                        </div>

                        <!-- Grilla Pedido Compra Detalle -->
                        <div class="table-responsive">
                           <table class="table table-bordered table-striped table-hover">
                              <thead>
                                 <tr>
                                    <th>ITEM</th>
                                    <th>TIPO</th>
                                    <th>CANTIDAD</th>
                                    <th>UNIDAD MEDIDA</th>
                                    <th>PRECIO</th>
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

            <!-- Grilla Pedido Compra -->
            <div class="col-lg-12 col-md-12 col-sm-12" id="cabecera" style="display: block;">
               <div class="card">
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        PEDIDOS DE COMPRAS REGISTRADOS <small style="color: white; font-weight: bold;">Lista de Pedidos
                           Registrados</small>
                     </h2>
                  </div>
                  <div class="body">
                     <div class="table-responsive">
                        <table class="table table-bordered table-striped table-hover dataTable js-exportable">
                           <thead>
                              <tr>
                                 <th>N° PEDIDO</th>
                                 <th>FECHA</th>
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

            <!-- Formulario Solicitud Presupuesto Cabecera -->
            <div class="col-lg-12 col-md-12 col-sm-12">
               <div class="card">
                  <div class="header" style="background: #4caf50;">
                     <h2 style="color: white; font-weight: bold;">
                        FORMULARIO DE SOLICITUD PRESUPUESTO
                     </h2>
                  </div>
                  <div class="body">
                     <input type="hidden" id="operacion_cabecera2" value="0">
                     <div class="row clearfix cabecera-solicitud">
                        <div class="col-sm-1">
                           <div class="form-group form-float">
                              <div class="form-line activar2">
                                 <input type="text" class="form-control" id="solpre_codigo" disabled>
                                 <label class="form-label">N° Solicitud</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line fecha2">
                                 <input type="text" class="form-control" id="solpre_fecha" disabled>
                                 <label class="form-label">Fecha</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line pe">
                                 <input type="text" class="form-control no-disabled3 solo-numeros" id="pedco_codigo2"
                                    disabled onkeyup="getPedidoCompra()">
                                 <label class="form-label">N° Pedido</label>
                                 <div id="listaPedido" style="display: none;">
                                    <ul class="list-group" id="ulPedido" Style="height: 100px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line pro">
                                 <input type="hidden" id="pro_codigo" value="0">
                                 <input type="hidden" id="tipro_codigo" value="0">
                                 <input type="text" class="form-control no-disabled3 letras-numeros-algunos-simbolos"
                                    id="pro_razonsocial" disabled onkeyup="getProveedor()">
                                 <label class="form-label">RUC o Razón Social Proveedor</label>
                                 <div id="listaProvedor" style="display: none;">
                                    <ul class="list-group" id="ulProveedor" Style="height: 100px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line pro">
                                 <input type="text" class="form-control" id="solpre_correo_proveedor" disabled>
                                 <label class="form-label">Correo Proveedor</pelabel>
                              </div>
                           </div>
                        </div>
                     </div>

                     <!-- Botones Cabecera2 -->
                     <div class="icon-and-text-button-demo">
                        <div class="botonesExtra5">
                           <?php if ($btnNuevo === true) { ?>
                              <button type="button" class="btn btn-primary waves-effect" onclick="nuevo2()">
                                 <i class="material-icons">add</i>
                                 <span>NUEVO</span>
                              </button>
                           <?php } ?>
                           <?php if ($btnEliminar === true) { ?>
                              <button type="button" class="btn btn-primary waves-effect" onclick="eliminar2()">
                                 <i class="material-icons">delete</i>
                                 <span>ELIMINAR</span>
                              </button>
                           <?php } ?>
                           <button type="button" class="btn btn-primary waves-effect" onclick="salir()">
                              <i class="material-icons">exit_to_app</i>
                              <span>SALIR</span>
                           </button>
                        </div>
                        <div class="botonesExtra6" style="display: none;">
                           <button type="button" class="btn bg-red waves-effect" onclick="controlVacio3()">
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
                  <div id="detalle2" style="display: none;">
                     <div class="header" style="background: #4caf50;">
                        <h2 style="color: white; font-weight: bold;">
                           DETALLE SOLICITUD PRESUPUESTO
                        </h2>
                     </div>
                     <div class="body">
                        <input type="hidden" id="operacion_detalle2" value="0">
                        <div class="row clearfix detalle-solicitud">
                           <div class="col-sm-4">
                              <div class="form-group form-float">
                                 <div class="form-line it2">
                                    <input type="hidden" id="it_codigo2" value="0">
                                    <input type="hidden" id="tipit_codigo2" value="0">
                                    <input type="text" class="form-control no-disabled4 letras_numeros"
                                       id="it_descripcion2" disabled onkeyup="getItem2()">
                                    <label class="form-label">Item</label>
                                    <div id="listaItem2" style="display: none;">
                                       <ul class="list-group" id="ulItem2" Style="height: 80px; overflow: auto">
                                       </ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-4">
                              <div class="form-group form-float">
                                 <div class="form-line it2">
                                    <input type="text" class="form-control" id="solpredet_cantidad" disabled>
                                    <label class="form-label">Cantidad</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-4">
                              <div class="form-group form-float">
                                 <div class="form-line it2">
                                    <input type="hidden" id="unime_codigo2" value="0">
                                    <input type="text" class="form-control" id="unime_descripcion2" disabled>
                                    <label class="form-label">Unidad Medida</label>
                                 </div>
                              </div>
                           </div>
                        </div>

                        <!-- Botones Detalle2 -->
                        <div class="icon-and-text-button-demo">
                           <div class="botonesExtra7">
                              <?php if ($btnNuevo === true) { ?>
                                 <button type="button" class="btn btn-primary waves-effect" onclick="nuevoDetalle2()">
                                    <i class="material-icons">add</i>
                                    <span>NUEVO</span>
                                 </button>
                              <?php } ?>
                              <?php if ($btnEliminar === true) { ?>
                                 <button type="button" class="btn btn-primary waves-effect" onclick="eliminar3()">
                                    <i class="material-icons">delete</i>
                                    <span>ELIMINAR</span>
                                 </button>
                              <?php } ?>
                              <?php if ($btnEnviar === true) { ?>
                                 <button type="button" class="btn btn-primary waves-effect" onclick="enviarSolicitud()">
                                    <i class="material-icons">email</i>
                                    <span>ENVIAR SOLICITUD</span>
                                 </button>
                              <?php } ?>
                           </div>
                           <div class="botonesExtra8" style="display: none;">
                              <button type="button" class="btn bg-red waves-effect" onclick="controlVacio4()">
                                 <i class="material-icons">save</i>
                                 <span>CONFIRMAR</span>
                              </button>
                              <button type="button" class="btn bg-red waves-effect" onclick="limpiarCampos()">
                                 <i class="material-icons">lock</i>
                                 <span>CANCELAR</span>
                              </button>
                           </div>
                        </div>

                        <!-- Grilla Solicitud Presupuesto Detalle -->
                        <div class="table-responsive">
                           <table class="table table-bordered table-striped table-hover">
                              <thead>
                                 <tr>
                                    <th>ITEM</th>
                                    <th>TIPO</th>
                                    <th>CANTIDAD</th>
                                    <th>UNIDAD MEDIDA</th>
                                 </tr>
                              </thead>
                              <tbody id="tabla_detalle2">
                              </tbody>
                           </table>
                        </div>
                     </div>
                  </div>
               </div>
            </div>

            <!-- Grilla Solicitud Presupuesto Cabecera -->
            <div class="col-lg-12 col-md-12 col-sm-12" id="cabecera2" style="display: block;">
               <div class="card">
                  <div class="header" style="background: #4caf50;">
                     <h2 style="color: white; font-weight: bold;">
                        SOLICITUDES DE PRESUPUESTOS REGISTRADOS <small style="color: white; font-weight: bold;">Lista de
                           Solicitudes de Presupuestos
                           Registrados</small>
                     </h2>
                  </div>
                  <div class="body">
                     <div class="table-responsive">
                        <table class="table table-bordered table-striped table-hover">
                           <thead>
                              <tr>
                                 <th>N° SOLICITUD</th>
                                 <th>FECHA</th>
                                 <th>N° PEDIDO</th>
                                 <th>PROVEEDOR</th>
                                 <th>CORREO PROVEEDOR</th>
                                 <th>USUARIO</th>
                                 <th>SUCURSAL</th>
                                 <th>EMPRESA</th>
                              </tr>
                           </thead>
                           <tbody id="tabla_cuerpo2">
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