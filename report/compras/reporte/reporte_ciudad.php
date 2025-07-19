<?php

//Iniciamos sesion
session_start();

//Guardamos datos de la sesion
$usuario = $_SESSION['usuario']['usu_login'];
$perfil = $_SESSION['usuario']['perf_descripcion'];
$modulo = $_SESSION['usuario']['modu_descripcion'];

$fechaActual = date('d-m-Y');

//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Definimos la sentencia SQL a ejecutar
$sql = "select 
            c.ciu_codigo,
            c.ciu_descripcion,
            c.ciu_estado 
         from ciudad c 
         order by c.ciu_codigo;";

//Ejecutamos la consulta
$resultado = pg_query($conexion, $sql);

//Creamos un array de arrays asociativos para almacenar los resultados
$datos = pg_fetch_all($resultado);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Reporte Ciudad</title>
   <style>
      body {
         font-family: Arial, sans-serif;
         margin: 0;
         padding: 0;
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

      .tabla {
         width: 80%;
         margin: 40px auto;
         border-collapse: collapse;
         font-family: Arial, sans-serif;
         box-shadow: 0 2px 8px #009688;
      }

      .tabla caption {
         caption-side: top;
         font-size: 1.3em;
         margin-bottom: 10px;
         font-weight: bold;
         color: #333;
      }

      .tabla th,
      .tabla td {
         border: 1px solid #ddd;
         padding: 12px 16px;
         text-align: left;
      }

      .tabla th {
         background-color: #009688;
         color: #fff;
         text-transform: uppercase;
         font-size: 14px;
      }

      .tabla tr:nth-child(even) {
         background-color: #f9f9f9;
      }
   </style>
</head>

<body>
   <h1>8 DE DICIEMBRE CONFECCIONES</h1>

   <h4>LISTA DE CIUDAD</h4>

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
            <th>CÓDIGO</th>
            <th>DESCRIPCIÓN</th>
            <th>ESTADO</th>
         </tr>
      </thead>
      <tbody>
         <?php foreach ($datos as $fila) { ?>
            <tr>
               <td>
                  <?php echo $fila['ciu_codigo'] ?>
               </td>
               <td>
                  <?php echo $fila['ciu_descripcion'] ?>
               </td>
               <td>
                  <?php echo $fila['ciu_estado'] ?>
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

$dompdf->setPaper('A4', 'portrait'); //portrait -> vertical landscape -> horizontal

$dompdf->render();

$dompdf->stream("reporte_ciudad.pdf", array('Attachment' => false));

?>