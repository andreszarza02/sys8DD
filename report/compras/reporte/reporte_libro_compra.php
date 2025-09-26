<?php

//Iniciamos sesion
session_start();

// Definimos datos generales a utilizar en el encabezado
$usuario = $_SESSION['usuario']['usu_login'];
$perfil = $_SESSION['usuario']['perf_descripcion'];
$modulo = $_SESSION['usuario']['modu_descripcion'];

$fechaActual = date('d-m-Y');

//Requerimos conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

// Creamos una instanca de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

// Definimos y cargamos las variables
$desde = $_GET['desde'] ?? null;
$hasta = $_GET['hasta'] ?? null;
$proveedor = $_GET['proveedor'] ?? null;
$tipo = $_GET['tipo'] ?? null;

// Definimos la consulta principal
$sql = "SELECT * FROM v_reporte_libro_compra vrlc 
         WHERE vrlc.licom_fecha BETWEEN '$desde' AND '$hasta';";

// Agregamos los filtros opcionales solo si vienen con datos
if (!empty($proveedor)) {
   $sql .= " AND vrlc.pro_codigo = '$proveedor'";
}

if (!empty($tipo)) {
   $sql .= " AND vrlc.tipco_codigo = '$tipo'";
}

$resultado = pg_query($conexion, $sql);

$datos = pg_fetch_all($resultado);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="es">

<head>
   <meta charset="UTF-8">
   <title>Libro de Compras</title>
   <style>
      body {
         font-family: Arial, sans-serif;
         font-size: 12px;
         margin: 40px;
         color: #000;
      }

      h2 {
         text-align: center;
         margin-bottom: 5px;
      }

      .header-info {
         display: flex;
         justify-content: space-between;
         margin-bottom: 10px;
         font-size: 12px;
      }

      .header-info div {
         width: 48%;
      }

      table {
         width: 100%;
         border-collapse: collapse;
         margin-bottom: 15px;
      }

      table th,
      table td {
         border: 1px solid #000;
         padding: 5px;
         text-align: right;
         font-size: 11px;
      }

      table th {
         background-color: #f0f0f0;
         text-align: center;
      }

      .footer-total td {
         font-weight: bold;
         background-color: #f9f9f9;
      }

      .left {
         text-align: left !important;
      }
   </style>
</head>

<body>
   <p>8 DE DICIEMBRE</p>

   <h2>LIBRO DE COMPRAS</h2>

   <div class="header-info">
      <div>
         <p><strong>USUARIO:</strong> 1 ADMINISTRADOR</p>
         <p><strong>FECHA:</strong> 23-10-2005</p>
      </div>
      <div style="text-align: right;">
         <p><strong>PÁG.:</strong> 1</p>
         <p><strong>DESDE:</strong> 01-01-2005 &nbsp;&nbsp; <strong>HASTA:</strong> 23-10-2005</p>
      </div>
   </div>

   <table>
      <thead>
         <tr>
            <th rowspan="2">N°</th>
            <th rowspan="2">FECHA</th>
            <th rowspan="2">RUC</th>
            <th rowspan="2">PROVEEDOR</th>
            <th colspan="2">DOCUMENTO</th>
            <th rowspan="2">TOTAL CON IVA</th>
            <th colspan="2">IVA 10%</th>
            <th colspan="2">IVA 5%</th>
            <th rowspan="2">OTROS</th>
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
      </tbody>
      <tfoot>
      </tfoot>
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

$dompdf->stream("reporte_libro_compra.pdf", array('Attachment' => false));

?>