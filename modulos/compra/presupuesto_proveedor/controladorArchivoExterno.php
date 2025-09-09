<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion y servicios del composer
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";
$objConexion = new Conexion();
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/vendor/autoload.php";

// Requerimos recursos de composer
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Shared\Date;

// Instancia de conexión
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

// Validamos que este definido el archivo
if (!isset($_FILES['seleccionarExcel'])) {
   echo json_encode(
      [
         "tipo" => "error",
         "mensaje" => "NO SE RECIBIÓ EL ARCHIVO EXCEL"
      ]
   );
   exit;
}

// Guardamos la ruta temporal del archivo
$tmp = $_FILES['seleccionarExcel']['tmp_name'];

// Creamos un objeto de tipo phpOfice
$spreadsheet = IOFactory::load(filename: $tmp);
$sheet = $spreadsheet->getActiveSheet();

// Consultamos dtos del proveedor 
$sqlProvedor = "select 
                p.pro_codigo,
                tp.tipro_codigo,
                tp.tipro_descripcion
            from proveedor p
            join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
            where p.pro_ruc = '" . $sheet->getCell("B4")->getValue() . "'
            limit 1";
$resProveedor = pg_query($conexion, $sqlProvedor);
$datosProvedor = pg_fetch_assoc($resProveedor);

// Definimos datos para la cabecera
$excelDate = $sheet->getCell("B2")->getValue();
if (Date::isDateTime($sheet->getCell("B2"))) {
   $dateTime = Date::excelToDateTimeObject($excelDate);
   $prepro_fechaactual = $dateTime->format('d/m/Y'); // fecha en formato día/mes/año
} else {
   $prepro_fechaactual = $_POST['prepro_fechaactual'];
}

$excelDateVencimiento = $sheet->getCell("B5")->getValue();
if (Date::isDateTime($sheet->getCell("B5"))) {
   $dateTimeVen = Date::excelToDateTimeObject($excelDateVencimiento);
   $prepro_fechavencimiento = $dateTimeVen->format('d/m/Y');
} else {
   $prepro_fechavencimiento = null; // o como prefieras manejarlo
}
$pedco_codigo = (int) $sheet->getCell("B1")->getFormattedValue();
$pro_ruc = $sheet->getCell("B4")->getValue();
$pro_razonsocial = pg_escape_string($conexion, $sheet->getCell("B3")->getValue());
$pro_codigo = $datosProvedor['pro_codigo'];
$tipro_codigo = $datosProvedor['tipro_codigo'];
$tipro_descripcion = $datosProvedor['tipro_descripcion'];

// Escapamos los datos para que acepte la comilla simple
$prepro_estado = pg_escape_string($conexion, $_POST['prepro_estado']);
$suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);
$emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);
$usu_login = pg_escape_string($conexion, $_POST['usu_login']);

// Cargamos y ejecutamos el sp de cabecera 
$sqlCabecera = "select sp_presupuesto_proveedor_cab(
    {$_POST['prepro_codigo']},
    '$prepro_fechaactual',
    '$prepro_estado',
    '$prepro_fechavencimiento',
    {$_POST['usu_codigo']},
    $pro_codigo,
    $tipro_codigo,
    {$_POST['suc_codigo']},
    {$_POST['emp_codigo']},
    $pedco_codigo,
    {$_POST['operacion_cabecera']},
    '$usu_login',
    '{$_POST['procedimiento']}',
    '$pro_ruc',
    '$pro_razonsocial',
    '$emp_razonsocial',
    '$suc_descripcion',
    '$tipro_descripcion'
);";

pg_query($conexion, $sqlCabecera);
$error = pg_last_error($conexion);

// Caputuramos el error en caso de que se genere y lo enviamos al view
if (strpos($error, "fecha") !== false) {
   $response = array(
      "mensaje" => "LA FECHA DE REGISTRO ES MAYOR A LA FECHA DE VENCIMIENTO",
      "tipo" => "error"
   );
} else if (strpos($error, "pedido") !== false) {
   $response = array(
      "mensaje" => "EL PROVEEDOR SELECCIONADO YA TIENE DESIGNADO UN PRESUPUESTO DE ACUERDO AL PEDIDO",
      "tipo" => "error"
   );
} else if (strpos($error, "asociado") !== false) {
   $response = array(
      "mensaje" => "YA SE ENCUENTRA ASOCIADO EL PRESUPUESTO DE PROVEEDOR A UNA ORDEN DE COMPRA",
      "tipo" => "error"
   );
} else {
   $response = array(
      "mensaje" => pg_last_notice($conexion),
      "tipo" => "success"
   );

   // Si se ejecuto los datos de cabecera en cabecera, procedemos con el detalle
   // Definimos la fila de inicio
   $fila = 8;
   // Definimos el array donde guardar los items que se duplican
   $erroresItemsDuplicados = [];

   // Mientras tenga datos el archivo continuamos recorriendo
   while ($sheet->getCell("A" . $fila)->getValue() != "") {

      // Consultamos datos de item
      $sqlTipo = "select tipit_codigo, it_descripcion from items where it_codigo = cast(" . $sheet->getCell("A" . $fila)->getValue() . " as integer);";

      $resTipo = pg_query($conexion, $sqlTipo);
      $datosTipo = pg_fetch_assoc($resTipo);

      // Extraemos datos del item en en el excel
      $it_codigo = (int) $sheet->getCell("A" . $fila)->getValue();
      $peprodet_cantidad = str_replace(",", ".", $sheet->getCell("C" . $fila)->getValue());
      $peprodet_precio = str_replace(",", ".", $sheet->getCell("E" . $fila)->getValue());

      // Cargamos y ejecutamos el detalle
      $sqlDetalle = "select sp_presupuesto_proveedor_det(
         {$_POST['prepro_codigo']},
            $it_codigo,
            {$datosTipo['tipit_codigo']},
            $peprodet_cantidad,
            $peprodet_precio,
            {$_POST['operacion_cabecera']}
        );";

      pg_query($conexion, $sqlDetalle);
      $errorDetalle = pg_last_error($conexion);

      //En caso de ocurrir un error guardamos la variable que lo genero
      if (strpos($errorDetalle, 'item') !== false) {
         // Guardamos solo el nombre del item
         $erroresItemsDuplicados[] = $datosTipo['it_descripcion'];
      }

      // En cada vuelta aumentamos el contador
      $fila++;
   }

   // Función para unir en lista con comas y "y" antes del último
   function listaConjuntada($array)
   {
      if (count($array) == 1) {
         return $array[0];
      }
      $ultimo = array_pop($array);
      return implode(", ", $array) . " y " . $ultimo;
   }

   // Eliminamos duplicados
   $itemsUnicos = array_unique($erroresItemsDuplicados);

   // Construimos el mensaje final
   if (count($itemsUnicos) > 0) {
      if (count($itemsUnicos) == 1) {
         $mensaje = "EL ITEM " . listaConjuntada($itemsUnicos) . " SE ENCUENTRA DUPLICADO EN EL ARCHIVO";
      } else {
         $mensaje = "LOS ITEMS " . listaConjuntada($itemsUnicos) . " SE ENCUENTRAN DUPLICADOS EN EL ARCHIVO";
      }

      $response = array(
         "mensaje" => $mensaje,
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => "LA CABECERA Y EL DETALLE DEL PRESUPUESTO DE PROVEEDOR SE REGISTRARON DE MANERA CORRECTA",
         "tipo" => "info"
      );
   }
}
echo json_encode($response);