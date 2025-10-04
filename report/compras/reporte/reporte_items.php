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
$tipoItem = $_GET['tipoItem'] ?? null;
$descripcion = $_GET['descripcion'] ?? null;
$general = $_GET['general'] ?? null;

// Definimos la consulta principal
$sql = "SELECT 
               i.it_codigo,
               i.it_descripcion,
               i.it_costo,
               i.it_precio,
               i.it_estado,
               ti.tipit_descripcion,
               m.mod_codigomodelo,
               t.tall_descripcion,
               tim.tipim_descripcion,
               um.unime_descripcion,
               i.it_stock_min, 
               i.it_stock_max
            FROM items i
               JOIN tipo_item ti ON ti.tipit_codigo=i.tipit_codigo
               JOIN modelo m ON m.mod_codigo=i.mod_codigo
               JOIN talle t ON t.tall_codigo=i.tall_codigo 
               JOIN tipo_impuesto tim ON tim.tipim_codigo=i.tipim_codigo
               JOIN unidad_medida um ON um.unime_codigo=i.unime_codigo ";

// Array de condiciones
$conditions = [];

if (empty($general)) {
   if (!empty($desde) && !empty($hasta)) {
      $conditions[] = "i.it_codigo BETWEEN $desde AND $hasta";
   } elseif (empty($desde) && !empty($hasta)) {
      $conditions[] = "i.it_codigo BETWEEN 1 AND $hasta";
   } elseif (!empty($desde) && empty($hasta)) {
      $conditions[] = "i.it_codigo BETWEEN $desde AND (SELECT MAX(it_codigo) FROM items)";
   }

   if (!empty($tipoItem)) {
      $conditions[] = "i.tipit_codigo = $tipoItem";
   }

   if (!empty($descripcion)) {
      $conditions[] = "i.it_descripcion ILIKE '%$descripcion%'";
   }
}

// Unimos las condiciones con AND
if (count($conditions) > 0) {
   $sql .= " WHERE " . implode(" AND ", $conditions);
}

// Orden para más consistencia
$sql .= " ORDER BY i.it_codigo";

$resultado = pg_query($conexion, $sql);

$datos = pg_fetch_all($resultado);

// Datos extra sucursal.
$sql2 = "select 
            s.suc_direccion, s.suc_telefono 
         from sucursal s 
         where s.suc_descripcion ilike '%$sucursal%';";

$resultado2 = pg_query($conexion, $sql2);

$datosSucursal = pg_fetch_assoc($resultado2);


?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="es">

<head>
   <meta charset="UTF-8">
   <title>Items</title>
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

      .items {
         border-collapse: collapse;
         width: 100%;
         margin-top: 20px;
      }

      .items th,
      .items td {
         border: 1px solid #000;
         padding: 2px;
         font-size: 8px;
      }

      .items th {
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

   <h2>ITEMS</h2>

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
         <?php if (!empty($tipoItem)) { ?>
            <td>
               <p><b>TIPO ITEM:</b></p>
            </td>
            <td>
               <p class="descripcion"><?php echo $tipoItem ?>
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

   <table class="items">
      <thead>
         <tr>
            <th>CODIGO</th>
            <th>TIPO ITEM</th>
            <th>DESCRIPCION</th>
            <th>TIPO IMPUESTO</th>
            <th>COSTO</th>
            <th>PRECIO</th>
            <th>MODELO</th>
            <th>TALLE</th>
            <th>UNIDAD MEDIDA</th>
            <th>STOCK MINIMO</th>
            <th>STOCK MAXIMO</th>
            <th>ESTADO</th>
         </tr>
      </thead>
      <tbody>
         <?php if (pg_num_rows($resultado) > 0) { ?>
            <?php foreach ($datos as $cantidad_fila => $fila) {
               ?>
               <tr>
                  <td><?php echo $fila['it_codigo'] ?></td>
                  <td><?php echo $fila['tipit_descripcion'] ?></td>
                  <td><?php echo $fila['it_descripcion'] ?></td>
                  <td><?php echo $fila['tipim_descripcion'] ?></td>
                  <td><?php echo $fila['it_costo'] ?></td>
                  <td><?php echo $fila['it_precio'] ?></td>
                  <td><?php echo $fila['mod_codigomodelo'] ?></td>
                  <td><?php echo $fila['tall_descripcion'] ?></td>
                  <td><?php echo $fila['unime_descripcion'] ?></td>
                  <td><?php echo $fila['it_stock_min'] ?></td>
                  <td><?php echo $fila['it_stock_max'] ?></td>
                  <td><?php echo $fila['it_estado'] ?></td>
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

$dompdf->stream("reporte_items.pdf", array('Attachment' => false));

?>