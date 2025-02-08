<?php
header("Content-type: application/json; charset=utf-8");

session_start();

//Si existe la variable de apertura de caja me va a traer los datos de cabecera y apertura
if (isset($_SESSION['apertura']['numero'])) {

   $datos = [
      'usu_codigo' => "{$_SESSION['usuario']['usu_codigo']}",
      'usu_login' => "{$_SESSION['usuario']['usu_login']}",
      'suc_codigo' => "{$_SESSION['usuario']['suc_codigo']}",
      'suc_descripcion' => "{$_SESSION['usuario']['suc_descripcion']}",
      'emp_codigo' => "{$_SESSION['usuario']['emp_codigo']}",
      'emp_razonsocial' => "{$_SESSION['usuario']['emp_razonsocial']}",
      'emp_timbrado' => "{$_SESSION['usuario']['emp_timbrado']}",
      'apercie_codigo' => "{$_SESSION['apertura']['numero']}",
      'caj_codigo' => "{$_SESSION['apertura']['numero_caja']}",
      'caj_descripcion' => "{$_SESSION['apertura']['caja']}"
   ];

} else {

   //Si no existe la variable de apértura solo va a traer los datos de cabecera
   $datos = [
      'usu_codigo' => "{$_SESSION['usuario']['usu_codigo']}",
      'usu_login' => "{$_SESSION['usuario']['usu_login']}",
      'suc_codigo' => "{$_SESSION['usuario']['suc_codigo']}",
      'suc_descripcion' => "{$_SESSION['usuario']['suc_descripcion']}",
      'emp_codigo' => "{$_SESSION['usuario']['emp_codigo']}",
      'emp_razonsocial' => "{$_SESSION['usuario']['emp_razonsocial']}",
      'emp_timbrado' => "{$_SESSION['usuario']['emp_timbrado']}"
   ];
}


echo json_encode($datos);

?>