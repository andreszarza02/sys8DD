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

}

?>
<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
   <title>Venta</title>

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

            <?php if (isset($_SESSION['apertura']['habilitado']) == 'ABIERTO' or $_SESSION['usuario']['modu_descripcion'] == 'SISTEMA') {

               ?>

               <?php if (!isset($_SESSION['apertura']['numero_caja'])) { ?>
                  <div class="col-lg-12 col-md-12 col-sm-12">
                     <div class="alert" style="font-weight: bold; background: #4DC18B;">
                        LA CAJA NO SE ENCUENTRA ABIERTA, DE ESTA MANERA NO SE PUEDEN REGISTRAR FACTURAS DE VENTA
                     </div>
                  </div>
               <?php } ?>

               <!-- Formulario Venta -->
               <div class="col-lg-12 col-md-12 col-sm-12">
                  <div class="card">
                     <div class="header" style="background: #4DC18B;">
                        <h2 style="color: white; font-weight: bold;">
                           FORMULARIO DE VENTA
                        </h2>
                     </div>
                     <div class="body">
                        <input type="hidden" id="operacion_cabecera" value="0">
                        <div class="row clearfix">
                           <div class="col-sm-1">
                              <div class="form-group form-float">
                                 <div class="form-line activar">
                                    <input type="text" class="form-control" id="ven_codigo" disabled>
                                    <label class="form-label">N° Venta</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-1">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="date" class="form-control" id="ven_fecha" disabled>
                                    <label class="form-label">Fecha</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line ped">
                                    <input type="text" class="form-control no-disabled letras-numeros-algunos-simbolos"
                                       id="per_numerodocumento" disabled onkeyup="getPedidoVenta()">
                                    <label class="form-label">Documento Cliente</label>
                                    <div id="listaPedido" style="display: none;">
                                       <ul class="list-group" id="ulPedido" style="height: 100px; overflow: auto"></ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-3">
                              <div class="form-group form-float">
                                 <div class="form-line ped">
                                    <input type="hidden" id="cli_codigo" value="0">
                                    <input type="text" class="form-control" id="cliente" disabled>
                                    <label class="form-label">Cliente</pelabel>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line ped">
                                    <input type="hidden" id="caj_codigo" value="<?php if (isset($_SESSION['apertura']['numero_caja'])) {
                                       print_r($_SESSION['apertura']['numero_caja']);
                                    } else {
                                       print_r(value: "0");
                                    } ?>">
                                    <input type="text" class="form-control" id="peven_codigo" disabled>
                                    <label class="form-label">N° Pedido</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line foco3">
                                    <input type="hidden" id="tipco_codigo" value="4">
                                    <input type="text" class="form-control" id="ven_numfactura" disabled>
                                    <label class="form-label">N° Factura</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line foco3">
                                    <input type="text" class="form-control" id="ven_timbrado" disabled>
                                    <label class="form-label">Timbrado</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line focused">
                                    <input type="date" class="form-control" id="ven_timbrado_venc" disabled>
                                    <label class="form-label">Fecha</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line tp">
                                    <input type="text" class="form-control no-disabled solo-letras" id="ven_tipofactura"
                                       disabled onclick="getTipoFactura()">
                                    <label class="form-label">Tipo Factura</label>
                                    <div id="listaTipoFactura" style="display: none;">
                                       <ul class="list-group" id="ulTipoFactura" style="height: 100px; overflow: auto">
                                       </ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line foco4">
                                    <input type="text" class="form-control no-disabled solo-numeros" id="ven_cuota"
                                       disabled>
                                    <label class="form-label">Cuota</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line foco2">
                                    <input type="text" class="form-control no-disabled solo-numeros" id="ven_montocuota"
                                       disabled>
                                    <label class="form-label">Monto Cuota</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line foco4">
                                    <input type="text" class="form-control no-disabled letras-numeros-algunos-símbolos2"
                                       id="ven_interfecha" disabled>
                                    <label class="form-label">Intervalo Fecha</label>
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
                                    <input type="text" class="form-control" id="ven_estado" disabled>
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
                              <button type="button" class="btn bg-orange waves-effect" onclick="limpiarCampos()">
                                 <i class="material-icons">lock</i>
                                 <span>CANCELAR</span>
                              </button>
                           </div>
                        </div>
                     </div>
                  </div>
               </div>

               <!-- Formulario Venta Detalle -->
               <div id="detalle" style="display: none;">
                  <div class="col-lg-12 col-md-12 col-sm-12">
                     <div class="card">
                        <div class="header" style="background: #4DC18B;">
                           <h2 style="color: white; font-weight: bold;">
                              DETALLE VENTA
                           </h2>
                        </div>
                        <div class="body">
                           <input type="hidden" id="operacion_detalle" value="0">
                           <div class="row clearfix">
                              <div class="col-sm-2">
                                 <div class="form-group form-float">
                                    <div class="form-line dep">
                                       <input type="hidden" id="dep_codigo" value="0">
                                       <input type="text" class="form-control no-disabled2 letras-numeros"
                                          id="dep_descripcion" disabled onkeyup="getDeposito()">
                                       <label class="form-label">Deposito</label>
                                       <div id="listaDeposito" style="display: none;">
                                          <ul class="list-group" id="ulDeposito" style="height: 100px; overflow: auto">
                                          </ul>
                                       </div>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-3">
                                 <div class="form-group form-float">
                                    <div class="form-line it">
                                       <input type="hidden" id="it_codigo" value="0">
                                       <input type="hidden" id="tipit_codigo" value="0">
                                       <input type="hidden" id="tipim_codigo" value="0">
                                       <input type="text" class="form-control no-disabled2 letras-numeros" id="item"
                                          disabled onkeyup="getItem()">
                                       <label class="form-label">Item</label>
                                       <div id="listaItem" style="display: none;">
                                          <ul class="list-group" id="ulItem" Style="height: 100px; overflow: auto"></ul>
                                       </div>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-2">
                                 <div class="form-group form-float">
                                    <div class="form-line it">
                                       <input type="text" class="form-control" id="tall_descripcion" disabled>
                                       <label class="form-label">Talle</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-1">
                                 <div class="form-group form-float">
                                    <div class="form-line it">
                                       <input type="text" class="form-control" id="vendet_cantidad" disabled>
                                       <label class="form-label">Cantidad</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-2">
                                 <div class="form-group form-float">
                                    <div class="form-line it">
                                       <input type="hidden" id="unime_codigo" value="0">
                                       <input type="text" class="form-control" id="unime_descripcion" disabled>
                                       <label class="form-label">Unidad Medida</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-2">
                                 <div class="form-group form-float">
                                    <div class="form-line it">
                                       <input type="text" class="form-control" id="vendet_precio" disabled>
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
                                 <?php if ($btnEliminar === true) { ?>
                                    <button type="button" class="btn btn-primary waves-effect" onclick="eliminar()">
                                       <i class="material-icons">insert_drive_file</i>
                                       <span>IMPRIMIR</span>
                                    </button>
                                 <?php } ?>
                              </div>
                              <div class="botonesExtra4" style="display: none;">
                                 <button type="button" class="btn bg-red waves-effect" onclick="controlVacio2()">
                                    <i class="material-icons">save</i>
                                    <span>CONFIRMAR</span>
                                 </button>
                                 <button type="button" class="btn bg-orange waves-effect" onclick="limpiarCampos()">
                                    <i class="material-icons">lock</i>
                                    <span>CANCELAR</span>
                                 </button>
                              </div>
                           </div>

                           <!-- Grilla Venta Detalle -->
                           <div class="table-responsive">
                              <table class="table table-bordered table-striped table-hover">
                                 <thead>
                                    <tr>
                                       <th>ITEM</th>
                                       <th>TALLE</th>
                                       <th>TIPO ITEM</th>
                                       <th>CANTIDAD</th>
                                       <th>UNIDAD MEDIDA</th>
                                       <th>DEPOSITO</th>
                                       <th>PRECIO</th>
                                       <th>EXENTA</th>
                                       <th>IVA 5</th>
                                       <th>IVA 10</th>
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

               <!-- Grilla Venta-->
               <div class="col-lg-12 col-md-12 col-sm-12" id="cabecera" style="display: block;">
                  <div class="card">
                     <div class="header" style="background: #4DC18B;">
                        <h2 style="color: white; font-weight: bold;">
                           VENTAS REGISTRADAS <small style="color: white; font-weight: bold;">Lista de Ventas
                              Registradas</small>
                        </h2>
                     </div>
                     <div class="body">
                        <div class="table-responsive">
                           <table class="table table-bordered table-striped table-hover dataTable js-exportable">
                              <thead>
                                 <tr>
                                    <th>N° VENTA</th>
                                    <th>FECHA</th>
                                    <th>N° FACTURA</th>
                                    <th>TIMBRADO</th>
                                    <th>FECHA VENC. TIMBRADO</th>
                                    <th>TIPO FACTURA</th>
                                    <th>CUOTA</th>
                                    <th>MONTO CUOTA</th>
                                    <th>INTERVALO</th>
                                    <th>CLIENTE</th>
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

            <?php } else { ?>

               <div class="col-lg-12 col-md-12 col-sm-12">
                  <div class="card">
                     <div class="header" style="background: #4DC18B;">
                        <h2 style="color: white; font-weight: bold;">
                           LA CAJA NO SE ENCUENTRA ABIERTA, PARA ACCEDER A ESTE FOMULARIO LA CAJA SE DEBE DE ENCONTRAR
                           ABIERTA
                        </h2>
                     </div>
                  </div>
               </div>

            <?php } ?>

         </div>
      </div>
   </section>

   <!-- referenciamos las librerias a utilizar -->
   <?php include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/link_js.php" ?>

   <!-- JavaScript propio -->
   <script src="metodos.js"></script>

</body>

</html>

<?php //} ?>