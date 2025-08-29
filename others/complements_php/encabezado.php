<?php

//Consultamos si existe la variable de sesión usuario
if (isset($_SESSION['usuario'])) {

   //si existe, establecemos la variable $u como un array asociativo
   $u = $_SESSION['usuario'];

} else {

   //sino mediante el header redireccionamos al sign in
   header("Location: http://localhost/sys8DD/index.php");
}

// Requerimos la conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Incluimos el archivo de funciones
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/funciones/funciones.php";

// Definimos los GUIs y sus variables clave
$guis = [
   'CIUDAD' => 'ref_ciudad',
   'EMPRESA' => 'ref_empresa',
   'SUCURSAL' => 'ref_sucursal',
   'TIPO IMPUESTO' => 'ref_tipoImpuesto',
   'TIPO PROVEEDOR' => 'ref_tipoProveedor',
   'TIPO ITEM' => 'ref_tipoItem',
   'PROVEEDOR' => 'ref_proveedor',
   'DEPOSITO' => 'ref_deposito',
   'ITEMS' => 'ref_items',
   'CARGO' => 'ref_cargo',
   'PERSONAS' => 'ref_personas',
   'FUNCIONARIO' => 'ref_funcionario',
   'TALLE' => 'ref_talle',
   'COLOR PRENDA' => 'ref_colorPrenda',
   'MODELO' => 'ref_modelo',
   'MAQUINARIA' => 'ref_maquinaria',
   'TIPO ETAPA PRODUCCION' => 'ref_tipoEtapaProduccion',
   'UNIDAD MEDIDA' => 'ref_unidadMedida',
   'PARAMETRO CONTROL CALIDAD' => 'ref_parametroControlCalidad',
   'SECCION' => 'ref_seccion',
   'EQUIPO TRABAJO' => 'ref_equipoTrabajo',
   'TIPO DOCUMENTO' => 'ref_tipoDocumento',
   'TIPO COMPROBANTE' => 'ref_tipoComprobante',
   'TIMBRADOS' => 'ref_timbrados',
   'FORMA COBRO' => 'ref_formaCobro',
   'MARCA TARJETA' => 'ref_marcaTarjeta',
   'RED PAGO' => 'ref_redPago',
   'ENTIDAD EMISORA' => 'ref_entidadEmisora',
   'ENTIDAD ADHERIDA' => 'ref_entidadAdherida',
   'CAJA' => 'ref_caja',
   'CLIENTES' => 'ref_clientes',
   'MODULO' => 'ref_modulo',
   'PERMISOS' => 'ref_permisos',
   'PERFIL' => 'ref_perfil',
   'GUI' => 'ref_gui',
   'PERFILES PERMISOS' => 'ref_perfilesPermisos',
   'PERFIL GUI' => 'ref_perfilGui',
   'USUARIO' => 'ref_usuario',
   'ASIGNACION PERMISO USUARIO' => 'ref_asignacionPermisoUsuario',
   'CONFIGURACIONES' => 'ref_configuraciones',
   'CONFIGURACIONES SUCURSAL' => 'ref_configuracionesSucursal',
   'REFERENCIALES COMPRA' => 'referencialesCompra',
   'REFERENCIALES PRODUCCION' => 'referencialesProduccion',
   'REFERENCIALES VENTA' => 'referencialesVenta',
   'REFERENCIALES SEGURIDAD' => 'referencialesSeguridad',
   'PEDIDO COMPRA' => 'mov_pedidoCompra',
   'PRESUPUESTO PROVEEDOR' => 'mov_presupuestoProveedor',
   'ORDEN COMPRA' => 'mov_ordenCompra',
   'COMPRA' => 'mov_compra',
   'NOTA COMPRA' => 'mov_notaCompra',
   'AJUSTE STOCK' => 'mov_ajusteStock',
   'PEDIDO PRODUCCION' => 'mov_pedidoProduccion',
   'PRESUPUESTO PRODUCCION' => 'mov_presupuestoProduccion',
   'ORDEN PRODUCCION' => 'mov_ordenProduccion',
   'PRODUCCION' => 'mov_produccion',
   'COMPONENTE PRODUCCION' => 'mov_componenteProduccion',
   'ETAPA PRODUCCION' => 'mov_etapaProduccion',
   'CONTROL CALIDAD' => 'mov_controlCalidad',
   'PRODUCCION TERMINADA' => 'mov_produccionTerminada',
   'MERMAS' => 'mov_mermas',
   'COSTO PRODUCCION' => 'mov_costoProduccion',
   'PEDIDO VENTA' => 'mov_pedidoVenta',
   'APERTURA CIERRE' => 'mov_aperturaCierre',
   'VENTA' => 'mov_venta',
   'COBRO' => 'mov_cobro',
   'NOTA VENTA' => 'mov_notaVenta',
   'REPORTE REFERENCIAL COMPRAS' => 'rep_ReferencialCompras',
   'REPORTE MOVIMIENTO COMPRAS' => 'rep_MovimientoCompras',
   'REPORTE REFERENCIAL PRODUCCION' => 'rep_ReferencialProduccion',
   'REPORTE MOVIMIENTO PRODUCCION' => 'rep_MovimientoProduccion',
   'REPORTE REFERENCIAL VENTAS' => 'rep_ReferencialVentas',
   'REPORTE MOVIMIENTO VENTAS ' => 'rep_MovimientoVentas',
   'REPORTE REFERENCIAL SEGURIDAD' => 'rep_ReferencialSeguridad',
];

// Definimos variables globales
$referenciales = false;
$reportes = false;

// Inicializamos permisos dinámicamente
$permisos_interfaz = array_fill_keys(array_values($guis), false);

// Consultamos los GUIs del perfil
$perfil = $u['perf_descripcion'];
$sql = "
   SELECT g.gui_descripcion AS interfaz, perfgui_estado AS estado, g.modu_codigo AS modulo 
   FROM perfil_gui pg
   JOIN perfil p ON p.perf_codigo=pg.perf_codigo
   JOIN gui g ON g.gui_codigo=pg.gui_codigo AND g.modu_codigo=pg.modu_codigo
   WHERE p.perf_descripcion='$perfil'
   ORDER BY pg.perfgui_codigo
";
$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

// Clasificación por módulo
$modulos = [
   1 => [], // Compras
   2 => [], // Ventas
   3 => [], // Producción
   5 => [], // Seguridad
];

// Recorremos los datos obtenidos y asignamos permisos
foreach ($datos as $dato) {
   if (isset($guis[$dato['interfaz']]) && $dato['estado'] === 'ACTIVO') {
      $clave = $guis[$dato['interfaz']];
      $permisos_interfaz[$clave] = true; // habilitamos permiso
      $modulos[$dato['modulo']][] = $clave;
   }
}

// Recorremos los permisos para definir si existen referenciales o reportes habilitados
foreach ($permisos_interfaz as $interfaz => $true_or_false) {
   if ((strpos($interfaz, "ref_") === 0) && $true_or_false === true) {
      $referenciales = true;
   } elseif ((strpos($interfaz, "rep_") === 0) && $true_or_false === true) {
      $reportes = true;
   }
}

//Define los valores de la apertura de caja
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
            <?php if ($referenciales === true) { ?>
               <li>
                  <a href="javascript:void(0);" class="menu-toggle">
                     <i class="material-icons">perm_identity</i>
                     <span>Referenciales</span>
                  </a>
                  <ul class="ml-menu">
                     <?php if (tienePermiso(1, 'ref_')) { ?>
                        <li>
                           <a href="javascript:void(0);" class="menu-toggle">
                              <span>Compras</span>
                           </a>
                           <ul class="ml-menu">
                              <?php if ($permisos_interfaz['ref_ciudad']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/compra/ciudad/index.php">Ciudad</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_empresa']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/compra/empresa/index.php">Empresa</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_sucursal']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/compra/sucursal/index.php">Sucursal</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_tipoImpuesto']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/compra/tipo_impuesto/index.php">Tipo Impuesto</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_tipoProveedor']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/compra/tipo_proveedor/index.php">Tipo Proveedor</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_tipoItem']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/compra/tipo_item/index.php">Tipo Item</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_proveedor']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/compra/proveedor/index.php">Proveedor</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_deposito']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/compra/deposito/index.php">Deposito</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_items']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/compra/items/index.php">Items</a>
                                 </li>
                              <?php } ?>
                           </ul>
                        </li>
                     <?php } ?>
                     <?php if (tienePermiso(3, 'ref_')) { ?>
                        <li>
                           <a href="javascript:void(0);" class="menu-toggle">
                              <span>Produccion</span>
                           </a>
                           <ul class="ml-menu">
                              <?php if ($permisos_interfaz['ref_cargo']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/produccion/cargo/index.php">Cargo</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_personas']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/produccion/personas/index.php">Personas</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_funcionario']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/produccion/funcionario/index.php">Funcionario</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_talle']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/produccion/talle/index.php">Talle</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_colorPrenda']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/produccion/color_prenda/index.php">Color Prenda</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_modelo']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/produccion/modelo/index.php">Modelo</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_maquinaria']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/produccion/maquinaria/index.php">Maquinaria</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_tipoEtapaProduccion']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/produccion/tipo_etapa_produccion/index.php">Tipo Etapa
                                       Produccion</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_unidadMedida']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/produccion/unidad_medida/index.php">Unidad Medida</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_parametroControlCalidad']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/produccion/parametro_control_calidad/index.php">Parametros
                                       Control Calidad</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_seccion']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/produccion/seccion/index.php">Seccion</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_equipoTrabajo']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/produccion/equipo_trabajo/index.php">Equipo Trabajo</a>
                                 </li>
                              <?php } ?>
                           </ul>
                        </li>
                     <?php } ?>
                     <?php if (tienePermiso(2, 'ref_')) { ?>
                        <li>
                           <a href="javascript:void(0);" class="menu-toggle">
                              <span>Ventas</span>
                           </a>
                           <ul class="ml-menu">
                              <?php if ($permisos_interfaz['ref_tipoDocumento']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/venta/tipo_documento/index.php">Tipo Documento</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_tipoComprobante']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/venta/tipo_comprobante/index.php">Tipo Comprobante</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_timbrados']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/venta/timbrados/index.php">Timbrados</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_formaCobro']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/venta/forma_cobro/index.php">Forma Cobro</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_marcaTarjeta']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/venta/marca_tarjeta/index.php">Marca Tarjeta</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_redPago']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/venta/red_pago/index.php">Red Pago</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_entidadEmisora']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/venta/entidad_emisora/index.php">Entidad Emisora</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_entidadAdherida']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/venta/entidad_adherida/index.php">Entidad Adherida</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_caja']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/venta/caja/index.php">Caja</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_clientes']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/venta/clientes/index.php">Clientes</a>
                                 </li>
                              <?php } ?>
                           </ul>
                        </li>
                     <?php } ?>
                     <?php if (tienePermiso(5, 'ref_')) { ?>
                        <li>
                           <a href="javascript:void(0);" class="menu-toggle">
                              <span>Seguridad</span>
                           </a>
                           <ul class="ml-menu">
                              <?php if ($permisos_interfaz['ref_modulo']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/seguridad/modulo/index.php">Modulo</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_permisos']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/seguridad/permisos/index.php">Permisos</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_perfil']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/seguridad/perfil/index.php">Perfil</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_gui']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/seguridad/gui/index.php">GUI</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_perfilesPermisos']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/seguridad/perfiles_permisos/index.php">Perfiles Permisos</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_perfilGui']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/seguridad/perfil_gui/index.php">Perfil GUI</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_usuario']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/seguridad/usuario/index.php">Usuario</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_asignacionPermisoUsuario']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/seguridad/asignacion_permiso_usuario/index.php">Asignacion
                                       Permiso Usuario</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_configuraciones']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/seguridad/configuraciones/index.php">Configuraciones
                                       Interfaz</a>
                                 </li>
                              <?php } ?>
                              <?php if ($permisos_interfaz['ref_configuracionesSucursal']) { ?>
                                 <li>
                                    <a href="/sys8DD/referenciales/seguridad/configuraciones_sucursal/index.php">Configuraciones
                                       Interfaz Sucursal</a>
                                 </li>
                              <?php } ?>
                           </ul>
                        </li>
                     <?php } ?>
                  </ul>
               </li>
            <?php } ?>

            <!-- OPCIONES DE COMPRAS -->
            <?php if (tienePermiso(1, 'mov_')) { ?>
               <li>
                  <a href="javascript:void(0);" class="menu-toggle">
                     <i class="material-icons">shopping_basket</i>
                     <span>Compras</span>
                  </a>
                  <ul class="ml-menu">
                     <?php if ($permisos_interfaz['mov_pedidoCompra']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/compra/pedido_compra/index.php">Pedido Compra</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_presupuestoProveedor']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/compra/presupuesto_proveedor/index.php">Presupuesto Proveedor</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_ordenCompra']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/compra/orden_compra/index.php">Orden Compra</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_compra']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/compra/compra/index.php">Compra</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_ajusteStock']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/compra/ajuste_stock/index.php">Ajuste Stock</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_notaCompra']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/compra/nota_compra/index.php">Nota Compra</a>
                        </li>
                     <?php } ?>
                  </ul>
               </li>
            <?php } ?>

            <!-- OPCIONES DE PRODUCCION -->
            <?php if (tienePermiso(3, 'mov_')) { ?>
               <li>
                  <a href="javascript:void(0);" class="menu-toggle">
                     <i class="material-icons">work</i>
                     <span>Producción</span>
                  </a>
                  <ul class="ml-menu">
                     <?php if ($permisos_interfaz['mov_presupuestoProduccion']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/presupuesto/index.php">Presupuesto</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_componenteProduccion']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/componente_produccion/index.php">Componente Produccion</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_ordenProduccion']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/orden_produccion/index.php">Orden Produccion</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_produccion']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/produccion/index.php">Produccion</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_etapaProduccion']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/etapa_produccion/index.php">Etapa Produccion</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_produccionTerminada']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/produccion_terminada/index.php">Produccion Terminada</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_controlCalidad']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/control_calidad/index.php">Control Calidad</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_mermas']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/mermas/index.php">Mermas</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_costoProduccion']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/produccion/costo_produccion/index.php">Costo Produccion</a>
                        </li>
                     <?php } ?>
                  </ul>
               </li>
            <?php } ?>


            <!-- OPCIONES DE VENTAS -->
            <?php if (tienePermiso(2, 'mov_')) { ?>
               <li>
                  <a href="javascript:void(0);" class="menu-toggle">
                     <i class="material-icons">add_shopping_cart</i>
                     <span>Ventas</span>
                  </a>
                  <ul class="ml-menu">
                     <?php if ($permisos_interfaz['mov_pedidoVenta']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/venta/pedido_venta/index.php">Pedido Venta</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_aperturaCierre']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/venta/apertura_cierre/index.php">Apertura, Arqueo Control y Cierre</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_venta']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/venta/venta/index.php">Venta</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_cobro']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/venta/cobros/index.php">Cobro</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['mov_notaVenta']) { ?>
                        <li>
                           <a href="/sys8DD/modulos/venta/nota_venta/index.php">Nota Venta</a>
                        </li>
                     <?php } ?>
                  </ul>
               </li>
            <?php } ?>

            <!-- Informes -->
            <?php if ($reportes === true) { ?>
               <li>
                  <a href="javascript:void(0);" class="menu-toggle">
                     <i class="material-icons">description</i>
                     <span>Informes</span>
                  </a>
                  <ul class="ml-menu">
                     <?php if ($permisos_interfaz['rep_ReferencialCompras']) { ?>
                        <li>
                           <a href="/sys8DD/report/compras/informe_referencial.php">Informes Referenciales Compras</a>
                        </li>
                     <?php } ?>

                     <?php if ($permisos_interfaz['rep_ReferencialProduccion']) { ?>
                        <li>
                           <a href="/sys8DD/report/produccion/informe_referencial.php">Informes Referenciales Produccion</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['rep_ReferencialVentas']) { ?>
                        <li>
                           <a href="/sys8DD/report/ventas/informe_referencial.php">Informes Referenciales Ventas</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['rep_ReferencialSeguridad']) { ?>
                        <li>
                           <a href="/sys8DD/report/seguridad/informe_referencial.php">Informes Seguridad</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['rep_MovimientoCompras']) { ?>
                        <li>
                           <a href="/sys8DD/report/compras/informe_movimiento.php">Informes Compras</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['rep_MovimientoProduccion']) { ?>
                        <li>
                           <a href="/sys8DD/report/produccion/informe_movimiento.php">Informes Producción</a>
                        </li>
                     <?php } ?>
                     <?php if ($permisos_interfaz['rep_MovimientoVentas']) { ?>
                        <li>
                           <a href="/sys8DD/report/ventas/informe_movimiento.php">Informes Ventas</a>
                        </li>
                     <?php } ?>
                  </ul>
               </li>
            <?php } ?>

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