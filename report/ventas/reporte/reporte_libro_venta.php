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
$cliente = $_GET['cliente'] ?? null;
$tipo = $_GET['tipo'] ?? null;
$total = 0;
$sin_iva_10 = 0;
$credito_fiscal_10 = 0;
$sin_iva_5 = 0;
$credito_fiscal_5 = 0;
$otros = 0;

// Definimos la consulta principal
$sql = "SELECT * FROM v_reporte_libro_venta vrlv 
         WHERE vrlv.libven_fecha BETWEEN '$desde' AND '$hasta'";

// Agregamos los filtros opcionales solo si vienen con datos
if (!empty($cliente)) {
   $sql .= " AND vrlv.cli_codigo = '$cliente'";
}

if (!empty($tipo)) {
   $sql .= " AND vrlv.tipco_codigo = '$tipo'";
}

$resultado = pg_query($conexion, $sql);

$datos = pg_fetch_all($resultado);

// Datos extra sucursal.
$sql2 = "select 
            s.suc_direccion, s.suc_telefono 
         from sucursal s 
         where s.suc_descripcion ilike '%$sucursal%';";

$resultado2 = pg_query($conexion, $sql2);

$datosSucursal = pg_fetch_assoc($resultado2);

// Modificamos el formato de fecha recibida
$desde = date('d-m-Y', strtotime($desde));
$hasta = date('d-m-Y', strtotime($hasta));


?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="es">

<head>
   <meta charset="UTF-8">
   <title>Libro de Compras</title>
   <style>
      body {
         font-family: Arial, Helvetica, sans-serif;
         font-size: 10px;
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
         width: 99px;
      }

      .descripcion {
         margin-bottom: 13px;
      }

      .libro_venta {
         border-collapse: collapse;
         width: 100%;
         margin-top: 20px;
      }

      .libro_venta th,
      .libro_venta td {
         border: 1px solid #000;
         padding: 2px;
         font-size: 8px;
      }

      .libro_venta th {
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

   <h2>LIBRO DE VENTAS</h2>

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
         <td>
            <p><b>DESDE:</b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $desde ?>
            </p>
         </td>
         <td class="espacio1"></td>
         <td>
            <p><b>HASTA:</b></p>
         </td>
         <td>
            <p class="descripcion"><?php echo $hasta ?>
            </p>
         </td>
      </tr>
   </table>

   <hr>

   <table class="libro_venta">
      <thead>
         <tr>
            <th rowspan="2">N°</th>
            <th rowspan="2">FECHA</th>
            <th rowspan="2">DOCUMENTO</th>
            <th rowspan="2">CLIENTE</th>
            <th colspan="2">COMPROBANTE</th>
            <th rowspan="2">TOTAL CON IVA</th>
            <th colspan="2">IVA 10%</th>
            <th colspan="2">IVA 5%</th>
            <th rowspan="2">EXENTA</th>
         </tr>
         <tr>
            <th>TIPO</th>
            <th>N° COMPROBANTE</th>
            <th>IMPORTE SIN IVA</th>
            <th>CREDITO FISCAL</th>
            <th>IMPORTE SIN IVA</th>
            <th>CREDITO FISCAL</th>
         </tr>
      </thead>
      <tbody>
         <?php if (pg_num_rows($resultado) > 0) { ?>
            <?php foreach ($datos as $cantidad_fila => $fila) {
               $total += intval($fila['importe_total']);
               $sin_iva_10 += intval($fila['sin_credito_fiscal_10']);
               $credito_fiscal_10 += intval($fila['credito_fiscal_10']);
               $sin_iva_5 += intval($fila['sin_credito_fiscal_5']);
               $credito_fiscal_5 += intval($fila['credito_fiscal_5']);
               $otros += intval($fila['otros']);
               ?>
               <tr>
                  <td><?php echo $cantidad_fila + 1 ?></td>
                  <td><?php echo date('d-m-Y', strtotime($fila['libven_fecha'])) ?></td>
                  <td><?php echo $fila['per_numerodocumento'] ?></td>
                  <td><?php echo $fila['cliente'] ?></td>
                  <td><?php echo $fila['tipo_comprobante'] ?></td>
                  <td><?php echo $fila['nro_comprobante'] ?></td>
                  <td><?php echo number_format($fila['importe_total'], 0, ',', '.'); ?></td>
                  <td><?php echo number_format($fila['sin_credito_fiscal_10'], 0, ',', '.'); ?></td>
                  <td><?php echo number_format($fila['credito_fiscal_10'], 0, ',', '.'); ?></td>
                  <td><?php echo number_format($fila['sin_credito_fiscal_5'], 0, ',', '.'); ?></td>
                  <td><?php echo number_format($fila['credito_fiscal_5'], 0, ',', '.'); ?></td>
                  <td><?php echo number_format($fila['otros'], 0, ',', '.'); ?></td>
               </tr>
            <?php } ?>
         <?php } else { ?>
            <tr>
               <td colspan="12" style="text-align: center; style=" background-color: #f0f0f0;">NO SE ENCONTRARON REGISTROS
                  PARA MOSTRAR</td>
            </tr>
         <?php } ?>
      </tbody>
      <?php if (pg_num_rows($resultado) > 0) { ?>
         <tfoot>
            <tr>
               <td></td>
               <td colspan="5" style="text-align: left; background-color: #f0f0f0;">TOTALES</td>
               <td><?php echo number_format($total, 0, ',', '.'); ?></td>
               <td><?php echo number_format($sin_iva_10, 0, ',', '.'); ?></td>
               <td><?php echo number_format($credito_fiscal_10, 0, ',', '.'); ?></td>
               <td><?php echo number_format($sin_iva_5, 0, ',', '.'); ?></td>
               <td><?php echo number_format($credito_fiscal_5, 0, ',', '.'); ?></td>
               <td><?php echo number_format($otros, 0, ',', '.'); ?></td>
            </tr>
         </tfoot>
      <?php } ?>
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

$dompdf->stream("reporte_libro_venta.pdf", array('Attachment' => false));

?>