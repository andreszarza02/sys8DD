<?php

//Retorno JSON
header("Content-type: application/json; charset=utf-8");

//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

// Solicitamos la clase de funciones
include "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/complements_php/funciones/funciones.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

// Definimos las consultas a realizar
$ultimoFuncionario = "select coalesce(max(funpro_codigo),0)+1 as funpro_codigo from funcionario_proveedor;";
$ultimaChapa = "select coalesce(max(chave_codigo),0)+1 as chave_codigo from chapa_vehiculo;";
$ultimoModelo = "select coalesce(max(modve_codigo),0)+1 as modve_codigo from modelo_vehiculo;";
$ultimaMarca = "select coalesce(max(marve_codigo),0)+1 as marve_codigo from marca_vehiculo;";

//Consultamos si existe la variable operacion cabecera
if (isset($_POST['operacion_cabecera'])) {

   // Definimos y cargamos las variables
   $usu_login = pg_escape_string($conexion, $_POST['usu_login']);

   $pro_razonsocial = pg_escape_string($conexion, $_POST['pro_razonsocial']);

   $tipro_descripcion = pg_escape_string($conexion, $_POST['tipro_descripcion']);

   $marve_descripcion = pg_escape_string($conexion, $_POST['marve_descripcion']);

   $modve_descripcion = pg_escape_string($conexion, $_POST['modve_descripcion']);

   $chave_chapa = pg_escape_string($conexion, $_POST['chave_chapa']);

   /* Cargamos las referenciales de funcionario proveedor, chapa, modelo y marca vehiculo en caso de no estar definidos */

   $funpro_codigo = 0;
   $marve_codigo = 0;
   $modve_codigo = 0;
   $chave_codigo = 0;

   // Validamos que la nota sea de remision
   if (isset($_POST['tipco_codigo']) == 3) {

      // Validamos que el codigo de funcionario este definido
      if ($_POST['funpro_codigo'] == 0) {
         // Si no se define, consultamos, asignamos y cargamos un nuevo registro en funcionario_proveedor
         $resultadoFuncionario = pg_query($conexion, $ultimoFuncionario);

         $datosFuncionario = pg_fetch_assoc($resultadoFuncionario);

         $funpro_codigo = $datosFuncionario['funpro_codigo'];

         $funpro_nombre = pg_escape_string($conexion, $_POST['funpro_nombre']);

         $funpro_apellido = pg_escape_string($conexion, $_POST['funpro_apellido']);

         $funpro_documento = pg_escape_string($conexion, $_POST['funpro_documento']);

         // Insertamos un nuevo registro
         $nuevoFuncionarioProveedor = "select sp_funcionario_proveedor(
            $funpro_codigo, 
            '$funpro_nombre', 
            '$funpro_apellido', 
            '$funpro_documento', 
            'ACTIVO', 
            {$_POST['pro_codigo']},
            {$_POST['tipro_codigo']},
            1,
            {$_POST['usu_codigo']},
            '$usu_login',
            'ALTA',
            '$pro_razonsocial',
            '$tipro_descripcion'
            )";

         pg_query($conexion, $nuevoFuncionarioProveedor);

      } else {
         $funpro_codigo = $_POST['funpro_codigo'];
      }

      // Validamos que el codigo de marca vehiculo este definido
      if ($_POST['marve_codigo'] == 0) {
         // Si no se define, consultamos, asignamos y cargamos un nuevo registro en marca_vehiculo
         $resultadoMarca = pg_query($conexion, $ultimaMarca);

         $datosMarca = pg_fetch_assoc($resultadoMarca);

         $marve_codigo = $datosMarca['marve_codigo'];

         // Insertamos un nuevo registro
         $nuevaMarca = "select sp_marca_vehiculo(
            $marve_codigo, 
            '$marve_descripcion',
            'ACTIVO',
            1,
            {$_POST['usu_codigo']},
            '$usu_login',
            'ALTA'
            )";

         pg_query($conexion, $nuevaMarca);

      } else {
         $marve_codigo = $_POST['marve_codigo'];
      }

      // Validamos que el codigo de modelo vehiculo este definido
      if ($_POST['modve_codigo'] == 0) {
         // Si no se define, consultamos, asignamos y cargamos un nuevo registro en modelo_vehiculo
         $resultadoModelo = pg_query($conexion, $ultimoModelo);

         $datosModelo = pg_fetch_assoc($resultadoModelo);

         $modve_codigo = $datosModelo['modve_codigo'];

         // Insertamos un nuevo registro
         $nuevoModelo = "select sp_modelo_vehiculo(
            $modve_codigo, 
            '$modve_descripcion',
            'ACTIVO',
            $marve_codigo, 
            1,
            {$_POST['usu_codigo']},
            '$usu_login',
            'ALTA',
            '$marve_descripcion'
            )";

         pg_query($conexion, $nuevoModelo);

      } else {
         $modve_codigo = $_POST['modve_codigo'];
      }

      // Validamos que el codigo de chapa vehiculo este definido
      if ($_POST['chave_codigo'] == 0) {
         // Si no se define, consultamos, asignamos y cargamos un nuevo registro en chapa_vehiculo
         $resultadoChapa = pg_query($conexion, $ultimaChapa);

         $datosChapa = pg_fetch_assoc($resultadoChapa);

         $chave_codigo = $datosChapa['chave_codigo'];

         // Insertamos un nuevo registro
         $nuevaChapa = "select sp_chapa_vehiculo(
            $chave_codigo, 
            '$chave_chapa',
            $modve_codigo,
            $marve_codigo,
            'ACTIVO',
            1,
            {$_POST['usu_codigo']},
            '$usu_login',
            'ALTA',
            '$modve_descripcion',
            '$marve_descripcion'
            )";

         pg_query($conexion, $nuevaChapa);

      } else {
         $chave_codigo = $_POST['chave_codigo'];
      }

   }


   //Definimos y cargamos las variables
   $numeroNota = $_POST['nocom_numeronota'];
   $numeroNota = preg_replace('/\D/', '', $numeroNota);
   $nocom_numeronota = formatearNumeroFactura($numeroNota);

   $nocom_concepto = pg_escape_string($conexion, $_POST['nocom_concepto']);

   $nocom_estado = pg_escape_string($conexion, $_POST['nocom_estado']);

   $tipco_descripcion = pg_escape_string($conexion, $_POST['tipco_descripcion']);

   $suc_descripcion = pg_escape_string($conexion, $_POST['suc_descripcion']);

   $emp_razonsocial = pg_escape_string($conexion, $_POST['emp_razonsocial']);

   $nocom_chapa = pg_escape_string($conexion, $_POST['chave_chapa']);

   $procedimiento = pg_escape_string($conexion, $_POST['procedimiento']);

   $sql = "select sp_nota_compra_cab(
      {$_POST['nocom_codigo']}, 
      '{$_POST['nocom_fecha']}', 
      '$nocom_numeronota',
      '$nocom_concepto',
      '$nocom_estado',  
      {$_POST['tipco_codigo']}, 
      {$_POST['suc_codigo']}, 
      {$_POST['emp_codigo']}, 
      {$_POST['usu_codigo']}, 
      {$_POST['comp_codigo']}, 
      {$_POST['pro_codigo']}, 
      {$_POST['tipro_codigo']}, 
      '{$_POST['nocom_timbrado']}',
      '{$_POST['nocom_timbrado_venc']}',
      '$nocom_chapa',
      {$_POST['funpro_codigo']},
      {$_POST['operacion_cabecera']},
      '$usu_login',
      '$procedimiento',
      '$tipco_descripcion',
      '$pro_razonsocial',
      '$tipro_descripcion',
      '$emp_razonsocial',
      '$suc_descripcion'
      )";

   //Validamos la consulta
   $result = pg_query($conexion, $sql);
   $error = pg_last_error($conexion);

   if (strpos($error, "nota") !== false) {
      $response = array(
         "mensaje" => "EL NUMERO DE NOTA YA SE SE ENCUENTRA REGISTRADA",
         "tipo" => "error"
      );
   } else {
      $response = array(
         "mensaje" => pg_last_notice($conexion),
         "tipo" => "info"
      );
   }

   echo json_encode($response);

} else if (isset($_POST['consulta1'])) {

   //Consultamos y enviamos el ultimo codigo
   $sql = "select coalesce(max(nocom_codigo),0)+1 as nocom_codigo from nota_compra_cab;";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);
   echo json_encode($datos);

} else {

   //Si el post no recibe la operacion realizamos una consulta
   $sql = "select * 
           from v_nota_compra_cab vncc 
           where vncc.nocom_estado <> 'ANULADO';";
   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_all($resultado);
   echo json_encode($datos);
}

?>