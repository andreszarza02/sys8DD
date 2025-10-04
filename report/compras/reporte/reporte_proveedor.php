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
$tipoProveedor = $_GET['tipoProveedor'] ?? null;
$razonSocial = $_GET['razonSocial'] ?? null;
$general = $_GET['general'] ?? null;

// Definimos la consulta principal
$sql = "SELECT 
               p.pro_codigo, 
               p.pro_razonsocial,
               p.pro_ruc,
               p.pro_timbrado,
               p.pro_direccion,
               p.pro_telefono,
               p.pro_email,
               p.pro_estado,
               tp.tipro_descripcion,
               P.pro_timbrado_venc
          FROM proveedor p 
               JOIN tipo_proveedor tp 
               ON p.tipro_codigo=tp.tipro_codigo";

// Array de condiciones
$conditions = [];

if (empty($general)) {
   if (!empty($desde) && !empty($hasta)) {
      $conditions[] = "p.pro_codigo BETWEEN $desde AND $hasta";
   } elseif (empty($desde) && !empty($hasta)) {
      $conditions[] = "p.pro_codigo BETWEEN 1 AND $hasta";
   } elseif (!empty($desde) && empty($hasta)) {
      $conditions[] = "p.pro_codigo BETWEEN $desde AND (SELECT MAX(pro_codigo) FROM proveedor)";
   }

   if (!empty($tipoProveedor)) {
      $conditions[] = "p.tipro_codigo = $tipoProveedor";
   }

   if (!empty($razonSocial)) {
      $conditions[] = "p.pro_razonsocial ILIKE '%$razonSocial%'";
   }
}

// Unimos las condiciones con AND
if (count($conditions) > 0) {
   $sql .= " WHERE " . implode(" AND ", $conditions);
}

// Orden para más consistencia
$sql .= " ORDER BY p.pro_codigo";

$resultado = pg_query($conexion, $sql);

$datos = pg_fetch_all($resultado);

// Datos extra sucursal.
$sql2 = "select 
            s.suc_direccion, s.suc_telefono 
         from sucursal s 
         where s.suc_descripcion ilike '%$sucursal%';";

$resultado2 = pg_query($conexion, $sql2);

$datosSucursal = pg_fetch_assoc($resultado2);

// Datos extra tipoProveedor.
if (!empty($tipoProveedor)) {

   $sql3 = "select 
               tipro_descripcion 
            from tipo_proveedor  
            where tipro_codigo = $tipoProveedor;";

   $resultado3 = pg_query($conexion, $sql3);

   $datostipoProveedor = pg_fetch_assoc($resultado3);
}


?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="es">

<head>
   <meta charset="UTF-8">
   <title>Proveeedor</title>
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

      .proveedor {
         border-collapse: collapse;
         width: 100%;
         margin-top: 20px;
      }

      .proveedor th,
      .proveedor td {
         border: 1px solid #000;
         padding: 2px;
         font-size: 8px;
      }

      .proveedor th {
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

   <h2>PROVEEDOR</h2>

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
         <?php if (!empty($tipoProveedor)) { ?>
            <td>
               <p><b>TIPO PROVEEDOR:</b></p>
            </td>
            <td>
               <p class="descripcion"><?php echo $datostipoProveedor['tipro_descripcion'] ?>
               </p>
            </td>
         <?php } ?>
         <td class="espacio1"></td>
         <?php if (!empty($razonSocial)) { ?>
            <td>
               <p><b>RAZON SOCIAL:</b></p>
            </td>
            <td>
               <p class="descripcion"><?php echo $razonSocial ?>
               </p>
            </td>
         <?php } ?>
      </tr>
   </table>

   <hr>

   <table class="proveedor">
      <thead>
         <tr>
            <th>CODIGO</th>
            <th>TIPO PROVEEDOR</th>
            <th>RAZON SOCIAL</th>
            <th>RUC</th>
            <th>TIMBRADO</th>
            <th>TIMBRADO VENCIMIENTO</th>
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
                  <td><?php echo $fila['pro_codigo'] ?></td>
                  <td><?php echo $fila['tipro_descripcion'] ?></td>
                  <td><?php echo $fila['pro_razonsocial'] ?></td>
                  <td><?php echo $fila['pro_ruc'] ?></td>
                  <td><?php echo $fila['pro_timbrado'] ?></td>
                  <td><?php echo $fila['pro_timbrado_venc'] ?></td>
                  <td><?php echo $fila['pro_direccion'] ?></td>
                  <td><?php echo $fila['pro_telefono'] ?></td>
                  <td><?php echo $fila['pro_email'] ?></td>
                  <td><?php echo $fila['pro_estado'] ?></td>
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

$dompdf->stream("reporte_proveedor.pdf", array('Attachment' => false));

?>