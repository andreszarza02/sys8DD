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

$sql = "select i.*, ti.tipit_descripcion, m.mod_codigomodelo, t.tall_descripcion, tim.tipim_descripcion  
from items i join tipo_item ti on ti.tipit_codigo=i.tipit_codigo join modelo m on m.mod_codigo=i.mod_codigo
join talle t on t.tall_codigo=i.tall_codigo join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
where i.it_codigo between $desde and $hasta order by i.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Reporte Items</title>
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

   <h4>LISTA DE ITEMS</h4>

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
            <th>DESCRIPCION</th>
            <th>TIPO ITEM</th>
            <th>MODELO</th>
            <th>TALLE</th>
            <th>TIPO IMPUESTO</th>
            <th>COSTO</th>
            <th>PRECIO</th>
            <th>ESTADO</th>
         </tr>
      </thead>
      <tbody>
         <?php foreach ($datos as $fila) { ?>
            <tr class="fila">
               <td class="celda">
                  <?php echo $fila['it_codigo'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['it_descripcion'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['tipit_descripcion'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['mod_codigomodelo'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['tall_descripcion'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['tipim_descripcion'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['it_costo'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['it_precio'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['it_estado'] ?>
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

$dompdf->stream("reporte_items.pdf", array('Attachment' => false));

?>