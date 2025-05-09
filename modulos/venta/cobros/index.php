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
$btnEnviar = false;

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
   <title>Cobros</title>

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
                        LA CAJA NO SE ENCUENTRA ABIERTA, DE ESTA MANERA NO SE PUEDEN REGISTRAR LOS COBROS
                     </div>
                  </div>
               <?php } ?>

               <!-- Formulario Cobro -->
               <div class="col-lg-12 col-md-12 col-sm-12">
                  <div class="card">
                     <div class="header" style="background: #4DC18B;">
                        <h2 style="color: white; font-weight: bold;">
                           FORMULARIO DE COBRO
                        </h2>
                     </div>
                     <div class="body">
                        <input type="hidden" id="operacion_cabecera" value="0">
                        <input type="hidden" id="tipco_codigo" value="5">
                        <div class="row clearfix">
                           <div class="col-sm-1">
                              <div class="form-group form-float">
                                 <div class="form-line activar">
                                    <input type="text" class="form-control" id="cob_codigo" disabled>
                                    <label class="form-label">N° Cobro</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line foco2">
                                    <input type="text" class="form-control" id="cob_fecha" disabled>
                                    <label class="form-label">Fecha</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-2">
                              <div class="form-group form-float">
                                 <div class="form-line <?php if (isset($_SESSION['apertura']['caja'])) {
                                    echo "foco focused";
                                 } else {
                                    echo "foco";
                                 } ?>">
                                    <!-- Aqui se define el numero de apertura y cierre -->
                                    <input type="hidden" id="apercie_codigo" value="<?php if (isset($_SESSION['apertura']['numero'])) {
                                       echo $_SESSION['apertura']['numero'];
                                    } else {
                                       echo "0";
                                    } ?>">
                                    <!-- Aqui se define el numero de caja abierta -->
                                    <input type="hidden" id="caj_codigo" value="<?php if (isset($_SESSION['apertura']['numero_caja'])) {
                                       echo $_SESSION['apertura']['numero_caja'];
                                    } else {
                                       echo "0";
                                    } ?>">
                                    <!-- Aqui se define la descripcion de la caja abierta -->
                                    <input type="text" class="form-control" id="caj_descripcion" disabled value="<?php if (isset($_SESSION['apertura']['caja'])) {
                                       echo $_SESSION['apertura']['caja'];
                                    } else {
                                       echo null;
                                    } ?>">
                                    <label class="form-label">Caja</label>
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
                           <div class="col-sm-2">
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
                           <div class="col-sm-1">
                              <div class="form-group form-float">
                                 <div class="form-line est">
                                    <input type="text" class="form-control" id="cob_estado" disabled>
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

               <!-- Formulario Cobro Detalle -->
               <div id="detalle" style="display: none;">
                  <div id="tamañoDetalle" class="col-lg-12 col-md-12 col-sm-12">
                     <div class="card">
                        <div class="header" style="background: #4DC18B;">
                           <h2 style="color: white; font-weight: bold;">
                              DETALLE COBRO
                           </h2>
                        </div>
                        <div class="header">
                           <div class="row clearfix">
                              <div class="col-sm-6">
                                 <div class="form-group form-float">
                                    <div class="form-line vent">
                                       <input type="text" class="form-control no-disabled2" id="ci" disabled
                                          onkeyup="getVenta()">
                                       <label class="form-label">Documento Cliente</label>
                                       <div id="listaVenta" style="display: none;">
                                          <ul class="list-group" id="ulVenta" Style="height: 100px; overflow: auto"></ul>
                                       </div>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-2">
                                 <div class="form-group form-float">
                                    <div class="form-line vent">
                                       <input type="hidden" id="ven_codigo" value="0">
                                       <input type="text" class="form-control" id="factura" disabled>
                                       <label class="form-label">Factura</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-2">
                                 <div class="form-group form-float">
                                    <div class="form-line vent">
                                       <input type="number" class="form-control" id="cuota" disabled>
                                       <label class="form-label">Cantidad Coutas</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-2">
                                 <div class="form-group form-float">
                                    <div class="form-line vent">
                                       <input type="hidden" id="cuenco_monto" value="0">
                                       <input type="number" class="form-control" id="saldo" disabled>
                                       <label class="form-label">Monto Saldo</label>
                                    </div>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="body detalleCobro">
                           <input type="hidden" id="operacion_detalle" value="0">
                           <input type="hidden" id="cobdet_codigo" value="0">
                           <div class="row clearfix">
                              <!-- La clase cliente nos permite definir el tamaño del input -->
                              <div class="col-sm-4 cliente">
                                 <div class="form-group form-float">
                                    <div class="form-line vent">
                                       <input type="text" class="form-control" id="cliente" disabled>
                                       <label class="form-label">Cliente</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-1 cuota">
                                 <div class="form-group form-float">
                                    <div class="form-line cob">
                                       <input type="number" class="form-control" id="cobdet_numerocuota" disabled>
                                       <label class="form-label">Cuota</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-2 montoCuota">
                                 <div class="form-group form-float">
                                    <div class="form-line vent">
                                       <input type="number" class="form-control" id="ven_montocuota" disabled>
                                       <label class="form-label">Monto Cuota</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-2 intervalo">
                                 <div class="form-group form-float">
                                    <div class="form-line vent">
                                       <input type="text" class="form-control" id="ven_interfecha" disabled>
                                       <label class="form-label">Intervalo</label>
                                    </div>
                                 </div>
                              </div>
                              <!-- La clase montoEfectivo nos permite definir el tamaño del input -->
                              <div class="col-sm-3 montoEfectivo" style="display: block;">
                                 <div class="form-group form-float">
                                    <div class="form-line cob2">
                                       <input type="number" class="form-control no-disabled2" id="cobdet_monto" disabled>
                                       <label class="form-label">Monto</label>
                                    </div>
                                 </div>
                              </div>
                              <!-- Botones que determinan el tipo de cobro -->
                              <div class="col-sm-2" style="display: none;" id="forco_simbolo">
                                 <input type="hidden" id="forco_codigo" value="0">
                                 <input type="hidden" id="forco_descripcion" value="0">
                                 <div class="icon-button-demo">
                                    <div class="col-sm-4 contenedorEfectivo">
                                       <button type="button"
                                          class="btn bg-teal btn-circle waves-effect  waves-circle waves-float"
                                          id="forco_efectivo">
                                          <i class="material-icons">attach_money</i>
                                       </button>
                                    </div>
                                    <div class="col-sm-4">
                                       <button type="button"
                                          class="btn bg-teal btn-circle waves-effect  waves-circle waves-float"
                                          id="forco_tarjeta">
                                          <i class="material-icons">credit_card</i>
                                       </button>
                                    </div>
                                    <div class="col-sm-4">
                                       <button type="button"
                                          class="btn bg-teal btn-circle waves-effect  waves-circle waves-float"
                                          id="forco_cheque">
                                          <i class="material-icons">local_atm</i>
                                       </button>
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
                                    <button type="button" class="btn btn-primary waves-effect btnEliminar"
                                       onclick="eliminar()" style="display: none;">
                                       <i class="material-icons">delete</i>
                                       <span>ELIMINAR</span>
                                    </button>
                                 <?php } ?>
                                 <button type="button" class="btn btn-primary waves-effect" onclick="imprimir()">
                                    <i class="material-icons">insert_drive_file</i>
                                    <span>IMPRIMIR</span>
                                 </button>
                                 <?php if ($btnEnviar === true) { ?>
                                    <button type="button" class="btn btn-primary waves-effect" onclick="enviarRecibo()">
                                       <i class="material-icons">email</i>
                                       <span>ENVIAR RECIBO</span>
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

                           <!-- Grilla Cobro Detalle -->
                           <div id="tablaDet" class="table-responsive">
                              <table class="table table-bordered table-striped table-hover">
                                 <thead>
                                    <tr>
                                       <th>FACTURA</th>
                                       <th>CLIENTE</th>
                                       <th>FORMA COBRO</th>
                                       <th>N° CUOTA</th>
                                       <th>MONTO</th>
                                    </tr>
                                 </thead>
                                 <tbody id="tabla_detalle">
                                 </tbody>
                              </table>
                           </div>
                        </div>
                     </div>
                  </div>
               </div>

               <!-- Formulario Cobro Tarjeta -->
               <div id="cobroTarjeta" style="display: none;">
                  <div id="tamañoCobroTarjeta" class="col-lg-12 col-md-12 col-sm-12">
                     <div class="card">
                        <div class="header" style="background: #4DC18B;">
                           <h2 style="color: white; font-weight: bold;">
                              COBRO TARJETA
                           </h2>
                        </div>
                        <div class="body">
                           <div class="row clearfix">
                              <div class="col-sm-4">
                                 <div class="form-group form-float">
                                    <div class="form-line cobta">
                                       <input type="text" class="form-control no-disabled2" id="cobta_numero" disabled>
                                       <label class="form-label">N° Tarjeta</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-4">
                                 <div class="form-group form-float">
                                    <div class="form-line cobta2">
                                       <input type="number" class="form-control no-disabled2" id="cobta_monto" disabled>
                                       <label class="form-label">Monto Tajeta</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-4">
                                 <div class="form-group form-float">
                                    <div class="form-line tipTar">
                                       <input type="text" class="form-control no-disabled2" id="cobta_tipotarjeta"
                                          onclick="getTipoTarjeta()" disabled>
                                       <label class="form-label">Tipo Tarjeta</label>
                                       <div id="listaTipoTar" style="display: none;">
                                          <ul class="list-group" id="ulTipoTar" Style="height: 100px; overflow: auto">
                                          </ul>
                                       </div>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-3">
                                 <div class="form-group form-float">
                                    <div class="form-line ent">
                                       <input type="hidden" id="entad_codigo" value="0">
                                       <!--Se usa para ambas entidades-->
                                       <input type="hidden" id="ent_codigo" value="0">
                                       <input type="text" class="form-control no-disabled2" id="ent_razonsocial"
                                          onkeyup="getEntidadAdherida()" disabled>
                                       <label class="form-label">Entidad</label>
                                       <div id="listaEntidadTarjeta" style="display: none;">
                                          <ul class="list-group" id="ulEntidadTarjeta"
                                             Style="height: 100px; overflow: auto">
                                          </ul>
                                       </div>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-3">
                                 <div class="form-group form-float">
                                    <div class="form-line ent">
                                       <input type="hidden" id="marta_codigo" value="0">
                                       <input type="text" class="form-control" id="marta_descripcion" disabled>
                                       <label class="form-label">Marca Tarjeta</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-3">
                                 <div class="form-group form-float">
                                    <div class="form-line cobta">
                                       <input type="text" class="form-control no-disabled2" id="cobta_transaccion"
                                          disabled>
                                       <label class="form-label">N° Transaccion</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-3">
                                 <div class="form-group form-float">
                                    <div class="form-line redpa">
                                       <input type="hidden" id="redpa_codigo" value="0">
                                       <input type="text" class="form-control no-disabled2" id="redpa_descripcion"
                                          onkeyup="getRedPago()" disabled>
                                       <label class="form-label">Red Pago</label>
                                       <div id="listaRedPago" style="display: none;">
                                          <ul class="list-group" id="ulRedPago" Style="height: 100px; overflow: auto">
                                          </ul>
                                       </div>
                                    </div>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </div>
                  </div>
               </div>

               <!-- Formulario Cobro Cheque -->
               <div id="cobroCheque" style="display: none;">
                  <div id="tamañoCobroCheque" class="col-lg-12 col-md-12 col-sm-12">
                     <div class="card">
                        <div class="header" style="background: #4DC18B;">
                           <h2 style="color: white; font-weight: bold;">
                              COBRO CHEQUE
                           </h2>
                        </div>
                        <div class="body">
                           <div class="row clearfix">
                              <div class="col-sm-3">
                                 <div class="form-group form-float">
                                    <div class="form-line coche">
                                       <input type="text" class="form-control no-disabled2" id="coche_numero" disabled>
                                       <label class="form-label">N° Cheque</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-2">
                                 <div class="form-group form-float">
                                    <div class="form-line coche2">
                                       <input type="number" class="form-control no-disabled2" id="coche_monto" disabled>
                                       <label class="form-label">Monto Cheque</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-2">
                                 <div class="form-group form-float">
                                    <div class="form-line tipChe">
                                       <input type="text" class="form-control no-disabled2" id="coche_tipocheque"
                                          onclick="getTipoCheque()" disabled>
                                       <label class="form-label">Tipo Cheque</label>
                                       <div id="listaTipoChe" style="display: none;">
                                          <ul class="list-group" id="ulTipoChe" Style="height: 100px; overflow: auto">
                                          </ul>
                                       </div>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-2">
                                 <div class="form-group form-float">
                                    <div class="form-line focused">
                                       <input type="date" class="form-control no-disabled2" id="coche_fechavencimiento"
                                          disabled>
                                       <label class="form-label">Fecha Vencimiento</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="col-sm-3">
                                 <div class="form-group form-float">
                                    <div class="form-line ent">
                                       <input type="hidden" id="ent_codigo2" value="0">
                                       <input type="text" class="form-control no-disabled2" id="ent_razonsocial2"
                                          onkeyup="getEntidad()" disabled>
                                       <label class="form-label">Entidad</label>
                                       <div id="listaEntidadCheque" style="display: none;">
                                          <ul class="list-group" id="ulEntidadCheque"
                                             Style="height: 100px; overflow: auto">
                                          </ul>
                                       </div>
                                    </div>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </div>
                  </div>
               </div>

               <!-- Grilla Cobro-->
               <div class="col-lg-12 col-md-12 col-sm-12" id="cabecera">
                  <div class="card">
                     <div class="header" style="background: #4DC18B;">
                        <h2 style="color: white; font-weight: bold;">
                           COBRO REGISTRADO <small style="color: white; font-weight: bold;">Lista de Cobro
                              Registrado</small>
                        </h2>
                     </div>
                     <div class="body">
                        <div class="table-responsive">
                           <table class="table table-bordered table-striped table-hover dataTable js-exportable">
                              <thead>
                                 <tr>
                                    <th>N° COBRO</th>
                                    <th>FECHA</th>
                                    <th>CAJA</th>
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