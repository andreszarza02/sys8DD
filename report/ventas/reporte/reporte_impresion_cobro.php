<?php

//Requerimos conexion 
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Recibimos y definimos las variables
$cobro = $_GET['cob_codigo'];

//Establecemos la consulta de la cabecera
$sql = "select 
            e.emp_razonsocial,
            s.suc_descripcion,
            c.ciu_descripcion,
            u.usu_login,
            p.per_nombre||' '||p.per_apellido persona,
            e.emp_ruc 
         from cobro_cab cc
            join usuario u on u.usu_codigo=cc.usu_codigo 
            join funcionario f on f.func_codigo=u.func_codigo 
            join personas p on p.per_codigo=f.per_codigo 
            join sucursal s on s.suc_codigo=cc.suc_codigo 
            and s.emp_codigo=cc.emp_codigo 
            join empresa e on e.emp_codigo=s.emp_codigo 
            join ciudad c on c.ciu_codigo=s.ciu_codigo 
         where cc.cob_codigo=$cobro;";

$resultado = pg_query($conexion, $sql);
$logo = pg_fetch_assoc($resultado);

//Establecemos la consulta del detalle
$sql2 = "select 
            vcd.cob_codigo codigo,
            sum(vcd.cobdet_monto) monto,
            (select to_char(max(cc.cob_fecha), 'dd-mm-yyyy') from cobro_cab cc where cc.cob_codigo=$cobro) fecha,
            vcd.cliente,
            'DE LA CUOTA '||vcd.cobdet_numerocuota||'/'||vcd.cuota||' POR LA COMPRA N° '||vcd.factura concepto,
            (select 
               p.per_email
            from cliente c 
               join personas p on p.per_codigo=c.per_codigo 
	            where p.per_numerodocumento=vcd.ci) correo 
         from v_cobro_det vcd 
         where vcd.cob_codigo=$cobro
            group by 1,3,4,5,6;";

$resultado2 = pg_query($conexion, $sql2);
$detalle = pg_fetch_assoc($resultado2);

//Definimos el formato de fecha 
$fechaString = $detalle['fecha'];
//Convertimos la fecha de string a date
$fecha = DateTime::createFromFormat('d-m-Y', $fechaString);
//Definimos los meses del año
$meses = [
   1 => 'ENERO',
   2 => 'FEBRERO',
   3 => 'MARZO',
   4 => 'ABRIL',
   5 => 'MAYO',
   6 => 'JUNIO',
   7 => 'JULIO',
   8 => 'AGOSTO',
   9 => 'SEPTIEMBRE',
   10 => 'OCTUBRE',
   11 => 'NOVIEMBRE',
   12 => 'DICIEMBRE'
];
//Sacamos el dia, mes y año del objeto fecha
$dia = $fecha->format('d');
$mes = $meses[(int) $fecha->format('m')];
$anio = $fecha->format('Y');
//Cargamos la variable con el formato que queremos mostrar
$fechaFormateada = "{$logo['ciu_descripcion']}, $dia DE $mes DEL $anio";

//Pasamos el monto a letras
//Creamos una instancia de la clase NumberForamtter
$formatter = new NumberFormatter('es', NumberFormatter::SPELLOUT);
//Guardamos el monto en una variable
$montoSuma = floatval($detalle['monto']);

?>

<?php ob_start(); ?>

<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>RECIBO DE COBRO</title>
   <style>
      body {
         font-family: Arial, Helvetica, sans-serif;
         border: 2px solid #a6a2a1;
         border-radius: 15px;
         margin: 10px;
         padding: 30px 50px;
         min-height: 100vh;
         box-sizing: border-box;
      }

      h3 {
         margin: 10px auto;
         width: 36%;
         border-radius: 10px;
         background: ##232323;
         color: #fff;
         padding: 1px 0 1px 6px;
         border: 2px solid black;
      }

      th {
         padding: 2px;
         border: 2px solid #000;
         font-size: 14px;
         background: #232323;
         color: #fff;
      }

      .encabezado {
         width: 100%;
         margin-bottom: 130px;
         margin-top: 30px;
      }

      .datosEmpresa {
         border: 2px solid #a6a2a1;
         border-radius: 15px;
         padding: 10px 10px;
         box-sizing: border-box;
         float: left;
         width: 30%;
      }

      .logo {
         display: block;
         text-align: center;
      }

      .logo.empresa {
         font-size: 18px;
         font-weight: bold;
         margin-bottom: 5px;
      }

      .logo.sucursal {
         font-size: 16px;
         font-style: italic;
         margin-bottom: 5px;
      }

      .logo.ruc {
         font-size: 12px;
         font-style: italic;
         margin-bottom: 5px;
      }

      .titulo {
         padding: 50px 10px 10px 10px;
         float: left;
         width: 30%;
         text-align: center;
         margin-left: 5%;
         box-sizing: border-box;
         font-size: 25px;
         font-weight: bold;
      }

      .datosCobro1 {
         padding: 10px 10px;
         box-sizing: border-box;
         float: left;
         width: 22%;
         margin-left: 5%;
      }

      .presentacion {
         display: block;
         text-align: right;
      }

      .presentacion.nroCobro {
         font-size: 20px;
         font-weight: bold;
         margin-bottom: 5px;
         margin-right: 5px;
      }

      .presentacion.montoCobro {
         border: 2px solid #efe8e6;
         border-radius: 15px;
         padding: 10px;
         box-sizing: border-box;
         color: #000;
         background-color: #efe8e6;
      }

      .fecha {
         display: block;
         text-align: right;
         font-size: 16px;
         font-style: italic;
         margin-bottom: 35px;
      }

      .firma {
         width: 50%;
         position: absolute;
         top: 70%;
         right: 6.5%;
      }

      .firma table td span {
         margin-left: 90px;
         font-family: monospace;
      }

      .firma table td .solicitudFirma {
         font-size: 13px;
         font-weight: bold;
         font-style: oblique;
         text-align: center;
      }

      .firma .pieFirma {
         font-size: 20px;
         font-weight: bold;
         text-align: center;
      }
   </style>
</head>

<body>

   <div class="encabezado">

      <div class="datosEmpresa">
         <span class="logo empresa"><?php echo $logo['emp_razonsocial'] ?></span>
         <span class="logo sucursal"><?php echo $logo['suc_descripcion'] ?></span>
         <span class="logo ruc">RUC: <?php echo $logo['emp_ruc'] ?></span>
      </div>

      <span class="titulo">RECIBO</span>

      <div class="datosCobro1">
         <span class="presentacion nroCobro">N.° <?php echo $detalle['codigo'] ?></span>
         <span class="presentacion montoCobro">Gs. <?php echo number_format($detalle['monto'], 0, ',', '.'); ?></span>
      </div>

   </div>

   <div class="descripcion">
      <span class="fecha"><?php echo $fechaFormateada; ?></span>
      <!-- Primera línea -->
      <table width="100%" cellspacing="0" cellpadding="0" style="margin-bottom: 35px;">
         <tr>
            <td width="120px" style="vertical-align: bottom; padding-right: 10px;">Recibí (mos) de:</td>
            <td width="100%" style="vertical-align: bottom;">
               <span><?php echo $detalle['cliente']; ?></span>
               <div style="border-bottom: 1px solid black; margin-top: 2px;"></div>
            </td>
         </tr>
      </table>

      <!-- Segunda línea -->
      <table width="100%" cellspacing="0" cellpadding="0" style="margin-bottom: 35px;">
         <tr>
            <td width="200px" style="vertical-align: bottom; padding-right: 5px;">La cantidad de guaraníes:</td>
            <td width="100%" style="vertical-align: bottom;">
               <span><?php echo strtoupper($formatter->format($montoSuma)); ?></span>
               <div style="border-bottom: 1px solid black; margin-top: 2px;"></div>
            </td>
         </tr>
      </table>

      <!-- Tercera línea -->
      <table width="100%" cellspacing="0" cellpadding="0" style="margin-bottom: 35px;">
         <tr>
            <td width="160px" style="vertical-align: bottom; padding-right: 5px;">En concepto de pago:</td>
            <td width="100%" style="vertical-align: bottom;">
               <span><?php echo $detalle['concepto']; ?></span>
               <div style="border-bottom: 1px solid black; margin-top: 2px;"></div>
            </td>
         </tr>
      </table>
   </div>

   <div class="firma">
      <table width="100%" cellspacing="0" cellpadding="0" style="margin-bottom: 35px;">
         <tr>
            <td width="100%" style="vertical-align: bottom;">
               <span><?php echo "{$logo['usu_login']} - {$logo['persona']}" ?></span>
               <div style="border-bottom: 1px solid black; margin-top: 8px;"></div>
               <p class="solicitudFirma">Firma y aclaración</p>
               <p class="pieFirma"><?php echo $logo['emp_razonsocial'] ?></p>
            </td>
         </tr>
      </table>
   </div>

</body>

</html>

<?php

//Obtenemos lo guardado en bufer
$html = ob_get_clean();

require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/vendor/autoload.php";

//Llamamos a la libreria dompdf
use Dompdf\Dompdf;

//Generamos el pdf
$dompdf = new Dompdf();

$dompdf->loadHtml($html);

$dompdf->setPaper('A4', 'landscape'); //portrait -> vertical landscape -> horizontal

//Renderizamos el pdf
$dompdf->render();

$dompdf->stream("8_DE_DICIEMBRE_RECIBO_Nro_$cobro.pdf", array('Attachment' => false));

?>