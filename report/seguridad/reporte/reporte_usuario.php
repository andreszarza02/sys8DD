<?php
//Iniciamos sesion
session_start();
$usuario = $_SESSION['usuario']['usu_login'];
$perfil = $_SESSION['usuario']['perf_descripcion'];
$modulo = $_SESSION['usuario']['modu_descripcion'];

$fechaActual = date('d-m-Y');

//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$desde = $_GET['desde'];
$hasta = $_GET['hasta'];

$sql = "select u.*, m.modu_descripcion, p.perf_descripcion, p2.per_nombre||' '||p2.per_apellido as funcionario from usuario u join modulo m on m.modu_codigo=u.modu_codigo
join perfil p on p.perf_codigo=u.perf_codigo join funcionario f on f.func_codigo=u.func_codigo join personas p2 on p2.per_codigo=f.per_codigo where u.usu_fecha between '$desde' and '$hasta' order by u.usu_codigo";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Reporte Usuario</title>
   <style>
      .tabla {
         border-collapse: collapse;
         width: 100%;
         font-size: 10px;
      }

      th,
      .celda {
         border: 1px solid black;
         padding: 5px;
      }

      th {
         background-color: #009688;
      }

      h1 {
         color: #333;
         font-size: 20px;
         text-align: center;
         text-transform: uppercase;
         letter-spacing: -1px;
         font-family: 'Times New Roman', Times, serif;
      }

      h4 {
         font-weight: bold;
         font-size: 15px;
         text-align: center;
      }

      .usuarioCelda {
         width: 300px;
         font-size: 12px;
      }

      .usuario {
         margin-bottom: 10px;
      }
   </style>
</head>

<body>
   <h1>8 DE DICIEMBRE CONFECCIONES</h1>

   <h4>LISTA DE USUARIOS</h4>

   <table class="usuario">
      <tbody>
         <tr class="usuarioFila">
            <td class="usuarioCelda">
               <b>USUARIO:</b>
               <?php echo $usuario; ?>
            </td>
            <td class="usuarioCelda">
               <b>PERFIL:</b>
               <?php echo $perfil; ?>
            </td>
            <td class="usuarioCelda">
               <b>MÓDULO:</b>
               <?php echo $modulo ?>
            </td>
            <td class="usuarioCelda">
               <b>FECHA:</b>
               <?php echo $fechaActual; ?>
            </td>
         </tr>
      </tbody>
   </table>

   <table class="tabla">
      <thead>
         <tr>
            <th>CODIGO</th>
            <th>USUARIO</th>
            <th>FUNCIONARIO</th>
            <th>MODULO</th>
            <th>PERFIL</th>
            <th>FECHA</th>
            <th>ESTADO</th>
         </tr>
      </thead>
      <tbody>
         <?php foreach ($datos as $fila) { ?>
            <tr class="fila">
               <td class="celda">
                  <?php echo $fila['usu_codigo'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['usu_login'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['funcionario'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['modu_descripcion'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['perf_descripcion'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['usu_fecha'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['usu_estado'] ?>
               </td>
            </tr>
         <?php } ?>
      </tbody>
   </table>
</body>

</html>

<?php

$html = ob_get_clean();

require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/vendor/autoload.php";

use Dompdf\Dompdf;

$dompdf = new Dompdf();

$dompdf->loadHtml($html);

$dompdf->setPaper('A4', 'landscape'); //portrait -> vertical landscape -> horizontal

$dompdf->render();

$dompdf->stream("reporte_usuarios.pdf", array('Attachment' => false));

?>