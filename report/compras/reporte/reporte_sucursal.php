<?php

//Iniciamos sesion
session_start();

// Definimos datos generales a utilizar en el encabezado
$usuario = $_SESSION['usuario']['usu_login'];
$sucursal = $_SESSION['usuario']['suc_descripcion'];

//Definimos la zona horaria
date_default_timezone_set('America/Asuncion');
$fechaActual = date('d-m-Y');

//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

// Creamos una instanca de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

// Definimos y cargamos las variables
$desde = $_GET['desde'] ?? null;
$hasta = $_GET['hasta'] ?? null;
$ciudad = $_GET['ciudad'] ?? null;
$descripcion = $_GET['descripcion'] ?? null;
$general = $_GET['general'] ?? null;

// Definimos la consulta principal
$sql = "SELECT
            s.suc_codigo,
            s.suc_descripcion,
            s.suc_direccion,
            s.suc_telefono,
            s.suc_estado,
            s.suc_email,
            e.emp_razonsocial,
            c.ciu_descripcion
         FROM sucursal s
            JOIN empresa e ON e.emp_codigo=s.emp_codigo
            JOIN ciudad c ON c.ciu_codigo=s.ciu_codigo";

// Array de condiciones
$conditions = [];

if (empty($general)) {
   if (!empty($desde) && !empty($hasta)) {
      $conditions[] = "s.suc_codigo BETWEEN $desde AND $hasta";
   } elseif (empty($desde) && !empty($hasta)) {
      $conditions[] = "s.suc_codigo BETWEEN 1 AND $hasta";
   } elseif (!empty($desde) && empty($hasta)) {
      $conditions[] = "s.suc_codigo BETWEEN $desde AND (SELECT MAX(suc_codigo) FROM sucursal)";
   }

   if (!empty($ciudad)) {
      $conditions[] = "s.ciu_codigo = $ciudad";
   }

   if (!empty($descripcion)) {
      $conditions[] = "s.suc_descripcion ILIKE '%$descripcion%'";
   }
}

// Unimos las condiciones con AND
if (count($conditions) > 0) {
   $sql .= " WHERE " . implode(" AND ", $conditions);
}

// Orden para más consistencia
$sql .= " ORDER BY s.suc_codigo";

$resultado = pg_query($conexion, $sql);

$datos = pg_fetch_all($resultado);

// Datos extra sucursal.
$sql2 = "select 
            s.suc_direccion, s.suc_telefono 
         from sucursal s 
         where s.suc_descripcion ilike '%$sucursal%';";

$resultado2 = pg_query($conexion, $sql2);

$datosSucursal = pg_fetch_assoc($resultado2);

// Datos extra ciudad.
if (!empty($ciudad)) {

   $sql3 = "select 
               ciu_descripcion 
            from ciudad  
            where ciu_codigo = $ciudad;";

   $resultado3 = pg_query($conexion, $sql3);

   $datosCiudad = pg_fetch_assoc($resultado3);
}


?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="es">

<head>
   <meta charset="UTF-8">
   <title>Sucursal</title>
   <style>
      body {
         font-family: Arial, Helvetica, sans-serif;
         font-size: 8px;
         margin: 10px;
         color: #000;
      }

      h2 {
         text-align: center;
      }

      .sucursal {
         font-size: 9px;
      }

      .cabecera {
         font-size: 12px;
      }

      .espacio1 {
         width: 55px;
      }

      .descripcion {
         margin-bottom: 13px;
      }

      .sucursal {
         border-collapse: collapse;
         width: 100%;
         margin-top: 20px;
      }

      .sucursal th,
      .sucursal td {
         border: 1px solid #000;
         padding: 2px;
         font-size: 8px;
      }

      .sucursal th {
         background-color: #f0f0f0;
         text-align: center;
      }
   </style>
</head>

<body>
   <p><strong>8 DE DICIEMBRE - <?php echo $sucursal ?></strong></p>
   <p class="sucursal"><strong>Direccion:</strong> <?php echo $datosSucursal['suc_direccion']; ?> </p>
   <p class="sucursal"><strong>Contacto:</strong>
      <?php echo $datosSucursal['suc_telefono']; ?></p>

   <h2>SUCURSAL</h2>

   <hr>

   <table class="cabecera1">
      <tr class=cabecera">
         <td>
            <p><b>USUARIO: </b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $usuario ?>
            </p>
         </td>
         <td class="espacio1"></td>
         <td>
            <p><b>FECHA:</b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $fechaActual ?>
            </p>
         </td>
         <td class="espacio1"></td>
         <?php if (!empty($desde)) { ?>
            <td>
               <p><b>DESDE:</b></p>
            </td>
            <td>
               <p class="descripcion"><?php echo $desde ?>
               </p>
            </td>
         <?php } ?>
         <td class="espacio1"></td>
         <?php if (!empty($hasta)) { ?>
            <td>
               <p><b>HASTA:</b></p>
            </td>
            <td>
               <p class="descripcion"><?php echo $hasta ?>
               </p>
            </td>
         <?php } ?>
         <td class="espacio1"></td>
         <?php if (!empty($ciudad)) { ?>
            <td>
               <p><b>CIUDAD:</b></p>
            </td>
            <td>
               <p class="descripcion"><?php echo $datosCiudad['ciu_descripcion'] ?>
               </p>
            </td>
         <?php } ?>
         <td class="espacio1"></td>
         <?php if (!empty($descripcion)) { ?>
            <td>
               <p><b>DESCRIPCION:</b></p>
            </td>
            <td>
               <p class="descripcion"><?php echo $descripcion ?>
               </p>
            </td>
         <?php } ?>
      </tr>
   </table>

   <hr>

   <table class="sucursal">
      <thead>
         <tr>
            <th>CODIGO</th>
            <th>EMPRESA</th>
            <th>CIUDAD</th>
            <th>DESCRIPCION</th>
            <th>DIRECCION</th>
            <th>TELEFONO</th>
            <th>CORREO</th>
            <th>ESTADO</th>
         </tr>
      </thead>
      <tbody>
         <?php if (pg_num_rows($resultado) > 0) { ?>
            <?php foreach ($datos as $cantidad_fila => $fila) {
               ?>
               <tr>
                  <td><?php echo $fila['suc_codigo'] ?></td>
                  <td><?php echo $fila['emp_razonsocial'] ?></td>
                  <td><?php echo $fila['ciu_descripcion'] ?></td>
                  <td><?php echo $fila['suc_descripcion'] ?></td>
                  <td><?php echo $fila['suc_direccion'] ?></td>
                  <td><?php echo $fila['suc_telefono'] ?></td>
                  <td><?php echo $fila['suc_email'] ?></td>
                  <td><?php echo $fila['suc_estado'] ?></td>
               </tr>
            <?php } ?>
         <?php } else { ?>
            <tr>
               <td colspan="12" style="text-align: center; style=" background-color: #f0f0f0;">NO SE ENCONTRARON REGISTROS
                  PARA MOSTRAR</td>
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

$dompdf->stream("reporte_sucursal.pdf", array('Attachment' => false));

?>