<?php
//Retorno JSON
header("Content-type: application/json; charset=utf-8");
//Solicitamos la clase de Conexion
require_once "{$_SERVER['DOCUMENT_ROOT']}/sys8DD/others/conexion/conexion.php";

//Creamos la instancia de la clase Conexion
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

//Variables de validación
$impuestos = ["nada", "libven_iva5", "libven_iva10", "libven_exenta"];
$tipoComprobante = $_POST['tipco_codigo'];
$tipoImpuesto = $_POST['tipim_codigo'];
$item = $_POST['it_codigo'];
$tipoItem = $_POST['tipit_codigo'];
$factura = $_POST['ven_tipofactura'];
$concepto = $_POST['notven_concepto'];
$operacion = $_POST['operacion_detalle'];

//Variables de cantidad
$cantidad = intval($_POST['notvendet_cantidad']);
$precio = floatval($_POST['notvendet_precio']);

//Validamos en caso de que el item sea un servicio
if ($tipoItem == '3') {
   $total = $precio;
} else {
   $total = $cantidad * $precio;
}

//En caso de que sea nota debito y factura contado
if (($tipoComprobante == '2') && ($factura == 'CONTADO')) {

   if ($operacion == 1) {

      $sql = "update cuenta_cobrar set cuenco_montototal = cuenco_montototal+$total, cuenco_montosaldo = cuenco_montosaldo+$total where ven_codigo={$_POST['ven_codigo']}";

      $sql2 = "update venta_cab set vent_montocuota = vent_montocuota+$total where ven_codigo={$_POST['ven_codigo']}";

      $sql3 = "update libro_venta set $impuestos[$tipoImpuesto] = $impuestos[$tipoImpuesto]+$total where ven_codigo={$_POST['ven_codigo']}";

   } else {

      $sql = "update cuenta_cobrar set cuenco_montototal = cuenco_montototal-$total, cuenco_montosaldo = cuenco_montosaldo-$total where ven_codigo={$_POST['ven_codigo']}";

      $sql2 = "update venta_cab set vent_montocuota = vent_montocuota-$total where ven_codigo={$_POST['ven_codigo']}";

      $sql3 = "update libro_venta set $impuestos[$tipoImpuesto] = $impuestos[$tipoImpuesto]-$total where ven_codigo={$_POST['ven_codigo']}";
   }


   //ejecutamos las consultas
   pg_query($conexion, $sql);
   pg_query($conexion, $sql2);
   pg_query($conexion, $sql3);

}

//En caso de que sea nota debito y factura credito
if (($tipoComprobante == '2') && ($factura == 'CREDITO')) {

   $montoCuota = floatval($_POST['vent_montocuota']);

   if ($operacion == 1) {

      $sql = "update cuenta_cobrar set cuenco_montototal = cuenco_montototal+$total, cuenco_montosaldo = cuenco_montosaldo+$total where ven_codigo={$_POST['ven_codigo']}";

      $sql2 = "update libro_venta set $impuestos[$tipoImpuesto] = $impuestos[$tipoImpuesto]+$total where ven_codigo={$_POST['ven_codigo']}";

      //ejecutamos las primeras 2 consultas
      pg_query($conexion, $sql);
      pg_query($conexion, $sql2);


   } else {

      $sql = "update cuenta_cobrar set cuenco_montototal = cuenco_montototal-$total, cuenco_montosaldo = cuenco_montosaldo-$total where ven_codigo={$_POST['ven_codigo']}";

      $sql2 = "update libro_venta set $impuestos[$tipoImpuesto] = $impuestos[$tipoImpuesto]-$total where ven_codigo={$_POST['ven_codigo']}";

      //ejecutamos las primeras 2 consultas
      pg_query($conexion, $sql);
      pg_query($conexion, $sql2);
   }

   //Permite aumentar la cuota de la venta credito, al agregar y eliminar
   $sql3 = "select cuenco_montototal from cuenta_cobrar where ven_codigo = {$_POST['ven_codigo']}";
   $resultado = pg_query($conexion, $sql3);
   $dato = pg_fetch_assoc($resultado);

   $calculoCuota = (floatval($dato['cuenco_montototal']) / $montoCuota);
   $cuota = ceil($calculoCuota);

   $sql4 = "update venta_cab set ven_cuota = $cuota where ven_codigo ={$_POST['ven_codigo']};
   update cuenta_cobrar set cuenco_nrocuota = $cuota where ven_codigo = {$_POST['ven_codigo']};";

   pg_query($conexion, $sql4);

}

//En caso de que sea nota credito y la factura contado
if (($tipoComprobante == '1') && ($factura == 'CONTADO')) {

   $sql = "select cuenco_montototal-cuenco_montosaldo as diferencia from cuenta_cobrar where ven_codigo={$_POST['ven_codigo']}";

   $resultado = pg_query($conexion, $sql);
   $datos = pg_fetch_assoc($resultado);

   //consultamos si es que existe una venta asociada a un registro de cobro
   $sql7 = "select cd.cobdet_codigo from cobro_det cd join cobro_cab cb on cb.cob_codigo=cd.cob_codigo where cd.ven_codigo={$_POST['ven_codigo']} and cb.cob_estado='ACTIVO' limit 1;";

   $resultado3 = pg_query($conexion, $sql7);
   $datos3 = pg_fetch_assoc($resultado3);

   //Si la venta no esta asociada a un cobro ejecutamos la consulta
   if (($datos['diferencia'] == '0') && (empty($datos3['cobdet_codigo']))) {

      if ($operacion == 1) {

         $sql2 = "update cuenta_cobrar set cuenco_montototal = cuenco_montototal-$total, cuenco_montosaldo = cuenco_montosaldo-$total where ven_codigo={$_POST['ven_codigo']}";

         $sql3 = "update venta_cab set vent_montocuota = vent_montocuota-$total where ven_codigo={$_POST['ven_codigo']};update venta_det set vendet_cantidad=vendet_cantidad-$cantidad where it_codigo=$item and ven_codigo={$_POST['ven_codigo']};";

         $sql4 = "update libro_venta set $impuestos[$tipoImpuesto] = $impuestos[$tipoImpuesto]-$total where ven_codigo={$_POST['ven_codigo']}";

         $sql6 = "update cuenta_cobrar set cuenco_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
         update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
         update venta_cab set ven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};";


      } else {

         $sql2 = "update cuenta_cobrar set cuenco_montototal = cuenco_montototal+$total, cuenco_montosaldo = cuenco_montosaldo+$total where ven_codigo={$_POST['ven_codigo']}";

         $sql3 = "update venta_cab set vent_montocuota = vent_montocuota+$total where ven_codigo={$_POST['ven_codigo']};
         update venta_det set vendet_cantidad=vendet_cantidad+$cantidad where it_codigo=$item and ven_codigo={$_POST['ven_codigo']};";

         $sql4 = "update libro_venta set $impuestos[$tipoImpuesto] = $impuestos[$tipoImpuesto]+$total where ven_codigo={$_POST['ven_codigo']}";

         $sql6 = "update cuenta_cobrar set cuenco_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
         update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
         update venta_cab set ven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};";

      }

      pg_query($conexion, $sql2);
      pg_query($conexion, $sql3);
      pg_query($conexion, $sql4);
      pg_query($conexion, $sql6);


   } else {

      //Si la venta esta asociada a un cobro ejecutamos la consulta

      if ($operacion == 1) {

         $sql2 = "update cuenta_cobrar set cuenco_montototal = cuenco_montototal-$total where ven_codigo={$_POST['ven_codigo']}";

         $sql3 = "update venta_cab set vent_montocuota = vent_montocuota-$total where ven_codigo={$_POST['ven_codigo']};
         update venta_det set vendet_cantidad=vendet_cantidad-$cantidad where it_codigo=$item and ven_codigo={$_POST['ven_codigo']};";

         $sql4 = "update libro_venta set $impuestos[$tipoImpuesto] = $impuestos[$tipoImpuesto]-$total where ven_codigo={$_POST['ven_codigo']}";

         $sql6 = "update cuenta_cobrar set cuenco_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']};
         update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
         update venta_cab set ven_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']};";


      } else {

         $sql2 = "update cuenta_cobrar set cuenco_montototal = cuenco_montototal+$total where ven_codigo={$_POST['ven_codigo']}";

         $sql3 = "update venta_cab set vent_montocuota = vent_montocuota+$total where ven_codigo={$_POST['ven_codigo']};
         update venta_det set vendet_cantidad=vendet_cantidad+$cantidad where it_codigo=$item and ven_codigo={$_POST['ven_codigo']};";

         $sql4 = "update libro_venta set $impuestos[$tipoImpuesto] = $impuestos[$tipoImpuesto]+$total where ven_codigo={$_POST['ven_codigo']}";

         $sql6 = "update cuenta_cobrar set cuenco_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']};
         update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
         update venta_cab set ven_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']};
         update cobro_cab set cob_estado='ACTIVO' where cob_codigo in (select distinct cob_codigo from cobro_det where ven_codigo={$_POST['ven_codigo']});";

      }

      pg_query($conexion, $sql2);
      pg_query($conexion, $sql3);
      pg_query($conexion, $sql4);
      pg_query($conexion, $sql6);

   }

   $sql5 = "select cuenco_montototal from cuenta_cobrar where ven_codigo={$_POST['ven_codigo']}";

   $resultado2 = pg_query($conexion, $sql5);
   $datos2 = pg_fetch_assoc($resultado2);

   if ($datos2['cuenco_montototal'] == '0') {

      $sql6 = "update cuenta_cobrar set cuenco_estado='ANULADO' where ven_codigo={$_POST['ven_codigo']};
      update libro_venta set libven_estado='ANULADO' where ven_codigo={$_POST['ven_codigo']};
      update venta_cab set ven_estado='ANULADO' where ven_codigo={$_POST['ven_codigo']};
      update cobro_cab set cob_estado='ANULADO' where cob_codigo in (select distinct cob_codigo from cobro_det where ven_codigo={$_POST['ven_codigo']});4";


      pg_query($conexion, $sql6);

   }
}

//En caso de que sea nota credito y factura credito
if (($tipoComprobante == '1') && ($factura == 'CREDITO')) {

   //La utilizamos para calcular la cantidad de cuotas
   $montoCuota = floatval($_POST['vent_montocuota']);

   //Al insertar en nota venta, restamos y cambiamos el estado en las demas tablas
   if ($operacion == 1) {

      $sql2 = "update cuenta_cobrar set cuenco_montototal = cuenco_montototal-$total, cuenco_montosaldo = cuenco_montosaldo-$total where ven_codigo={$_POST['ven_codigo']}";

      $sql3 = "
      update venta_det set vendet_cantidad=vendet_cantidad-$cantidad where it_codigo=$item and ven_codigo={$_POST['ven_codigo']};";

      $sql4 = "update libro_venta set $impuestos[$tipoImpuesto] = $impuestos[$tipoImpuesto]-$total where ven_codigo={$_POST['ven_codigo']}";

      $sql6 = "update cuenta_cobrar set cuenco_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
      update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
      update venta_cab set ven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};";

      pg_query($conexion, $sql2);
      pg_query($conexion, $sql3);
      pg_query($conexion, $sql4);
      pg_query($conexion, $sql6);

      $sql7 = "select cuenco_montosaldo from cuenta_cobrar where cuenco_estado <> 'ANULADO' and ven_codigo={$_POST['ven_codigo']};";

      $resultado2 = pg_query($conexion, $sql7);
      $datos2 = pg_fetch_assoc($resultado2);

      if (floatval($datos2['cuenco_montosaldo']) < 0) {

         $sql8 = "update cuenta_cobrar set cuenco_montosaldo={$datos2['cuenco_montosaldo']}+(-1*{$datos2['cuenco_montosaldo']}) where ven_codigo={$_POST['ven_codigo']};
         update cuenta_cobrar set cuenco_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']};
         update venta_cab set ven_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']}";

         pg_query($conexion, $sql8);

      }

      $sql8 = "select cuenco_montototal from cuenta_cobrar where ven_codigo={$_POST['ven_codigo']}";

      $resultado3 = pg_query($conexion, $sql8);
      $datos3 = pg_fetch_assoc($resultado3);

      if ($datos3['cuenco_montototal'] == '0') {

         $sql9 = "update cuenta_cobrar set cuenco_estado='ANULADO' where ven_codigo={$_POST['ven_codigo']};
         update libro_venta set libven_estado='ANULADO' where ven_codigo={$_POST['ven_codigo']};
         update venta_cab set ven_estado='ANULADO' where ven_codigo={$_POST['ven_codigo']};
         update cobro_cab set cob_estado='ANULADO' where cob_codigo in (select distinct cob_codigo from cobro_det where ven_codigo={$_POST['ven_codigo']});";


         pg_query($conexion, $sql9);

      }

   } else {

      //Al insertar en nota venta, sumamos y cambiamos el estado en las demas tablas

      $sql9 = "update cuenta_cobrar set cuenco_montototal = cuenco_montototal+$total where ven_codigo={$_POST['ven_codigo']}";

      $sql10 = "update venta_det set vendet_cantidad=vendet_cantidad+$cantidad where it_codigo=$item and ven_codigo={$_POST['ven_codigo']};";

      $sql11 = "update libro_venta set $impuestos[$tipoImpuesto] = $impuestos[$tipoImpuesto]+$total where ven_codigo={$_POST['ven_codigo']}";

      $sql12 = "update cuenta_cobrar set cuenco_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
      update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
      update venta_cab set ven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
      update cobro_cab set cob_estado='ACTIVO' where cob_codigo in (select distinct cob_codigo from cobro_det where ven_codigo={$_POST['ven_codigo']});";

      pg_query($conexion, $sql9);
      pg_query($conexion, $sql10);
      pg_query($conexion, $sql11);
      pg_query($conexion, $sql12);

      $sql13 = "select sum(cobdet_monto) totalmonto from cobro_det where ven_codigo={$_POST['ven_codigo']};";

      $resultado5 = pg_query($conexion, $sql13);
      $datos5 = pg_fetch_assoc($resultado5);

      $sql14 = "select cuenco_montototal from cuenta_cobrar where ven_codigo={$_POST['ven_codigo']}";

      $resultado6 = pg_query($conexion, $sql14);
      $datos6 = pg_fetch_assoc($resultado6);

      $montoSaldo = (floatval($datos6['cuenco_montototal']) - floatval($datos5['totalmonto']));

      $sql15 = "update cuenta_cobrar set cuenco_montosaldo=$montoSaldo where ven_codigo={$_POST['ven_codigo']}";

      $resultado7 = pg_query($conexion, $sql15);
      $datos7 = pg_fetch_assoc($resultado7);

      $sql16 = "select cuenco_montosaldo from cuenta_cobrar where ven_codigo={$_POST['ven_codigo']};";

      $resultado8 = pg_query($conexion, $sql16);
      $datos8 = pg_fetch_assoc($resultado8);

      if (floatval($datos8['cuenco_montosaldo']) <= 0) {
         $sql17 = "update cuenta_cobrar set cuenco_montosaldo=0 where ven_codigo={$_POST['ven_codigo']};
         update cuenta_cobrar set cuenco_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']};
         update venta_cab set ven_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']}";

         $resultado7 = pg_query($conexion, $sql17);
      }

   }

   //Actualizamos la cantidad de cuotas en base a lo que se modifico en cuantas a cobrar
   $sql7 = "select cuenco_montototal from cuenta_cobrar where ven_codigo = {$_POST['ven_codigo']}";
   $resultado4 = pg_query($conexion, $sql7);
   $datos5 = pg_fetch_assoc($resultado4);

   $calculoCuota = (floatval($datos5['cuenco_montototal']) / $montoCuota);
   $cuota = ceil($calculoCuota);

   $sql8 = "update venta_cab set ven_cuota = $cuota where ven_codigo ={$_POST['ven_codigo']};
   update cuenta_cobrar set cuenco_nrocuota = $cuota where ven_codigo = {$_POST['ven_codigo']};
   ";

   pg_query($conexion, $sql8);

}

if (floatval($_POST['operacion_cabecera']) == 2) {

   $sql1 = "select sum(cobdet_monto) as totalmontoventa from cobro_det where ven_codigo={$_POST['ven_codigo']};";

   $resultado = pg_query($conexion, $sql1);
   $datos = pg_fetch_assoc($resultado);

   $totalMontoVenta = floatval($datos['totalmontoventa']);

   if (($tipoComprobante == '2')) {

      $sql2 = "
      DO $$
      DECLARE
         montoNota record;
      BEGIN
         FOR montoNota IN select notvendet_cantidad*notvendet_precio as total, notvendet_cantidad, notvendet_precio, 
         i.tipim_codigo, i.tipit_codigo 
         from nota_venta_det nvd 
         join nota_venta_cab nvc on nvc.notven_codigo=nvd.notven_codigo 
         join items i on i.it_codigo=nvd.it_codigo where ven_codigo={$_POST['ven_codigo']} and tipco_codigo=2
         LOOP
            if montoNota.tipit_codigo <> 3 then
               update cuenta_cobrar set cuenco_montototal=cuenco_montototal-montoNota.total, 
               cuenco_montosaldo=cuenco_montosaldo-montoNota.total
               where ven_codigo={$_POST['ven_codigo']};
            end if;
            if montoNota.tipim_codigo = 1 then
               update libro_venta set libven_iva5=libven_iva5-montoNota.total where ven_codigo={$_POST['ven_codigo']};
            end if;
            if (montoNota.tipim_codigo = 2) and (montoNota.tipit_codigo <> 3) then
               update libro_venta set libven_iva10=libven_iva10-montoNota.total where ven_codigo={$_POST['ven_codigo']};
            end if;
            if (montoNota.tipim_codigo = 2) and (montoNota.tipit_codigo = 3) then
               update libro_venta set libven_iva10=libven_iva10-notvendet_precio where ven_codigo={$_POST['ven_codigo']};	
               update cuenta_cobrar set cuenco_montototal=cuenco_montototal-notvendet_precio, 
               cuenco_montosaldo=cuenco_montosaldo-notvendet_precio
               where ven_codigo={$_POST['ven_codigo']};
            end if;
            if montoNota.tipim_codigo = 3 then
               update libro_venta set libven_exenta=libven_exenta-montoNota.total where ven_codigo={$_POST['ven_codigo']};
            end if;
         END LOOP;
      END $$;";

      $resultado2 = pg_query($conexion, $sql2);

      $sql4 = "select cuenco_montototal from cuenta_cobrar where ven_codigo={$_POST['ven_codigo']}";

      $resultado4 = pg_query($conexion, $sql4);
      $datos2 = pg_fetch_assoc($resultado4);

      if ($factura == 'CONTADO') {

         if (empty($totalMontoVenta)) {

            $sql3 = "update cuenta_cobrar set cuenco_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
            update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
            update venta_cab set ven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
            update venta_cab set vent_montocuota={$datos2['cuenco_montototal']} where ven_codigo={$_POST['ven_codigo']};";

         } else {

            $sql3 = "update cuenta_cobrar set cuenco_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']};
            update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
            update venta_cab set ven_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']};
            update venta_cab set vent_montocuota={$datos2['cuenco_montototal']} where ven_codigo={$_POST['ven_codigo']};";

         }

      }

      if ($factura == 'CREDITO') {

         $sql5 = "select vent_montocuota from venta_cab where ven_codigo={$_POST['ven_codigo']}";

         $resultado3 = pg_query($conexion, $sql5);
         $datos3 = pg_fetch_assoc($resultado3);

         $cantidadCuota = floatval($datos2['cuenco_montototal']) / floatval($datos3['vent_montocuota']);
         $cuota = ceil($cantidadCuota);

         if (floatval($datos2['cuenco_montototal']) == $totalMontoVenta) {

            $sql3 = "update cuenta_cobrar set cuenco_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']};
            update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
            update venta_cab set ven_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']};
            update venta_cab set ven_cuota=$cuota where ven_codigo={$_POST['ven_codigo']};
            update cuenta_cobrar set cuenco_nrocuota=$cuota where ven_codigo={$_POST['ven_codigo']};";

         } else {

            $sql3 = "update cuenta_cobrar set cuenco_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
            update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
            update venta_cab set ven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
            update venta_cab set ven_cuota=$cuota where ven_codigo={$_POST['ven_codigo']};
            update cuenta_cobrar set cuenco_nrocuota=$cuota where ven_codigo={$_POST['ven_codigo']};";

         }

      }

      $resultado3 = pg_query($conexion, $sql3);
   }

   if (($tipoComprobante == '1')) {

      $sql1 = "select sum(cobdet_monto) as totalmontoventa from cobro_det where ven_codigo={$_POST['ven_codigo']};";

      $resultado = pg_query($conexion, $sql1);
      $datos = pg_fetch_assoc($resultado);

      $totalMontoVenta = floatval($datos['totalmontoventa']);

      $sql2 = "
      DO $$
      DECLARE
         montoNota record;
      BEGIN
         FOR montoNota IN select notvendet_cantidad*notvendet_precio as total, notvendet_cantidad, notvendet_precio, 
         i.tipim_codigo, i.tipit_codigo, nvd.it_codigo  
         from nota_venta_det nvd 
         join nota_venta_cab nvc on nvc.notven_codigo=nvd.notven_codigo 
         join items i on i.it_codigo=nvd.it_codigo where ven_codigo={$_POST['ven_codigo']} and tipco_codigo=1
         LOOP
           update cuenta_cobrar set cuenco_montototal=cuenco_montototal+montoNota.total where ven_codigo={$_POST['ven_codigo']};
           update venta_det set vendet_cantidad=vendet_cantidad+montoNota.notvendet_cantidad where ven_codigo={$_POST['ven_codigo']}
           and it_codigo=montoNota.it_codigo;
            if montoNota.tipim_codigo = 1 then
               update libro_venta set libven_iva5=libven_iva5+montoNota.total where ven_codigo={$_POST['ven_codigo']};
            end if;
            if montoNota.tipim_codigo = 2 then
               update libro_venta set libven_iva10=libven_iva10+montoNota.total where ven_codigo={$_POST['ven_codigo']};
            end if;
            if montoNota.tipim_codigo = 3 then
               update libro_venta set libven_exenta=libven_exenta+montoNota.total where ven_codigo={$_POST['ven_codigo']};
            end if;
         END LOOP;
      END $$;";

      $resultado2 = pg_query($conexion, $sql2);

      $sql4 = "select cuenco_montototal from cuenta_cobrar where ven_codigo={$_POST['ven_codigo']}";

      $resultado4 = pg_query($conexion, $sql4);
      $datos2 = pg_fetch_assoc($resultado4);

      if ($factura == 'CONTADO') {

         if (empty($totalMontoVenta)) {

            $sql3 = "update cuenta_cobrar set cuenco_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
            update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
            update venta_cab set ven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
            update venta_cab set vent_montocuota={$datos2['cuenco_montototal']} where ven_codigo={$_POST['ven_codigo']};
            update cuenta_cobrar set cuenco_montosaldo={$datos2['cuenco_montototal']}-$totalMontoVenta where ven_codigo={$_POST['ven_codigo']};
            ";

         } else {

            $sql3 = "update cuenta_cobrar set cuenco_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']};
            update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
            update venta_cab set ven_estado='CANCELADO' where ven_codigo={$_POST['ven_codigo']};
            update venta_cab set vent_montocuota={$datos2['cuenco_montototal']} where ven_codigo={$_POST['ven_codigo']};
            update cuenta_cobrar set cuenco_montosaldo={$datos2['cuenco_montototal']}-$totalMontoVenta where ven_codigo={$_POST['ven_codigo']};";

         }

      }

      if ($factura == 'CREDITO') {

         $sql5 = "select vent_montocuota from venta_cab where ven_codigo={$_POST['ven_codigo']}";

         $resultado5 = pg_query($conexion, $sql5);
         $datos3 = pg_fetch_assoc($resultado5);

         $cantidadCuota = floatval($datos2['cuenco_montototal']) / floatval($datos3['vent_montocuota']);
         $cuota = ceil($cantidadCuota);

         $sql3 = "update cuenta_cobrar set cuenco_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
         update libro_venta set libven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
         update venta_cab set ven_estado='ACTIVO' where ven_codigo={$_POST['ven_codigo']};
         update venta_cab set ven_cuota=$cuota where ven_codigo={$_POST['ven_codigo']};
         update cuenta_cobrar set cuenco_nrocuota=$cuota where ven_codigo={$_POST['ven_codigo']};
         update cuenta_cobrar set cuenco_montosaldo={$datos2['cuenco_montototal']}-$totalMontoVenta where ven_codigo={$_POST['ven_codigo']};";

      }

      $resultado3 = pg_query($conexion, $sql3);

   }

}



?>