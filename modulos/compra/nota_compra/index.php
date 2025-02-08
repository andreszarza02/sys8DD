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
   <title>Nota de Compra</title>

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

            <!-- Formulario Nota Compra -->
            <div class="col-lg-12 col-md-12 col-sm-12">
               <div class="card">
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        FORMULARIO DE NOTA COMPRA
                     </h2>
                  </div>
                  <div class="body">
                     <input type="hidden" id="operacion_cabecera" value="0">
                     <input type="hidden" id="procedimiento" value="">
                     <div class="row clearfix">
                        <div class="col-sm-1">
                           <div class="form-group form-float">
                              <div class="form-line activar">
                                 <input type="hidden" id="nocom_codigo">
                                 <input type="text" class="form-control no-disabled" id="nocom_numeronota" disabled>
                                 <label class="form-label">N° Nota</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-1">
                           <div class="form-group form-float">
                              <div class="form-line fecha">
                                 <input type="text" class="form-control" id="nocom_fecha" disabled>
                                 <label class="form-label">Fecha</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line tip">
                                 <input type="hidden" id="tipco_codigo" value="0">
                                 <input type="text" class="form-control no-disabled" id="tipco_descripcion" disabled
                                    onkeyup="getTipoComprobante()">
                                 <label class="form-label">Tipo Comprobante</label>
                                 <div id="listaTC" style="display: none;">
                                    <ul class="list-group" id="ulTC" Style="height: 100px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line foco4">
                                 <input type="text" class="form-control no-disabled" id="nocom_concepto"
                                    onkeyup="getConcepto()" disabled>
                                 <label class="form-label">Concepto</label>
                                 <div id="listaConcepto" style="display: none;">
                                    <ul class="list-group" id="ulConcepto" Style="height: 100px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line comp">
                                 <input type="hidden" id="pro_codigo" value="0">
                                 <input type="hidden" id="tipro_codigo" value="0">
                                 <input type="hidden" id="tipro_descripcion">
                                 <input type="text" class="form-control no-disabled" id="pro_razonsocial" disabled
                                    onkeyup="getCompra()">
                                 <label class="form-label">RUC o Razon Social</label>
                                 <div id="listaCompra" style="display: none;">
                                    <ul class="list-group" id="ulCompra" Style="height: 100px; overflow: auto">
                                    </ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-1">
                           <div class="form-group form-float">
                              <div class="form-line comp">
                                 <input type="text" class="form-control" id="comp_codigo" disabled>
                                 <label class="form-label">N° Compra</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-2">
                           <div class="form-group form-float">
                              <div class="form-line comp">
                                 <input type="text" class="form-control" id="com_numfactura" disabled>
                                 <label class="form-label">N° Factura</label>
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
                                 <input type="text" class="form-control" id="nocom_estado" disabled>
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

            <!-- Formulario Nota Compra Detalle -->
            <div id="detalle" style="display: none;">
               <div class="col-lg-12 col-md-12 col-sm-12">
                  <div class="card">
                     <div class="header" style="background: #4DC18B;">
                        <h2 style="color: white; font-weight: bold;">
                           DETALLE NOTA COMPRA
                        </h2>
                     </div>
                     <div class="body">
                        <input type="hidden" id="operacion_detalle" value="0">
                        <div class="row clearfix">
                           <div class="col-sm-2" id="deposito" style="display: none;">
                              <div class="form-group form-float">
                                 <div class="form-line dep">
                                    <input type="hidden" id="dep_codigo" value="0">
                                    <input type="text" class="form-control no-disabled2" id="dep_descripcion"
                                       onkeyup="getDeposito()" disabled>
                                    <label class="form-label">Deposito</label>
                                    <div id="listaDeposito" style="display: none;">
                                       <ul class="list-group" id="ulDeposito" Style="height: 80px; overflow: auto"></ul>
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
                                    <input type="text" class="form-control no-disabled2" id="it_descripcion" disabled
                                       onkeyup="getItem()">
                                    <label class="form-label">Item</label>
                                    <div id="listaItem" style="display: none;">
                                       <ul class="list-group" id="ulItem" Style="height: 80px; overflow: auto"></ul>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-1">
                              <div class="form-group form-float">
                                 <div class="form-line foco2">
                                    <input type="number" class="form-control no-disabled2" id="nocomdet_cantidad"
                                       disabled onkeyup="validarCantidadItemCredito()"
                                       onchange="validarCantidadItemCredito()">
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
                                 <div class="form-line foco3">
                                    <input type="number" class="form-control" id="nocomdet_precio" disabled>
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

                        <!-- Grilla Nota Compra Detalle -->
                        <div class="table-responsive">
                           <table class="table table-bordered table-striped table-hover">
                              <thead>
                                 <tr>
                                    <th>ITEM</th>
                                    <th>TIPO</th>
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

            <!-- Grilla Nota Compra -->
            <div class="col-lg-12 col-md-12 col-sm-12" id="cabecera" style="display: block;">
               <div class="card">
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        NOTAS DE COMPRAS REGISTRADAS <small style="color: white; font-weight: bold;">Lista de Notas de
                           Compras Registradas</small>
                     </h2>
                  </div>
                  <div class="body">
                     <div class="table-responsive">
                        <table class="table table-bordered table-striped table-hover dataTable js-exportable">
                           <thead>
                              <tr>
                                 <th>N° NOTA</th>
                                 <th>FECHA</th>
                                 <th>TIPO COMPROBANTE</th>
                                 <th>CONCEPTO</th>
                                 <th>PROVEEDOR</th>
                                 <th>TIPO PROVEEDOR</th>
                                 <th>N° COMPRA</th>
                                 <th>N° FACTURA</th>
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