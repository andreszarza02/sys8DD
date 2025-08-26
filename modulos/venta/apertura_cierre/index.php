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

$btnApertura = false;
$btnCierre = false;

foreach ($permisos as $permiso) {
   if (($permiso['perm_descripcion'] === 'ABRIR') && ($permiso['asigperm_estado'] === 'ACTIVO')) {
      $btnApertura = true;
   }

   if (($permiso['perm_descripcion'] === 'CERRAR') && ($permiso['asigperm_estado'] === 'ACTIVO')) {
      $btnCierre = true;
   }
}

?>
<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
   <title>Apertura Cierre Caja</title>

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

            <!-- Boton de aparicion de formulario -->
            <div class="col-lg-12 col-md-12 col-sm-12 botonesExtra6">
               <div class="icon-button-demo">
                  <button type="button" class="btn bg-teal btn-circle-lg waves-effect waves-circle waves-float"
                     onclick="reapertura()">
                     <i class="material-icons">restore_page</i>
                  </button>
               </div>
            </div>


            <!-- Formulario Apertura y Cierre -->
            <div class="col-lg-6 col-md-6 col-sm-6">
               <input type="hidden" id="operacion" value="0">
               <div class="card">
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        APERTURA Y CIERRE DE CAJA
                     </h2>
                  </div>
                  <div class="body">
                     <div class="row clearfix">
                        <div class="col-sm-4">
                           <div class="form-group form-float">
                              <div class="form-line activar">
                                 <input type="hidden" id="apertura" value="<?php if (isset($_SESSION['apertura']['numero'])) {
                                    print_r($_SESSION['apertura']['numero']);
                                 } else {
                                    print_r("0");
                                 } ?>">
                                 <input type="hidden" id="estadoApertura" value="<?php if (isset($_SESSION['apertura']['habilitado'])) {
                                    print_r($_SESSION['apertura']['habilitado']);
                                 } else {
                                    print_r("CERRADO");
                                 } ?>">
                                 <input type="text" class="form-control" id="apercie_codigo" disabled>
                                 <label class="form-label">N° Apertura y Cierre</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-4">
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
                        <div class="col-sm-4">
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
                        <div class="col-sm-4">
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
                        <div class="col-sm-4">
                           <div class="form-group form-float">
                              <div class="form-line caj">
                                 <input type="hidden" id="caj_codigo" value="0">
                                 <input type="text" class="form-control no-disabled" id="caj_descripcion" disabled
                                    onkeyup="getCaja()">
                                 <label class="form-label">Caja</label>
                                 <div id="listaCaja" style="display: none;">
                                    <ul class="list-group" id="ulCaja" Style="height: 100px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-4">
                           <div class="form-group form-float">
                              <div class="form-line est">
                                 <input type="text" class="form-control" id="apercie_estado" disabled>
                                 <label class="form-label">Estado</label>
                              </div>
                           </div>
                        </div>
                     </div>
                  </div>
                  <section class="apertura">
                     <div class="header" style="background: #4DC18B; border-radius: 50px;">
                        <h2 style="color: white; font-weight: bold;">
                           APERTURA DE CAJA
                        </h2>
                     </div>
                     <div class="body">
                        <div class="row clearfix">
                           <div class="col-sm-6">
                              <div class="form-group form-float">
                                 <div class="form-line fechaAper">
                                    <input type="text" class="form-control no-disabled" id="apercie_fechahoraapertura"
                                       disabled>
                                    <label class="form-label">Fecha Apertura</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-6">
                              <div class="form-group form-float">
                                 <div class="form-line montoAper">
                                    <input type="number" class="form-control no-disabled" id="apercie_montoapertura"
                                       disabled>
                                    <label class="form-label">Monto Apertura</label>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </div>
                  </section>
                  <section class="cierre" style="display: none">
                     <div class="header" style="background: #4DC18B; border-radius: 50px;">
                        <h2 style="color: white; font-weight: bold;">
                           CIERRE DE CAJA
                        </h2>
                     </div>
                     <div class="body">
                        <div class="row clearfix">
                           <div class="col-sm-6">
                              <div class="form-group form-float">
                                 <div class="form-line fechaCie">
                                    <input type="text" class="form-control no-disabled" id="apercie_fechahoracierre"
                                       disabled>
                                    <label class="form-label">Fecha Cierre</label>
                                 </div>
                              </div>
                           </div>
                           <div class="col-sm-6">
                              <div class="form-group form-float">
                                 <div class="form-line montoCie">
                                    <input type="text" class="form-control no-disabled" id="apercie_montocierre"
                                       disabled>
                                    <label class="form-label">Monto Cierre</label>
                                 </div>
                              </div>
                           </div>
                        </div>
                     </div>
                  </section>
               </div>
               <div class="icon-and-text-button-demo">
                  <?php if ($btnApertura === true) { ?>
                     <button type="button" class="btn btn-primary waves-effect botonesExtra1" onclick="abrir()">
                        <i class="material-icons">add</i>
                        <span>APERTURA</span>
                     </button>
                  <?php } ?>
                  <?php if ($btnCierre === true) { ?>
                     <button type="button" class="btn btn-primary waves-effect botonesExtra2" onclick="cerrar()">
                        <i class="material-icons">cancel</i>
                        <span>CIERRE</span>
                     </button>
                  <?php } ?>
                  <button type="button" class="btn btn-primary waves-effect botonesExtra3" onclick="salir()">
                     <i class="material-icons">exit_to_app</i>
                     <span>SALIR</span>
                  </button>
                  <div class="botonesExtra4" style="display: none;">
                     <button type="button" class="btn bg-red waves-effect" onclick="controlVacio()">
                        <i class="material-icons">save</i>
                        <span>CONFIRMAR</span>
                     </button>
                     <button type="button" class="btn bg-red waves-effect" onclick="limpiarCampos()">
                        <i class="material-icons">lock</i>
                        <span>CANCELAR</span>
                     </button>
                  </div>
                  <div class="botonesExtra5" style="display: none;">
                     <button type="button" class="btn bg-red waves-effect" onclick="controlVacio4()">
                        <i class="material-icons">sync</i>
                        <span>REABRIR</span>
                     </button>
                     <button type="button" class="btn bg-red waves-effect" onclick="limpiarCampos()">
                        <i class="material-icons">lock</i>
                        <span>CANCELAR</span>
                     </button>
                  </div>
               </div>
            </div>

            <div class="col-lg-6 col-md-6 col-sm-6 contenedorApertura" style="display: none;">
               <div class="card">
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        REAPERTURA DE CAJA
                     </h2>
                  </div>
                  <div class="body">
                     <div class="row clearfix">
                        <div class="col-sm-12">
                           <div class="form-group form-float">
                              <div class="form-line aper">
                                 <input type="hidden" id="apercie_codigo2" value="0">
                                 <input type="text" class="form-control no-disabled" id="usuario"
                                    onkeyup="getApertura()">
                                 <label class="form-label">Usuario</label>
                                 <div id="listaApertura" style="display: none;">
                                    <ul class="list-group" id="ulApertura" Style="height: 100px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line aper">
                                 <input type="hidden" id="caj_codigo2" value="0">
                                 <input type="text" class="form-control no-disabled" id="caj_descripcion2" disabled>
                                 <label class="form-label">Caja</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line aper">
                                 <input type="text" class="form-control no-disabled" id="emp_razonsocial2" disabled>
                                 <label class="form-label">Empresa</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line aper">
                                 <input type="text" class="form-control no-disabled" id="suc_descripcion2" disabled>
                                 <label class="form-label">Sucursal</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line aper">
                                 <input type="text" class="form-control no-disabled" id="apercie_estado2" disabled>
                                 <label class="form-label">Estado</label>
                              </div>
                           </div>
                        </div>
                     </div>
                  </div>
               </div>
            </div>

            <!-- Formulario Arqueo Control -->
            <div class="col-lg-6 col-md-6 col-sm-6" id="contenedorArqueo" style="display: none;">
               <div class="card">
                  <div class="header" style="background: #4DC18B;">
                     <h2 style="color: white; font-weight: bold;">
                        Arqueo Control
                     </h2>
                  </div>
                  <div class="body">

                     <h2 class="card-inside-title" style="color: white; font-weight: bold; background-color:#4DC18B;">
                        Formas de Pago</h2>
                     <div class="demo-checkbox" id="contenedorCheck">
                        <input type="checkbox" id="efectivo" class="filled-in chk-col-teal" value="efectivo" />
                        <label for="efectivo">Efectivo</label>
                        <input type="checkbox" id="cheque" class="filled-in chk-col-teal" value="cheque" />
                        <label for="cheque">Cheque</label>
                        <input type="checkbox" id="tarjeta" class="filled-in chk-col-teal" value="tarjeta" />
                        <label for="tarjeta">Tarjeta</label>
                        <input type="checkbox" id="formaTodos" class="filled-in chk-col-teal" value="todos" />
                        <label for="formaTodos">Todos</label>
                     </div>

                  </div>
                  <div class="body">
                     <div class="row clearfix">
                        <div class="col-sm-12">
                           <h2 class="card-inside-title"
                              style="color: white; font-weight: bold; background-color:#4DC18B;">Funcionario</h2>
                           <div class="form-group">
                              <div class="form-line">
                                 <input type="hidden" id="func_codigo" value="0">
                                 <input type="text" id="funcionario" class="form-control"
                                    placeholder="Ingresa el CI del funcionario" onkeyup="getFuncionario()" />
                                 <div id="listaFuncionario" style="display: none;">
                                    <ul class="list-group" id="ulFuncionario" Style="height: 100px; overflow: auto">
                                    </ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-12">
                           <h2 class="card-inside-title"
                              style="color: white; font-weight: bold; background-color:#4DC18B;">Observacion</h2>
                           <div class="form-group">
                              <div class="form-line">
                                 <input type="text" id="observacion" class="form-control"
                                    placeholder="Ingresa el motivo del arqueo" />
                              </div>
                           </div>
                        </div>
                     </div>
                     <div class="demo-button">
                        <button type="button" class="btn btn-block btn-lg waves-effect"
                           style="background-color: #4DC18B; color: white;" onclick="controlVacio3()">GENERAR
                           ARQUEO</button>
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