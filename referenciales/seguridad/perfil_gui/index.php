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
   <title>Perfil GUI</title>

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

            <!-- Formulario Perfil GUI -->
            <div class="col-lg-12 col-md-12 col-sm-12">
               <div class="card">
                  <div class="header">
                     <h2>
                        FORMULARIO DE PERFIL GUI<small>Mantener referencial perfil gui</small>
                     </h2>
                  </div>
                  <div class="body">
                     <input type="hidden" id="operacion" value="0">
                     <input type="hidden" id="procedimiento" value="">
                     <input type="hidden" id="usu_codigo" value="<?php echo $_SESSION['usuario']['usu_codigo']; ?>">
                     <input type="hidden" id="usu_login" value="<?php echo $_SESSION['usuario']['usu_login']; ?>">
                     <input type="hidden" id="perfgui_codigo" value="0">
                     <div class="row clearfix">
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line perf">
                                 <input type="hidden" id="perf_codigo" value="0">
                                 <input type="text" class="form-control no-disabled" id="perf_descripcion" disabled
                                    onkeyup="getPerfil()">
                                 <label class="form-label">Perfil</label>
                                 <div id="listaPerfil" style="display: none;">
                                    <ul class="list-group" id="ulPerfil" Style="height: 100px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line gui">
                                 <input type="hidden" id="gui_codigo" value="0">
                                 <input type="text" class="form-control no-disabled" id="gui_descripcion" disabled
                                    onkeyup="getGUI()">
                                 <label class="form-label">GUI</label>
                                 <div id="listaGUI" style="display: none;">
                                    <ul class="list-group" id="ulGUI" Style="height: 100px; overflow: auto"></ul>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line gui">
                                 <input type="hidden" id="modu_codigo" value="0">
                                 <input type="text" class="form-control" id="modu_descripcion" disabled>
                                 <label class="form-label">Modulo</label>
                              </div>
                           </div>
                        </div>
                        <div class="col-sm-3">
                           <div class="form-group form-float">
                              <div class="form-line est">
                                 <input type="text" class="form-control no-disabled" id="perfgui_estado" disabled>
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
                           <button type="button" class="btn btn-primary waves-effect" onclick="salir()">
                              <i class="material-icons">exit_to_app</i>
                              <span>SALIR</span>
                           </button>
                        </div>
                        <div class="botonesExtra2" style="display: none;">
                           <button type="button" class="btn bg-red waves-effect" onclick="controlVacio()">
                              <i class="material-icons">save</i>
                              <span>GRABAR</span>
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

            <!-- Grilla Perfil Gui -->
            <div id="perfilGui" style="display: block;">
               <div class="col-lg-12 col-md-12 col-sm-12">
                  <div class="card">
                     <div class="header">
                        <h2>
                           PERFILES GUI REGISTRADOS <small>Lista de perfiles gui registrados</small>
                        </h2>
                     </div>
                     <div class="body">
                        <div class="table-responsive">
                           <table class="table table-bordered table-striped table-hover dataTable js-exportable">
                              <thead>
                                 <tr>
                                    <th>PERFIL</th>
                                    <th>GUI</th>
                                    <th>MODULO</th>
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
   </section>

   <!-- referenciamos las librerias a utilizar -->
   <?php include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/link_js.php" ?>

   <!-- JavaScript propio -->
   <script src="metodos.js"></script>

</body>

</html>