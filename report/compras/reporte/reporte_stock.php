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

$deposito = $_GET['deposito'];

$sql = "select 
            e.emp_razonsocial,
            su.suc_descripcion,
            d.dep_descripcion,
            i.it_descripcion,
            s.st_cantidad,
            um.unime_descripcion
         from stock s
            join items i on i.it_codigo=s.it_codigo 
            and i.tipit_codigo=s.tipit_codigo
            join tipo_item ti on ti.tipit_codigo=i.tipit_codigo 
            join deposito d on d.dep_codigo=s.dep_codigo
            and d.suc_codigo=s.dep_codigo 
            and d.emp_codigo=s.emp_codigo
            join sucursal su on su.suc_codigo=d.suc_codigo 
            and su.emp_codigo=d.emp_codigo
            join empresa e on e.emp_codigo=su.emp_codigo
            join unidad_medida um on um.unime_codigo=s.unime_codigo
            where s.dep_codigo=$deposito
         order by s.it_codigo;";

$resultado = pg_query($conexion, $sql);
$datos = pg_fetch_all($resultado);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Reporte Stock</title>
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

   <h4>LISTA DE STOCK</h4>

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
            <th>EMPRESA</th>
            <th>SUCURSAL</th>
            <th>DEPOSITO</th>
            <th>ITEM</th>
            <th>CANTIDAD</th>
            <th>UNIDAD MEDIDA</th>
         </tr>
      </thead>
      <tbody>
         <?php foreach($datos as $fila) { ?>
            <tr class="fila">
               <td class="celda">
                  <?php echo $fila['emp_razonsocial'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['suc_descripcion'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['dep_descripcion'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['it_descripcion'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['st_cantidad'] ?>
               </td>
               <td class="celda">
                  <?php echo $fila['unime_descripcion'] ?>
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

$dompdf->stream("reporte_stock.pdf", array('Attachment' => false));

?>