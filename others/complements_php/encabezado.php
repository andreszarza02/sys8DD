<?php
//Consultamos si existe la variable de sesión usuario
if (isset($_SESSION['usuario'])) {
   //si existe, establecemos la variable $u como un array asociativo
   $u = $_SESSION['usuario'];
} else {
   //sino mediante el header redireccionamos al sign in
   header("Location: http://localhost/sys8DD/index.php");
}

//requerimos la conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//guardamos el perfil y consultamos los guis asignados al perfil
$perfil = $u['perf_descripcion'];
$modulo = $u['modu_descripcion'];
$sql = "select 
         g.gui_descripcion as interfaz, 
         perfgui_estado as estado 
      from perfil_gui pg
         join perfil p on p.perf_codigo=pg.perf_codigo
         join gui g on g.gui_codigo=pg.gui_codigo
         and g.modu_codigo=pg.modu_codigo
      where p.perf_descripcion='$perfil'
      order by pg.perfgui_codigo";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

//definimos los guis a mostrar
$referencialesCompra = false;
$referencialesVenta = false;
$referencialesProduccion = false;
$referencialesSeguridad = false;
$pedidoCompra = false;
$presupuestoProveedor = false;
$ordenCompra = false;
$compra = false;
$notaCompra = false;
$ajusteInventario = false;
$pedidoProduccion = false;
$presupuestoProduccion = false;
$componenteProduccion = false;
$ordenProduccion = false;
$produccion = false;
$etapaProduccion = false;
$controlCalidad = false;
$produccionTerminada = false;
$mermas = false;
$costoProduccion = false;
$pedidoVenta = false;
$aperturaCierre = false;
$venta = false;
$cobro = false;
$notaVenta = false;
$reporteReferencialCompras = false;
$reporteReferencialProduccion = false;
$reporteReferencialVentas = false;
$reporteReferencialSeguridad = false;
$reporteMovimientoCompras = false;
$reporteMovimientoProduccion = false;
$reporteMovimientoVentas = false;

$guis = [
   'REFERENCIALES COMPRA' => 'referencialesCompra',
   'REFERENCIALES PRODUCCION' => 'referencialesProduccion',
   'REFERENCIALES VENTA' => 'referencialesVenta',
   'REFERENCIALES SEGURIDAD' => 'referencialesSeguridad',
   'PEDIDO COMPRA' => 'pedidoCompra',
   'PRESUPUESTO PROVEEDOR' => 'presupuestoProveedor',
   'ORDEN COMPRA' => 'ordenCompra',
   'COMPRA' => 'compra',
   'NOTA COMPRA' => 'notaCompra',
   'AJUSTE INVENTARIO' => 'ajusteInventario',
   'PEDIDO PRODUCCION' => 'pedidoProduccion',
   'PRESUPUESTO PRODUCCION' => 'presupuestoProduccion',
   'ORDEN PRODUCCION' => 'ordenProduccion',
   'PRODUCCION' => 'produccion',
   'COMPONENTE PRODUCCION' => 'componenteProduccion',
   'ETAPA PRODUCCION' => 'etapaProduccion',
   'CONTROL CALIDAD' => 'controlCalidad',
   'PRODUCCION TERMINADA' => 'produccionTerminada',
   'MERMAS' => 'mermas',
   'COSTO PRODUCCION' => 'costoProduccion',
   'PEDIDO VENTA' => 'pedidoVenta',
   'APERTURA CIERRE' => 'aperturaCierre',
   'VENTA' => 'venta',
   'COBRO' => 'cobro',
   'NOTA VENTA' => 'notaVenta',
   'REPORTE REFERENCIAL COMPRAS' => 'reporteReferencialCompras',
   'REPORTE MOVIMIENTO COMPRAS' => 'reporteMovimientoCompras',
   'REPORTE REFERENCIAL PRODUCCION' => 'reporteReferencialProduccion',
   'REPORTE MOVIMIENTO PRODUCCION' => 'reporteMovimientoProduccion',
   'REPORTE REFERENCIAL VENTAS' => 'reporteReferencialVentas',
   'REPORTE MOVIMIENTO VENTAS ' => 'reporteMovimientoVentas',
   'REPORTE REFERENCIAL SEGURIDAD' => 'reporteReferencialSeguridad',
];

//show movements
foreach ($datos as $dato) {
   if ((array_key_exists($dato['interfaz'], $guis)) && ($dato['estado'] == 'ACTIVO')) {
      $variableGUI = strval($guis[$dato['interfaz']]);
      $$variableGUI = true;
   }
}

//show movements of the sales
$apertura = ['numero' => 0, 'habilitado' => '', 'numero_caja' => 0, 'caja' => ''];
if (isset($_SESSION['apertura'])) {
   $apertura = [
      'numero' => $_SESSION['apertura']['numero'],
      'habilitado' => $_SESSION['apertura']['habilitado'],
      'numero_caja' => $_SESSION['apertura']['numero_caja'],
      'caja' => $_SESSION['apertura']['caja']
   ];
}

?>
<!-- Page Loader -->
<div class="page-loader-wrapper">
   <div class="loader">
      <div class="preloader">
         <div class="spinner-layer pl-red">
            <div class="circle-clipper left">
               <div class="circle"></div>
            </div>
            <div class="circle-clipper right">
               <div class="circle"></div>
            </div>
         </div>
      </div>
      <p>Cargando...</p>
   </div>
</div>
<!-- #END# Page Loader -->
<!-- Overlay For Sidebars -->
<div class="overlay"></div>
<!-- #END# Overlay For Sidebars -->
<!-- Search Bar -->
<div class="search-bar">
   <div class="search-icon">
      <i class="material-icons">search</i>
   </div>
   <!-- Asignamos un metodo al input para consultar la interfaz a ingresar -->
   <input type="text" placeholder="Busque la interfaz a la cual acceder" id="busquedaMenu" onkeyup="getListaMenu()">
   <div id="listaBusquedaMenu" style="display: none;">
      <ul class="list-group" id="ulBsquedaMenu" Style="height: 100px; overflow: auto"></ul>
   </div>
   <div class="close-search">
      <i class="material-icons" onclick="vaciarLista()">close</i>
   </div>
</div>
<!-- #END# Search Bar -->
<!-- Top Bar -->
<nav class="navbar">
   <div class="container-fluid">
      <div class="navbar-header">
         <a href="javascript:void(0);" class="navbar-toggle collapsed" data-toggle="collapse"
            data-target="#navbar-collapse" aria-expanded="false"></a>
         <a href="javascript:void(0);" class="bars"></a>
         <a class="navbar-brand" href="/sys8DD/menu.php">8 de Diciembre Confecciones</a>
      </div>
      <div class="collapse navbar-collapse" id="navbar-collapse">
         <ul class="nav navbar-nav navbar-right">
            <!-- Call Search -->
            <li><a href="javascript:void(0);" class="js-search" data-close="true"><i
                     class="material-icons">search</i></a></li>
            <!-- #END# Call Search -->
            <!-- Notifications -->
            <li class="dropdown">
               <!-- <a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown" role="button">
                  <i class="material-icons">notifications</i>
                  <span class="label-count">7</span>
               </a> -->
               <ul class="dropdown-menu">
                  <li class="header">NOTIFICATIONS</li>
                  <li class="body">
                     <ul class="menu">
                        <li>
                           <a href="javascript:void(0);">
                              <div class="icon-circle bg-light-green">
                                 <i class="material-icons">person_add</i>
                              </div>
                              <div class="menu-info">
                                 <h4>12 new members joined</h4>
                                 <p>
                                    <i class="material-icons">access_time</i> 14 mins ago
                                 </p>
                              </div>
                           </a>
                        </li>
                        <li>
                           <a href="javascript:void(0);">
                              <div class="icon-circle bg-cyan">
                                 <i class="material-icons">add_shopping_cart</i>
                              </div>
                              <div class="menu-info">
                                 <h4>4 sales made</h4>
                                 <p>
                                    <i class="material-icons">access_time</i> 22 mins ago
                                 </p>
                              </div>
                           </a>
                        </li>
                        <li>
                           <a href="javascript:void(0);">
                              <div class="icon-circle bg-red">
                                 <i class="material-icons">delete_forever</i>
                              </div>
                              <div class="menu-info">
                                 <h4><b>Nancy Doe</b> deleted account</h4>
                                 <p>
                                    <i class="material-icons">access_time</i> 3 hours ago
                                 </p>
                              </div>
                           </a>
                        </li>
                        <li>
                           <a href="javascript:void(0);">
                              <div class="icon-circle bg-orange">
                                 <i class="material-icons">mode_edit</i>
                              </div>
                              <div class="menu-info">
                                 <h4><b>Nancy</b> changed name</h4>
                                 <p>
                                    <i class="material-icons">access_time</i> 2 hours ago
                                 </p>
                              </div>
                           </a>
                        </li>
                        <li>
                           <a href="javascript:void(0);">
                              <div class="icon-circle bg-blue-grey">
                                 <i class="material-icons">comment</i>
                              </div>
                              <div class="menu-info">
                                 <h4><b>John</b> commented your post</h4>
                                 <p>
                                    <i class="material-icons">access_time</i> 4 hours ago
                                 </p>
                              </div>
                           </a>
                        </li>
                        <li>
                           <a href="javascript:void(0);">
                              <div class="icon-circle bg-light-green">
                                 <i class="material-icons">cached</i>
                              </div>
                              <div class="menu-info">
                                 <h4><b>John</b> updated status</h4>
                                 <p>
                                    <i class="material-icons">access_time</i> 3 hours ago
                                 </p>
                              </div>
                           </a>
                        </li>
                        <li>
                           <a href="javascript:void(0);">
                              <div class="icon-circle bg-purple">
                                 <i class="material-icons">settings</i>
                              </div>
                              <div class="menu-info">
                                 <h4>Settings updated</h4>
                                 <p>
                                    <i class="material-icons">access_time</i> Yesterday
                                 </p>
                              </div>
                           </a>
                        </li>
                     </ul>
                  </li>
                  <li class="footer">
                     <a href="javascript:void(0);">View All Notifications</a>
                  </li>
               </ul>
            </li>
            <!-- #END# Notifications -->
            <!-- Tasks -->
            <li class="dropdown">
               <!-- <a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown" role="button">
                  <i class="material-icons">flag</i>
                  <span class="label-count">9</span>
               </a> -->
               <ul class="dropdown-menu">
                  <li class="header">TASKS</li>
                  <li class="body">
                     <ul class="menu tasks">
                        <li>
                           <a href="javascript:void(0);">
                              <h4>
                                 Footer display issue
                                 <small>32%</small>
                              </h4>
                              <div class="progress">
                                 <div class="progress-bar bg-pink" role="progressbar" aria-valuenow="85"
                                    aria-valuemin="0" aria-valuemax="100" style="width: 32%">
                                 </div>
                              </div>
                           </a>
                        </li>
                        <li>
                           <a href="javascript:void(0);">
                              <h4>
                                 Make new buttons
                                 <small>45%</small>
                              </h4>
                              <div class="progress">
                                 <div class="progress-bar bg-cyan" role="progressbar" aria-valuenow="85"
                                    aria-valuemin="0" aria-valuemax="100" style="width: 45%">
                                 </div>
                              </div>
                           </a>
                        </li>
                        <li>
                           <a href="javascript:void(0);">
                              <h4>
                                 Create new dashboard
                                 <small>54%</small>
                              </h4>
                              <div class="progress">
                                 <div class="progress-bar bg-teal" role="progressbar" aria-valuenow="85"
                                    aria-valuemin="0" aria-valuemax="100" style="width: 54%">
                                 </div>
                              </div>
                           </a>
                        </li>
                        <li>
                           <a href="javascript:void(0);">
                              <h4>
                                 Solve transition issue
                                 <small>65%</small>
                              </h4>
                              <div class="progress">
                                 <div class="progress-bar bg-orange" role="progressbar" aria-valuenow="85"
                                    aria-valuemin="0" aria-valuemax="100" style="width: 65%">
                                 </div>
                              </div>
                           </a>
                        </li>
                        <li>
                           <a href="javascript:void(0);">
                              <h4>
                                 Answer GitHub questions
                                 <small>92%</small>
                              </h4>
                              <div class="progress">
                                 <div class="progress-bar bg-purple" role="progressbar" aria-valuenow="85"
                                    aria-valuemin="0" aria-valuemax="100" style="width: 92%">
                                 </div>
                              </div>
                           </a>
                        </li>
                     </ul>
                  </li>
                  <li class="footer">
                     <a href="javascript:void(0);">View All Tasks</a>
                  </li>
               </ul>
            </li>
            <!-- #END# Tasks -->
            <!-- <li class="pull-right"><a href="javascript:void(0);" class="js-right-sidebar" data-close="true"><i
                     class="material-icons">more_vert</i></a></li> -->
         </ul>
      </div>
   </div>
</nav>
<!-- #Top Bar -->
<section>
   <!-- Left Sidebar -->
   <aside id="leftsidebar" class="sidebar">
      <!-- User Info -->
      <div class="user-info">
         <div class="image">
            <img src="/sys8DD/images/user.png" width="48" height="48" alt="User" />
         </div>
         <div class="info-container">
            <div class="name" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
               <?php echo $u['per_nombre'] . " " . $u['per_apellido'] ?>
            </div>
            <div class="email">
               <?php echo $u['per_email'] ?>
            </div>

            <div class="btn-group user-helper-dropdown">
               <i class="material-icons" data-toggle="dropdown" aria-haspopup="true"
                  aria-expanded="true">keyboard_arrow_down</i>
               <ul class="dropdown-menu pull-right">
                  <li><a href="javascript:void(0);"><i class="material-icons">person</i>Perfil</a></li>
                  <li role="separator" class="divider"></li>
                  <li><a href="javascript:void(0);"><i class="material-icons">group</i>
                        <?php echo $u['perf_descripcion'] ?>
                     </a></li>
                  <li><a href="javascript:void(0);"><i class="material-icons">shopping_cart</i>
                        <?php echo $u['suc_descripcion'] ?>
                     </a></li>
                  <li role="separator" class="divider"></li>
                  <li><a href="/sys8DD/index.php"><i class="material-icons">input</i>Salir</a></li>
               </ul>
            </div>
         </div>
      </div>
      <!-- #User Info -->
      <!-- Menu -->
      <div class="menu">
         <ul class="list">
            <li class="header">Menu de Navegacion</li>
            <li>
               <a href="/sys8DD/menu.php">
                  <i class="material-icons">home</i>
                  <span>Inicio</span>
               </a>
            </li>
            <!-- -------------------------------------------------------------------------------- -->
            <!-- OPCIONES DE REFERENCIALES -->
            <?php if ($u['modu_descripcion'] == "SISTEMA") { ?>
               <li>
                  <a href="javascript:void(0);" class="menu-toggle">
                     <i class="material-icons">perm_identity</i>
                     <span>Referenciales</span>
                  </a>
                  <ul class="ml-menu">
                     <?php if ($referencialesCompra === true) { ?>
                        <li>
                           <a href="javascript:void(0);" class="menu-toggle">
                              <span>Compras</span>
                           </a>
                           <ul class="ml-menu">
                              <li>
                                 <a href="/sys8DD/referenciales/compra/ciudad/index.php">Ciudad</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/compra/empresa/index.php">Empresa</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/compra/sucursal/index.php">Sucursal</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/compra/tipo_impuesto/index.php">Tipo Impuesto</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/compra/tipo_proveedor/index.php">Tipo Proveedor</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/compra/tipo_item/index.php">Tipo Item</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/compra/proveedor/index.php">Proveedor</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/compra/deposito/index.php">Deposito</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/compra/items/index.php">Items</a>
                              </li>
                           </ul>
                        </li>
                     <?php } ?>
                     <?php if ($referencialesProduccion === true) { ?>
                        <li>
                           <a href="javascript:void(0);" class="menu-toggle">
                              <span>Produccion</span>
                           </a>
                           <ul class="ml-menu">
                              <li>
                                 <a href="/sys8DD/referenciales/produccion/cargo/index.php">Cargo</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/produccion/personas/index.php">Personas</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/produccion/funcionario/index.php">Funcionario</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/produccion/talle/index.php">Talle</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/produccion/color_prenda/index.php">Color Prenda</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/produccion/modelo/index.php">Modelo</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/produccion/maquinaria/index.php">Maquinaria</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/produccion/tipo_etapa_produccion/index.php">Tipo Etapa
                                    Produccion</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/produccion/unidad_medida/index.php">Unidad Medida</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/produccion/parametro_control_calidad/index.php">Parametros
                                    Control Calidad</a>
                              </li>
                              <!-- <li>
                                                      <a href="/sys8DD/referenciales/produccion/costo_servicio/index.php">Costo Servicio</a>
                                                   </li> -->
                              <li>
                                 <a href="/sys8DD/referenciales/produccion/seccion/index.php">Seccion</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/produccion/equipo_trabajo/index.php">Equipo Trabajo</a>
                              </li>
                           </ul>
                        </li>
                     <?php } ?>
                     <?php if ($referencialesVenta === true) { ?>
                        <li>
                           <a href="javascript:void(0);" class="menu-toggle">
                              <span>Ventas</span>
                           </a>
                           <ul class="ml-menu">
                              <li>
                                 <a href="/sys8DD/referenciales/venta/tipo_documento/index.php">Tipo Documento</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/venta/tipo_comprobante/index.php">Tipo Comprobante</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/venta/timbrados/index.php">Timbrados</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/venta/forma_cobro/index.php">Forma Cobro</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/venta/marca_tarjeta/index.php">Marca Tarjeta</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/venta/red_pago/index.php">Red Pago</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/venta/entidad_emisora/index.php">Entidad Emisora</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/venta/entidad_adherida/index.php">Entidad Adherida</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/venta/caja/index.php">Caja</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/venta/clientes/index.php">Clientes</a>
                              </li>
                           </ul>
                        </li>
                     <?php } ?>
                     <?php if ($referencialesSeguridad === true) { ?>
                        <li>
                           <a href="javascript:void(0);" class="menu-toggle">
                              <span>Seguridad</span>
                           </a>
                           <ul class="ml-menu">
                              <li>
                                 <a href="/sys8DD/referenciales/seguridad/modulo/index.php">Modulo</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/seguridad/permisos/index.php">Permisos</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/seguridad/perfil/index.php">Perfil</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/seguridad/gui/index.php">GUI</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/seguridad/perfiles_permisos/index.php">Perfiles Permisos</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/seguridad/perfil_gui/index.php">Perfil GUI</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/seguridad/usuario/index.php">Usuario</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/seguridad/asignacion_permiso_usuario/index.php">Asignacion
                                    Permiso Usuario</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/seguridad/configuraciones/index.php">Configuraciones
                                    Interfaz</a>
                              </li>
                              <li>
                                 <a href="/sys8DD/referenciales/seguridad/configuraciones_sucursal/index.php">Configuraciones
                                    Interfaz Sucursal</a>
                              </li>
                           </ul>
                        </li>
                     <?php } ?>
                  </ul>
               </li>
            <?php } ?>

            <!-- OPCIONES DE COMPRAS -->
            <?php if ($u['modu_descripcion'] == "COMPRAS" || $u['modu_descripcion'] == "SISTEMA" || ($u['perf_codigo'] == "5")) { ?>
               <li>
                  <a href="javascript:void(0);" class="menu-toggle">
                     <i class="material-icons">shopping_basket</i>
                     <span>Compras</span>
                  </a>
                  <ul class="ml-menu">
                     <?php if ($pedidoCompra === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/compra/pedido_compra/index.php">Pedido Compra</a>
                        </li>
                     <?php } ?>
                     <?php if ($presupuestoProveedor === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/compra/presupuesto_proveedor/index.php">Presupuesto Proveedor</a>
                        </li>
                     <?php } ?>
                     <?php if ($ordenCompra === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/compra/orden_compra/index.php">Orden Compra</a>
                        </li>
                     <?php } ?>
                     <?php if ($compra === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/compra/compra/index.php">Compra</a>
                        </li>
                     <?php } ?>
                     <?php if ($ajusteInventario === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/compra/ajuste_stock/index.php">Ajuste Stock</a>
                        </li>
                     <?php } ?>
                     <?php if ($notaCompra === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/compra/nota_compra/index.php">Nota Compra</a>
                        </li>
                     <?php } ?>
                  </ul>
               </li>
            <?php } ?>

            <!-- OPCIONES DE PRODUCCION -->
            <?php if ($u['modu_descripcion'] == "PRODUCCION" || $u['modu_descripcion'] == "SISTEMA") { ?>
               <li>
                  <a href="javascript:void(0);" class="menu-toggle">
                     <i class="material-icons">work</i>
                     <span>Produccion</span>
                  </a>
                  <ul class="ml-menu">
                     <?php if ($pedidoProduccion === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/pedido_produccion/index.php">Pedido Produccion</a>
                        </li>
                     <?php } ?>
                     <?php if ($presupuestoProduccion === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/presupuesto/index.php">Presupuesto</a>
                        </li>
                     <?php } ?>
                     <?php if ($componenteProduccion === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/componente_produccion/index.php">Componente Produccion</a>
                        </li>
                     <?php } ?>
                     <?php if ($ordenProduccion === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/orden_produccion/index.php">Orden Produccion</a>
                        </li>
                     <?php } ?>
                     <?php if ($produccion === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/produccion/index.php">Produccion</a>
                        </li>
                     <?php } ?>
                     <?php if ($etapaProduccion === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/etapa_produccion/index.php">Etapa Produccion</a>
                        </li>
                     <?php } ?>
                     <?php if ($produccionTerminada === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/produccion_terminada/index.php">Produccion Terminada</a>
                        </li>
                     <?php } ?>
                     <?php if ($controlCalidad === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/control_calidad/index.php">Control Calidad</a>
                        </li>
                     <?php } ?>
                     <?php if ($mermas === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/mermas/index.php">Mermas</a>
                        </li>
                     <?php } ?>
                     <?php if ($costoProduccion === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/costo_produccion/index.php">Costo Produccion</a>
                        </li>
                     <?php } ?>
                  </ul>
               </li>
            <?php } ?>


            <!-- OPCIONES DE VENTAS -->
            <?php if ($u['modu_descripcion'] == "VENTAS" || $u['modu_descripcion'] == "SISTEMA") { ?>
               <li>
                  <a href="javascript:void(0);" class="menu-toggle">
                     <i class="material-icons">add_shopping_cart</i>
                     <span>Ventas</span>
                  </a>
                  <ul class="ml-menu">
                     <?php if ($pedidoVenta === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/venta/pedido_venta/index.php">Pedido Venta</a>
                        </li>
                     <?php } ?>
                     <?php if ($aperturaCierre === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/venta/apertura_cierre/index.php">Apertura Cierre</a>
                        </li>
                     <?php } ?>
                     <?php if ($venta === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/venta/venta/index.php">Venta</a>
                        </li>
                     <?php } ?>
                     <?php if ($cobro === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/venta/cobros/index.php">Cobro</a>
                        </li>
                     <?php } ?>
                     <?php if ($notaVenta === true) { ?>
                        <li>
                           <a href="/sys8DD/modulos/venta/nota_venta/index.php">Nota Venta</a>
                        </li>
                     <?php } ?>
                  </ul>
               </li>
            <?php } ?>

            <!-- Informes -->
            <li>
               <a href="javascript:void(0);" class="menu-toggle">
                  <i class="material-icons">description</i>
                  <span>Informes</span>
               </a>
               <ul class="ml-menu">
                  <?php if ($reporteReferencialCompras == true) { ?>
                     <li>
                        <a href="/sys8DD/report/compras/informe_referencial.php">Informes Referenciales Compras</a>
                     </li>
                  <?php } ?>

                  <?php if ($reporteReferencialProduccion == true) { ?>
                     <li>
                        <a href="/sys8DD/report/produccion/informe_referencial.php">Informes Referenciales Produccion</a>
                     </li>
                  <?php } ?>
                  <?php if ($reporteReferencialVentas == true) { ?>
                     <li>
                        <a href="/sys8DD/report/ventas/informe_referencial.php">Informes Referenciales Ventas</a>
                     </li>
                  <?php } ?>
                  <?php if ($reporteReferencialSeguridad == true) { ?>
                     <li>
                        <a href="/sys8DD/report/seguridad/informe_referencial.php">Informes Seguridad</a>
                     </li>
                  <?php } ?>
                  <?php if ($reporteMovimientoCompras == true) { ?>
                     <li>
                        <a href="/sys8DD/report/compras/informe_movimiento.php">Informes Compras</a>
                     </li>
                  <?php } ?>
                  <?php if ($reporteMovimientoProduccion == true) { ?>
                     <li>
                        <a href="/sys8DD/report/produccion/informe_movimiento.php">Informes Producción</a>
                     </li>
                  <?php } ?>
                  <?php if ($reporteMovimientoVentas == true) { ?>
                     <li>
                        <a href="/sys8DD/report/ventas/informe_movimiento.php">Informes Ventas</a>
                     </li>
                  <?php } ?>
               </ul>
            </li>

            <!-- <li class="header">LABELS</li>
            <li>
               <a href="javascript:void(0);">
                  <i class="material-icons col-red">donut_large</i>
                  <span>Important</span>
               </a>
            </li>
            <li>
               <a href="javascript:void(0);">
                  <i class="material-icons col-amber">donut_large</i>
                  <span>Warning</span>
               </a>
            </li>
            <li>
               <a href="javascript:void(0);">
                  <i class="material-icons col-light-blue">donut_large</i>
                  <span>Information</span>
               </a>
            </li> -->
         </ul>
      </div>
      <!-- #Menu -->
      <!-- Footer -->
      <div class="legal">
         <!-- <div class="copyright">
            &copy; 2016 - 2017 <a href="javascript:void(0);">AdminBSB - Material Design</a>.
         </div>
         <div class="version">
            <b>Version: </b> 1.0.5
         </div> -->
         <div class="copyright">
            &copy; 2021 - 2025 <a href="javascript:void(0);">8 de Diciembre - Confecciones</a>.
         </div>
         <div class="version">
            <b>Version: </b> 0.0.3
         </div>
      </div>
      <!-- #Footer -->
   </aside>
   <!-- #END# Left Sidebar -->
   <!-- Right Sidebar -->
   <aside id="rightsidebar" class="right-sidebar">
      <ul class="nav nav-tabs tab-nav-right" role="tablist">
         <li role="presentation" class="active"><a href="#skins" data-toggle="tab">SKINS</a></li>
         <li role="presentation"><a href="#settings" data-toggle="tab">SETTINGS</a></li>
      </ul>
      <div class="tab-content">
         <div role="tabpanel" class="tab-pane fade in active in active" id="skins">
            <ul class="demo-choose-skin">
               <li data-theme="red" class="active">
                  <div class="red"></div>
                  <span>Red</span>
               </li>
               <li data-theme="pink">
                  <div class="pink"></div>
                  <span>Pink</span>
               </li>
               <li data-theme="purple">
                  <div class="purple"></div>
                  <span>Purple</span>
               </li>
               <li data-theme="deep-purple">
                  <div class="deep-purple"></div>
                  <span>Deep Purple</span>
               </li>
               <li data-theme="indigo">
                  <div class="indigo"></div>
                  <span>Indigo</span>
               </li>
               <li data-theme="blue">
                  <div class="blue"></div>
                  <span>Blue</span>
               </li>
               <li data-theme="light-blue">
                  <div class="light-blue"></div>
                  <span>Light Blue</span>
               </li>
               <li data-theme="cyan">
                  <div class="cyan"></div>
                  <span>Cyan</span>
               </li>
               <li data-theme="teal">
                  <div class="teal"></div>
                  <span>Teal</span>
               </li>
               <li data-theme="green">
                  <div class="green"></div>
                  <span>Green</span>
               </li>
               <li data-theme="light-green">
                  <div class="light-green"></div>
                  <span>Light Green</span>
               </li>
               <li data-theme="lime">
                  <div class="lime"></div>
                  <span>Lime</span>
               </li>
               <li data-theme="yellow">
                  <div class="yellow"></div>
                  <span>Yellow</span>
               </li>
               <li data-theme="amber">
                  <div class="amber"></div>
                  <span>Amber</span>
               </li>
               <li data-theme="orange">
                  <div class="orange"></div>
                  <span>Orange</span>
               </li>
               <li data-theme="deep-orange">
                  <div class="deep-orange"></div>
                  <span>Deep Orange</span>
               </li>
               <li data-theme="brown">
                  <div class="brown"></div>
                  <span>Brown</span>
               </li>
               <li data-theme="grey">
                  <div class="grey"></div>
                  <span>Grey</span>
               </li>
               <li data-theme="blue-grey">
                  <div class="blue-grey"></div>
                  <span>Blue Grey</span>
               </li>
               <li data-theme="black">
                  <div class="black"></div>
                  <span>Black</span>
               </li>
            </ul>
         </div>
         <div role="tabpanel" class="tab-pane fade" id="settings">
            <div class="demo-settings">
               <p>GENERAL SETTINGS</p>
               <ul class="setting-list">
                  <li>
                     <span>Report Panel Usage</span>
                     <div class="switch">
                        <label><input type="checkbox" checked><span class="lever"></span></label>
                     </div>
                  </li>
                  <li>
                     <span>Email Redirect</span>
                     <div class="switch">
                        <label><input type="checkbox"><span class="lever"></span></label>
                     </div>
                  </li>
               </ul>
               <p>SYSTEM SETTINGS</p>
               <ul class="setting-list">
                  <li>
                     <span>Notifications</span>
                     <div class="switch">
                        <label><input type="checkbox" checked><span class="lever"></span></label>
                     </div>
                  </li>
                  <li>
                     <span>Auto Updates</span>
                     <div class="switch">
                        <label><input type="checkbox" checked><span class="lever"></span></label>
                     </div>
                  </li>
               </ul>
               <p>ACCOUNT SETTINGS</p>
               <ul class="setting-list">
                  <li>
                     <span>Offline</span>
                     <div class="switch">
                        <label><input type="checkbox"><span class="lever"></span></label>
                     </div>
                  </li>
                  <li>
                     <span>Location Permission</span>
                     <div class="switch">
                        <label><input type="checkbox" checked><span class="lever"></span></label>
                     </div>
                  </li>
               </ul>
            </div>
         </div>
      </div>
   </aside>
   <!-- #END# Right Sidebar -->
</section>