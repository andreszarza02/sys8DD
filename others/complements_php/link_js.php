<!--Referencias Archivos JS-->

<!-- Jquery Core Js -->
<script src="/sys8DD/plugins/jquery/jquery.min.js"></script>

<!-- Bootstrap Core Js -->
<script src="/sys8DD/plugins/bootstrap/js/bootstrap.js"></script>

<!-- Select Plugin Js -->
<script src="/sys8DD/plugins/bootstrap-select/js/bootstrap-select.js"></script>

<!-- Slimscroll Plugin Js -->
<script src="/sys8DD/plugins/jquery-slimscroll/jquery.slimscroll.js"></script>

<!-- Waves Effect Plugin Js -->
<script src="/sys8DD/plugins/node-waves/waves.js"></script>

<!-- Jquery CountTo Plugin Js -->
<script src="/sys8DD/plugins/jquery-countto/jquery.countTo.js"></script>

<!-- Morris Plugin Js -->
<script src="/sys8DD/plugins/raphael/raphael.min.js"></script>
<script src="/sys8DD/plugins/morrisjs/morris.js"></script>

<!-- ChartJs -->
<script src="/sys8DD/plugins/chartjs/Chart.bundle.js"></script>

<!-- Flot Charts Plugin Js -->
<script src="/sys8DD/plugins/flot-charts/jquery.flot.js"></script>
<script src="/sys8DD/plugins/flot-charts/jquery.flot.resize.js"></script>
<script src="/sys8DD/plugins/flot-charts/jquery.flot.pie.js"></script>
<script src="/sys8DD/plugins/flot-charts/jquery.flot.categories.js"></script>
<script src="/sys8DD/plugins/flot-charts/jquery.flot.time.js"></script>

<!-- Sparkline Chart Plugin Js -->
<script src="plugins/jquery-sparkline/jquery.sparkline.js"></script>

<!-- Validation Plugin Js -->
<script src="/sys8DD/plugins/jquery-validation/jquery.validate.js"></script>

<!-- Custom Js -->
<script src="/sys8DD/js/admin.js"></script>
<script src="/sys8DD/js/pages/index.js"></script>

<!-- Demo Js -->
<script src="/sys8DD/js/demo.js"></script>
<script src="/sys8DD/js/pages/examples/sign-in.js"></script>

<!-- Tema -->
<script src="/sys8DD/others/complements_js/tema.js"></script>

<!-- Alerts -->

<!-- SweetAlert Plugin Js -->
<script src="/sys8DD/plugins/sweetalert/sweetalert.min.js"></script>


<!-- tablas -->

<!-- Jquery DataTable Plugin Js -->
<script src="/sys8DD/plugins/jquery-datatable/jquery.dataTables.js"></script>
<script src="/sys8DD/plugins/jquery-datatable/skin/bootstrap/js/dataTables.bootstrap.js"></script>
<script src="/sys8DD/plugins/jquery-datatable/extensions/export/dataTables.buttons.min.js"></script>
<script src="/sys8DD/plugins/jquery-datatable/extensions/export/buttons.flash.min.js"></script>
<script src="/sys8DD/plugins/jquery-datatable/extensions/export/jszip.min.js"></script>
<script src="/sys8DD/plugins/jquery-datatable/extensions/export/pdfmake.min.js"></script>
<script src="/sys8DD/plugins/jquery-datatable/extensions/export/vfs_fonts.js"></script>
<script src="/sys8DD/plugins/jquery-datatable/extensions/export/buttons.html5.min.js"></script>
<script src="/sys8DD/plugins/jquery-datatable/extensions/export/buttons.print.min.js"></script>

<!-- fecha -->

<!-- Autosize Plugin Js -->
<script src="/sys8DD/plugins/autosize/autosize.js"></script>

<!-- Moment Plugin Js -->
<script src="/sys8DD/plugins/momentjs/moment.js"></script>

<!-- Bootstrap Material Datetime Picker Plugin Js -->
<script src="/sys8DD/plugins/bootstrap-material-datetimepicker/js/bootstrap-material-datetimepicker.js"></script>

<!-- Bootstrap Datepicker Plugin Js -->
<script src="/sys8DD/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>

<!-- Custom de Fecha Js -->
<script src="/sys8DD/js/pages/forms/basic-form-elements.js"></script>

<!-- Bootstrap Notify Plugin Js -->
<script src="/sys8DD/plugins/bootstrap-notify/bootstrap-notify.js"></script>

<!-- este metodo se encarga de activar el menu a la izquierda -->
<script>
   let activarMenu = () => {
      let url = window.location.pathname;
      $(".list li a").each(function () {
         let href = $(this).attr("href");
         if (url == href) {
            $(this).parent().addClass("active");
            $(this).parent().parent().parent().addClass("active");
            $(this).parent().parent().parent().parent().parent().addClass("active");
         }
      });
   };

   activarMenu();
</script>

<script src="/sys8DD/others/complements_js/busquedaMenu.js"></script>