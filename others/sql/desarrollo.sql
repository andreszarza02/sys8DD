--Tablas
CREATE TABLE tipo_documento (
                tipdo_codigo INTEGER NOT NULL,
                tipdo_descripcion VARCHAR NOT NULL,
                tipdo_estado VARCHAR NOT NULL,
                CONSTRAINT tipo_documento_pk PRIMARY KEY (tipdo_codigo)
);

CREATE TABLE personas (
                per_codigo INTEGER NOT NULL,
                per_nombre VARCHAR NOT NULL,
                per_apellido VARCHAR NOT NULL,
                per_numerodocumento VARCHAR NOT NULL,
                per_telefono VARCHAR NOT NULL,
                per_email VARCHAR NOT NULL,
                per_estado VARCHAR NOT NULL,
                tipdo_codigo INTEGER NOT NULL,
                CONSTRAINT personas_pk PRIMARY KEY (per_codigo)
);

CREATE TABLE ciudad (
                ciu_codigo INTEGER NOT NULL,
                ciu_descripcion VARCHAR NOT NULL,
                ciu_estado VARCHAR NOT NULL,
                CONSTRAINT ciudad_pk PRIMARY KEY (ciu_codigo)
);

CREATE TABLE empresa (
                emp_codigo INTEGER NOT NULL,
                emp_telefono VARCHAR NOT NULL,
                emp_razonsocial VARCHAR NOT NULL,
                emp_ruc VARCHAR NOT NULL,
                emp_email VARCHAR NOT NULL,
                emp_actividad VARCHAR NOT NULL,
                emp_estado VARCHAR NOT NULL,
                CONSTRAINT empresa_pk PRIMARY KEY (emp_codigo)
);

CREATE TABLE sucursal (
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                suc_descripcion VARCHAR NOT NULL,
                suc_direccion VARCHAR,
                suc_telefono VARCHAR,
                suc_estado VARCHAR NOT NULL,
                ciu_codigo INTEGER NOT NULL,
                CONSTRAINT sucursal_pk PRIMARY KEY (suc_codigo, emp_codigo)
);

CREATE TABLE cargo (
                car_codigo INTEGER NOT NULL,
                car_descripcion VARCHAR NOT NULL,
                car_estado VARCHAR NOT NULL,
                CONSTRAINT cargo_pk PRIMARY KEY (car_codigo)
);

CREATE TABLE funcionario (
                func_codigo INTEGER NOT NULL,
                fun_fechaingreso DATE NOT NULL,
                func_estado VARCHAR NOT NULL,
                per_codigo INTEGER NOT NULL,
                ciu_codigo INTEGER NOT NULL,
                car_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT funcionario_pk PRIMARY KEY (func_codigo)
);

CREATE TABLE perfil (
                perf_codigo INTEGER NOT NULL,
                perf_descripcion VARCHAR NOT NULL,
                perf_estado VARCHAR NOT NULL,
                CONSTRAINT perfil_pk PRIMARY KEY (perf_codigo)
);

CREATE TABLE modulo (
                modu_codigo INTEGER NOT NULL,
                modu_descripcion VARCHAR NOT NULL,
                modu_estado VARCHAR NOT NULL,
                CONSTRAINT modulo_pk PRIMARY KEY (modu_codigo)
);

CREATE TABLE usuario (
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                usu_contrasenia VARCHAR NOT NULL,
                usu_estado VARCHAR NOT NULL,
                usu_fecha DATE NOT NULL,
                modu_codigo INTEGER NOT NULL,
                perf_codigo INTEGER NOT NULL,
                func_codigo INTEGER NOT NULL,
                CONSTRAINT usuario_pk PRIMARY KEY (usu_codigo)
);

CREATE TABLE gui (
                gui_codigo INTEGER NOT NULL,
                modu_codigo INTEGER NOT NULL,
                gui_descripcion VARCHAR NOT NULL,
                gui_estado VARCHAR NOT NULL,
                CONSTRAINT gui_pk PRIMARY KEY (gui_codigo, modu_codigo)
);

CREATE TABLE permisos (
                perm_codigo INTEGER NOT NULL,
                perm_descripcion VARCHAR NOT NULL,
                perm_estado VARCHAR NOT NULL,
                CONSTRAINT permisos_pk PRIMARY KEY (perm_codigo)
);

CREATE TABLE acceso (
                acc_codigo INTEGER NOT NULL,
                acc_usuario VARCHAR NOT NULL,
                acc_fecha DATE NOT NULL,
                acc_hora TIME NOT NULL,
                acc_obs VARCHAR NOT NULL,
                CONSTRAINT acceso_pk PRIMARY KEY (acc_codigo)
);

CREATE TABLE perfiles_permisos (
				perfpe_codigo INTEGER NOT NULL,
                perf_codigo INTEGER NOT NULL,
                perm_codigo INTEGER NOT NULL,
                perfpe_estado VARCHAR NOT NULL,
                CONSTRAINT perfiles_permisos_pk PRIMARY KEY (perfpe_codigo, perf_codigo, perm_codigo)
);

CREATE TABLE perfil_gui (
				perfgui_codigo INTEGER NOT NULL,
                perf_codigo INTEGER NOT NULL,
                gui_codigo INTEGER NOT NULL,
                modu_codigo INTEGER NOT NULL,
                perfgui_estado VARCHAR NOT NULL,
                CONSTRAINT perfil_gui_pk PRIMARY KEY (perfgui_codigo, perf_codigo, gui_codigo, modu_codigo)
);

CREATE TABLE asignacion_permiso_usuario (
				asigperm_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                perfpe_codigo INTEGER NOT NULL,
                perf_codigo INTEGER NOT NULL,
                perm_codigo INTEGER NOT NULL,
                asigperm_estado VARCHAR NOT NULL,
                CONSTRAINT asignacion_permiso_usuario_pk PRIMARY KEY (asigperm_codigo, usu_codigo, perfpe_codigo, perf_codigo, perm_codigo)
);

CREATE TABLE tipo_impuesto (
                tipim_codigo INTEGER NOT NULL,
                tipim_descripcion VARCHAR NOT NULL,
                tipim_estado VARCHAR NOT NULL,
                CONSTRAINT tipo_impuesto_pk PRIMARY KEY (tipim_codigo)
);

CREATE TABLE tipo_proveedor (
                tipro_codigo INTEGER NOT NULL,
                tipro_descripcion VARCHAR NOT NULL,
                tipro_estado VARCHAR NOT NULL,
                CONSTRAINT tipo_proveedor_pk PRIMARY KEY (tipro_codigo)
);

CREATE TABLE tipo_item (
                tipit_codigo INTEGER NOT NULL,
                tipit_descripcion VARCHAR NOT NULL,
                tipit_estado VARCHAR NOT NULL,
                CONSTRAINT tipo_item_pk PRIMARY KEY (tipit_codigo)
);

CREATE TABLE proveedor (
                pro_codigo INTEGER NOT NULL,
                tipro_codigo INTEGER NOT NULL,
                pro_razonsocial VARCHAR NOT NULL,
                pro_ruc VARCHAR NOT NULL,
                pro_direccion VARCHAR,
                pro_telefono VARCHAR NOT NULL,
                pro_email VARCHAR,
                pro_estado VARCHAR NOT NULL,
                CONSTRAINT proveedor_pk PRIMARY KEY (pro_codigo, tipro_codigo)
);

CREATE TABLE deposito (
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                dep_descripcion VARCHAR NOT NULL,
                dep_estado VARCHAR NOT NULL,
                ciu_codigo INTEGER NOT NULL,
                CONSTRAINT deposito_pk PRIMARY KEY (dep_codigo, suc_codigo, emp_codigo)
);

CREATE TABLE talle (
                tall_codigo INTEGER NOT NULL,
                tall_descripcion VARCHAR NOT NULL,
                tall_estado VARCHAR NOT NULL,
                CONSTRAINT talle_pk PRIMARY KEY (tall_codigo)
);

CREATE TABLE color_prenda (
                col_codigo INTEGER NOT NULL,
                col_descripcion VARCHAR NOT NULL,
                col_estado VARCHAR NOT NULL,
                CONSTRAINT color_prenda_pk PRIMARY KEY (col_codigo)
);

CREATE TABLE modelo (
                mod_codigo INTEGER NOT NULL,
                mod_codigomodelo INTEGER NOT NULL,
                mod_sexo sexo NOT NULL,
                mod_observacion VARCHAR,
                mod_estado VARCHAR NOT NULL,
                col_codigo INTEGER NOT NULL,
                CONSTRAINT modelo_pk PRIMARY KEY (mod_codigo)
);

CREATE TABLE items (
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                it_descripcion VARCHAR NOT NULL,
                it_costo NUMERIC NOT NULL,
                it_precio NUMERIC NOT NULL,
                it_estado VARCHAR NOT NULL,
                mod_codigo INTEGER NOT NULL,
                tall_codigo INTEGER NOT NULL,
                tipim_codigo INTEGER NOT NULL,
                CONSTRAINT items_pk PRIMARY KEY (it_codigo, tipit_codigo)
);

CREATE TABLE tipo_comprobante (
                tipco_codigo INTEGER NOT NULL,
                tipco_descripcion VARCHAR NOT NULL,
                tipco_estado VARCHAR NOT NULL,
                CONSTRAINT tipo_comprobante_pk PRIMARY KEY (tipco_codigo)
);

CREATE TABLE forma_cobro (
                forco_codigo INTEGER NOT NULL,
                forco_descripcion VARCHAR NOT NULL,
                forco_estado VARCHAR NOT NULL,
                CONSTRAINT forma_cobro_pk PRIMARY KEY (forco_codigo)
);

CREATE TABLE marca_tarjeta (
                marta_codigo INTEGER NOT NULL,
                marta_descripcion VARCHAR NOT NULL,
                marta_estado VARCHAR NOT NULL,
                CONSTRAINT marca_tarjeta_pk PRIMARY KEY (marta_codigo)
);

CREATE TABLE entidad_emisora (
                ent_codigo INTEGER NOT NULL,
                ent_razonsocial VARCHAR NOT NULL,
                ent_ruc VARCHAR NOT NULL,
                ent_telefono VARCHAR NOT NULL,
                ent_email VARCHAR NOT NULL,
                ent_estado VARCHAR NOT NULL,
                CONSTRAINT entidad_emisora_pk PRIMARY KEY (ent_codigo)
);

CREATE TABLE entidad_adherida (
                entad_codigo INTEGER NOT NULL,
                ent_codigo INTEGER NOT NULL,
                marta_codigo INTEGER NOT NULL,
                entad_estado VARCHAR NOT NULL,
                CONSTRAINT entidad_adherida_pk PRIMARY KEY (entad_codigo, ent_codigo, marta_codigo)
);

CREATE TABLE caja (
                caj_codigo INTEGER NOT NULL,
                caj_descripcion VARCHAR NOT NULL,
                caj_estado VARCHAR NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT caja_pk PRIMARY KEY (caj_codigo)
);

CREATE TABLE maquinaria (
                maq_codigo INTEGER NOT NULL,
                maq_descripcion VARCHAR NOT NULL,
                maq_estado VARCHAR NOT NULL,
                CONSTRAINT maquinaria_pk PRIMARY KEY (maq_codigo)
);

CREATE TABLE cliente (
                cli_codigo INTEGER NOT NULL,
                cli_direccion VARCHAR NOT NULL,
                cli_tipocliente tipo_cliente NOT NULL,
                cli_estado VARCHAR NOT NULL,
                per_codigo INTEGER NOT NULL,
                ciu_codigo INTEGER NOT NULL,
                CONSTRAINT cliente_pk PRIMARY KEY (cli_codigo)
);

CREATE TABLE tipo_etapa_produccion (
                tipet_codigo INTEGER NOT NULL,
                tipet_descripcion VARCHAR NOT NULL,
                tipet_estado VARCHAR NOT NULL,
                CONSTRAINT tipo_etapa_produccion_pk PRIMARY KEY (tipet_codigo)
);

CREATE TABLE unidad_medida (
                unime_codigo INTEGER NOT NULL,
                unime_descripcion VARCHAR NOT NULL,
                unime_estado VARCHAR NOT NULL,
                CONSTRAINT unidad_medida_pk PRIMARY KEY (unime_codigo)
);

CREATE TABLE parametro_control_calidad (
                pacoca_codigo INTEGER NOT NULL,
                pacoca_descripcion VARCHAR NOT NULL,
                pacoca_estado VARCHAR NOT NULL,
                CONSTRAINT parametro_control_calidad_pk PRIMARY KEY (pacoca_codigo)
);

CREATE TABLE costo_servicio (
                costserv_codigo INTEGER NOT NULL,
                costserv_costo NUMERIC NOT NULL,
                costserv_estado VARCHAR NOT NULL,
                mod_codigo INTEGER NOT NULL,
                CONSTRAINT costo_servicio_pk PRIMARY KEY (costserv_codigo)
);

CREATE TABLE seccion (
                secc_codigo INTEGER NOT NULL,
                secc_descripcion VARCHAR NOT NULL,
                secc_estado VARCHAR NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT seccion_pk PRIMARY KEY (secc_codigo)
);

CREATE TABLE equipo_trabajo (
                func_codigo INTEGER NOT NULL,
                secc_codigo INTEGER NOT NULL,
                eqtra_estado VARCHAR NOT NULL,
                CONSTRAINT equipo_trabajo_pk PRIMARY KEY (func_codigo, secc_codigo)
);
 
CREATE TABLE pedido_compra_cab (
                pedco_codigo INTEGER NOT NULL,
                pedco_fecha DATE NOT NULL,
                pedco_estado VARCHAR NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                CONSTRAINT pedido_compra_cab_pk PRIMARY KEY (pedco_codigo)
);

CREATE TABLE pedido_compra_det (
                pedco_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                pedcodet_cantidad NUMERIC NOT NULL,
                pedcodet_precio NUMERIC NOT NULL,
                CONSTRAINT pedido_compra_det_pk PRIMARY KEY (pedco_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE presupuesto_proveedor_cab (
                prepro_codigo INTEGER NOT NULL,
                prepro_fechaactual DATE NOT NULL,
                prepro_estado VARCHAR NOT NULL,
                prepro_fechavencimiento DATE NOT NULL,
                usu_codigo INTEGER NOT NULL,
                pro_codigo INTEGER NOT NULL,
                tipro_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT presupuesto_proveedor_cab_pk PRIMARY KEY (prepro_codigo)
);

CREATE TABLE presupuesto_proveedor_det (
                prepro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                peprodet_cantidad NUMERIC NOT NULL,
                peprodet_precio NUMERIC NOT NULL,
                CONSTRAINT presupuesto_proveedor_det_pk PRIMARY KEY (prepro_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE pedido_presupuesto (
                pedco_codigo INTEGER NOT NULL,
                prepro_codigo INTEGER NOT NULL,
                pedpre_codigo INTEGER NOT NULL,
                CONSTRAINT pedido_presupuesto_pk PRIMARY KEY (pedco_codigo, prepro_codigo, pedpre_codigo)
);

CREATE TABLE orden_compra_cab (
                orcom_codigo INTEGER NOT NULL,
                orcom_fecha DATE NOT NULL,
                orcom_condicionpago condicion_pago NOT NULL,
                orcom_cuota INTEGER,
                orcom_interfecha VARCHAR,
                orcom_estado VARCHAR NOT NULL,
                usu_codigo INTEGER NOT NULL,
                pro_codigo INTEGER NOT NULL,
                tipro_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT orden_compra_cab_pk PRIMARY KEY (orcom_codigo)
);

CREATE TABLE orden_compra_det (
                orcom_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                orcomdet_cantidad NUMERIC NOT NULL,
                orcomdet_precio NUMERIC NOT NULL,
                CONSTRAINT orden_compra_det_pk PRIMARY KEY (orcom_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE presupuesto_orden (
                orcom_codigo INTEGER NOT NULL,
                prepro_codigo INTEGER NOT NULL,
                presor_codigo INTEGER NOT NULL,
                CONSTRAINT presupuesto_orden_pk PRIMARY KEY (orcom_codigo, prepro_codigo, presor_codigo)
);

CREATE TABLE ajuste_stock_cab (
                ajus_codigo INTEGER NOT NULL,
                ajus_fecha DATE NOT NULL,
                ajus_tipoajuste tipo_ajuste NOT NULL,
                ajus_estado VARCHAR NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                ajus_audit TEXT NOT NULL,
                CONSTRAINT ajuste_stock_cab_pk PRIMARY KEY (ajus_codigo)
);

CREATE TABLE ajuste_stock_det (
                ajus_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                ajuindet_cantidad NUMERIC NOT NULL,
                ajusdet_precio NUMERIC NOT NULL, 
                ajuindet_motivo VARCHAR NOT NULL,
                CONSTRAINT ajuste_stock_det_pk PRIMARY KEY (ajus_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
);

CREATE TABLE ajuste_stock_det_auditoria (
                ajusdetaud_codigo integer NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                ajusdetaud_fecha TIMESTAMP NOT NULL,
                ajusdetaud_procedimiento VARCHAR NOT NULL,
                ajus_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                ajusdet_cantidad NUMERIC NOT NULL,
                ajusdet_precio NUMERIC NOT NULL,
                ajusdet_motivo VARCHAR NOT NULL,
                CONSTRAINT ajuste_stock_det_auditoria_pk PRIMARY KEY (ajusdetaud_codigo)
);

CREATE TABLE stock (
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                st_cantidad NUMERIC NOT NULL,
                unime_codigo INTEGER NOT NULL,
                CONSTRAINT stock_pk PRIMARY KEY (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
);

CREATE TABLE pedido_venta_cab (
                peven_codigo INTEGER NOT NULL,
                peven_fecha DATE NOT NULL,
                peven_estado VARCHAR NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                cli_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                CONSTRAINT pedido_venta_cab_pk PRIMARY KEY (peven_codigo)
);

CREATE TABLE pedido_venta_det (
                peven_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                pevendet_cantidad INTEGER NOT NULL,
                pevendet_precio NUMERIC NOT NULL,
                CONSTRAINT pedido_venta_det_pk PRIMARY KEY (peven_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE compra_cab (
                comp_codigo INTEGER NOT NULL,
                comp_fecha DATE NOT NULL,
                com_numfactura VARCHAR NOT NULL,
                comp_tipofactura VARCHAR NOT NULL,
                comp_cuota INTEGER,
                comp_interfecha VARCHAR,
                comp_estado VARCHAR NOT NULL,
                pro_codigo INTEGER NOT NULL,
                tipro_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                CONSTRAINT compra_cab_pk PRIMARY KEY (comp_codigo)
);

CREATE TABLE compra_det (
                comp_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                compdet_cantidad NUMERIC NOT NULL,
                compdet_precio NUMERIC NOT NULL,
                CONSTRAINT compra_det_pk PRIMARY KEY (comp_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
);

CREATE TABLE orden_compra (
                comp_codigo INTEGER NOT NULL,
                orcom_codigo INTEGER NOT NULL,
                ordencom_codigo INTEGER NOT NULL,
                CONSTRAINT orden_compra_pk PRIMARY KEY (comp_codigo, orcom_codigo, ordencom_codigo)
);

CREATE TABLE libro_compra (
                licom_codigo INTEGER NOT NULL,
                comp_codigo INTEGER NOT NULL,
                licom_exenta NUMERIC,
                licom_iva5 NUMERIC,
                licom_iva10 NUMERIC,
                licom_fecha DATE NOT NULL,
                licom_numerofactura VARCHAR NOT NULL,
                licom_estado VARCHAR NOT NULL,
                CONSTRAINT libro_compra_pk PRIMARY KEY (licom_codigo, comp_codigo)
);

CREATE TABLE cuenta_pagar (
                comp_codigo INTEGER NOT NULL,
                cuenpa_nrocuota INTEGER,
                cuenpa_montototal NUMERIC NOT NULL,
                cuenpa_montosaldo NUMERIC NOT NULL,
                cuenpa_estado VARCHAR NOT NULL,
                CONSTRAINT cuenta_pagar_pk PRIMARY KEY (comp_codigo)
);

CREATE TABLE nota_compra_cab (
                nocom_codigo INTEGER NOT NULL,
                nocom_fecha DATE NOT NULL,
                nocom_numeronota VARCHAR NOT NULL,
                nocom_concepto VARCHAR NOT NULL,
                nocom_estado VARCHAR NOT NULL,
                tipco_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                comp_codigo INTEGER NOT NULL,
                pro_codigo INTEGER NOT NULL,
                tipro_codigo INTEGER NOT NULL,
                CONSTRAINT nota_compra_cab_pk PRIMARY KEY (nocom_codigo)
);

CREATE TABLE nota_compra_det (
                nocom_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                nocomdet_cantidad NUMERIC NOT NULL,
                nocomdet_precio NUMERIC NOT NULL,
                CONSTRAINT nota_compra_det_pk PRIMARY KEY (nocom_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE pedido_produccion_cab (
                pedpro_codigo INTEGER NOT NULL,
                pedpro_fecha DATE NOT NULL,
                pedpro_estado VARCHAR NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT pedido_produccion_cab_pk PRIMARY KEY (pedpro_codigo)
);

CREATE TABLE pedido_produccion_det (
                pedpro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                pedprodet_cantidad NUMERIC NOT NULL,
                pedprodet_precio NUMERIC NOT NULL,
                CONSTRAINT pedido_produccion_det_pk PRIMARY KEY (pedpro_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE presupuesto_cab (
                pres_codigo INTEGER NOT NULL,
                pres_fecharegistro DATE NOT NULL,
                pres_fechavencimiento DATE NOT NULL,
                pres_estado VARCHAR NOT NULL,
                peven_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                cli_codigo INTEGER NOT NULL,
                CONSTRAINT presupuesto_cab_pk PRIMARY KEY (pres_codigo)
);

CREATE TABLE presupuesto_det (
                pres_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                presdet_cantidad INTEGER NOT NULL,
                presdet_precio NUMERIC NOT NULL,
                CONSTRAINT presupuesto_det_pk PRIMARY KEY (pres_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE orden_produccion_cab (
                orpro_codigo INTEGER NOT NULL,
                orpro_fecha DATE NOT NULL,
                orpro_fechainicio DATE NOT NULL,
                orpro_fechaculminacion DATE NOT NULL,
                orpro_estado VARCHAR NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                secc_codigo INTEGER NOT NULL,
                CONSTRAINT orden_produccion_cab_pk PRIMARY KEY (orpro_codigo)
);

CREATE TABLE orden_produccion_det (
                orpro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                orprodet_especificacion VARCHAR NOT NULL,
                orprodet_cantidad INTEGER NOT NULL,
                CONSTRAINT orden_produccion_det_pk PRIMARY KEY (orpro_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE orden_produccion_det2 (
                orpro_codigo INTEGER NOT NULL,
                compro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                orprodet2_cantidad NUMERIC NOT NULL,
                CONSTRAINT orden_produccion_det2_pk PRIMARY KEY (orpro_codigo, compro_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE orden_presupuesto (
                orpre_codigo INTEGER NOT NULL,
                orpro_codigo INTEGER NOT NULL,
                pres_codigo INTEGER NOT NULL,
                CONSTRAINT orden_presupuesto_pk PRIMARY KEY (orpre_codigo, orpro_codigo, pres_codigo)
);

CREATE TABLE produccion_cab (
                prod_codigo INTEGER NOT NULL,
                prod_fecha DATE NOT NULL,
                prod_estado VARCHAR NOT NULL,
                orpro_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT produccion_cab_pk PRIMARY KEY (prod_codigo)
);

CREATE TABLE produccion_det (
                prod_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                prodet_cantidad INTEGER NOT NULL,
                prodet_fechainicio DATE NOT NULL,
                prodet_fechafinal DATE NOT NULL,
                prodet_observacion VARCHAR NOT NULL,
                CONSTRAINT produccion_det_pk PRIMARY KEY (prod_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE etapa_produccion (
                prod_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                tipet_codigo INTEGER NOT NULL,
                etpro_fecha DATE NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                maq_codigo INTEGER NOT NULL,
                CONSTRAINT etapa_produccion_pk PRIMARY KEY (prod_codigo, it_codigo, tipit_codigo, tipet_codigo)
);		


CREATE TABLE apertura_cierre (
                apercie_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                caj_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                apercie_fechahoraapertura TIMESTAMP,
                apercie_fechahoracierre TIMESTAMP,
                apercie_montoapertura NUMERIC,
                apercie_montocierre NUMERIC,
                apercie_estado VARCHAR NOT NULL,
                CONSTRAINT apertura_cierre_pk PRIMARY KEY (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
);


CREATE TABLE venta_cab (
                ven_codigo INTEGER NOT NULL,
                ven_fecha DATE NOT NULL,
                ven_numfactura VARCHAR NOT NULL,
                ven_tipofactura VARCHAR NOT NULL,
                ven_cuota INTEGER NOT NULL,
                vent_montocuota NUMERIC NOT NULL,
                ven_interfecha VARCHAR NOT NULL,
                ven_estado VARCHAR NOT NULL,
                usu_codigo INTEGER NOT NULL,
                cli_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT venta_cab_pk PRIMARY KEY (ven_codigo)
);

CREATE TABLE venta_det (
                ven_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                vendet_cantidad INTEGER NOT NULL,
                vendet_precio NUMERIC NOT NULL,
                CONSTRAINT venta_det_pk PRIMARY KEY (ven_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
);

CREATE TABLE pedido_venta (
                ven_codigo INTEGER NOT NULL,
                peven_codigo INTEGER NOT NULL,
                pedidoven_codigo INTEGER NOT NULL,
                CONSTRAINT pedido_venta_pk PRIMARY KEY (ven_codigo, peven_codigo, pedidoven_codigo)
);

CREATE TABLE libro_venta (
                libven_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                libven_exenta NUMERIC NOT NULL,
                libven_iva5 NUMERIC NOT NULL,
                libven_iva10 NUMERIC NOT NULL,
                libven_fecha DATE NOT NULL,
                libven_numfactura VARCHAR NOT NULL,
                libven_estado VARCHAR NOT NULL,
                CONSTRAINT libro_venta_pk PRIMARY KEY (libven_codigo, ven_codigo)
);

CREATE TABLE cuenta_cobrar (
                ven_codigo INTEGER NOT NULL,
                cuenco_nrocuota INTEGER	NOT NULL,
                cuenco_montototal NUMERIC NOT NULL,
                cuenco_montosaldo NUMERIC NOT NULL,
                cuenco_estado VARCHAR NOT NULL,
                CONSTRAINT cuenta_cobrar_pk PRIMARY KEY (ven_codigo)
);


CREATE TABLE cobro_cab (
                cob_codigo INTEGER NOT NULL,
                cob_fecha DATE NOT NULL,
                cob_estado VARCHAR NOT NULL,
                apercie_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                caj_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                CONSTRAINT cobro_cab_pk PRIMARY KEY (cob_codigo)
);

CREATE TABLE cobro_det (
                cobdet_codigo INTEGER NOT NULL,
                cob_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                cobdet_monto NUMERIC NOT NULL,
                cobdet_numerocuota INTEGER NOT NULL,
                forco_codigo INTEGER NOT NULL,
                CONSTRAINT cobro_det_pk PRIMARY KEY (cobdet_codigo, cob_codigo, ven_codigo)
);

CREATE TABLE cobro_cheque (
                coche_codigo INTEGER NOT NULL,
                coche_numero VARCHAR NOT NULL,
                coche_monto NUMERIC NOT NULL,
                coche_tipocheque tipo_cheque NOT NULL,
                coche_fechavencimiento DATE NOT NULL,
                ent_codigo INTEGER NOT NULL,
                cob_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                cobdet_codigo INTEGER NOT NULL,
                CONSTRAINT cobro_cheque_pk PRIMARY KEY (coche_codigo)
);


CREATE TABLE cobro_tarjeta (
                cobta_codigo INTEGER NOT NULL,
                cobta_numero VARCHAR NOT NULL,
                cobta_monto NUMERIC NOT NULL,
                cobta_tipotarjeta VARCHAR NOT NULL,
                cobta_estado VARCHAR NOT NULL,
                entad_codigo INTEGER NOT NULL,
                ent_codigo INTEGER NOT NULL,
                marta_codigo in TEGER NOT NULL,
                cob_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                cobdet_codigo INTEGER NOT NULL,
                CONSTRAINT cobro_tarjeta_pk PRIMARY KEY (cobta_codigo)
);


CREATE TABLE nota_venta_cab (
                notven_codigo INTEGER NOT NULL,
                notven_fecha DATE NOT NULL,
                notven_numeronota VARCHAR NOT NULL,
                notven_concepto VARCHAR NOT NULL,
                notven_estado VARCHAR NOT NULL,
                tipco_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                cli_codigo INTEGER NOT NULL,
                CONSTRAINT nota_venta_cab_pk PRIMARY KEY (notven_codigo)
);

CREATE TABLE nota_venta_det (
                notven_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                notvendet_cantidad INTEGER NOT NULL,
                notvendet_precio NUMERIC NOT NULL,
                CONSTRAINT nota_venta_det_pk PRIMARY KEY (notven_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE recaudacion_depositar (
                rec_codigo INTEGER NOT NULL,
                apercie_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                caj_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                rec_montoefectivo NUMERIC NOT NULL,
                rec_montocheque NUMERIC NOT NULL,
                rec_estado VARCHAR NOT NULL,
                CONSTRAINT recaudacion_depositar_pk PRIMARY KEY (rec_codigo, apercie_codigo, 
                suc_codigo, emp_codigo, caj_codigo, usu_codigo)
);


CREATE TABLE arqueo_control (
                arco_codigo INTEGER NOT NULL,
                apercie_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                caj_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                arco_observacion VARCHAR NOT NULL,
                arco_fecha DATE NOT NULL,
                func_codigo INTEGER NOT NULL,
                CONSTRAINT arqueo_control_pk PRIMARY KEY (arco_codigo, apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
);

CREATE TABLE acceso_control (
                accon_codigo INTEGER NOT NULL,
                accon_usuario VARCHAR NOT NULL,
                accon_clave VARCHAR NOT NULL,
                accon_fecha DATE NOT NULL,
                accon_hora TIME NOT NULL,
                accon_observacion VARCHAR NOT NULL,
                accon_intentos INTEGER NOT NULL,
                CONSTRAINT acceso_control_pk PRIMARY KEY (accon_codigo)
);

CREATE TABLE actualizacion_contrasenia (
                accontra_codigo INTEGER NOT NULL,
                accontra_usuario VARCHAR NOT NULL,
                accontra_clave VARCHAR NOT NULL,
                accontra_fecha DATE NOT NULL,
                accontra_hora TIME NOT NULL,
                accontra_observacion VARCHAR NOT NULL,
                accontra_intentos INTEGER NOT NULL,
                CONSTRAINT actualizacion_contrasenia_pk PRIMARY KEY (accontra_codigo)
);

CREATE TABLE pedido_compra_det_auditoria (
                pedcodetaud_codigo integer NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                pedcodetaud_fecha TIMESTAMP,
                pedcodetaud_procedimiento VARCHAR NOT NULL,
                pedco_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                pedcodet_cantidad NUMERIC NOT NULL,
                pedcodet_precio NUMERIC NOT NULL,
                CONSTRAINT pedido_compra_det_auditoria_pk PRIMARY KEY (pedcodetaud_codigo)
);

CREATE TABLE presupuesto_proveedor_det_auditoria (
                preprodetaud_codigo integer NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                preprodetaud_fecha TIMESTAMP,
                preprodetaud_procedimiento VARCHAR NOT NULL,
                prepro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                peprodet_cantidad NUMERIC NOT NULL,
                peprodet_precio NUMERIC NOT NULL,
                CONSTRAINT presupuesto_proveedor_det_auditoria_pk PRIMARY KEY (preprodetaud_codigo)
);

CREATE TABLE orden_compra_det_auditoria (
                orcomdetaud_codigo integer NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                orcomdetaud_fecha TIMESTAMP,
                orcomdetaud_procedimiento VARCHAR NOT NULL,
                orcom_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                orcomdet_cantidad NUMERIC NOT NULL,
                orcomdet_precio NUMERIC NOT NULL,
                CONSTRAINT orden_compra_det_auditoria_pk PRIMARY KEY (orcomdetaud_codigo)
);

CREATE TABLE compra_det_auditoria (
                compdetaud_codigo integer NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                compdetaud_fecha TIMESTAMP NOT NULL,
                compdetaud_procedimiento VARCHAR NOT NULL,
                comp_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                compdet_cantidad NUMERIC NOT NULL,
                compdet_precio NUMERIC NOT NULL,
                CONSTRAINT compra_det_auditoria_pk PRIMARY KEY (compdetaud_codigo)
);

CREATE TABLE ajuste_inventario_det_auditoria (
                ajuindetaud_codigo integer NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                ajuindetaud_fecha TIMESTAMP NOT NULL,
                ajuindetaud_procedimiento VARCHAR NOT NULL,
                ajuin_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                ajuindet_cantidad NUMERIC NOT NULL,
                ajuindet_motivo VARCHAR NOT NULL,
                ajuindet_precio NUMERIC NOT NULL,
                CONSTRAINT ajuste_inventario_det_auditoria_pk PRIMARY KEY (ajuindetaud_codigo)
);

CREATE TABLE nota_compra_det_auditoria (
                nocomdetaud_codigo integer NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                nocomdetaud_fecha TIMESTAMP NOT NULL,
                nocomdetaud_procedimiento VARCHAR NOT NULL,
                nocom_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                nocomdet_cantidad NUMERIC NOT NULL,
                nocomdet_precio NUMERIC NOT NULL,
                CONSTRAINT nota_compra_det_auditoria_pk PRIMARY KEY (nocomdetaud_codigo)
);

CREATE TABLE stock_auditoria (
				staud_codigo INTEGER NOT NULL, 
				staud_fecha TIMESTAMP NOT NULL,
				staud_procedimiento VARCHAR NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                st_cantidad NUMERIC NOT NULL,
                CONSTRAINT stock_auditoria_pk PRIMARY KEY (staud_codigo)
);

CREATE TABLE pedido_venta_det_auditoria (
                pevendetaud_codigo integer NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                pevendetaud_fecha TIMESTAMP NOT NULL,
                pevendetaud_procedimiento VARCHAR NOT NULL,
                peven_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                pevendet_cantidad NUMERIC NOT NULL,
                pevendet_precio NUMERIC NOT NULL,
                CONSTRAINT pedido_venta_det_auditoria_pk PRIMARY KEY (pevendetaud_codigo)
);

CREATE TABLE presupuesto_det_auditoria (
                presdetaud_codigo integer NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                presdetaud_fecha TIMESTAMP NOT NULL,
                presdetaud_procedimiento VARCHAR NOT NULL,
                pres_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                presdet_cantidad INTEGER NOT NULL,
                presdet_precio NUMERIC NOT NULL,
                CONSTRAINT presupuesto_det_auditoria_pk PRIMARY KEY (presdetaud_codigo)
);

CREATE TABLE orden_produccion_det_auditoria (
                orprodetaud_codigo integer NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                orprodetaud_fecha TIMESTAMP NOT NULL,
                orprodetaud_procedimiento VARCHAR NOT NULL,
                orpro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                orprodet_especificacion VARCHAR NOT NULL,
                orprodet_cantidad INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT null,
                CONSTRAINT orden_produccion_det_auditoria_pk PRIMARY KEY (orprodetaud_codigo)
);

CREATE TABLE componente_produccion_cab (
                compro_codigo INTEGER NOT NULL,
                compro_fecha DATE NOT NULL,
                compro_estado VARCHAR NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                compro_audit TEXT,
                CONSTRAINT componente_produccion_cab_pk PRIMARY KEY (compro_codigo)
);

CREATE TABLE componente_produccion_det (
                compro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                comprodet_cantidad NUMERIC NOT NULL,
                CONSTRAINT componente_produccion_det_pk PRIMARY KEY (compro_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE componente_produccion_det_auditoria (
                comprodetaud_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                comprodetaud_fecha TIMESTAMP NOT NULL,
                comprodetaud_procedimiento VARCHAR NOT NULL,
                compro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                comprodet_cantidad NUMERIC NOT NULL,
                CONSTRAINT componente_produccion_det_auditoria_pk PRIMARY KEY (comprodetaud_codigo)
);

CREATE TABLE orden_produccion_det2_auditoria (
                orprodet2aud_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                orprodet2aud_fecha TIMESTAMP NOT NULL,
                orprodet2aud_procedimiento VARCHAR NOT NULL,
                orpro_codigo INTEGER NOT NULL,
                compro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                orprodet2_cantidad NUMERIC NOT NULL,
                CONSTRAINT orden_produccion_det2_auditoria_pk PRIMARY KEY (orprodet2aud_codigo)
);

CREATE TABLE produccion_det_auditoria (
                prodetaud_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                prodetaud_fecha TIMESTAMP NOT NULL,
                prodetaud_procedimiento VARCHAR NOT NULL,
                prod_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                prodet_cantidad INTEGER NOT NULL,
                prodet_fechainicio DATE NOT NULL,
                prodet_fechafinal DATE NOT NULL,
                prodet_observacion VARCHAR NOT NULL,
                prodet_estado VARCHAR NOT NULL,
                CONSTRAINT produccion_det_auditoria_pk PRIMARY KEY (prodetaud_codigo)
);

CREATE TABLE etapa_produccion_auditoria (
                etproaud_codigo INTEGER NOT NULL,
                etproaud_fecha TIMESTAMP NOT NULL,
                etproaud_procedimiento VARCHAR NOT NULL,
                prod_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                tipet_codigo INTEGER NOT NULL,
                etpro_fecha DATE NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                maq_codigo INTEGER NOT NULL,
                CONSTRAINT tapa_produccion_auditoria_pk PRIMARY KEY (etproaud_codigo)
);

CREATE TABLE produccion_terminada_cab (
                proter_codigo INTEGER NOT NULL,
                proter_fecha DATE NOT NULL,
                proter_fechaculminacion DATE NOT NULL,
                proter_estado VARCHAR NOT NULL,
                prod_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                proter_audit TEXT,
                CONSTRAINT produccion_terminada_cab_pk PRIMARY KEY (proter_codigo)
);

CREATE TABLE produccion_terminada_det (
                proter_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                proterdet_cantidad INTEGER NOT NULL,
                CONSTRAINT produccion_terminada_det_pk PRIMARY KEY (proter_codigo, it_codigo, tipit_codigo, dep_codigo,
                suc_codigo, emp_codigo)
);

CREATE TABLE produccion_terminada_det_auditoria (
                proterdetaud_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                proterdetaud_fecha TIMESTAMP NOT NULL,
                proterdetaud_procedimiento VARCHAR NOT NULL,
                proter_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                proterdet_cantidad INTEGER NOT NULL,
                CONSTRAINT produccion_terminada_det_auditoria_pk PRIMARY KEY (proterdetaud_codigo)
);

CREATE TABLE mermas_cab (
                mer_codigo INTEGER NOT NULL,
                mer_fecha DATE NOT NULL,
                mer_estado VARCHAR NOT NULL,
                proter_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                mer_audit TEXT,
                CONSTRAINT mermas_cab_pk PRIMARY KEY (mer_codigo)
);

CREATE TABLE mermas_det (
                mer_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                merdet_cantidad NUMERIC NOT NULL,
                merdet_precio NUMERIC NOT NULL,
                CONSTRAINT mermas_det_pk PRIMARY KEY (mer_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE mermas_det_auditoria (
                merdetaud_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                merdetaud_fecha TIMESTAMP NOT NULL,
                merdetaud_procedimiento VARCHAR NOT NULL,
                mer_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                merdet_cantidad NUMERIC NOT NULL,
                merdet_precio NUMERIC NOT NULL,
                CONSTRAINT mermas_det_auditoria_pk PRIMARY KEY (merdetaud_codigo)
);

CREATE TABLE control_calidad_cab (
                conca_codigo INTEGER NOT NULL,
                conca_fecha DATE NOT NULL,
                conca_estado VARCHAR NOT NULL,
                proter_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                conca_audit TEXT,
                CONSTRAINT control_calidad_cab_pk PRIMARY KEY (conca_codigo)
);

CREATE TABLE control_calidad_det (
                conca_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                pacoca_codigo INTEGER NOT NULL,
                concadet_cantidadfallida INTEGER NOT NULL,
                CONSTRAINT control_calidad_det_pk PRIMARY KEY (conca_codigo, it_codigo, tipit_codigo, pacoca_codigo)
);

CREATE TABLE control_calidad_det_auditoria (
                concadetaud_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                concadetaud_fecha TIMESTAMP NOT NULL,
                concadetaud_procedimiento VARCHAR NOT NULL,
                conca_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                pacoca_codigo INTEGER NOT NULL,
                concadet_cantidadfallida INTEGER NOT NULL,
                CONSTRAINT control_calidad_det_auditoria_pk PRIMARY KEY (concadetaud_codigo)
);

CREATE TABLE costo_produccion_cab (
                copro_codigo INTEGER NOT NULL,
                copro_fecha DATE NOT NULL,
                copro_estado VARCHAR NOT NULL,
                orpro_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                copro_audit TEXT,
                CONSTRAINT costo_produccion_cab_pk PRIMARY KEY (copro_codigo)
);

CREATE TABLE costo_produccion_det (
                copro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                coprodet_cantidad NUMERIC NOT NULL,
                coprodet_costo NUMERIC NOT NULL,
                CONSTRAINT costo_produccion_det_pk PRIMARY KEY (copro_codigo, it_codigo, tipit_codigo)
);

CREATE TABLE costo_produccion_det_auditoria (
                coprodetaud_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                usu_login VARCHAR NOT NULL,
                coprodetaud_fecha TIMESTAMP NOT NULL,
                coprodetaud_procedimiento VARCHAR NOT NULL,
                copro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                coprodet_cantidad NUMERIC NOT NULL,
                coprodet_costo NUMERIC NOT NULL,
                CONSTRAINT costo_produccion_det_auditoria_pk PRIMARY KEY (coprodetaud_codigo)
);

CREATE TABLE apertura_cierre_auditoria (
                apercieaud_codigo INTEGER NOT NULL,
                apercieaud_fecha TIMESTAMP NOT NULL,
                apercieaud_procedimiento VARCHAR NOT NULL,
                apercie_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                caj_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                apercie_fechahoraapertura TIMESTAMP NOT NULL,
                apercie_fechahoracierre TIMESTAMP NOT NULL,
                apercie_montoapertura NUMERIC NOT NULL,
                apercie_montocierre NUMERIC NOT NULL,
                apercie_estado VARCHAR NOT NULL,
                CONSTRAINT apertura_cierre_auditoria_pk PRIMARY KEY (apercieaud_codigo)
);

CREATE TABLE recaudacion_depositar_auditoria (
                recaud_codigo INTEGER NOT NULL,
                recaud_fecha TIMESTAMP NOT NULL,
                recaud_procedimiento VARCHAR NOT NULL,
                rec_codigo INTEGER NOT NULL,
                apercie_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                caj_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                rec_montoefectivo NUMERIC NOT NULL,
                rec_montocheque NUMERIC NOT NULL,
                rec_estado VARCHAR NOT NULL,
                CONSTRAINT recaudacion_depositar_auditoria_pk PRIMARY KEY (recaud_codigo)
);

CREATE TABLE arqueo_control_auditoria (
                arcoaud_codigo INTEGER NOT NULL,
                arcoaud_fecha TIMESTAMP NOT NULL,
                arcoaud_procedimiento VARCHAR NOT NULL,
                arco_codigo INTEGER NOT NULL,
                apercie_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                caj_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                arco_observacion VARCHAR NOT NULL,
                arco_fecha DATE NOT NULL,
                func_codigo INTEGER NOT NULL,
                CONSTRAINT arqueo_control_auditoria_pk PRIMARY KEY (arcoaud_codigo)
);

CREATE TABLE factura_venta (
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                caj_codigo INTEGER NOT NULL,
                facven_numero VARCHAR NOT NULL,
                CONSTRAINT factura_venta_pk PRIMARY KEY (suc_codigo, emp_codigo, caj_codigo)
);

CREATE TABLE factura_venta_auditoria (
				facvenaud_codigo INTEGER NOT NULL,
				facvenaud_fecha TIMESTAMP NOT NULL,
                facvenaud_procedimiento VARCHAR NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                caj_codigo INTEGER NOT NULL,
                facven_numero VARCHAR NOT NULL,
                CONSTRAINT factura_venta_auditoria_pk PRIMARY KEY (facvenaud_codigo)
);

CREATE TABLE pedido_venta_auditoria (
				pedvenaud_codigo INTEGER NOT NULL,
				usu_codigo INTEGER NOT NULL,
				usu_login VARCHAR NOT NULL,
				pedvenaud_fecha TIMESTAMP NOT NULL,
                pedvenaud_procedimiento VARCHAR NOT NULL,
                ven_codigo INTEGER NOT NULL,
                peven_codigo INTEGER NOT NULL,
                pedven_codigo INTEGER NOT NULL,
                CONSTRAINT pedido_venta_auditoria_pk PRIMARY KEY (pedvenaud_codigo)
);

CREATE TABLE libro_venta_auditoria (
				libvenaud_codigo INTEGER NOT NULL,
				usu_codigo INTEGER NOT NULL,
				usu_login VARCHAR NOT NULL,
				libvenaud_fecha TIMESTAMP NOT NULL,
                libvenaud_procedimiento VARCHAR NOT NULL,
                libven_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                libven_exenta NUMERIC NOT NULL,
                libven_iva5 NUMERIC NOT NULL,
                libven_iva10 NUMERIC NOT NULL,
                libven_fecha DATE NOT NULL,
                libven_numcomprobante VARCHAR NOT NULL,
                libven_estado VARCHAR NOT NULL,
                tipco_codigo INTEGER NOT NULL,
                CONSTRAINT libro_venta_auditoria_pk PRIMARY KEY (libvenaud_codigo)
);

CREATE TABLE cuenta_cobrar_auditoria (
				cuencoaud_codigo INTEGER NOT NULL,
				usu_codigo INTEGER NOT NULL,
				usu_login VARCHAR NOT NULL,
				cuencoaud_fecha TIMESTAMP NOT NULL,
                cuencoaud_procedimiento VARCHAR NOT NULL,
                ven_codigo INTEGER NOT NULL,
                cuenco_nrocuota INTEGER NOT NULL,
                cuenco_monto NUMERIC NOT NULL,
                cuenco_saldo NUMERIC NOT NULL,
                cuenco_estado VARCHAR NOT NULL,
                tipco_codigo INTEGER NOT NULL,
                CONSTRAINT cuenta_cobrar_auditoria_pk PRIMARY KEY (cuencoaud_codigo)
);

CREATE TABLE venta_cab_auditoria (
				venaud_codigo INTEGER NOT NULL,
				venaud_fecha TIMESTAMP NOT NULL,
                venaud_procedimiento VARCHAR NOT NULL,
                ven_codigo INTEGER NOT NULL,
                ven_fecha DATE NOT NULL,
                ven_numfactura VARCHAR NOT NULL,
                ven_tipofactura tipo_factura NOT NULL,
                ven_cuota INTEGER NOT NULL,
                ven_montocuota NUMERIC NOT NULL,
                ven_interfecha VARCHAR NOT NULL,
                ven_estado VARCHAR NOT NULL,
                usu_codigo INTEGER NOT NULL,
                cli_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                tipco_codigo INTEGER NOT NULL,
                ven_timbrado VARCHAR NOT NULL,
                CONSTRAINT venta_cab_auditoria_pk PRIMARY KEY (venaud_codigo)
);

CREATE TABLE venta_det_auditoria (
				vendetaud_codigo INTEGER NOT NULL,
				usu_codigo INTEGER NOT NULL,
				usu_login VARCHAR NOT NULL,
				vendetaud_fecha TIMESTAMP NOT NULL,
                vendetaud_procedimiento VARCHAR NOT NULL,
                ven_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                vendet_cantidad INTEGER NOT NULL,
                vendet_precio NUMERIC NOT NULL,
                CONSTRAINT venta_det_auditoria_pk PRIMARY KEY (vendetaud_codigo)
);

CREATE TABLE cobro_cab_auditoria (
				cobaud_codigo INTEGER NOT NULL,
				cobaud_fecha TIMESTAMP NOT NULL,
                cobaud_procedimiento VARCHAR NOT NULL,
                cob_codigo INTEGER NOT NULL,
                cob_fecha TIMESTAMP NOT NULL,
                cob_estado VARCHAR NOT NULL,
                apercie_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                caj_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                CONSTRAINT cobro_cab_auditoria_pk PRIMARY KEY (cobaud_codigo)
);

CREATE TABLE cobro_det_auditoria (
				cobdetaud_codigo INTEGER NOT NULL,
				usu_codigo INTEGER NOT NULL,
				usu_login VARCHAR NOT NULL,
				cobdetaud_fecha TIMESTAMP NOT NULL,
                cobdetaud_procedimiento VARCHAR NOT NULL,
                cobdet_codigo INTEGER NOT NULL,
                cob_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                cobdet_monto NUMERIC NOT NULL,
                cobdet_numerocuota INTEGER NOT NULL,
                forco_codigo INTEGER NOT NULL,
                CONSTRAINT cobro_det_auditoria_pk PRIMARY KEY (cobdetaud_codigo)
);

CREATE TABLE cobro_tarjeta_auditoria (
				cobtaaud_codigo INTEGER NOT NULL,
				usu_codigo INTEGER NOT NULL,
				usu_login VARCHAR NOT NULL,
				cobtaaud_fecha TIMESTAMP NOT NULL,
                cobtaaud_procedimiento VARCHAR NOT NULL,
                cobta_codigo INTEGER NOT NULL,
                cobta_numero VARCHAR NOT NULL,
                cobta_monto NUMERIC NOT NULL,
                cobta_tipotarjeta tipo_tarjeta NOT NULL,
                entad_codigo INTEGER NOT NULL,
                ent_codigo INTEGER NOT NULL,
                marta_codigo INTEGER NOT NULL,
                cobdet_codigo INTEGER NOT NULL,
                cob_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                CONSTRAINT cobro_tarjeta_auditoria_pk PRIMARY KEY (cobtaaud_codigo)
);

CREATE TABLE cobro_cheque_auditoria (
				cocheaud_codigo INTEGER NOT NULL,
				usu_codigo INTEGER NOT NULL,
				usu_login VARCHAR NOT NULL,
				cocheaud_fecha TIMESTAMP NOT NULL,
                cocheaud_procedimiento VARCHAR NOT NULL,
                coche_codigo INTEGER NOT NULL,
                coche_numero VARCHAR NOT NULL,
                coche_monto NUMERIC NOT NULL,
                coche_tipocheque tipo_cheque NOT NULL,
                coche_fechavencimiento DATE NOT NULL,
                ent_codigo INTEGER NOT NULL,
                cobdet_codigo INTEGER NOT NULL,
                cob_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                CONSTRAINT cobro_cheque_auditoria_pk PRIMARY KEY (cocheaud_codigo)
);

CREATE TABLE red_pago (
                redpa_codigo INTEGER NOT NULL,
                redpa_descripcion VARCHAR NOT NULL,
                redpa_estado VARCHAR NOT NULL,
                redpa_audit text NOT null,
                CONSTRAINT red_pago_pk PRIMARY KEY (redpa_codigo)
);

CREATE TABLE configuraciones (
                config_codigo INTEGER NOT NULL,
                config_validacion VARCHAR NOT NULL,
                config_descripcion VARCHAR NOT NULL,
                config_estado VARCHAR NOT NULL,
                config_audit TEXT NOT NULL,
                CONSTRAINT configuraciones_pk PRIMARY KEY (config_codigo)
);

CREATE TABLE configuraciones_sucursal (
				configsuc_codigo INTEGER NOT NULL,
                config_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                configsuc_estado VARCHAR NOT NULL,
                configsuc_audit TEXT NOT NULL,
                CONSTRAINT configuraciones_sucursal_pk PRIMARY KEY (configsuc_codigo, config_codigo, suc_codigo, emp_codigo)
);

CREATE TABLE nota_venta_cab_auditoria (
				notvenaud_codigo INTEGER NOT NULL,
				notvenaud_fecha TIMESTAMP NOT NULL,
                notvenaud_procedimiento VARCHAR NOT NULL,
                notven_codigo INTEGER NOT NULL,
                notven_fecha TIMESTAMP NOT NULL,
                notven_numeronota VARCHAR NOT NULL,
                notven_concepto VARCHAR NOT NULL,
                notven_estado VARCHAR NOT NULL,
                tipco_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                cli_codigo INTEGER NOT NULL,
                CONSTRAINT nota_venta_cab_auditoria_pk PRIMARY KEY (notvenaud_codigo)
);

CREATE TABLE nota_venta_det_auditoria (
				notvendetaud_codigo INTEGER NOT NULL,
				usu_codigo INTEGER NOT NULL,
				usu_login VARCHAR NOT NULL,
				notvendetaud_fecha TIMESTAMP NOT NULL,
                notvendetaud_procedimiento VARCHAR NOT NULL,
                notven_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                notvendet_cantidad INTEGER NOT NULL,
                notvendet_precio NUMERIC NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT nota_venta_det_auditoria_pk PRIMARY KEY (notvendetaud_codigo)
);

CREATE TABLE funcionario_proveedor (
                funpro_codigo INTEGER NOT NULL,
                funpro_nombre VARCHAR NOT NULL,
                funpro_apellido VARCHAR NOT NULL,
                funpro_documento VARCHAR NOT NULL,
                funpro_estado VARCHAR NOT NULL,
                pro_codigo INTEGER NOT NULL,
                tipro_codigo INTEGER NOT NULL,
                funpro_audit TEXT NOT NULL,
                CONSTRAINT funcionario_proveedor_pk PRIMARY KEY (funpro_codigo)
);

CREATE TABLE marca_vehiculo (
                marve_codigo INTEGER NOT NULL,
                marve_descripcion VARCHAR NOT NULL,
                marve_estado VARCHAR NOT NULL,
                marve_audit TEXT NOT NULL,
                CONSTRAINT marca_vehiculo_pk PRIMARY KEY (marve_codigo)
);


CREATE TABLE modelo_vehiculo (
                modve_codigo INTEGER NOT NULL,
                modve_descripcion VARCHAR NOT NULL,
                modve_estado VARCHAR NOT NULL,
                marve_codigo INTEGER NOT null,
                modve_audit TEXT NOT NULL,
                CONSTRAINT modelo_vehiculo_pk PRIMARY KEY (modve_codigo)
);

CREATE TABLE chapa_vehiculo (
				chave_codigo INTEGER NOT NULL,
                chave_chapa VARCHAR NOT NULL,
                modve_codigo INTEGER NOT NULL,
                chave_estado VARCHAR NOT NULL,
                chave_audit TEXT NOT NULL,
                CONSTRAINT chapa_vehiculo_pk PRIMARY KEY (chave_codigo)
);

CREATE TABLE tipo_cliente (
				ticli_codigo INTEGER NOT NULL,
                ticli_descripcion VARCHAR NOT NULL,
                ticli_estado VARCHAR NOT NULL,
                ticli_audit TEXT NOT NULL,
                CONSTRAINT tipo_cliente_pk PRIMARY KEY (ticli_codigo)
);

CREATE TABLE solicitud_presupuesto_cab (
                solpre_codigo INTEGER NOT NULL,
                pedco_codigo INTEGER NOT NULL,
                pro_codigo INTEGER NOT NULL,
                tipro_codigo INTEGER NOT NULL,
                solpre_fecha DATE NOT NULL,
                solpre_correo_proveedor VARCHAR NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT solicitud_presupuesto_cab_pk PRIMARY KEY (solpre_codigo, pedco_codigo, pro_codigo, tipro_codigo)
);

CREATE TABLE solicitud_presupuesto_det (
                solpre_codigo INTEGER NOT NULL,
                pedco_codigo INTEGER NOT NULL,
                pro_codigo INTEGER NOT NULL,
                tipro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                solpredet_cantidad NUMERIC NOT NULL,
                CONSTRAINT solicitud_presupuesto_det_pk PRIMARY KEY (solpre_codigo, pedco_codigo, pro_codigo, tipro_codigo, it_codigo, tipit_codigo)
);

--Alteracion de tablas
ALTER TABLE solicitud_presupuesto_det ADD constraint items_solicitud_presupuesto_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE solicitud_presupuesto_det ADD constraint solicitud_presupuesto_cab_solicitud_presupuesto_det_fk
FOREIGN KEY (solpre_codigo, pedco_codigo, pro_codigo, tipro_codigo)
REFERENCES solicitud_presupuesto_cab (solpre_codigo, pedco_codigo, pro_codigo, tipro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE solicitud_presupuesto_cab ADD constraint sucursal_solicitud_presupuesto_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE solicitud_presupuesto_cab ADD constraint usuario_solicitud_presupuesto_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE solicitud_presupuesto_cab ADD constraint proveedor_solicitud_presupuesto_cab_fk
FOREIGN KEY (pro_codigo, tipro_codigo)
REFERENCES proveedor (pro_codigo, tipro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE solicitud_presupuesto_cab ADD constraint pedido_compra_cab_solicitud_presupuesto_cab_fk
FOREIGN KEY (pedco_codigo)
REFERENCES pedido_compra_cab (pedco_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE chapa_vehiculo ADD constraint modelo_vehiculo_chapa_vehiculo_fk
FOREIGN KEY (modve_codigo)
REFERENCES modelo_vehiculo (modve_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE modelo_vehiculo ADD constraint modelo_vehiculo_modelo_vehiculo_fk
FOREIGN KEY (marve_codigo)
REFERENCES modelo_vehiculo (marve_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE funcionario_proveedor ADD constraint proveedor_funcionario_proveedor_fk
FOREIGN KEY (pro_codigo, tipro_codigo)
REFERENCES proveedor (pro_codigo, tipro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_venta_det ADD CONSTRAINT deposito_nota_venta_det_fk
FOREIGN KEY (dep_codigo, suc_codigo, emp_codigo)
REFERENCES deposito (dep_codigo, suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE configuraciones_sucursal ADD CONSTRAINT sucursal_configuraciones_sucursal_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE configuraciones_sucursal ADD CONSTRAINT configuraciones_configuraciones_sucursal_fk
FOREIGN KEY (config_codigo)
REFERENCES configuraciones (config_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cobro_tarjeta ADD constraint red_pago_cobro_tarjeta_fk
FOREIGN KEY (redpa_codigo)
REFERENCES red_pago (redpa_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cuenta_cobrar ADD constraint tipo_comprobante_cuenta_cobrar_fk
FOREIGN KEY (tipco_codigo)
REFERENCES tipo_comprobante (tipco_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE libro_venta ADD constraint tipo_comprobante_libro_venta_fk
FOREIGN KEY (tipco_codigo)
REFERENCES tipo_comprobante (tipco_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE venta_cab ADD constraint tipo_comprobante_venta_cab_fk
FOREIGN KEY (tipco_codigo)
REFERENCES tipo_comprobante (tipco_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE factura_venta ADD constraint caja_factura_venta_fk
FOREIGN KEY (caj_codigo)
REFERENCES caja (caj_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE factura_venta ADD CONSTRAINT sucursal_factura_venta_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE costo_produccion_det ADD CONSTRAINT items_costo_produccion_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE costo_produccion_det ADD CONSTRAINT costo_produccion_cab_costo_produccion_det_fk
FOREIGN KEY (copro_codigo)
REFERENCES costo_produccion_cab (copro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE costo_produccion_cab ADD CONSTRAINT sucursal_costo_produccion_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE costo_produccion_cab ADD CONSTRAINT usuario_costo_produccion_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE costo_produccion_cab ADD CONSTRAINT orden_produccion_cab_costo_produccion_cab_fk
FOREIGN KEY (orpro_codigo)
REFERENCES orden_produccion_cab (orpro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE control_calidad_det ADD CONSTRAINT parametro_control_calidad_control_calidad_det_fk
FOREIGN KEY (pacoca_codigo)
REFERENCES parametro_control_calidad (pacoca_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE control_calidad_det ADD CONSTRAINT items_control_calidad_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE control_calidad_det ADD CONSTRAINT control_calidad_cab_control_calidad_det_fk
FOREIGN KEY (conca_codigo)
REFERENCES control_calidad_cab (conca_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE control_calidad_cab ADD CONSTRAINT sucursal_control_calidad_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE control_calidad_cab ADD CONSTRAINT usuario_control_calidad_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE control_calidad_cab ADD CONSTRAINT produccion_terminada_cab_control_calidad_cab_fk
FOREIGN KEY (proter_codigo)
REFERENCES produccion_terminada_cab (proter_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE mermas_det ADD CONSTRAINT items_mermas_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE mermas_det ADD CONSTRAINT mermas_cab_mermas_det_fk
FOREIGN KEY (mer_codigo)
REFERENCES mermas_cab (mer_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE mermas_cab ADD CONSTRAINT sucursal_mermas_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE mermas_cab ADD CONSTRAINT usuario_mermas_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE mermas_cab ADD CONSTRAINT produccion_terminada_cab_mermas_cab_fk
FOREIGN KEY (proter_codigo)
REFERENCES produccion_terminada_cab (proter_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE produccion_terminada_det ADD CONSTRAINT produccion_terminada_cab_produccion_terminada_det_fk
FOREIGN KEY (proter_codigo)
REFERENCES produccion_terminada_cab (proter_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE produccion_terminada_det ADD CONSTRAINT stock_produccion_terminada_det_fk
FOREIGN KEY (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
REFERENCES stock (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE produccion_terminada_cab ADD CONSTRAINT sucursal_produccion_terminada_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE produccion_terminada_cab ADD CONSTRAINT usuario_produccion_terminada_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE produccion_terminada_cab ADD CONSTRAINT produccion_cab_produccion_terminada_cab_fk
FOREIGN KEY (prod_codigo)
REFERENCES produccion_cab (prod_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_produccion_det2 ADD CONSTRAINT orden_produccion_cab_orden_produccion_det2_fk
FOREIGN KEY (orpro_codigo)
REFERENCES orden_produccion_cab (orpro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_produccion_det2 ADD CONSTRAINT componente_produccion_det_orden_produccion_det2_fk
FOREIGN KEY (compro_codigo, it_codigo, tipit_codigo)
REFERENCES componente_produccion_det (compro_codigo, it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE componente_produccion_det ADD CONSTRAINT componente_produccion_cab_componente_produccion_det_fk
FOREIGN KEY (compro_codigo)
REFERENCES componente_produccion_cab (compro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE componente_produccion_det ADD CONSTRAINT items_componente_produccion_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE componente_produccion_cab ADD CONSTRAINT sucursal_componente_produccion_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE componente_produccion_cab ADD CONSTRAINT usuario_componente_produccion_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE componente_produccion_cab ADD CONSTRAINT items_componente_produccion_cab_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE arqueo_control ADD CONSTRAINT apertura_cierre_arqueo_control_fk
FOREIGN KEY (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
REFERENCES apertura_cierre (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE arqueo_control ADD CONSTRAINT funcionario_arqueo_control_fk
FOREIGN KEY (func_codigo)
REFERENCES funcionario (func_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE recaudacion_depositar ADD CONSTRAINT apertura_cierre_recaudacion_depositar_fk
FOREIGN KEY (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
REFERENCES apertura_cierre (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_venta_det ADD CONSTRAINT items_nota_venta_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_venta_det ADD CONSTRAINT nota_venta_cab_nota_venta_det_fk
FOREIGN KEY (notven_codigo)
REFERENCES nota_venta_cab (notven_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_venta_cab ADD CONSTRAINT venta_cab_nota_venta_cab_fk
FOREIGN KEY (ven_codigo)
REFERENCES venta_cab (ven_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_venta_cab ADD CONSTRAINT usuario_nota_venta_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_venta_cab ADD CONSTRAINT sucursal_nota_venta_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_venta_cab ADD CONSTRAINT cliente_nota_venta_cab_fk
FOREIGN KEY (cli_codigo)
REFERENCES cliente (cli_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_venta_cab ADD CONSTRAINT tipo_comprobante_nota_venta_cab_fk
FOREIGN KEY (tipco_codigo)
REFERENCES tipo_comprobante (tipco_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cobro_tarjeta ADD CONSTRAINT cobro_det_cobro_tarjeta_fk
FOREIGN KEY (cob_codigo, ven_codigo, cobdet_codigo)
REFERENCES cobro_det (cob_codigo, ven_codigo, cobdet_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cobro_tarjeta ADD CONSTRAINT entidad_adherida_cobro_tarjeta_fk
FOREIGN KEY (entad_codigo, ent_codigo, marta_codigo)
REFERENCES entidad_adherida (entad_codigo, ent_codigo, marta_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cobro_cheque ADD CONSTRAINT cobro_det_cobro_cheque_fk
FOREIGN KEY (cob_codigo, ven_codigo, cobdet_codigo)
REFERENCES cobro_det (cob_codigo, ven_codigo, cobdet_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cobro_cheque ADD CONSTRAINT entidad_emisora_cobro_cheque_fk
FOREIGN KEY (ent_codigo)
REFERENCES entidad_emisora (ent_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cobro_det ADD CONSTRAINT cobro_cab_cobro_det_fk
FOREIGN KEY (cob_codigo)
REFERENCES cobro_cab (cob_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cobro_det ADD CONSTRAINT cuenta_cobrar_cobro_det_fk
FOREIGN KEY (ven_codigo)
REFERENCES cuenta_cobrar (ven_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cobro_det ADD CONSTRAINT forma_cobro_cobro_det_fk
FOREIGN KEY (forco_codigo)
REFERENCES forma_cobro (forco_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cobro_cab ADD CONSTRAINT apertura_cierre_cobro_cab_fk
FOREIGN KEY (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
REFERENCES apertura_cierre (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cuenta_cobrar ADD CONSTRAINT venta_cab_cuenta_cobrar_fk
FOREIGN KEY (ven_codigo)
REFERENCES venta_cab (ven_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE libro_venta ADD CONSTRAINT venta_cab_libro_venta_fk
FOREIGN KEY (ven_codigo)
REFERENCES venta_cab (ven_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_venta ADD CONSTRAINT pedido_venta_cab_pedido_venta_fk
FOREIGN KEY (peven_codigo)
REFERENCES pedido_venta_cab (peven_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_venta ADD CONSTRAINT venta_cab_pedido_venta_fk
FOREIGN KEY (ven_codigo)
REFERENCES venta_cab (ven_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE venta_det ADD CONSTRAINT stock_venta_det_fk
FOREIGN KEY (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
REFERENCES stock (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE venta_det ADD CONSTRAINT venta_cab_venta_det_fk
FOREIGN KEY (ven_codigo)
REFERENCES venta_cab (ven_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE venta_cab ADD CONSTRAINT usuario_venta_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE venta_cab ADD CONSTRAINT sucursal_venta_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE venta_cab ADD CONSTRAINT cliente_venta_cab_fk
FOREIGN KEY (cli_codigo)
REFERENCES cliente (cli_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE apertura_cierre ADD CONSTRAINT caja_apertura_cierre_fk
FOREIGN KEY (caj_codigo)
REFERENCES caja (caj_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE apertura_cierre ADD CONSTRAINT sucursal_apertura_cierre_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE apertura_cierre ADD CONSTRAINT usuario_apertura_cierre_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE etapa_produccion ADD CONSTRAINT produccion_det_etapa_produccion_fk
FOREIGN KEY (prod_codigo, it_codigo, tipit_codigo)
REFERENCES produccion_det (prod_codigo, it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE etapa_produccion ADD CONSTRAINT usuario_etapa_produccion_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE etapa_produccion ADD CONSTRAINT sucursal_etapa_produccion_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE etapa_produccion ADD CONSTRAINT tipo_etapa_produccion_etapa_produccion_fk
FOREIGN KEY (tipet_codigo)
REFERENCES tipo_etapa_produccion (tipet_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE etapa_produccion ADD CONSTRAINT maquinaria_etapa_produccion_fk
FOREIGN KEY (maq_codigo)
REFERENCES maquinaria (maq_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE produccion_det ADD CONSTRAINT items_produccion_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE produccion_det ADD CONSTRAINT produccion_cab_produccion_det_fk
FOREIGN KEY (prod_codigo)
REFERENCES produccion_cab (prod_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE produccion_cab ADD CONSTRAINT orden_produccion_cab_produccion_cab_fk
FOREIGN KEY (orpro_codigo)
REFERENCES orden_produccion_cab (orpro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE produccion_cab ADD CONSTRAINT usuario_produccion_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE produccion_cab ADD CONSTRAINT sucursal_produccion_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_presupuesto ADD CONSTRAINT presupuesto_cab_orden_presupuesto_fk
FOREIGN KEY (pres_codigo)
REFERENCES presupuesto_cab (pres_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_presupuesto ADD CONSTRAINT orden_produccion_cab_orden_presupuesto_fk
FOREIGN KEY (orpro_codigo)
REFERENCES orden_produccion_cab (orpro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_produccion_det ADD CONSTRAINT items_orden_produccion_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_produccion_det ADD CONSTRAINT orden_produccion_cab_orden_produccion_det_fk
FOREIGN KEY (orpro_codigo)
REFERENCES orden_produccion_cab (orpro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_produccion_cab ADD CONSTRAINT usuario_orden_produccion_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_produccion_cab ADD CONSTRAINT seccion_orden_produccion_cab_fk
FOREIGN KEY (secc_codigo)
REFERENCES seccion (secc_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_produccion_cab ADD CONSTRAINT sucursal_orden_produccion_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_det ADD CONSTRAINT presupuesto_cab_presupuesto_det_fk
FOREIGN KEY (pres_codigo)
REFERENCES presupuesto_cab (pres_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_det ADD CONSTRAINT items_presupuesto_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_cab ADD CONSTRAINT pedido_venta_cab_presupuesto_cab_fk
FOREIGN KEY (peven_codigo)
REFERENCES pedido_venta_cab (peven_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_cab ADD CONSTRAINT usuario_presupuesto_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_cab ADD CONSTRAINT sucursal_presupuesto_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_cab ADD CONSTRAINT cliente_presupuesto_cab_fk
FOREIGN KEY (cli_codigo)
REFERENCES cliente (cli_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_produccion_det ADD CONSTRAINT items_pedido_produccion_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_produccion_det ADD CONSTRAINT pedido_produccion_cab_pedido_produccion_det_fk
FOREIGN KEY (pedpro_codigo)
REFERENCES pedido_produccion_cab (pedpro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_produccion_cab ADD CONSTRAINT usuario_pedido_produccion_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_produccion_cab ADD CONSTRAINT sucursal_pedido_produccion_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_compra_det ADD CONSTRAINT nota_compra_cab_nota_compra_det_fk
FOREIGN KEY (nocom_codigo)
REFERENCES nota_compra_cab (nocom_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_compra_det ADD CONSTRAINT items_nota_compra_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_compra_cab ADD CONSTRAINT compra_cab_nota_compra_cab_fk
FOREIGN KEY (comp_codigo)
REFERENCES compra_cab (comp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_compra_cab ADD CONSTRAINT proveedor_nota_compra_cab_fk
FOREIGN KEY (pro_codigo, tipro_codigo)
REFERENCES proveedor (pro_codigo, tipro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_compra_cab ADD CONSTRAINT usuario_nota_compra_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_compra_cab ADD CONSTRAINT sucursal_nota_compra_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_compra_cab ADD CONSTRAINT tipo_comprobante_nota_compra_cab_fk
FOREIGN KEY (tipco_codigo)
REFERENCES tipo_comprobante (tipco_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cuenta_pagar ADD CONSTRAINT compra_cab_cuenta_pagar_fk
FOREIGN KEY (comp_codigo)
REFERENCES compra_cab (comp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE libro_compra ADD CONSTRAINT compra_cab_libro_compra_fk
FOREIGN KEY (comp_codigo)
REFERENCES compra_cab (comp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_compra ADD CONSTRAINT orden_compra_cab_orden_compra_fk
FOREIGN KEY (orcom_codigo)
REFERENCES orden_compra_cab (orcom_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_compra ADD CONSTRAINT compra_cab_orden_compra_fk
FOREIGN KEY (comp_codigo)
REFERENCES compra_cab (comp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE compra_det ADD CONSTRAINT compra_cab_compra_det_fk
FOREIGN KEY (comp_codigo)
REFERENCES compra_cab (comp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE compra_det ADD CONSTRAINT stock_compra_det_fk
FOREIGN KEY (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
REFERENCES stock (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE compra_cab ADD CONSTRAINT proveedor_compra_cab_fk
FOREIGN KEY (pro_codigo, tipro_codigo)
REFERENCES proveedor (pro_codigo, tipro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE compra_cab ADD CONSTRAINT tipo_comprobante_compra_cab_fk
FOREIGN KEY (tipco_codigo)
REFERENCES tipo_comprobante (tipco_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE compra_cab ADD CONSTRAINT usuario_compra_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE compra_cab ADD CONSTRAINT sucursal_compra_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE libro_compra ADD CONSTRAINT tipo_comprobante_libro_compra_fk
FOREIGN KEY (tipco_codigo)
REFERENCES tipo_comprobante (tipco_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_venta_det ADD CONSTRAINT items_pedido_venta_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_venta_det ADD CONSTRAINT pedido_venta_cab_pedido_venta_det_fk
FOREIGN KEY (peven_codigo)
REFERENCES pedido_venta_cab (peven_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_venta_cab ADD CONSTRAINT usuario_pedido_venta_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_venta_cab ADD CONSTRAINT sucursal_pedido_venta_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_venta_cab ADD CONSTRAINT cliente_pedido_venta_cab_fk
FOREIGN KEY (cli_codigo)
REFERENCES cliente (cli_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE ajuste_stock_det ADD CONSTRAINT stock_ajuste_stock_det_fk
FOREIGN KEY (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
REFERENCES stock (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE ajuste_stock_det ADD CONSTRAINT ajuste_stock_cab_ajuste_stock_det_fk
FOREIGN KEY (ajus_codigo)
REFERENCES ajuste_stock_cab (ajus_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE stock ADD CONSTRAINT items_stock_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE stock ADD CONSTRAINT deposito_stock_fk
FOREIGN KEY (dep_codigo, suc_codigo, emp_codigo)
REFERENCES deposito (dep_codigo, suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE ajuste_stock_cab ADD CONSTRAINT usuario_ajuste_stock_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE ajuste_stock_cab ADD CONSTRAINT sucursal_ajuste_stock_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_orden ADD CONSTRAINT presupuesto_proveedor_cab_presupuesto_orden_fk
FOREIGN KEY (prepro_codigo)
REFERENCES presupuesto_proveedor_cab (prepro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_orden ADD CONSTRAINT orden_compra_cab_presupuesto_orden_fk
FOREIGN KEY (orcom_codigo)
REFERENCES orden_compra_cab (orcom_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_compra_det ADD CONSTRAINT orden_compra_cab_orden_compra_det_fk
FOREIGN KEY (orcom_codigo)
REFERENCES orden_compra_cab (orcom_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_compra_det ADD CONSTRAINT items_orden_compra_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_compra_cab ADD CONSTRAINT proveedor_orden_compra_cab_fk
FOREIGN KEY (pro_codigo, tipro_codigo)
REFERENCES proveedor (pro_codigo, tipro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_compra_cab ADD CONSTRAINT usuario_orden_compra_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_compra_cab ADD CONSTRAINT sucursal_orden_compra_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_presupuesto ADD CONSTRAINT presupuesto_proveedor_cab_pedido_presupuesto_fk
FOREIGN KEY (prepro_codigo)
REFERENCES presupuesto_proveedor_cab (prepro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_presupuesto ADD CONSTRAINT pedido_compra_cab_pedido_presupuesto_fk
FOREIGN KEY (pedco_codigo)
REFERENCES pedido_compra_cab (pedco_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_proveedor_det ADD CONSTRAINT presupuesto_proveedor_cab_presupuesto_proveedor_det_fk
FOREIGN KEY (prepro_codigo)
REFERENCES presupuesto_proveedor_cab (prepro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_proveedor_det ADD CONSTRAINT items_presupuesto_proveedor_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_proveedor_cab ADD CONSTRAINT proveedor_presupuesto_proveedor_cab_fk
FOREIGN KEY (pro_codigo, tipro_codigo)
REFERENCES proveedor (pro_codigo, tipro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_proveedor_cab ADD CONSTRAINT usuario_presupuesto_proveedor_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE presupuesto_proveedor_cab ADD CONSTRAINT sucursal_presupuesto_proveedor_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_compra_det ADD CONSTRAINT items_pedido_compra_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_compra_det ADD CONSTRAINT pedido_compra_cab_pedido_compra_det_fk
FOREIGN KEY (pedco_codigo)
REFERENCES pedido_compra_cab (pedco_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_compra_cab ADD CONSTRAINT sucursal_pedido_compra_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pedido_compra_cab ADD CONSTRAINT usuario_pedido_compra_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE equipo_trabajo ADD CONSTRAINT funcionario_equipo_trabajo_fk
FOREIGN KEY (func_codigo)
REFERENCES funcionario (func_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE equipo_trabajo ADD CONSTRAINT seccion_equipo_trabajo_fk
FOREIGN KEY (secc_codigo)
REFERENCES seccion (secc_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE seccion ADD CONSTRAINT sucursal_seccion_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE costo_servicio ADD CONSTRAINT modelo_costo_servicio_fk
FOREIGN KEY (mod_codigo)
REFERENCES modelo (mod_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cliente ADD CONSTRAINT ciudad_cliente_fk
FOREIGN KEY (ciu_codigo)
REFERENCES ciudad (ciu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cliente ADD CONSTRAINT personas_cliente_fk
FOREIGN KEY (per_codigo)
REFERENCES personas (per_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE entidad_adherida ADD CONSTRAINT marca_tarjeta_entidad_adherida_fk
FOREIGN KEY (marta_codigo)
REFERENCES marca_tarjeta (marta_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE entidad_adherida ADD CONSTRAINT entidad_emisora_entidad_adherida_fk
FOREIGN KEY (ent_codigo)
REFERENCES entidad_emisora (ent_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE items ADD CONSTRAINT tipo_impuesto_items_fk
FOREIGN KEY (tipim_codigo)
REFERENCES tipo_impuesto (tipim_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE items ADD CONSTRAINT tipo_item_items_fk
FOREIGN KEY (tipit_codigo)
REFERENCES tipo_item (tipit_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE items ADD CONSTRAINT modelo_items_fk
FOREIGN KEY (mod_codigo)
REFERENCES modelo (mod_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE items ADD CONSTRAINT talle_items_fk
FOREIGN KEY (tall_codigo)
REFERENCES talle (tall_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE items ADD CONSTRAINT unidad_medida_items_fk
FOREIGN KEY (unime_codigo)
REFERENCES unidad_medida (unime_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE modelo ADD CONSTRAINT color_prenda_modelo_fk
FOREIGN KEY (col_codigo)
REFERENCES color_prenda (col_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE deposito ADD CONSTRAINT sucursal_deposito_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE deposito ADD CONSTRAINT ciudad_deposito_fk
FOREIGN KEY (ciu_codigo)
REFERENCES ciudad (ciu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE personas ADD CONSTRAINT tipo_documento_personas_fk
FOREIGN KEY (tipdo_codigo)
REFERENCES tipo_documento (tipdo_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE sucursal ADD CONSTRAINT empresa_sucursal_fk
FOREIGN KEY (emp_codigo)
REFERENCES empresa (emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE sucursal ADD CONSTRAINT ciudad_sucursal_fk
FOREIGN KEY (ciu_codigo)
REFERENCES ciudad (ciu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE funcionario ADD CONSTRAINT personas_funcionario_fk
FOREIGN KEY (per_codigo)
REFERENCES personas (per_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE funcionario ADD CONSTRAINT ciudad_funcionario_fk
FOREIGN KEY (ciu_codigo)
REFERENCES ciudad (ciu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE funcionario ADD CONSTRAINT cargo_funcionario_fk
FOREIGN KEY (car_codigo)
REFERENCES cargo (car_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE funcionario ADD CONSTRAINT sucursal_funcionario_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE usuario ADD CONSTRAINT modulo_usuario_fk
FOREIGN KEY (modu_codigo)
REFERENCES modulo (modu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE usuario ADD CONSTRAINT perfil_usuario_fk
FOREIGN KEY (perf_codigo)
REFERENCES perfil (perf_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE usuario ADD CONSTRAINT funcionario_usuario_fk
FOREIGN KEY (func_codigo)
REFERENCES funcionario (func_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE gui ADD CONSTRAINT modulo_gui_fk
FOREIGN KEY (modu_codigo)
REFERENCES modulo (modu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE perfiles_permisos ADD CONSTRAINT permisos_perfiles_permisos_fk
FOREIGN KEY (perm_codigo)
REFERENCES permisos (perm_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE perfiles_permisos ADD CONSTRAINT perfil_perfiles_permisos_fk
FOREIGN KEY (perf_codigo)
REFERENCES perfil (perf_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE perfil_gui ADD CONSTRAINT gui_perfil_gui_fk
FOREIGN KEY (gui_codigo, modu_codigo)
REFERENCES gui (gui_codigo, modu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE perfil_gui ADD CONSTRAINT perfil_perfil_gui_fk
FOREIGN KEY (perf_codigo)
REFERENCES perfil (perf_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE asignacion_permiso_usuario ADD CONSTRAINT perfiles_permisos_asignacion_permiso_usuario_fk
FOREIGN KEY (perfpe_codigo, perf_codigo, perm_codigo)
REFERENCES perfiles_permisos (perfpe_codigo, perf_codigo, perm_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE asignacion_permiso_usuario ADD CONSTRAINT usuario_asignacion_permiso_usuario_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE proveedor ADD CONSTRAINT tipo_proveedor_proveedor_fk
FOREIGN KEY (tipro_codigo)
REFERENCES tipo_proveedor (tipro_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE nota_compra_det ADD CONSTRAINT deposito_nota_compra_det_fk
FOREIGN KEY (dep_codigo, suc_codigo, emp_codigo)
REFERENCES deposito (dep_codigo, suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE orden_produccion_det ADD CONSTRAINT deposito_orden_produccion_det_fk
FOREIGN KEY (dep_codigo, suc_codigo, emp_codigo)
REFERENCES deposito (dep_codigo, suc_codigo, emp_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cobro_cab ADD CONSTRAINT tipo_comprobante_cobro_cab_fk
FOREIGN KEY (tipco_codigo)
REFERENCES tipo_comprobante (tipco_codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE;

--Sentencias
INSERT INTO usuario
(usu_codigo, usu_login, usu_contrasenia, usu_estado, usu_fecha, modu_codigo, perf_codigo, func_codigo)
VALUES(1, 'ssan', md5('123'), 'ACTIVO', '2023-09-19', 4, 1, 1);

select 
	u.*,
	p.per_nombre,
	p.per_apellido,
	p.per_email,
	p2.perf_descripcion,
	su.suc_descripcion 
from usuario u 
	join funcionario f on f.func_codigo = u.func_codigo
	join personas p on p.per_codigo = f.per_codigo
	join sucursal su on su.suc_codigo = f.suc_codigo 
	join modulo m on m.modu_codigo = u.modu_codigo
	join perfil p2 on p2.perf_codigo = u.perf_codigo
where u.usu_login = 'ssan' and u.usu_contrasenia = md5('123');

insert into acceso
(acc_codigo, acc_usuario, acc_fechahora, acc_obs)
values((select coalesce(max(a.acc_codigo),0)+1 from acceso a), '', '', '');

select coalesce(max(a.acc_codigo),0)+1 from acceso a;

select current_timestamp as fecha;

--Funciones
--Procedimiento almacenado modulo
select sp_modulo(1, 'COMPRAS', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
select coalesce(max(modu_codigo),0)+1 as modu_codigo from modulo;
create or replace function sp_modulo(
    moducodigo integer,
    modudescripcion varchar,
    moduestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare moduAudit text; 
begin 
    if operacion in(1,2) then
        perform * from modulo
        where upper(modu_descripcion) = upper(modudescripcion)
        and modu_codigo != moducodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into modulo(modu_codigo, modu_descripcion, modu_estado)
				values(moducodigo, upper(modudescripcion), 'ACTIVO');
				raise notice 'EL MODULO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		UPDATE modulo
				SET modu_descripcion=upper(modudescripcion), modu_estado='ACTIVO'
				WHERE modu_codigo=moducodigo;
				raise notice 'EL MODULO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	UPDATE modulo
		SET modu_estado='INACTIVO'
		WHERE modu_codigo=moducodigo;
		raise notice 'EL MODULO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(modu_audit, '') into moduAudit from modulo where modu_codigo = moducodigo;
	--a los datos anteriores le agregamos los nuevos
	update modulo 
	set modu_audit = moduAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'modu_descripcion', upper(modudescripcion),
		'modu_estado', upper(moduestado)
	)||','
	where modu_codigo = moducodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado permisos 
SELECT 
	p.perm_descripcion, 
	apu.asigperm_estado 
FROM asignacion_permiso_usuario apu 
	JOIN permisos p ON p.perm_codigo = apu.perm_codigo 
WHERE usu_codigo = $usuario 
order by p.perm_codigo;
select sp_permisos(1, 'AGRegar', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
select coalesce(max(perm_codigo),0)+1 as perm_codigo from permisos;
create or replace function sp_permisos(
    permcodigo integer,
    permdescripcion varchar,
    permestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare permAudit text; 
begin 
    if operacion in(1,2) then
        perform * from permisos
        where upper(perm_descripcion) = upper(permdescripcion)
        and perm_codigo != permcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into permisos(perm_codigo, perm_descripcion, perm_estado)
				values(permcodigo, upper(permdescripcion), 'ACTIVO');
				raise notice 'EL PERMISO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update permisos
				set perm_descripcion=upper(permdescripcion), perm_estado='ACTIVO'
				where perm_codigo=permcodigo;
				raise notice 'EL PERMISO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update permisos
		set perm_estado='INACTIVO'
		WHERE perm_codigo=permcodigo;
		raise notice 'EL PERMISO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(perm_audit, '') into permAudit from permisos where perm_codigo = permcodigo;
	--a los datos anteriores le agregamos los nuevos
	update permisos 
	set perm_audit = permAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'perm_descripcion', upper(permdescripcion),
		'perm_estado', upper(permestado)
	)||','
	where perm_codigo = permcodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado perfil 
select sp_perfil(1, 'ADMINISTRADOR', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
select coalesce(max(perf_codigo),0)+1 as perf_codigo from perfil;
create or replace function sp_perfil(
    perfcodigo integer,
    perfdescripcion varchar,
    perfestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare perfAudit text; 
begin 
    if operacion in(1,2) then
        perform * from perfil
        where upper(perf_descripcion) = upper(perfdescripcion)
        and perf_codigo != perfcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into perfil(perf_codigo, perf_descripcion, perf_estado)
				values(perfcodigo, upper(perfdescripcion), 'ACTIVO');
				raise notice 'EL PERFIL FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update perfil
				set perf_descripcion=upper(perfdescripcion), perf_estado='ACTIVO'
				where perf_codigo=perfcodigo;
				raise notice 'EL PERFIL FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update perfil
		set perf_estado='INACTIVO'
		WHERE perf_codigo=perfcodigo;
		raise notice 'EL PERFIL FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(perf_audit, '') into perfAudit from perfil where perf_codigo = perfcodigo;
	--a los datos anteriores le agregamos los nuevos
	update perfil 
	set perf_audit = perfAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'perf_descripcion', upper(perfdescripcion),
		'perf_estado', upper(perfestado)
	)||','
	where perf_codigo = perfcodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado gui
select 
	g.gui_codigo,
	g.modu_codigo,
	g.gui_descripcion,
	g.gui_estado,
	m.modu_descripcion  
from gui g 
	join modulo m on m.modu_codigo = g.modu_codigo 
order by gui_codigo;
select sp_gui(1, 1, 'REFERENCIALES COMPRA', 'ACTIVO', 4, 1, 'ssan', 'ALTA', 'COMPRAS');
select coalesce(max(gui_codigo),0)+1 as gui_codigo from gui;
create or replace function sp_gui(
    guicodigo integer,
    moducodigo integer,
    guidescripcion varchar,
    guiestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    modudescripcion varchar
) returns void as
$function$
declare guiAudit text; 
begin 
    if operacion in(1,2) then
        perform * from gui
        where (upper(gui_descripcion) = upper(guidescripcion) and modu_codigo = moducodigo)
        and gui_codigo != guicodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into gui(gui_codigo, modu_codigo, gui_descripcion, gui_estado)
				values(guicodigo, moducodigo, upper(guidescripcion), 'ACTIVO');
				raise notice 'EL GUI FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update gui
				set gui_descripcion=upper(guidescripcion), modu_codigo=moducodigo, gui_estado='ACTIVO'
				where gui_codigo=guicodigo;
				raise notice 'EL GUI FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update gui 
		set gui_estado='INACTIVO'
		WHERE gui_codigo=guicodigo;
		raise notice 'EL GUI FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(gui_audit, '') into guiAudit from gui where gui_codigo = guicodigo;
	--a los datos anteriores le agregamos los nuevos
	update gui 
	set gui_audit = guiAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'gui_descripcion', upper(guidescripcion),
		'modu_codigo', moducodigo,
		'modu_descripcion', upper(modudescripcion),
		'gui_estado', upper(guiestado)
	)||','
	where gui_codigo = guicodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado perfiles_permisos
select sp_perfiles_permisos(1, 1, 1, 'ACTIVO', 4, 1, 'ssan', 'ALTA', 'ADMINISTRADOR', 'AGREGAR');
select coalesce(max(perfpe_codigo),0)+1 as perfpe_codigo from perfiles_permisos;
create or replace function sp_perfiles_permisos(
    perfpecodigo integer,
    perfcodigo integer,
    permcodigo integer,
    perfpeestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    perfdescripcion varchar,
    permdescripcion varchar
) returns void as
$function$
declare perfpeAudit text; 
begin 
    if operacion in(1,2) then
        perform * from perfiles_permisos
        where (perf_codigo=perfcodigo and perm_codigo=permcodigo)
        and perfpe_codigo != perfpecodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into perfiles_permisos(perfpe_codigo, perf_codigo, perm_codigo, perfpe_estado)
				values(perfpecodigo, perfcodigo, permcodigo, 'ACTIVO');
				raise notice 'EL PERMISO DE PERFIL FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update perfiles_permisos
				set perf_codigo=perfcodigo, perm_codigo=permcodigo, perfpe_estado='ACTIVO'
				where perfpe_codigo=perfpecodigo;
				raise notice 'EL PERMISO DE PERFIL FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update perfiles_permisos 
		set perfpe_estado='INACTIVO'
		WHERE perfpe_codigo=perfpecodigo;
		raise notice 'EL PERMISO DE PERFIL FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(perfpe_audit, '') into perfpeAudit from perfiles_permisos where perfpe_codigo = perfpecodigo;
	--a los datos anteriores le agregamos los nuevos
	update perfiles_permisos 
	set perfpe_audit = perfpeAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'perf_codigo', perfcodigo,
		'perf_descripcion', upper(perfdescripcion),
		'perm_codigo', permcodigo,
		'perm_descripcion', upper(permdescripcion),
		'perfpe_estado', upper(perfpeestado)
	)||','
	where perfpe_codigo = perfpecodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado perfiles_permisos
select sp_perfil_gui(1, 1, 1, 1, 'ACTIVO', 4, 1, 'ssan', 'ALTA', 'ADMINISTRADOR', 'REFERENCIALES COMPRA', 'COMPRAS');
select coalesce(max(perfgui_codigo),0)+1 as perfgui_codigo from perfil_gui;
create or replace function sp_perfil_gui(
    perfguicodigo integer,
    perfcodigo integer,
    guicodigo integer,
    moducodigo integer,
    perfguiestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    perfdescripcion varchar,
    guidescripcion varchar,
    modudescripcion varchar
) returns void as
$function$
declare perfguiAudit text; 
begin 
    if operacion in(1,2) then
        perform * from perfil_gui
        where (perf_codigo=perfcodigo and gui_codigo=guicodigo and modu_codigo=moducodigo)
        and perfgui_codigo != perfguicodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into perfil_gui(perfgui_codigo, perf_codigo, gui_codigo, modu_codigo, perfgui_estado)
				values(perfguicodigo, perfcodigo, guicodigo, moducodigo, 'ACTIVO');
				raise notice 'EL GUI DEL PERFIL FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update perfil_gui
				set perf_codigo=perfcodigo, gui_codigo=guicodigo, modu_codigo=moducodigo,
				perfgui_estado='ACTIVO'
				where perfgui_codigo=perfguicodigo;
				raise notice 'EL GUI DEL PERFIL FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update perfil_gui 
		set perfgui_estado='INACTIVO'
		WHERE perfgui_codigo=perfguicodigo;
		raise notice 'EL GUI DEL PERFIL FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(perfgui_audit, '') into perfguiAudit from perfil_gui where perfgui_codigo = perfguicodigo;
	--a los datos anteriores le agregamos los nuevos
	update perfil_gui 
	set perfgui_audit = perfguiAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'perf_codigo', perfcodigo,
		'perf_descripcion', upper(perfdescripcion),
		'gui_codigo', guicodigo,
		'gui_descripcion', upper(guidescripcion),
		'modu_codigo', moducodigo,
		'modu_descripcion', upper(modudescripcion),
		'perfgui_estado', upper(perfguiestado)
	)||','
	where perfgui_codigo = perfguicodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado perfiles_permisos
select  (1, 'ssan', 'prueba', 4, 1, 1, 'ACTIVO', 4, 1, 'ssan', 'ALTA', 'SISINIO ANDRES SANABRIA ZARZA', 'ADMINISTRADOR', 'SISTEMA');
select coalesce(max(usu_codigo),0)+1 as usu_codigo from usuario;
create or replace function sp_usuario(
    usucodigo integer,
    usulogin varchar,
    usucontrasenia varchar,
    moducodigo integer,
    perfcodigo integer,
    funccodigo integer,
    usuestado varchar,
    operacion integer,
    usucodigoreg integer,
    usuloginreg varchar,
    procedimiento varchar,
    funcionario varchar,
    perfdescripcion varchar,
    modudescripcion varchar
) returns void as
$function$
declare usuAudit text; 
begin 
    if operacion = 1 then
        perform * from usuario
        where usu_login=usulogin;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into usuario(
	        	usu_codigo, 
	        	usu_login, 
	        	usu_contrasenia, 
	        	usu_estado, 
	        	usu_fecha,
	        	modu_codigo,
	        	perf_codigo,
	        	func_codigo)
				values(usucodigo, usulogin, md5(usucontrasenia), 'ACTIVO', current_date, moducodigo, perfcodigo, funccodigo);
				raise notice 'EL USUARIO FUE REGISTRADO CON EXITO';
        end if;
    end if;
   	if operacion = 2 then
   		perform * from usuario
   		where usu_login=usulogin 
   		and usu_codigo != usucodigo;
   		if found then
            raise exception '1';
        elseif operacion = 2 then
		   		update usuario
				set usu_login=usulogin, func_codigo=funccodigo, usu_contrasenia=md5(usucontrasenia), 
				usu_estado='ACTIVO', modu_codigo=moducodigo, perf_codigo=perfcodigo
				where usu_codigo=usucodigo;
				raise notice 'EL USUARIO FUE MODIFICADO CON EXITO';
		end if;
   	end if;
    if operacion = 3 then 
    	update usuario 
		set usu_estado='INACTIVO'
		where usu_codigo=usucodigo;
		raise notice 'EL USUARIO FUE DESACTIVADO CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(usu_audit, '') into usuAudit  from usuario where usu_codigo = usucodigo;
	--a los datos anteriores le agregamos los nuevos
	update usuario 
	set usu_audit = usuAudit||''||json_build_object(
		'USU_CODIGO', usucodigoreg,
		'USU_LOGIN', usuloginreg,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'usu_fecha', to_char(current_date, 'DD-MM-YYYY'),
		'func_codigo', func_codigo,
		'funcionario', upper(funcionario),
		'perf_codigo', perfcodigo,
		'perf_descripcion', upper(perfdescripcion),
		'modu_codigo', moducodigo,
		'modu_descripcion', upper(modudescripcion),
		'usu_estado', upper(usuestado)
	)||','
	where usu_codigo = usucodigo;
end
$function$ 
language plpgsql;

select md5(123);

update usuario set usu_contrasenia=md5('123') where usu_codigo = 1;

SELECT 
            p.perm_descripcion, 
            apu.asigperm_estado 
         FROM asignacion_permiso_usuario apu 
            JOIN permisos p ON p.perm_codigo = apu.perm_codigo 
         WHERE usu_codigo = 1
         order by p.perm_codigo;

--Procedimiento almacenado asignacion permiso usuario
select sp_asignacion_permiso_usuario(1, 1, 1, 1, 1, 'ACTIVO', 4, 1, 'ssan' , 'ALTA', 'ssan', 'ADMINISTRADOR', 'AGREGAR');
select coalesce(max(asigperm_codigo),0)+1 as asigperm_codigo from asignacion_permiso_usuario; 
create or replace function sp_asignacion_permiso_usuario(
    asigpermcodigo integer,
    usucodigo integer,
    perfpecodigo integer,
    perfcodigo integer,
    permcodigo integer,
    asigpermestado varchar,
    operacion integer,
    usucodigoreg integer,
    usuloginreg varchar,
    procedimiento varchar,
    usulogin varchar,
    perfdescripcion varchar,
    permdescripcion varchar
) returns void as
$function$
declare asigpermAudit text;
begin 
    if operacion in(1,2) then
        perform * from asignacion_permiso_usuario
        where (usu_codigo=usucodigo and perfpe_codigo=perfpecodigo and perf_codigo=perfcodigo
        and perm_codigo=permcodigo) and asigperm_codigo != asigpermcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into asignacion_permiso_usuario(asigperm_codigo, usu_codigo, perfpe_codigo, perf_codigo, perm_codigo,
	        	asigperm_estado)
				values(asigpermcodigo, usucodigo, perfpecodigo, perfcodigo, permcodigo, 'ACTIVO');
				raise notice 'LA ASIGNACION FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update asignacion_permiso_usuario
				set usu_codigo=usucodigo, perfpe_codigo=perfpecodigo, perm_codigo=permcodigo,
				asigperm_estado='ACTIVO'
				where asigperm_codigo=asigpermcodigo;
				raise notice 'LA ASIGNACION FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update asignacion_permiso_usuario 
		set asigperm_estado='INACTIVO'
		WHERE asigperm_codigo=asigpermcodigo;
		raise notice 'LA ASIGNACION FUE BORRADA CON CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(asigperm_audit, '') into asigpermAudit from asignacion_permiso_usuario where asigperm_codigo = asigpermcodigo;
	--a los datos anteriores le agregamos los nuevos
	update asignacion_permiso_usuario 
	set asigperm_audit = asigpermAudit||''||json_build_object(
		'USU_CODIGO', usucodigoreg,
		'USU_LOGIN', usuloginreg,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'perfpe_codigo', perfpecodigo,
		'perf_codigo', perfcodigo,
		'perf_descripcion', upper(perfdescripcion),
		'perm_codigo', permcodigo,
		'perm_descripcion', upper(permdescripcion),
		'asigperm_estado', upper(asigpermestado)
	)||','
	where asigperm_codigo = asigpermcodigo;
end
$function$ 
language plpgsql;

select coalesce(max(config_codigo),0)+1 as config_codigo from configuraciones; 
create or replace function sp_configuraciones(
    configcodigo integer,
    configvalidacion varchar,
    configdescripcion varchar,
    configestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Declaramos las variables a utilizar
declare configAudit text;
begin 
	-- Validamos si la operacion es de insercion o modificacion
    if operacion in(1,2) then
		--En caso de que sea una insercion
        if operacion = 1 then
				-- Procedemos con la insercion
	        	insert into configuraciones(config_codigo, config_validacion, config_descripcion, config_estado)
				values(configcodigo, upper(configvalidacion), upper(configdescripcion),'ACTIVO');
				raise notice 'LA CONFIGURACION FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
				-- En caso de que ser una modificacion
				-- Procedemos con la modificacion
        		update configuraciones
				set 
					config_validacion=upper(configvalidacion), 
					config_descripcion=upper(configdescripcion),  
					config_estado='ACTIVO'
				where config_codigo=configcodigo;
				raise notice 'LA CONFIGURACION FUE MODIFICADA CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion
    if operacion = 3 then 
		--En caso de ser asi procedemos con la eliminacion logica
    	update configuraciones
		set config_estado='INACTIVO'
		where config_codigo=configcodigo;
		raise notice 'LA CONFIGURACION FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(config_audit, '') into configAudit from configuraciones where config_codigo = configcodigo;
	--a los datos anteriores le agragamos los nuevos
	update configuraciones 
	set config_audit = configAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'config_validacion', upper(configvalidacion),
		'config_descripcion', upper(configdescripcion),
		'config_estado', upper(configestado)
	)||','
	where config_codigo = configcodigo;
end
$function$ 
language plpgsql;

select coalesce(max(configsuc_codigo),0)+1 as configsuc_codigo from configuraciones_sucursal;
select sp_configuraciones_sucursal(1, 1, 1, 1, 'ACTIVO', 2, 1, 'ssan', 'ALTA', '5', 'DIAS HABILES PARA SOLICITAR UNA NOTA DE VENTA',
'CASA MATRIZ', '8 de diciembre');
create or replace function sp_configuraciones_sucursal(
	configsuccodigo integer,
    configcodigo integer,
    succodigo integer,
    empcodigo integer,
    configsucestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    configvalidacion varchar,
    configdescripcion varchar,
    sucdescripcion varchar,
    emprazonsocial varchar
) returns void as
$function$
-- Declaramos las variables a utilizar 
declare configSucAudit text; 
begin 
	--Validamos si la operacion es de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita ningun registro
        perform * from configuraciones_sucursal
        where (config_codigo=configcodigo and suc_codigo=succodigo and emp_codigo=empcodigo)
		and configsuc_codigo != configsuccodigo;
        if found then
			-- En caso de que se repita un registro, generamos una excepcion
            raise exception '1';
    	elseif operacion = 1 then
				-- Si la operación es de insercion, procedemos con el mismo
	        	insert into configuraciones_sucursal(configsuc_codigo, config_codigo, suc_codigo, emp_codigo, configsuc_estado)
				values(configsuccodigo, configcodigo, succodigo, empcodigo, 'ACTIVO');
				-- Mensaje de insercion
				raise notice 'LA CONFIGURACION PARA LA SUCURSAL FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
				-- Si la operación es de modificacion, procedemos con el mismo
        		update configuraciones_sucursal
				set 
					config_codigo=configcodigo, 
					suc_codigo=succodigo, 
					emp_codigo=empcodigo,
					configsuc_estado='ACTIVO'
				where configsuc_codigo=configsuccodigo;
				-- Mensaje de modificacion
				raise notice 'LA CONFIGURACION PARA LA SUCURSAL FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
		-- Si la operación es de eliminacion, procedemos con el borrado logico
    	update configuraciones_sucursal 
		set configsuc_estado='INACTIVO'
		WHERE configsuc_codigo=configsuccodigo;
		raise notice 'LA CONFIGURACION PARA LA SUCURSAL FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(configsuc_audit, '') into configSucAudit from configuraciones_sucursal where configsuc_codigo = configsuccodigo;
	--a los datos anteriores le agregamos los nuevos
	update configuraciones_sucursal 
	set configsuc_audit = configSucAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'config_codigo', configcodigo,
		'config_validacion', upper(configvalidacion),
		'config_descripcion', upper(configdescripcion),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'configsuc_estado', upper(configsucestado)
	)||','
	where configsuc_codigo = configsuccodigo;
end
$function$ 
language plpgsql;

select sp_tipo_documento(1, 'CEDULA DE IDENTIDAD', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
select coalesce(max(tipdo_codigo),0)+1 as tipdo_codigo from tipo_documento;
create or replace function sp_tipo_documento(
    tipdocodigo integer,
    tipdodescripcion varchar,
    tipdoestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare tipdoAudit text;
begin 
    if operacion in(1,2) then
        perform * from tipo_documento
        where upper(tipdo_descripcion) = upper(tipdodescripcion)
        and tipdo_codigo != tipdocodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into tipo_documento(tipdo_codigo, tipdo_descripcion, tipdo_estado)
				values(tipdocodigo, upper(tipdodescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE DOCUMENTO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		UPDATE tipo_documento
				SET tipdo_descripcion=upper(tipdodescripcion), tipdo_estado='ACTIVO'
				WHERE tipdo_codigo=tipdocodigo;
				raise notice 'EL TIPO DE DOCUMENTO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	UPDATE tipo_documento
		SET tipdo_estado='INACTIVO'
		WHERE tipdo_codigo=tipdocodigo;
		raise notice 'EL TIPO DE DOCUMENTO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(tipdo_   audit, '') into tipdoAudit from tipo_documento where tipdo_codigo = tipdocodigo;
	--a los datos anteriores le agregamos los nuevos
	update tipo_documento 
	set tipdo_audit = tipdoAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tipdo_descripcion', upper(tipdodescripcion),
		'tipdo_estado', upper(tipdoestado)
	)||','
	where tipdo_codigo = tipdocodigo;
end
$function$ 
language plpgsql;

select coalesce(max(ciu_codigo),0)+1 as ciu_codigo from ciudad;

--Procedimiento almacenado ciudad
select  
	c.ciu_codigo,
	c.ciu_descripcion,
	c.ciu_estado
from ciudad c
order by c.ciu_codigo;
select sp_ciudad(1, 'SAN ANTONIO', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
create or replace function sp_ciudad(
    ciucodigo integer,
    ciudescripcion varchar,
    ciuestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare ciuAudit text;
begin 
    if operacion in(1,2) then
        perform * from ciudad
        where upper(ciu_descripcion) = upper(ciudescripcion)
        and ciu_codigo != ciucodigo;
        if found then
            raise exception 'descripcion';
    	elseif operacion = 1 then
	        	insert into ciudad(ciu_codigo, ciu_descripcion, ciu_estado)
				values(ciucodigo, upper(ciudescripcion), 'ACTIVO');
				raise notice 'LA CIUDAD FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update ciudad
				set ciu_descripcion=upper(ciudescripcion), ciu_estado='ACTIVO'
				where ciu_codigo=ciucodigo;
				raise notice 'LA CIUDAD FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update ciudad
		set ciu_estado='INACTIVO'
		where ciu_codigo=ciucodigo;
		raise notice 'LA CIUDAD FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(ciu_audit, '') into ciuAudit from ciudad where ciu_codigo = ciucodigo;
	--a los datos anteriores le agragamos los nuevos
	update ciudad 
	set ciu_audit = ciuAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'ciu_descripcion', upper(ciudescripcion),
		'ciu_estado', upper(ciuestado)
	)||','
	where ciu_codigo = ciucodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado cargo
select sp_cargo(1, 'ADMINISTRADOR DE SISTEMAS', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
select coalesce(max(car_codigo),0)+1 as car_codigo from cargo;
create or replace function sp_cargo(
    carcodigo integer,
    cardescripcion varchar,
    carestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare carAudit text; 
begin 
    if operacion in(1,2) then
        perform * from cargo
        where upper(car_descripcion) = upper(cardescripcion)
        and car_codigo != carcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into cargo(car_codigo, car_descripcion, car_estado)
				values(carcodigo, upper(cardescripcion), 'ACTIVO');
				raise notice 'EL CARGO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		UPDATE cargo
				SET car_descripcion=upper(cardescripcion), car_estado='ACTIVO'
				WHERE car_codigo=carcodigo;
				raise notice 'EL CARGO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	UPDATE cargo
		SET car_estado='INACTIVO'
		WHERE car_codigo=carcodigo;
		raise notice 'EL CARGO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(car_audit, '') into carAudit from cargo where car_codigo = carcodigo;
	--a los datos anteriores le agregamos los nuevos
	update cargo 
	set car_audit = carAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'car_descripcion', upper(cardescripcion),
		'car_estado', upper(carestado)
	)||','
	where car_codigo = carcodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado empresa
select coalesce(max(emp_codigo),0)+1 as emp_codigo from empresa;
select sp_empresa(1, '0981635913', '8 DE DICIEMBRE', '80565656', '17866978', '8dd@gmail.com', 
'CONFECCION', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
create or replace function sp_empresa(
    empcodigo integer,
    emptelefono varchar,
    emprazonsocial varchar,
    empruc varchar,
    emptimbrado varchar,
    emptimbradofecinic date,
    emptimbradofecvenc date,
    empemail varchar,
    empactividad varchar,
    empestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Definimos las variables
declare empAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que la fecha de vencimiento del timbrado no sea menor a la fecha de inicio
		if emptimbradofecvenc <= emptimbradofecinic then
			-- En caso de ser asi, generamos una excepcion
     	 	raise exception 'fecha';
     	 end if;
		-- Validamos que no se repita el ruc de la empresa
        perform * from empresa
        where emp_ruc = empruc and emp_codigo != empcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'ruc';
		-- Si los paramtros pasaron la validacion procedmos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into empresa(emp_codigo, emp_telefono, emp_razonsocial, emp_ruc, emp_email, emp_actividad, emp_estado, emp_timbrado, 
				emp_timbrado_fec_inic, emp_timbrado_fec_venc)
				values(empcodigo, emptelefono, upper(emprazonsocial), empruc, empemail, upper(empactividad), 'ACTIVO', emptimbrado, 
				emptimbradofecinic, emptimbradofecvenc);
				raise notice 'LA EMPRESA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update empresa
				set emp_telefono=emptelefono, emp_razonsocial=upper(emprazonsocial), emp_ruc=empruc,
				emp_email=empemail, emp_actividad=upper(empactividad), emp_estado='ACTIVO', emp_timbrado=emptimbrado,
				emp_timbrado_fec_inic=emptimbradofecinic, emp_timbrado_fec_venc=emptimbradofecvenc 
				where emp_codigo=empcodigo;
				raise notice 'LA EMPRESA FUE MODIFICADA CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de elimianacion (borrado logíco)
    if operacion = 3 then 
    	update empresa
		set emp_estado='INACTIVO'
		where emp_codigo=empcodigo;
		raise notice 'LA EMPRESA FUE BORRADA CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(emp_audit, '') into empAudit from empresa where emp_codigo = empcodigo;
	-- A los datos anteriores le agragamos los nuevos
	update empresa 
	set emp_audit = empAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'emp_telefono', emptelefono,
		'emp_razonsocial', upper(emprazonsocial),
		'emp_ruc', empruc,
		'emp_timbrado', emptimbrado,
		'emp_timbrado_fec_inic', emptimbradofecinic,
		'emp_timbrado_fec_venc', emptimbradofecvenc,
		'emp_email', empemail,
		'emp_actividad', upper(empactividad),
		'emp_estado', upper(empestado)
	)||','
	where emp_codigo = empcodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado sucursal
select coalesce(max(suc_codigo),0)+1 as suc_codigo from sucursal;
select sp_sucursal(1, 1, 'CASA MATRIZ', 'RAFAEL MALGAREJO C/SAN ANTONIO', '0983337397', 
'ACTIVO', 1, '8dd.matriz@gmail.com', 4, 1, 'ssan', 'ALTA', 'SAN ANTONIO', '8 DE DICIEMBRE');
create or replace function sp_sucursal(
    succodigo integer,
    empcodigo integer,
    sucdescripcion varchar,
    sucdireccion varchar,
    suctelefono varchar,
    sucestado varchar,
    ciucodigo integer,
    sucemail varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    ciudescripcion varchar,
    emprazonsocial varchar
) returns void as
$function$
-- Definimos las variables
declare sucAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita la descripcion de la sucursal
        perform * from sucursal
        where (emp_codigo=empcodigo and upper(suc_descripcion)=upper(sucdescripcion))
        and suc_codigo != succodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into sucursal(suc_codigo, emp_codigo, suc_descripcion, suc_direccion, suc_telefono,
	        	suc_estado, ciu_codigo, suc_email)
				values(succodigo, empcodigo, upper(sucdescripcion),
				upper(sucdireccion), suctelefono, 'ACTIVO', ciucodigo, sucemail);
				raise notice 'LA SUCURSAL FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update sucursal
				set emp_codigo=empcodigo, suc_descripcion=upper(sucdescripcion), 
				suc_direccion=upper(sucdireccion), suc_telefono=suctelefono, suc_estado='ACTIVO',
				ciu_codigo=ciucodigo, suc_email=sucemail
				where suc_codigo=succodigo;
				raise notice 'LA SUCURSAL FUE MODIFICADA CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de elimianacion (borrado logíco)
    if operacion = 3 then 
    	update sucursal 
		set suc_estado='INACTIVO'
		where suc_codigo=succodigo;
		raise notice 'LA SUCURSAL FUE BORRADA CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(suc_audit, '') into sucAudit from sucursal where suc_codigo = succodigo;
	-- A los datos anteriores le agragamos los nuevos
	update sucursal 
	set suc_audit = sucAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'suc_descripcion', upper(sucdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'ciu_codigo', ciucodigo,
		'ciu_descripcion', upper(ciudescripcion),
		'suc_direccion', upper(sucdireccion),
		'suc_telefono', suctelefono,
		'suc_email', sucemail,
		'suc_estado', upper(sucestado)
	)||','
	where suc_codigo = succodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado personas
select sp_personas(1, 'SISINIO ANDRES', 'SANABRIA ZARZA', '5346486', '0986314094', 'andres.zarza@gmail.com', 'ACTIVO', 1,
4, 1, 'ssan', 'alta', 'CEDULA DE IDENTIDAD');
select coalesce(max(per_codigo),0)+1 as per_codigo from personas;
create or replace function sp_personas(
    percodigo integer,
    pernombre varchar,
    perapellido varchar,
    pernumerodocumento varchar,
    pertelefono varchar,
    peremail varchar,
    perestado varchar,
    tipdocodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    tipdodescripcion varchar
) returns void as
$function$
declare perAudit text; 
begin 
    if operacion in(1,2) then
        perform * from personas
        where per_numerodocumento=pernumerodocumento
        and per_codigo != percodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into personas(per_codigo, per_nombre, per_apellido, per_numerodocumento, per_telefono,
	        	per_email, per_estado, tipdo_codigo)
				values(percodigo, upper(pernombre), upper(perapellido), pernumerodocumento, pertelefono, peremail, 'ACTIVO', tipdocodigo);
				raise notice 'LA PERSONA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update personas
				set per_nombre=upper(pernombre), per_apellido=upper(perapellido), per_numerodocumento=pernumerodocumento, 
				per_telefono=pertelefono, per_email=peremail, per_estado='ACTIVO', tipdo_codigo=tipdocodigo
				where per_codigo=percodigo;
				raise notice 'LA PERSONA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update personas 
		set per_estado='INACTIVO'
		where per_codigo=percodigo;
		raise notice 'LA PERSONA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(per_audit, '') into perAudit from personas where per_codigo = percodigo;
	--a los datos anteriores le agregamos los nuevos
	update personas 
	set per_audit = perAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'per_nombre', upper(pernombre),
		'per_apellido', upper(perapellido),
		'per_numerodocumento', pernumerodocumento,
		'per_email', peremail,
		'tipdo_codigo', tipdocodigo,
		'tipdo_descripcion', upper(tipdodescripcion),
		'per_estado', upper(perestado)
	)||','
	where per_codigo = percodigo;
end
$function$ 
language plpgsql;

--Proccedimiento almacenado funcionario
select sp_funcionario(1, '2023-09-19', 'ACTIVO', 1, 1, 1, 1, 1, 4, 1, 'ssan', 'alta', '5346486', 
'SISINIO ANDRES SANABRIA ZARZA', 'SAN ANTONIO', 'ADMINISTRADOR DE SISTEMAS', '8 DE DICIEMBRE', 'CASA MATRIZ');
select coalesce(max(func_codigo),0)+1 as func_codigo from funcionario;
create or replace function sp_funcionario(
    funccodigo integer,
    funfechaingreso date,
    funcestado varchar,
    percodigo integer,
    ciucodigo integer,
    carcodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    pernumerodocumento varchar,
    persona varchar,
    ciudescripcion varchar,
    cardescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare funcAudit text;
begin 
    if operacion in(1,2) then
        perform * from funcionario
        where per_codigo=percodigo
        and func_codigo != funccodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into funcionario(func_codigo, fun_fechaingreso, func_estado, per_codigo, ciu_codigo,
	        	car_codigo, suc_codigo, emp_codigo)
				values(funccodigo, funfechaingreso, 'ACTIVO', percodigo, ciucodigo, carcodigo, succodigo, empcodigo);
				raise notice 'EL FUNCIONARIO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update funcionario
				set fun_fechaingreso=funfechaingreso, func_estado='ACTIVO', per_codigo=percodigo, ciu_codigo=ciucodigo,
				car_codigo=carcodigo, suc_codigo=succodigo, emp_codigo=empcodigo
				where func_codigo=funccodigo;
				raise notice 'EL FUNCIONARIO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update funcionario 
		set func_estado='INACTIVO'
		where func_codigo=funccodigo;
		raise notice 'EL FUNCIONARIO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(func_audit, '') into funcAudit from funcionario where func_codigo = funccodigo;
	--a los datos anteriores le agregamos los nuevos
	update funcionario 
	set func_audit = funcAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'fun_fechaingreso', funfechaingreso,
		'per_codigo', percodigo,
		'per_numerodocumento', pernumerodocumento,
		'persona', upper(persona),
		'ciu_codigo', ciucodigo,
		'ciu_descripcion', upper(ciudescripcion),
		'car_codigo', carcodigo,
		'car_descripcion', upper(cardescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'func_estado', upper(funcestado)
	)||','
	where func_codigo = funccodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado tipo tipo impuesto 
select coalesce(max(tipim_codigo),0)+1 as tipim_codigo from tipo_impuesto;
select sp_tipo_impuesto(1, 'IVA 5%', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
create or replace function sp_tipo_impuesto(
    tipimcodigo integer,
    tipimdescripcion varchar,
    tipimestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Definimos las variables
declare tipimAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita la descripcion del tipo de impuesto
        perform * from tipo_impuesto
        where upper(tipim_descripcion) = upper(tipimdescripcion)
        and tipim_codigo != tipimcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into tipo_impuesto(tipim_codigo, tipim_descripcion, tipim_estado)
				values(tipimcodigo, upper(tipimdescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE IMPUESTO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update tipo_impuesto
				set tipim_descripcion=upper(tipimdescripcion), tipim_estado='ACTIVO'
				where tipim_codigo=tipimcodigo;
				raise notice 'EL TIPO DE IMPUESTO FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de elimianacion (borrado logíco)
    if operacion = 3 then 
    	update tipo_impuesto
		set tipim_estado='INACTIVO'
		where tipim_codigo=tipimcodigo;
		raise notice 'EL TIPO DE IMPUESTO FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(tipim_audit, '') into tipimAudit from tipo_impuesto where tipim_codigo = tipimcodigo;
	-- A los datos anteriores le agregamos los nuevos
	update tipo_impuesto 
	set tipim_audit = tipimAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tipim_descripcion', upper(tipimdescripcion),
		'tipim_estado', upper(tipimestado)
	)||','
	where tipim_codigo = tipimcodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado tipo proveedor 
select coalesce(max(tipro_codigo),0)+1 as tipro_codigo from tipo_proveedor;
select 
	tp.tipro_codigo,
	tp.tipro_descripcion,
	tipro_estado 
from tipo_proveedor tp 
order by tp.tipro_codigo;
select sp_tipo_proveedor(1, 'MINORISTA', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
create or replace function sp_tipo_proveedor(
    tiprocodigo integer,
    tiprodescripcion varchar,
    tiproestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Definimos las variables
declare tiproAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita la descripcion del tipo de proveedor
        perform * from tipo_proveedor
        where upper(tipro_descripcion) = upper(tiprodescripcion)
        and tipro_codigo != tiprocodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into tipo_proveedor(tipro_codigo, tipro_descripcion, tipro_estado)
				values(tiprocodigo, upper(tiprodescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE PROVEEDOR FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update tipo_proveedor
				set tipro_descripcion=upper(tiprodescripcion), tipro_estado='ACTIVO'
				where tipro_codigo=tiprocodigo;
				raise notice 'EL TIPO DE PROVEEDOR FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update tipo_proveedor
		set tipro_estado='INACTIVO'
		where tipro_codigo=tiprocodigo;
		raise notice 'EL TIPO DE PROVEEDOR FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(tipro_audit, '') into tiproAudit from tipo_proveedor where tipro_codigo = tiprocodigo;
	-- A los datos anteriores le agregamos los nuevos
	update tipo_proveedor 
	set tipro_audit = tiproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tipro_descripcion', upper(tiprodescripcion),
		'tipro_estado', upper(tiproestado)
	)||','
	where tipro_codigo = tiprocodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado tipo item 
select coalesce(max(tipit_codigo),0)+1 as tipit_codigo from tipo_item;
select sp_tipo_item(1, 'MATERIA PRIMA', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
create or replace function sp_tipo_item(
    tipitcodigo integer,
    tipitdescripcion varchar,
    tipitestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Definimos las variables
declare tipitAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita la descripcion del tipo de item
        perform * from tipo_item
        where upper(tipit_descripcion) = upper(tipitdescripcion)
        and tipit_codigo != tipitcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into tipo_item(tipit_codigo, tipit_descripcion, tipit_estado)
				values(tipitcodigo, upper(tipitdescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE ITEM FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update tipo_item
				set tipit_descripcion=upper(tipitdescripcion), tipit_estado='ACTIVO'
				where tipit_codigo=tipitcodigo;
				raise notice 'EL TIPO DE ITEM FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update tipo_item
		set tipit_estado='INACTIVO'
		where tipit_codigo=tipitcodigo;
		raise notice 'EL TIPO DE ITEM FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(tipit_audit, '') into tipitAudit from tipo_item where tipit_codigo = tipitcodigo;
	-- A los datos anteriores le agregamos los nuevos
	update tipo_item 
	set tipit_audit = tipitAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tipit_descripcion', upper(tipitdescripcion),
		'tipit_estado', upper(tipitestado)
	)||','
	where tipit_codigo = tipitcodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado proveedor
select coalesce(max(pro_codigo),0)+1 as pro_codigo from proveedor;
select sp_proveedor(1, 1, 'EL HILERO', '80000000', '18976532', 'EUSEBIO AYALA C/ FELICIANO', '098562147', 'elhl@prueba.com', 
'ACTIVO', 4, 1, 'ssan', 'ALTA', 'MAYORISTA');
create or replace function sp_proveedor(
    procodigo integer,
    tiprocodigo integer,
    prorazonsocial varchar,
    proruc varchar,
    protimbrado varchar,
    protimbradovenc date,
    prodireccion varchar,
    protelefono varchar,
    proemail varchar,
    proestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    tiprodescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare proAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita el ruc de ningun proveedor
        perform * from proveedor
        where (pro_ruc = proruc or pro_razonsocial = upper(prorazonsocial)) and pro_codigo != procodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'ruc';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into proveedor(pro_codigo, tipro_codigo, pro_razonsocial, pro_ruc, pro_direccion, pro_telefono, 
	        	pro_email, pro_estado, pro_timbrado, pro_timbrado_venc)
				values(procodigo, tiprocodigo, upper(prorazonsocial), proruc, upper(prodireccion), protelefono, proemail, 'ACTIVO', protimbrado, protimbradovenc);
				raise notice 'EL PROVEEDOR FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update proveedor
				set tipro_codigo=tiprocodigo, pro_razonsocial=upper(prorazonsocial), pro_ruc=proruc,
				pro_direccion=upper(prodireccion), pro_telefono=protelefono, pro_email=proemail, pro_estado='ACTIVO',
				pro_timbrado=protimbrado, pro_timbrado_venc=protimbradovenc
				where pro_codigo=procodigo;
				raise notice 'EL PROVEEDOR FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update proveedor
		set pro_estado='INACTIVO'
		where pro_codigo=procodigo;
		raise notice 'EL PROVEEDOR FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(pro_audit, '') into proAudit from proveedor where pro_codigo = procodigo;
	-- A los datos anteriores le agregamos los nuevos
	update proveedor 
	set pro_audit = proAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'pro_razonsocial', upper(prorazonsocial),
		'tipro_codigo', tiprocodigo,
		'tipro_descripcion', upper(tiprodescripcion),
		'pro_ruc', proruc,
		'pro_timbrado', protimbrado,
		'pro_timbrado_venc', protimbradovenc,
		'pro_direccion', upper(prodireccion),
		'pro_telefono', protelefono,
		'pro_email', proemail,
		'pro_estado', upper(proestado)
	)||','
	where pro_codigo = procodigo;
end
$function$ 
language plpgsql;

-- Procedimiento almacenado funcionario proveedor
select coalesce(max(funpro_codigo),0)+1 as funpro_codigo from funcionario_proveedor;

select 
	fp.funpro_codigo,
	fp.funpro_nombre,
	fp.funpro_apellido,
	fp.funpro_documento,
	fp.funpro_estado,
	fp.pro_codigo,
	fp.tipro_codigo,
	p.pro_razonsocial,
	tp.tipro_descripcion 
from funcionario_proveedor fp 
	join proveedor p on p.pro_codigo=fp.pro_codigo 
	and p.tipro_codigo=fp.tipro_codigo 
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
order by fp.funpro_codigo;

create or replace function sp_funcionario_proveedor(
    funprocodigo integer,
    funpronombre varchar,
    funproapellido varchar,
    funprodocumento varchar,
    funproestado varchar,
    procodigo integer,
    tiprocodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    prorazonsocial varchar,
    tiprodescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare funproAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos si se paso un numero de documento
		if funprodocumento is null then
			-- Si no se paso validamos el funcionario por nombre
			perform * from funcionario_proveedor
        	where (funpro_nombre = upper(funpronombre) and funpro_apellido = upper(funproapellido)) and pro_codigo = procodigo and funpro_codigo != funprocodigo;
		else	
			-- Si se paso validamos el numero de cedula
			perform * from funcionario_proveedor
        	where (funpro_documento = funprodocumento) and pro_codigo = procodigo and funpro_codigo != funprocodigo;
		end if;
        if found then
			-- En caso de que ya se encuentre registrado, generamos una excepcion
            raise exception 'funcionario';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into funcionario_proveedor(funpro_codigo, funpro_nombre, funpro_apellido, funpro_documento, funpro_estado, pro_codigo, tipro_codigo)
				values(funprocodigo, upper(funpronombre), upper(funproapellido), funprodocumento, 'ACTIVO', procodigo, tiprocodigo);
				raise notice 'EL FUNCIONARIO PROVEEDOR FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update funcionario_proveedor
				set funpro_nombre=upper(funpronombre), funpro_apellido=upper(funproapellido), funpro_documento=funprodocumento,
				funpro_estado='ACTIVO', pro_codigo=procodigo, tipro_codigo=tiprocodigo
				where funpro_codigo=funprocodigo;
				raise notice 'EL FUNCIONARIO PROVEEDOR FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update funcionario_proveedor
		set funpro_estado='INACTIVO'
		where funpro_codigo=funprocodigo;
		raise notice 'EL FUNCIONARIO PROVEEDOR FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(funpro_audit, '') into funproAudit from funcionario_proveedor where funpro_codigo = funprocodigo;
	-- A los datos anteriores le agregamos los nuevos
	update funcionario_proveedor 
	set funpro_audit = funproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'funpro_nombre', upper(funpronombre),
		'funpro_apellido', upper(funproapellido),
		'funpro_documento', funprodocumento,
		'pro_codigo', procodigo,
		'pro_razonsocial', upper(prorazonsocial),
		'tipro_codigo', tiprocodigo,
		'tipro_descripcion', upper(tiprodescripcion),
		'funpro_estado', upper(funproestado)
	)||','
	where funpro_codigo = funprocodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado deposito
select sp_deposito(1, 1, 1, 'DEPOSITO 1', 'ACTIVO', 1, 4, 1, 'ssan', 'ALTA', 'SAN ANTONIO', '8 DE DICEMBRE', 'CASA MATRIZ');
create or replace function sp_deposito(
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    depdescripcion varchar,
    depestado varchar,
    ciucodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    ciudescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar--1:insert 2:update 3:delete
) returns void as
$function$
-- Definimos las variables
declare depAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
	    -- Validamos que no se repita la descripcion del deposito con la empresa y sucursal
        perform * from deposito
        where (upper(dep_descripcion)=upper(depdescripcion) and emp_codigo=empcodigo and suc_codigo=succodigo)
        and dep_codigo != depcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into deposito(dep_codigo, suc_codigo, emp_codigo, dep_descripcion, dep_estado, ciu_codigo)
				values(depcodigo, succodigo, empcodigo, upper(depdescripcion), 'ACTIVO', ciucodigo);
				raise notice 'EL DEPOSITO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update deposito
				set suc_codigo=succodigo, emp_codigo=empcodigo, 
				dep_descripcion=upper(depdescripcion), dep_estado='ACTIVO',
				ciu_codigo=ciucodigo
				where dep_codigo=depcodigo;
				raise notice 'EL DEPOSITO FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update deposito 
		set dep_estado='INACTIVO'
		where dep_codigo=depcodigo;
		raise notice 'EL DEPOSITO FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(dep_audit, '') into depAudit from deposito where dep_codigo = depcodigo;
	-- A los datos anteriores le agregamos los nuevos
	update deposito 
	set dep_audit = depAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'dep_descripcion', upper(depdescripcion),
		'ciu_codigo', ciucodigo,
		'ciu_descripcion', upper(ciudescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'dep_estado', upper(depestado)
	)||','
	where dep_codigo = depcodigo;
end
$function$ 
language plpgsql;

--Prodecimiento almacenado talle
select sp_talle(0, 'SIN TALLE', 'ACTIVO', 4, 1, 'ssan', 'alta');
select coalesce(max(tall_codigo),0)+1 as tall_codigo from talle;
create or replace function sp_talle(
    tallcodigo integer,
    talldescripcion varchar,
    tallestado varchar, 
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare tallAudit text; 
begin 
    if operacion in(1,2) then
        perform * from talle
        where upper(tall_descripcion) = upper(talldescripcion)
        and tall_codigo != tallcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into talle(tall_codigo, tall_descripcion, tall_estado)
				values(tallcodigo, upper(talldescripcion), 'ACTIVO');
				raise notice 'EL TALLE FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update talle
				set tall_descripcion=upper(talldescripcion), tall_estado='ACTIVO'
				where tall_codigo=tallcodigo;
				raise notice 'EL TALLE FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update talle
		set tall_estado='INACTIVO'
		where tall_codigo=tallcodigo;
		raise notice 'EL TALLE FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(tall_audit, '') into tallAudit from talle where tall_codigo = tallcodigo;
	--a los datos anteriores le agregamos los nuevos
	update talle 
	set tall_audit = tallAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tall_descripcion', upper(talldescripcion),
		'tall_estado', upper(tallestado)
	)||','
	where tall_codigo = tallcodigo;
end
$function$ 
language plpgsql;

--Prodecimiento almacenado color prenda
select 
	cp.col_codigo,
	cp.col_descripcion,
	cp.col_estado 
from color_prenda cp
order by cp.col_codigo;
select sp_color_prenda(1, 'BLANCO', 'ACTIVO', 4, 1, 'ssan', 'alta');
select coalesce(max(col_codigo),0)+1 as col_codigo from color_prenda;
create or replace function sp_color_prenda(
    colcodigo integer,
    coldescripcion varchar,
    colestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare colAudit text; 
begin 
    if operacion in(1,2) then
        perform * from color_prenda
        where upper(col_descripcion) = upper(coldescripcion)
        and col_codigo != colcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into color_prenda(col_codigo, col_descripcion, col_estado)
				values(colcodigo, upper(coldescripcion), 'ACTIVO');
				raise notice 'EL COLOR DE PRENDA FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update color_prenda
				set col_descripcion=upper(coldescripcion), col_estado='ACTIVO'
				where col_codigo=colcodigo;
				raise notice 'EL COLOR DE PRENDA FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update color_prenda
		set col_estado='INACTIVO'
		where col_codigo=colcodigo;
		raise notice 'EL COLOR DE PRENDA FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(col_audit, '') into colAudit from color_prenda where col_codigo = colcodigo;
	--a los datos anteriores le agregamos los nuevos
	update color_prenda 
	set col_audit = colAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'col_descripcion', upper(coldescripcion),
		'col_estado', upper(colestado)
	)||','
	where col_codigo = colcodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado modelo
select sp_modelo(0, 'SIN MODELO', 'M', 'SIN OBS', 'ACTIVO', 3, 4, 1, 'ssan', 'alta', 'SIN COLOR');
select coalesce(max(mod_codigo),0)+1 as mod_codigo from modelo;
create or replace function sp_modelo(
    modcodigo integer,
    modcodigomodelo varchar,
    modsexo sexo,
    modobservacion varchar,
    modestado varchar,
    colcodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    coldescripcion varchar
) returns void as
$function$
declare modAudit text;
begin 
    if operacion in(1,2) then
        perform * from modelo
        where mod_codigomodelo=modcodigomodelo
        and mod_codigo != modcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into modelo(mod_codigo, mod_codigomodelo, mod_sexo, mod_observacion, mod_estado, col_codigo)
				values(modcodigo, modcodigomodelo, modsexo, upper(modobservacion), 'ACTIVO', colcodigo);
				raise notice 'EL MODELO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update modelo
				set mod_codigomodelo=modcodigomodelo, mod_sexo=modsexo, mod_observacion=upper(modobservacion),
				mod_estado='ACTIVO', col_codigo=colcodigo
				where mod_codigo=modcodigo;
				raise notice 'EL MODELO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update modelo 
		set mod_estado='INACTIVO'
		where mod_codigo=modcodigo;
		raise notice 'EL MODELO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(mod_audit, '') into modAudit from modelo where mod_codigo = modcodigo;
	--a los datos anteriores le agregamos los nuevos
	update modelo 
	set mod_audit = modAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'mod_codigomodelo', modcodigomodelo,
		'col_codigo', colcodigo,
		'col_descripcion', upper(coldescripcion),
		'mod_sexo', modsexo,
		'mod_observacion', upper(modobservacion),
		'mod_estado', upper(modestado)
	)||','
	where mod_codigo = modcodigo;
end
$function$ 
language plpgsql;


--Procedimiento almacenado items
select coalesce(max(it_codigo),0)+1 as it_codigo from items;
select sp_items(1, 1, 'HILO NEGRO', 5000, 0, 'ACTIVO', 0, 0, 2, 3, 4, 1, 'ssan', 'ALTA', 'MATERIA PRIMA', 'IVA 10%', 'SIN MODELO', 'SIN TALLE', 'UNIDADES');
create or replace function sp_items(
    itcodigo integer,
    tipitcodigo integer,
    itdescripcion varchar,
    itcosto numeric,
    itprecio numeric,
    itestado varchar,
    modcodigo integer,
    tallcodigo integer,
    tipimcodigo integer,
    unimecodigo integer,
    itstockmin numeric,
    itstockmax numeric,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    tipitdescripcion varchar,
    tipimdescripcion varchar,
    modcodigomodelo varchar,
    talldescripcion varchar,
    unimedescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare itAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion y el tipo de item producto
	if operacion in(1,2) and tipitcodigo=2 then
		-- Validamos que no se repita la descripcion y otros datos del item producto
		perform * from items
        where upper(it_descripcion)=upper(itdescripcion) and tipit_codigo=tipitcodigo and mod_codigo=modcodigo
        and tall_codigo=tallcodigo and tipim_codigo=tipimcodigo and unime_codigo=unimecodigo and it_codigo != itcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into items(
	        	it_codigo, 
	        	tipit_codigo, 
	        	it_descripcion, 
	        	it_costo, 
	        	it_precio,
	        	it_estado,
	        	mod_codigo,
	        	tall_codigo,
	        	tipim_codigo,
				unime_codigo,
				it_stock_min,
				it_stock_max)
				values(itcodigo, tipitcodigo, upper(itdescripcion), itcosto, itprecio, 'ACTIVO', modcodigo,
				tallcodigo, tipimcodigo, unimecodigo, itstockmin, itstockmax);
				raise notice 'EL ITEM FUE REGISTRADO CON EXITO';
		elseif operacion = 2 then
				update items
				set tipit_codigo=tipitcodigo, 
				it_descripcion=upper(itdescripcion), 
				it_costo=itcosto, it_precio=itprecio,
				it_estado='ACTIVO', mod_codigo=modcodigo,
				tall_codigo=tallcodigo, tipim_codigo=tipimcodigo,
				unime_codigo=unimecodigo, it_stock_min=itstockmin,
				it_stock_max=itstockmax
				where it_codigo=itcodigo;
				raise notice 'EL ITEM FUE MODIFICADO CON EXITO';
        end if;
	end if;
	-- Validamos la operacion de insercion o modificacion y que el tipo de item no sea producto
    if operacion in(1,2) and tipitcodigo<>2 then
		-- Validamos que no se repita la descripcion del items
        perform * from items
        where upper(it_descripcion)=upper(itdescripcion) and it_codigo != itcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into items(
	        	it_codigo, 
	        	tipit_codigo, 
	        	it_descripcion, 
	        	it_costo, 
	        	it_precio,
	        	it_estado,
	        	mod_codigo,
	        	tall_codigo,
	        	tipim_codigo,
				unime_codigo,
				it_stock_min,
				it_stock_max)
				values(itcodigo, tipitcodigo, upper(itdescripcion), itcosto, itprecio, 'ACTIVO', modcodigo,
				tallcodigo, tipimcodigo, unimecodigo, itstockmin, itstockmax);
				raise notice 'EL ITEM FUE REGISTRADO CON EXITO';
		elseif operacion = 2 then
				update items
				set tipit_codigo=tipitcodigo, 
				it_descripcion=upper(itdescripcion), 
				it_costo=itcosto, it_precio=itprecio,
				it_estado='ACTIVO', mod_codigo=modcodigo,
				tall_codigo=tallcodigo, tipim_codigo=tipimcodigo,
				unime_codigo=unimecodigo, it_stock_min=itstockmin,
				it_stock_max=itstockmax
				where it_codigo=itcodigo;
				raise notice 'EL ITEM FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update items 
		set it_estado='INACTIVO'
		where it_codigo=itcodigo;
		raise notice 'EL ITEM FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(it_audit, '') into itAudit from items where it_codigo = itcodigo;
	-- A los datos anteriores le agregamos los nuevos
	update items 
	set it_audit = itAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'it_descripcion', upper(itdescripcion),
		'tipit_codigo', tipitcodigo,
		'tipit_descripcion', upper(tipitdescripcion),
		'tipim_codigo', tipimcodigo,
		'tipim_descripcion', upper(tipimdescripcion),
		'it_costo', itcosto,
		'it_precio', itprecio,
		'mod_codigo', modcodigo,
		'mod_codigomodelo', modcodigomodelo,
		'tall_codigo', tallcodigo,
		'tall_descripcion', talldescripcion,
		'unime_codigo', unimecodigo,
		'unime_descripcion', upper(unimedescripcion),
		'it_stock_min', itstockmin,
		'it_stock_max', itstockmax,
		'it_estado', upper(itestado)
	)||','
	where it_codigo = itcodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacendao tipo_comprobante 
select sp_tipo_comprobante(1, 'CREDITO', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
select coalesce(max(tipco_codigo),0)+1 as tipco_codigo from tipo_comprobante;
create or replace function sp_tipo_comprobante(
    tipcocodigo integer,
    tipcodescripcion varchar,
    tipcoestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare tipcoAudit text;
begin 
    if operacion in(1,2) then
        perform * from tipo_comprobante
        where upper(tipco_descripcion) = upper(tipcodescripcion)
        and tipco_codigo != tipcocodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into tipo_comprobante(tipco_codigo, tipco_descripcion, tipco_estado)
				values(tipcocodigo, upper(tipcodescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE COMPROBANTE FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update tipo_comprobante
				set tipco_descripcion=upper(tipcodescripcion), tipco_estado='ACTIVO'
				where tipco_codigo=tipcocodigo;
				raise notice 'EL TIPO DE COMPROBANTE FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update tipo_comprobante
		set tipco_estado='INACTIVO'
		where tipco_codigo=tipcocodigo;
		raise notice 'EL TIPO DE COMPROBANTE FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(tipco_audit, '') into tipcoAudit from tipo_comprobante where tipco_codigo = tipcocodigo;
	--a los datos anteriores le agregamos los nuevos
	update tipo_comprobante 
	set tipco_audit = tipcoAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tipco_descripcion', upper(tipcodescripcion),
		'tipco_estado', upper(tipcoestado)
	)||','
	where tipco_codigo = tipcocodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacendo forma_cobro
select sp_forma_cobro(1, 'EFECTIVO', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
select coalesce(max(forco_codigo),0)+1 as forco_codigo from forma_cobro;
create or replace function sp_forma_cobro(
    forcocodigo integer,
    forcodescripcion varchar,
    forcoestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare forcoAudit text;
begin 
    if operacion in(1,2) then
        perform * from forma_cobro
        where upper(forco_descripcion) = upper(forcodescripcion)
        and forco_codigo != forcocodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into forma_cobro(forco_codigo, forco_descripcion, forco_estado)
				values(forcocodigo, upper(forcodescripcion), 'ACTIVO');
				raise notice 'LA FORMA DE COBRO FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update forma_cobro
				set forco_descripcion=upper(forcodescripcion), forco_estado='ACTIVO'
				where forco_codigo=forcocodigo;
				raise notice 'LA FORMA DE COBRO FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update forma_cobro
		set forco_estado='INACTIVO'
		where forco_codigo=forcocodigo;
		raise notice 'LA FORMA DE COBRO FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(forco_audit, '') into forcoAudit from forma_cobro where forco_codigo = forcocodigo;
	--a los datos anteriores le agregamos los nuevos
	update forma_cobro 
	set forco_audit = forcoAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'forco_descripcion', upper(forcodescripcion),
		'forco_estado', upper(forcoestado)
	)||','
	where forco_codigo = forcocodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado marca_tarjeta
select sp_marca_tarjeta(1, 'MASTERCARD', 'ACTIVO', 4, 1, 'ssan', 'ALTA'); 
select coalesce(max(marta_codigo),0)+1 as marta_codigo from marca_tarjeta;
create or replace function sp_marca_tarjeta(
    martacodigo integer,
    martadescripcion varchar,
    martaestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare martaAudit text;
begin 
    if operacion in(1,2) then
        perform * from marca_tarjeta
        where upper(marta_descripcion) = upper(martadescripcion)
        and marta_codigo != martacodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into marca_tarjeta(marta_codigo, marta_descripcion, marta_estado)
				values(martacodigo, upper(martadescripcion), 'ACTIVO');
				raise notice 'LA MARCA DE TARJETA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update marca_tarjeta
				set marta_descripcion=upper(martadescripcion), marta_estado='ACTIVO'
				where marta_codigo=martacodigo;
				raise notice 'LA MARCA DE TARJETA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update marca_tarjeta
		set marta_estado='INACTIVO'
		where marta_codigo=martacodigo;
		raise notice 'LA MARCA DE TARJETA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(marta_audit, '') into martaAudit from marca_tarjeta where marta_codigo = martacodigo;
	--a los datos anteriores le agregamos los nuevos
	update marca_tarjeta 
	set marta_audit = martaAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'marta_descripcion', upper(martadescripcion),
		'marta_estado', upper(martaestado)
	)||','
	where marta_codigo = martacodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado entidad emisora
select sp_entidad_emisora(1, 'COOPERATIVA SAN ANDRES', '80156324', '021117000', 'cooSA@prueba', 'ACTIVO', 
4, 1, 'ssan', 'ALTA');
select coalesce(max(ent_codigo),0)+1 as ent_codigo from entidad_emisora;
create or replace function sp_entidad_emisora(
    entcodigo integer,
    entrazonsocial varchar,
    entruc varchar,
    enttelefono varchar,
    entemail varchar,
    entestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare entAudit text;
begin 
    if operacion in(1,2) then
        perform * from entidad_emisora
        where ent_ruc = entruc and ent_codigo != entcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into entidad_emisora(ent_codigo, ent_razonsocial, ent_ruc, ent_telefono, ent_email, ent_estado)
				values(entcodigo, upper(entrazonsocial), entruc, enttelefono, entemail, 'ACTIVO');
				raise notice 'LA ENTIDAD EMISORA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update entidad_emisora
				set ent_razonsocial=upper(entrazonsocial), ent_ruc=entruc, ent_telefono=enttelefono,
				ent_email=entemail, ent_estado='ACTIVO'
				where ent_codigo=entcodigo;
				raise notice 'LA ENTIDAD EMISORA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update entidad_emisora
		set ent_estado='INACTIVO'
		where ent_codigo=entcodigo;
		raise notice 'LA ENTIDAD EMISORA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(ent_audit, '') into entAudit from entidad_emisora where ent_codigo = entcodigo;
	--a los datos anteriores le agregamos los nuevos
	update entidad_emisora 
	set ent_audit = entAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'ent_razonsocial', upper(entrazonsocial),
		'ent_ruc', entruc,
		'ent_telefono', enttelefono,
		'ent_email', entemail,
		'ent_estado', upper(entestado)
	)||','
	where ent_codigo = entcodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado entidad adherida
select 
               ea.entad_codigo,
               ea.ent_codigo,
               ea.marta_codigo,
               ea.entad_estado,
               ee.ent_razonsocial,
               mt.marta_descripcion 
         from entidad_adherida ea
               join entidad_emisora ee on ee.ent_codigo=ea.entad_codigo
               join marca_tarjeta mt on mt.marta_codigo=ea.marta_codigo
         order by ea.entad_codigo;
select sp_entidad_adherida(1, 1, 1, 'ACTIVO', 4, 1, 'ssan', 'ALTA', 'COOPERATIVA SAN ANDRES', 'MASTERCARD');
select coalesce(max(entad_codigo),0)+1 as entad_codigo from entidad_adherida;
create or replace function sp_entidad_adherida(
    entadcodigo integer,
    entcodigo integer,
    martacodigo integer,
    entadestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    entrazonsocial varchar,
    martadescripcion varchar
) returns void as
$function$
declare entadAudit text;
begin 
    if operacion in(1,2) then
        perform * from entidad_adherida
        where (ent_codigo=entcodigo and marta_codigo=martacodigo)
        and entad_codigo != entadcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into entidad_adherida(entad_codigo, ent_codigo, marta_codigo, entad_estado)
				values(entadcodigo, entcodigo, martacodigo, 'ACTIVO');
				raise notice 'LA ENTIDAD ADHERIDA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update entidad_adherida
				set ent_codigo=entcodigo, marta_codigo=martacodigo, entad_estado='ACTIVO'
				where entad_codigo=entadcodigo;
				raise notice 'LA ENTIDAD ADHERIDA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update entidad_adherida
		set entad_estado='INACTIVO'
		where entad_codigo=entadcodigo;
		raise notice 'LA ENTIDAD ADHERIDA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(entad_audit, '') into entadAudit from entidad_adherida where entad_codigo = entadcodigo;
	--a los datos anteriores le agregamos los nuevos
	update entidad_adherida 
	set entad_audit = entadAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'ent_codigo', entcodigo,
		'ent_razonsocial', upper(entrazonsocial),
		'marta_codigo', martacodigo,
		'marta_descripcion', upper(martadescripcion),
		'entad_estado', upper(entadestado)
	)||','  
	where entad_codigo = entadcodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado caja
select 
	c.caj_codigo,
	c.caj_descripcion,
	c.caj_estado 
from caja c
order by c.caj_codigo;
select sp_caja(1, 'CAJA 1', 'ACTIVO', 4, 1, 'ssan', 'ALTA');
select coalesce(max(caj_codigo),0)+1 as caj_codigo from caja;
create or replace function sp_caja(
    cajcodigo integer,
    cajdescripcion varchar,
    cajestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare cajAudit text;
begin 
    if operacion in(1,2) then
        perform * from caja
        where upper(caj_descripcion)=upper(cajdescripcion)
        and caj_codigo != cajcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into caja(caj_codigo, caj_descripcion, caj_estado, suc_codigo, emp_codigo)
				values(cajcodigo, upper(cajdescripcion), 'ACTIVO');
				raise notice 'LA CAJA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update caja
				set caj_descripcion=upper(cajdescripcion), caj_estado='ACTIVO'
				where caj_codigo=cajcodigo;
				raise notice 'LA CAJA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update caja 
		set caj_estado='INACTIVO'
		where caj_codigo=cajcodigo;
		raise notice 'LA CAJA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(caj_audit, '') into cajAudit from caja where caj_codigo = cajcodigo;
	--a los datos anteriores le agregamos los nuevos
	update caja 
	set caj_audit = cajAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'caj_descripcion', upper(cajdescripcion),
		'caj_estado', upper(cajestado)
	)||','
	where caj_codigo = cajcodigo;
end
$function$ 
language plpgsql;

-- Procedimiento almacenado marca_vehiculo
select 
	mv.marve_codigo,
	mv.marve_descripcion,
	mv.marve_estado 
from marca_vehiculo mv 
where mv.marve_descripcion ilike '%%'
and mv.marve_estado = 'ACTIVO'
order by mv.marve_codigo;

select coalesce(max(marve_codigo),0)+1 as marve_codigo from marca_vehiculo;
create or replace function sp_marca_vehiculo(
    marvecodigo integer,
    marvedescripcion varchar,
    marveestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Definimos las variables
declare marveAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
        perform * from marca_vehiculo
        where upper(marve_descripcion)=upper(marvedescripcion)
        and marve_codigo != marvecodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into marca_vehiculo(marve_codigo, marve_descripcion, marve_estado)
				values(marvecodigo, upper(marvedescripcion), 'ACTIVO');
				raise notice 'LA MARCA DE VEHICULO FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update marca_vehiculo
				set marve_descripcion=upper(marvedescripcion), marve_estado='ACTIVO'
				where marve_codigo=marvecodigo;
				raise notice 'LA MARCA DE VEHICULO FUE MODIFICADA CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update marca_vehiculo 
		set marve_estado='INACTIVO'
		where marve_codigo=marvecodigo;
		raise notice 'LA MARCA DE VEHICULO FUE BORRADA CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(marve_audit, '') into marveAudit from marca_vehiculo where marve_codigo = marvecodigo;
	-- A los datos anteriores le agregamos los nuevos
	update marca_vehiculo 
	set marve_audit = marveAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'marve_descripcion', upper(marvedescripcion),
		'marve_estado', upper(marveestado)
	)||','
	where marve_codigo = marvecodigo;
end
$function$ 
language plpgsql;

-- Procedimiento almacenado modelo_vehiculo
select 
	mv.modve_codigo,
	mv.modve_descripcion,
	mv.modve_estado,
	mv.marve_codigo,
	mv2.marve_descripcion 
from modelo_vehiculo mv 
join marca_vehiculo mv2 on mv2.marve_codigo=mv.marve_codigo 
order by mv.modve_codigo;

select coalesce(max(modve_codigo),0)+1 as modve_codigo from modelo_vehiculo;
create or replace function sp_modelo_vehiculo(
    modvecodigo integer,
    modvedescripcion varchar,
    modveestado varchar,
    marvecodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    marvedescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare modveAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita el modelo vehiculo y la marca del vehiculo
        perform * from modelo_vehiculo
        where upper(modve_descripcion)=upper(modvedescripcion) and marve_codigo=marvecodigo
        and modve_codigo != modvecodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into modelo_vehiculo(modve_codigo, modve_descripcion, modve_estado, marve_codigo)
				values(modvecodigo, upper(modvedescripcion), 'ACTIVO', marvecodigo);
				raise notice 'EL MODELO DE VEHICULO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update modelo_vehiculo
				set modve_descripcion=upper(modvedescripcion), modve_estado='ACTIVO', marve_codigo=marvecodigo
				where modve_codigo=modvecodigo;
				raise notice 'EL MODELO DE VEHICULO FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update modelo_vehiculo 
		set modve_estado='INACTIVO'
		where modve_codigo=modvecodigo;
		raise notice 'EL MODELO DE VEHICULO FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(modve_audit, '') into modveAudit from modelo_vehiculo where modve_codigo = modvecodigo;
	-- A los datos anteriores le agregamos los nuevos
	update modelo_vehiculo 
	set modve_audit = modveAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'modve_descripcion', upper(modvedescripcion),
		'marve_codigo', marvecodigo,
		'marve_descripcion', upper(marvedescripcion),
		'modve_estado', upper(modveestado)
	)||','
	where modve_codigo = modvecodigo;
end
$function$ 
language plpgsql;

-- Procedimiento almacenado chapa_vehiculo
select 
	mv.modve_codigo,
	mv.modve_descripcion,
	mv2.marve_codigo,
	mv2.marve_descripcion,
	mv2.marve_descripcion||', '||'MODELO: '||mv.modve_descripcion as descripcion
from modelo_vehiculo mv 
join marca_vehiculo mv2 on mv2.marve_codigo=mv.marve_codigo 
where (mv.modve_descripcion ilike '%li%' or mv2.marve_descripcion ilike '%li%')
and mv.modve_estado='ACTIVO'
order by mv.modve_codigo;

select 
	cv.chave_codigo,
	cv.chave_chapa,
	cv.modve_codigo,
	cv.chave_estado,
	mv.modve_descripcion,
	mv2.marve_codigo,
	mv2.marve_descripcion,
	mv2.marve_descripcion||', '||'MODELO: '||mv.modve_descripcion as descripcion
from chapa_vehiculo cv 
join modelo_vehiculo mv on mv.modve_codigo=cv.modve_codigo 
join marca_vehiculo mv2 on mv2.marve_codigo=mv.marve_codigo 
order by cv.chave_codigo;

select coalesce(max(chave_codigo),0)+1 as chave_codigo from chapa_vehiculo; 

create or replace function sp_chapa_vehiculo(
	chavecodigo integer,
    chavechapa varchar,
    modvecodigo integer,
    marvecodigo integer,
    chaveestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    modvedescripcion varchar,
    marvedescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare chaveAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita el numero de chapa
        perform * from chapa_vehiculo
        where upper(chave_chapa)=upper(chavechapa) and chave_codigo != chavecodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'chapa';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into chapa_vehiculo(chave_codigo, chave_chapa, modve_codigo, chave_estado)
				values(chavecodigo, upper(chavechapa), modvecodigo, 'ACTIVO');
				raise notice 'LA CHAPA DE VEHICULO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update chapa_vehiculo
				set chave_chapa=upper(chavechapa), modve_codigo=modvecodigo, chave_estado='ACTIVO'
				where chave_codigo=chavecodigo;
				raise notice 'LA CHAPA DE VEHICULO FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update chapa_vehiculo 
		set chave_estado='INACTIVO'
		where chave_codigo=chavecodigo;
		raise notice 'LA CHAPA DE VEHICULO FUE BORRADA CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(chave_audit, '') into chaveAudit from chapa_vehiculo where chave_codigo = chavecodigo;
	-- A los datos anteriores le agregamos los nuevos
	update chapa_vehiculo 
	set chave_audit = chaveAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'chave_chapa', upper(chavechapa),
		'modve_codigo', modvecodigo,
		'modve_descripcion', upper(modvedescripcion),
		'marve_codigo', marvecodigo,
		'marve_descripcion', upper(marvedescripcion),
		'chave_estado', upper(chaveestado)
	)||','
	where chave_codigo = chavecodigo;
end
$function$ 
language plpgsql;

-- Procedimiento almacenado tipo_cliente
select 
	tc.ticli_codigo,
	tc.ticli_descripcion,
	tc.ticli_estado 
from tipo_cliente tc 
order by tc.ticli_codigo;

select coalesce(max(ticli_codigo),0)+1 as ticli_codigo from tipo_cliente;

create or replace function sp_tipo_cliente(
    ticlicodigo integer,
    ticlidescripcion varchar,
    ticliestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
-- Definimos las variables
declare ticliAudit text;
begin 
	-- Validamos la operacion de insercion o modificacion
    if operacion in(1,2) then
		-- Validamos que no se repita la descripcion de tipo cliente
        perform * from tipo_cliente
        where upper(ticli_descripcion)=upper(ticlidescripcion) and ticli_codigo != ticlicodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'descripcion';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro o modificacion
    	elseif operacion = 1 then
	        	insert into tipo_cliente(ticli_codigo, ticli_descripcion, ticli_estado)
				values(ticlicodigo, upper(ticlidescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE CLIENTE FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update tipo_cliente
				set ticli_descripcion=upper(ticlidescripcion), ticli_estado='ACTIVO'
				where ticli_codigo=ticlicodigo;
				raise notice 'EL TIPO DE CLIENTE FUE MODIFICADO CON EXITO';
        end if;
    end if;
	-- Validamos si la operacion es de eliminacion (borrado logíco)
    if operacion = 3 then 
    	update tipo_cliente 
		set ticli_estado='INACTIVO'
		where ticli_codigo=ticlicodigo;
		raise notice 'EL TIPO DE CLIENTE FUE BORRADO CON EXITO';
    end if;
	-- Consultamos el audit anterior
	select coalesce(ticli_audit, '') into ticliAudit from tipo_cliente where ticli_codigo = ticlicodigo;
	-- A los datos anteriores le agregamos los nuevos
	update tipo_cliente 
	set ticli_audit = ticliAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'ticli_descripcion', upper(ticlidescripcion),
		'ticli_estado', upper(ticliestado)
	)||','
	where ticli_codigo = ticlicodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado maquinaria
select 
	m.maq_codigo,
	m.maq_descripcion,
	m.maq_estado 
from maquinaria m
order by m.maq_codigo;
select sp_maquinaria(1, 'RECTA', 'ACTIVO', 4, 1, 'ssan', 'alta');
select coalesce(max(maq_codigo),0)+1 as maq_codigo from maquinaria;
create or replace function sp_maquinaria(
    maqcodigo integer,
    maqdescripcion varchar,
    maqestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare maqAudit text;
begin 
    if operacion in(1,2) then
        perform * from maquinaria
        where upper(maq_descripcion) = upper(maqdescripcion)
        and maq_codigo != maqcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into maquinaria(maq_codigo, maq_descripcion, maq_estado)
				values((select coalesce(max(maq_codigo),0)+1 from maquinaria), upper(maqdescripcion), 'ACTIVO');
				raise notice 'LA MAQUINARIA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update maquinaria
				set maq_descripcion=upper(maqdescripcion), maq_estado='ACTIVO'
				where maq_codigo=maqcodigo;
				raise notice 'LA MAQUINARIA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update maquinaria
		set maq_estado='INACTIVO'
		where maq_codigo=maqcodigo;
		raise notice 'LA MAQUINARIA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(maq_audit, '') into maqAudit from maquinaria where maq_codigo = maqcodigo;
	--a los datos anteriores le agregamos los nuevos
	update maquinaria 
	set maq_audit = maqAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'maq_descripcion', upper(maqdescripcion),
		'maq_estado', upper(maqestado)
	)||','
	where maq_codigo = maqcodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado cliente
select 
               c.cli_codigo,
               c.cli_direccion,
               c.cli_tipocliente, 
               c.cli_estado,
               c.per_codigo,
               c.ciu_codigo,
               p.per_nombre||' '||p.per_apellido as persona,
	           p.per_numerodocumento,
               ci.ciu_descripcion 
         from cliente c
               join personas p on p.per_codigo=c.per_codigo
               join ciudad ci on ci.ciu_codigo=c.ciu_codigo
         order by c.cli_codigo;
select sp_cliente(1, 'ACHUCARRO C/AVD. SAN ANTONIO', 'FISICA', 'ACTIVO', 1,  1, 4, 1, 'ssan',
'ALTA', '5346486', 'SISINIO ANDRES SANABRIA ZARZA', 'SAN ANTONIO');
select coalesce(max(cli_codigo),0)+1 as cli_codigo from cliente;
create or replace function sp_cliente(
    clicodigo integer,
    clidireccion varchar,
    clitipocliente tipo_cliente,
    cliestado varchar,
    percodigo integer,
    ciucodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    pernumerodocumento varchar,
    persona varchar,
    ciudescripcion varchar--1:insert 2:update 3:delete
) returns void as
$function$
declare cliAudit text;
begin 
    if operacion in(1,2) then
        perform * from cliente
        where per_codigo=percodigo
        and cli_codigo != clicodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into cliente(cli_codigo, cli_direccion, cli_tipocliente, cli_estado, per_codigo,
	        	ciu_codigo)
				values(clicodigo, upper(clidireccion), clitipocliente, 'ACTIVO', percodigo, ciucodigo);
				raise notice 'EL CLIENTE FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update cliente
				set cli_direccion=upper(clidireccion), cli_tipocliente=clitipocliente, cli_estado='ACTIVO',
				per_codigo=percodigo, ciu_codigo=ciucodigo
				where cli_codigo=clicodigo;
				raise notice 'EL CLIENTE FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update cliente 
		set cli_estado='INACTIVO'
		where cli_codigo=clicodigo;
		raise notice 'EL CLIENTE FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(cli_audit, '') into cliAudit from cliente where cli_codigo = clicodigo;
	--a los datos anteriores le agregamos los nuevos
	update cliente 
	set cli_audit = cliAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'cli_tipocliente', clitipocliente,
		'per_codigo', percodigo,
		'per_numerodocumento', pernumerodocumento,
		'persona', upper(persona),
		'ciu_codigo', ciucodigo,	
		'ciu_descripcion', upper(ciudescripcion),	
		'cli_direccion', upper(clidireccion),
		'cli_estado', upper(cliestado)
	)||','
	where cli_codigo = clicodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado tipo etapa produccion
select 
	tep.tipet_codigo,
	tep.tipet_descripcion,
	tep.tipet_estado 
from tipo_etapa_produccion tep
order by tep.tipet_codigo;
select sp_tipo_etapa_produccion(1, 'CORTE', 'ACTIVO', 4, 1, 'ssan', 'alta');
select coalesce(max(tipet_codigo),0)+1 as tipet_codigo from tipo_etapa_produccion;
create or replace function sp_tipo_etapa_produccion(
    tipetcodigo integer,
    tipetdescripcion varchar,
    tipetestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare tipetAudit text;
begin 
    if operacion in(1,2) then
        perform * from tipo_etapa_produccion
        where upper(tipet_descripcion) = upper(tipetdescripcion)
        and tipet_codigo != tipetcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into tipo_etapa_produccion(tipet_codigo, tipet_descripcion, tipet_estado)
				values(tipetcodigo, upper(tipetdescripcion), 'ACTIVO');
				raise notice 'EL TIPO DE ETAPA DE PRODUCCION FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update tipo_etapa_produccion
				set tipet_descripcion=upper(tipetdescripcion), tipet_estado='ACTIVO'
				where tipet_codigo=tipetcodigo;
				raise notice 'EL TIPO DE ETAPA DE PRODUCCION FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update tipo_etapa_produccion
		set tipet_estado='INACTIVO'
		where tipet_codigo=tipetcodigo;
		raise notice 'EL TIPO DE ETAPA DE PRODUCCION FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(tipet_audit, '') into tipetAudit from tipo_etapa_produccion where tipet_codigo = tipetcodigo;
	--a los datos anteriores le agregamos los nuevos
	update tipo_etapa_produccion 
	set tipet_audit = tipetAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'tipet_descripcion', upper(tipetdescripcion),
		'tipet_estado', upper(tipetestado)
	)||','
	where tipet_codigo = tipetcodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado unidad medida
select 
	um.unime_codigo,
	um.unime_descripcion,
	um.unime_estado,
	um.unime_simbolo
from unidad_medida um
order by um.unime_codigo;
select sp_unidad_medida(1, 'CENTIMETROS', 'ACTIVO', 'Cm', 4, 1, 'ssan', 'alta');
select lower('ASDASD'); 
select coalesce(max(unime_codigo),0)+1 as unime_codigo from unidad_medida;
create or replace function sp_unidad_medida(
    unimecodigo integer,
    unimedescripcion varchar,
    unimeestado varchar,
    unimesimbolo varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare unimeAudit text;
begin 
    if operacion in(1,2) then
        perform * from unidad_medida
        where upper(unime_descripcion) = upper(unimedescripcion)
        and unime_codigo != unimecodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into unidad_medida(unime_codigo, unime_descripcion, unime_estado, unime_simbolo)
				values(unimecodigo, upper(unimedescripcion), 'ACTIVO', lower(unimesimbolo));
				raise notice 'LA UNIDAD DE MEDIDA FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update unidad_medida
				set unime_descripcion=upper(unimedescripcion), unime_estado='ACTIVO', unime_simbolo=lower(unimesimbolo)
				where unime_codigo=unimecodigo;
				raise notice 'LA UNIDAD DE MEDIDA FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update unidad_medida
		set unime_estado='INACTIVO'
		where unime_codigo=unimecodigo;
		raise notice 'LA UNIDAD DE MEDIDA FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(unime_audit, '') into unimeAudit from unidad_medida where unime_codigo = unimecodigo;
	--a los datos anteriores le agregamos los nuevos
	update unidad_medida 
	set unime_audit = unimeAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'unime_descripcion', upper(unimedescripcion),
		'unime_simbolo', lower(unimesimbolo),
		'unime_estado', upper(unimeestado)
	)||','
	where unime_codigo = unimecodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado parametro control calidad
select
	pcc.pacoca_codigo,
	pcc.pacoca_descripcion,
	pcc.pacoca_estado 
from parametro_control_calidad pcc 
order by pcc.pacoca_codigo;
select sp_parametro_control_calidad(1, 'COLOR DE HILO', 'ACTIVO', 4, 1, 'ssan', 'alta');
select coalesce(max(pacoca_codigo),0)+1 as pacoca_codigo from parametro_control_calidad;
create or replace function sp_parametro_control_calidad(
    pacocacodigo integer,
    pacocadescripcion varchar,
    pacocaestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare pacocaAudit text;
begin 
    if operacion in(1,2) then
        perform * from parametro_control_calidad
        where upper(pacoca_descripcion) = upper(pacocadescripcion)
        and pacoca_codigo != pacocacodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into parametro_control_calidad(pacoca_codigo, pacoca_descripcion, pacoca_estado)
				values(pacocacodigo, upper(pacocadescripcion), 'ACTIVO');
				raise notice 'EL PARAMETRO DE CONTROL DE CALIDAD FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update parametro_control_calidad
				set pacoca_descripcion=upper(pacocadescripcion), pacoca_estado='ACTIVO'
				where pacoca_codigo=pacocacodigo;
				raise notice 'EL PARAMETRO DE CONTROL DE CALIDAD FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update parametro_control_calidad
		set pacoca_estado='INACTIVO'
		where pacoca_codigo=pacocacodigo;
		raise notice 'EL PARAMETRO DE CONTROL DE CALIDAD FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(pacoca_audit, '') into pacocaAudit from parametro_control_calidad where pacoca_codigo = pacocacodigo;
	--a los datos anteriores le agregamos los nuevos
	update parametro_control_calidad 
	set pacoca_audit = pacocaAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'pacoca_descripcion', upper(pacocadescripcion),
		'pacoca_estado', upper(pacocaestado)
	)||','
	where pacoca_codigo = pacocacodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado costo servicio
create or replace function sp_costo_servicio(
    costservcodigo integer,
    costservcosto numeric,
    costservestado varchar,
    modcodigo integer,
    operacion integer 
) returns void as
$function$
begin 
    if operacion in(1,2) then
        perform * from costo_servicio
        where mod_codigo=modcodigo and costserv_codigo != costservcodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into costo_servicio(costserv_codigo, costserv_costo, costserv_estado, mod_codigo)
				values((select coalesce(max(costserv_codigo),0)+1 from costo_servicio), costservcosto, 'ACTIVO', modcodigo);
				raise notice 'EL COSTO SERVICIO FUE REGISTRADO CON EXITO';
        elseif operacion = 2 then
        		update costo_servicio
				set costserv_costo=costservcosto, costserv_estado='ACTIVO', mod_codigo=modcodigo
				where costserv_codigo=costservcodigo;
				raise notice 'EL COSTO SERVICIO FUE MODIFICADO CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update costo_servicio
		set costserv_estado='INACTIVO'
		where costserv_codigo=costservcodigo;
		raise notice 'EL COSTO SERVICIO FUE BORRADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado seccion
select 
               s.secc_codigo,
               s.secc_descripcion,
               s.secc_estado,
               s.suc_codigo,
               s.emp_codigo,
               su.suc_descripcion,
               e.emp_razonsocial
         from seccion s 
               join sucursal su on su.suc_codigo=s.suc_codigo
               and su.emp_codigo=s.emp_codigo
               join empresa e on e.emp_codigo=su.emp_codigo
         order by s.secc_codigo
select sp_seccion(1, 'SECCION 1', 'ACTIVO', 1, 1, 4, 1, 'ssan', 'alta', '8 DE Diciembre', 'Casa Matriz');
select coalesce(max(secc_codigo),0)+1 as secc_codigo from seccion;
create or replace function sp_seccion(
    secccodigo integer,
    seccdescripcion varchar,
    seccestado varchar,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare seccAudit text;
begin 
    if operacion in(1,2) then
        perform * from seccion
        where (upper(secc_descripcion)=upper(seccdescripcion) and emp_codigo=empcodigo and suc_codigo=succodigo)
        and secc_codigo != secccodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into seccion(secc_codigo, secc_descripcion, secc_estado, suc_codigo, emp_codigo)
				values(secccodigo, upper(seccdescripcion), 'ACTIVO', succodigo, empcodigo);
				raise notice 'LA SECCION FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
        		update seccion
				set secc_descripcion=upper(seccdescripcion), secc_estado='ACTIVO', 
				suc_codigo=succodigo, emp_codigo=empcodigo
				where secc_codigo=secccodigo;
				raise notice 'LA SECCION FUE MODIFICADA CON EXITO';
        end if;
    end if;
    if operacion = 3 then 
    	update seccion 
		set secc_estado='INACTIVO'
		where secc_codigo=secccodigo;
		raise notice 'LA SECCION FUE BORRADA CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(secc_audit, '') into seccAudit from seccion where secc_codigo = secccodigo;
	--a los datos anteriores le agregamos los nuevos
	update seccion 
	set secc_audit = seccAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'secc_descripcion', upper(seccdescripcion),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'secc_estado', upper(seccestado)
	)||','
	where secc_codigo = secccodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado equipo trabajo
select sp_equipo_trabajo(5, 1, 'ACTIVO', 4, 1, 'ssan', 'alta', '11111111', 'GUSTAVO  VILLALBA', 'SECCION 1');
create or replace function sp_equipo_trabajo(
    funccodigo integer,
    secccodigo integer,
    eqtraestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar,
    pernumerodocumento varchar,
    funcionario varchar,
    seccdescripcion varchar
) returns void as
$function$
declare eqtraAudit text;
begin 
    if operacion = 1 then
        perform * from equipo_trabajo
        where func_codigo=funccodigo and secc_codigo=secccodigo;
        if found then
            raise exception '1';
    	elseif operacion = 1 then
	        	insert into equipo_trabajo(func_codigo, secc_codigo, eqtra_estado)
				values(funccodigo, secccodigo, 'ACTIVO');
				raise notice 'EL EQUIPO DE TRABAJO FUE REGISTRADO CON EXITO';
        end if;
    end if;
   if operacion = 2 then 
    	update equipo_trabajo
		set eqtra_estado='ACTIVO'
		where func_codigo=funccodigo and secc_codigo=secccodigo;
		raise notice 'EL EQUIPO DE TRABAJO FUE MODIFICADO CON EXITO';
    end if;
    if operacion = 3 then 
    	update equipo_trabajo 
		set eqtra_estado='INACTIVO'
		WHERE func_codigo=funccodigo and secc_codigo=secccodigo;
		raise notice 'EL EQUIPO DE TRABAJO FUE BORRADO CON EXITO';
    end if;
	--consultamos el audit anterior 
	select coalesce(eqtra_audit, '') into eqtraAudit from equipo_trabajo where func_codigo=funccodigo and secc_codigo=secccodigo;
	--a los datos anteriores le agregamos los nuevos
	update equipo_trabajo 
	set eqtra_audit = eqtraAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'func_codigo', funccodigo,
		'funcionario', upper(funcionario),
		'secc_codigo', secccodigo,
		'secc_descripcion', upper(seccdescripcion),
		'eqtra_estado', upper(eqtraestado)
	)||','
	where func_codigo=funccodigo and secc_codigo=secccodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado pedido compra cabecera
select
	1
from pedido_presupuesto pp 
	join pedido_compra_cab pcc on pcc.pedco_codigo=pp.pedco_codigo 
	join presupuesto_proveedor_cab ppc on ppc.prepro_codigo=pp.prepro_codigo 
where pp.pedco_codigo=1 and ppc.prepro_estado <> 'ANULADO';

select sp_pedido_compra_cab(1, '2023-10-17', 'APROBADO', 1, 1, 1, 4, 'ssan', 'alta', '8 DE diciembre', 'casa matriz');
select coalesce(max(pedco_codigo),0)+1 as pedco_codigo from pedido_compra_cab;
create or replace function sp_pedido_compra_cab(
    pedcocodigo integer,
    pedcofecha date,
    pedcoestado varchar,
    succodigo integer,
    empcodigo integer,
    usucodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare pedcoAudit text;
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
	     insert into pedido_compra_cab(pedco_codigo, pedco_fecha, pedco_estado, suc_codigo, emp_codigo, usu_codigo)
		 values(pedcocodigo, pedcofecha, 'PENDIENTE', succodigo, empcodigo, usucodigo);
		 -- Se envia un mensaje de confirmacion
		 raise notice 'EL PEDIDO DE COMPRA FUE REGISTRADO CON EXITO';
    end if;
	-- Validamos la operacion de anulacion
    if operacion = 2 then 
		-- Si ya se encuentra asociado un pedido a un presupuesto en un estado distinto a anulado 
		perform 1 from pedido_presupuesto pp 
		join pedido_compra_cab pcc on pcc.pedco_codigo=pp.pedco_codigo 
		join presupuesto_proveedor_cab ppc on ppc.prepro_codigo=pp.prepro_codigo 
		where pp.pedco_codigo=pedcocodigo and ppc.prepro_estado <> 'ANULADO';
		if found then
			-- En caso de ser asi, generamos una excepcion
			raise exception 'asociado';
		elseif operacion = 2 then
			update pedido_compra_cab 
			set pedco_estado='ANULADO', usu_codigo=usucodigo
			where pedco_codigo=pedcocodigo;
			-- Se envia un mensaje de confirmacion
			raise notice 'EL PEDIDO DE COMPRA FUE ANULADO CON EXITO';
		end if;
    end if;
	-- Consultamos el audit anterior
	select coalesce(pedco_audit, '') into pedcoAudit from pedido_compra_cab where pedco_codigo = pedcocodigo;
	-- A los datos anteriores le agregamos los nuevos
	update pedido_compra_cab 
	set pedco_audit = pedcoAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'pedco_estado', upper(pedcoestado)
	)||','
	where pedco_codigo = pedcocodigo;
end
$function$ 
language plpgsql;

select 
            i.it_codigo,
            i.tipit_codigo,
            i.it_descripcion,
  			i.unime_codigo,
  			um.unime_descripcion,
            it_costo as pedcodet_precio 
         from items i
         	join unidad_medida um on um.unime_codigo=i.unime_codigo
         where 
            i.it_descripcion ilike '%$item%' 
            and i.tipit_codigo <> 2
            and i.it_estado = 'ACTIVO'
         order by i.it_codigo;

--Procedimiento almacenado pedido compra detalle
create or replace function sp_pedido_compra_det(
    pedcocodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    pedcodetcantidad numeric,
    pedcodetprecio numeric,
    operacion integer --1:insert 2:delete
) returns void as
$function$
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		-- Validamos que no se repota el ítem en el detalle
     	perform * from pedido_compra_det
     	where it_codigo=itcodigo and pedco_codigo=pedcocodigo;
     	if found then
			 -- Si es asi, generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
		     insert into pedido_compra_det(pedco_codigo, it_codigo, tipit_codigo, pedcodet_cantidad, pedcodet_precio)
			 values(pedcocodigo, itcodigo, tipitcodigo, pedcodetcantidad, pedcodetprecio);
			 -- Se envia un mensaje de confirmacion
			 raise notice 'EL PEDIDO DE COMPRA DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de eliminación
    if operacion = 2 then 
    	delete from pedido_compra_det 
    	where pedco_codigo=pedcocodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		-- Se envia un mensaje de confirmacion
		raise notice 'EL PEDIDO DE COMPRA DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacendado presupuesto proveedor cabecera
select
            i.it_codigo,
            i.tipit_codigo,
            i.it_descripcion,
            um.unime_codigo,
            um.unime_descripcion,
            pcd.pedcodet_cantidad as peprodet_cantidad
         from pedido_compra_det pcd 
            join items i on i.it_codigo=pcd.it_codigo
            and i.tipit_codigo=pcd.tipit_codigo
            join unidad_medida um on um.unime_codigo=i.unime_codigo 
         where pcd.pedco_codigo='$pedido' and i.it_estado = 'ACTIVO' 
            and i.it_descripcion ilike '%$descripcion%' 
         order by i.it_codigo;

select 
	ppc.prepro_codigo,
	pp.pedco_codigo,
	ppc.pro_codigo
from presupuesto_proveedor_cab ppc 
	join pedido_presupuesto pp on pp.prepro_codigo = ppc.prepro_codigo
where pp.pedco_codigo = pedcocodigo 
	and ppc.pro_codigo = procodigo 
	and ppc.prepro_codigo != preprocodigo;

perform 
	ppc.prepro_codigo,
	pp.pedco_codigo,
	ppc.pro_codigo 
from presupuesto_proveedor_cab ppc 
	join pedido_presupuesto pp on pp.presprov_cod = ppc.presprov_cod
	where current_date > presprovfechavenci or (pp.pedcom_cod = pedcomcod and ppc.pro_cod = procod and ppc.presprov_cod != presprovcod);

select 
         pcc.pedco_codigo, 
         'Pedido N°'||' '||pcc.pedco_codigo||' '||to_char(pcc.pedco_fecha, 'DD-MM-YYYY') as pedido 
      from pedido_compra_cab pcc 
         where cast(pcc.pedco_codigo as varchar) ilike '%$pedido%' and
      pedco_estado = 'PENDIENTE';
     
 select 
 	p.pro_codigo,
 	p.tipro_codigo,
 	p.pro_razonsocial,
 	p.pro_ruc,
 	tp.tipro_descripcion 
 from proveedor p 
 	 join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
	 where p.pro_ruc ilike '%%'
	 and p.pro_estado = 'ACTIVO' 
 order by p.pro_codigo;

select * from v_presupuesto_proveedor_det vppd where vppd.prepro_codigo = $presupuesto;

select sp_presupuesto_proveedor_cab(2, '2023-10-19', 'ACTIVO', '2023-10-22', 2, 2, 2, 1, 1, 1, 1, 'psal', 'alta', '80000000', 'SERVIPART', '8 de diciembre', 'casa matriz', 'mayorista');
select coalesce(max(prepro_codigo),0)+1 from presupuesto_proveedor_cab;

select
	1
from presupuesto_orden po 
	join presupuesto_proveedor_cab ppc on ppc.prepro_codigo=po.prepro_codigo 
	join orden_compra_cab occ on occ.orcom_codigo=po.orcom_codigo 
where po.prepro_codigo=2 and occ.orcom_estado <> 'ANULADO';

select 
	p.pro_codigo,
	p.tipro_codigo,
	p.pro_razonsocial,
	p.pro_ruc,
	tp.tipro_descripcion
from proveedor p 
join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
where p.pro_ruc = '80000000';

select 
                p.pro_codigo,
                tp.tipro_codigo,
                tp.tipro_descripcion
            from proveedor p
            join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
            where pro_ruc = '80000000'
            limit 1;

select tipit_codigo, it_descripcion from items where it_codigo=1;

create or replace function sp_presupuesto_proveedor_cab(
    preprocodigo integer,
    preprofechaactual date,
    preproestado varchar,
    preprofechavencimiento date,
    usucodigo integer,
    procodigo integer,
    tiprocodigo integer,
    succodigo integer,
    empcodigo integer,
    pedcocodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    proruc varchar,
    prorazonsocial varchar, 
    emprazonsocial varchar,
    sucdescripcion varchar,
    tiprodescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare ultCodPedidoPresupuesto integer;
declare preproAudit text;
begin 
	 -- Validamos la operacion de insercion 
     if operacion = 1 then
		 -- Guardamos el serial de pedido_presupuesto
	 	 ultCodPedidoPresupuesto = (select coalesce(max(pedpre_codigo),0)+1 from pedido_presupuesto);
		 -- Validamos si la fecha actual es mayor a la fecha de vencimiento
     	 if preprofechaactual > preprofechavencimiento then
			-- En caso de ser asi, generamos un excepcion
     	 	raise exception 'fecha';
     	 end if;
		 -- Validamos que no se repita el presupuesto de un pedido de compra por el mismo proveedor
		 perform 
			ppc.prepro_codigo,
			pp.pedco_codigo,
			ppc.pro_codigo
		from presupuesto_proveedor_cab ppc 
			join pedido_presupuesto pp on pp.prepro_codigo = ppc.prepro_codigo
		where pp.pedco_codigo = pedcocodigo 
			and ppc.pro_codigo = procodigo 
			and ppc.prepro_codigo != preprocodigo;
     	 if found then
			 -- En caso de ser asi, generamos un excepcion
     		 raise exception 'pedido';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro 
     	 elseif operacion = 1 then
		     insert into presupuesto_proveedor_cab(prepro_codigo, prepro_fechaactual, prepro_estado, prepro_fechavencimiento, usu_codigo,
		     pro_codigo, tipro_codigo, suc_codigo, emp_codigo)
			 values(preprocodigo, preprofechaactual, 'ACTIVO', preprofechavencimiento, usucodigo, procodigo, tiprocodigo,
			 succodigo, empcodigo);
			 -- Insertamos datos en tabla intermedia de relacion pedido_presupuesto
			 insert into pedido_presupuesto(pedco_codigo, prepro_codigo, pedpre_codigo)
			 values(pedcocodigo, preprocodigo, ultCodPedidoPresupuesto);
			 -- Cargamos la columna de auditoria de pedido presupuesto
			 update pedido_presupuesto 
			 set pedpre_audit = json_build_object(
				'usu_codigo', usucodigo,
				'usu_login', usulogin,
				'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
				'procedimiento', 'ALTA',
				'pedco_codigo', pedcocodigo,
				'prepro_codigo', preprocodigo
			 )
			 where pedpre_codigo = ultCodPedidoPresupuesto;
			 -- Se envia un mensaje de confirmacion
			 raise notice 'EL PRESUPUESTO DEL PROVEEDOR FUE REGISTRADO CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de anulacion
    if operacion = 2 then 
		-- Validamos si ya se encuentra asociado un presupuesto a una orden y tiene un estado distinto a anulado 
		perform 1 from presupuesto_orden po 
		join presupuesto_proveedor_cab ppc on ppc.prepro_codigo=po.prepro_codigo 
		join orden_compra_cab occ on occ.orcom_codigo=po.orcom_codigo 
		where po.prepro_codigo=preprocodigo and occ.orcom_estado <> 'ANULADO';
		if found then
			-- En caso de ser asi, generamos una excepcion
			raise exception 'asociado';		
		elseif operacion = 2 then
			update presupuesto_proveedor_cab 
			set prepro_estado='ANULADO', usu_codigo=usucodigo
			where prepro_codigo=preprocodigo;
			-- Se envia un mensaje de confirmacion
			raise notice 'EL PRESUPUESTO DEL PROVEEDOR FUE ANULADO CON EXITO';
		end if;
    end if;
	-- Consultamos el audit anterior
	select coalesce(prepro_audit, '') into preproAudit from presupuesto_proveedor_cab where prepro_codigo = preprocodigo;
	-- A los datos anteriores le agregamos los nuevos
	update presupuesto_proveedor_cab 
	set prepro_audit = preproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'prepro_fechaactual', preprofechaactual,
		'prepro_fechavencimiento', preprofechavencimiento,
		'pro_codigo', procodigo,
		'pro_ruc', upper(proruc),
		'pro_razonsocial', upper(prorazonsocial),
		'tipro_codigo', tiprocodigo,
		'tipro_descripcion', upper(tiprodescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'prepro_estado', upper(preproestado)
	)||','
	where prepro_codigo = preprocodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacendado presupuesto proveedor detalle
create or replace function sp_presupuesto_proveedor_det(
    preprocodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    peprodetcantidad numeric,
    peprodetprecio numeric,
    operacion integer --1:insert 2:delete
) returns void as
$function$
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		-- Validamos que no se repota el ítem en el detalle
     	perform * from presupuesto_proveedor_det
     	where it_codigo=itcodigo and prepro_codigo=preprocodigo;
     	if found then
			 -- Si es asi, generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
		     insert into presupuesto_proveedor_det(prepro_codigo, it_codigo, tipit_codigo, peprodet_cantidad, peprodet_precio)
			 values(preprocodigo, itcodigo, tipitcodigo, peprodetcantidad, peprodetprecio);
			 raise notice 'EL PRESUPUESTO PROVEEDOR DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de eliminación
    if operacion = 2 then 
    	delete from presupuesto_proveedor_det	 
    	where prepro_codigo=preprocodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'EL PRESUPUESTO PROVEEDOR DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado orden compra cabecera 
select * from v_orden_compra_cab vocc where vocc.orcom_estado <> 'ANULADO';
select * from v_orden_compra_det vocd where vocd.orcom_codigo = $orden;
select 
            i.it_codigo,
            i.tipit_codigo,
            i.it_descripcion,
            um.unime_codigo,
            um.unime_descripcion,
            ppd.peprodet_cantidad as orcomdet_cantidad,
            ppd.peprodet_precio as orcomdet_precio
      from presupuesto_proveedor_det ppd 
            join items i on i.it_codigo=ppd.it_codigo 
            and i.tipit_codigo=ppd.tipit_codigo
            join unidad_medida um on um.unime_codigo=i.unime_codigo 
            where ppd.prepro_codigo=$presupuesto and i.it_estado='ACTIVO'
            and i.it_descripcion ilike '%$descripcion%'
      order by ppd.prepro_codigo;
select sp_orden_compra_cab(2, '17-10-2024', 'CONTADO', 1, 'S/I', 100000, 'ACTIVO', 2, 2, 2, 1, 1, 2, 2, 1, 'psal', 
'alta', 'servipart', 'mayorista', '8 de diciembre', 'casa matriz');
select coalesce(max(orcom_codigo),0)+1 as orcom_codigo from orden_compra_cab;

select 
  ppd.it_codigo,
  ppd.tipit_codigo,
  ppd.peprodet_cantidad as cantidad,
  ppd.peprodet_precio as precio
from presupuesto_proveedor_det ppd 
where ppd.prepro_codigo=2;

select 
	1
from orden_compra oc 
	join orden_compra_cab occ on occ.orcom_codigo=oc.orcom_codigo
	join compra_cab cc on cc.comp_codigo=oc.comp_codigo 
where oc.orcom_codigo=2 and cc.comp_estado <> 'ANULADO';

create or replace function sp_orden_compra_cab(
    orcomcodigo integer,
    orcomfecha date,
    orcomcondicionpago condicion_pago,
    orcomcuota integer,
    orcominterfecha varchar,  
    orcommontocuota numeric,
    orcomestado varchar,
    usucodigo integer,
    procodigo integer,
    tiprocodigo integer, 
    succodigo integer,
    empcodigo integer,
    preprocodigo integer,
    pedcocodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    prorazonsocial varchar,
    tiprodescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare 
	ultCodPresupuestoOrden integer;
	orcomAudit text;
	preproAudit text;
	pedcoAudit text;
	c_presupuesto_det cursor is
		select 
  		ppd.it_codigo,
  		ppd.tipit_codigo,
  		ppd.peprodet_cantidad as cantidad,
  		ppd.peprodet_precio as precio
		from presupuesto_proveedor_det ppd 
		where ppd.prepro_codigo=preprocodigo;
	c_presupuesto cursor is
		select 
		ppc.prepro_fechaactual,
		ppc.prepro_estado,
		ppc.prepro_fechavencimiento,
		ppc.pro_codigo,
		p.pro_ruc,
		p.pro_razonsocial,
		ppc.tipro_codigo,
		tp.tipro_descripcion 
		from presupuesto_proveedor_cab ppc
		join proveedor p on p.pro_codigo=ppc.pro_codigo 
		and p.tipro_codigo=ppc.tipro_codigo 
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
		where ppc.prepro_codigo=preprocodigo;
	c_pedido cursor is
		select 
		pcc.pedco_estado
		from pedido_compra_cab pcc
		where pcc.pedco_codigo=pedcocodigo;	
begin 
	 -- Validamos la operacion de insercion 
     if operacion = 1 then
		 -- Guardamos el serial de presupuesto_orden
		 ultCodPresupuestoOrden = (select coalesce(max(presor_codigo),0)+1 from presupuesto_orden);
		 -- Se inserta datos en orden compra cabecera
	     insert into orden_compra_cab(orcom_codigo, orcom_fecha, orcom_condicionpago, orcom_cuota, orcom_interfecha,
	     orcom_estado, usu_codigo, pro_codigo, tipro_codigo, suc_codigo, emp_codigo, orcom_montocuota)
		 values(orcomcodigo, orcomfecha, orcomcondicionpago, orcomcuota, orcominterfecha, 'ACTIVO', usucodigo, procodigo, tiprocodigo,
		 succodigo, empcodigo, orcommontocuota);
		 -- Se inserta datos en presupuesto orden
		 insert into presupuesto_orden(orcom_codigo, prepro_codigo, presor_codigo)
		 values(orcomcodigo, preprocodigo, ultCodPresupuestoOrden);
		 --Actualizamos el estado del presupuesto proveedor cabecera seleccionado
		 update presupuesto_proveedor_cab set prepro_estado='APROBADO', usu_codigo=usucodigo where prepro_codigo=preprocodigo;
		 --Actualizamos el estado del pedido compra cabecera que se haya ordenado
		 update pedido_compra_cab set pedco_estado='APROBADO', usu_codigo=usucodigo where pedco_codigo=pedcocodigo;
		 -- Auditamos movimiento de presupuesto_orden
		 update presupuesto_orden 
			 set presor_audit = json_build_object(
				'usu_codigo', usucodigo,
				'usu_login', usulogin,
				'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
				'procedimiento', 'ALTA',
				'orcom_codigo', orcomcodigo,
				'prepro_codigo', preprocodigo
			 )
			 where presor_codigo = ultCodPresupuestoOrden;
		 -- Insertamos datos de detalle de orden compra 
		 for predet in c_presupuesto_det loop
			-- Recorremos el detalle de presupuesto de forma indivdualizada y cargamos el detalle de orden compra en cada recorrido
			perform sp_orden_compra_det(orcomcodigo, predet.it_codigo, predet.tipit_codigo, predet.cantidad, predet.precio, 1, 0, orcomcuota, usucodigo);
		 end loop;
		 -- Se envia un mensaje de confirmacion
		 raise notice 'LA ORDEN DE COMPRA FUE REGISTRADA CON EXITO';
    end if;
	-- Validamos la operacion de anulacion
    if operacion = 2 then 
	    -- Validamos si ya se encuentra asociado la orden de compra a una compra y si la compra tiene un estado distinto a anulado 
		perform 1 from orden_compra oc 
		join orden_compra_cab occ on occ.orcom_codigo=oc.orcom_codigo
		join compra_cab cc on cc.comp_codigo=oc.comp_codigo 
		where oc.orcom_codigo=orcomcodigo and cc.comp_estado <> 'ANULADO';
		if found then
			-- En caso de ser asi, generamos una excepcion
			raise exception 'asociado';		
		elseif operacion = 2 then
			--Anulamos la orden de compra cabecera
    		update orden_compra_cab 
			set orcom_estado='ANULADO', usu_codigo=usucodigo
			where orcom_codigo=orcomcodigo;
			--Activamos de nuevo el presupesto 
			update presupuesto_proveedor_cab set prepro_estado='ACTIVO', usu_codigo=usucodigo where prepro_codigo=preprocodigo;
			--Activamos el pedido de compra asociado al presupuesto
			update pedido_compra_cab set pedco_estado='ACTIVO', usu_codigo=usucodigo where pedco_codigo=pedcocodigo;
			-- Se envia un mensaje de confirmacion
			raise notice 'LA ORDEN DE COMPRA FUE ANULADA CON EXITO';
		end if;
    end if;
	-- Consultamos el audit anterior
	select coalesce(orcom_audit, '') into orcomAudit from orden_compra_cab where orcom_codigo = orcomcodigo;
	-- A los datos anteriores le agregamos los nuevos
	update orden_compra_cab 
	set orcom_audit = orcomAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'orcom_fecha', orcomfecha,
		'orcom_condicionpago', orcomcondicionpago,
		'orcom_cuota', orcomcuota,
		'orcom_montocuota', orcommontocuota,
		'orcom_interfecha', upper(orcominterfecha),
		'pro_codigo', procodigo,
		'pro_razonsocial', upper(prorazonsocial),
		'tipro_codigo', tiprocodigo,
		'tipro_descripcion', upper(tiprodescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'orcom_estado', upper(orcomestado)
	)||','
	where orcom_codigo = orcomcodigo;
	--consultamos el audit anterior de presupuesto proveedor cabecera
	select coalesce(prepro_audit, '') into preproAudit from presupuesto_proveedor_cab where prepro_codigo = preprocodigo;
	--recorremos la fila modificada de presupuesto proveedor
	for pre in c_presupuesto loop
		update presupuesto_proveedor_cab
		set prepro_audit = preproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'prepro_fechaactual', pre.prepro_fechaactual,
		'prepro_fechavencimiento', pre.prepro_fechavencimiento,
		'pro_codigo', pre.pro_codigo,
		'pro_ruc', pre.pro_ruc,
		'pro_razonsocial', pre.pro_razonsocial,
		'tipro_codigo', pre.tipro_codigo,
		'tipro_descripcion', pre.tipro_descripcion,
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'prepro_estado', pre.prepro_estado
	)||','
	where prepro_codigo = preprocodigo;
	end loop;
	--consultamos el audit anterior de pedido compra cabecera
	select coalesce(pedco_audit, '') into pedcoAudit from pedido_compra_cab where pedco_codigo = pedcocodigo;
	--recorremos la fila modificada de pedido compra
	for ped in c_pedido loop
		update pedido_compra_cab 
		set pedco_audit = pedcoAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'pedco_estado', ped.pedco_estado
		)||','
		where pedco_codigo = pedcocodigo;
	end loop;
end
$function$ 
language plpgsql;

select 
	pcc.pedco_estado
from pedido_compra_cab pcc
where pcc.pedco_codigo=1;

select 
 (sum(case 
 	when vppd.tipit_codigo = 3 then
 		vppd.peprodet_precio
 	else
 		vppd.peprodet_cantidad*vppd.peprodet_precio
 end))/1 as division
from v_presupuesto_proveedor_det vppd 
where vppd.prepro_codigo=2;

select 
	ppc.prepro_fechaactual,
	ppc.prepro_estado,
	ppc.prepro_fechavencimiento,
	ppc.pro_codigo,
	p.pro_ruc,
	p.pro_razonsocial,
	ppc.tipro_codigo,
	tp.tipro_descripcion 
from presupuesto_proveedor_cab ppc
	join proveedor p on p.pro_codigo=ppc.pro_codigo 
	and p.tipro_codigo=ppc.tipro_codigo 
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
where ppc.prepro_codigo=1;
	
where ppc.prepro_codigo=1;


select sum(case ocd.tipit_codigo when 3 then ocd.orcomdet_precio else ocd.orcomdet_cantidad*ocd.orcomdet_precio end) as suma_detalle 
from orden_compra_det ocd where ocd.orcom_codigo = 1;

select 10000/2 as monto_cuota;
--Procedimiento almacenado orden compra detalle
create or replace function sp_orden_compra_det(
    orcomcodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    orcomdetcantidad numeric,
    orcomdetprecio numeric,
    operacion integer,
    cabecera_detalle integer,-- 0 cabecera - 1 detalle
    orcomcuota integer,
    usucodigo integer
) returns void as
$function$
-- Definimos las variables a utilizar
declare suma_detalle numeric;
		monto_cuota numeric;
		orcomAudit text;
		c_orden cursor is
		select 
		occ.usu_codigo,
		u.usu_login,
		occ.orcom_fecha,
		occ.orcom_condicionpago,
		occ.orcom_cuota,
		occ.orcom_montocuota,
		occ.orcom_interfecha,
		occ.pro_codigo,
		p.pro_razonsocial,
		occ.tipro_codigo,
		tp.tipro_descripcion,
		occ.emp_codigo,
		e.emp_razonsocial,
		occ.suc_codigo,
		s.suc_descripcion,
		occ.orcom_estado 
		from orden_compra_cab occ 
		join usuario u on u.usu_codigo=occ.usu_codigo
		join proveedor p on p.pro_codigo=occ.pro_codigo
		and p.tipro_codigo=occ.tipro_codigo 
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
		join sucursal s on s.suc_codigo=occ.suc_codigo 
		and s.emp_codigo=occ.emp_codigo 
		join empresa e on e.emp_codigo=s.emp_codigo 
		where occ.orcom_codigo=orcomcodigo;
begin 
	 -- Validamos la operacion de insercion
     if (operacion = 1 and cabecera_detalle = 0) or (operacion = 1 and cabecera_detalle = 1) then
		-- Validamos que no se repita el ítem en el detalle
     	perform * from orden_compra_det
     	where it_codigo=itcodigo and orcom_codigo=orcomcodigo;
     	if found then
			 -- Si es asi, generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
			 -- Si los parametros pasan la validación, procedemos con la insercion
		     insert into orden_compra_det(orcom_codigo, it_codigo, tipit_codigo, orcomdet_cantidad, orcomdet_precio)
			 values(orcomcodigo, itcodigo, tipitcodigo, orcomdetcantidad, orcomdetprecio);
			 -- Se envia un mensaje de confirmacion
			 raise notice 'LA ORDEN COMPRA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de eliminación
    if (operacion = 2 and cabecera_detalle = 0) or (operacion = 2 and cabecera_detalle = 1) then 
		-- Procedemos con la eliminacion
    	delete from orden_compra_det	 
    	where orcom_codigo=orcomcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'LA ORDEN COMPRA DETALLE FUE ELIMINADA CON EXITO';
    end if;
	-- Validamos que cuando se inserte o elimine en detalle, se actualice el monto cuota de cabecera
	if (operacion = 1 and cabecera_detalle = 1) or (operacion = 2 and cabecera_detalle = 1) then
		-- Realizamos la sumatoria y guardamos en una variable
		select coalesce(sum(case ocd.tipit_codigo when 3 then ocd.orcomdet_precio else ocd.orcomdet_cantidad*ocd.orcomdet_precio end),0) into suma_detalle 
		from orden_compra_det ocd where ocd.orcom_codigo = orcomcodigo;
		-- Calculamos el nuevo monto de orcom_montocuota
		select round(suma_detalle/orcomcuota) into monto_cuota;
		-- Definimos el nuevo orcom_montocuota
		update orden_compra_cab set orcom_montocuota=monto_cuota, usu_codigo=usucodigo where orcom_codigo=orcomcodigo;
		-- Una vez actualizado la cabecera, la auditamos
		-- Consultamos el audit anterior
		select coalesce(orcom_audit, '') into orcomAudit from orden_compra_cab where orcom_codigo = orcomcodigo;
		-- A los datos anteriores le agregamos los nuevos
		for orden in c_orden loop
	       	 	update orden_compra_cab 
				set orcom_audit = orcomAudit||''||json_build_object(
				'usu_codigo', orden.usu_codigo,
				'usu_login', orden.usu_login,
				'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
				'procedimiento', 'MODIFICACION',
				'orcom_fecha', orden.orcom_fecha,
				'orcom_condicionpago', orden.orcom_condicionpago,
				'orcom_cuota', orden.orcom_cuota,
				'orcom_montocuota', orden.orcom_montocuota,
				'orcom_interfecha', upper(orden.orcom_interfecha),
				'pro_codigo', orden.pro_codigo,
				'pro_razonsocial', upper(orden.pro_razonsocial),
				'tipro_codigo', orden.tipro_codigo,
				'tipro_descripcion', upper(orden.tipro_descripcion),
				'emp_codigo', orden.emp_codigo,
				'emp_razonsocial', upper(orden.emp_razonsocial),
				'suc_codigo', orden.suc_codigo,
				'suc_descripcion', upper(orden.suc_descripcion),
				'orcom_estado', upper(orden.orcom_estado)
				)||','
				where orcom_codigo = orcomcodigo;
        end loop;
	end if;
end
$function$ 
language plpgsql;

--gugugu
select 
	occ.usu_codigo,
	u.usu_login,
	occ.orcom_fecha,
	occ.orcom_condicionpago,
	occ.orcom_cuota,
	occ.orcom_montocuota,
	occ.orcom_interfecha,
	occ.pro_codigo,
	p.pro_razonsocial,
	occ.tipro_codigo,
	tp.tipro_descripcion,
	occ.emp_codigo,
	e.emp_razonsocial,
	occ.suc_codigo,
	s.suc_descripcion,
	occ.orcom_estado 
from orden_compra_cab occ 
	join usuario u on u.usu_codigo=occ.usu_codigo
	join proveedor p on p.pro_codigo=occ.pro_codigo
	and p.tipro_codigo=occ.tipro_codigo 
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
	join sucursal s on s.suc_codigo=occ.suc_codigo 
	and s.emp_codigo=occ.emp_codigo 
	join empresa e on e.emp_codigo=s.emp_codigo 
where occ.orcom_codigo=1;

select sp_ajuste_inventario_cab(1, '22/10/2023', 'NEGATIVO', 'ACTIVO', 1, 1, 2, 2);

--Procedimiento almacenado ajuste inventario cabecera
select sp_ajuste_inventario_cab(2, '25-10-2024', 'NEGATIVO', 'ACTIVO', 1, 1, 2, 1, 'psal', 'ALTA', '8 de diciembre', 'casa matriz');
select coalesce(max(ajuin_codigo),0)+1 as ajuin_codigo from ajuste_inventario_cab;
create or replace function sp_ajuste_stock_cab(
    ajuscodigo integer,
    ajusfecha date,
    ajustipoajuste tipo_ajuste,
    ajusestado varchar,
    succodigo integer,
    empcodigo integer,
    usucodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
-- Definimos las variables a utilizar
declare ajusteDet record;
		cantidadStockAuditoria numeric;
		ajusAudit text;
begin
	-- Validamos la operacion de insercion
    if operacion = 1 then
		 -- Insertamos un nuevo registro
	     insert into ajuste_stock_cab(ajus_codigo, ajus_fecha, ajus_tipoajuste, ajus_estado, suc_codigo, emp_codigo, usu_codigo)
		 values(ajuscodigo, ajusfecha, ajustipoajuste, 'ACTIVO', succodigo, empcodigo, usucodigo);
		 -- Enviamos un mensaje de confirmacion
		 raise notice 'EL AJUSTE DE STOCK FUE REGISTRADO CON EXITO';
    end if;
	-- Validamos la operacion de anulacion
    if operacion = 2 then 
		-- Actualizamos el estado de cabecera a Anulado
    	update ajuste_stock_cab 
		set ajus_estado='ANULADO', usu_codigo=usucodigo
		where ajus_codigo=ajuscodigo;
		--Actualizamos el stock en caso de anular la cabecera
	    if ajustipoajuste='POSITIVO' then
			-- Si es positivo restamos
	    	for ajusteDet in select * from ajuste_stock_det where ajus_codigo=ajuscodigo loop
	       	 	update stock set st_cantidad=st_cantidad-ajusteDet.ajusdet_cantidad 
				where it_codigo=ajusteDet.it_codigo and tipit_codigo=ajusteDet.tipit_codigo and dep_codigo=ajusteDet.dep_codigo
				and suc_codigo=ajusteDet.suc_codigo and emp_codigo=ajusteDet.emp_codigo;
				-- Auditamos nueva cantidad de stock
				select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=ajusteDet.it_codigo and s.tipit_codigo=ajusteDet.tipit_codigo
				and s.dep_codigo=ajusteDet.dep_codigo and s.suc_codigo=ajusteDet.suc_codigo and s.emp_codigo=ajusteDet.emp_codigo;
				-- Procedemos con el audit del registro modificado
				perform sp_stock(ajusteDet.it_codigo, ajusteDet.tipit_codigo, ajusteDet.dep_codigo, ajusteDet.suc_codigo, 
				ajusteDet.emp_codigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
        	end loop;
        elseif ajustipoajuste='NEGATIVO' then
			-- Si es negativo sumamos
        	for ajusteDet in select * from ajuste_inventario_det where ajuin_codigo=ajuincodigo loop
	       	 	update stock set st_cantidad=st_cantidad+ajusteDet.ajusdet_cantidad 
				where it_codigo=ajusteDet.it_codigo and tipit_codigo=ajusteDet.tipit_codigo and dep_codigo=ajusteDet.dep_codigo
				and suc_codigo=ajusteDet.suc_codigo and emp_codigo=ajusteDet.emp_codigo;
				-- Auditamos nueva cantidad de stock
				select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=ajusteDet.it_codigo and s.tipit_codigo=ajusteDet.tipit_codigo
				and s.dep_codigo=ajusteDet.dep_codigo and s.suc_codigo=ajusteDet.suc_codigo and s.emp_codigo=ajusteDet.emp_codigo;
				-- Procedemos con el audit del registro modificado
				perform sp_stock(ajusteDet.it_codigo, ajusteDet.tipit_codigo, ajusteDet.dep_codigo, ajusteDet.suc_codigo, 
				ajusteDet.emp_codigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
        	end loop;
	    end if;
		-- Enviamos un mensaje de confirmacion
		raise notice 'EL AJUSTE DE STOCK FUE ANULADO CON EXITO';
    end if;
	--AJUSTE STOCK CABECERA AUDITORIA
	-- Consultamos el audit anterior de ajuste inventario cabecera
	select coalesce(aju.ajus_audit, '') into ajusAudit from ajuste_stock_cab aju where aju.ajus_codigo=ajuscodigo;
	-- A los datos anteriores le agregamos los nuevos
	update ajuste_stock_cab
	set ajus_audit = ajusAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'ajus_fecha', ajusfecha,
		'ajus_tipoajuste', ajustipoajuste,
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'ajus_estado', upper(ajusestado)
	)||','
	where ajus_codigo = ajuscodigo;
end
$function$ 
language plpgsql;

select 
         s.it_codigo,
         s.tipit_codigo,
         (case 
	         s.tipit_codigo 
         when 1 
         then 
         	i.it_descripcion 
         else 
         	i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion 
         end) as it_descripcion,
         (case 
	         s.tipit_codigo 
         when 1 
         then 
         	i.it_costo
         else 
         	i.it_precio 
         end) as ajuindet_precio,
         um.unime_codigo,
         um.unime_descripcion 
      from stock s 
         join items i on i.it_codigo=s.it_codigo
         and i.tipit_codigo=s.tipit_codigo
         join unidad_medida um on um.unime_codigo=i.unime_codigo
         join modelo m on m.mod_codigo=i.mod_codigo
         join talle t on t.tall_codigo=i.tall_codigo
         where s.dep_codigo=$deposito 
         and s.suc_codigo=$sucursal 
         and s.emp_codigo=$empresa 
         and i.it_descripcion ilike '%$descripcion%'
         and (i.tipit_codigo = 1 or i.tipit_codigo = 2)
         and i.it_estado='ACTIVO'
      order by s.it_codigo;

select sp_ajuste_inventario_det(2, 1, 1, 1, 1, 1, 1, 'actualizacion', 'NEGATIVO', 5000, 2);
--Procedimiento almacenado ajuste inventario detalle
create or replace function sp_ajuste_stock_det(
    ajuscodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    ajusdetcantidad numeric,
    ajusdetprecio numeric,
    ajusdetmotivo varchar,
    ajustipoajuste varchar,
    usucodigo integer,
    usulogin varchar,
    operacion integer 
) returns void as
$function$
declare cantidadStockAuditoria numeric;
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		-- Validamos que no se repita el item y deposito en un mismo detalle de ajuste
     	perform * from ajuste_stock_det
     	where it_codigo=itcodigo and dep_codigo=depcodigo and ajus_codigo=ajuscodigo;
     	if found then
			 -- En caso de ser asi, generamos una excepcion
     		 raise exception 'item';
		-- Si los parametros superan la validacion se procede con la persistencia
     	elseif operacion = 1 then
     	 	 --Insertamos detalle de ajuste
		     insert into ajuste_stock_det(ajus_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo,
		     emp_codigo, ajusdet_cantidad, ajusdet_precio, ajusdet_motivo)
			 values(ajuscodigo, itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, ajusdetcantidad, ajusdetprecio, upper(ajusdetmotivo));
			 --Actualizamos el stock en caso de que sea positivo o negativo
			 if ajustipoajuste='POSITIVO' then
				-- Si es positivo sumamos
			 	update stock set st_cantidad=st_cantidad+ajusdetcantidad 
			 	where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			 	and suc_codigo=succodigo and emp_codigo=empcodigo;
				-- Auditamos nueva cantidad de stock
				select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
				and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
				-- Procedemos con el audit del registro modificado
				perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
			 elseif ajuintipoajuste='NEGATIVO' then
				-- Si es negativo restamos
			 	update stock set st_cantidad=st_cantidad-ajusdetcantidad 
			 	where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			 	and suc_codigo=succodigo and emp_codigo=empcodigo;
				-- Auditamos nueva cantidad de stock
				select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
				and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
				-- Procedemos con el audit del registro modificado
				perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
			 end if;
			 -- Se envia mensaje de confirmacion
			 raise notice 'EL AJUSTE STOCK DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de eliminacion
    if operacion = 2 then 
    	--Eliminamos el item y devolvemos la cantidad
    	delete from ajuste_stock_det 
    	where ajus_codigo=ajuscodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
        and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
       	--Actualizamos el stock en caso de eliminar un registro
        if ajustipoajuste='POSITIVO' then
			-- Si es positivo restamos
			 update stock set st_cantidad=st_cantidad-ajusdetcantidad 
			 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			 and suc_codigo=succodigo and emp_codigo=empcodigo;
			-- Auditamos nueva cantidad de stock
			select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
			and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			-- Procedemos con el audit del registro modificado
			perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
        elseif ajustipoajuste='NEGATIVO' then
			-- Si es negativo sumamos
        	update stock set st_cantidad=st_cantidad+ajusdetcantidad 
			 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			 and suc_codigo=succodigo and emp_codigo=empcodigo;
			-- Auditamos nueva cantidad de stock
			select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
			and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			-- Procedemos con el audit del registro modificado
			perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
	    end if;
		-- Se envia mensaje de confirmacion
		raise notice 'EL AJUSTE STOCK DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado pedido venta cabecera
select sp_pedido_venta_cab(1, '2023-10-22', 'VENDIDO', 1, 1, 2, 3, 3, 'afra', 'ALTA', '5555666', 'ALAM FRANCO DIAZ', 
'8 de Diciembre', 'casa matriz');
select coalesce(max(peven_codigo),0)+1 from pedido_venta_cab;
create or replace function sp_pedido_venta_cab(
    pevencodigo integer,
    pevenfecha date,
    pevenestado varchar,
    succodigo integer,
    empcodigo integer,
    clicodigo integer,
    usucodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    pernumerodocumento varchar,
    cliente varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
--Declaramos las variables a utilizar
declare pevenAudit text;
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
	     insert into pedido_venta_cab(peven_codigo, peven_fecha, peven_estado, suc_codigo, emp_codigo, cli_codigo, usu_codigo)
		 values(pevencodigo, pevenfecha, 'PENDIENTE', succodigo, empcodigo, clicodigo, usucodigo);
		 raise notice 'EL PEDIDO DE VENTA FUE REGISTRADO CON EXITO';
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--En esta parte se hace solo un borrado logico
    	update pedido_venta_cab 
		set peven_estado='ANULADO', usu_codigo=usucodigo
		where peven_codigo=pevencodigo;
		raise notice 'EL PEDIDO DE VENTA FUE ANULADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(peven_audit, '') into pevenAudit from pedido_venta_cab where peven_codigo=pevencodigo;
	--a los datos anteriores le agregamos los nuevos
	update pedido_venta_cab 
	set peven_audit = pevenAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'peven_fecha', pevenfecha,
		'cli_codigo', clicodigo,
		'cliente', upper(cliente),
		'per_numerodocumento', pernumerodocumento,
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'peven_estado', upper(pevenestado)
	)||','
	where peven_codigo = pevencodigo;
end
$function$ 
language plpgsql;

---Procedimiento almacenado pedido venta detalle
create or replace function sp_pedido_venta_det(
    pevencodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    pevendetcantidad numeric,
    pevendetprecio numeric,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si existe el item en caso de que si generamos una excepcion
     	perform * from pedido_venta_det
     	where it_codigo=itcodigo and peven_codigo=pevencodigo;
     	if found then
     		 raise exception 'item';
		--Si no existe el item insertamos el mismo en el detalle
     	elseif operacion = 1 then
		     insert into pedido_venta_det(peven_codigo, it_codigo, tipit_codigo, pevendet_cantidad, pevendet_precio)
			 values(pevencodigo, itcodigo, tipitcodigo, pevendetcantidad, pevendetprecio);
			 raise notice 'EL PEDIDO DE VENTA DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from pedido_venta_det 
    	where peven_codigo=pevencodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'EL PEDIDO DE VENTA DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

select sp_compra_cab(1, '2023-10-25', '15000000', '18976532', 'CONTADO', 1, 11000, 'S/I', 'ACTIVO', 1, 1, 1, 1, 2, 1, 4, 1, 
'psal', 'ALTA', 'FACTURA', 'EL hilero', 'Minorista', '8 de diciembre', 'casa matriz');

SELECT table_name 
FROM information_schema.tables 
WHERE table_schema NOT IN ('pg_catalog', 'information_schema') 
AND table_type = 'BASE TABLE';

select 1 from nota_compra_cab ncc 
where ncc.comp_codigo=1 and ncc.nocom_estado <> 'ANULADO';

select (case when p.pro_timbrado <> '189765322' and p.pro_timbrado_venc <> '2026-01-02' then 1 else 0 end) as true_or_false from proveedor p where p.pro_codigo=1;

select 
p.pro_razonsocial,
p.tipro_codigo,
tp.tipro_descripcion,
p.pro_ruc,
p.pro_timbrado,
p.pro_timbrado_venc,
p.pro_direccion,
p.pro_telefono,
p.pro_email,
p.pro_estado
from proveedor p 
join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
where p.pro_codigo=1;

select coalesce(max(comp_codigo),0)+1 as comp_codigo from compra_cab;

-- Procedimiento almacenado para alta y auditoria de stock
create or replace function sp_stock(
    itcodigo integer,
    tipitcodigo integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    stcantidad numeric,
    operacion integer,
    usucodigo integer,
    usulogin varchar
) returns void as
$function$
-- Definimos las variables a utilizar
declare stAudit text;
		procedimiento varchar;
begin 
	-- Valiados la operacion de insercion
    if operacion = 1 then
		-- Validamos que no se repita el item y deposito
        perform * from stock
        where it_codigo = itcodigo and tipit_codigo = tipitcodigo
        and dep_codigo=depcodigo and suc_codigo=succodigo
        and emp_codigo=empcodigo;
        if found then
			-- En caso de ser asi, generamos una excepcion
            raise exception 'item_stock';
    	elseif operacion = 1 then
				-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro 
	        	insert into stock(it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo, st_cantidad)
				values(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, stcantidad);
				-- Establecemos el valor del procedimiento
				procedimiento := 'ALTA';
				-- Se envia un mensaje de confirmacion
				raise notice 'EL ITEM FUE REGISTRADO EN STOCK CON EXITO';
        end if;
    end if;
	-- Validamos que la operacion sea de modificacion
    if operacion = 2 then 
		-- Establecemos el valor del procedimiento
    	procedimiento := 'MODIFICACION';
    end if;
	-- Consultamos el audit anterior
	select coalesce(st_audit, '') into stAudit from stock where it_codigo = itcodigo and dep_codigo = depcodigo;
	-- Alos datos anteriores le agragamos los nuevos
	update stock 
	set st_audit = stAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'it_codigo', itcodigo,
		'tipit_codigo', tipitcodigo,
		'dep_codigo', depcodigo,
		'suc_codigo', succodigo,
		'emp_codigo', empcodigo,
		'st_cantidad', stcantidad
	)||','
	where it_codigo = itcodigo and dep_codigo = depcodigo;
end
$function$ 
language plpgsql;

select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo= 1 and s.dep_codigo=1;

--Procedimiento almacenado compra cabecera 
create or replace function sp_compra_cab(
    compcodigo integer,
    compfecha date,
    compnumfactura varchar,
    comptimbrado varchar,
    comptipofactura tipo_factura,
    compcuota integer,
    compmontocuota numeric,
    compinterfecha varchar,
    compestado varchar,
    procodigo integer,
    tiprocodigo integer,
    succodigo integer,
    empcodigo integer,
    usucodigo integer,
    orcomcodigo integer,
    tipcocodigo integer,
    comptimbradovenc date,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    tipcodescripcion varchar,
    prorazonsocial varchar,
    tiprodescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
-- Definimos las variables
declare compraDet record;
		ultCodOrdenCompra integer;
		ultCodLibroCompra integer;
		compAudit text;
		orcomAudit text;
		licomAudit text;
		cuenpaAudit text;
		proAudit text;
		modificacionTimbrado integer;
		cantidadStockAuditoria numeric;
		c_orden cursor is
		select 
		occ.orcom_fecha,
		occ.orcom_condicionpago,
		occ.orcom_cuota,
		occ.orcom_montocuota,
		occ.orcom_interfecha,
		occ.orcom_estado,
		occ.pro_codigo,
		p.pro_razonsocial,
		occ.tipro_codigo,
		tp.tipro_descripcion
		from orden_compra_cab occ
		join usuario u on u.usu_codigo=occ.usu_codigo
		join proveedor p on p.pro_codigo=occ.pro_codigo
		and p.tipro_codigo=occ.tipro_codigo
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
		where occ.orcom_codigo=orcomcodigo;
		c_libro cursor is
		select 
		lc.comp_codigo,
		lc.licom_exenta,
		lc.licom_iva5,
		lc.licom_iva10,
		lc.licom_fecha,
		lc.tipco_codigo,
		lc.licom_numcomprobante,
		lc.licom_estado
		from libro_compra lc
		where lc.comp_codigo=compcodigo;
		c_cuenta cursor is
		select
		cp.cuenpa_nrocuota,
		cp.cuenpa_monto,
		cp.cuenpa_saldo,
		cp.cuenpa_estado
		from cuenta_pagar cp
		where cp.comp_codigo=compcodigo;
		c_proveedor cursor is
		select 
		p.pro_razonsocial,
		p.tipro_codigo,
		tp.tipro_descripcion,
		p.pro_ruc,
		p.pro_timbrado,
		p.pro_timbrado_venc,
		p.pro_direccion,
		p.pro_telefono,
		p.pro_email,
		p.pro_estado
		from proveedor p 
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
		where p.pro_codigo=procodigo;
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		ultCodOrdenCompra = (select coalesce(max(ordencom_codigo),0)+1 from orden_compra);
		ultCodLibroCompra = (select coalesce(max(licom_codigo),0)+1 from libro_compra);
		-- Validamos que no se repita el numero de factura, timbrado y estado activo
     	perform * from compra_cab
     	where comp_numfactura=compnumfactura and comp_timbrado=comptimbrado and comp_estado='ACTIVO';
     	if found then
     		 raise exception 'factura';
		-- Si los paramtros pasan la validacion procedemos con su insercion
     	elseif operacion = 1 then
		     insert into compra_cab(
			 comp_codigo, 
			 comp_fecha, 
			 comp_numfactura, 
			 comp_tipofactura, 
			 comp_cuota, 
			 comp_interfecha,
		     comp_estado, 
			 pro_codigo, 
      	     tipro_codigo, 
     		 suc_codigo, 
			 emp_codigo, 
			 usu_codigo, 	
			 comp_montocuota, 
			 comp_timbrado, 
			 tipco_codigo,
			 comp_timbrado_venc
			 )
			 values(
			 compcodigo, 
			 compfecha, 
			 compnumfactura, 
			 comptipofactura, 
			 compcuota, 
			 upper(compinterfecha), 
			 'ACTIVO', 
			 procodigo, 
			 tiprocodigo,
			 succodigo, 
			 empcodigo, 
			 usucodigo, 
			 compmontocuota, 
			 comptimbrado,  
			 tipcocodigo,
			 comptimbradovenc
			 );
			 -- Insertamos datos en orden compra
			 insert into orden_compra(comp_codigo, orcom_codigo, ordencom_codigo)
		 	 values(compcodigo, orcomcodigo, ultCodOrdenCompra);
			 -- Auditamos orden compra
			 update orden_compra 
			 set ordencom_audit = json_build_object(
				'usu_codigo', usucodigo,
				'usu_login', usulogin,
				'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
				'procedimiento', 'ALTA',
				'comp_codigo', compcodigo,
				'orcom_codigo', orcomcodigo
			 )
			 where ordencom_codigo = ultCodOrdenCompra;
		 	 -- Insertamos datos en libro compra
		 	 insert into libro_compra(licom_codigo, comp_codigo, licom_exenta, licom_iva5, licom_iva10, licom_fecha,
		 	 tipco_codigo, licom_numcomprobante, licom_estado)
		 	 values(ultCodLibroCompra, compcodigo, 0, 0, 0, compfecha, tipcocodigo, compnumfactura, 'ACTIVO');
		 	 -- Insertamos datos en cuenta pagar
		 	 insert into cuenta_pagar(comp_codigo, cuenpa_nrocuota, cuenpa_monto, cuenpa_saldo, cuenpa_estado)
		 	 values(compcodigo, compcuota, 0, 0, 'ACTIVO');
		 	 -- Actualizamos estado de orden
		 	 update orden_compra_cab set orcom_estado='COMPLETADO', usu_codigo=usucodigo where orcom_codigo=orcomcodigo;
			 -- Validamos si los datos de timbrado de proveedor son distintos
			 select (case when p.pro_timbrado <> comptimbrado then 1 else 0 end) 
			 into modificacionTimbrado from proveedor p where p.pro_codigo=procodigo;
			 -- Si son distintos se actualizan el timbrado y fecha vencimiento timbrado del proveedor
			 if modificacionTimbrado = 1 then
				-- Procedmos con la actualizacion
				update proveedor set pro_timbrado=comptimbrado, pro_timbrado_venc=comptimbradovenc where pro_codigo=procodigo;
				-- Auditamos proveedor
				select coalesce(pro_audit, '') into proAudit from proveedor where pro_codigo = procodigo;
				-- Recorremos el cursor de proveedor y actualizamos el audit
				for pro in c_proveedor loop
					update proveedor 
					set pro_audit = proAudit||''||json_build_object(
						'usu_codigo', usucodigo,
						'usu_login', usulogin,
						'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
						'procedimiento', 'MODIFICACION',
						'pro_razonsocial', upper(pro.pro_razonsocial),
						'tipro_codigo', pro.tipro_codigo,
						'tipro_descripcion', upper(pro.tipro_descripcion),
						'pro_ruc', pro.pro_ruc,
						'pro_timbrado', pro.pro_timbrado,
						'pro_timbrado_venc', pro.pro_timbrado_venc,
						'pro_direccion', upper(pro.pro_direccion),
						'pro_telefono', pro.pro_telefono,
						'pro_email', pro.pro_email,
						'pro_estado', upper(pro.pro_estado)
					)||','
					where pro_codigo = procodigo;
				end loop;
			 end if;
			  -- Se envia un mensaje de confirmacion
			 raise notice 'LA COMPRA FUE REGISTRADA CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de anulacion
    if operacion = 2 then 
		-- Validamos si ya se encuentra asociado compra a una nota de compra y si la nota de compra tiene un estado distinto a anulado 
		select 1 from nota_compra_cab ncc 
		where ncc.comp_codigo=compcodigo and ncc.nocom_estado <> 'ANULADO';
		if found then
			-- En caso de ser asi, generamos una excepcion
			raise exception 'asociado';		
		elseif operacion = 2 then
			-- Anulamos compra cabecera
	    	update compra_cab 
			set comp_estado='ANULADO', usu_codigo=usucodigo
			where comp_codigo=compcodigo;
		    -- Anulamos libro compra
		    update libro_compra set licom_estado='ANULADO' where comp_codigo=compcodigo;
		    -- Anulamos cuenta pagar
		    update cuenta_pagar set cuenpa_estado='ANULADO' where comp_codigo=compcodigo;
		    -- Activamos la orden compra seleccionada
		    update orden_compra_cab set orcom_estado='ACTIVO', usu_codigo=usucodigo where orcom_codigo=orcomcodigo;
		    --Actualizamos el stock 
		    for compraDet in select * from compra_det where comp_codigo=compcodigo loop
				-- Se resta cantidad de stock por item de detalle
		       	update stock set st_cantidad=st_cantidad-compraDet.compdet_cantidad 
				where it_codigo=compraDet.it_codigo and tipit_codigo=compraDet.tipit_codigo and dep_codigo=compraDet.dep_codigo
		        and suc_codigo=compraDet.suc_codigo and emp_codigo=compraDet.emp_codigo;
				-- Auditamos stock
				-- Consultamos cantidad recien modificada de stock
				select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo = compraDet.it_codigo and s.tipit_codigo=compraDet.tipit_codigo
				and s.dep_codigo = compraDet.dep_codigo and s.suc_codigo=compraDet.suc_codigo and s.emp_codigo=compraDet.emp_codigo;
				-- Pasamos los parametros para auditar stock
				perform sp_stock(compraDet.it_codigo, compraDet.tipit_codigo, compraDet.dep_codigo, compraDet.suc_codigo, compraDet.emp_codigo,
				cantidadStockAuditoria, 2, usucodigo, usulogin);
	        end loop;
			-- Se envia un mensaje de confirmacion
			raise notice 'LA COMPRA FUE ANULADA CON EXITO';
		end if;
    end if;
 	-- COMPRA CABECERA AUDITORIA
	-- Consultamos el audit anterior de compra cabecera
	select coalesce(cc.comp_audit, '') into compAudit from compra_cab cc where cc.comp_codigo=compcodigo;
	--a los datos anteriores le agregamos los nuevos
	update compra_cab
	set comp_audit = compAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'comp_fecha', compfecha,
		'comp_numfactura', compnumfactura,
		'comp_timbrado', comptimbrado,
		'comp_timbrado_venc', comptimbradovenc,
		'comp_tipofactura', comptipofactura,
		'comp_cuota', compcuota,
		'comp_montocuota', compmontocuota,
		'comp_interfecha', upper(compinterfecha),
		'tipco_codigo', tipcocodigo,
		'tipco_descripcion', upper(tipcodescripcion),
		'pro_codigo', procodigo,
		'pro_razonsocial', upper(prorazonsocial),
		'tipro_codigo', tiprocodigo,
		'tipro_descripcion', upper(tiprodescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'comp_estado', upper(compestado)
	)||','
	where comp_codigo = compcodigo;
	-- ORDEN COMPRA CABECERA AUDITORIA
	-- Consultamos el audit anterior de orden compra cabecera
	select coalesce(orcom_audit, '') into orcomAudit from orden_compra_cab occ where occ.orcom_codigo = orcomcodigo;
	--a los datos anteriores le agregamos los nuevos
	for ord in c_orden loop
		update orden_compra_cab
		set orcom_audit = orcomAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'orcom_fecha', ord.orcom_fecha,
		'orcom_condicionpago', ord.orcom_condicionpago,
		'orcom_cuota', ord.orcom_cuota,
		'orcom_montocuota', ord.orcom_montocuota,
		'orcom_interfecha', upper(ord.orcom_interfecha),
		'pro_codigo', ord.pro_codigo,
		'pro_razonsocial', upper(ord.pro_razonsocial),
		'tipro_codigo', ord.tipro_codigo,
		'tipro_descripcion', upper(ord.tipro_descripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'orcom_estado', upper(ord.orcom_estado)
		)||','
		where orcom_codigo = orcomcodigo;
	end loop;
	-- LIBRO COMPRA AUDITORIA
	-- Consultamos el audit anterior de libro compra
	select coalesce(lc.licom_audit, '') into licomAudit from libro_compra lc where lc.comp_codigo=compcodigo;
	-- A los datos anteriores le agregamos los nuevos
	for lib in c_libro loop
		update libro_compra 
		set licom_audit = licomAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'comp_codigo', lib.comp_codigo,
		'licom_exenta', lib.licom_exenta,
		'licom_iva5', lib.licom_iva5,
		'licom_iva10', lib.licom_iva10,
		'licom_fecha', lib.licom_fecha,
		'tipco_codigo', lib.tipco_codigo,
		'tipco_descripcion', upper(tipcodescripcion),
		'licom_numcomprobante', lib.licom_numcomprobante,
		'licom_estado', lib.licom_estado
		)||','
		where comp_codigo = compcodigo;
	end loop;
	-- CUENTAS PAGAR AUDITORIA
	-- Consultamos el audit anterior de cuenta pagar
	select coalesce(cp.cuenpa_audit, '') into cuenpaAudit from cuenta_pagar cp where cp.comp_codigo=compcodigo;
	-- A los datos anteriores le agregamos los nuevos
	for cue in c_cuenta loop
		update cuenta_pagar 
		set cuenpa_audit = cuenpaAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'cuenpa_nrocuota', cue.cuenpa_nrocuota,
		'cuenpa_monto', cue.cuenpa_monto,
		'cuenpa_saldo', cue.cuenpa_saldo,
		'cuenpa_estado', cue.cuenpa_estado
		)||','
		where comp_codigo = compcodigo;
	end loop;
end
$function$ 
language plpgsql;

select 
         s.it_codigo,
         s.tipit_codigo,
         i.it_descripcion,
         um.unime_codigo,
         um.unime_descripcion 
      from stock s 
         join items i on i.it_codigo=s.it_codigo
         and i.tipit_codigo=s.tipit_codigo
         join unidad_medida um on um.unime_codigo=i.unime_codigo
         where s.dep_codigo=$dep_codigo
         and s.suc_codigo=$suc_codigo 
         and s.emp_codigo=$emp_codigo
         and i.it_descripcion ilike '%$it_descripcion%'
         and i.it_estado='ACTIVO'
      order by s.it_codigo;
     
 select 
 	ocd.it_codigo,
 	ocd.it_codigo,
 	ocd.tipit_codigo,
 	i.it_descripcion,
 	ocd.orcomdet_cantidad as compdet_cantidad,
 	ocd.orcomdet_precio as compdet_precio,
 	um.unime_codigo,
 	um.unime_descripcion 
 from orden_compra_det ocd 
 	 join orden_compra_cab occ on occ.orcom_codigo=ocd.orcom_codigo 
	 join items i on i.it_codigo=ocd.it_codigo 
	 and i.tipit_codigo=ocd.tipit_codigo 
	 join unidad_medida um on um.unime_codigo=i.unime_codigo
 where ocd.orcom_codigo=1 
 	 and i.it_estado='ACTIVO'
 	 and occ.orcom_estado='COMPLETADO'
 	 and i.it_descripcion ilike '%hil%'
 order by i.it_codigo;
 

select
         occ.orcom_codigo,
         'Orden N°'||occ.orcom_codigo||' '||to_char(occ.orcom_fecha, 'DD-MM-YYYY') as orden,
         occ.pro_codigo,
         occ.tipro_codigo,
         tp.tipro_descripcion,
         p.pro_razonsocial,
         occ.orcom_condicionpago as comp_tipofactura,
         occ.orcom_cuota as comp_cuota,
         occ.orcom_montocuota as comp_montocuota,
         occ.orcom_interfecha as comp_interfecha
      from orden_compra_cab occ
         join proveedor p on p.pro_codigo=occ.pro_codigo
         and p.tipro_codigo=occ.tipro_codigo
         join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
         where (p.pro_ruc ilike '%$pro_razonsocial%' or p.pro_razonsocial ilike '%$pro_razonsocial%')
         and occ.orcom_estado='ACTIVO'
      order by occ.orcom_codigo;
     
select 
	d.dep_codigo,
	d.dep_descripcion
from deposito d
	where d.suc_codigo=$sucursal 
	and d.emp_codigo=$empresa 
	and d.dep_estado='ACTIVO';
select sp_compra_det(1, 1, 1, 1, 1, 1, 20, 5000, 1);
--Procedimiento almacenado compra detalle
select * from personas p;
select version();

select i.it_costo from items i where i.it_codigo=1;

select coalesce(sum(case cd.tipit_codigo when 3 then cd.compdet_precio else cd.compdet_cantidad*cd.compdet_precio end), 0) as suma_detalle 
from compra_det cd where cd.comp_codigo = 2; 

select 
cc.comp_codigo,
cc.comp_fecha,
cc.comp_numfactura,
cc.comp_timbrado,
cc.comp_tipofactura,
cc.comp_cuota,
cc.comp_montocuota,
cc.comp_interfecha,
cc.comp_estado,
cc.pro_codigo,
cc.tipro_codigo,
p.pro_razonsocial,
tp.tipro_descripcion,
u.usu_login,
s.suc_descripcion,
e.emp_razonsocial,
oc.orcom_codigo
from compra_cab cc
join orden_compra oc on oc.comp_codigo=cc.comp_codigo
join proveedor p on p.pro_codigo=cc.pro_codigo
and p.tipro_codigo=cc.tipro_codigo
join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
join usuario u on u.usu_codigo=cc.usu_codigo
join sucursal s on s.suc_codigo=cc.suc_codigo
and s.emp_codigo=cc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
where cc.comp_codigo=1;

select 
		cc.comp_codigo,
		cc.comp_fecha,
		cc.comp_numfactura,
		cc.comp_timbrado,
		CC.comp_timbrado_venc,
		cc.comp_tipofactura,
		cc.comp_cuota,
		cc.comp_montocuota,
		cc.comp_interfecha,
		cc.comp_estado,
		cc.pro_codigo,
		cc.tipro_codigo,
		p.pro_razonsocial,
		tp.tipro_descripcion,
		cc.usu_codigo,
		u.usu_login,
		s.suc_descripcion,
		e.emp_razonsocial,
		oc.orcom_codigo,
		cc.tipco_codigo,
		tc.tipco_descripcion 
		from compra_cab cc
		join orden_compra oc on oc.comp_codigo=cc.comp_codigo
		join proveedor p on p.pro_codigo=cc.pro_codigo
		and p.tipro_codigo=cc.tipro_codigo
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
		join tipo_comprobante tc on tc.tipco_codigo=cc.tipco_codigo 
		join usuario u on u.usu_codigo=cc.usu_codigo
		join sucursal s on s.suc_codigo=cc.suc_codigo
		and s.emp_codigo=cc.emp_codigo
		join empresa e on e.emp_codigo=s.emp_codigo
		where cc.comp_codigo=compcodigo;

create or replace function sp_compra_det(
    compcodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    compdetcantidad numeric,
    compdetprecio numeric,
    usucodigo integer,
    usulogin varchar,
    compcuota integer,
    operacion integer
) returns void as
$function$
declare cantidadStockAuditoria numeric;
		itemCosto numeric;
		suma_detalle numeric;
		monto_cuota numeric;
		itAudit text;
		compAudit text;
		c_items cursor is
		select 
        i.it_codigo,
        i.tipit_codigo,
        i.it_descripcion,
        i.it_costo,
        i.it_precio,
        i.it_estado,
        i.mod_codigo,
        i.tall_codigo,
        i.tipim_codigo,
        i.unime_codigo,
        ti.tipit_descripcion,
        m.mod_codigomodelo,
        t.tall_descripcion,
        tim.tipim_descripcion,
        um.unime_descripcion,
        i.it_stock_min, 
        i.it_stock_max
        from items i
        join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
        join modelo m on m.mod_codigo=i.mod_codigo
        join talle t on t.tall_codigo=i.tall_codigo 
        join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
        join unidad_medida um on um.unime_codigo=i.unime_codigo 
        where i.it_codigo=itcodigo;
		c_compra cursor is
		select 
		cc.comp_codigo,
		cc.comp_fecha,
		cc.comp_numfactura,
		cc.comp_timbrado,
		cc.comp_timbrado_venc,
		cc.comp_tipofactura,
		cc.comp_cuota,
		cc.comp_montocuota,
		cc.comp_interfecha,
		cc.comp_estado,
		cc.pro_codigo,
		cc.tipro_codigo,
		cc.emp_codigo,
		cc.suc_codigo,
		cc.usu_codigo,
		p.pro_razonsocial,
		tp.tipro_descripcion,
		cc.usu_codigo,
		u.usu_login,
		s.suc_descripcion,
		e.emp_razonsocial,
		oc.orcom_codigo,
		cc.tipco_codigo,
		tc.tipco_descripcion 
		from compra_cab cc
		join orden_compra oc on oc.comp_codigo=cc.comp_codigo
		join proveedor p on p.pro_codigo=cc.pro_codigo
		and p.tipro_codigo=cc.tipro_codigo
		join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
		join tipo_comprobante tc on tc.tipco_codigo=cc.tipco_codigo 
		join usuario u on u.usu_codigo=cc.usu_codigo
		join sucursal s on s.suc_codigo=cc.suc_codigo
		and s.emp_codigo=cc.emp_codigo
		join empresa e on e.emp_codigo=s.emp_codigo
		where cc.comp_codigo=compcodigo;
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		-- Validamos que no se repita el item en el detalle de compra
     	perform * from compra_det
     	where it_codigo=itcodigo and dep_codigo=depcodigo and comp_codigo=compcodigo;
     	if found then
			 -- En caso de ser asi, generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
			 -- Validamos si es que el item junto al deposito existen o esta registrado en stock
			 perform * from stock
     		 where it_codigo=itcodigo and tipit_codigo=tipitcodigo 
			 and dep_codigo=depcodigo and suc_codigo=succodigo 
			 and emp_codigo=empcodigo;
			 if found then
				-- En caso de que si se encuentre, sumamos la cantidad
				 update stock set st_cantidad=st_cantidad+compdetcantidad 
				 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
				 and suc_codigo=succodigo and emp_codigo=empcodigo;
				-- Auditamos nueva cantidad de stock
				select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
				and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
				-- Procedemos con el audit del registro modificado
				perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
			 else	
				 -- Si no existe lo registramos
				 -- Materia prima o utilitario
				 if tipitcodigo in(1, 4) then
					--Si es materia prima o utilitario cargamos el item en stock
					perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, compdetcantidad, 1, usucodigo, usulogin);
				 else
					-- Servicio
					-- Si es un servicio mantenemos la cantidad en 0
					perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, 0, 1, usucodigo, usulogin);
				 end if;
             end if;
     	 	 --Insertamos detalle compra
		     insert into compra_det(comp_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo,
		     emp_codigo, compdet_cantidad, compdet_precio)
			 values(compcodigo, itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, compdetcantidad, compdetprecio);
			 -- Validamos que  el precio del item detalle no sea distinto al almacenado en caso de ser materia prima o utilitario
			 if	tipitcodigo in(1,4) then
				-- Consultamos el costo para validar
				select i.it_costo into itemCosto from items i where i.it_codigo=itcodigo;
				-- Validamos si es distinto a lo pasado en detalle
				if itemCosto <> compdetprecio then
					-- Actualizamos la columna de costo de item
					update items set it_costo=compdetprecio where it_codigo=itcodigo;
					-- Auditamos la modifcacion de items
					select coalesce(it_audit, '') into itAudit from items where it_codigo = itcodigo;
					-- Recorremos el cursor de items
					for item in c_items loop
						update items 
						set it_audit = itAudit||''||json_build_object(
							'usu_codigo', usucodigo,
							'usu_login', usulogin,
							'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
							'procedimiento', 'MODIFICACION',
							'it_descripcion', upper(item.it_descripcion),
							'tipit_codigo', item.tipit_codigo,
							'tipit_descripcion', upper(item.tipit_descripcion),
							'tipim_codigo', item.tipim_codigo,
							'tipim_descripcion', upper(item.tipim_descripcion),
							'it_costo', item.it_costo,
							'it_precio', item.it_precio,
							'mod_codigo', item.mod_codigo,
							'mod_codigomodelo', item.mod_codigomodelo,
							'tall_codigo', item.tall_codigo,
							'tall_descripcion', item.tall_descripcion,
							'unime_codigo', item.unime_codigo,
							'unime_descripcion', upper(item.unime_descripcion),
							'it_stock_min', item.it_stock_min,
							'it_stock_max', item.it_stock_max,
							'it_estado', upper(item.it_estado)
						)||','
						where it_codigo = itcodigo;
					end loop;
				end if;
			 end if;
			 -- Se envia mensaje de confirmacion
			 raise notice 'LA COMPRA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de eliminacion
    if operacion = 2 then 
    	-- Eliminamos el item y devolvemos la cantidad
    	delete from compra_det 
    	where comp_codigo=compcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
        and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
       	-- Actualizamos el stock 
		update stock set st_cantidad=st_cantidad-compdetcantidad 
		where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		and suc_codigo=succodigo and emp_codigo=empcodigo;
		-- Auditamos nueva cantidad de stock
		select s.st_cantidad into cantidadStockAuditoria from stock s where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
		and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
		-- Procedemos con el audit del registro modificado
		perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
		-- Se envia mensaje de confirmacion
		raise notice 'LA COMPRA DETALLE FUE ELIMINADA CON EXITO';
    end if;
	-- Validamos la operacion de insercion y eliminacion
	if operacion in(1,2) then
		-- Realizamos la sumatoria del detalle y guardamos en una variable
		select coalesce(sum(case cd.tipit_codigo when 3 then cd.compdet_precio else cd.compdet_cantidad*cd.compdet_precio end), 0) into suma_detalle 
		from compra_det cd where cd.comp_codigo = compcodigo;
		-- Calculamos el nuevo monto de comp_montocuota
		select round(suma_detalle/compcuota) into monto_cuota;
		-- Definimos el nuevo comp_montocuota
		update compra_cab set comp_montocuota=monto_cuota, usu_codigo=usucodigo where comp_codigo=compcodigo;
		-- Una vez actualizado la cabecera, la auditamos
		-- Consultamos el audit anterior de compra cabecera
		select coalesce(cc.comp_audit, '') into compAudit from compra_cab cc where cc.comp_codigo=compcodigo;
		-- A los datos anteriores le agregamos los nuevos
		for compra in c_compra loop
			update compra_cab
			set comp_audit = compAudit||''||json_build_object(
				'usu_codigo', compra.usu_codigo,
				'usu_login', compra.usu_login,
				'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
				'procedimiento', 'MODIFICACION',
				'comp_fecha', compra.comp_fecha,
				'comp_numfactura', compra.comp_numfactura,
				'comp_timbrado', compra.comp_timbrado,
				'comp_timbrado_venc', compra.comp_timbrado_venc,
				'comp_tipofactura', compra.comp_tipofactura,
				'comp_cuota', compra.comp_cuota,
				'comp_montocuota', compra.comp_montocuota,
				'comp_interfecha', upper(compra.comp_interfecha),
				'tipco_codigo', compra.tipco_codigo,
				'tipco_descripcion', upper(compra.tipco_descripcion),
				'pro_codigo', compra.pro_codigo,
				'pro_razonsocial', upper(compra.pro_razonsocial),
				'tipro_codigo', compra.tipro_codigo,
				'tipro_descripcion', upper(compra.tipro_descripcion),
				'emp_codigo', compra.emp_codigo,
				'emp_razonsocial', upper(compra.emp_razonsocial),
				'suc_codigo', compra.suc_codigo,
				'suc_descripcion', upper(compra.suc_descripcion),
				'comp_estado', upper(compra.comp_estado)
			)||','
			where comp_codigo = compcodigo;
		end loop;
	end if;
end
$function$ 
language plpgsql;

select round(i.it_stock_max) as maximo from items i where i.it_codigo=1;
select s.st_cantidad as cantidad_item from stock s where s.it_codigo=1 and s.tipit_codigo=1 and s.dep_codigo=1 and s.suc_codigo=1 and s.emp_codigo=1;

select * from acceso a order by acc_codigo DESC;

--Procedimiento almacenado libro compra
select 
            cd.dep_codigo,
            d.dep_descripcion,
            cd.it_codigo,
            cd.tipit_codigo,
            i.tipim_codigo,
            (case 
                  when i.tipit_codigo in(1, 4)
                  then 
                     i.it_descripcion||' '||d.dep_descripcion 
                  else 
                     i.it_descripcion
                  end) as it_descripcion,
            cd.compdet_cantidad as nocomdet_cantidad,
            i.unime_codigo,
            um.unime_descripcion,
            cd.compdet_precio as nocomdet_precio
         from compra_det cd
            join stock s on s.it_codigo=cd.it_codigo
            and s.tipit_codigo=cd.tipit_codigo
            and s.dep_codigo=cd.dep_codigo 
            and s.suc_codigo=cd.suc_codigo
            and s.emp_codigo=cd.emp_codigo
            join items i on i.it_codigo=s.it_codigo
            and i.tipit_codigo=s.tipit_codigo
            join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
            join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
            join deposito d on d.dep_codigo=s.dep_codigo
            and d.suc_codigo=s.suc_codigo
            and d.emp_codigo=s.emp_codigo 
            join unidad_medida um on um.unime_codigo=i.unime_codigo
         where cd.comp_codigo=1
            and i.it_descripcion ilike '%%'
            and i.it_estado = 'ACTIVO'
            and i.tipit_codigo <> 2
         order by cd.comp_codigo;

select sp_libro_compra(1, 0, 0, 100000, 'FACTURA', '15000000', 1, 2, 'psal');
create or replace function sp_libro_compra(
    compcodigo integer,
    licomexenta numeric,
    licomiva5 numeric,
    licomiva10 numeric,
    tipcocodigo integer,
    tipcodescripcion varchar,
    licomnumcomprobante varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar
) returns void as
$function$
declare licomAudit text;
		c_libro cursor is
		select 
		lc.comp_codigo,
		lc.licom_exenta,
		lc.licom_iva5,
		lc.licom_iva10,
		lc.licom_fecha,
		lc.tipco_codigo,
		lc.licom_numcomprobante,
		lc.licom_estado
		from libro_compra lc
		where lc.comp_codigo=compcodigo
		and lc.licom_numcomprobante=licomnumcomprobante;
begin 
	if operacion = 1 then
     update libro_compra set licom_exenta=licom_exenta+licomexenta, licom_iva5=licom_iva5+licomiva5, 
     licom_iva10=licom_iva10+licomiva10 where comp_codigo=compcodigo and licom_numcomprobante=licomnumcomprobante
	 and tipco_codigo=tipcocodigo;
    end if;
    if operacion = 2 then
     update libro_compra set licom_exenta=licom_exenta-licomexenta, licom_iva5=licom_iva5-licomiva5, 
     licom_iva10=licom_iva10-licomiva10 where comp_codigo=compcodigo and licom_numcomprobante=licomnumcomprobante
	 and tipco_codigo=tipcocodigo;
    end if;
	--LIBRO COMPRA AUDITORIA
	--consultamos el audit anterior de libro compra
	select coalesce(lc.licom_audit, '') into licomAudit from libro_compra lc where lc.comp_codigo=compcodigo and lc.licom_numcomprobante=licomnumcomprobante;
	--a los datos anteriores le agregamos los nuevos
	for lib in c_libro loop
		update libro_compra 
		set licom_audit = licomAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'comp_codigo', lib.comp_codigo,
		'licom_exenta', lib.licom_exenta,
		'licom_iva5', lib.licom_iva5,
		'licom_iva10', lib.licom_iva10,
		'licom_fecha', lib.licom_fecha,
		'tipco_codigo', lib.tipco_codigo,
		'tipco_descripcion', upper(tipcodescripcion),
		'licom_numcomprobante', lib.licom_numcomprobante,
		'licom_estado', lib.licom_estado
		)||','
		where comp_codigo = compcodigo and licom_numcomprobante = licomnumcomprobante and tipco_codigo=tipcocodigo;
	end loop;
end
$function$ 
language plpgsql;

--Procedimiento almacenado cuneta pagar.
select coalesce ((select 1 from (select ncd.it_codigo from nota_compra_det ncd where ncd.nocom_codigo=1 and 
ncd.it_codigo=1 and ncd.tipit_codigo=1 and ncd.dep_codigo=1 and ncd.suc_codigo=1 and ncd.emp_codigo=1)g),0) as existe_item;
select cd.compdet_cantidad as cantidad_compra_det from compra_det cd where cd.comp_codigo=1 and cd.it_codigo=1 and cd.tipit_codigo=1
and cd.dep_codigo=1 and cd.suc_codigo=1 and cd.emp_codigo=1;
select sp_cuenta_pagar(1, 100000, 100000, 1, 2, 'psal');
create or replace function sp_cuenta_pagar(
    compcodigo integer,
    cuenpamonto numeric,
    cuenpasaldo numeric,
    operacion integer,
    usucodigo integer,
    usulogin varchar
) returns void as
$function$
declare cuenpaAudit text;
		c_cuenta cursor is
		select
		cp.cuenpa_nrocuota,
		cp.cuenpa_monto,
		cp.cuenpa_saldo,
		cp.cuenpa_estado
		from cuenta_pagar cp
		where cp.comp_codigo=compcodigo;
begin 
    if operacion = 1 then
	 update	cuenta_pagar set cuenpa_monto=cuenpa_monto+cuenpamonto, 
	 cuenpa_saldo=cuenpa_saldo+cuenpasaldo where comp_codigo=compcodigo;
	end if;
	if operacion = 2 then 
	 update	cuenta_pagar set cuenpa_monto=cuenpa_monto-cuenpamonto, 
	 cuenpa_saldo=cuenpa_saldo-cuenpasaldo where comp_codigo=compcodigo;
	end if;
	--CUENTAS PAGAR AUDITORIA
	--consultamos el audit anterior de cuenta pagar
	select coalesce(cp.cuenpa_audit, '') into cuenpaAudit from cuenta_pagar cp where cp.comp_codigo=compcodigo;
	--a los datos anteriores le agregamos los nuevos
	for cue in c_cuenta loop
		update cuenta_pagar 
		set cuenpa_audit = cuenpaAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'cuenpa_nrocuota', cue.cuenpa_nrocuota,
		'cuenpa_monto', cue.cuenpa_monto,
		'cuenpa_saldo', cue.cuenpa_saldo,
		'cuenpa_estado', cue.cuenpa_estado
		)||','
		where comp_codigo = compcodigo;
	end loop;
end
$function$ 
language plpgsql;

--Procedimiento almacenado nota compra cabecera
select 
         s.it_codigo,
         s.tipit_codigo,
         i.it_descripcion,
         um.unime_codigo,
         um.unime_descripcion,
         (case 
         when i.tipit_codigo in(1, 4)
         then 
         	i.it_costo 
         else 
         	0
         end) as nocomdet_precio
      from stock s 
         join items i on i.it_codigo=s.it_codigo
         and i.tipit_codigo=s.tipit_codigo
         join unidad_medida um on um.unime_codigo=i.unime_codigo
         join modelo m on m.mod_codigo=i.mod_codigo
         join talle t on t.tall_codigo=i.tall_codigo
         where s.dep_codigo=1
         and s.suc_codigo=1
         and s.emp_codigo=1 
         and i.it_descripcion ilike '%%'
         and i.tipit_codigo <> 2
         and i.it_estado='ACTIVO'
      order by s.it_codigo;
select 
	cd.dep_codigo,
	d.dep_descripcion,
	cd.it_codigo,
	cd.tipit_codigo,
	(case 
         when i.tipit_codigo in(1, 4)
         then 
         	i.it_descripcion||' '||d.dep_descripcion 
         else 
         	i.it_descripcion
         end) as it_descripcion,
	cd.compdet_cantidad as nocomdet_cantidad,
	i.unime_codigo,
	um.unime_descripcion,
	cd.compdet_precio as nocomdet_precio
from compra_det cd
	join stock s on s.it_codigo=cd.it_codigo
	and s.tipit_codigo=cd.tipit_codigo
	and s.dep_codigo=cd.dep_codigo 
	and s.suc_codigo=cd.suc_codigo
	and s.emp_codigo=cd.emp_codigo
	join items i on i.it_codigo=s.it_codigo
	and i.tipit_codigo=s.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
	join deposito d on d.dep_codigo=s.dep_codigo
	and d.suc_codigo=s.suc_codigo
	and d.emp_codigo=s.emp_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo
where cd.comp_codigo=1
and i.it_descripcion ilike '%%'
and i.it_estado = 'ACTIVO'
and i.tipit_codigo <> 2
order by cd.comp_codigo;
select coalesce(max(nocom_codigo),0)+1 from nota_compra_cab;
select 
	ncd.it_codigo,
	ncd.tipit_codigo,
	ncd.dep_codigo,
	ncd.suc_codigo,
	ncd.emp_codigo 
from nota_compra_det ncd
where ncd.nocom_codigo=1;

select sp_nota_compra_cab(1, '2024-11-22', '001', 'DEVOLUCION', 'ACTIVO', 1, 1, 1, 2, 1, 1, 1,
1, 'psal', 'ALTA', 'CREDITO', 'EL HILERO', 'MINORISTA', '8 DE DICIEMBRE', 'CASA MATRIZ');

select coalesce(sum(case when ncd.tipit_codigo = 3 then ncd.nocomdet_precio else ncd.nocomdet_cantidad*ncd.nocomdet_precio end),0)
into totalSuma from nota_compra_det ncd where ncd.nocom_codigo = nocomcodigo;

create or replace function sp_nota_compra_cab(
    nocomcodigo integer,
    nocomfecha date,
    nocomnumeronota varchar,
    nocomconcepto varchar,
    nocomestado varchar,
    tipcocodigo integer,
    succodigo integer,
    empcodigo integer,
    usucodigo integer,
    compcodigo integer,
    procodigo integer,
    tiprocodigo integer,
    nocomtimbrado varchar,
    nocomtimbradovenc date,
    nocomchapa varchar,
    nocomfuncionario integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    tipcodescripcion varchar,
    prorazonsocial varchar,
    tiprodescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare
    -- Variables de auditoría
    nocomAudit text;
    licomAudit text;
    compAudit text;

    -- Variables de control
    ultCodLibroCompra integer;
    totalSuma numeric := 0;
	cantidadStockAuditoria numeric := 0;

    -- Cursor para recorrer detalles de la nota
    c_nota_det record;
    -- Cursor para recorrer compras relacionadas
    c_compra record;
    -- Cursor para recorrer libro de compras relacionado
    c_libro record;
begin
    -- 1. Operación: Insertar Nota
    if operacion = 1 then
        -- Buscamos siguiente código disponible en libro de compras
        select coalesce(max(licom_codigo),0)+1 into ultCodLibroCompra from libro_compra;

        -- Validamos si ya existe una nota con el mismo número, proveedor y tipo
        if exists (
            select 1 from nota_compra_cab
            where nocom_numeronota = nocomnumeronota
              and nocom_timbrado = nocomtimbrado
              and nocom_estado = 'ACTIVO'
        ) then
            raise exception 'nota';
        end if;

        -- Insertamos nueva cabecera de nota
        insert into nota_compra_cab(
            nocom_codigo, nocom_fecha, nocom_numeronota, nocom_concepto,
            nocom_estado, tipco_codigo, suc_codigo, emp_codigo,
            usu_codigo, comp_codigo, pro_codigo, tipro_codigo,
			nocom_timbrado, nocom_timbrado_venc, nocom_chapa, nocom_funcionario
        ) values (
            nocomcodigo, nocomfecha, nocomnumeronota, upper(nocomconcepto),
            'ACTIVO', tipcocodigo, succodigo, empcodigo,
            usucodigo, compcodigo, procodigo, tiprocodigo,
			nocomtimbrado, nocomtimbradovenc, nocomchapa, nocomfuncionario
        );

        -- Si corresponde, insertamos en libro de compras
        if tipcocodigo in (1,2) then
            insert into libro_compra(
                licom_codigo, comp_codigo, licom_exenta, licom_iva5, licom_iva10,
                licom_fecha, tipco_codigo, licom_numcomprobante, licom_estado
            ) values (
                ultCodLibroCompra, compcodigo, 0, 0, 0,
                nocomfecha, tipcocodigo, nocomnumeronota, 'ACTIVO'
            );
        end if;

        raise notice 'LA NOTA DE COMPRA FUE REGISTRADA CON EXITO';
    end if;

    -- 2. Operación: Anular Nota
    if operacion = 2 then
        -- Marcamos la nota como anulada
        update nota_compra_cab
        set nocom_estado = 'ANULADO', usu_codigo = usucodigo
        where nocom_codigo = nocomcodigo;

        -- Anulamos libro de compras relacionado
        update libro_compra
        set licom_estado = 'ANULADO'
        where comp_codigo = compcodigo
          and licom_numcomprobante = nocomnumeronota
          and tipco_codigo = tipcocodigo;

        -- Recorremos detalles para ajustar stock
        for c_nota_det in
            select it_codigo, tipit_codigo, nocomdet_cantidad, dep_codigo, suc_codigo, emp_codigo
            from nota_compra_det
            where nocom_codigo = nocomcodigo
        loop
            case tipcocodigo
                when 1 then -- Nota crédito: devolvemos stock
                    update stock
                    set st_cantidad = st_cantidad + c_nota_det.nocomdet_cantidad
                    where it_codigo = c_nota_det.it_codigo
                      and tipit_codigo = c_nota_det.tipit_codigo
                      and dep_codigo = c_nota_det.dep_codigo
                      and suc_codigo = c_nota_det.suc_codigo
                      and emp_codigo = c_nota_det.emp_codigo;
					-- Consultamos cantidad recien modificada de stock
					select s.st_cantidad into cantidadStockAuditoria 
					from stock s 
					where s.it_codigo = c_nota_det.it_codigo 
					  and s.tipit_codigo=c_nota_det.tipit_codigo
					  and s.dep_codigo = c_nota_det.dep_codigo 
					  and s.suc_codigo=c_nota_det.suc_codigo 
					  and s.emp_codigo=c_nota_det.emp_codigo;
					-- Pasamos los parametros para auditar stock
					perform sp_stock(c_nota_det.it_codigo, c_nota_det.tipit_codigo, c_nota_det.dep_codigo, 
							c_nota_det.suc_codigo, c_nota_det.emp_codigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
                when 2 then -- Nota débito: restamos stock
                    update stock
                    set st_cantidad = st_cantidad - c_nota_det.nocomdet_cantidad
                    where it_codigo = c_nota_det.it_codigo
                      and tipit_codigo = c_nota_det.tipit_codigo
                      and dep_codigo = c_nota_det.dep_codigo
                      and suc_codigo = c_nota_det.suc_codigo
                      and emp_codigo = c_nota_det.emp_codigo;
					-- Consultamos cantidad recien modificada de stock
					select s.st_cantidad into cantidadStockAuditoria 
					from stock s 
					where s.it_codigo = c_nota_det.it_codigo 
					  and s.tipit_codigo=c_nota_det.tipit_codigo
					  and s.dep_codigo = c_nota_det.dep_codigo 
					  and s.suc_codigo=c_nota_det.suc_codigo 
					  and s.emp_codigo=c_nota_det.emp_codigo;
					-- Pasamos los parametros para auditar stock
					perform sp_stock(c_nota_det.it_codigo, c_nota_det.tipit_codigo, c_nota_det.dep_codigo, 
							c_nota_det.suc_codigo, c_nota_det.emp_codigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
            end case;
        end loop;

        -- Sumamos subtotales de los detalles
        select coalesce(
		sum(case when ncd.tipit_codigo = 3 then ncd.nocomdet_precio else ncd.nocomdet_cantidad*ncd.nocomdet_precio end),0)
		into totalSuma 
		from nota_compra_det ncd 
		where ncd.nocom_codigo = nocomcodigo;

        -- Si hay monto, actualizamos cuentas por pagar
        if totalSuma > 0 then
            perform sp_cuenta_pagar(
                compcodigo, totalSuma, totalSuma,
                tipcocodigo, usucodigo, usulogin
            );
        end if;

        -- Si fue nota crédito, también reactivamos la compra asociada
        if tipcocodigo = 1 and totalSuma > 0 then
            update cuenta_pagar set cuenpa_estado='ACTIVO' where comp_codigo=compcodigo;
            update compra_cab set comp_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;

            -- Auditamos la compra asociada
            for c_compra in
                select cc.*, tc.tipco_descripcion, p.pro_razonsocial,
                       tp.tipro_descripcion, e.emp_razonsocial, s.suc_descripcion
                from compra_cab cc
                join tipo_comprobante tc on tc.tipco_codigo = cc.tipco_codigo
                join proveedor p on p.pro_codigo = cc.pro_codigo
                join tipo_proveedor tp on tp.tipro_codigo = p.tipro_codigo
                join sucursal s on s.suc_codigo = cc.suc_codigo and s.emp_codigo = cc.emp_codigo
                join empresa e on e.emp_codigo = s.emp_codigo
                where cc.comp_codigo = compcodigo
            loop
                select coalesce(comp_audit,'') into compAudit from compra_cab where comp_codigo=compcodigo;

                update compra_cab
                set comp_audit = compAudit || '' || json_build_object(
                    'usu_codigo', usucodigo,
                    'usu_login', usulogin,
                    'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
                    'procedimiento', 'MODIFICACION',
                    'comp_fecha', c_compra.comp_fecha,
                    'comp_numfactura', c_compra.comp_numfactura,
                    'comp_timbrado', c_compra.comp_timbrado,
					'comp_timbrado_venc', c_compra.comp_timbrado_venc,
                    'comp_tipofactura', c_compra.comp_tipofactura,
                    'comp_cuota', c_compra.comp_cuota,
                    'comp_montocuota', c_compra.comp_montocuota,
                    'comp_interfecha', c_compra.comp_interfecha,
                    'tipco_codigo', c_compra.tipco_codigo,
                    'tipco_descripcion', c_compra.tipco_descripcion,
                    'pro_codigo', c_compra.pro_codigo,
                    'pro_razonsocial', c_compra.pro_razonsocial,
                    'tipro_codigo', c_compra.tipro_codigo,
                    'tipro_descripcion', c_compra.tipro_descripcion,
                    'emp_codigo', c_compra.emp_codigo,
                    'emp_razonsocial', c_compra.emp_razonsocial,
                    'suc_codigo', c_compra.suc_codigo,
                    'suc_descripcion', c_compra.suc_descripcion,
                    'comp_estado', c_compra.comp_estado
                ) || ','
                where comp_codigo = compcodigo;
            end loop;
        end if;

        raise notice 'LA NOTA DE COMPRA FUE ANULADA CON EXITO';
    end if;

    -- 3. Auditoría de Nota Compra
    select coalesce(nocom_audit,'') into nocomAudit
    from nota_compra_cab
    where nocom_codigo = nocomcodigo;

    update nota_compra_cab
    set nocom_audit = nocomAudit || '' || json_build_object(
        'usu_codigo', usucodigo,
        'usu_login', usulogin,
        'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
        'procedimiento', upper(procedimiento),
        'nocom_fecha', nocomfecha,
        'nocom_numeronota', nocomnumeronota,
		'nocom_timbrado', nocomtimbrado,
		'nocom_timbrado_venc', nocomtimbradovenc,
        'nocom_concepto', nocomconcepto,
        'comp_codigo', compcodigo,
        'tipco_codigo', tipcocodigo,
        'tipco_descripcion', upper(tipcodescripcion),
        'pro_codigo', procodigo,
        'pro_razonsocial', upper(prorazonsocial),
        'tipro_codigo', tiprocodigo,
        'tipro_descripcion', upper(tiprodescripcion),
        'emp_codigo', empcodigo,
        'emp_razonsocial', upper(emprazonsocial),
        'suc_codigo', succodigo,
        'suc_descripcion', upper(sucdescripcion),
		'nocom_chapa', nocomchapa,
		'nocom_funcionario', nocomfuncionario,
        'nocom_estado', upper(nocomestado)
    ) || ','
    where nocom_codigo = nocomcodigo;

    -- 4. Auditoría de Libro Compra
    select coalesce(licom_audit,'') into licomAudit
    from libro_compra
    where comp_codigo=compcodigo
      and licom_numcomprobante=nocomnumeronota
      and tipco_codigo=tipcocodigo;

    for c_libro in
        select comp_codigo, licom_exenta, licom_iva5, licom_iva10,
               licom_fecha, tipco_codigo, licom_numcomprobante, licom_estado
        from libro_compra
        where comp_codigo=compcodigo
          and licom_numcomprobante=nocomnumeronota
          and tipco_codigo=tipcocodigo
    loop
        update libro_compra
        set licom_audit = licomAudit || '' || json_build_object(
            'usu_codigo', usucodigo,
            'usu_login', usulogin,
            'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
            'procedimiento', upper(procedimiento),
            'comp_codigo', c_libro.comp_codigo,
            'licom_exenta', c_libro.licom_exenta,
            'licom_iva5', c_libro.licom_iva5,
            'licom_iva10', c_libro.licom_iva10,
            'licom_fecha', c_libro.licom_fecha,
            'tipco_codigo', c_libro.tipco_codigo,
            'tipco_descripcion', upper(tipcodescripcion),
            'licom_numcomprobante', c_libro.licom_numcomprobante,
            'licom_estado', c_libro.licom_estado
        ) || ','
        where comp_codigo=compcodigo
          and licom_numcomprobante=nocomnumeronota
          and tipco_codigo=tipcocodigo;
    end loop;

end
$function$
language plpgsql;

select sp_nota_compra_cab(0, '26/10/2023', '1', 'Desperfecto', 'Activo', 1, 1, 1, 2, 1, 1, 1, 1);

select
	sum(ncd.nocomdet_cantidad*ncd.nocomdet_precio) as nota,
	sum(cd.compdet_cantidad*cd.compdet_precio) as compra
from nota_compra_det ncd 
join nota_compra_cab ncc on ncc.nocom_codigo=ncd.nocom_codigo 
join compra_det cd on cd.comp_codigo=ncc.comp_codigo 
where ncd.nocom_codigo=1;

if exists (select 1 from cuenta_pagar where comp_codigo=1);

select cp.cuenpa_monto into notaMonto from cuenta_pagar cp where cp.comp_codigo=1;
select cc.comp_estado into compraEstado from compra_cab cc where cc.comp_codigo=1;
--Procedimiento almacenado nota compra detalle
select sp_nota_compra_det(1, 1, 1, 5, 5000, 1, 1, 1, 1, 1);
create or replace function sp_nota_compra_det(
    nocomcodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    nocomdetcantidad numeric,
    nocomdetprecio numeric,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    tipcocodigo integer,
    compcodigo integer,
    usucodigo integer, 
    operacion integer,
    usulogin varchar
) returns void as
$function$ 
declare 
    -- Variables de trabajo
    notaMonto numeric;          -- monto actual de la cuenta por pagar
    compraEstado varchar;       -- estado actual de la cabecera de compra
    compAudit text;             -- texto acumulado para auditoría
	cantidadStockAuditoria numeric := 0;  --cantidad de stock actualizado para auditoria

    -- Cursor para traer datos de la cabecera de compra (para auditoría)
    c_compra_cab cursor is
        select 
            cc.comp_fecha,
            cc.comp_numfactura,
            cc.comp_timbrado,
			cc.comp_timbrado_venc,
            cc.comp_tipofactura,
            cc.comp_cuota,
            cc.comp_montocuota,
            cc.comp_interfecha,
            cc.tipco_codigo,
            tc.tipco_descripcion,
            cc.pro_codigo,
            p.pro_razonsocial,
            cc.tipro_codigo,
            tp.tipro_descripcion,
            cc.emp_codigo,
            e.emp_razonsocial,
            cc.suc_codigo,
            s.suc_descripcion,
            cc.comp_estado
        from compra_cab cc
        join tipo_comprobante tc on tc.tipco_codigo=cc.tipco_codigo
        join proveedor p on p.pro_codigo=cc.pro_codigo
        join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
        join sucursal s on s.suc_codigo=cc.suc_codigo and s.emp_codigo=cc.emp_codigo
        join empresa e on e.emp_codigo=s.emp_codigo
        where cc.comp_codigo=compcodigo;
begin 
    -- Consultamos el monto y estado de la compra asociada
    select cp.cuenpa_monto into notaMonto from cuenta_pagar cp where cp.comp_codigo=compcodigo;
    select cc.comp_estado into compraEstado from compra_cab cc where cc.comp_codigo=compcodigo;	

    -- OPERACIÓN INSERT
    if operacion = 1 then
        -- Validamos si ya existe un detalle con los mismos datos
        perform 1 from nota_compra_det
        where it_codigo=itcodigo and tipit_codigo=tipitcodigo 
          and dep_codigo=depcodigo and suc_codigo=succodigo 
          and emp_codigo=empcodigo and nocom_codigo=nocomcodigo;
        if found then
            raise exception 'item'; -- ya existe, lanzamos error
        end if;

        -- Insertamos nuevo detalle
        insert into nota_compra_det(nocom_codigo, it_codigo, tipit_codigo, nocomdet_cantidad, 
									nocomdet_precio, dep_codigo, suc_codigo, emp_codigo)
        values(nocomcodigo, itcodigo, tipitcodigo, nocomdetcantidad, nocomdetprecio, depcodigo, succodigo, empcodigo);

        -- Ajustamos el stock según el tipo de comprobante
        if tipcocodigo = 1 then -- Nota de crédito: se descuenta del stock
            update stock set st_cantidad=st_cantidad-nocomdetcantidad 
            where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
              and suc_codigo=succodigo and emp_codigo=empcodigo;
			-- Auditamos nueva cantidad de stock
			select s.st_cantidad into cantidadStockAuditoria from stock s 
			where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
			 and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			-- Procedemos con el audit del registro modificado
			perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);

            -- Si el monto de la cuenta es 0, anulamos compra y cuenta pagar
            if notaMonto = 0 then 
                update cuenta_pagar set cuenpa_estado='ANULADO' where comp_codigo=compcodigo;
				-- Pasamos operacion 3 solo para auditar
                perform sp_cuenta_pagar(compcodigo, 0, 0, 3, usucodigo, usulogin);

                update compra_cab set comp_estado='ANULADO', usu_codigo=usucodigo where comp_codigo=compcodigo;
                -- Auditoría de compra cabecera
                for compra in c_compra_cab loop
                    select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
                    update compra_cab
                    set comp_audit = compAudit || '' || json_build_object(
                        'usu_codigo', usucodigo,
                        'usu_login', usulogin,
                        'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
                        'procedimiento', 'MODIFICACION',
                        'comp_fecha', compra.comp_fecha,
                        'comp_numfactura', compra.comp_numfactura,
                        'comp_timbrado', compra.comp_timbrado,
						'comp_timbrado_venc', compra.comp_timbrado_venc,
                        'comp_tipofactura', compra.comp_tipofactura,
                        'comp_cuota', compra.comp_cuota,
                        'comp_montocuota', compra.comp_montocuota,
                        'comp_interfecha', compra.comp_interfecha,
                        'tipco_codigo', compra.tipco_codigo,
                        'tipco_descripcion', compra.tipco_descripcion,
                        'pro_codigo', compra.pro_codigo,
                        'pro_razonsocial', compra.pro_razonsocial,
                        'tipro_codigo', compra.tipro_codigo,
                        'tipro_descripcion', compra.tipro_descripcion,
                        'emp_codigo', compra.emp_codigo,
                        'emp_razonsocial', compra.emp_razonsocial,
                        'suc_codigo', compra.suc_codigo,
                        'suc_descripcion', compra.suc_descripcion,
                        'comp_estado', compra.comp_estado
                    ) || ','
                    where comp_codigo = compcodigo;
                end loop;
            end if;

        elseif tipcocodigo = 2 then -- Nota de débito: se suma al stock
            update stock set st_cantidad=st_cantidad+nocomdetcantidad 
            where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
              and suc_codigo=succodigo and emp_codigo=empcodigo;
			-- Auditamos nueva cantidad de stock
			select s.st_cantidad into cantidadStockAuditoria from stock s 
			where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
			 and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			-- Procedemos con el audit del registro modificado
			perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);

            -- Si la compra estaba anulada pero hay monto, se reactivan registros
            if notaMonto > 0 and compraEstado = 'ANULADO' then
                update cuenta_pagar set cuenpa_estado='ACTIVO' where comp_codigo=compcodigo;
				-- Pasamos operacion 3 solo para auditar
                perform sp_cuenta_pagar(compcodigo, 0, 0, 3, usucodigo, usulogin);

                update compra_cab set comp_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;

                for compra in c_compra_cab loop
                    select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
                    update compra_cab
                    set comp_audit = compAudit || '' || json_build_object(
                        'usu_codigo', usucodigo,
                        'usu_login', usulogin,
                        'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
                        'procedimiento', 'MODIFICACION',
                        'comp_fecha', compra.comp_fecha,
                        'comp_numfactura', compra.comp_numfactura,
                        'comp_timbrado', compra.comp_timbrado,
						'comp_timbrado_venc', compra.comp_timbrado_venc,
                        'comp_tipofactura', compra.comp_tipofactura,
                        'comp_cuota', compra.comp_cuota,
                        'comp_montocuota', compra.comp_montocuota,
                        'comp_interfecha', compra.comp_interfecha,
                        'tipco_codigo', compra.tipco_codigo,
                        'tipco_descripcion', compra.tipco_descripcion,
                        'pro_codigo', compra.pro_codigo,
                        'pro_razonsocial', compra.pro_razonsocial,
                        'tipro_codigo', compra.tipro_codigo,
                        'tipro_descripcion', compra.tipro_descripcion,
                        'emp_codigo', compra.emp_codigo,
                        'emp_razonsocial', compra.emp_razonsocial,
                        'suc_codigo', compra.suc_codigo,
                        'suc_descripcion', compra.suc_descripcion,
                        'comp_estado', compra.comp_estado
                    ) || ','
                    where comp_codigo = compcodigo;
                end loop;
            end if;
        end if;

        raise notice 'LA NOTA DE COMPRA DETALLE FUE REGISTRADA CON EXITO';
    end if;

    -- OPERACIÓN DELETE
    if operacion = 2 then 
        -- Eliminamos el detalle
        delete from nota_compra_det 
        where nocom_codigo=nocomcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
          and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;

        -- Ajustamos stock según comprobante
        if tipcocodigo = 1 then -- Crédito: devolvemos al stock
            update stock set st_cantidad=st_cantidad+nocomdetcantidad 
            where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
              and suc_codigo=succodigo and emp_codigo=empcodigo;
			-- Auditamos nueva cantidad de stock
			select s.st_cantidad into cantidadStockAuditoria from stock s 
			where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
			 and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			-- Procedemos con el audit del registro modificado
			perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);

            if notaMonto > 0 and compraEstado = 'ANULADO' then	
                update cuenta_pagar set cuenpa_estado='ACTIVO' where comp_codigo=compcodigo;
                perform sp_cuenta_pagar(compcodigo, 0, 0, 3, usucodigo, usulogin);

                update compra_cab set comp_estado='ACTIVO', usu_codigo=usucodigo where comp_codigo=compcodigo;

                for compra in c_compra_cab loop
                    select coalesce(comp_audit, '') into compAudit from compra_cab where comp_codigo=compcodigo;
                    update compra_cab
                    set comp_audit = compAudit || '' || json_build_object(
                        'usu_codigo', usucodigo,
                        'usu_login', usulogin,
                        'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
                        'procedimiento', 'MODIFICACION',
                        'comp_fecha', compra.comp_fecha,
                        'comp_numfactura', compra.comp_numfactura,
                        'comp_timbrado', compra.comp_timbrado,
						'comp_timbrado_venc', compra.comp_timbrado_venc,
                        'comp_tipofactura', compra.comp_tipofactura,
                        'comp_cuota', compra.comp_cuota,
                        'comp_montocuota', compra.comp_montocuota,
                        'comp_interfecha', compra.comp_interfecha,
                        'tipco_codigo', compra.tipco_codigo,
                        'tipco_descripcion', compra.tipco_descripcion,
                        'pro_codigo', compra.pro_codigo,
                        'pro_razonsocial', compra.pro_razonsocial,
                        'tipro_codigo', compra.tipro_codigo,
                        'tipro_descripcion', compra.tipro_descripcion,
                        'emp_codigo', compra.emp_codigo,
                        'emp_razonsocial', compra.emp_razonsocial,
                        'suc_codigo', compra.suc_codigo,
                        'suc_descripcion', compra.suc_descripcion,
                        'comp_estado', compra.comp_estado
                    ) || ','
                    where comp_codigo = compcodigo;
                end loop;
            end if;

        elseif tipcocodigo = 2 then -- Débito: quitamos del stock
            update stock set st_cantidad=st_cantidad-nocomdetcantidad 
            where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
              and suc_codigo=succodigo and emp_codigo=empcodigo;
			-- Auditamos nueva cantidad de stock
			select s.st_cantidad into cantidadStockAuditoria from stock s 
			where s.it_codigo=itcodigo and s.tipit_codigo=tipitcodigo
			 and s.dep_codigo=depcodigo and s.suc_codigo=succodigo and s.emp_codigo=empcodigo;
			-- Procedemos con el audit del registro modificado
			perform sp_stock(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, cantidadStockAuditoria, 2, usucodigo, usulogin);
        end if;

        raise notice 'LA NOTA DE COMPRA DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

select sp_nota_compra_det(1, 1, 1, 5, 5000, 1);

--Procedimiento almacenado solicitud_presupuesto_cab
select * from solicitud_presupuesto_cab spc
where pedco_codigo=pedcocodigo and pro_codigo=procodigo 
and tipro_codigo=tiprocodigo and solpre_codigo != solprecodigo; 

select 
	spc.solpre_codigo,
	spc.solpre_fecha,
	spc.pedco_codigo as pedco_codigo2,
	spc.pro_codigo,
	spc.tipro_codigo,
	p.pro_razonsocial,
	p.pro_email as solpre_correo_proveedor,
	u.usu_login as usu_login2,
	s.suc_descripcion as suc_descripcion2,
	e.emp_razonsocial as emp_razonsocial2
from solicitud_presupuesto_cab spc 
	join pedido_compra_cab pcc on pcc.pedco_codigo=spc.pedco_codigo 
	join proveedor p on p.pro_codigo=spc.pro_codigo
	and p.tipro_codigo=spc.tipro_codigo 
	join usuario u on u.usu_codigo=spc.usu_codigo 
	join sucursal s on s.suc_codigo=spc.suc_codigo 
	and s.emp_codigo=spc.emp_codigo 
		join empresa e on e.emp_codigo=s.emp_codigo 
where pcc.pedco_estado = 'PENDIENTE'
order by spc.solpre_codigo;

select coalesce(max(solpre_codigo),0)+1 as solpre_codigo from solicitud_presupuesto_cab;

create or replace function sp_solicitud_presupuesto_cab(
    solprecodigo integer,
    pedcocodigo integer,
    procodigo integer,
    tiprocodigo integer,
    solprefecha date,
    solprecorreoproveedor varchar,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer
) returns void as
$function$
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		-- Validamos que no se repita el pedido y el proveedor
		perform * from solicitud_presupuesto_cab spc
		where pedco_codigo=pedcocodigo and pro_codigo=procodigo 
		and tipro_codigo=tiprocodigo and solpre_codigo != solprecodigo;
		if found then
			-- En caso de ser asi, generamos una excepcion
			raise exception 'pedido';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro
		elseif operacion = 1 then
			insert into solicitud_presupuesto_cab(solpre_codigo, pedco_codigo, pro_codigo, tipro_codigo, solpre_fecha, solpre_correo_proveedor,
			usu_codigo, suc_codigo, emp_codigo)
		 	values(solprecodigo, pedcocodigo, procodigo, tiprocodigo, solprefecha, solprecorreoproveedor, usucodigo, succodigo, empcodigo);
			-- Se envia un mensaje de confirmacion
		 	raise notice 'LA SOLICITUD DE PRESUPUESTO CABECERA YA SE REGISTRO, PUEDE PROCEDER CON EL DETALLE';
		end if;
    end if;
	-- Validamos la operacion de eliminacion
    if operacion = 2 then 
		-- Eliminamos el detalle de cabecera
		delete from solicitud_presupuesto_det where solpre_codigo=solprecodigo;
		-- Eliminamos la cabera
		delete from solicitud_presupuesto_cab where solpre_codigo=solprecodigo;
		-- Se envia un mensaje de confirmacion
		raise notice 'LA SOLICITUD DE PRESUPUESTO CABECERA FUE ELIMINADA CON SU RESPECTIVO DETALLE';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado solicitud_presupuesto_det
select 
	spc.pedco_codigo,
	to_char(spc.solpre_fecha, 'DD-MM-YYYY') as fecha_solicitud,
	spc.solpre_correo_proveedor,
	p.pro_razonsocial,
	p.pro_ruc,
	p.pro_direccion,
	s.suc_descripcion,
	s.suc_direccion,
	e.emp_razonsocial,
	e.emp_ruc 
from solicitud_presupuesto_cab spc 
join proveedor p on p.pro_codigo=spc.pro_codigo 
and p.tipro_codigo=spc.tipro_codigo 
join sucursal s on s.suc_codigo=spc.suc_codigo 
and s.emp_codigo=spc.emp_codigo 
join empresa e on e.emp_codigo=s.emp_codigo 
where spc.solpre_codigo=1;

select 
	spd.it_codigo,
	i.it_descripcion,
	spd.solpredet_cantidad,
	um.unime_descripcion
from solicitud_presupuesto_det spd 
	join items i on i.it_codigo=spd.it_codigo 
	and i.tipit_codigo=spd.tipit_codigo  
	join unidad_medida um on um.unime_codigo=i.unime_codigo 
	where spd.solpre_codigo=1
order by spd.solpre_codigo, spd.it_codigo;

select 
               spd.it_codigo as it_codigo2,
               spd.tipit_codigo as tipit_codigo2,
               i.it_descripcion as it_descripcion2,
               spd.solpredet_cantidad,
               ti.tipit_descripcion as tipit_descripcion2,
               um.unime_codigo as unime_codigo2,
               um.unime_descripcion as unime_descripcion2
            from solicitud_presupuesto_det spd 
               join items i on i.it_codigo=spd.it_codigo 
               and i.tipit_codigo=spd.tipit_codigo 
                  join tipo_item ti on ti.tipit_codigo=i.tipit_codigo 
                  join unidad_medida um on um.unime_codigo=i.unime_codigo 
            where spd.solpre_codigo=1
            order by spd.solpre_codigo, spd.it_codigo;

create or replace function sp_solicitud_presupuesto_det(
    solprecodigo integer,
    pedcocodigo integer,
    procodigo integer,
    tiprocodigo integer,
    itcodigo integer, 
    tipitcodigo integer,
    solpredetcantidad numeric,
    operacion integer
) returns void as
$function$
begin 
	 -- Validamos la operacion de insercion
     if operacion = 1 then
		-- Validamos que no se repita el ítem en el detalle
     	perform * from solicitud_presupuesto_det
     	where it_codigo=itcodigo and solpre_codigo=solprecodigo;
     	if found then
			 -- Si es asi, generamos una excepcion
     		 raise exception 'item';
		-- Si los parametros pasaron la validacion procedemos con la persistencia de un nuevo registro
     	elseif operacion = 1 then
		     insert into solicitud_presupuesto_det(solpre_codigo, pedco_codigo, pro_codigo, tipro_codigo, it_codigo, tipit_codigo, solpredet_cantidad)
			 values(solprecodigo, pedcocodigo, procodigo, tiprocodigo, itcodigo, tipitcodigo, solpredetcantidad);
			 raise notice 'LA SOLICITUD DE PRESUPUESTO DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	-- Validamos la operacion de eliminación
    if operacion = 2 then 
    	delete from solicitud_presupuesto_det	 
    	where solpre_codigo=solprecodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'LA SOLICITUD DE PRESUPUESTO DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado pedido produccion cabecera
create or replace function sp_pedido_produccion_cab(
    pedprocodigo integer,
    pedprofecha date,
    pedproestado varchar,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer --1:insert 2:delete
) returns void as
$function$
begin 
     if operacion = 1 then
	     insert into pedido_produccion_cab(pedpro_codigo, pedpro_fecha, pedpro_estado, usu_codigo, suc_codigo, emp_codigo)
		 values((select coalesce(max(pedpro_codigo),0)+1 from pedido_produccion_cab), pedprofecha, 'PENDIENTE',
		 usucodigo, succodigo, empcodigo);
		 raise notice 'EL PEDIDO DE PRODUCCION FUE REGISTRADO CON EXITO';
    end if;
    if operacion = 2 then 
    	update pedido_produccion_cab 
		set pedpro_estado='ANULADO'
		where pedpro_codigo=pedprocodigo;
		raise notice 'EL PEDIDO DE PRODUCCION FUE ANULADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

select sp_pedido_produccion_cab(1, '29/10/2023', 'PENDIENTE', 1, 1, 1, 2);

--Procedimiento almacenado pedido produccion detalle
create or replace function sp_pedido_produccion_det(
    pedprocodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    pedprodetcantidad numeric,
    pedprodetprecio numeric,
    operacion integer --1:insert 2:delete
) returns void as
$function$
begin 
     if operacion = 1 then
     	perform * from pedido_produccion_det
     	where it_codigo=itcodigo and pedpro_codigo=pedprocodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
		     insert into pedido_produccion_det(pedpro_codigo, it_codigo, tipit_codigo, pedprodet_cantidad, pedprodet_precio)
			 values(pedprocodigo, itcodigo, tipitcodigo, pedprodetcantidad, pedprodetprecio);
			 raise notice 'EL PEDIDO DE PRODUCCION DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
    if operacion = 2 then 
    	delete from pedido_produccion_det 
    	where pedpro_codigo=pedprocodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'EL PEDIDO DE PRODUCCION DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

select sp_pedido_produccion_det(1, 1, 1, 11, 5000, 1);

--Procedimiento almacenado presupuesto cabecera
select sp_presupuesto_cab(1, '2023-10-31', '2023-11-04', 'ACTIVO', 1, 4, 1, 1, 2, 3, 'scue', 'ALTA', '88889999', 'SIXTO BENITEZ SOSA',
'8 DE DICIEMBRE', 'CASA MATRIZ');
select coalesce(max(pres_codigo),0)+1 as pres_codigo from presupuesto_cab;
create or replace function sp_presupuesto_cab(
    prescodigo integer,
    presfecharegistro date,
    presfechavencimiento date,
    presestado varchar,
    pevencodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    clicodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    pernumerodocumento varchar,
    cliente varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare presAudit text;
		pevenAudit text;
		c_pedido cursor is
		select 
		pvc.peven_codigo,
		pvc.peven_fecha,
		pvc.peven_estado,
		pvc.cli_codigo,	
		p.per_nombre||''||p.per_apellido as cliente,
		p.per_numerodocumento
		from pedido_venta_cab pvc
		join cliente c on c.cli_codigo=pvc.cli_codigo
		join personas p on p.per_codigo=c.per_codigo
		where pvc.peven_codigo=pevencodigo;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		 --Validamos que la fecha de vencimiento no sea menor a la fecha de registro
     	 if presfechavencimiento < presfecharegistro then
			--En caso de que sea asi generamos una excepcion
     	 	raise exception 'fecha_mayor';
     	 end if;
		 --Validamos que no se repita el codigo de pedido venta junto al estado activo
   		 perform * from presupuesto_cab 
   		 where peven_codigo=pevencodigo and pres_estado='ACTIVO';
   		 if found then
			--En caso de que sea asi generamos una excepcion
   		 	raise exception 'pedido';
   		 elseif operacion = 1 then
   		     --Insertamos cabecera 
		     insert into presupuesto_cab(pres_codigo, pres_fecharegistro, pres_fechavencimiento, pres_estado, peven_codigo,
		     usu_codigo, suc_codigo, emp_codigo, cli_codigo)
			 values(prescodigo, presfecharegistro, presfechavencimiento, 'ACTIVO', 
			 pevencodigo, usucodigo, succodigo, empcodigo, clicodigo);
			 --Actualizamos el estado del pedido de venta seleccionado
			 update pedido_venta_cab set peven_estado='PRESUPUESTADO', usu_codigo=usucodigo where peven_codigo=pevencodigo;
		 	 --Enviamos un mensaje de confirmacion
			 raise notice 'EL PRESUPUESTO DE PRODUCCION FUE REGISTRADO CON EXITO';
		 end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--En este caso realizamos un borrado logico
    	update presupuesto_cab 
		set pres_estado='ANULADO', usu_codigo=usucodigo
		where pres_codigo=prescodigo;
		--Actualizamos el estado del pedido de venta asociado a cabecera
	    update pedido_venta_cab set peven_estado='PENDIENTE', usu_codigo=usucodigo where peven_codigo=pevencodigo;
		--Enviamos un mensaje de confirmacion
		raise notice 'EL PRESUPUESTO DE PRODUCCION FUE ANULADO CON EXITO';
    end if;
	--consultamos el audit anterior
	select coalesce(pres_audit, '') into presAudit from presupuesto_cab where pres_codigo=prescodigo;
	--a los datos anteriores le agregamos los nuevos
	update presupuesto_cab 
	set pres_audit = presAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'pres_fecharegistro', presfecharegistro,
		'pres_fechavencimiento', presfechavencimiento,
		'peven_codigo', pevencodigo,
		'cli_codigo', clicodigo,
		'cliente', upper(cliente),
		'per_numerodocumento', pernumerodocumento,
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'pres_estado', upper(presestado)
	)||','
	where pres_codigo = prescodigo;
	--Auditamos pedido venta cabecera
	--consultamos el audit anterior de pedido venta cabecera
	select coalesce(peven_audit, '') into pevenAudit from pedido_venta_cab where peven_codigo=pevencodigo;
	--a los datos anteriores le agregamos los nuevos
	--Recorremos el cursor y auditamos los datos
	for ped in c_pedido loop
		update pedido_venta_cab 
		set peven_audit = pevenAudit||''||json_build_object(
			'usu_codigo', usucodigo,
			'usu_login', usulogin,
			'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
			'procedimiento', 'MODIFICACION',
			'peven_fecha', ped.peven_fecha,
			'cli_codigo', ped.cli_codigo,
			'cliente', ped.cliente,
			'per_numerodocumento', ped.per_numerodocumento,
			'emp_codigo', empcodigo,
			'emp_razonsocial', upper(emprazonsocial),
			'suc_codigo', succodigo,
			'suc_descripcion', upper(sucdescripcion),
			'peven_estado', ped.peven_estado
		)||','
		where peven_codigo = pevencodigo;
	end loop;
end
$function$ 
language plpgsql;

select * from sp_presupuesto_cab();

--Procedimiento almacenado presupuesto detalle
select sp_presupuesto_det(1, 2, 2, 5, 70000, 1);

create or replace function sp_presupuesto_det(
    prescodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    presdetcantidad integer,
    presdetprecio numeric,
    operacion integer --1:insert 2:delete
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si existe el item en caso de que si generamos una excepcion
     	perform * from presupuesto_det
     	where it_codigo=itcodigo and pres_codigo=prescodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
		     insert into presupuesto_det(pres_codigo, it_codigo, tipit_codigo, presdet_cantidad, presdet_precio)
			 values(prescodigo, itcodigo, tipitcodigo, presdetcantidad, presdetprecio);
			 raise notice 'EL PRESUPUESTO PRODUCCION DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from presupuesto_det	 
    	where pres_codigo=prescodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'EL PRESUPUESTO PRODUCCION DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado orden produccion cabecera
select sp_orden_produccion_cab(1, '01/11/2023', '02/11/2023', '06/11/2023', 'activo', 4, 1, 1, 1, 1, 1, 2);

select it_codigo, tipit_codigo, orcomdet_cantidad from orden_compra_det ocd where ocd.orcom_codigo=1;
select 
	it_codigo,
	tipit_codigo,
	orprodet_cantidad 
from orden_produccion_det opd
where orpro_codigo=1;

select coalesce(max(orpro_codigo),0)+1 as orpro_codigo from orden_produccion_cab;
create or replace function sp_orden_produccion_cab(
    orprocodigo integer,
    orprofecha date,
    orprofechainicio date,
    orprofechaculminacion date,
    orproestado varchar,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    secccodigo integer,
    prescodigo integer,
    pevencodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    seccdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare orproAudit text;
		presAudit text;
		pevenAudit text;
		ultCodOrdenPresupuesto integer;
		comproCodigo integer;
		cantidadMateriaPrima numeric;
		filaComponenteProduccionDetalle record;
		c_presupuesto cursor is
		select 
		pc.pres_fecharegistro,
		pc.pres_fechavencimiento,
		pc.peven_codigo,
		pc.cli_codigo,
		p.per_nombre||' '||p.per_apellido as cliente,
		p.per_numerodocumento,
		pc.pres_estado 
		from presupuesto_cab pc
		join cliente c on c.cli_codigo=pc.cli_codigo
		join personas p on p.per_codigo=c.per_codigo
		where pc.pres_codigo=prescodigo;
		c_pedido cursor is
		select 
		pvc.peven_fecha,
		pvc.peven_estado,
		pvc.cli_codigo,
		p.per_nombre||' '||p.per_apellido as cliente,
		p.per_numerodocumento
		from pedido_venta_cab pvc
		join cliente c on c.cli_codigo=pvc.cli_codigo
		join personas p on p.per_codigo=c.per_codigo
		where pvc.peven_codigo=pevencodigo;
		c_orden cursor is
		select 
		it_codigo,
		tipit_codigo,
		dep_codigo,
		suc_codigo,
		emp_codigo,
		orprodet_cantidad 
		from orden_produccion_det opd
		where orpro_codigo=orprocodigo;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		 ultCodOrdenPresupuesto := (select coalesce(max(orpre_codigo),0)+1 from orden_presupuesto);
		 --Validamos que la fecha registro no sea mayor a la fecha de inicio
		 if orprofecha > orprofechainicio then
			--En caso de ser asi, lanzamos una excepcion
     	 	raise exception 'fecha_registro';
     	 end if;
		 --Validamos que la fecha de inicio no sea mayor a la fecha de culminacion
         if orprofechainicio > orprofechaculminacion then
			--En caso de ser asi, lanzamos una excepcion
     	 	raise exception 'fecha_inicio';
     	 end if;
     	 --Una vez pasada la validacion, insertamos un nuevo registro en cabecera
	     insert into orden_produccion_cab(orpro_codigo, orpro_fecha, orpro_fechainicio, orpro_fechaculminacion, orpro_estado,
	     usu_codigo, suc_codigo, emp_codigo, secc_codigo)
		 values(orprocodigo, orprofecha, orprofechainicio, orprofechaculminacion, 'ACTIVO', usucodigo, succodigo, empcodigo, secccodigo);
		 --Insertamos nuevo registro en orden presupuesto
		 insert into orden_presupuesto(orpre_codigo, orpro_codigo, pres_codigo)
		 values(ultCodOrdenPresupuesto, orprocodigo, prescodigo);
		 --Actualizamos el estado de presupuesto 
		 update presupuesto_cab set pres_estado='APROBADO', usu_codigo=usucodigo where pres_codigo=prescodigo;
		 --Actualizamos el estado del pedido venta que se haya ordenado
		 update pedido_venta_cab set peven_estado='APROBADO', usu_codigo=usucodigo where peven_codigo=pevencodigo;
		 --Auditamos orden presupuesto
		 update orden_presupuesto 
			 set orpre_audit = json_build_object(
				'usu_codigo', usucodigo,
				'usu_login', usulogin,
				'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
				'procedimiento', 'ALTA',
				'orpro_codigo', orprocodigo,
				'pres_codigo', prescodigo
			 )
			 where orpre_codigo = ultCodOrdenPresupuesto;
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA ORDEN DE PRODUCCION FUE REGISTRADA CON EXITO';
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--En esta caso realizamos un borrado logico
    	update orden_produccion_cab 
		set orpro_estado='ANULADO', usu_codigo=usucodigo
		where orpro_codigo=orprocodigo;
		--Actualizamos el estado de presupuesto 
	    update presupuesto_cab set pres_estado='ACTIVO', usu_codigo=usucodigo where pres_codigo=prescodigo;
		--Actualizamos el estado del pedido venta que se asocio a la orden una vez anulada
	    update pedido_venta_cab set peven_estado='PRESUPUESTADO', usu_codigo=usucodigo where peven_codigo=pevencodigo;
		--Actualizamos el stock, en caso de que se tenga registros asociados en el detalle
		for ord in c_orden loop
			--Sacamos el codigo de componente produccion para individualizar las materias primas por producto
			comproCodigo := (select cpc.compro_codigo from componente_produccion_cab cpc where cpc.it_codigo=ord.it_codigo and cpc.tipit_codigo=ord.tipit_codigo);
			--Sacamos la materia prima por producto
			for filaComponenteProduccionDetalle in select it_codigo, tipit_codigo, comprodet_cantidad 
			from componente_produccion_det cpd where compro_codigo=comproCodigo loop
				--Definimos la cantidad a sumar de materia prima
				cantidadMateriaPrima := ord.orprodet_cantidad * filaComponenteProduccionDetalle.comprodet_cantidad;
				--Actualizamos el stock
		        update stock set st_cantidad=st_cantidad+cantidadMateriaPrima 
				where it_codigo=filaComponenteProduccionDetalle.it_codigo and tipit_codigo=filaComponenteProduccionDetalle.tipit_codigo 
				and dep_codigo=ord.dep_codigo and suc_codigo=ord.suc_codigo and emp_codigo=ord.emp_codigo;
				--Reinciamos la variable cantidadMateriaPrima
				cantidadMateriaPrima := 0;
			end loop;
		end loop;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA ORDEN DE PRODUCCION FUE ANULADA CON EXITO';
    end if;
	--Consultamos el audit anterior
	select coalesce(orpro_audit, '') into orproAudit from orden_produccion_cab where orpro_codigo=orprocodigo;
	--a los datos anteriores le agregamos los nuevos
	update orden_produccion_cab 
	set orpro_audit = orproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'orpro_fecha', orprofecha,
		'orpro_fechainicio', orprofechainicio,
		'orpro_fechaculminacion', orprofechaculminacion,
		'secc_codigo', secccodigo,
		'secc_descripcion', upper(seccdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'orpro_estado', upper(orproestado)
	)||','
	where orpro_codigo = orprocodigo;
	--Auditamos presupuesto cabecera
	--Consultamos el audit anterior de presupuesto cabecera
	select coalesce(pres_audit, '') into presAudit from presupuesto_cab where pres_codigo=prescodigo;
	--a los datos anteriores le agregamos los nuevos
	--Recorremos el cursor y auditamos los datos
	for pre in c_presupuesto loop
		update presupuesto_cab 
		set pres_audit = presAudit||''||json_build_object(
			'usu_codigo', usucodigo,
			'usu_login', usulogin,
			'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
			'procedimiento', 'MODIFICACION',
			'pres_fecharegistro', pre.pres_fecharegistro,
			'pres_fechavencimiento', pre.pres_fechavencimiento,
			'peven_codigo', pre.peven_codigo,
			'cli_codigo', pre.cli_codigo,
			'cliente', pre.cliente,
			'per_numerodocumento', pre.per_numerodocumento,
			'emp_codigo', empcodigo,
			'emp_razonsocial', upper(emprazonsocial),
			'suc_codigo', succodigo,
			'suc_descripcion', upper(sucdescripcion),
			'pres_estado', pre.pres_estado
		)||','
		where pres_codigo = prescodigo;
	end loop;
	--Auditamos pedido venta cabecera
	--consultamos el audit anterior de pedido venta cabecera
	select coalesce(peven_audit, '') into pevenAudit from pedido_venta_cab where peven_codigo=pevencodigo;
	--a los datos anteriores le agregamos los nuevos
	--Recorremos el cursor y auditamos los datos
	for ped in c_pedido loop
		update pedido_venta_cab 
		set peven_audit = pevenAudit||''||json_build_object(
			'usu_codigo', usucodigo,
			'usu_login', usulogin,
			'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
			'procedimiento', 'MODIFICACION',
			'peven_fecha', ped.peven_fecha,
			'cli_codigo', ped.cli_codigo,
			'cliente', ped.cliente,
			'per_numerodocumento', ped.per_numerodocumento,
			'emp_codigo', empcodigo,
			'emp_razonsocial', upper(emprazonsocial),
			'suc_codigo', succodigo,
			'suc_descripcion', upper(sucdescripcion),
			'peven_estado', ped.peven_estado
		)||','
		where peven_codigo = pevencodigo;
	end loop;
end
$function$ 
language plpgsql;

--Procedimiento almacenado orden produccion detalle
select sp_orden_produccion_det(1, 2, 2, 'Cierre negro', 5, 1);

select cpc.compro_codigo from componente_produccion_cab cpc where cpc.it_codigo=2 and cpc.tipit_codigo=2;

select cpd.it_codigo, cpd.tipit_codigo, cpd.comprodet_cantidad from componente_produccion_det cpd where cpd.compro_codigo=1;

create or replace function sp_orden_produccion_det(
    orprocodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    orprodetespecificacion varchar,
    orprodetcantidad integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer 
) returns void as
$function$
declare comproCodigo integer;
		filaComponenteProduccionDetalle record;
		cantidadMateriaPrima numeric;
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si existe el item en caso de que si generamos una excepcion
     	perform * from orden_produccion_det
     	where it_codigo=itcodigo and orpro_codigo=orprocodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
			--En caso de que no se genere una excepcion, insertamos en nuevo registro en orden produccion detalle
		     insert into orden_produccion_det(
			 orpro_codigo, 
			 it_codigo, 
			 tipit_codigo, 
			 orprodet_especificacion, 
			 orprodet_cantidad,
			 dep_codigo,
			 suc_codigo,
			 emp_codigo	
			 )
			 values(
			 orprocodigo, 
			 itcodigo, 
			 tipitcodigo, 
			 upper(orprodetespecificacion), 
			 orprodetcantidad,
			 depcodigo,
			 succodigo,
			 empcodigo
			 );
			 --Al insertar el registro en orden produccion detalle procedemos a cargar de forma automatica orden produccion detalle2
			 --Traemos el codigo de componente produccion en base al item del detalle
			 comproCodigo := (select cpc.compro_codigo from componente_produccion_cab cpc where cpc.it_codigo=itcodigo and cpc.tipit_codigo=tipitcodigo);
			 --Creamos un loop en el cual traemos la materia prima a utilizar por producto de componente produccion detalle
			 for filaComponenteProduccionDetalle in select it_codigo, tipit_codigo, comprodet_cantidad 
			 from componente_produccion_det cpd where compro_codigo=comproCodigo loop
			 --Definimmos la cantidad de materia prima a utilizar
			 cantidadMateriaPrima := orprodetcantidad * filaComponenteProduccionDetalle.comprodet_cantidad;
			 --Una vez definido los datos a traer en el loop procedemos a cargar orden produccion detalle2 con la materia prima a utilizar para realizar el 
			 --producto definido en el registro de orden produccion detalle
			 perform sp_orden_produccion_det2(
			 orprocodigo, 
			 comproCodigo, 
			 filaComponenteProduccionDetalle.it_codigo, 
			 filaComponenteProduccionDetalle.tipit_codigo,
			 cantidadMateriaPrima,
			 1
			 );
			 --Descontamos la cantidad de stoct
             update stock set st_cantidad=st_cantidad-cantidadMateriaPrima 
			 where it_codigo=filaComponenteProduccionDetalle.it_codigo and tipit_codigo=filaComponenteProduccionDetalle.tipit_codigo 
			 and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
			 --Reinciamos la variable cantidadMateriaPrima
			 cantidadMateriaPrima := 0;
			 end loop;
			 --Enviamos un mensaje de aviso al insertar el registro en detalle
			 raise notice 'LA ORDEN DE PRODUCCION DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from orden_produccion_det	 
    	where orpro_codigo=orprocodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		--Al eliminar el registro en orden produccion detalle procedemos a elimiar de forma automatica orden produccion detalle2
		--Traemos el codigo de componente produccion en base al item del detalle
		comproCodigo := (select cpc.compro_codigo from componente_produccion_cab cpc where cpc.it_codigo=itcodigo and cpc.tipit_codigo=tipitcodigo);
		--Creamos un loop en el cual traemos la materia prima a utilizar por producto de componente produccion detalle
		for filaComponenteProduccionDetalle in select it_codigo, tipit_codigo, comprodet_cantidad 
			from componente_produccion_det cpd where compro_codigo=comproCodigo loop
			--Definimmos la cantidad de materia prima a restablecer en stock
			cantidadMateriaPrima := orprodetcantidad * filaComponenteProduccionDetalle.comprodet_cantidad;
			--Una vez definido los datos a traer en el loop procedemos a eliminar registros en orden produccion detalle2 
			perform sp_orden_produccion_det2(
			orprocodigo, 
			comproCodigo, 
			filaComponenteProduccionDetalle.it_codigo, 
			filaComponenteProduccionDetalle.tipit_codigo,
			cantidadMateriaPrima,
			2
			);
			--Sumamos la cantidad de stock que se resto
	        update stock set st_cantidad=st_cantidad+cantidadMateriaPrima 
			where it_codigo=filaComponenteProduccionDetalle.it_codigo and tipit_codigo=filaComponenteProduccionDetalle.tipit_codigo 
			and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
			--Reinciamos la variable cantidadMateriaPrima
			cantidadMateriaPrima := 0;
		end loop;
		--Enviamos un  mensaje de aviso al eliminar el registro en detalle
		raise notice 'LA ORDEN DE PRODUCCION DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado orden produccion detalle2
create or replace function sp_orden_produccion_det2(
    orprocodigo integer,
    comprocodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    orprodet2cantidad numeric,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Insertamos los nuevos registros
		insert into orden_produccion_det2(
		orpro_codigo, 
		compro_codigo, 
		it_codigo, 
		tipit_codigo, 
		orprodet2_cantidad
		)
		values(
		orprocodigo, 
		comprocodigo, 
		itcodigo, 
		tipitcodigo, 
		orprodet2cantidad
		);
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from orden_produccion_det2	 
    	where orpro_codigo=orprocodigo and compro_codigo=comprocodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado produccion cabecera
select sp_produccion_cab(1, '02/11/2023', 'ACTIVO', 1, 4, 1, 1, 2);
select coalesce(max(prod_codigo),0)+1 as prod_codigo from produccion_cab;
create or replace function sp_produccion_cab(
    prodcodigo integer,
    prodfecha date,
    prodestado varchar,
    orprocodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    seccdescripcion varchar,
    orprofechainicio date,
    orprofechaculminacion date,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare prodAudit text;
		orproAudit text;
		c_orden cursor is
		select 
		opc.orpro_fecha,
		opc.orpro_fechainicio,
		opc.orpro_fechaculminacion,
		opc.secc_codigo,
		s.secc_descripcion,
		opc.orpro_estado
		from orden_produccion_cab opc 
		join seccion s on s.secc_codigo=opc.secc_codigo 
		where orpro_codigo=orprocodigo;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya se encuentra registrado la orden de produccion y si su estado es igual a activo
     	perform * from produccion_cab
     	where orpro_codigo=orprocodigo and prod_estado='ACTIVO';
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'orden';
     	elseif operacion = 1 then
     	 --Una vez pasada la validacion, insertamos un nuevo registro en cabecera
	     insert into produccion_cab(
		 prod_codigo, 
		 prod_fecha, 
		 prod_estado, 
		 orpro_codigo, 
		 usu_codigo,
	     suc_codigo, 
		 emp_codigo
		 )
		 values(
		 prodcodigo, 
		 prodfecha, 
		 'ACTIVO',
		 orprocodigo, 
		 usucodigo, 
		 succodigo, 
		 empcodigo
         );
		 --Actualizamos el estado de la orden de produccion asociada a la produccion
		 update orden_produccion_cab set orpro_estado='EN PRODUCCION', usu_codigo=usucodigo where orpro_codigo=orprocodigo; 
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA PRODUCCION FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--En esta caso realizamos un borrado logico
    	update produccion_cab 
		set prod_estado='ANULADO', usu_codigo=usucodigo
		where prod_codigo=prodcodigo;
		--Actualizamos el estado de la orden de producciona asociada a la produccion anulada
		update orden_produccion_cab set orpro_estado='ACTIVO', usu_codigo=usucodigo where orpro_codigo=orprocodigo;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA PRODUCCION FUE ANULADA CON EXITO';
    end if;
	--Al terminar la insercion o anulacion de la cabecera, procedemos a uditar el mismo
	--Consultamos el audit anterior
	select coalesce(prod_audit, '') into prodAudit from produccion_cab where prod_codigo=prodcodigo;
	--a los datos anteriores le agregamos los nuevos
	update produccion_cab 
	set prod_audit = prodAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'prod_fecha', prodfecha,
		'orpro_codigo', orprocodigo,
		'secc_descripcion', upper(seccdescripcion),
		'orpro_fechainicio', orprofechainicio,
		'orpro_fechaculminacion', orprofechaculminacion,
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'prod_estado', upper(prodestado)
	)||','
	where prod_codigo = prodcodigo;
	--Auditamos orden produccion cabecera
	--Consultamos el audit anterior
	select coalesce(orpro_audit, '') into orproAudit from orden_produccion_cab where orpro_codigo=orprocodigo;
	--a los datos anteriores le agregamos los nuevos
	for ord in c_orden loop
		update orden_produccion_cab 
		set orpro_audit = orproAudit||''||json_build_object(
			'usu_codigo', usucodigo,
			'usu_login', usulogin,
			'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
			'procedimiento', 'MODIFICACION',
			'orpro_fecha', ord.orpro_fecha,
			'orpro_fechainicio', ord.orpro_fechainicio,
			'orpro_fechaculminacion', ord.orpro_fechaculminacion,
			'secc_codigo', ord.secc_codigo,
			'secc_descripcion', ord.secc_descripcion,
			'emp_codigo', empcodigo,
			'emp_razonsocial', upper(emprazonsocial),
			'suc_codigo', succodigo,
			'suc_descripcion', upper(sucdescripcion),
			'orpro_estado', ord.orpro_estado
		)||','
		where orpro_codigo = orprocodigo;
	end loop;
end
$function$ 
language plpgsql;

--Procedimiento almacenado produccion detalle

select sp_produccion_det(1, 2, 2, 5, '02/11/2023', '04/11/2023', 'SIN OBS', 1);
create or replace function sp_produccion_det(
    prodcodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    prodetcantidad integer,
    prodetfechainicio date,
    prodetfechafinal date,
    prodetobservacion varchar,
    prodetestado varchar,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si la fecha de incio es mayor a la fecha final
		if prodetfechainicio > prodetfechafinal then
			--En caso de ser asi generamos una excepcion 
			raise exception 'fecha_mayor';
		end if;
		--Validamos que el item no se repita en detalle
     	perform * from produccion_det
     	where it_codigo=itcodigo and prod_codigo=prodcodigo;
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
			 --Insertamos el nuevo registro
		     insert into produccion_det(
			 prod_codigo, 
			 it_codigo, 
			 tipit_codigo, 
			 prodet_cantidad, 
			 prodet_fechainicio, 
		     prodet_fechafinal, 
			 prodet_observacion,
			 prodet_estado
			 )
			 values(
			 prodcodigo, 
			 itcodigo, 
		  	 tipitcodigo, 
			 prodetcantidad, 
			 prodetfechainicio, 
			 prodetfechafinal, 
			 prodetobservacion,
			 prodetestado
			 );
			 --Enviamos un  mensaje de aviso al insertar el registro en detalle
			 raise notice 'LA PRODUCCION DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Validamos que el estado del detalle sea terminado
		if prodetestado = 'TERMINADO' then
			--En caso de ser asi generamos una excepcion 
			raise exception 'cancelar';
		end if;
		--Realizamos un borrado fisico el cual se audita
    	delete from produccion_det 
    	where prod_codigo=prodcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		--Enviamos un  mensaje de aviso al eliminar el registro en detalle
		raise notice 'LA PRODUCCION DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado etapa produccion
select sp_etapa_produccion(1, 2, 2, 1, '04/11/2023', 'ACTIVO', 4, 1, 1, 8, 1);
create or replace function sp_etapa_produccion(
    prodcodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    tipetcodigo integer,
    etprofecha date,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    maqcodigo integer,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos que no se repita la produccion, el producto y la etapa
     	perform * from etapa_produccion
     	where (prod_codigo=prodcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo and tipet_codigo=tipetcodigo);
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'produccion_etapa';
     	elseif operacion = 1 then
		 --Una vez pasada la validacion, insertamos un nuevo registro 
	     insert into etapa_produccion(
		 prod_codigo, 
		 it_codigo, 
		 tipit_codigo, 
		 tipet_codigo, 
		 etpro_fecha, 
		 usu_codigo, 
		 suc_codigo, 
		 emp_codigo, 
		 maq_codigo
		 )
		 values(
		 prodcodigo, 
		 itcodigo, 
		 tipitcodigo, 
		 tipetcodigo, 
		 etprofecha, 
	     usucodigo, 
		 succodigo, 
	     empcodigo, 
		 maqcodigo
		 );
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA ETAPA DE PRODUCCION FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--En esta caso realizamos un borrado fisico el cual se audita
    	delete from etapa_produccion 
		where prod_codigo=prodcodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo and tipet_codigo=tipetcodigo;
		--Enviamos un mensaje de confirmacion de eliminacion
		raise notice 'LA ETAPA DE PRODUCCION FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado produccion terminada cabecera
select 
from orden_produccion_cab opc 
where opc.orpro_estado = 'TERMINADO'
and opc.orpro_codigo not in (select pc.orpro_codigo from produccion_cab pc);

select pc.orpro_codigo from produccion_cab pc;

create or replace function sp_produccion_terminada_cab(
    protercodigo integer,
    proterfecha date,
    proterfechaculminacion date,
    proterestado varchar,
    prodcodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    seccdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare proterAudit text;
		produccionTerminadaDetalle record;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya se encuentra registrado la produccion y si su estado es igual a activo
     	perform * from produccion_terminada_cab
     	where prod_codigo=prodcodigo and proter_estado='ACTIVO';
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'produccion';
     	elseif operacion = 1 then
     	 --Una vez pasada la validacion, insertamos un nuevo registro en cabecera
	     insert into produccion_terminada_cab(
		 proter_codigo, 
		 proter_fecha, 
		 proter_fechaculminacion,
		 proter_estado, 
		 prod_codigo, 
		 usu_codigo,
	     suc_codigo, 
		 emp_codigo
		 )
		 values(
		 protercodigo, 
		 proterfecha,
		 proterfechaculminacion,
		 'ACTIVO',
		 prodcodigo, 
		 usucodigo, 
		 succodigo, 
		 empcodigo
         );
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA CABECERA DE PRODUCCION TERMINADA FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de anulacion
    if operacion = 2 then
		--En este caso realizamos un borrado logico
    	update produccion_terminada_cab 
		set proter_estado='ANULADO', usu_codigo=usucodigo
		where proter_codigo=protercodigo;
		--Actualizamos el stock en caso de que en detalle se haya sumado
	    for produccionTerminadaDetalle in select * from produccion_terminada_det where proter_codigo=protercodigo loop
	       	update stock set st_cantidad=st_cantidad-produccionTerminadaDetalle.proterdet_cantidad 
			where it_codigo=produccionTerminadaDetalle.it_codigo and tipit_codigo=produccionTerminadaDetalle.tipit_codigo 
			and dep_codigo=produccionTerminadaDetalle.dep_codigo and suc_codigo=produccionTerminadaDetalle.suc_codigo 
			and emp_codigo=produccionTerminadaDetalle.emp_codigo;
        end loop;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA CABECERA DE PRODUCCION TERMINADA FUE ANULADA CON EXITO';
    end if;
	--Al terminar la insercion o anulacion de la cabecera, procedemos a auditar el mismo
	--Consultamos el audit anterior
	select coalesce(proter_audit, '') into proterAudit from produccion_terminada_cab where proter_codigo=protercodigo;
	--a los datos anteriores le agregamos los nuevos
	update produccion_terminada_cab 
	set proter_audit = proterAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'proter_fecha', proterfecha,
		'proter_fechaculminacion', proterfechaculminacion,
		'prod_codigo', prodcodigo,
		'secc_descripcion', upper(seccdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'proter_estado', upper(proterestado)
	)||','
	where proter_codigo = protercodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado produccion terminada detalle 
create or replace function sp_produccion_terminada_det(
    protercodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    proterdetcantidad integer,
    operacion integer
) returns void as
$function$
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si no se repite el item en detalle
     	perform * from produccion_terminada_det
     	where it_codigo=itcodigo and proter_codigo=protercodigo;
     	if found then
     		 raise exception 'item';
     	elseif operacion = 1 then
			 --Buscamos si es que en stock se encuentra registrado el producto
			 perform * from stock
     		 where it_codigo=itcodigo and tipit_codigo=tipitcodigo 
			 and dep_codigo=depcodigo and suc_codigo=succodigo 
			 and emp_codigo=empcodigo;
			 --Si el produco ya se encuentra registrado en stock procedemos a sumar la cantidad
			 if found then
				 --Actualizamos el stock 
				 update stock set st_cantidad=st_cantidad+proterdetcantidad 
				 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
				 and suc_codigo=succodigo and emp_codigo=empcodigo;
			 else	
				--Cargamos el nuevo ítem en stock
				insert into stock(it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo, st_cantidad)
				values(itcodigo, tipitcodigo, depcodigo, succodigo, empcodigo, proterdetcantidad);
             end if;
     	 	 --Insertamos produccion terminada detalle
		     insert into produccion_terminada_det(
			 proter_codigo, 
			 it_codigo, 
			 tipit_codigo, 
			 dep_codigo, 
			 suc_codigo,
		     emp_codigo, 
			 proterdet_cantidad
			 )
			 values(
			 protercodigo, 
			 itcodigo, 
			 tipitcodigo, 
			 depcodigo, 
			 succodigo, 
			 empcodigo, 
			 proterdetcantidad
			 );
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'EL PRODUCTO FUE REGISTRADO CON EXITO EN PRODUCCION TERMINADA DETALLE';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
    	--En este caso realizamos un borrado fisico que se audita
    	delete from produccion_terminada_det 
    	where proter_codigo=protercodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
        and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
       	--Actualizamos el stock 
		update stock set st_cantidad=st_cantidad-proterdetcantidad 
		where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		and suc_codigo=succodigo and emp_codigo=empcodigo;
		--Enviamos un mensaje de confirmacion de eliminacion
		raise notice 'EL PRODUCTO FUE ELIMINADO CON EXITO EN PRODUCCION TERMINADA DETALLE';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado mermas cabecera
create or replace function sp_mermas_cab(
    mercodigo integer,
    merfecha date,
    merestado varchar,
    protercodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    seccdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare merAudit text;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya se encuentra registrado la produccion terminada y si su estado es igual a activo
     	perform * from mermas_cab
     	where proter_codigo=protercodigo and mer_estado='ACTIVO';
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'produccion_terminada';
     	elseif operacion = 1 then
     	 --Una vez pasada la validacion, insertamos un nuevo registro en cabecera
	     insert into mermas_cab(
		 mer_codigo, 
		 mer_fecha, 
		 mer_estado, 
		 proter_codigo, 
		 usu_codigo,
	     suc_codigo, 
		 emp_codigo
		 )
		 values(
		 mercodigo, 
		 merfecha,
		 'ACTIVO',
		 protercodigo, 
		 usucodigo, 
		 succodigo, 
		 empcodigo
         );
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA CABECERA DE MERMAS FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de anulacion
    if operacion = 2 then
		--En este caso realizamos un borrado logico
    	update mermas_cab 
		set mer_estado='ANULADO', usu_codigo=usucodigo
		where mer_codigo=mercodigo;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA CABECERA DE MERMAS FUE ANULADA CON EXITO';
    end if;
	--Al terminar la insercion o anulacion de la cabecera, procedemos a auditar el mismo
	--Consultamos el audit anterior
	select coalesce(mer_audit, '') into merAudit from mermas_cab where mer_codigo=mercodigo;
	--a los datos anteriores le agregamos los nuevos
	update mermas_cab 
	set mer_audit = merAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'mer_fecha', merfecha,
		'proter_codigo', protercodigo,
		'secc_descripcion', upper(seccdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'mer_estado', upper(merestado)
	)||','
	where mer_codigo = mercodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado mermas detalle
create or replace function sp_mermas_det(
    mercodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    merdetcantidad numeric,
    merdetprecio numeric,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si existe el item en caso de que si generamos una excepcion
     	perform * from mermas_det
     	where it_codigo=itcodigo and mer_codigo=mercodigo;
     	if found then
     		 raise exception 'item';
		--Si no existe el item insertamos el mismo en el detalle
     	elseif operacion = 1 then
		     insert into mermas_det(
			 mer_codigo, 
			 it_codigo, 
			 tipit_codigo, 
			 merdet_cantidad, 
			 merdet_precio
			 )
			 values(
			 mercodigo, 
			 itcodigo, 
			 tipitcodigo, 
			 merdetcantidad, 
			 merdetprecio
			 );
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'LA MATERIA PRIMA FUE REGISTRADA CON EXITO EN MERMAS DETALLE';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from mermas_det 
    	where mer_codigo=mercodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'LA MATERIA PRIMA FUE ELIMINADA CON EXITO EN MERMAS DETALLE';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado control calidad cabecera
select coalesce(max(conca_codigo),0)+1 as conca_codigo from control_calidad_cab;
create or replace function sp_control_calidad_cab(
    concacodigo integer,
    concafecha date,
    concaestado varchar,
    protercodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    seccdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare concaAudit text;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya se encuentra registrado la produccion terminada y si su estado es igual a activo
     	perform * from control_calidad_cab
     	where proter_codigo=protercodigo and conca_estado='ACTIVO';
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'produccion_terminada';
     	elseif operacion = 1 then
     	 --Una vez pasada la validacion, insertamos un nuevo registro en cabecera
	     insert into control_calidad_cab(
		 conca_codigo, 
		 conca_fecha, 
		 conca_estado, 
		 proter_codigo, 
		 usu_codigo,
	     suc_codigo, 
		 emp_codigo
		 )
		 values(
		 concacodigo, 
		 concafecha,
		 'ACTIVO',
		 protercodigo, 
		 usucodigo, 
		 succodigo, 
		 empcodigo
         );
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA CABECERA DE CONTROL CALIDAD FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de anulacion
    if operacion = 2 then
		--En este caso realizamos un borrado logico
    	update control_calidad_cab 
		set conca_estado='ANULADO', usu_codigo=usucodigo
		where conca_codigo=concacodigo;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA CABECERA DE CONTROL CALIDAD FUE ANULADA CON EXITO';
    end if;
	--Al terminar la insercion o anulacion de la cabecera, procedemos a auditar el mismo
	--Consultamos el audit anterior
	select coalesce(conca_audit, '') into concaAudit from control_calidad_cab where conca_codigo=concacodigo;
	--a los datos anteriores le agregamos los nuevos
	update control_calidad_cab 
	set conca_audit = concaAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'conca_fecha', concafecha,
		'proter_codigo', protercodigo,
		'secc_descripcion', upper(seccdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'conca_estado', upper(concaestado)
	)||','
	where conca_codigo = concacodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado control calidad detalle
create or replace function sp_control_calidad_det(
    concacodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    pacocacodigo integer,
    concadetcantidadfallida integer,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos que no se repita el item, el parametro de control de calidad y el codigo de control
     	perform * from control_calidad_det
     	where it_codigo=itcodigo and tipit_codigo=tipitcodigo 
		and pacoca_codigo=pacocacodigo and conca_codigo=concacodigo;
     	if found then
			 --En caso de que se repita generamos una excepcion
     		 raise exception 'item_parametro';
		--Si no existe el item insertamos el mismo en el detalle
     	elseif operacion = 1 then
		     insert into control_calidad_det(
			 conca_codigo, 
			 it_codigo, 
			 tipit_codigo, 
			 pacoca_codigo, 
			 concadet_cantidadfallida
			 )
			 values(
			 concacodigo, 
			 itcodigo, 
			 tipitcodigo, 
			 pacocacodigo, 
			 concadetcantidadfallida
			 );
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'EL PRODUCTO FUE REGISTRADO CON EXITO EN CONTROL CALIDAD DETALLE';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from control_calidad_det 
    	where conca_codigo=concacodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo AND pacoca_codigo=pacocacodigo;
		--Enviamos un mensaje de confirmacion de eliminacion
		raise notice 'EL PRODUCTO FUE ELIMINADO CON EXITO DE CONTROL CALIDAD DETALLE';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado costo produccion cabecera
select coalesce(max(copro_codigo),0)+1 as copro_codigo from costo_produccion_cab;
create or replace function sp_costo_produccion_cab(
    coprocodigo integer,
    coprofecha date,
    coproestado varchar,
    orprocodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    seccdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$ 
declare coproAudit text;
		ordenProduccionDetalle2 record;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya se encuentra registrado la orden y si su estado es igual a activo
     	perform * from costo_produccion_cab
     	where orpro_codigo=orprocodigo and copro_estado='ACTIVO';
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'orden';
     	elseif operacion = 1 then
     	 --Una vez pasada la validacion, insertamos un nuevo registro en cabecera
	     insert into costo_produccion_cab(
		 copro_codigo, 
		 copro_fecha, 
		 copro_estado, 
		 orpro_codigo, 
		 usu_codigo,
	     suc_codigo, 
		 emp_codigo
		 )
		 values(
		 coprocodigo, 
		 coprofecha,
		 'ACTIVO',
		 orprocodigo, 
		 usucodigo, 
		 succodigo, 
		 empcodigo
         );
		--Una vez insertada la cabecera, procedemos a cargar de forma automatica el detalle de costo produccion
		--Preparamos la consulta para extraer los items de orden produccion det2
		for ordenProduccionDetalle2 in select opd.it_codigo, opd.tipit_codigo, sum(opd.orprodet2_cantidad) as cantidad_materia, i.it_costo
		from orden_produccion_det2 opd join componente_produccion_det cpd on cpd.compro_codigo=opd.compro_codigo  and cpd.it_codigo=opd.it_codigo 
		and cpd.tipit_codigo=opd.tipit_codigo join items i on i.it_codigo=cpd.it_codigo and i.tipit_codigo=cpd.tipit_codigo 
		where opd.orpro_codigo=orprocodigo group by opd.it_codigo, opd.tipit_codigo, i.it_costo loop 
			--Una vez obtenemos los items procedemos a insertar los mismos en costo_produccion_det
			insert into costo_produccion_det(copro_codigo, it_codigo, tipit_codigo, coprodet_cantidad, coprodet_costo)
			values(coprocodigo, ordenProduccionDetalle2.it_codigo, ordenProduccionDetalle2.tipit_codigo, 
			ordenProduccionDetalle2.cantidad_materia, ordenProduccionDetalle2.it_costo);
		end loop;
		 --Enviamos un mensaje de confirmacion de insercion
		 raise notice 'LA CABECERA DE COSTO PRODUCCION FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de anulacion
    if operacion = 2 then
		--En este caso realizamos un borrado logico
    	update costo_produccion_cab 
		set copro_estado='ANULADO', usu_codigo=usucodigo
		where copro_codigo=coprocodigo;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA CABECERA DE COSTO PRODUCCION FUE ANULADA CON EXITO';
    end if;
	--Al terminar la insercion o anulacion de la cabecera, procedemos a auditar el mismo
	--Consultamos el audit anterior
	select coalesce(copro_audit, '') into coproAudit from costo_produccion_cab where copro_codigo=coprocodigo;
	--a los datos anteriores le agregamos los nuevos
	update costo_produccion_cab 
	set copro_audit = coproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'copro_fecha', coprofecha,
		'orpro_codigo', orprocodigo,
		'secc_descripcion', upper(seccdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'copro_estado', upper(coproestado)
	)||','
	where copro_codigo = coprocodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado componente produccion cabecera
select coalesce(max(compro_codigo),0)+1 as compro_codigo from componente_produccion_cab;
create or replace function sp_componente_produccion_cab(
    comprocodigo integer,
    comprofecha date,
    comproestado varchar,
    itcodigo integer,
    tipitcodigo integer,
    usucodigo integer,
    succodigo integer,
    empcodigo integer,
    operacion integer,
    usulogin varchar,
    procedimiento varchar,
    itdescripcion varchar,
    modcodigomodelo varchar,
    coldescripcion varchar,
    talldescripcion varchar,
    tipitdescripcion varchar,
    emprazonsocial varchar,
    sucdescripcion varchar
) returns void as
$function$
declare comproAudit text;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si es que ya existe el item en cabecera
		perform * from componente_produccion_cab cpc 
		where cpc.it_codigo=itcodigo and cpc.tipit_codigo=tipitcodigo and cpc.compro_estado='ACTIVO';
     	if found then
			 --Si es que existe el item generamos una excepcion
     		 raise exception 'item_repetido';
	 	elseif operacion = 1 then
	    	--Una vez pasada la validacion, insertamos un nuevo registro en cabecera
		    insert into componente_produccion_cab(
			compro_codigo, 
			compro_fecha, 
			compro_estado, 
			it_codigo, 
			tipit_codigo,
		    usu_codigo, 
			suc_codigo, 
			emp_codigo
			)
			values(
			comprocodigo, 
			comprofecha, 
			'ACTIVO', 
			itcodigo, 
			tipitcodigo, 
			usucodigo, 
			succodigo, 
			empcodigo
			);
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'EL COMPONENTE DE PRODUCCION FUE REGISTRADO CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--En esta caso realizamos un borrado logico
    	update componente_produccion_cab 
		set compro_estado='ANULADO', usu_codigo=usucodigo
		where compro_codigo=comprocodigo;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'EL COMPONENTE DE PRODUCCION FUE ANULADO CON EXITO';
    end if;
	--Consultamos el audit anterior
	select coalesce(compro_audit, '') into comproAudit from componente_produccion_cab where compro_codigo=comprocodigo;
	--a los datos anteriores le agregamos los nuevos
	update componente_produccion_cab 
	set compro_audit = comproAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'compro_fecha', comprofecha,
		'it_codigo', itcodigo,
		'it_descripcion', upper(itdescripcion),
		'mod_codigomodelo', modcodigomodelo,
		'col_descripcion', upper(coldescripcion),
		'tall_descripcion', upper(talldescripcion),
		'tipit_codigo', tipitcodigo,
		'tipit_descripcion', upper(tipitdescripcion),
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'compro_estado', upper(comproestado)
	)||','
	where compro_codigo = comprocodigo;
end
$function$ 
language plpgsql;

--Procedimiento almacenado componente produccion detalle
create or replace function sp_componente_produccion_det(
    comprocodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    comprodetcantidad numeric,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si existe el item en caso de que si generamos una excepcion
     	perform * from componente_produccion_det
     	where it_codigo=itcodigo and compro_codigo=comprocodigo;
     	if found then
     		 raise exception 'item';
		--Si no existe el item insertamos el mismo en el detalle
     	elseif operacion = 1 then
		     insert into componente_produccion_det(compro_codigo, it_codigo, tipit_codigo, comprodet_cantidad)
			 values(comprocodigo, itcodigo, tipitcodigo, comprodetcantidad);
			 raise notice 'EL COMPONENTE DE PRODUCCION DETALLE FUE REGISTRADO CON EXITO';
		end if;
    end if;
	--Validamos la operacion en este caso la eliminacion
    if operacion = 2 then 
		--Se realiza un borrado fisico el cual se audita
    	delete from componente_produccion_det 
    	where compro_codigo=comprocodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo;
		raise notice 'EL COMPONENTE DE PRODUCCION DETALLE FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacendado presupuesto proveedor cabecera
select sp_apertura_cierre(1, 1, 1, 1, 1, '25-01-2024 11:3:7', null, 100000, null, 'CERRADO', 1);

select 
            ac.apercie_codigo,
            ac.caj_codigo,
            c.caj_descripcion,
            ac.apercie_estado
         from 
            apertura_cierre ac 
            join caja c on c.caj_codigo=ac.caj_codigo 
            where ac.apercie_codigo = 2;

create or replace function sp_apertura_cierre(
    aperciecodigo integer,
    succodigo integer,
    empcodigo integer,
    cajcodigo integer,
    usucodigo integer,
    aperciefechahoraapertura timestamp,
    aperciefechahoracierre timestamp,
    aperciemontoapertura numeric,
    aperciemontocierre numeric,
    apercieestado varchar,
    operacion integer 
) returns void as	
$function$
declare ultcod integer;
begin 
     if operacion = 1 then
     	perform * from apertura_cierre
     	where (caj_codigo=cajcodigo and apercie_estado='ABIERTO' and apercie_codigo<>aperciecodigo);
     	if found then
     		 raise exception 'caja';
     	elseif operacion = 1 then
	     insert into apertura_cierre(apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo,
	     apercie_fechahoraapertura, apercie_fechahoracierre, apercie_montoapertura, apercie_montocierre, apercie_estado)
		 values(aperciecodigo, succodigo, empcodigo, cajcodigo, usucodigo, aperciefechahoraapertura, aperciefechahoracierre,
		 aperciemontoapertura, aperciemontocierre, 'ABIERTO');
		 raise notice 'CAJA ABIERTA EXITOSAMENTE';
		end if;
    end if;
    if operacion = 2 then 
    	update apertura_cierre 
		set apercie_fechahoracierre=aperciefechahoracierre, apercie_montocierre=aperciemontocierre,
		apercie_estado='CERRADO', usu_codigo=usucodigo
		where apercie_codigo=aperciecodigo;
		raise notice 'CAJA CERRADA EXITOSAMENTE';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado de venta cabecera
update 
	factura_venta 
set facven_numero='' 
where suc_codigo=1 
and emp_codigo=1 
and caj_codigo=1;
select coalesce(max(ven_codigo),0)+1 as ven_codigo from venta_cab;
select  (0, '08/02/2024', '15000', 'CONTADO', 1, 0, 'S/I', 'ACTIVO', 1, 2, 1, 1, 1, 1);
select split_part('001-001-0000001', '-', 3);
create or replace function sp_venta_cab(
    vencodigo integer,
    venfecha date,
    vennumfactura varchar,
    ventimbrado varchar,
    ventipofactura tipo_factura,
    vencuota integer,
    venmontocuota numeric,
    veninterfecha varchar,
    venestado varchar,
    usucodigo integer,
    clicodigo integer,
    succodigo integer,
    empcodigo integer,
    tipcocodigo integer,
    pevencodigo integer,
    cajcodigo integer,
    operacion integer 
) returns void as
$function$
declare ventaDet record;
		usuario varchar;
		sucursal varchar;
		empresa varchar;
		c_pedido cursor is
		select 
	 	pvc.peven_fecha,
	 	pvc.cli_codigo,
	 	p.per_nombre||' '||p.per_apellido as cliente,
	 	p.per_numerodocumento,
	 	pvc.peven_estado,
		pvc.peven_audit 
		from pedido_venta_cab pvc
		join cliente c on c.cli_codigo=pvc.cli_codigo 
		join personas p on p.per_codigo=c.per_codigo 
		where pvc.peven_codigo=pevencodigo;
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos si se repite el numero de factura
     	perform * from venta_cab
     	where ven_numfactura=vennumfactura and ven_estado='ACTIVO';
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'factura';
     	elseif operacion = 1 then
			 --Procedemos a insertar el nuevo registro en venta cabecera
		     insert into venta_cab(
			 ven_codigo, 
			 ven_fecha, 
			 ven_numfactura, 
			 ven_tipofactura, 
			 ven_cuota, 
			 ven_montocuota,
		     ven_interfecha, 
			 ven_estado, 
			 usu_codigo, 
			 cli_codigo, 
			 suc_codigo, 
			 emp_codigo,
			 tipco_codigo,
			 ven_timbrado
			 )
			 values(
			 vencodigo, 
			 venfecha, 
			 vennumfactura, 
			 ventipofactura, 	
			 vencuota, 
			 venmontocuota, 
			 upper(veninterfecha), 
			 'ACTIVO',
			 usucodigo, 
			 clicodigo, 
			 succodigo, 	
			 empcodigo,
			 tipcocodigo,
			 ventimbrado
			 );
			 --Cargamos pedido venta
			 insert into pedido_venta(ven_codigo, peven_codigo, pedven_codigo)
		 	 values(vencodigo, pevencodigo, (select coalesce(max(pedven_codigo),0)+1 from pedido_venta));
		 	 --Cargamos libro venta
		 	 insert into libro_venta(
			 libven_codigo, 
			 ven_codigo, 
			 libven_exenta, 
			 libven_iva5, 
			 libven_iva10, 
			 libven_fecha,
		 	 libven_numcomprobante, 	
			 libven_estado,
			 tipco_codigo)
		 	 values(
			 (select coalesce(max(libven_codigo),0)+1 from libro_venta), 
			 vencodigo, 
			 0, 
			 0, 
			 0, 
			 venfecha,
		 	 vennumfactura, 
			 'ACTIVO',
			 tipcocodigo
			 );
		 	 --Cargamos cuenta cobrar
		 	 insert into cuenta_cobrar(
			 ven_codigo, 
			 cuenco_nrocuota, 
			 cuenco_monto, 
			 cuenco_saldo, 
			 cuenco_estado,
			 tipco_codigo
			 )
		 	 values(
			 vencodigo, 
			 vencuota, 
			 0, 
			 0, 
			 'ACTIVO',
			 tipcocodigo
			 );
		 	 --Actualizamos estado del pedido de venta
		 	 update pedido_venta_cab set peven_estado='VENDIDO', usu_codigo=usucodigo where peven_codigo=pevencodigo;
			 --Una vez insertado el nuevo registro, actualizamos el numero de factura en la tabla factura venta
			 update 
					factura_venta 
			 set facven_numero=split_part(vennumfactura, '-', 3)
			 where suc_codigo=succodigo
			 and emp_codigo=empcodigo
			 and caj_codigo=cajcodigo;
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'LA VENTA FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
        --En este caso realizamos un borrado logico
    	update venta_cab 
		set usu_codigo=usucodigo, ven_estado='ANULADO'
		where ven_codigo=vencodigo;
	    --Anulamos libro venta
	    update libro_venta set libven_estado='ANULADO' where ven_codigo=vencodigo;
	    --Anulamos cuenta cobrar
	    update cuenta_cobrar set cuenco_estado='ANULADO' where ven_codigo=vencodigo;
	    --Activamos el pedido de venta seleccionada
	    update pedido_venta_cab set peven_estado='TERMINADA', usu_codigo=usucodigo where peven_codigo=pevencodigo;
	    --Actualizamos el stock 
	    for ventaDet in select * from venta_det where ven_codigo=vencodigo loop
	       	update stock set st_cantidad=st_cantidad+ventaDet.vendet_cantidad 
			where it_codigo=ventaDet.it_codigo and tipit_codigo=ventaDet.tipit_codigo and dep_codigo=ventaDet.dep_codigo
	        and suc_codigo=ventaDet.suc_codigo and emp_codigo=ventaDet.emp_codigo;
        end loop;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'LA VENTA FUE ANULADA CON EXITO';
    end if;
	--Auditamos pedido venta
	for pedido in c_pedido loop
		--Consultamos el usuario de venta cabecera
		usuario := (select usu_login from usuario where usu_codigo=usucodigo);
		--Consultamos la sucursal de venta cabecera
		sucursal := (select suc_descripcion from sucursal where suc_codigo=succodigo);
		--Consultamos la empresa de venta cabecera
		empresa := (select emp_razonsocial from empresa where emp_codigo=empcodigo);
		--Actualizamos el audit de pedido venta
		update pedido_venta_cab 
		set peven_audit = pedido.peven_audit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usuario,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'peven_fecha', pedido.peven_fecha,
		'cli_codigo', pedido.cli_codigo,
		'cliente', pedido.cliente,
		'per_numerodocumento', pedido.per_numerodocumento,
		'emp_codigo', empcodigo,
		'emp_razonsocial', empresa,
		'suc_codigo', succodigo,
		'suc_descripcion', sucursal,
		'peven_estado', pedido.peven_estado
		)||','
		where peven_codigo = pevencodigo;
	end loop;
end
$function$ 
language plpgsql;

select usu_login from usuario where usu_codigo=1;
select suc_descripcion from sucursal where suc_codigo=1;
select emp_razonsocial from empresa where emp_codigo=1; 

select 
 	pvc.peven_fecha,
 	pvc.cli_codigo,
 	p.per_nombre||' '||p.per_apellido as cliente,
 	p.per_numerodocumento,
 	pvc.peven_estado,
 	pvc.peven_audit 
from pedido_venta_cab pvc
join cliente c on c.cli_codigo=pvc.cli_codigo 
join personas p on p.per_codigo=c.per_codigo 
where pvc.peven_codigo=1;

--Procedimiento almacenado de venta detalle
select sp_venta_det(1, 2, 2, 1, 1, 1, 5, 350000, 1);
create or replace function sp_venta_det(
    vencodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    vendetcantidad integer,
    vendetprecio numeric,
    operacion integer
) returns void as
$function$
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
		--Validamos que no se repita el item
     	perform * from venta_det
     	where it_codigo=itcodigo and dep_codigo=depcodigo and ven_codigo=vencodigo;
     	if found then
			 --En caso de ser asi generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
     	 	 --Insertamos nuevo registro en venta detalle
		     insert into venta_det(
			 ven_codigo, 
			 it_codigo, 
			 tipit_codigo, 
			 dep_codigo, 
			 suc_codigo,
		     emp_codigo, 
			 vendet_cantidad, 
			 vendet_precio
			 )
			 values(
			 vencodigo, 
			 itcodigo, 
			 tipitcodigo, 
			 depcodigo, 
			 succodigo, 
			 empcodigo, 
			 vendetcantidad, 
			 vendetprecio
			 );
			 --Actualizamos el stock 
			 update stock set st_cantidad=st_cantidad-vendetcantidad 
			 where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
			 and suc_codigo=succodigo and emp_codigo=empcodigo;
			 --Enviamos un mensaje de confirmacion de insercion
			 raise notice 'LA VENTA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
    	--En este caso realizamos un borrado fisico
    	delete from venta_det 
    	where ven_codigo=vencodigo and it_codigo=itcodigo and tipit_codigo=tipitcodigo
        and dep_codigo=depcodigo and suc_codigo=succodigo and emp_codigo=empcodigo;
       	--Actualizamos el stock 
		update stock set st_cantidad=st_cantidad+vendetcantidad 
		where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		and suc_codigo=succodigo and emp_codigo=empcodigo;
		--Enviamos un mensaje de de confirmacion de eliminacion
		raise notice 'LA VENTA DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;


--Procedimiento almacenado cuenta cobrar
select sp_cuenta_cobrar(1, 350000, 350000);
create or replace function sp_cuenta_cobrar(
    vencodigo integer,
    cuencomonto numeric,
    cuencosaldo numeric,
    tipcocodigo integer,
    operacion integer
) returns void as
$function$
begin 
	--Validamos si la operacion es 1 0 2
	if operacion = 1 then
	  --En caso de ser 1 procedemos a sumar el monto que nos pasan por parametro
	 update	cuenta_cobrar 
	 set cuenco_monto=cuenco_monto+cuencomonto, 
	 	 cuenco_saldo=cuenco_saldo+cuencosaldo,
		 tipco_codigo=tipcocodigo
	 where ven_codigo=vencodigo;
	end if;
	if operacion = 2 then 
	 --En caso de ser 2 procedemos a restar el monto que nos pasan por parametro
	 update	cuenta_cobrar 
	 set cuenco_monto=cuenco_monto-cuencomonto, 
	 	 cuenco_saldo=cuenco_saldo-cuencosaldo,
		 tipco_codigo=tipcocodigo
	 where ven_codigo=vencodigo;
	end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado libro venta
select sp_libro_venta(1, 0, 0, 350000);
create or replace function sp_libro_venta(
    vencodigo integer,
    libvenexenta numeric,
    libveniva5 numeric,
    libveniva10 numeric,
    libvennumcomprobante varchar,
    tipcocodigo integer,
    operacion integer
) returns void as
$function$
begin 
	--Validamos si la operacion es 1 0 2
	if operacion = 1 then
	 --En caso de ser 1 procedemos a sumar el monto que nos pasan por parametro
     update libro_venta 
	 set libven_exenta=libven_exenta+libvenexenta, 
		 libven_iva5=libven_iva5+libveniva5, 
     	 libven_iva10=libven_iva10+libveniva10 
	 where ven_codigo=vencodigo
	 and libven_numcomprobante=libvennumcomprobante
	 and tipco_codigo=tipcocodigo;
    end if;
    if operacion = 2 then
	--En caso de ser 2 procedemos a restar el monto que nos pasan por parametro
     update libro_venta 
	 set libven_exenta=libven_exenta-libvenexenta, 
		 libven_iva5=libven_iva5-libveniva5, 
     	 libven_iva10=libven_iva10-libveniva10 
	 where ven_codigo=vencodigo
	 and libven_numcomprobante=libvennumcomprobante
	 and tipco_codigo=tipcocodigo;
    end if;
end
$function$ 
language plpgsql;

select distinct cd.ven_codigo from cobro_det cd where cd.cob_codigo=1;
select sp_cobro_cab(0, '21/02/2024', 'ACTIVO', 1, 1, 1, 1, 3, 1);
select coalesce(max(cob_codigo),0)+1 from cobro_cab;
create or replace function sp_cobro_cab(
    cobcodigo integer,
    cobfecha timestamp,
    cobestado varchar,
    aperciecodigo integer,
    succodigo integer,
    empcodigo integer,
    cajcodigo integer,
    usucodigo integer,
    tipcocodigo integer,
    operacion integer 
) returns void as
$function$
declare cobroDet record;
		ventaEstado varchar;
begin 
	 --Validamos si la operacion es de insercion 
     if operacion = 1 then
      	--Procedemos a insertar el nuevo registro en cobro cabecera
		insert into cobro_cab(
		cob_codigo, 
		cob_fecha, 
		cob_estado, 
		apercie_codigo, 
		suc_codigo, 
		emp_codigo, 
		caj_codigo, 
		usu_codigo,
		tipco_codigo
		)
		values(
		cobcodigo, 
		cobfecha, 
		'ACTIVO', 
		aperciecodigo, 
		succodigo, 
		empcodigo, 
		cajcodigo, 
		usucodigo,
		tipcocodigo
		);
		--Enviamos un mensaje de confirmacion de insercion
		raise notice 'EL COBRO FUE REGISTRADO CON EXITO';
    end if;
	--Validamos si la operacion es de anulacion
    if operacion = 2 then 
		--Consultamos el estado de venta cabecera
		ventaEstado := (select ven_estado from venta_cab where ven_codigo=(select distinct cd.ven_codigo from cobro_det cd where cd.cob_codigo=cobcodigo));
        --En este caso realizamos un borrado logico
    	update cobro_cab 
		set cob_estado='ANULADO', usu_codigo=usucodigo
		where cob_codigo=cobcodigo;
		--Actualizamos el monto saldo de cuentas a cobrar asociado al cobro anulado
	    for cobroDet in select * from cobro_det where cob_codigo=cobcodigo loop
	       	update cuenta_cobrar 
			set 
			cuenco_saldo=cuenco_saldo+cobroDet.cobdet_monto, 
			cuenco_estado='ACTIVO', 
			tipco_codigo=5
			where ven_codigo=cobroDet.ven_codigo;
        end loop;
		--Actualizamos el estado de venta cabecera en caso de que sea cancelado
		if ventaEstado = 'CANCELADO' then
			update venta_cab 
			set ven_estado='ACTIVO',
			usu_codigo=usucodigo  
			where ven_codigo=(select distinct cd.ven_codigo from cobro_det cd where cd.cob_codigo=cobcodigo);
		end if;
		--Enviamos un mensaje de confirmacion de anulacion
		raise notice 'EL COBRO FUE ANULADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

select ven_estado from venta_cab where ven_codigo=1;

select sp_cobro_det(0, 1, 1, 350000, 1, 1, 1);
select coalesce(max(cobdet_codigo),0)+1 as codigodetalle from cobro_det;
create or replace function sp_cobro_det(
    cobdetcodigo integer,
    cobcodigo integer,
    vencodigo integer,
    cobdetmonto numeric,
    cobdetnumerocuota integer,
    forcocodigo integer,
    cochenumero varchar,
    entcodigo integer,
    usucodigo integer,
    cobtatransaccion varchar,
    redpacodigo integer,
    operacion integer 
) returns void as
$function$
declare ventaEstado varchar;
begin 
   --Validamos la operacion en este caso la insercion
   --Validamos si es una insercion y si la forma de cobro es tarjeta
   if operacion = 1 and forcocodigo = 2 then
	   --Validamos que no se repita el numero de transaccion y la red de pago 
      	perform * from cobro_tarjeta	
     	where cobta_transaccion=cobtatransaccion and redpa_codigo=redpacodigo;
     	if found then
		     --En caso de ser asi generamos una excepcion
     		 raise exception 'tarjeta';
		end if;
   end if;
   --Validamos si es una insercion y si la forma de cobro es cheque 
   if operacion = 1 and forcocodigo = 3 then
      	--Validamos que no se repita el numero de cheque 
      	perform * from cobro_cheque	
     	where coche_numero=cochenumero and ent_codigo=entcodigo;
     	if found then
		     --En caso de ser asi generamos una excepcion
     		 raise exception 'cheque';
		end if;
    end if;
	--Validamos si la operacion es de insercion y si la forma de cobro es efectivo
	if operacion = 1 and forcocodigo = 1 then
		--Validamos que no se repita 2 veces la forma de cobro efectivo en el detalle
      	perform * from cobro_det	
     	where forco_codigo=forcocodigo and cob_codigo=cobcodigo and ven_codigo=vencodigo;
     	if found then
		     --En caso de ser asi generamos una excepcion
     		 raise exception 'efectivo';
		end if;
    end if;
	--Validamos si la operacion es de insercion
    if operacion = 1 then
		--Insertamos nuevo registro en cobro detalle
		insert into cobro_det(
		cobdet_codigo, 
		cob_codigo, 
		ven_codigo, 	
		cobdet_monto, 
		cobdet_numerocuota, 	
		forco_codigo
		)
		values(
		(select coalesce(max(cobdet_codigo),0)+1 from cobro_det), 
		cobcodigo, 
		vencodigo, 
		cobdetmonto, 
		cobdetnumerocuota, 
		forcocodigo
		);
		--Actualizamos saldo y tipo de comprobante en cuenta cobrar
		update cuenta_cobrar 
		set cuenco_saldo=cuenco_saldo-cobdetmonto, 
		tipco_codigo=5
		where ven_codigo=vencodigo;
		--Enviamos un mensaje de confirmacion de insercion
		raise notice 'EL DETALLE DEL COBRO FUE REGISTRADO CON EXITO';
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		--Consultamos el estado de venta cabecera
		ventaEstado := (select ven_estado from venta_cab where ven_codigo=vencodigo);
        --Eliminamos el registro de cobro tarjeta en caso de que toque
    	if forcocodigo = 2 then
    	 delete from cobro_tarjeta where cobdet_codigo=cobdetcodigo;
    	end if;
		--Eliminamos el registro de cobro cheque en caso de que toque
    	if forcocodigo = 3 then
    	 delete from cobro_cheque where cobdet_codigo=cobdetcodigo;
    	end if;
		--Realizamos un borrado fisico de cobro detalle
    	delete from cobro_det where cobdet_codigo=cobdetcodigo;
		--Actualizamos registro de cuenta cobrar
    	update cuenta_cobrar 
		set cuenco_saldo=cuenco_saldo+cobdetmonto, 
			cuenco_estado='ACTIVO',
			tipco_codigo=5
		where ven_codigo=vencodigo;
		--Actualizamos registro de venta cabecera en caso de que el mismo sea cancelado
		if ventaEstado = 'CANCELADO' then
			update venta_cab 
			set ven_estado='ACTIVO',
			usu_codigo=usucodigo  
			where ven_codigo=vencodigo;
		end if;
		--Enviamos un mensaje de de confirmacion de eliminacion
		raise notice 'EL DETALLE DEL COBRO FUE ELIMINADO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

select sp_cobro_cheque(0, '1666000', 350000, 'DIFERIDOS', '25/02/2024', 1, 1, 1, 1, 1);
create or replace function sp_cobro_cheque(
    cochecodigo integer,
    cochenumero varchar,
    cochemonto numeric,
    cochetipocheque tipo_cheque,
    cochefechavencimiento date,
    entcodigo integer,
    cobcodigo integer,
    vencodigo integer,
    cobdetcodigo integer,
    operacion integer
) returns void as
$function$
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
     	--Insertamos registro en cobro cheque
		insert into cobro_cheque(
		coche_codigo, 	
		coche_numero, 
		coche_monto, 
		coche_tipocheque, 
		coche_fechavencimiento,
		ent_codigo, 
		cob_codigo, 
		ven_codigo, 
		cobdet_codigo
		)
		values(
		(select coalesce(max(coche_codigo),0)+1 from cobro_cheque), 
		cochenumero, 
		cochemonto, 
		cochetipocheque, 
		cochefechavencimiento, 
		entcodigo, 
		cobcodigo,
		vencodigo, 
		cobdetcodigo
		);
		end if;
end
$function$ 
language plpgsql;

select coalesce(max(cobdet_codigo),0)+1 from cobro_det;

select sp_cobro_tarjeta(0, '1555000', 350000, 'DEBITO', 1, 1, 1, 1, 1, 1, 1);
create or replace function sp_cobro_tarjeta(
    cobtacodigo integer,
    cobtanumero varchar,
    cobtamonto numeric,
    cobtatipotarjeta tipo_tarjeta,
    entadcodigo integer,
    entcodigo integer,
    martacodigo integer,
    cobcodigo integer,
    vencodigo integer,
    cobdetcodigo integer,
    cobtatransaccion varchar,
    redpacodigo integer,
    operacion integer 
) returns void as
$function$
begin 
	 --Validamos si la operacion es de insercion
     if operacion = 1 then
     	--Procedemos con la insercion en cobro tarjeta
		insert into cobro_tarjeta(
		cobta_codigo, 
		cobta_numero, 
		cobta_monto, 
		cobta_tipotarjeta, 
		entad_codigo,
		ent_codigo, 
		marta_codigo, 
		cob_codigo, 
		ven_codigo, 
		cobdet_codigo,
		cobta_transaccion,
		redpa_codigo
		)
		values(
		(select coalesce(max(cobta_codigo),0)+1 from cobro_tarjeta), 
		cobtanumero, 
		cobtamonto, 
		cobtatipotarjeta, 
		entadcodigo, 
		entcodigo, 
		martacodigo,
		cobcodigo, 
		vencodigo, 
		cobdetcodigo,
		cobtatransaccion,
		redpacodigo
		);
    end if;
end
$function$ 
language plpgsql;

select 
	it_codigo,
	tipit_codigo,
	dep_codigo,
	suc_codigo,
	emp_codigo,
	notvendet_cantidad 
from nota_venta_det
where notven_codigo=1;

select
	coalesce(ncd.nocomdet_cantidad*ncd.nocomdet_precio, 0) as subtotal
from nota_compra_det ncd
where ncd.nocom_codigo=1;

select 
	coalesce(sum((case
		nvd.tipit_codigo
	 when 3
	 	then
	 		nvd.notvendet_precio 
	 	else	
	 		nvd.notvendet_cantidad*nvd.notvendet_precio 
	 end)), 0) total
from nota_venta_det nvd 
where nvd.notven_codigo=1;

select vc.ven_estado from venta_cab vc where vc.ven_codigo=1;

select coalesce(max(notven_codigo),0)+1 as notven_codigo from nota_venta_cab;
select sp_nota_venta_cab(1, '16/03/2024', '00001' , 'prueba', 'ACTIVO', 3, 1, 1, 1, 3, 2, 2);
select coalesce(max(notven_codigo),0)+1 from nota_venta_cab;
create or replace function sp_nota_venta_cab(
    notvencodigo integer,
    notvenfecha date,
    notvennumeronota varchar,
    notvenconcepto varchar,
    notvenestado varchar,
    tipcocodigo integer,
    vencodigo integer,
    succodigo integer,
    empcodigo integer,
    usucodigo integer,
    clicodigo integer,
    operacion integer 
) returns void as
$function$
-- Declaramos las variables a utilizar
declare ultCodLibroVenta integer;
		estadoVenta varchar;
		c_nota_venta_det cursor is
		select 
		it_codigo,
		tipit_codigo,
		dep_codigo,
		suc_codigo,
		emp_codigo,
		notvendet_cantidad 
		from nota_venta_det
		where notven_codigo=notvencodigo;
		totalSuma numeric;
begin 
	 -- Validamos si la operacion es de insercion
     if operacion = 1 then
		ultCodLibroVenta = (select coalesce(max(libven_codigo),0)+1 from libro_venta);
		--Validamos que no se repita el numero de nota
     	perform * from nota_venta_cab
     	where notven_numeronota=notvennumeronota and notvenestado='ACTIVO';
     	if found then
			 -- En caso de que si, generamos una excepcion
     		 raise exception 'nota';
		-- En caso de no generar excepciones procedemos con la insercion
     	elseif operacion = 1 then
	     insert into nota_venta_cab(
		 notven_codigo, 
		 notven_fecha, 
		 notven_numeronota, 
		 notven_concepto, 
	     notven_estado, 
		 tipco_codigo, 
		 ven_codigo, 
		 suc_codigo, 
		 emp_codigo, 
		 usu_codigo, 
		 cli_codigo
		 )
		 values(
		 notvencodigo, 
		 notvenfecha, 
		 notvennumeronota, 
		 upper(notvenconcepto), 
		 'ACTIVO', 
		 tipcocodigo, 
		 vencodigo, 
		 succodigo, 
		 empcodigo, 
		 usucodigo, 
		 clicodigo
		 );
		 -- Cargamos Libro venta dependiendo del tipo de comprobante
		 if tipcocodigo in(1,2) then
			 insert into libro_venta(
			 libven_codigo, 
			 ven_codigo, 	
			 libven_exenta, 
		     libven_iva5, 
			 libven_iva10, 
			 libven_fecha,
			 libven_numcomprobante, 
			 libven_estado, 
			 tipco_codigo
			 )
			 values(
			 ultCodLibroVenta, 
			 ven_codigo, 
			 0, 
			 0, 
			 0, 
			 notvenfecha, 
			 notvennumeronota, 
			 'ACTIVO', 
			 tipcocodigo
			);
		 end if;
		 -- Generamos un mensaje al terminar la insercion
		 raise notice 'LA NOTA DE VENTA FUE REGISTRADA CON EXITO';
		end if;
    end if;
	-- Validamos si la operacion es de anulacion
    if operacion = 2 then 
		-- Actualizamos el estado de nota venta
    	update nota_venta_cab 
		set notven_estado='ANULADO', usu_codigo=usucodigo
		where notven_codigo=notvencodigo;
		-- Si la nota es de credito 
		if tipcocodigo = 1 then
			-- Actualizamos estado de libro venta
			update libro_venta
			set libven_estado='ANULADO'
			where ven_codigo=vencodigo
			and libven_numcomprobante=nocomnumeronota
			and tipco_codigo=tipcocodigo;
			-- Volvemos stock a como estaba
			for nota in c_nota_venta_det loop
				update stock set st_cantidad=st_cantidad-nota.notvendet_cantidad 
				where it_codigo=nota.it_codigo 
				and tipit_codigo=nota.tipit_codigo 
				and dep_codigo=nota.dep_codigo
				and suc_codigo=nota.suc_codigo 
				and emp_codigo=nota.emp_codigo;
			end loop;
			-- Guardamos la sumatoria del detalle de nota venta en una variable
			totalSuma := (select coalesce(sum((case nvd.tipit_codigo when 3 then nvd.notvendet_precio else nvd.notvendet_cantidad*nvd.notvendet_precio end)), 0) total
			from nota_venta_det nvd where nvd.notven_codigo=notvencodigo);
			-- Consultamos el estado de venta cabecera
			estadoVenta := (select vc.ven_estado from venta_cab vc where vc.ven_codigo=vencodigo);
			-- Validamos que el monto del detalle sea mayor a cero
			if totalSuma > 0 then
				-- Actualizamos el monto de cuenta cobrar con lo restado en el detalle
				update cuenta_cobrar 
			 	set cuenco_monto=cuenco_monto+totalSuma, 
			 	 	cuenco_saldo=cuenco_saldo+totalSuma,
					cuenco_estado='ACTIVO',
				 	tipco_codigo=tipcocodigo
			 	where ven_codigo=vencodigo;
				-- Validamos el estado de venta
				if estadoVenta = 'ANULADO' then
					-- En caso de estar anulado procedemos con su actualizacion
					update venta_cab set ven_estado='ACTIVO', usu_codigo=usucodigo where ven_codigo=vencodigo; 
				end if;
		end if;
		-- Si la nota es de debito
		elseif tipcocodigo = 2 then
			-- Actualizamos estado de libro venta
			update libro_venta
			set libven_estado='ANULADO'
			where ven_codigo=vencodigo
			and libven_numcomprobante=nocomnumeronota
			and tipco_codigo=tipcocodigo;
			-- Volvemos stock a como estaba
			for nota in c_nota_venta_det loop
				update stock set st_cantidad=st_cantidad+nota.notvendet_cantidad 
				where it_codigo=nota.it_codigo 
				and tipit_codigo=nota.tipit_codigo 
				and dep_codigo=nota.dep_codigo
				and suc_codigo=nota.suc_codigo 
				and emp_codigo=nota.emp_codigo;
			end loop;
			-- Guardamos la sumatoria del detalle de nota venta en una variable
			totalSuma := (select coalesce(sum((case nvd.tipit_codigo when 3 then nvd.notvendet_precio else nvd.notvendet_cantidad*nvd.notvendet_precio end)), 0) total
			from nota_venta_det nvd where nvd.notven_codigo=notvencodigo);
			-- Validamos que el monto del detalle sea mayor a cero
			if totalSuma > 0 then
				-- Actualizamos el monto de cuenta cobrar con lo sumado en el detalle
				update cuenta_cobrar 
			 	set cuenco_monto=cuenco_monto-totalSuma, 
			 	 	cuenco_saldo=cuenco_saldo-totalSuma,
					cuenco_estado='ACTIVO',
				 	tipco_codigo=tipcocodigo
			 	where ven_codigo=vencodigo;
			end if;
		end if;
		-- Generamos un mensaje al terminar la insercion
		raise notice 'LA NOTA DE VENTA FUE ANULADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

update venta_cab set ven_estado='ACTIVO', usu_codigo=usucodigo where ven_codigo=1; 

create database sys8DD_restore;

select (-5000+-5000)

select cc.cuenco_saldo into montoSaldo from cuenta_cobrar cc where cc.ven_codigo=1;

select coalesce(sum(cd.cobdet_monto), 0) as sumatoria from cobro_det cd join cobro_cab cc on cc.cob_codigo=cd.cob_codigo where cd.ven_codigo=2 and cc.cob_estado='ACTIVO';

select coalesce(sum(case	
			when tipit_codigo = 3 then 1*notvendet_precio else notvendet_cantidad*notvendet_precio 
		   end), 0) from nota_venta_det nvd where nvd.notven_codigo=1;

select sp_nota_venta_det(1, 6, 2, 1, 70000, 2);
create or replace function sp_nota_venta_det(
    notvencodigo integer,
    itcodigo integer,
    tipitcodigo integer,
    notvendetcantidad integer,
    notvendetprecio numeric,
    depcodigo integer,
    succodigo integer,
    empcodigo integer,
    tipcocodigo integer,
    vencodigo integer, 
    libvennumcomprobante varchar,
    tipimcodigo integer,
    usucodigo integer,
    operacion integer
) returns void as
$function$
-- Declaramos las variables a utilizar
declare monto numeric;
		montoIva5 numeric := 0;
		montoIva10 numeric := 0;
		montoIvaExenta numeric := 0;
		montoCuenta numeric := 0;
		montoSaldo numeric := 0;
		sumatoriaCobro numeric := 0;
		sumatoriaNotaVentaDetalle numeric := 0;
	    ventaEstado varchar;
begin
	 --Consultamos el estado de venta
     select ven_estado into ventaEstado from venta_cab where ven_codigo=vencodigo; 
	 -- Consultamos el saldo de cuenta cobrar
	 select cc.cuenco_saldo into montoSaldo from cuenta_cobrar cc where cc.ven_codigo=vencodigo;
	 -- Consultamos el monto de cuenta cobrar
	 select cc.cuenco_monto into montoCuenta from cuenta_cobrar cc where cc.ven_codigo=vencodigo;
	 -- Consultamos la sumatoria de cobro detalle
	 select coalesce(sum(cd.cobdet_monto), 0) into sumatoriaCobro from cobro_det cd join cobro_cab cc on cc.cob_codigo=cd.cob_codigo where cd.ven_codigo=vencodigo and cc.cob_estado='ACTIVO';
	 -- Consultamos la sumatoria de nota venta detalle
	 select coalesce(sum(case	
							when tipit_codigo = 3 then 1*notvendet_precio else notvendet_cantidad*notvendet_precio 
						  end), 0) into sumatoriaNotaVentaDetalle from nota_venta_det nvd where nvd.notven_codigo=notvencodigo;
	 -- Validamos si la operacion es de insercion
     if operacion = 1 then
		-- Validamos que no se repita el item en el detalle
     	perform * from nota_venta_det
     	where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		and suc_codigo=succodigo and emp_codigo=empcodigo and notven_codigo=notvencodigo;
     	if found then
			 -- En caso de repetirse un item, generamos una excepcion
     		 raise exception 'item';
     	elseif operacion = 1 then
			 -- Insertamos un registro en nota venta detalle, independientemente del tipo de comprobante
		     insert into nota_venta_det(
				 notven_codigo, 
				 it_codigo, 
				 tipit_codigo, 
				 notvendet_cantidad, 
				 notvendet_precio,
				 dep_codigo,
				 suc_codigo,
				 emp_codigo
			 )
			 values(
				 notvencodigo, 
				 itcodigo, 
				 tipitcodigo, 
				 notvendetcantidad, 
				 notvendetprecio,
				 depcodigo,
				 succodigo,
				 empcodigo);
			 -- Actualizamos registro en cuenta cobrar, libro venta y stock, solo en caso de ser una nota de credito o debito
			 if tipcocodigo in(1,2) then
			     -- Actualizamos la cantidad de item en stock
			 	 update stock	   -- En caso de ser credito se suma stock, en caso de ser debito se resta stock			 
				 set st_cantidad = case when tipcocodigo = 1 then st_cantidad + notvendetcantidad else st_cantidad - notvendetcantidad end 
				 where it_codigo = itcodigo
				 and tipit_codigo = tipitcodigo
				 and dep_codigo = depcodigo
				 and suc_codigo = succodigo
				 and emp_codigo = empcodigo;
				 --Definicion de monto para cuenta cobrar
				 if tipcocodigo = 1 then
					-- Si el tipo de comprobante es credito, multiplicamos cantidad por precio o mantenemos el precio dependiendo del tipo de item
					if tipitcodigo = 3 then
						-- Si es servicio, mantenemos el precio por no tener cantidad y convertimos a negativo
						monto := (notvendetprecio)*-1; 
					else
						-- Si es producto, multiplicamos cantidad por el precio y convertimos a negativo
						monto := (notvendetcantidad*notvendetprecio)*-1; 
					end if;
				 else
					-- Si el tipo de comprobante es debito, multiplicamos cantidad por precio o mantenemos el precio dependiendo del tipo de item
					if tipitcodigo = 3 then
						-- Si es servicio, mantenemos el precio por no tener cantidad
						monto := notvendetprecio; 
					else
						-- Si es producto, multiplicamos cantidad por el precio
						monto := (notvendetcantidad*notvendetprecio); 
					end if;
				 end if;
				 -- Para repartir el valor en libro venta, validamos el tipo de impuesto
				 if tipimcodigo = 1 then -- Iva 5%
					montoIva5 := monto;
				 elseif tipimcodigo = 2 then -- Iva 10% 
					montoIva10 := monto;
				 else -- Iva exenta
					montoIvaExenta := monto;
				 end if;
				 -- Llamamos al sp de cuenta cobrar y libro venta y le pasamos los parametros necesarios para ejecutarse
				 -- Cuenta Cobrar				      	    -- En caso de ser credito y el saldo cero, pasamos un cero para que el saldo no quede negativo
				 perform sp_cuenta_cobrar(
											vencodigo, 
											monto, 
											case 
												-- Si es credito y el saldo de cuenta cobrar es 0, retamos 0 sino lo guardado de cantidad por precio
												when tipcocodigo = 1 and montoSaldo = 0 then 0 
												-- Si es credito y el saldo de cuenta cobrar es menor a lo que se quiere devolver en detalle,
												-- retamos lo que se encuentra en saldo sino lo guardado de cantidad por precio
												when tipcocodigo = 1 and (montoSaldo < (monto*-1)) then -montoSaldo 
												else monto
											end, 
											tipcocodigo, 
											operacion
										  );
				 -- Libro Venta
				 perform sp_libro_venta(vencodigo, montoIvaExenta, montoIva5, montoIva10, libvennumcomprobante, tipcocodigo, operacion);
				 -- Actualizacion de estados de cuenta cobrar y venta cabecera
				 update cuenta_cobrar set cuenco_estado = case  -- Validamos credito y monto de cuenta cobrar
														  	when tipcocodigo = 1 and montoCuenta = 0 then 'ANULADO' 
																-- Validamos debito y estado de venta cabecera
															when tipcocodigo = 2 and ventaEstado = 'CANCELADO' then 'ACTIVO' 
														  end where ven_codigo=vencodigo;
				 -- Venta cabecera
				 update venta_cab set ven_estado=case 		-- Validamos credito y monto de cuenta cobrar
														  	when tipcocodigo = 1 and montoCuenta = 0 then 'ANULADO' 
															-- Validamos debito y estado de venta cabecera
															when tipcocodigo = 2 and ventaEstado = 'CANCELADO' then 'ACTIVO' 
														  end, usu_codigo=usucodigo  where ven_codigo=vencodigo;
			 end if;
			 -- Enviamos un mensaje de confirmacion de insercion
			 raise notice 'LA NOTA DE VENTA DETALLE FUE REGISTRADA CON EXITO';
		end if;
    end if;
	-- Validamos si la operacion es de eliminacion
    if operacion = 2 then 
		-- Procedemos con la eliminacion del registro en este caso una eliminacion fisica
    	delete from nota_venta_det 
    	where it_codigo=itcodigo and tipit_codigo=tipitcodigo and dep_codigo=depcodigo
		and suc_codigo=succodigo and emp_codigo=empcodigo and notven_codigo=notvencodigo;
		-- Actualizamos registro en cuenta cobrar, libro venta y stock, solo en caso de ser una nota de credito o debito
		if tipcocodigo in(1,2) then
			-- Actualizamos la cantidad de item en stock
			update stock
			set st_cantidad = case when tipcocodigo = 1 then st_cantidad - notvendetcantidad else st_cantidad + notvendetcantidad end 
			where it_codigo = itcodigo
			and tipit_codigo = tipitcodigo
			and dep_codigo = depcodigo
			and suc_codigo = succodigo
			and emp_codigo = empcodigo;
			--Definicion de monto para cuenta cobrar
			if tipcocodigo = 1 then
				-- Si el tipo de comprobante es credito, multiplicamos cantidad por precio o mantenemos el precio dependiendo del tipo de item
				if tipitcodigo = 3 then
					-- Si es servicio, mantenemos el precio por no tener cantidad y convertimos a negativo
					monto := (notvendetprecio)*-1; 
				else
					-- Si es producto, multiplicamos cantidad por el precio y convertimos a negativo
					monto := (notvendetcantidad*notvendetprecio)*-1; 
				end if;
			else
				-- Si el tipo de comprobante es debito, multiplicamos cantidad por precio o mantenemos el precio dependiendo del tipo de item
				if tipitcodigo = 3 then
					-- Si es servicio, mantenemos el precio por no tener cantidad
					monto := notvendetprecio; 
				else
					-- Si es producto, multiplicamos cantidad por el precio
					monto := (notvendetcantidad*notvendetprecio); 
				end if;
			end if;
			-- Para repartir el valor en libro venta, validamos el tipo de impuesto
			if tipimcodigo = 1 then -- Iva 5%
				montoIva5 := monto;
			elseif tipimcodigo = 2 then -- Iva 10% gugu
				montoIva10 := monto;
			else -- Iva exenta
				montoIvaExenta := monto;
			end if;
			-- Llamamos al sp de cuenta cobrar y libro venta y le pasamos los parametros necesarios para ejecutarse
			-- Cuenta Cobrar
			perform sp_cuenta_cobrar(
										vencodigo, 
										monto, 
										case
											-- Se suma monto de cuenta cobrar + sumatoria de nota venta detalle - monto de nota venta detalle que se esta eliminando
											-- Se resta la sumatoria de cobro detalle -> al resultado de esta resta se vuelve a restar el saldo de cuenta cobrar
											-- Esto solo se realiza en caso de que la nota de credito
											-- En caso de que la nota sea de debito, solo se pasa el calculo de cantidad * precio de nota venta detalle
											when tipcocodigo = 1 then -(((montoCuenta+sumatoriaNotaVentaDetalle-monto)-sumatoriaCobro)-montoSaldo) else monto
										end, 
										tipcocodigo, 
										operacion
									);
			-- Libro Venta
			perform sp_libro_venta(vencodigo, montoIvaExenta, montoIva5, montoIva10, libvennumcomprobante, tipcocodigo, operacion);
			-- Validamos el tipo de comprobante para actualizar o no los estados
			if tipcocodigo = 1 then 
				--En caso de ser una nota de credito, consultamos el monto de cuenta cobrar y el estado de venta cabecera
				select cc.cuenco_monto into montoCuenta from cuenta_cobrar cc where cc.ven_codigo=vencodigo;
				-- Validamos el monto de cuena cobrar
				if montoCuenta > 0 and ventaEstado = 'ANULADO' then 
					-- En caso de ser mayor a 0 y tener el estado de venta en anulado, procedemos con la actualizacion de estado a activo
					-- Cuenta cobrar
					update cuenta_cobrar set cuenco_estado='ACTIVO' where ven_codigo=vencodigo;
					-- Venta cabecera
					update venta_cab set ven_estado='ACTIVO', usu_codigo=usucodigo  where ven_codigo=vencodigo;
				end if;
			end if;
		end if;
		-- Enviamos un mensaje de confirmacion de eliminacion
		raise notice 'LA NOTA DE VENTA DETALLE FUE ELIMINADA CON EXITO';
    end if;
end
$function$ 
language plpgsql;

select ven_estado into ventaEstado from venta_cab where ven_codigo=1;
update cuenta_cobrar set cuenco_estado='ANULADO' where ven_codigo=1;
update venta_cab set ven_estado='ANULADO', usu_codigo=usucodigo  where ven_codigo=vencodigo;

select (5*5)*-1

perform * from factura_venta 
where suc_codigo=1 
and emp_codigo=1 
and caj_codigo=1;

--Procedimiento almacenado factura venta
select sp_factura_venta(1, 1, 1, '0000000', 1);
create or replace function sp_factura_venta(
    succodigo integer,
    empcodigo integer,
    cajcodigo integer,
    facvennumero varchar,
    operacion integer
) returns void as
$function$
begin 
	 --Validamos la operacion en este caso la insercion
     if operacion = 1 then
		--Validamos si ya se encuentra el registro
	 	perform * from factura_venta 
		where suc_codigo=succodigo
		and emp_codigo=empcodigo 
		and caj_codigo=cajcodigo;
     	if found then
			 --En caso de que si, generamos una excepcion
     		 raise exception 'punto_venta';
     	elseif operacion = 1 then
			 --En caso de que no procedemos con la insercion del nuevo registro
			 insert into factura_venta(suc_codigo, emp_codigo, caj_codigo, facven_numero)
		     values(succodigo, empcodigo, cajcodigo, facvennumero);
		end if;
		 raise notice 'EL REGISTRO DE FACTURA VENTA SE INSERTO CON EXITO';
    end if;
end
$function$ 
language plpgsql;

--Procedimiento almacenado red_pago
create or replace function sp_red_pago(
    redpacodigo integer,
    redpadescripcion varchar,
    redpaestado varchar,
    operacion integer,
    usucodigo integer,
    usulogin varchar,
    procedimiento varchar
) returns void as
$function$
declare redpaAudit text;
begin 
	--Validamos si la operacion es de insercion o modificacion
    if operacion in(1,2) then
		--Validamos que la descripcion no se repita, solo en caso de modificar un mismo registro
        perform * from red_pago
        where upper(redpa_descripcion) = upper(redpadescripcion)
        and redpa_codigo != redpacodigo;
        if found then
			--En caso de que se cumpla la condicion, generamos una excepcion
            raise exception '1';
    	elseif operacion = 1 then
				--En caso de que no se cumpla, procedemos con la insercion en caso de que la operacion sea 1
	        	insert into red_pago(redpa_codigo, redpa_descripcion, redpa_estado)
				values(redpacodigo, upper(redpadescripcion), 'ACTIVO');
				--Enviamos un mensaje de confirmacion de insercion
				raise notice 'LA RED DE PAGO FUE REGISTRADA CON EXITO';
        elseif operacion = 2 then
				--En caso de que no se cumpla, procedemos con la modificacion en caso de que la operacion sea 2
        		update red_pago
				set redpa_descripcion=upper(redpadescripcion), redpa_estado='ACTIVO'
				where redpa_codigo=redpacodigo;
				--Enviamos un mensaje de confirmacion de modificacion
				raise notice 'LA RED DE PAGO FUE MODIFICADA CON EXITO';
        end if;
    end if;
	--Validamos si la operacion es de eliminacion
    if operacion = 3 then 
		--En este caso se procede con un borrado logico
    	update red_pago
		set redpa_estado='INACTIVO'
		where redpa_codigo=redpacodigo;
		raise notice 'LA RED DE PAGO FUE ELIMINADA CON EXITO';
    end if;
	--Consultamos el audit anterior
	select coalesce(redpa_audit, '') into redpaAudit from red_pago where redpa_codigo = redpacodigo;
	--A los datos anteriores le agregamos los nuevos
	update red_pago 
	set redpa_audit = redpaAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', upper(procedimiento),
		'redpa_descripcion', upper(redpadescripcion),
		'redpa_estado', upper(redpaestado)
	)||','
	where redpa_codigo = redpacodigo;
end
$function$ 
language plpgsql;

--DML
select 
         p.pro_codigo,
         p.tipro_codigo,
         p.pro_razonsocial,
         tp.tipro_descripcion 
      from proveedor p 
         join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
         where (p.pro_ruc ilike '%el hi%' or p.pro_razonsocial ilike '%el hi%')
         and p.pro_estado = 'ACTIVO' 
      order by p.pro_codigo;
select 
            s.suc_codigo, 
            s.suc_descripcion 
         from sucursal s 
         where s.emp_codigo = 1 
         and s.suc_descripcion ilike '%%'
         and s.suc_estado = 'ACTIVO';
select 
         g.gui_descripcion as interfaz, 
         perfgui_estado as estado,
         g.modu_codigo as modulo
      from perfil_gui pg
         join perfil p on p.perf_codigo=pg.perf_codigo
         join gui g on g.gui_codigo=pg.gui_codigo
         and g.modu_codigo=pg.modu_codigo
      where p.perf_descripcion='ADMINISTRADOR'
      order by pg.perfgui_codigo

delete from actualizacion_contrasenia;
select 
	c.ciu_codigo,
	c.ciu_descripcion,
	c.ciu_estado 
from ciudad c s
order by c.ciu_codigo;

select 
  c.config_codigo,
  c.config_validacion 
from configuraciones_sucursal cs 
	join configuraciones c on c.config_codigo=cs.config_codigo 
	join sucursal s on s.suc_codigo=cs.suc_codigo
	and s.emp_codigo=cs.emp_codigo 
where cs.suc_codigo=1
	and cs.emp_codigo=1
	and cs.configsuc_estado='ACTIVO'
order by c.config_codigo;

select 
	p.per_numerodocumento,
	c.cli_codigo,
	p.per_nombre||' '||p.per_apellido cliente,
	vc.ven_codigo,
	vc.ven_numfactura,
	'VENTA N°:'||vc.ven_codigo||' FACTURA:'||vc.ven_numfactura||' '||'FECHA:'||to_char(vc.ven_fecha , 'DD-MM-YYYY') venta
from venta_cab vc 
join cliente c on c.cli_codigo=vc.cli_codigo 
	join personas p on p.per_codigo=c.per_codigo 
where p.per_numerodocumento ilike '%53%'
and vc.ven_estado <> 'ANULADO'
and ((current_date-vc.ven_fecha) <= 7)
order by vc.ven_numfactura;


select current_date-'19/04/2025' as dias;

select
	c.config_codigo,
	c.config_validacion,
	c.config_descripcion 
from configuraciones c 
where c.config_descripcion ilike '%habi%'
and c.config_estado='ACTIVO'
order by c.config_codigo;

select 
	cs.configsuc_codigo,
	cs.config_codigo,
	cs.suc_codigo,
	cs.emp_codigo,
	cs.configsuc_estado,
	e.emp_razonsocial,
	s.suc_descripcion,
	c.config_descripcion,
	c.config_validacion 
from configuraciones_sucursal cs 
join configuraciones c on c.config_codigo=cs.config_codigo 
join sucursal s on s.suc_codigo=cs.suc_codigo 
and s.emp_codigo=cs.emp_codigo 
	join empresa e on e.emp_codigo=s.emp_codigo 
order by cs.configsuc_codigo;

select 
	config_codigo,
	config_validacion,
	config_descripcion,
	config_estado
from configuraciones 
order by config_codigo;

select 
 vd.dep_codigo,
 vd.it_codigo,
 vd.tipit_codigo,
 ti.tipit_descripcion,
 i.tipim_codigo,
 (case 
		ti.tipit_descripcion 
	 when 'PRODUCTO'
	       then 
	         i.it_descripcion||' '||m.mod_codigomodelo
	       else 
	         i.it_descripcion 
 end) it_descripcion,
(case 
		ti.tipit_descripcion 
	 when 'PRODUCTO'
	       then 
	         i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion 
	       else 
	         i.it_descripcion 
end) it_descripcion2,
t.tall_descripcion,
vd.vendet_cantidad notvendet_cantidad,
um.unime_descripcion,
vd.vendet_precio as notvendet_precio
from venta_det vd 
	join venta_cab vc on vc.ven_codigo=vd.ven_codigo 
	join stock s on s.it_codigo=vd.it_codigo 
	and s.tipit_codigo=vd.tipit_codigo 
	and s.dep_codigo=vd.dep_codigo
	and s.suc_codigo=vd.suc_codigo 
	and s.emp_codigo=vd.emp_codigo 
	join items i on i.it_codigo=s.it_codigo 
	and i.tipit_codigo=s.tipit_codigo 
		join tipo_item ti on ti.tipit_codigo=i.tipit_codigo 
		join talle t on t.tall_codigo=i.tall_codigo 
		join modelo m on m.mod_codigo=i.mod_codigo 
		join unidad_medida um on um.unime_codigo=i.unime_codigo 
	join deposito d on d.dep_codigo=s.dep_codigo 
	and d.suc_codigo=s.suc_codigo 
	and d.emp_codigo=s.emp_codigo 
		join sucursal s2 on s2.suc_codigo=d.suc_codigo 
		and s2.emp_codigo=d.emp_codigo 
			join empresa e on e.emp_codigo=s2.emp_codigo 
where i.it_estado='ACTIVO'
	and ti.tipit_descripcion in('PRODUCTO', 'SERVICIO')
	and (i.it_descripcion ilike '%%' or m.mod_codigomodelo ilike '%%')
	and vc.ven_codigo=1
	and vc.ven_estado <> 'ANULADO'
	and vc.suc_codigo=1 and vc.emp_codigo=1
order by vd.ven_codigo, vd.it_codigo;

select 
	i.it_codigo,
	i.tipit_codigo,
	ti.tipit_descripcion,
	i.tipim_codigo,
	(case 
			ti.tipit_descripcion 
	 	when 'PRODUCTO'
	        then 
	         	i.it_descripcion||' '||m.mod_codigomodelo
	         else 
	         	i.it_descripcion 
	 end) it_descripcion,
	 (case 
			ti.tipit_descripcion 
	 	when 'PRODUCTO'
	        then 
	         	i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion 
	         else 
	         	i.it_descripcion 
	 end) it_descripcion2,
	 t.tall_descripcion,
	 (case 
	 	when ti.tipit_descripcion='PRODUCTO' and s.st_cantidad<=0
	        then 
	         	'NO HAY STOCK'
	         else 
	         	CAST(s.st_cantidad AS VARCHAR)
	 end) notvendet_cantidad,
	 um.unime_descripcion,
	 i.it_precio as notvendet_precio
from stock s 
join items i on i.it_codigo=s.it_codigo 
and i.tipit_codigo=s.tipit_codigo 
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo 
	join talle t on t.tall_codigo=i.tall_codigo 
	join modelo m on m.mod_codigo=i.mod_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo 
join deposito d on d.dep_codigo=s.dep_codigo 
and d.suc_codigo=s.suc_codigo 
and d.emp_codigo=s.emp_codigo 
	join sucursal s2 on s2.suc_codigo=d.suc_codigo 
	and s2.emp_codigo=d.emp_codigo 
		join empresa e on e.emp_codigo=s2.emp_codigo 
where i.it_estado='ACTIVO'
and ti.tipit_descripcion in('PRODUCTO', 'SERVICIO')
and (i.it_descripcion ilike '%fle%' or m.mod_codigomodelo ilike '%fle%')
and s.dep_codigo=1 and s.suc_codigo=1 and s.emp_codigo=1
order by i.it_codigo;

select distinct 
	p.per_nombre||' '||p.per_apellido cliente,
	p.per_email correo
from cobro_det cd 
join venta_cab vc on vc.ven_codigo=cd.ven_codigo 
join cliente c on c.cli_codigo=vc.cli_codigo 
join personas p on p.per_codigo=c.per_codigo 
where cd.cob_codigo=1;


select 
	p.per_nombre||' '||p.per_apellido cliente,
	p.per_email correo
from cliente c 
join personas p on p.per_codigo=c.per_codigo 
where p.per_numerodocumento='5346486';

select 
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
where cc.cob_codigo=1;
select 
	vcd.cob_codigo codigo,
	sum(vcd.cobdet_monto) monto,
	(select to_char(max(cc.cob_fecha), 'dd-mm-yyyy') from cobro_cab cc where cc.cob_codigo=1) fecha,
	vcd.cliente,
	'DE LA CUOTA '||vcd.cobdet_numerocuota||'/'||vcd.cuota||' POR LA COMPRA N° '||vcd.factura concepto,
	(select 
		p.per_email
	from cliente c 
	join personas p on p.per_codigo=c.per_codigo 
	where p.per_numerodocumento=vcd.ci) correo
from v_cobro_det vcd 
where vcd.cob_codigo=1
	group by 1,3,4,5,6;

select date(max(cc.cob_fecha)) from cobro_cab cc where cc.cob_codigo=1
select * from v_cobro_det vcd limit 1;
(select to_char(max(cc.cob_fecha), 'dd-mm-yyyy') from cobro_cab cc where cc.cob_codigo=1); 
select    
               coalesce(sum(cd.cobdet_monto), 0) as montoventa 
          from cobro_det cd 
          join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
          where cc.cob_estado='ACTIVO' and
          cd.ven_codigo = 1;
select
 rp.redpa_codigo,
 rp.redpa_descripcion 
from red_pago rp 
where rp.redpa_descripcion ilike '%%'
and redpa_estado = 'ACTIVO'
order by redpa_codigo;
select distinct 
	fc.forco_descripcion 
from cobro_det cd 
join forma_cobro fc on fc.forco_codigo=cd.forco_codigo 
where cd.cob_codigo=1 and fc.forco_descripcion='EFECTIVO';

select 
from cobro_det cd 
join forma_cobro fc on fc.forco_codigo=cd.forco_codigo 
where cd.ven_codigo=1 
and cd.cob_codigo=1;

select 
	fc.forco_codigo,
	fc.forco_descripcion 
from forma_cobro fc 
where forco_estado = 'ACTIVO'
order by forco_codigo;

select 
         i.it_codigo,
         i.tipit_codigo,
         (case 
			i.tipit_codigo
	     when 2
	        then 
	         	i.it_descripcion||' '||m.mod_codigomodelo
	         else 
	         	i.it_descripcion 
	     end) as item,
     	(case 
			i.tipit_codigo
	     when 2
	        then 
	         	i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion 
	         else 
	         	i.it_descripcion 
	     end) as item2,
         t.tall_descripcion,
         um.unime_codigo,
         um.unime_descripcion,
         i.it_precio as pevendet_precio
      from items i
         join modelo m on m.mod_codigo=i.mod_codigo
         join talle t on t.tall_codigo=i.tall_codigo 
         join unidad_medida um on um.unime_codigo=i.unime_codigo
         where (i.it_descripcion ilike '%%' 
         or m.mod_codigomodelo ilike '%%') 
         and tipit_codigo in(2, 3) 
         and it_estado = 'ACTIVO'
      order by i.it_codigo;

select 
         pvc.peven_codigo,
         'Pedido Venta N°'||pvc.peven_codigo||' '||to_char(pvc.peven_fecha , 'DD-MM-YYYY') as pedido,
         pvc.cli_codigo,
         p.per_nombre||' '||p.per_apellido as cliente,
         p.per_numerodocumento 
      from pedido_venta_cab pvc
         join cliente c on c.cli_codigo=pvc.cli_codigo
        	 join personas p on p.per_codigo=c.per_codigo
      where (p.per_numerodocumento ilike '%%' and m.)
      and pvc.peven_estado='TERMINADA'
      and pvc.suc_codigo=1
      and pvc.emp_codigo=1
      order by pvc.peven_codigo;
     
select 
	pvd.it_codigo,
	pvd.tipit_codigo,
	i.tipim_codigo,
	(case 
		pvd.tipit_codigo
     when 2
        then 
         	i.it_descripcion||' '||m.mod_codigomodelo
         else 
         	i.it_descripcion 
     end) as item,
     (case 
		pvd.tipit_codigo
     when 2
        then 
         	i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion 
         else 
         	i.it_descripcion 
     end) as item2,
     t.tall_descripcion,
     um.unime_codigo,
     um.unime_descripcion,
     pd.presdet_cantidad as vendet_cantidad,
     pd.presdet_precio as vendet_precio
from pedido_venta_det pvd 
join items i on i.it_codigo=pvd.it_codigo 
and i.tipit_codigo=pvd.tipit_codigo 
	join modelo m on m.mod_codigo=i.mod_codigo 
	join talle t on t.tall_codigo=i.tall_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo 
join pedido_venta_cab pvc on pvc.peven_codigo=pvd.peven_codigo 
	join presupuesto_cab pc on pc.peven_codigo=pvc.peven_codigo 
		join presupuesto_det pd on pd.pres_codigo=pc.pres_codigo 
where pvd.peven_codigo=1
and i.it_estado='ACTIVO'
and pvc.peven_estado='VENDIDO'
and pc.pres_estado='APROBADO'
and (i.it_descripcion ilike '%%' or m.mod_codigomodelo ilike '%%')
and i.tipit_codigo in (2, 3)
order by pvd.peven_codigo, pvd.it_codigo;

select 
            pvd.it_codigo,
            pvd.tipit_codigo,
            i.tipim_codigo,
            (case 
               pvd.tipit_codigo
            when 2
               then 
                     i.it_descripcion||' '||m.mod_codigomodelo
                  else 
                     i.it_descripcion 
            end) as item,
            (case 
               pvd.tipit_codigo
            when 2
               then 
                     i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion 
                  else 
                     i.it_descripcion 
            end) as item2,
            t.tall_descripcion,
            um.unime_codigo,
            um.unime_descripcion,
            pd.presdet_cantidad as vendet_cantidad,
            pd.presdet_precio as vendet_precio
         from pedido_venta_det pvd 
         join items i on i.it_codigo=pvd.it_codigo 
         and i.tipit_codigo=pvd.tipit_codigo 
            join modelo m on m.mod_codigo=i.mod_codigo 
            join talle t on t.tall_codigo=i.tall_codigo 
            join unidad_medida um on um.unime_codigo=i.unime_codigo 
         join pedido_venta_cab pvc on pvc.peven_codigo=pvd.peven_codigo 
            join presupuesto_cab pc on pc.peven_codigo=pvc.peven_codigo 
               join presupuesto_det pd on pd.pres_codigo=pc.pres_codigo 
               and pd.it_codigo=pvd.it_codigo
         where pvd.peven_codigo=1
         and i.it_estado='ACTIVO'
         and pvc.peven_estado='VENDIDO'
         and pc.pres_estado='APROBADO'
         and (i.it_descripcion ilike '%%' or m.mod_codigomodelo ilike '%%')
         and i.tipit_codigo in (2, 3)
         order by pvd.peven_codigo, pvd.it_codigo;

update 
	factura_venta 
set facven_numero='' 
where suc_codigo=1 
and emp_codigo=1 
and caj_codigo=1;

select 
         pvc.peven_codigo,
         'Pedido Venta N°'||pvc.peven_codigo||' '||to_char(pvc.peven_fecha , 'DD-MM-YYYY') as pedido,
         pvc.cli_codigo,
         p.per_nombre||' '||p.per_apellido as cliente,
         p.per_numerodocumento 
      from pedido_venta_cab pvc
         join cliente c on c.cli_codigo=pvc.cli_codigo
        	 join personas p on p.per_codigo=c.per_codigo
      where p.per_numerodocumento ilike '%%' 
      and pvc.peven_estado='TERMINADA'
      order by pvc.peven_codigo;

select
	s.suc_descri,
	c.caj_descri,
	lpad(cast(f.suc_cod as text), 3, '0')|| '-' || 
	lpad(cast(f.caj_cod as text), 3, '0')|| '-' || f.fac_nro as factura
from facturas f 
	join sucursal s on s.suc_cod = f.suc_cod and s.emp_cod = f.emp_cod 
		join empresa e on e.emp_cod = s.emp_cod 
	join caja c on c.caj_cod = f.caj_cod
order by f.suc_cod, f.caj_cod;

select 
	e.emp_razonsocial,
	s.suc_descripcion,
	c.caj_descripcion,
	lpad(cast(fv.suc_codigo as text), 3, '0')|| '-' || 
	lpad(cast(fv.caj_codigo as text), 3, '0')|| '-' || 
	fv.facven_numero as factura
from factura_venta fv 
join sucursal s on s.suc_codigo=fv.suc_codigo and s.emp_codigo=fv.emp_codigo 
	join empresa e on e.emp_codigo=s.emp_codigo 
join caja c on c.caj_codigo=fv.caj_codigo 
order by fv.suc_codigo, fv.caj_codigo;

-- Consulta para generar factura
select 
	lpad(cast(fv.suc_codigo as text), 3, '0')|| '-' || 
	lpad(cast(fv.caj_codigo as text), 3, '0')|| '-' || 
	lpad(cast((cast(fv.facven_numero as integer)+1) as text), 7, '0') as ven_numfactura
from factura_venta fv 
where fv.suc_codigo=1
	and fv.emp_codigo=1
	and fv.caj_codigo=1;

select cast(fv.facven_numero as integer) from factura_venta fv;



select
 	s.suc_codigo,
 	s.suc_descripcion 
from sucursal s
where s.suc_descripcion ilike '%%'
	and s.emp_codigo=1
	and s.suc_estado='ACTIVO'
order by s.suc_codigo;

ALTER TABLE venta_cab RENAME COLUMN vent_montocuota TO ven_montocuota;
select 
	e.emp_razonsocial,
	e.emp_ruc,
	s.suc_descripcion,
	s.suc_telefono,
	s.suc_email 
from sucursal s 
join empresa e on e.emp_codigo=s.emp_codigo
where s.suc_descripcion='CASA MATRIZ';

select
	u.usu_login,
	p.per_nombre||' '||p.per_apellido as persona
from usuario u 
join funcionario f on f.func_codigo=u.func_codigo 
join personas p on p.per_codigo=f.per_codigo 
where u.usu_login='ssan';
select
            coalesce(sum(case when cd.forco_codigo=1 then cd.cobdet_monto else 0 end), 0) as montoefectivo,
            coalesce(sum(case when cd.forco_codigo=3 then cc2.coche_monto else 0 end), 0) as montocheque
         from cobro_det cd
         join cobro_cab cc on cc.cob_codigo=cd.cob_codigo
         join cobro_cheque cc2 on cc2.cob_codigo=cd.cob_codigo
         join apertura_cierre ac on ac.apercie_codigo=cc.apercie_codigo
         where ac.apercie_codigo=1;
select 
         coalesce(sum(cobdet_monto), 0) as totalcierre 
      from cobro_det cd 
      join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
      join apertura_cierre ac on ac.apercie_codigo=cc.apercie_codigo 
      where cc.cob_fecha between ac.apercie_fechahoraapertura and '{$_POST['apercie_fechahoracierre']}' 
      and cc.cob_estado='ACTIVO' 
      and ac.apercie_codigo={$_POST['apercie_codigo']};

select 
	s.secc_descripcion,
	opc.orpro_codigo,
	'Orden Produccion N°'||opc.orpro_codigo||' '||to_char(opc.orpro_fecha, 'DD-MM-YYYY') as orden
from orden_produccion_cab opc 
	join seccion s on s.secc_codigo=opc.secc_codigo 
	where opc.orpro_estado <> 'ANULADO'
	and opc.suc_codigo=1
	and opc.orpro_codigo not in (select cpc.orpro_codigo from costo_produccion_cab cpc where cpc.copro_estado='ACTIVO')
	and s.secc_descripcion ilike '%sesdfasdc%'
order by opc.orpro_codigo;



select 
	opd.it_codigo,
	opd.tipit_codigo,
	sum(opd.orprodet2_cantidad) as cantidad_materia,
	i.it_costo
from orden_produccion_det2 opd 
join componente_produccion_det cpd on cpd.compro_codigo=opd.compro_codigo 
and cpd.it_codigo=opd.it_codigo 
and cpd.tipit_codigo=opd.tipit_codigo 
join items i on i.it_codigo=cpd.it_codigo 
and i.tipit_codigo=cpd.tipit_codigo 
where opd.orpro_codigo=1
group by opd.it_codigo, opd.tipit_codigo, i.it_costo;

select 
	ptd.it_codigo,
	i.it_descripcion||' COD:'||m.mod_codigomodelo||' TALL:'||t.tall_descripcion as item2,
	ptd.proterdet_cantidad as cantidad_total,
	(select 
		coalesce(sum(ccd.concadet_cantidadfallida), 0)
	from control_calidad_det ccd 
		join control_calidad_cab ccc on ccc.conca_codigo=ccd.conca_codigo 
	where ccc.proter_codigo=1 
	and ccd.it_codigo=ptd.it_codigo
	) as cantidad_fallida,
	(ptd.proterdet_cantidad)
	-
	(select 
		coalesce(sum(ccd.concadet_cantidadfallida),0) 
	from control_calidad_det ccd 
		join control_calidad_cab ccc on ccc.conca_codigo=ccd.conca_codigo 
	where ccc.proter_codigo=1 
	and ccd.it_codigo=ptd.it_codigo
	) as cantidad_item_correcto
from produccion_terminada_det ptd 
join stock s on s.it_codigo=ptd.it_codigo 
	and s.tipit_codigo=ptd.tipit_codigo 
	and s.dep_codigo=ptd.dep_codigo 
	and s.suc_codigo=ptd.suc_codigo 
	and s.emp_codigo=ptd.emp_codigo 
		join items i on i.it_codigo=s.it_codigo 
		and i.tipit_codigo=s.tipit_codigo 
			join modelo m on m.mod_codigo=i.mod_codigo 
			join talle t on t.tall_codigo=i.tall_codigo 
			join unidad_medida um on um.unime_codigo=i.unime_codigo
where ptd.proter_codigo=1;

select sum(ccd.concadet_cantidadfallida) from control_calidad_det ccd join control_calidad_cab ccc on ccc.conca_codigo=ccd.conca_codigo 
where ccc.proter_codigo=1 and ccd.it_codigo=6;

select 
	pcc.pacoca_codigo,
	pcc.pacoca_descripcion,
	pcc.pacoca_estado 
from parametro_control_calidad pcc 
where pcc.pacoca_estado='ACTIVO'
and pacoca_descripcion ilike '%colo%';

select 
	ptd.it_codigo,
	ptd.tipit_codigo,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	i.it_descripcion||' COD:'||m.mod_codigomodelo||' TALL:'||t.tall_descripcion as item2,
	t.tall_descripcion,
	um.unime_codigo,
	um.unime_descripcion 
from produccion_terminada_det ptd 
	join stock s on s.it_codigo=ptd.it_codigo 
	and s.tipit_codigo=ptd.tipit_codigo 
	and s.dep_codigo=ptd.dep_codigo 
	and s.suc_codigo=ptd.suc_codigo 
	and s.emp_codigo=ptd.emp_codigo 
		join items i on i.it_codigo=s.it_codigo 
		and i.tipit_codigo=s.tipit_codigo 
			join modelo m on m.mod_codigo=i.mod_codigo 
			join talle t on t.tall_codigo=i.tall_codigo 
			join unidad_medida um on um.unime_codigo=i.unime_codigo
where ptd.proter_codigo=1
	and i.it_estado='ACTIVO'
	and i.tipit_codigo=2
	and (i.it_descripcion ilike '%100%' or m.mod_codigomodelo ilike '%100%')
order by ptd.it_codigo;


select distinct
	opd.it_codigo,
	opd.tipit_codigo,
	i.it_descripcion,
	i.it_costo as merdet_precio,
	um.unime_codigo,
	um.unime_descripcion 
from produccion_terminada_cab ptc 
	join produccion_cab pc on pc.prod_codigo=ptc.prod_codigo 
		join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
			join orden_produccion_det2 opd on opd.orpro_codigo=opc.orpro_codigo
				join componente_produccion_det cpd on cpd.compro_codigo=opd.compro_codigo 
				and cpd.it_codigo=opd.it_codigo and cpd.tipit_codigo=opd.tipit_codigo 
					join items i on i.it_codigo=cpd.it_codigo 
					and i.tipit_codigo=cpd.tipit_codigo 
						join unidad_medida um on um.unime_codigo=i.unime_codigo 
where ptc.proter_codigo=1
and i.it_estado='ACTIVO'
and i.tipit_codigo=1
and i.it_descripcion ilike '%%'
order by opd.it_codigo;

select coalesce(max(mer_codigo),0)+1 as mer_codigo from mermas_cab;


select 
	s.secc_descripcion,
	'Produccion Terminada N°'||ptc.proter_codigo||' '||to_char(ptc.proter_fecha,'DD-MM-YYYY') as produccion_terminada,
	ptc.proter_codigo 
from produccion_terminada_cab ptc 
	join produccion_cab pc on pc.prod_codigo=ptc.prod_codigo 
		join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
			join seccion s on s.secc_codigo=opc.secc_codigo 
where ptc.proter_estado='ACTIVO'
	and opc.suc_codigo=1
	and ptc.proter_codigo not in (select mc.proter_codigo from mermas_cab mc where mc.mer_estado='ACTIVO')
	and s.secc_descripcion ilike '%seccion 1%'
order by ptc.proter_codigo;

select mc.proter_codigo from mermas_cab mc where mc.mer_estado='ACTIVO';

select 
         pd.it_codigo,
         pd.tipit_codigo,
         i.it_descripcion||' '||m.mod_codigomodelo as item,
         i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as item2,
         t.tall_descripcion,
         pd.prodet_cantidad as proterdet_cantidad,
         um.unime_codigo,
         um.unime_descripcion 
      from produccion_det pd 
         join items i on i.it_codigo=pd.it_codigo
         and i.tipit_codigo=pd.tipit_codigo
         join modelo m on m.mod_codigo=i.mod_codigo
         join talle t on t.tall_codigo=i.tall_codigo
         join unidad_medida um on um.unime_codigo=i.unime_codigo 
         where (i.it_descripcion ilike '%100%' or m.mod_codigomodelo ilike '%100%')
         and i.it_estado='ACTIVO'
         and i.tipit_codigo=2
         and pd.prod_codigo=1
      order by pd.it_codigo;

select * from v_produccion_terminada_det vptd where vptd.proter_codigo=1;

select * from v_produccion_terminada_cab vptc where vptc.proter_estado <> 'ANULADO';

select coalesce(max(proter_codigo),0)+1 as proter_codigo from produccion_terminada_cab;

select 
            s.secc_descripcion,
            'Produccion N°'||pc.prod_codigo||' '||to_char(pc.prod_fecha,'DD-MM-YYYY') as produccion,
            pc.prod_codigo,
            opc.orpro_fechaculminacion as proter_fechaculminacion
         from produccion_cab pc 
            join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
            join seccion s on s.secc_codigo=opc.secc_codigo 
            where pc.prod_estado='TERMINADO'
            and opc.suc_codigo=1
            and pc.prod_codigo not in (select ptc.prod_codigo from produccion_terminada_cab ptc where ptc.proter_estado='ACTIVO')
            and s.secc_descripcion ilike '%secci%'
         order by pc.prod_codigo;

DO $$
DECLARE
	prodAudit text;
	orproAudit text;
	orproCodigo integer;
    c_produccion cursor is
	select 
	pc.prod_fecha,
	pc.orpro_codigo,
	s.secc_descripcion,
	opc.orpro_fechainicio,
	opc.orpro_fechaculminacion,
	pc.prod_estado
	from produccion_cab pc 
	join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
	join seccion s on s.secc_codigo=opc.secc_codigo 
	where pc.prod_codigo=1;
	c_orden cursor is
	select 
	opc.orpro_fecha,
	opc.orpro_fechainicio,
	opc.orpro_fechaculminacion,
	opc.secc_codigo,
	s.secc_descripcion,
	opc.orpro_estado
	from produccion_cab pc 
	join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
	join seccion s on s.secc_codigo=opc.secc_codigo 
	where pc.prod_codigo=1;
BEGIN
  --Actualizamos el estado de produccion cabecera
  update produccion_cab set prod_estado = 'TERMINADO' where prod_codigo = 1;
  --Auditamos el cambio de estado de produccion cabecera
  --Consultamos el audit anterior
  select coalesce(prod_audit, '') into prodAudit from produccion_cab where prod_codigo=1;
  --Consultamos los datos del cursor y auditamos
  for prod in c_produccion loop
		update produccion_cab 
		set prod_audit = prodAudit||''||json_build_object(
		'usu_codigo', usucodigo,
		'usu_login', usulogin,
		'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
		'procedimiento', 'MODIFICACION',
		'prod_fecha', prod.prod_fecha,
		'orpro_codigo', prod.orpro_codigo,
		'secc_descripcion', prod.secc_descripcion,
		'orpro_fechainicio', prod.orpro_fechainicio,
		'orpro_fechaculminacion', prod.orpro_fechaculminacion,
		'emp_codigo', empcodigo,
		'emp_razonsocial', upper(emprazonsocial),
		'suc_codigo', succodigo,
		'suc_descripcion', upper(sucdescripcion),
		'prod_estado', prod.prod_estado
		)||','
		where prod_codigo = 1;
  end loop;
  --Extraemos el codigo de la orden de produccion asociada a la produccion cabecera
  orproCodigo := (select orpro_codigo from produccion_cab where prod_codigo = 1);
  --Actualizamos el estado de orden produccion cabecera asociado a la produccion cabecera
  update orden_produccion_cab set orpro_estado = 'TERMINADO' where orpro_codigo = orproCodigo;
  --Auditamos el cambio de estado de orden produccion cabecera
  --Consultamos el audit anterior
  select coalesce(orpro_audit, '') into orproAudit from orden_produccion_cab where orpro_codigo=orproCodigo;
  --a los datos anteriores le agregamos los nuevos
  for ord in c_orden loop
		update orden_produccion_cab 
		set orpro_audit = orproAudit||''||json_build_object(
			'usu_codigo', usucodigo,
			'usu_login', usulogin,
			'fecha', to_char(current_timestamp, 'DD-MM-YYYY HH24:MI:SS'),
			'procedimiento', 'MODIFICACION',
			'orpro_fecha', ord.orpro_fecha,
			'orpro_fechainicio', ord.orpro_fechainicio,
			'orpro_fechaculminacion', ord.orpro_fechaculminacion,
			'secc_codigo', ord.secc_codigo,
			'secc_descripcion', ord.secc_descripcion,
			'emp_codigo', empcodigo,
			'emp_razonsocial', upper(emprazonsocial),
			'suc_codigo', succodigo,
			'suc_descripcion', upper(sucdescripcion),
			'orpro_estado', ord.orpro_estado
		)||','
		where orpro_codigo = orproCodigo;
 end loop;
END $$;


		select 
		opc.orpro_fecha,
		opc.orpro_fechainicio,
		opc.orpro_fechaculminacion,
		opc.secc_codigo,
		s.secc_descripcion,
		opc.orpro_estado
		from produccion_cab pc 
		join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
		join seccion s on s.secc_codigo=opc.secc_codigo 
		where pc.prod_codigo = 1;

update orden_produccion_cab set orpro_estado = 'TERMINADO' where orpro_codigo = orproCodigo;

select 
	pc.prod_fecha,
	pc.orpro_codigo,
	s.secc_descripcion,
	opc.orpro_fechainicio,
	opc.orpro_fechaculminacion,
	pc.prod_estado
from produccion_cab pc 
join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
join seccion s on s.secc_codigo=opc.secc_codigo 
where pc.prod_codigo=1;


update produccion_cab set prod_estado = 'TERMINADO' where prod_codigo = 1;

select 
	pd.prodet_estado
from produccion_det pd 
where pd.prod_codigo=1;

update produccion_det set prodet_estado = 'TERMINADO'
where prod_codigo=1 and it_codigo=2 and tipit_codigo=2;

select 
	m.maq_codigo,
	m.maq_descripcion,
	m.maq_estado 
from maquinaria m 
where m.maq_descripcion ilike '%%'
and m.maq_estado='ACTIVO'
order by m.maq_codigo;

select
	tep.tipet_codigo,
	tep.tipet_descripcion,
	tep.tipet_estado 
from tipo_etapa_produccion tep 
where tep.tipet_descripcion ilike '%afasd%';

select 
	pd.it_codigo,
	pd.tipit_codigo,
	pd.prodet_estado,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	i.it_descripcion||' COD:'||m.mod_codigomodelo||' TALL:'||t.tall_descripcion as item2,
	t.tall_descripcion 
from produccion_det pd 
join produccion_cab pc on pc.prod_codigo=pd.prod_codigo 
join items i on i.it_codigo=pd.it_codigo 
and i.tipit_codigo=pd.tipit_codigo 
join modelo m on m.mod_codigo=i.mod_codigo 
join talle t on t.tall_codigo=i.tall_codigo 
where pd.prod_codigo=1
and pd.prodet_estado='ACTIVO'
and pc.prod_estado='ACTIVO' 
and i.it_estado='ACTIVO'
and i.tipit_codigo=2
order by pd.it_codigo;

select 
	s.secc_descripcion,
	'Produccion N°'||pc.prod_codigo||' '||to_char(pc.prod_fecha,'DD-MM-YYYY') as produccion,
	pc.prod_codigo 
from produccion_cab pc 
join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
join seccion s on s.secc_codigo=opc.secc_codigo 
where pc.prod_estado='ACTIVO'
and opc.suc_codigo=1
and s.secc_descripcion ilike '%secc%'
order by pc.prod_codigo;


select
  	i.it_codigo,
  	i.tipit_codigo,
  	ti.tipit_descripcion,
  	i.it_descripcion as item,
  	i.it_descripcion||' COD:'||m.mod_codigomodelo||' COL:'||cp.col_descripcion||' TALL:'||t.tall_descripcion as item2,
  	m.mod_codigomodelo,
  	cp.col_descripcion,
  	t.tall_descripcion
from items i 
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join modelo m on m.mod_codigo=i.mod_codigo
join color_prenda cp on cp.col_codigo=m.col_codigo
join talle t on t.tall_codigo=i.tall_codigo
where (i.it_descripcion ilike '%pantalon%' or m.mod_codigomodelo ilike '%100%')
and i.it_estado='ACTIVO'
and i.tipit_codigo=2
order by i.it_codigo;

select
  	i.it_codigo,
  	i.tipit_codigo,
  	i.it_descripcion as item2,
  	um.unime_codigo,
  	um.unime_descripcion 
from items i 
join unidad_medida um on um.unime_codigo=i.unime_codigo
where i.it_descripcion ilike '%%'
and i.it_estado='ACTIVO'
and i.tipit_codigo=1
order by i.it_codigo;

SELECT 
            p.perm_descripcion, 
            apu.asigperm_estado 
         FROM asignacion_permiso_usuario apu 
            JOIN permisos p ON p.perm_codigo = apu.perm_codigo 
         WHERE usu_codigo = 5 
         order by p.perm_codigo;
select 
         pd.it_codigo,
         pd.tipit_codigo,
         i.it_descripcion||' '||m.mod_codigomodelo as item,
         i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as item2,
         t.tall_descripcion,
         um.unime_codigo,
         um.unime_descripcion,
         pd.presdet_cantidad as orprodet_cantidad
      from presupuesto_det pd
         join items i on i.it_codigo=pd.it_codigo
         and i.tipit_codigo=pd.tipit_codigo
         join modelo m on m.mod_codigo=i.mod_codigo
         join talle t on t.tall_codigo=i.tall_codigo
         join unidad_medida um on um.unime_codigo=i.unime_codigo 
      where pd.pres_codigo=1
      and i.it_descripcion ilike '%pa%' 
      and i.it_estado='ACTIVO'
      and i.tipit_codigo=2
      order by pd.it_codigo;
select 
         p.per_numerodocumento,
         p.per_nombre||' '||p.per_apellido as cliente,
         pc.pres_codigo,
         pc.peven_codigo,
         'Presupuesto N°'||pc.pres_codigo||' '||to_char(pc.pres_fecharegistro, 'DD-MM-YYYY') as presupuesto
      from presupuesto_cab pc 
      join cliente c on c.cli_codigo=pc.cli_codigo 
      join personas p on p.per_codigo=c.per_codigo 
      where p.per_numerodocumento ilike '%88%'
      and pc.pres_estado='ACTIVO'
      order by pc.pres_codigo;
select 
	pd.*,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	t.tall_descripcion,
	um.unime_descripcion,
	(case i.tipim_codigo when 1 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as exenta
from presupuesto_det pd
	join items i on i.it_codigo=pd.it_codigo
	and i.tipit_codigo=pd.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo 
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join unidad_medida um on um.unime_codigo=i.unime_codigo 
where pd.pres_codigo=1;
select 
	e.emp_razonsocial,
	s.suc_descripcion,
	 'RUC: '||e.emp_ruc as emp_ruc,
	pc.pres_codigo,
	p.per_nombre||' '||p.per_apellido as cliente,
	(case 
    when p.tipdo_codigo=1 then 'CI:' 
    when p.tipdo_codigo=2 then 'RUC:'
    else 'PASAPORTE:'
    end) as tipdo_descripcion,
    p.per_numerodocumento as cliente_documento,
    p.per_email as cliente_correo,
    to_char(pc.pres_fecharegistro, 'DD-MM-YYYY') as pres_fecharegistro,
    to_char(pc.pres_fechavencimiento, 'DD-MM-YYYY') as pres_fechavencimiento,
	pc.peven_codigo,
	p2.per_nombre||' '||p2.per_apellido as funcionario,
	u.usu_login,
	s.suc_telefono,
	s.suc_email
from presupuesto_cab pc
	join usuario u on u.usu_codigo=pc.usu_codigo
	join sucursal s on s.suc_codigo=pc.suc_codigo
	and s.emp_codigo=pc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
	join cliente c on c.cli_codigo=pc.cli_codigo
	join personas p on p.per_codigo=c.per_codigo
	join funcionario f on f.func_codigo=u.func_codigo
	join personas p2 on p2.per_codigo=f.per_codigo
where pc.pres_codigo=1;
select 
         pvd.it_codigo,
         pvd.tipit_codigo,
         i.it_descripcion||' '||m.mod_codigomodelo as item,
         i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as item2,
         pvd.pevendet_cantidad as presdet_cantidad,
         t.tall_descripcion,
         um.unime_codigo,
         um.unime_descripcion,
         i.it_precio as presdet_precio
      from pedido_venta_det pvd
         join items i on i.it_codigo=pvd.it_codigo
         and i.tipit_codigo=pvd.tipit_codigo 
         join modelo m on m.mod_codigo=i.mod_codigo
         join talle t on t.tall_codigo=i.tall_codigo 
         join unidad_medida um on um.unime_codigo=i.unime_codigo
         where pvd.peven_codigo=1
         and i.it_descripcion ilike '%%'
         and i.it_estado='ACTIVO'
         and i.tipit_codigo=2
      order by i.it_codigo;
select 
         pvc.peven_codigo,
         'Pedido N°'||pvc.peven_codigo||' '||to_char(pvc.peven_fecha , 'DD-MM-YYYY') as pedido,
         pvc.cli_codigo,
         p.per_nombre||' '||p.per_apellido as cliente,
         p.per_numerodocumento 
      from pedido_venta_cab pvc
         join cliente c on c.cli_codigo=pvc.cli_codigo
         join personas p on p.per_codigo=c.per_codigo
        where p.per_numerodocumento ilike '%%'
         and pvc.peven_estado='ACTIVO'
      order by pvc.peven_codigo;
select 
         i.it_codigo,
         i.tipit_codigo,
         i.it_descripcion||' '||m.mod_codigomodelo as item,
         i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as item2,
         t.tall_descripcion,
         um.unime_codigo,
         um.unime_descripcion,
         i.it_precio as pevendet_precio
      from items i
         join modelo m on m.mod_codigo=i.mod_codigo
         join talle t on t.tall_codigo=i.tall_codigo 
         join unidad_medida um on um.unime_codigo=i.unime_codigo
         where it_descripcion ilike '%$item%' 
         and tipit_codigo = 2 
         and it_estado = 'ACTIVO'
      order by i.it_codigo;
select
      c.cli_codigo,
      p.per_numerodocumento,
      p.per_nombre||' '||p.per_apellido as cliente
   from cliente c
      join personas p on p.per_codigo=c.per_codigo
      where p.per_numerodocumento ilike '%$cliente%' 
      and c.cli_estado='ACTIVO'
   order by c.cli_codigo;
select 
            ocd.it_codigo,
            ocd.it_codigo,
            ocd.tipit_codigo,
            i.tipim_codigo,
            i.it_descripcion,
            ocd.orcomdet_cantidad as compdet_cantidad,
            ocd.orcomdet_precio as compdet_precio,
            um.unime_codigo,
            um.unime_descripcion 
         from orden_compra_det ocd 
            join orden_compra_cab occ on occ.orcom_codigo=ocd.orcom_codigo 
            join items i on i.it_codigo=ocd.it_codigo 
            and i.tipit_codigo=ocd.tipit_codigo 
            join unidad_medida um on um.unime_codigo=i.unime_codigo
         where ocd.orcom_codigo=$orcom_codigo 
            and i.it_estado='ACTIVO'
            and occ.orcom_estado='COMPLETADO'
            and i.it_descripcion ilike '%$it_descripcion%'
            and i.tipit_codigo <> 2
         order by i.it_codigo;
select 
            i.it_codigo,
            i.tipit_codigo,
            i.it_descripcion,
            um.unime_codigo,
            um.unime_descripcion,
            ppd.peprodet_cantidad as orcomdet_cantidad,
            ppd.peprodet_precio as orcomdet_precio
      from presupuesto_proveedor_det ppd 
            join items i on i.it_codigo=ppd.it_codigo 
            and i.tipit_codigo=ppd.tipit_codigo
            join unidad_medida um on um.unime_codigo=i.unime_codigo 
            where ppd.prepro_codigo=$presupuesto 
            and i.it_estado='ACTIVO'
            and i.it_descripcion ilike '%$descripcion%'
            and i.tipit_codigo <> 2
      order by ppd.prepro_codigo;
select 
         cc.comp_codigo,
         'Compra N°'||cc.comp_codigo||' '||to_char(cc.comp_fecha, 'DD-MM-YYYY') as compra,
         cc.pro_codigo,
         p.pro_razonsocial,
         cc.tipro_codigo,
         tp.tipro_descripcion,
         cc.com_numfactura
      from compra_cab cc
         join proveedor p on p.pro_codigo=cc.pro_codigo
         and p.tipro_codigo=cc.tipro_codigo
         join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
         where (p.pro_ruc ilike '%00000000%' or p.pro_razonsocial ilike '%HILERO%') 
         and (cc.comp_estado='ACTIVO' or cc.comp_estado='ANULADO')
      order by cc.comp_codigo;
select 
	tc.tipco_codigo,
	tc.tipco_descripcion,
	tc.tipco_estado 
      from tipo_comprobante tc
         where tc.tipco_descripcion ilike '%$tipoComprobante%'
         and tc.tipco_estado = 'ACTIVO'
      order by tc.tipco_codigo;
select 
            p.per_nombre||' '||p.per_apellido as persona,
            p.per_email 
         from usuario u 
            join funcionario f on f.func_codigo=u.func_codigo 
            join personas p on p.per_codigo=f.per_codigo
         where u.usu_login ilike '%$usuario%';
select 
            ac.accontra_codigo
         from actualizacion_contrasenia ac 
            where ac.accontra_usuario ilike '%ssan%' 
         order by ac.accontra_codigo desc 
         limit 1;
update usuario 
set usu_contrasenia = md5('123')
where usu_login = 'ssan';
select coalesce(max(accontra_codigo),0)+1 from actualizacion_contrasenia
update acceso_control
set accon_usuario='', accon_clave='', accon_fecha='', accon_hora='', accon_observacion='', accon_intentos=0
where accon_codigo=0;
select ac.accon_clave from acceso_control ac where ac.accon_usuario ilike '%ssan%' limit 1;
select ac.accon_intentos, ac.accon_clave 
from acceso_control ac 
where ac.accon_usuario ilike '%ssan%' 
order by ac.accon_codigo desc 
limit 1;
select coalesce(max(accon_codigo),0)+1 from acceso_control;
INSERT INTO acceso_control (accon_codigo, accon_usuario, accon_clave, accon_fecha, accon_hora, accon_observacion, accon_intentos)
VALUES(1, 'ssan', '100000', current_date, current_time, 'prueba', 1);
select 
	p.per_nombre||' '||p.per_apellido as persona,
	p.per_email 
from usuario u 
join funcionario f on f.func_codigo=u.func_codigo 
join personas p on p.per_codigo=f.per_codigo
where u.usu_login ilike '%ssa44n%';
select
            i.it_codigo,
            i.tipit_codigo,
            i.it_descripcion,
            um.unime_codigo,
            um.unime_descripcion,
            pcd.pedcodet_cantidad as peprodet_cantidad
         from pedido_compra_det pcd 
            join items i on i.it_codigo=pcd.it_codigo
            and i.tipit_codigo=pcd.tipit_codigo
            join unidad_medida um on um.unime_codigo=i.unime_codigo 
         where pcd.pedco_codigo=1 
         	and i.it_estado = 'ACTIVO' 
            and i.it_descripcion ilike '%%' 
            and i.tipit_codigo <> 2
         order by i.it_codigo;
SELECT 
            p.perm_descripcion, 
            apu.asigperm_estado 
         FROM asignacion_permiso_usuario apu 
            JOIN permisos p ON p.perm_codigo = apu.perm_codigo 
         WHERE usu_codigo = 2
         order by p.perm_codigo;
select 
	g.gui_descripcion,
	(case
		when g.gui_descripcion='PEDIDO COMPRA' then 
							   'PEDIDO COMPRA'
		when g.gui_descripcion='PRESUPUESTO PROVEEDOR' then 
							   'PRESUPUESTO PROVEEDOR'
		when g.gui_descripcion='ORDEN COMPRA' then 
							   'ORDEN COMPRA'
		when g.gui_descripcion='COMPRA' then 
							   'COMPRA'
		when g.gui_descripcion='AJUSTE INVENTARIO' then 
							   'AJUSTE INVENTARIO'
		when g.gui_descripcion='NOTA COMPRA' then 
							   'NOTA COMPRA'
		when m.modu_descripcion='COMPRAS' then 
							   'REPORTE REFERENCIAL COMPRA'
		else 
								'NSE'
	 end
	),
	m.modu_descripcion
from perfil_gui pg 
	join perfil p on p.perf_codigo=pg.perf_codigo 
	join gui g on g.gui_codigo=pg.gui_codigo 
	and g.modu_codigo=pg.modu_codigo
	join modulo m on m.modu_codigo=g.modu_codigo
where p.perf_codigo=2
and g.gui_descripcion ilike '%ped%';

select 
	vgr.gui_referencial as gui,
	vgr.gui_link as link
from v_gui_referenciales vgr 
where vgr.gui_referencial <> 'NER'
and vgr.gui_referencial ilike '%%';

select * from information_schema.tables;

select 
	ocd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	(case i.tipim_codigo when 1 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as exenta
from orden_compra_det ocd
join items i on i.it_codigo=ocd.it_codigo 
and i.tipit_codigo=ocd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
join unidad_medida um on um.unime_codigo=i.unime_codigo
where ocd.orcom_codigo=1;
select
	occ.orcom_codigo,
	e.emp_razonsocial,
	s.suc_descripcion,
	'RUC: '||e.emp_ruc as emp_ruc,
	p.pro_razonsocial,
	p.pro_ruc,
 to_char(occ.orcom_fecha, 'DD-MM-YYYY') as orcom_fecha,
	occ.orcom_condicionpago,
	occ.orcom_cuota,
	occ.orcom_montocuota,
	occ.orcom_interfecha,
	p2.per_nombre||' '||p2.per_apellido as nombre,
	u.usu_login,
	s.suc_telefono,
	s.suc_email
from orden_compra_cab occ
	join usuario u on u.usu_codigo=occ.usu_codigo
	join funcionario f on f.func_codigo=u.func_codigo 
	join personas p2 on p2.per_codigo=f.per_codigo 
	join proveedor p on p.pro_codigo=occ.pro_codigo
	and p.tipro_codigo=occ.tipro_codigo
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
	join sucursal s on s.suc_codigo=occ.suc_codigo
	and s.emp_codigo=occ.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
where occ.orcom_codigo=1;

select 
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	ti.tipit_codigo,
	t.tall_descripcion,
	nvd.notvendet_cantidad,
	um.unime_descripcion,
	nvd.notvendet_precio,
	(case i.tipim_codigo when 1 then nvd.notvendet_cantidad * nvd.notvendet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then nvd.notvendet_cantidad * nvd.notvendet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then nvd.notvendet_cantidad * nvd.notvendet_precio else 0 end) as exenta
from nota_venta_det nvd
   join nota_venta_cab nvc on nvc.notven_codigo=nvd.notven_codigo
   join items i on i.it_codigo=nvd.it_codigo
   and i.tipit_codigo=nvd.tipit_codigo
   join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
   join talle t on t.tall_codigo=i.tall_codigo
   join modelo m on m.mod_codigo=i.mod_codigo
   join stock s on s.it_codigo=i.it_codigo
   and s.tipit_codigo=i.tipit_codigo
   join unidad_medida um on um.unime_codigo=s.unime_codigo
   join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
where nvd.notven_codigo=1;

select 
	nvc.notven_numeronota,
	nvc.notven_fecha,
	nvc.tipco_codigo,
	tc.tipco_descripcion,
	nvc.notven_concepto,
	p.per_nombre||' '||p.per_apellido as cliente,
	vc.ven_numfactura,
	u.usu_login,
	e.emp_razonsocial,
	s.suc_descripcion,
	nvc.notven_estado
from nota_venta_cab nvc
	join tipo_comprobante tc on tc.tipco_codigo=nvc.tipco_codigo
	join venta_cab vc on vc.ven_codigo=nvc.ven_codigo
	join sucursal s on s.suc_codigo=nvc.suc_codigo
	and s.emp_codigo=nvc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
	join usuario u on u.usu_codigo=nvc.usu_codigo
	join cliente c on c.cli_codigo=nvc.cli_codigo
	join personas p on p.per_codigo=c.per_codigo
where nvc.notven_codigo=1;

select distinct
	vc.ven_numfactura as factura,
	p.per_nombre||' '||p.per_apellido as cliente,
	cd.cobdet_numerocuota,
	cc.cuenco_montosaldo as saldo,
	vc.vent_montocuota,
	vc.ven_interfecha,
	cc.cuenco_montototal 
from cobro_det cd
	join cobro_cab cc3 on cc3.cob_codigo=cd.cob_codigo
	join cuenta_cobrar cc on cc.ven_codigo=cd.ven_codigo
	join venta_cab vc on vc.ven_codigo=cc.ven_codigo
	join cliente c on c.cli_codigo=vc.cli_codigo
	join personas p on p.per_codigo=c.per_codigo
where cd.cob_codigo=1;

select 
	sum(case when cd.forco_codigo=1 then cd.cobdet_monto else 0 end) as efectivo,
    sum(case when cd.forco_codigo=2 then cd.cobdet_monto else 0 end) as tarjeta,
    sum(case when cd.forco_codigo=3 then cd.cobdet_monto else 0 end) as cheque 
from cobro_det cd
	join cobro_cab cc3 on cc3.cob_codigo=cd.cob_codigo
	join cuenta_cobrar cc on cc.ven_codigo=cd.ven_codigo
	join venta_cab vc on vc.ven_codigo=cc.ven_codigo
	join cliente c on c.cli_codigo=vc.cli_codigo
	join personas p on p.per_codigo=c.per_codigo
	join forma_cobro fc on fc.forco_codigo=cd.forco_codigo
where cd.cob_codigo=1;


select 
	cc.cob_codigo,
	cc.cob_fecha,
	ac.apercie_codigo,
	c.caj_descripcion,
	u.usu_login,
	e.emp_razonsocial,
	s.suc_descripcion,
	cc.cob_estado
from cobro_cab cc
	join apertura_cierre ac on ac.apercie_codigo=cc.apercie_codigo
	join caja c on c.caj_codigo=ac.caj_codigo
	join sucursal s on s.suc_codigo=ac.suc_codigo
	and s.emp_codigo=ac.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
	join usuario u on u.usu_codigo=ac.usu_codigo
where cc.cob_codigo=1; 

select 
         ac.apercie_codigo as apercie_codigo2,
         c.caj_descripcion as caj_descripcion2,
         c.caj_codigo as caj_codigo2,
         s.suc_descripcion as suc_descripcion2,
         e.emp_razonsocial as emp_razonsocial2,
         u.usu_login as usuario,
         ac.apercie_estado as apercie_estado2,
         u.usu_login||' '||'-'||ac.apercie_fechahoraapertura||' '||'-'||c.caj_descripcion as apertura
      from apertura_cierre ac 
      join caja c on c.caj_codigo=ac.caj_codigo
      join usuario u on u.usu_codigo=ac.usu_codigo
      join sucursal s on s.suc_codigo=ac.suc_codigo
      and s.emp_codigo=ac.emp_codigo
      join empresa e on e.emp_codigo=s.emp_codigo
      where u.usu_login ilike '%af%' and ac.apercie_estado='ABIERTO';

select 
	ac.apercie_codigo,
	c.caj_descripcion,
	c.caj_codigo,
	s.suc_descripcion,
	e.emp_razonsocial,
	u.usu_login as usuario,
	ac.apercie_estado,
	u.usu_login||' '||'-'||ac.apercie_fechahoraapertura||' '||'-'||c.caj_descripcion as apertura
from apertura_cierre ac 
join caja c on c.caj_codigo=ac.caj_codigo
join usuario u on u.usu_codigo=ac.usu_codigo
join sucursal s on s.suc_codigo=ac.suc_codigo
and s.emp_codigo=ac.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
where u.usu_login ilike '%af%' and ac.apercie_estado='ABIERTO';

DO $$
DECLARE
    ultcod integer;
BEGIN
  ultcod = (select coalesce(max(rec_codigo),0)+1 from recaudacion_depositar); 
  insert into recaudacion_depositar(rec_codigo, apercie_codigo, suc_codigo, emp_codigo, caj_codigo, 
  usu_codigo, rec_montoefectivo, rec_montocheque, rec_estado) values(ultcod, 1, 1, 1, 1, 3, 95000, 595000, 'ACTIVO');
END $$;

DO $$
DECLARE
    ultcod integer;
BEGIN
  ultcod = (select coalesce(max(arco_codigo),0)+1 from arqueo_control); 
  insert into arqueo_control(arco_codigo, apercie_codigo, suc_codigo, emp_codigo, caj_codigo, 
  usu_codigo, arco_observacion, arco_fecha, func_codigo) values(ultcod, 1, 1, 1, 1, 3, 'obs', current_date, 3);
END $$;

select 
	sum(cd.cobdet_monto) as montoefectivo,
	sum(cc.coche_monto) as montocheque
from cobro_det cd join cobro_cheque cc on cc.cobdet_codigo=cd.cobdet_codigo where cd.ven_codigo=1;

select sql();

select apercie_fechahoraapertura;

select 
	sum(cd.cobdet_monto) as efectivo,
	sum(cc2.coche_monto) as cheque,
	sum(ct.cobta_monto) as tarjeta,
	sum(cd.cobdet_monto) as total
from cobro_det cd 
	join cobro_cab cc on cc.cob_codigo=cd.cob_codigo
	join cobro_cheque cc2 on cc2.cob_codigo=cd.cob_codigo 
	join cobro_tarjeta ct on ct.cob_codigo=cd.cob_codigo 
	join apertura_cierre ac on ac.apercie_codigo=cc.apercie_codigo
where ac.apercie_codigo=1;

select
    sum(case when cd.forco_codigo=1 then cd.cobdet_monto else 0 end) as efectivo,
    sum(case when cd.forco_codigo=2 then ct.cobta_monto else 0 end) as tarjeta,
    sum(case when cd.forco_codigo=3 then cc2.coche_monto else 0 end) as cheque,
    sum(cd.cobdet_monto) as total
from cobro_det cd
join cobro_cab cc on cc.cob_codigo=cd.cob_codigo
join cobro_cheque cc2 on cc2.cob_codigo=cd.cob_codigo
join cobro_tarjeta ct on ct.cob_codigo=cd.cob_codigo
join apertura_cierre ac on ac.apercie_codigo=cc.apercie_codigo
where ac.apercie_codigo=1;

select sum(cobdet_monto) as totalcierre from cobro_det cd join cobro_cab cc on cc.cob_codigo=cd.cob_codigo
join apertura_cierre ac on ac.apercie_codigo=cc.apercie_codigo where cc.cob_fecha between ac.apercie_fechahoraapertura 
and '2024-05-05 13:20:17.000' and cc.cob_estado='ACTIVO' and ac.apercie_codigo=1;

select sum(notvendet_cantidad*notvendet_precio) as total from nota_venta_det nvd join nota_venta_cab nvc on nvc.notven_codigo=nvd.notven_codigo where ven_codigo=1 
and tipco_codigo=2;

update cuenta_cobrar set cuenco_montototal=cuenco_montototal-1, cuenco_montosaldo=cuenco_montosaldo-1
where ven_codigo=1;

update libro_venta set libven_iva5=libven_iva5-1 where ven_codigo=1;

select cuenco_montototal from cuenta_cobrar where ven_codigo=1;

select vent_montocuota from venta_cab where ven_codigo=1;

DO $$
DECLARE
    montoNota record;
BEGIN
    FOR montoNota IN select notvendet_cantidad*notvendet_precio as total, notvendet_cantidad, notvendet_precio, 
    i.tipim_codigo, i.tipit_codigo 
    from nota_venta_det nvd 
    join nota_venta_cab nvc on nvc.notven_codigo=nvd.notven_codigo 
    join items i on i.it_codigo=nvd.it_codigo where ven_codigo=1 
	and tipco_codigo=2
    LOOP
        update cuenta_cobrar set cuenco_montototal=cuenco_montototal-montoNota.total, 
        cuenco_montosaldo=cuenco_montosaldo-montoNota.total
		where ven_codigo=1;
		update venta_cab set vent_montocuota=vent_montocuota-montoNota.total where ven_codigo=1;
		if montoNota.tipim_codigo = 1 then
			update libro_venta set libven_iva5=libven_iva5-montoNota.total where ven_codigo=1;
		end if;
		if (montoNota.tipim_codigo = 2) and (montoNota.tipit_codigo <> 3) then
			update libro_venta set libven_iva10=libven_iva10-montoNota.total where ven_codigo=1;
		end if;
		if (montoNota.tipim_codigo = 2) and (montoNota.tipit_codigo = 3) then
			update libro_venta set libven_iva10=libven_iva10-notvendet_precio where ven_codigo=1;	
		end if;
		if montoNota.tipim_codigo = 3 then
			update libro_venta set libven_exenta=libven_exenta-montoNota.total where ven_codigo=1;
		end if;
    END LOOP;
END $$;

	DO $$
      DECLARE
         montoNota record;
      BEGIN
         FOR montoNota IN select notvendet_cantidad*notvendet_precio as total, notvendet_cantidad, notvendet_precio, 
         i.tipim_codigo, i.tipit_codigo, nvd.it_codigo  
         from nota_venta_det nvd 
         join nota_venta_cab nvc on nvc.notven_codigo=nvd.notven_codigo 
         join items i on i.it_codigo=nvd.it_codigo where ven_codigo=1 and tipco_codigo=1
         LOOP
           update cuenta_cobrar set cuenco_montototal=cuenco_montototal+montoNota.total, 
           cuenco_montosaldo=cuenco_montosaldo+montoNota.total
           where ven_codigo=1;
           update venta_det set vendet_cantidad=vendet_cantidad+montoNota.notvendet_cantidad where ven_codigo=1
           and it_codigo=montoNota.it_codigo;
            if montoNota.tipim_codigo = 1 then
               update libro_venta set libven_iva5=libven_iva5+montoNota.total where ven_codigo=1;
            end if;
            if montoNota.tipim_codigo = 2 then
               update libro_venta set libven_iva10=libven_iva10+montoNota.total where ven_codigo=1;
            end if;
            if montoNota.tipim_codigo = 3 then
               update libro_venta set libven_exenta=libven_exenta+montoNota.total where ven_codigo=1;
            end if;
         END LOOP;
      END $$;

update cuenta_cobrar set cuenco_montosaldo=1190000-90000 where ven_codigo=1;
select sum(cobdet_monto) as totalmontoventa from cobro_det where ven_codigo=1;
select cuenco_montosaldo from cuenta_cobrar where ven_codigo=1; 
update cuenta_cobrar set cuenco_montosaldo=0 where ven_codigo=1;
select sum(cobdet_monto) totalmonto from cobro_det where ven_codigo=1; 
update cobro_cab set cob_estado='ANULADO' where cob_codigo in (select distinct cob_codigo from cobro_det where ven_codigo=1)
delete from apertura_cierre where apercie_codigo = 5;
update cuenta_cobrar set cuenco_montosaldo=cuenco_montosaldo+(-1*-200000) where ven_codigo=1; 
select -200+-200 as resultado;
select cuenco_montosaldo from cuenta_cobrar where ven_codigo=1;
select cd.cobdet_codigo from cobro_det cd join cobro_cab cb on cb.cob_codigo=cd.cob_codigo 
where cd.ven_codigo=1 and cb.cob_estado='ACTIVO' limit 1;
update venta_det set vendet_cantidad=vendet_cantidad-5 where it_codigo=2 and ven_codigo=1;
select cuenco_montototal from cuenta_cobrar where cuenco_estado <> 'ANULADO' and ven_codigo=1;
select cuenco_montototal-cuenco_montosaldo as diferencia from cuenta_cobrar where ven_codigo=1;
select cuenco_montototal from cuenta_cobrar where ven_codigo=1;
update cuenta_cobrar set cuenco_estado='ANULADO' where ven_codigo=1;
update libro_venta set libven_estado='ANULADO' where ven_codigo=1;
update venta_cab set ven_estado='ANULADO' where ven_codigo=1;
select 
	i.it_codigo,
    i.tipit_codigo,
    i.tipim_codigo,
    i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as descripcion,
    i.it_precio as notvendet_precio,
    i.it_descripcion,
    t.tall_descripcion,
    um.unime_descripcion
from venta_det vd
join venta_cab vc on vc.ven_codigo=vd.ven_codigo
join stock s on s.it_codigo=vd.it_codigo
and s.tipit_codigo=vd.tipit_codigo
and s.dep_codigo=vd.dep_codigo 
and s.suc_codigo=vd.suc_codigo
and s.emp_codigo=vd.emp_codigo
join items i on i.it_codigo=s.it_codigo 
and i.tipit_codigo=s.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join modelo m on m.mod_codigo=i.mod_codigo 
join talle t on t.tall_codigo=i.tall_codigo
join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
join unidad_medida um on um.unime_codigo=s.unime_codigo
where (i.it_descripcion ilike '%100%' or m.mod_codigomodelo ilike '%100%') 
and vc.ven_estado <> 'ANULADO' and i.tipit_codigo=2 and vc.ven_codigo=1
order by i.it_codigo;


select 
         i.it_codigo,
         i.tipit_codigo,
         i.tipim_codigo,
         i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as descripcion,
         i.it_precio as notvendet_precio,
         i.it_descripcion,
         t.tall_descripcion,
         um.unime_descripcion
      from venta_det vd
      	 join venta_cab vc on vc.
         join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
         join talle t on t.tall_codigo=i.tall_codigo
         join modelo m on m.mod_codigo=i.mod_codigo
         join stock s on s.it_codigo=i.it_codigo
         and s.tipit_codigo=i.tipit_codigo
         join unidad_medida um on um.unime_codigo=s.unime_codigo
      where i.it_descripcion ilike '%$item%' and i.it_estado = 'ACTIVO'
      and (i.tipit_codigo = 2 or i.tipit_codigo = 3)
      order by i.it_codigo;
select tipco_codigo from nota_venta_cab where ven_codigo=1 and notven_estado = 'ACTIVO';
update cuenta_cobrar set cuenco_estado = 'CANCELADO' where ven_codigo = 1;
select coalesce(sum(cd.cobdet_monto), 0) as montoventa from cobro_det cd where cd.ven_codigo = 1;
select sum(cd.cobdet_monto) as totalVenta from cobro_det cd where cd.ven_codigo=1 and cd.cob_codigo=1; 
select 
         cc.ven_codigo,
         cc.cuenco_nrocuota as cuota,
         cc.cuenco_montosaldo as saldo,
         cc.cuenco_montototal,
         'N° Venta: '||vc.ven_codigo||' Factura: '||vc.ven_numfactura as venta,
         vc.ven_numfactura as factura,
         p.per_nombre||' '||p.per_apellido as cliente,
         vc.vent_montocuota,
         ven_interfecha
      from cuenta_cobrar cc
         join venta_cab vc on vc.ven_codigo=cc.ven_codigo
         join cliente c on c.cli_codigo=vc.cli_codigo
         join personas p on p.per_codigo=c.per_codigo
      where p.per_numerodocumento ilike '%%' and cc.cuenco_estado='ACTIVO'
      order by vc.ven_codigo;
select * from forma_cobro order by forco_codigo;
select fc.forco_descripcion from cobro_det cd join forma_cobro fc on fc.forco_codigo=cd.forco_codigo 
where cd.ven_codigo=1 and cd.cob_codigo=1;
select max(cd.cobdet_numerocuota) as cobdet_numerocuota from cobro_det cd join cobro_cab cc on cc.cob_codigo=cd.cob_codigo
where ven_codigo = 1 and cd.cob_codigo = 1 and cc.cob_estado='ACTIVO';
select coalesce(max(cd.cobdet_numerocuota),0)+1 as cobdet_numerocuota from cobro_det cd 
join cobro_cab cc on cc.cob_codigo=cd.cob_codigo where ven_codigo = 1 and cc.cob_estado='ACTIVO';
select coalesce(max(cd.cob_codigo),0) as cob_codigo from cobro_det cd join cobro_cab cc on cc.cob_codigo=cd.cob_codigo
where ven_codigo = 1 and cc.cob_estado='ACTIVO';
select coalesce(max(cobdet_numerocuota),0)+1 as cobdet_numerocuota from cobro_det where ven_codigo = 1;
select coalesce(max(cob_codigo),0) as cob_codigo from cobro_det where ven_codigo = 1;
select 
	cc.ven_codigo,
	cc.cuenco_nrocuota,
	cc.cuenco_montosaldo as montoSaldo,
	'N° Venta '||vc.ven_codigo||' '||vc.ven_numfactura as venta,
	vc.ven_numfactura,
	p.per_nombre||' '||p.per_apellido as cliente,
	vc.vent_montocuota,
	ven_interfecha
from cuenta_cobrar cc
join venta_cab vc on vc.ven_codigo=cc.ven_codigo
join cliente c on c.cli_codigo=vc.cli_codigo
join personas p on p.per_codigo=c.per_codigo
where p.per_numerodocumento ilike '%888%' and cc.cuenco_estado='ACTIVO'
order by vc.ven_codigo;

select 
         cc.ven_codigo,
         cc.cuenco_nrocuota as cuota,
         cc.cuenco_montosaldo as montoSaldo,
         'N° Venta: '||vc.ven_codigo||' Factura: '||vc.ven_numfactura as venta,
         vc.ven_numfactura as factura,
         p.per_nombre||' '||p.per_apellido as cliente,
         vc.vent_montocuota,
         ven_interfecha
      from cuenta_cobrar cc
         join venta_cab vc on vc.ven_codigo=cc.ven_codigo
         join cliente c on c.cli_codigo=vc.cli_codigo
         join personas p on p.per_codigo=c.per_codigo
      where p.per_numerodocumento ilike '%888%' and cc.cuenco_estado='ACTIVO'
      order by vc.ven_codigo;





select ee.ent_codigo, ee.ent_razonsocial as ent_razonsocial2 from entidad_emisora ee where ee.ent_razonsocial ilike '%SAN%' and ee.ent_estado = 'ACTIVO';
select 
	ea.entad_codigo,
	ea.ent_codigo,
		ea.marta_codigo,
		ee.ent_razonsocial||' '||mt.marta_descripcion as entidades,
		ee.ent_razonsocial,
		mt.marta_descripcion
from entidad_adherida ea 
	join entidad_emisora ee on ee.ent_codigo=ea.ent_codigo
	join marca_tarjeta mt on mt.marta_codigo=ea.marta_codigo
where ee.ent_razonsocial ilike '%San%' and ea.entad_estado = 'ACTIVO';


select ac.apercie_codigo, ac.apercie_estado, ac.caj_codigo, c.caj_descripcion 
from apertura_cierre ac join caja c on c.caj_codigo=ac.caj_codigo where ac.apercie_codigo = 1;
select 
         pvc.peven_codigo,
         'Pedido '||pvc.peven_codigo as pedido,
         pvc.cli_codigo,
         p.per_nombre||''||p.per_apellido as cliente
      from pedido_venta_cab pvc
         join cliente c on c.cli_codigo=pvc.cli_codigo
         join personas p on p.per_codigo=c.per_codigo
         where cast(pvc.peven_codigo as varchar) ilike '%2%' and pvc.peven_estado='TERMINADA'
      order by pvc.peven_codigo
select ac.apercie_codigo, ac.apercie_estado from apertura_cierre ac where ac.apercie_codigo = 1;
select 
	ac.apercie_codigo,
	c.caj_descripcion,
	ac.apercie_fechahoraapertura,
	ac.apercie_montoapertura,
	ac.apercie_estado
from 
	apertura_cierre ac 
	join caja c on c.caj_codigo=ac.caj_codigo 
	where ac.apercie_codigo = 1;
select * from forma_cobro;
select c.caj_codigo, c.caj_descripcion from caja c where c.suc_codigo=1 and c.emp_codigo=1 and c.caj_descripcion ilike '%ja 1%'; 
select coalesce(max(apercie_codigo),0)+1 as numero_apertura from apertura_cierre;
SELECT p.perm_descripcion, apu.asigperm_estado FROM asignacion_permiso_usuario apu JOIN 
permisos p ON p.perm_codigo = apu.perm_codigo WHERE usu_codigo = 3;
select sp_pedido_venta_cab(0, '22/10/2023', 'ACTIVO', 1, 1, 2, 3, 1);
select sp_pedido_venta_det(1, 2, 2, 5, 70000, 1);
select sp_orden_compra_det(1, 1, 1, 2, 10000, 1);
select sp_orden_compra_cab(0, '20/10/2023', 'CONTADO', 1, 'S/I', 'ACTIVO', 1, 1, 1, 1, 1, 1, 1, 1);
select sp_presupuesto_proveedor_cab(0, '20/10/2023', 'Activo', '23/10/2023', 2, 2, 2, 1, 1, 1, 1);
select sp_presupuesto_proveedor_det(1, 1, 1, 20, 5000, 1);
select sp_presupuesto_proveedor_cab()
select sp_pedido_compra_cab(0, '16/10/2023', 'PENDIENTE', 1, 1, 1, 1);
select sp_pedido_compra_det(1, 1, 1, 5, 5000, 1);
select sp_equipo_trabajo(2, 1, 'Activo', 2);
select sp_seccion(1, 'Seccion 2', 'Activo', 1, 1, 3);
select sp_costo_servicio(1, 6000, 'Activo', 1, 3); 
select sp_parametro_control_calidad(1, 'color de hilo', 'Activo', 3);
select sp_unidad_medida(1, 'M', 'Activo', 3);
select sp_tipo_etapa_produccion(1, 'CORTE', 'Activo', 3);
select sp_cliente(1, 'ÑEMBY', 'FISICA', 'Activo', 1, 1, 3);
select sp_maquinaria(1, 'doble', 'Activo', 3);
select sp_caja(0, 'Caja 2', 'Activo', 1, 1, 1);
select sp_entidad_adherida(1, 1, 1, 'Activo', 2);
select sp_entidad_emisora(1, 'cooperativa San andres', '80156324', '021117000', 'cooSA@prueba', 'Activo', 3);
select sp_marca_tarjeta(1, 'Mastercard', 'Activo', 3);
select sp_forma_cobro(1, 'Cheque', 'Activo', 3);
select sp_tipo_comprobante(1, 'NOta Credito', 'Activo', 3); 
select sp_items(1, 1, 'Hilo Rojo', 5000, 0, 'Activo', 0, 0, 1, 2);
select sp_modelo(0, '911', 'M', 'Cierre grande', 'Activo', 1, 1);
select sp_color_prenda(1, 'Azul', 'Activo', 3);
select sp_talle(1, '38', 'Activo', 3);
select sp_deposito(1, 1, 1, 'Deposito 1', 'Activo', 2, 3);
select sp_proveedor(1, 1, 'EL Hilero', '80000000', 'Eusebio Ayala c/ feliciano', 'prueba', 'elhl@', 'Activo', 3);
select sp_tipo_item(0, 'producto', 'Activo', 1);
select sp_tipo_proveedor(1, 'minorista', 'Activo', 3);
select sp_tipo_impuesto(1, 'IVA 10%', 'Activo', 3);
select sp_funcionario(0, '2023-10-01', 'Activo', 2, 2, 1, 1, 1, 1);
select sp_personas(3, 'Dylan Gael', 'Sanabria Zarza', '5555555', 'no tiene', 'no tiene', 'Activo', 1, 3);
select sp_sucursal(2, 1, 'Venta 1', 'San Rafael c/Cacique', '0988888', 'Activo', 1, 3);
select sp_empresa(2, '000000', 'fuera', '111111', 'prueba@gmail.com', 'cambio', 'Activo', 3);
select sp_cargo(2, 'encargado de compras', 'activo', 3);
select sp_ciudad(2, 'san lorenzo', 'activo', 3);
select sp_tipo_documento(2, 'RUC', 'Activo', 3);
select * from forma_cobro order by forco_codigo;
select sp_asignacion_permiso_usuario(4, 2, 2, 1, 2, 'Activo', 2);
update usuario set usu_contrasenia = md5('123') where usu_codigo = 1;
select current_date;
select * from tipo_documento where tipdo_descripcion ilike '%i%';
select * from empresa where emp_ruc = '80565656';
select sp_perfil_gui(1, 1, 1, 5, 'Activo', 1); 
select sp_perfiles_permisos(3, 1, 2, 'Activo',2);
select sp_gui(3, 3, 'PRUEBA','Activo',2);
select * from tipo_documento order by tipdo_codigo;
select * from color_prenda order by col_codigo;
select * from cargo order by car_codigo;
select * from tipo_proveedor tp where tp.tipro_descripcion ilike '%min%'; 
select * from empresa order by emp_codigo;
select * from tipo_impuesto order by tipim_codigo;
select * from tipo_proveedor order by tipro_codigo;
select * from tipo_item order by tipit_codigo;
select * from talle order by tall_codigo;
select  from ciudad c where ciu_descripcion ilike '%ñ%';
select p.*, tp.tipro_descripcion from proveedor p join tipo_proveedor tp 
on p.tipro_codigo=tp.tipro_codigo order by p.pro_codigo;
select * from empresa where emp_razonsocial ilike '%8%';
SELECT * FROM modulo ORDER BY modu_codigo;
SELECT * FROM modulo WHERE modu_estado='ACTIVO' ORDER BY modu_codigo;
select * from tipo_etapa_produccion order by tipet_codigo;
select * from unidad_medida order by unime_codigo;
select * from parametro_control_calidad order by pacoca_codigo;
select 
	cs.*,
	m.mod_codigomodelo
from costo_servicio cs
join modelo m on m.mod_codigo=cs.mod_codigo
order by cs.costserv_codigo;

select 
    i.*,
    ti.tipit_descripcion,
    m.mod_codigomodelo,
	t.tall_descripcion,
	tim.tipim_descripcion,
	um.unime_descripcion 
from items i
    join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
    join modelo m on m.mod_codigo=i.mod_codigo
    join talle t on t.tall_codigo=i.tall_codigo 
    join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
    join unidad_medida um on um.unime_codigo=i.unime_codigo 
order by i.it_codigo;

select * from unidad_medida um where um.unime_descripcion ilike '%uni%';

select d.*, e.emp_razonsocial, s.suc_descripcion, c.ciu_descripcion
from deposito d join ciudad c on c.ciu_codigo=d.ciu_codigo join sucursal s on s.suc_codigo=d.suc_codigo 
and s.emp_codigo=d.emp_codigo join empresa e on e.emp_codigo=s.emp_codigo 
where d.dep_codigo between 1 and 2 order by d.dep_codigo

select 
    p.*, tp.tipro_descripcion 
from proveedor p 
    join tipo_proveedor tp 
    on p.tipro_codigo=tp.tipro_codigo 
where p.pro_codigo between 1 and 3
 order by p.pro_codigo;

select 
	s.*,
	su.suc_descripcion,
	e.emp_razonsocial
from seccion s 
join sucursal su on su.suc_codigo=s.suc_codigo
and su.emp_codigo=s.emp_codigo
join empresa e on e.emp_codigo=su.emp_codigo
order by s.secc_codigo;

select
	s.*,
	e.emp_razonsocial,
	c.ciu_descripcion
from sucursal s
join empresa e on e.emp_codigo=s.emp_codigo
join ciudad c on c.ciu_codigo=s.ciu_codigo
order by s.suc_codigo;
select 
	pp.*,
	perf.perf_descripcion,
	perm.perm_descripcion
from perfiles_permisos pp 
join perfil perf on perf.perf_codigo=pp.perf_codigo
join permisos perm on perm.perm_codigo=pp.perm_codigo;

select * from perfil where perf_descripcion ilike '%adm%';
select * from gui;

select * from modulo where modu_descripcion = 'COMPRAS';

select sp_modulo(5,'PRueba','',2);

SELECT * FROM modulo WHERE (modu_codigo between 1 and 2) and modu_estado='ACTIVO' ORDER BY modu_codigo;

select * from perfil where perf_codigo between 1 and 1 order by perf_codigo;

select * from permisos where perm_codigo between 1 and 3 order by perm_codigo;

select * from modulo;

select * from acceso a where a.acc_fecha between '2' and '21-09-2023' order by a.acc_codigo;

select g.*, m.modu_descripcion from gui g join modulo m on m.modu_codigo=g.modu_codigo where g.gui_codigo
between 1 and 4 order by g.gui_codigo;

select * from ciudad where ciu_codigo between 1 and 3 order by ciu_codigo;

select pg.*, p.perf_descripcion, g.gui_descripcion, m.modu_descripcion from perfil_gui pg join perfil p on p.perf_codigo=pg.perf_codigo join gui g on g.gui_codigo=pg.gui_codigo
and g.modu_codigo=pg.modu_codigo join modulo m on m.modu_codigo=g.modu_codigo where pg.perfgui_codigo between 1 and 2
order by pg.perfgui_codigo;

select pp.*, perf.perf_descripcion, perm.perm_descripcion from perfiles_permisos pp  
join perfil perf on perf.perf_codigo=pp.perf_codigo join permisos perm on perm.perm_codigo=pp.perm_codigo
where pp.perfpe_codigo between 1 and 4 order by perfpe_codigo;

select apu.*, u.usu_login , p.perf_descripcion, p2.perm_descripcion from asignacion_permiso_usuario apu
join usuario u on u.usu_codigo=apu.usu_codigo join perfiles_permisos pp on pp.perfpe_codigo=apu.perfpe_codigo 
and pp.perf_codigo=apu.perf_codigo and pp.perm_codigo=apu.perm_codigo join perfil p on p.perf_codigo=pp.perf_codigo
join permisos p2 on p2.perm_codigo=pp.perm_codigo where apu.asigperm_codigo between 1 and 1 order by apu.asigperm_codigo;

select 
	i.it_codigo,
	i.tipit_codigo,
	i.it_descripcion,
	ppd.peprodet_cantidad as orcomdet_cantidad,
	ppd.peprodet_precio as orcomdet_precio
from presupuesto_proveedor_det ppd 
join items i on i.it_codigo=ppd.it_codigo 
and i.tipit_codigo=ppd.tipit_codigo
where ppd.prepro_codigo=1 and i.it_estado='ACTIVO'
and i.it_descripcion ilike '%ilo%'
order by ppd.prepro_codigo; 


select 		
	u.*,
    m.modu_descripcion,
    p.perf_descripcion,
    p2.per_nombre||' '||p2.per_apellido as funcionario
from usuario u
    join modulo m on m.modu_codigo=u.modu_codigo
    join perfil p on p.perf_codigo=u.perf_codigo
    join funcionario f on f.func_codigo=u.func_codigo
    join personas p2 on p2.per_codigo=f.per_codigo
where u.usu_fecha between '21-09-2023' and '21-09-2023'
order by u.usu_codigo;

select 
	u.*,
	p.per_nombre,
	p.per_apellido,
	p.per_email,
	p2.perf_descripcion,
	su.suc_descripcion,
	m.modu_descripcion 
from usuario u 
	join funcionario f on f.func_codigo = u.func_codigo
	join personas p on p.per_codigo = f.per_codigo
	join sucursal su on su.suc_codigo = f.suc_codigo 
	join modulo m on m.modu_codigo = u.modu_codigo
	join perfil p2 on p2.perf_codigo = u.perf_codigo
where u.usu_login = 'ssan' and u.usu_contrasenia = md5('123');

select
	p.perm_descripcion,
	apu.asigperm_estado 
from 
	asignacion_permiso_usuario apu
join 
	permisos p on p.perm_codigo = apu.perm_codigo
where usu_codigo = 1;

select 
	pg.*,
	p.perf_descripcion,
	g.gui_descripcion,
	m.modu_descripcion
from perfil_gui pg
join perfil p on p.perf_codigo=pg.perf_codigo
join gui g on g.gui_codigo=pg.gui_codigo 
and g.modu_codigo=pg.modu_codigo
join modulo m on m.modu_codigo=g.modu_codigo
order by pg.perfgui_codigo;

select 
	g.*,
	m.modu_descripcion 
from gui g
join modulo m on m.modu_codigo=g.modu_codigo 
where g.gui_descripcion ilike '%mod%';

select 
	u.*,
	m.modu_descripcion,
	p.perf_descripcion,
	p2.per_nombre||' '||p2.per_apellido as funcionario,
	p2.per_numerodocumento
from usuario u
join modulo m on m.modu_codigo=u.modu_codigo
join perfil p on p.perf_codigo=u.perf_codigo
join funcionario f on f.func_codigo=u.func_codigoseleccionUsuario
join personas p2 on p2.per_codigo=f.per_codigo
order by u.usu_codigo;

select 
	f.func_codigo,
	p.per_nombre||' '||p.per_apellido as funcionario,
	p.per_numerodocumento
from funcionario f
join personas p on p.per_codigo=f.per_codigo
where p.per_numerodocumento ilike '%%';

select 
	apu.*,
	u.usu_login ,
	p.perf_descripcion,
	p2.perm_descripcion
from asignacion_permiso_usuario apu
join usuario u on u.usu_codigo=apu.usu_codigo
join perfiles_permisos pp on pp.perfpe_codigo=apu.perfpe_codigo 
and pp.perf_codigo=apu.perf_codigo and pp.perm_codigo=apu.perm_codigo
join perfil p on p.perf_codigo=pp.perf_codigo
join permisos p2 on p2.perm_codigo=pp.perm_codigo
order by apu.asigperm_codigo;

select distinct pp.perf_codigo, p.perf_descripcion from perfiles_permisos pp 
join perfil p on pp.perf_codigo=p.perf_codigo where p.perf_descripcion ilike '%adm%';

select pp.perm_codigo, pp.perfpe_codigo, p.perm_descripcion from perfiles_permisos pp join permisos p
on p.perm_codigo=pp.perm_codigo where pp.perf_codigo=1;

select u.usu_codigo, u.usu_login, u.perf_codigo, p.perf_descripcion  from usuario u 
join perfil p on p.perf_codigo=u.perf_codigo where usu_login ilike '%%';

select * from ciudad order by ciu_codigo;

select 
	p.*,
	p.per_nombre||' '||p.per_apellido as persona,
	td.tipdo_descripcion
from personas p
join tipo_documento td on td.tipdo_codigo=p.tipdo_codigo;

select 
	f.*,
	p.per_nombre||' '||p.per_apellido as persona,
	p.per_numerodocumento,
	c.ciu_descripcion,
	c2.car_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial
from funcionario f
join personas p on p.per_codigo=f.per_codigo
join ciudad c on c.ciu_codigo=f.ciu_codigo
join cargo c2 on c2.car_codigo=f.car_codigo
join sucursal s on s.suc_codigo=f.suc_codigo 
and s.emp_codigo=f.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by f.func_codigo;

select
	p.per_codigo,
	p.per_nombre||' '||p.per_apellido as persona,
	p.per_numerodocumento 
from personas p
where p.per_numerodocumento like '%5%';

select 
	m.*,
	cp.col_descripcion
from modelo m
join color_prenda cp on cp.col_codigo=m.col_codigo
order by m.mod_codigo;

select * from color_prenda cp where cp.col_descripcion ilike '%a%';

select * from cargo c where c.car_descripcion ilike '%a%';

select s.suc_codigo, s.suc_descripcion from sucursal s where s.emp_codigo = 1;

select 
	d.*,
	e.emp_razonsocial,
	s.suc_descripcion,
	c.ciu_descripcion
from deposito d 
join ciudad c on c.ciu_codigo=d.ciu_codigo
join sucursal s on s.suc_codigo=d.suc_codigo 
and s.emp_codigo=d.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by d.dep_codigo;

select 
	i.*,
	ti.tipit_descripcion,
	m.mod_codigomodelo,
	t.tall_descripcion,
	tim.tipim_descripcion 
from items i
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join modelo m on m.mod_codigo=i.mod_codigo
join talle t on t.tall_codigo=i.tall_codigo 
join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
order by i.it_codigo;

select count(*) as cantidad_persona from personas;
select count(*) as cantidad_funcionario from funcionario;
select count(*) as cantidad_usuario from usuario;
select count(*) as cantidad_cliente from cliente;

select * from tipo_item ti where tipit_descripcion ilike '%pr%';
select * from tipo_impuesto ti where ti.tipim_descripcion ilike '%va%';
select * from modelo m where m.mod_codigomodelo ilike '%%';
select * from talle t where t.tall_descripcion ilike '%%';

select d.*, e.emp_razonsocial, s.suc_descripcion, c.ciu_descripcion
from deposito d join ciudad c on c.ciu_codigo=d.ciu_codigo
join sucursal s on s.suc_codigo=d.suc_codigo and s.emp_codigo=d.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo where d.dep_codigo between 1 and 3
order by d.dep_codigo;

select i.*, ti.tipit_descripcion, m.mod_codigomodelo, t.tall_descripcion, tim.tipim_descripcion  
from items i join tipo_item ti on ti.tipit_codigo=i.tipit_codigo join modelo m on m.mod_codigo=i.mod_codigo
join talle t on t.tall_codigo=i.tall_codigo join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
where i.it_codigo between 1 and 5 order by i.it_codigo;

select 
	ea.*,
	ee.ent_razonsocial,
	mt.marta_descripcion 
from entidad_adherida ea
join entidad_emisora ee on ee.ent_codigo=ea.entad_codigo
join marca_tarjeta mt on mt.marta_codigo=ea.marta_codigo
order by ea.entad_codigo;

select * from entidad_emisora where ent_razonsocial ilike '%%';
select * from marca_tarjeta where marta_descripcion ilike '%l%';

select 
	c.*,
	s.suc_descripcion,
	e.emp_razonsocial 
from caja c
join sucursal s on s.suc_codigo=c.suc_codigo
and s.emp_codigo=c.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by c.caj_codigo;

select 
	c.*,
	p.per_nombre||' '||p.per_apellido as persona,
	p.per_numerodocumento,
	ci.ciu_descripcion 
from cliente c
join personas p on p.per_codigo=c.per_codigo
join ciudad ci on ci.ciu_codigo=c.ciu_codigo
order by c.cli_codigo;

select 
	f.func_codigo,
    p.per_nombre||' '||p.per_apellido as funcionario,
    p.per_numerodocumento,
    f.suc_codigo,
    f.emp_codigo 
from funcionario f
    join personas p on p.per_codigo=f.per_codigo
    where p.per_numerodocumento ilike '%545%';

select 
	et.*,
	p.per_nombre||' '||p.per_apellido as funcionario,
	p.per_numerodocumento,
	s.secc_descripcion,
	s2.suc_descripcion,
	e.emp_razonsocial 
from equipo_trabajo et
join seccion s on s.secc_codigo=et.secc_codigo
join funcionario f on f.func_codigo=et.func_codigo
join personas p on p.per_codigo=f.per_codigo
join sucursal s2 on s2.suc_codigo=f.suc_codigo
and s2.emp_codigo=f.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by et.func_codigo;

select 
		et.*,
        p.per_nombre||' '||p.per_apellido as funcionario,
        p.per_numerodocumento,
        s.secc_descripcion,
        s2.suc_descripcion,
        e.emp_razonsocial
from equipo_trabajo et
        join seccion s on s.secc_codigo=et.secc_codigo
        join funcionario f on f.func_codigo=et.func_codigo
        join personas p on p.per_codigo=f.per_codigo
        order by et.func_codigo;
select 
	s.secc_codigo,
	s.secc_descripcion
from seccion s 
where (s.suc_codigo=1 and s.emp_codigo=1);
select p.*, tp.tipro_descripcion from proveedor p join tipo_proveedor tp on p.tipro_codigo=tp.tipro_codigo 
where p.pro_codigo between 1 and 2 order by p.pro_codigo;

select 
	pcc.*,
	p.per_nombre||' '||p.per_apellido as usuario,
	s.suc_descripcion,
	e.emp_razonsocial
from pedido_compra_cab pcc 
join usuario u on u.usu_codigo=pcc.usu_codigo
join funcionario f on f.func_codigo=u.func_codigo
join personas p on p.per_codigo=f.per_codigo 
join sucursal s on s.suc_codigo=pcc.suc_codigo and s.emp_codigo=pcc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by pcc.pedco_codigo;

select
	pcd.*,
	i.it_descripcion,
	ti.tipit_descripcion
from pedido_compra_det pcd 
join items i on i.it_codigo=pcd.it_codigo
and i.tipit_codigo=pcd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
order by pcd.pedco_codigo;

SELECT p.perm_descripcion, apu.asigperm_estado FROM asignacion_permiso_usuario apu JOIN 
permisos p ON p.perm_codigo = apu.perm_codigo WHERE usu_codigo = 2;

select 
	u.*,
	p.per_nombre,
	p.per_apellido,
	p.per_email,
	p2.perf_descripcion,
	su.suc_descripcion,
	su.suc_codigo,
	e.emp_codigo,
	e.emp_razonsocial,
	m.modu_descripcion
from usuario u 
	join funcionario f on f.func_codigo = u.func_codigo
	join personas p on p.per_codigo = f.per_codigo
	join sucursal su on su.suc_codigo = f.suc_codigo
	join empresa e on su.emp_codigo=e.emp_codigo
	join modulo m on m.modu_codigo = u.modu_codigo
	join perfil p2 on p2.perf_codigo = u.perf_codigo
where u.usu_login = 'ssan' and u.usu_contrasenia = md5('123');

select *, it_costo as pedcodet_precio from items where it_descripcion ilike '%hi%' and tipit_codigo = 1;

select * from proveedor p where p.pro_ruc ilike '%80000000%'and p.pro_estado = 'ACTIVO' order by p.pro_codigo;

select
	i.it_codigo,
	i.tipit_codigo,
	i.it_descripcion
from pedido_compra_det pcd 
join items i on i.it_codigo=pcd.it_codigo
and i.tipit_codigo=pcd.tipit_codigo
where pcd.pedco_codigo= '1' and i.it_estado = 'ACTIVO' and i.it_descripcion ilike '%hilo%' 
order by i.it_codigo;

select 
	ppc.*,
	u.usu_login,
	p.pro_razonsocial,
	tp.tipro_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	pp.pedco_codigo
from presupuesto_proveedor_cab ppc
join usuario u on u.usu_codigo=ppc.usu_codigo
join proveedor p on p.pro_codigo=ppc.pro_codigo
and p.tipro_codigo=ppc.tipro_codigo
join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
join sucursal s on s.suc_codigo=ppc.suc_codigo 
and s.emp_codigo=ppc.emp_codigo 
join empresa e on e.emp_codigo=s.emp_codigo
join pedido_presupuesto pp on pp.prepro_codigo=ppc.prepro_codigo
order by ppc.prepro_codigo;

select pcc.pedco_codigo, 'Pedido'||' '||pcc.pedco_codigo as pedido from pedido_compra_cab pcc where cast(pcc.pedco_codigo as varchar) ilike '%1%';

select 
	occ.*,
	u.usu_login,
	p.pro_razonsocial,
	tp.tipro_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	po.prepro_codigo
from orden_compra_cab occ
join usuario u on u.usu_codigo=occ.usu_codigo
join proveedor p on p.pro_codigo=occ.pro_codigo
and p.tipro_codigo=occ.tipro_codigo
join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
join sucursal s on s.suc_codigo=occ.suc_codigo
and s.emp_codigo=occ.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
join presupuesto_orden po on po.orcom_codigo=occ.orcom_codigo
order by occ.orcom_codigo

select 
	ocd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	ocd.orcomdet_cantidad*ocd.orcomdet_precio as total
from orden_compra_det ocd
join items i on i.it_codigo=ocd.it_codigo 
and i.tipit_codigo=ocd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
order by ocd.orcom_codigo;

select 
	pp.pedco_codigo,
	pp.prepro_codigo,
	'Presupuesto'||' '||pp.prepro_codigo as presupuesto,
	ppc.pro_codigo,
	ppc.tipro_codigo,
	p.pro_razonsocial
from pedido_presupuesto pp
join presupuesto_proveedor_cab ppc on ppc.prepro_codigo=pp.prepro_codigo
join proveedor p on p.pro_codigo=ppc.pro_codigo
where cast(pp.prepro_codigo as varchar) ilike '%1%' and ppc.prepro_estado='ACTIVO'
order by pp.prepro_codigo;

cast(pcc.pedco_codigo as varchar)

select 
	aic.*,
	u.usu_login,
	e.emp_razonsocial,
	s.suc_descripcion
from ajuste_inventario_cab aic
join usuario u on u.usu_codigo=aic.usu_codigo
join sucursal s on s.suc_codigo=aic.suc_codigo
and s.emp_codigo=aic.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by aic.ajuin_codigo;

select
	aid.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	d.dep_descripcion,
	su.suc_descripcion,
	e.emp_razonsocial
from ajuste_inventario_det aid
join stock s on s.it_codigo=aid.it_codigo
and s.tipit_codigo=aid.tipit_codigo and
s.dep_codigo=aid.dep_codigo and s.suc_codigo=aid.suc_codigo
and s.emp_codigo=aid.emp_codigo
join items i on i.it_codigo=s.it_codigo 
and i.tipit_codigo=s.tipit_codigo 
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join deposito d on d.dep_codigo=s.dep_codigo and
d.suc_codigo=s.suc_codigo and d.emp_codigo=s.emp_codigo 
join sucursal su on su.suc_codigo=d.suc_codigo 
and su.emp_codigo=d.emp_codigo
join empresa e on e.emp_codigo=su.emp_codigo
order by aid.ajuin_codigo;

select * from deposito where suc_codigo=1 and emp_codigo=1 and dep_estado='ACTIVO';

select 
	s.it_codigo,
	s.tipit_codigo,
	i.it_descripcion 
from stock s 
	join items i on i.it_codigo=s.it_codigo
	and i.tipit_codigo=s.tipit_codigo
	where s.dep_codigo=1 and s.suc_codigo=1 and s.emp_codigo=1
order by s.it_codigo;

select 
	pvc.*,
	s.suc_descripcion,
	e.emp_razonsocial,
	p.per_nombre||' '||p.per_apellido as cliente,
	u.usu_login
from pedido_venta_cab pvc
	join usuario u on u.usu_codigo=pvc.usu_codigo 
	join cliente c on c.cli_codigo=pvc.cli_codigo
	join personas p on p.per_codigo=c.per_codigo
	join sucursal s on s.suc_codigo=pvc.suc_codigo
	and s.emp_codigo=pvc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
order by pvc.peven_codigo;

select 
	pvd.*,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	i.it_descripcion,
	m.mod_codigomodelo,
	ti.tipit_descripcion
from pedido_venta_det pvd
	join items i on i.it_codigo=pvd.it_codigo
	and i.tipit_codigo=pvd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
order by pvd.peven_codigo;

select
	c.cli_codigo,
	p.per_numerodocumento,
	p.per_nombre||''||p.per_apellido as cliente
from cliente c
	join personas p on p.per_codigo=c.per_codigo
	where p.per_numerodocumento ilike '%99%' and c.cli_estado='ACTIVO'
order by c.cli_codigo;

select 
	i.it_codigo,
	i.tipit_codigo,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	i.it_precio as pevendet_precio
from items i
	join modelo m on m.mod_codigo=i.mod_codigo 
	where it_descripcion ilike '%pan%' and tipit_codigo = 2 and it_estado = 'ACTIVO'
order by i.it_codigo; 

select 
	cc.*,
	p.pro_razonsocial,
	tp.tipro_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	u.usu_login
from compra_cab cc
	join proveedor p on p.pro_codigo=cc.pro_codigo
	and p.tipro_codigo=cc.tipro_codigo
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
	join usuario u on u.usu_codigo=cc.usu_codigo
	join sucursal s on s.suc_codigo=cc.suc_codigo
	and s.emp_codigo=cc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
order by cc.comp_codigo;

select 
	cd.*,
	i.it_descripcion,
	d.dep_descripcion,
	su.suc_descripcion,
	e.emp_razonsocial,
	um.unime_descripcion,
	(case i.tipim_codigo when 1 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as exenta
from compra_det cd
	join stock s on s.it_codigo=cd.it_codigo
	and s.tipit_codigo=cd.tipit_codigo
	and s.dep_codigo=cd.dep_codigo 
	and s.suc_codigo=cd.suc_codigo
	and s.emp_codigo=cd.emp_codigo
	join items i on i.it_codigo=s.it_codigo
	and i.tipit_codigo=s.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
	join deposito d on d.dep_codigo=s.dep_codigo
	and d.suc_codigo=s.suc_codigo
	and d.emp_codigo=s.emp_codigo 
	join sucursal su on su.suc_codigo=d.suc_codigo
	and su.emp_codigo=d.emp_codigo
	join empresa e on e.emp_codigo=su.emp_codigo
	join unidad_medida um on um.unime_codigo=s.unime_codigo
order by cd.comp_codigo;

select
	occ.orcom_codigo,
	'Orden'||' '||occ.orcom_codigo as orden,
	occ.pro_codigo,
	occ.tipro_codigo,
	p.pro_razonsocial,
	occ.orcom_condicionpago as comp_tipofactura,
	occ.orcom_cuota as comp_cuota,
	occ.orcom_interfecha as comp_interfecha
from orden_compra_cab occ
	join proveedor p on p.pro_codigo=occ.pro_codigo
	and p.tipro_codigo=occ.tipro_codigo
	where cast(occ.orcom_codigo as varchar) ilike '%1%'
	and occ.orcom_estado='COMPLETADO'
order by occ.orcom_codigo;

select 
	ncc.*,
	tc.tipco_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	u.usu_login,
	cc.com_numfactura,
	p.pro_razonsocial
from nota_compra_cab ncc
join tipo_comprobante tc on tc.tipco_codigo=ncc.tipco_codigo
join sucursal s on s.suc_codigo=ncc.suc_codigo
and s.emp_codigo=ncc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo 
join usuario u on u.usu_codigo=ncc.usu_codigo
join compra_cab cc on cc.comp_codigo=ncc.comp_codigo
join proveedor p on p.pro_codigo=ncc.pro_codigo
and p.tipro_codigo=ncc.tipro_codigo
order by ncc.nocom_codigo;

select 
	ncd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	(case i.tipim_codigo when 1 then ncd.nocomdet_cantidad * ncd.nocomdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ncd.nocomdet_cantidad * ncd.nocomdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ncd.nocomdet_cantidad * ncd.nocomdet_precio else 0 end) as exenta
from nota_compra_det ncd
join items i on i.it_codigo=ncd.it_codigo
and i.tipit_codigo=ncd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
order by ncd.nocom_codigo;

select 
	cc.comp_codigo,
	'Compra'||' '||cc.comp_codigo as compra,
	cc.com_numfactura,
	cc.pro_codigo,
	cc.tipro_codigo,
	p.pro_razonsocial
from compra_cab cc
	join proveedor p on p.pro_codigo=cc.pro_codigo
	and p.tipro_codigo=cc.tipro_codigo
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
	where cast(cc.comp_codigo as varchar) ilike '%1%' and cc.comp_estado='ANULADO'
order by cc.comp_codigo;

select *
from tipo_comprobante tc
	where tc.tipco_descripcion ilike '%remi%'
order by tc.tipco_codigo;

select * 
from items i
	where i.it_descripcion ilike '%h%' and i.it_estado = 'ACTIVO'
	and i.tipit_codigo = 1;
order by i.it_codigo; 

select * from tipo_documento td where td.tipdo_codigo between 1 and 4 order by td.tipdo_codigo;
select * from tipo_comprobante tp where tp.tipco_codigo between 1 and 4 order by tp.tipco_codigo;
select * from forma_cobro fc where fc.forco_codigo between 1 and 4 order by fc.forco_codigo;

select 
	pcc.*,
	s.suc_descripcion,
	e.emp_razonsocial,
	u.usu_login 
from pedido_compra_cab pcc
join sucursal s on s.suc_codigo=pcc.suc_codigo
and s.emp_codigo=pcc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo 
join usuario u on u.usu_codigo=pcc.usu_codigo
order by pcc.pedco_codigo;

select
	pcd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	(case i.tipim_codigo when 1 then pcd.pedcodet_cantidad * pcd.pedcodet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then pcd.pedcodet_cantidad * pcd.pedcodet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then pcd.pedcodet_cantidad * pcd.pedcodet_precio else 0 end) as exenta
from pedido_compra_det pcd 
	join items i on i.it_codigo=pcd.it_codigo
	and i.tipit_codigo=pcd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
where pcd.pedco_codigo=1
order by pcd.pedco_codigo;

select * from stock;

UPDATE stock
SET st_cantidad=st_cantidad+10
WHERE it_codigo=5 AND tipit_codigo=1 AND dep_codigo=1 AND suc_codigo=1 AND emp_codigo=1;

select 
	ppc.*,
	u.usu_login,
	p.pro_razonsocial,
	p.pro_ruc,
	tp.tipro_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	pp.pedco_codigo
from presupuesto_proveedor_cab ppc
	join usuario u on u.usu_codigo=ppc.usu_codigo
	join proveedor p on p.pro_codigo=ppc.pro_codigo
	and p.tipro_codigo=ppc.tipro_codigo
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
	join sucursal s on s.suc_codigo=ppc.suc_codigo 
	and s.emp_codigo=ppc.emp_codigo 
	join empresa e on e.emp_codigo=s.emp_codigo
	join pedido_presupuesto pp on pp.prepro_codigo=ppc.prepro_codigo
order by ppc.prepro_codigo;

select
	ppd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	(case i.tipim_codigo when 1 then ppd.peprodet_cantidad * ppd.peprodet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ppd.peprodet_cantidad * ppd.peprodet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ppd.peprodet_cantidad * ppd.peprodet_precio else 0 end) as exenta
from presupuesto_proveedor_det ppd 
	join items i on i.it_codigo=ppd.it_codigo
	and i.tipit_codigo=ppd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
	where ppd.prepro_codigo=1
order by ppd.prepro_codigo;

select 
	occ.*,
	u.usu_login,
	p.pro_razonsocial,
	tp.tipro_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	po.prepro_codigo,
	pepre.pedco_codigo
from orden_compra_cab occ
	join usuario u on u.usu_codigo=occ.usu_codigo
	join proveedor p on p.pro_codigo=occ.pro_codigo
	and p.tipro_codigo=occ.tipro_codigo
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
	join sucursal s on s.suc_codigo=occ.suc_codigo
	and s.emp_codigo=occ.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
	join presupuesto_orden po on po.orcom_codigo=occ.orcom_codigo
	join pedido_presupuesto pepre on pepre.prepro_codigo=po.prepro_codigo
order by occ.orcom_codigo;

select 
	ocd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	(case i.tipim_codigo when 1 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as exenta
from orden_compra_det ocd
	join items i on i.it_codigo=ocd.it_codigo 
	and i.tipit_codigo=ocd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
	where ocd.orcom_codigo=1
order by ocd.orcom_codigo;

select 
	cc.*,
	p.pro_razonsocial,
	tp.tipro_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	u.usu_login,
	oc.orcom_codigo
from compra_cab cc
	join orden_compra oc on oc.comp_codigo=cc.comp_codigo
	join proveedor p on p.pro_codigo=cc.pro_codigo
	and p.tipro_codigo=cc.tipro_codigo
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
	join usuario u on u.usu_codigo=cc.usu_codigo
	join sucursal s on s.suc_codigo=cc.suc_codigo
	and s.emp_codigo=cc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
order by cc.comp_codigo;

select 
	cd.*,
	i.it_descripcion,
	d.dep_descripcion,
	su.suc_descripcion,
	e.emp_razonsocial,
	um.unime_descripcion,
	(case i.tipim_codigo when 1 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as exenta
from compra_det cd
	join stock s on s.it_codigo=cd.it_codigo
	and s.tipit_codigo=cd.tipit_codigo
	and s.dep_codigo=cd.dep_codigo 
	and s.suc_codigo=cd.suc_codigo
	and s.emp_codigo=cd.emp_codigo
	join items i on i.it_codigo=s.it_codigo
	and i.tipit_codigo=s.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
	join deposito d on d.dep_codigo=s.dep_codigo
	and d.suc_codigo=s.suc_codigo
	and d.emp_codigo=s.emp_codigo 
	join sucursal su on su.suc_codigo=d.suc_codigo
	and su.emp_codigo=d.emp_codigo
	join empresa e on e.emp_codigo=su.emp_codigo
	join unidad_medida um on um.unime_codigo=s.unime_codigo
	where cd.comp_codigo=1
order by cd.comp_codigo;

select 
	ncc.*,
	tc.tipco_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	u.usu_login,
	cc.com_numfactura,
	p.pro_razonsocial,
	tp.tipro_descripcion
from nota_compra_cab ncc
	join tipo_comprobante tc on tc.tipco_codigo=ncc.tipco_codigo
	join sucursal s on s.suc_codigo=ncc.suc_codigo
	and s.emp_codigo=ncc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo 
	join usuario u on u.usu_codigo=ncc.usu_codigo
	join compra_cab cc on cc.comp_codigo=ncc.comp_codigo
	join proveedor p on p.pro_codigo=ncc.pro_codigo
	and p.tipro_codigo=ncc.tipro_codigo
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
	where ncc.nocom_fecha between '1/10/2023' and '29/10/2023'
order by ncc.nocom_codigo;

select 
	ncd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	(case i.tipim_codigo when 1 then ncd.nocomdet_cantidad * ncd.nocomdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ncd.nocomdet_cantidad * ncd.nocomdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ncd.nocomdet_cantidad * ncd.nocomdet_precio else 0 end) as exenta
from nota_compra_det ncd
   join items i on i.it_codigo=ncd.it_codigo
   and i.tipit_codigo=ncd.tipit_codigo
   join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
   join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
   where ncd.nocom_codigo=1
order by ncd.nocom_codigo;

select 
	aic.*,
	u.usu_login,
	e.emp_razonsocial,
	s.suc_descripcion
from ajuste_inventario_cab aic
	join usuario u on u.usu_codigo=aic.usu_codigo
	join sucursal s on s.suc_codigo=aic.suc_codigo
	and s.emp_codigo=aic.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
where aic.ajuin_fecha between '' and ''
order by aic.ajuin_codigo;

select
	aid.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	d.dep_descripcion,
	su.suc_descripcion,
	e.emp_razonsocial,
	um.unime_descripcion
from ajuste_inventario_det aid
   join stock s on s.it_codigo=aid.it_codigo
   and s.tipit_codigo=aid.	tipit_codigo and
   s.dep_codigo=aid.dep_codigo and s.suc_codigo=aid.suc_codigo
   and s.emp_codigo=aid.emp_codigo
   join items i on i.it_codigo=s.it_codigo 
   and i.tipit_codigo=s.tipit_codigo 
   join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
   join deposito d on d.dep_codigo=s.dep_codigo and
   d.suc_codigo=s.suc_codigo and d.emp_codigo=s.emp_codigo 
   join sucursal su on su.suc_codigo=d.suc_codigo 
   and su.emp_codigo=d.emp_codigo
   join empresa e on e.emp_codigo=su.emp_codigo
   join unidad_medida um on um.unime_codigo=s.unime_codigo
   where aid.ajuin_codigo=1
order by aid.ajuin_codigo;

select * from marca_tarjeta mt where mt.marta_codigo between 1 and 3 order by mt.marta_codigo;

select * from entidad_emisora ee where ee.ent_codigo between 1 and 3 order by ee.ent_codigo;

select ea.*, ee.ent_razonsocial, mt.marta_descripcion from entidad_adherida ea
join entidad_emisora ee on ee.ent_codigo=ea.entad_codigo join marca_tarjeta mt on mt.marta_codigo=ea.marta_codigo
where ea.entad_codigo between 1 and 2
order by ea.entad_codigo;

select c.*, s.suc_descripcion, e.emp_razonsocial 
from caja c join sucursal s on s.suc_codigo=c.suc_codigo
and s.emp_codigo=c.emp_codigo join empresa e on e.emp_codigo=s.emp_codigo
where c.caj_codigo between 1 and 2
order by c.caj_codigo

select c.*, p.per_nombre||' '||p.per_apellido as persona, p.per_numerodocumento,
ci.ciu_descripcion from cliente c join personas p on p.per_codigo=c.per_codigo
join ciudad ci on ci.ciu_codigo=c.ciu_codigo where c.cli_codigo between 1 and 3
order by c.cli_codigo;

select 
	pc.*,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	p.per_nombre||''||p.per_apellido as cliente
from presupuesto_cab pc
join usuario u on u.usu_codigo=pc.usu_codigo
join sucursal s on s.suc_codigo=pc.suc_codigo
and s.emp_codigo=pc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
join cliente c on c.cli_codigo=pc.cli_codigo
join personas p on p.per_codigo=c.per_codigo
order by pc.pres_codigo;

select 
	pd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	(case i.tipim_codigo when 1 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as exenta
from presupuesto_det pd
join items i on i.it_codigo=pd.it_codigo
and i.tipit_codigo=pd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
order by pd.pres_codigo;

select 
	pvc.peven_codigo,
	'Pedido '||pvc.peven_codigo as pedido,
	pvc.cli_codigo,
	p.per_nombre||''||p.per_apellido as cliente
from pedido_venta_cab pvc
	join cliente c on c.cli_codigo=pvc.cli_codigo
	join personas p on p.per_codigo=c.per_codigo
	where cast(pvc.peven_codigo as varchar) ilike '%1%' and pvc.peven_estado='ACTIVO'
order by pvc.peven_codigo;

select 
	pvd.it_codigo,
	pvd.tipit_codigo,
	i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as it_descripcion,
	t.tall_descripcion,
	i.it_precio as presdet_precio
from pedido_venta_det pvd
	join items i on i.it_codigo=pvd.it_codigo
	and i.tipit_codigo=pvd.tipit_codigo 
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo 
	where pvd.peven_codigo=1 and i.it_estado='ACTIVO'
	and i.it_descripcion ilike '%p%'
order by pvd.peven_codigo;

select 
	opc.*,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	se.secc_descripcion,
	op.pres_codigo,
	pc.peven_codigo
from orden_produccion_cab opc
	join usuario u on u.usu_codigo=opc.usu_codigo
	join sucursal s on s.suc_codigo=opc.suc_codigo 
	and s.emp_codigo=opc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
	join seccion se on se.secc_codigo=opc.secc_codigo
	join orden_presupuesto op on op.orpro_codigo=opc.orpro_codigo
	join presupuesto_cab pc on pc.pres_codigo=op.pres_codigo
order by opc.orpro_codigo;

select 
	opd.*,
	i.it_descripcion||' '||m.mod_codigomodelo as it_descripcion,
	t.tall_descripcion,
	ti.tipit_descripcion
from orden_produccion_det opd
	join items i on i.it_codigo=opd.it_codigo
	and i.tipit_codigo=opd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
order by opd.orpro_codigo;

select 
	pc.pres_codigo,
	'Presupuesto '||pc.pres_codigo as presupuesto,
	pc.peven_codigo
from presupuesto_cab pc 
	where cast(pc.pres_codigo as varchar) ilike '%1%'
	and pc.pres_estado='ACTIVO'
order by pc.pres_codigo;

select 
	pd.it_codigo,
	pd.tipit_codigo,
	i.it_descripcion||' '||m.mod_codigomodelo as it_descripcion,
	t.tall_descripcion,
	pd.presdet_cantidad as orprodet_cantidad
from presupuesto_det pd
	join items i on i.it_codigo=pd.it_codigo
	and i.tipit_codigo=pd.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
	where i.it_descripcion ilike '%p%' and i.it_estado='ACTIVO'
	and pd.pres_codigo=1
order by pd.it_codigo;

select 
	pc.*,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial
from produccion_cab pc
	join usuario u on u.usu_codigo=pc.usu_codigo
	join sucursal s on s.suc_codigo=pc.suc_codigo
	and s.emp_codigo=pc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
order by pc.prod_codigo;

select 
	pd.*,
	i.it_descripcion||' '||m.mod_codigomodelo as it_descripcion,
	ti.tipit_descripcion,
	t.tall_descripcion
from produccion_det pd
	join items i on i.it_codigo=pd.it_codigo
	and i.tipit_codigo=pd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
order by pd.prod_codigo;

select 
	opc.orpro_codigo,
	'Orden '||opc.orpro_codigo as orden,
	s.secc_descripcion
from orden_produccion_cab opc
join seccion s on s.secc_codigo=opc.secc_codigo
	where cast(opc.orpro_codigo as varchar) ilike '%%'
	and opc.orpro_estado='EN PRODUCCION'
order by opc.orpro_codigo; 


select 
	opd.it_codigo,
	opd.tipit_codigo,
	i.it_descripcion||' '||m.mod_codigomodelo as it_descripcion,
	t.tall_descripcion,
	opd.orprodet_cantidad as prodet_cantidad
from orden_produccion_det opd
	join items i on i.it_codigo=opd.it_codigo
	and i.tipit_codigo=opd.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
	where i.it_descripcion ilike '%%' and i.it_estado='ACTIVO'
	and opd.orpro_codigo=1
order by opd.orpro_codigo;

select 
	ep.*,
	i.it_descripcion||' '||mo.mod_codigomodelo it_descripcion,
	t.tall_descripcion,
	tep.tipet_descripcion,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	ma.maq_descripcion
from etapa_produccion ep
	join orden_produccion_det opd on opd.orpro_codigo=ep.orpro_codigo
	and opd.it_codigo=ep.it_codigo
	and opd.tipit_codigo=ep.tipit_codigo
	join items i on i.it_codigo=opd.it_codigo 
	and i.tipit_codigo=opd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join modelo mo on mo.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
	join tipo_etapa_produccion tep on tep.tipet_codigo=ep.tipet_codigo
	join usuario u on u.usu_codigo=ep.usu_codigo
	join sucursal s on s.suc_codigo=ep.suc_codigo
	and s.emp_codigo=ep.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
	join maquinaria ma on ma.maq_codigo=ep.maq_codigo
order by ep.orpro_codigo;

select distinct
	opd.orpro_codigo, 
	'Orden N° '||opd.orpro_codigo as orden
from orden_produccion_det opd
	join orden_produccion_cab opc on opc.orpro_codigo=opd.orpro_codigo
	where cast(opd.orpro_codigo as varchar) ilike '%1%'
	and opc.orpro_estado='ACTIVO'
order by opd.orpro_codigo;


select 
	opd.it_codigo,
	opd.tipit_codigo,
	i.it_descripcion||' '||m.mod_codigomodelo as it_descripcion,
	t.tall_descripcion
from orden_produccion_det opd
	join items i on i.it_codigo=opd.it_codigo
	and i.tipit_codigo=opd.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
	where i.it_descripcion ilike '%%' and i.it_estado='ACTIVO'
	and opd.orpro_codigo=1
order by opd.orpro_codigo;

select * from maquinaria where maq_descripcion ilike '%rec%' order by maq_codigo;

select * from tipo_etapa_produccion where tipet_descripcion ilike '%su%' order by tipet_codigo;

select distinct
         opd.orpro_codigo, 
         'Orden N° '||opd.orpro_codigo as orden
      from orden_produccion_det opd
         join orden_produccion_cab opc on opc.orpro_codigo=opd.orpro_codigo
         where cast(opd.orpro_codigo as varchar) ilike '%$orden%'
         and opc.orpro_estado='ACTIVO'
      order by opd.orpro_codig;

select * from cargo where car_codigo between 1 and  order by car_codigo;
select * from talle where tall_codigo between 1 and 4 order by tall_codigo;
select * from color_prenda where  col_codigo between 1 and 4 order by col_codigo;
select * from maquinaria where maq_codigo betw een 1 and 10 order by maq_codigo;
select * from tipo_etapa_produccion where tipet_codigo between 1 and 20 order by tipet_codigo;
select * from unidad_medida where unime_codigo between 1 and 5 order by unime_codigo;
select * from parametro_control_calidad where pacoca_codigo between 1 and 5 order by pacoca_codigo;
select * from costo_servicio where costserv_codigo between 1 and 3 order by costserv_codigo; 
select cs.*, m.mod_codigomodelo from costo_servicio cs join modelo m on m.mod_codigo=cs.mod_codigo
where cs.costserv_codigo between 1 and 5 order by cs.costserv_codigo;
select s.*, su.suc_descripcion, e.emp_razonsocial from seccion s join sucursal su on su.suc_codigo=s.suc_codigo
and su.emp_codigo=s.emp_codigo join empresa e on e.emp_codigo=su.emp_codigo where s.secc_codigo between 1
and 8 order by s.secc_codigo;

select g.gui_descripcion as interfaz, perfgui_estado as estado from perfil_gui pg
join perfil p on p.perf_codigo=pg.perf_codigo
join gui g on g.gui_codigo=pg.gui_codigo
and g.modu_codigo=pg.modu_codigo
join modulo m on m.modu_codigo=g.modu_codigo
where p.perf_descripcion='ADMINISTRADOR'
order by pg.perfgui_codigo;

select 
         i.it_codigo,
         i.tipit_codigo,
         i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as item,
         t.tall_descripcion,
         i.it_precio as pevendet_precio
      from items i
         join modelo m on m.mod_codigo=i.mod_codigo
         join talle t on t.tall_codigo=i.tall_codigo
         where it_descripcion ilike '%%' and tipit_codigo = 2 and it_estado = 'ACTIVO'
      order by i.it_codigo;





select 
    et.*,
    p.per_nombre||' '||p.per_apellido as funcionario,
    p.per_numerodocumento,
    s.secc_descripcion,
    s2.suc_descripcion,
    e.emp_razonsocial 
from equipo_trabajo et
    join seccion s on s.secc_codigo=et.secc_codigo
    join funcionario f on f.func_codigo=et.func_codigo
    join personas p on p.per_codigo=f.per_codigo
    join sucursal s2 on s2.suc_codigo=f.suc_codigo
    and s2.emp_codigo=f.emp_codigo
    join empresa e on e.emp_codigo=s.emp_codigo
    where s.secc_codigo between 1 and 10
order by et.func_codigo;

select 
    p.*,
    p.per_nombre||' '||p.per_apellido as persona,
    td.tipdo_descripcion
from personas p
	join tipo_documento td on td.tipdo_codigo=p.tipdo_codigo
	where p.per_codigo between 1 and 8 
order by p.per_codigo;

select 
    f.*,
    p.per_nombre||' '||p.per_apellido as persona,
    p.per_numerodocumento,
    c.ciu_descripcion,
    c2.car_descripcion,
    s.suc_descripcion,
    e.emp_razonsocial
from funcionario f
    join personas p on p.per_codigo=f.per_codigo
    join ciudad c on c.ciu_codigo=f.ciu_codigo
    join cargo c2 on c2.car_codigo=f.car_codigo
    join sucursal s on s.suc_codigo=f.suc_codigo 
    and s.emp_codigo=f.emp_codigo
    join empresa e on e.emp_codigo=s.emp_codigo
    where f.func_codigo between 1 and 8
order by f.func_codigo

select 
         s.it_codigo,
         s.tipit_codigo,
         (case s.tipit_codigo when 1 then i.it_descripcion 
         else i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion end) as it_descripcion,
         t.tall_descripcion,
         um.unime_descripcion 
      from stock s 
         join items i on i.it_codigo=s.it_codigo
         and i.tipit_codigo=s.tipit_codigo
         join unidad_medida um on um.unime_codigo=s.unime_codigo
         join modelo m on m.mod_codigo=i.mod_codigo
         join talle t on t.tall_codigo=i.tall_codigo
         where s.dep_codigo=1 and s.suc_codigo=1 and s.emp_codigo=1 and i.it_descripcion ilike '%%'
         and (i.tipit_codigo = 1 or i.tipit_codigo = 2)
      order by s.it_codigo;


select 
	cp.cuenpa_nrocuota,
	cp.cuenpa_montototal,
	cp.cuenpa_montosaldo,
	cp.cuenpa_estado,
	cb.comp_interfecha
from 
	cuenta_pagar cp
	join compra_cab cb on cb.comp_codigo=cp.comp_codigo
	where cp.comp_codigo = 1
order by cp.comp_codigo;

select 
	lc.*,
	p.pro_razonsocial,
	p.pro_ruc 
from libro_compra lc 
	join compra_cab cc on cc.comp_codigo=lc.comp_codigo
	join proveedor p on p.pro_codigo=cc.pro_codigo
	and p.tipro_codigo=cc.tipro_codigo
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
	where lc.licom_fecha between '01/09/2023' and '01/12/2023'
order by lc.licom_codigo;

select 
	e.emp_razonsocial,
	su.suc_descripcion,
	d.dep_descripcion,
	i.it_descripcion,
	s.st_cantidad,
	um.unime_descripcion
from stock s
	join items i on i.it_codigo=s.it_codigo 
	and i.tipit_codigo=s.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo 
	join deposito d on d.dep_codigo=s.dep_codigo
	and d.suc_codigo=s.dep_codigo 
	and d.emp_codigo=s.emp_codigo
	join sucursal su on su.suc_codigo=d.suc_codigo 
	and su.emp_codigo=d.emp_codigo
	join empresa e on e.emp_codigo=su.emp_codigo
	join unidad_medida um on um.unime_codigo=s.unime_codigo
	where s.dep_codigo=1
order by s.it_codigo;
 
select
	cb.comp_codigo,
	cb.comp_fecha,
	cb.com_numfactura,
	cb.comp_tipofactura,
	cb.comp_interfecha,
	p.pro_razonsocial,
	tp.tipro_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	u.usu_login
from 
	compra_cab cb
	join proveedor p on p.pro_codigo=cb.pro_codigo
	and p.tipro_codigo=cb.tipro_codigo
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
	join sucursal s on s.suc_codigo=cb.suc_codigo
	and s.emp_codigo=cb.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
	join usuario u on u.usu_codigo=cb.usu_codigo
	join funcionario f on f.func_codigo=u.func_codigo
	join personas pe on pe.per_codigo=f.per_codigo
	where cb.comp_fecha between '01/09/2023' and '01/12/2023'
order by cb.comp_codigo;

select 	
	i.it_descripcion||' '||m.mod_codigomodelo as producto,
	t.tall_descripcion,
	um.unime_descripcion
from pedido_venta_det pvd
join stock s on s.it_codigo=pvd.it_codigo
and s.tipit_codigo=pvd.tipit_codigo
join items i on i.it_codigo=pvd.it_codigo 
and i.tipit_codigo=pvd.tipit_codigo
join modelo m on m.mod_codigo=i.mod_codigo
join talle t on t.tall_codigo=i.it_codigo
join unidad_medida um on um.unime_codigo=s.unime_codigo 
where pvd.peven_codigo=1


select 	
	i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as producto,
	t.tall_descripcion,
	pvd.pevendet_cantidad as cantidad,
	i.it_precio as precio,
	um.unime_descripcion,
	pvd.it_codigo,
	pvd.tipit_codigo
from stock s
	join pedido_venta_det pvd on s.it_codigo=pvd.it_codigo
	and s.tipit_codigo=pvd.tipit_codigo
	join pedido_venta_cab pvc on pvc.peven_codigo=pvd.peven_codigo
	join items i on i.it_codigo=s.it_codigo 
	and i.tipit_codigo=s.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
	join unidad_medida um on um.unime_codigo=s.unime_codigo 
where 
	pvd.peven_codigo=1 and s.dep_codigo=1 and s.suc_codigo=1
	and s.emp_codigo=1 and (i.it_descripcion ilike '%bermuda%' or m.mod_codigomodelo ilike '%100%')
	and pvc.peven_estado='VENDIDO';

s.dep_codigo=1 and s.suc_codigo=1 and s.emp_codigo=1

select 
	p.per_nombre||' '||p.per_apellido as cliente,
	'N° Venta: '||vc.ven_codigo||' Factura: '||vc.ven_numfactura as venta,
	vc.ven_numfactura as factura,
	p.per_numerodocumento as cedula
from venta_cab vc
join cliente c on c.cli_codigo=vc.cli_codigo
join personas p on p.per_codigo=c.per_codigo
where p.per_numerodocumento ilike '%8%'
order by vc.ven_numfactura;

select 
	i.it_codigo,
	i.tipit_codigo,
	i.it_descripcion||' '||m.mod_codigomodelo as descripcion,
	i.it_precio as notvendet_precio,
	i.it_descripcion,
	t.tall_descripcion,
	um.unime_descripcion
from items i
   join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
   join talle t on t.tall_codigo=i.tall_codigo
   join modelo m on m.mod_codigo=i.mod_codigo
   join stock s on s.it_codigo=i.it_codigo
   and s.tipit_codigo=i.tipit_codigo
   join unidad_medida um on um.unime_codigo=s.unime_codigo
where i.it_descripcion ilike '%%' and i.it_estado = 'ACTIVO'
and (i.tipit_codigo = 2 or i.tipit_codigo = 3)
order by i.it_codigo;
update cuenta_cobrar set cuenco_montototal = cuenco_montototal+50000, cuenco_montosaldo = cuenco_montosaldo+50000
where ven_codigo=1;
update venta_cab set vent_montocuota = vent_montocuota+50000 where ven_codigo=1;
update libro_venta set libven_iva10 = libven_iva10+50000 where ven_codigo=1;

select 
            vc.ven_codigo,
            vc.ven_tipofactura,
            c.cli_codigo,
            p.per_nombre||' '||p.per_apellido as cliente,
            'N° Venta: '||vc.ven_codigo||' Factura: '||vc.ven_numfactura as venta,
            vc.ven_numfactura as factura,
            p.per_numerodocumento as cedula
         from venta_cab vc
            join cliente c on c.cli_codigo=vc.cli_codigo
            join personas p on p.per_codigo=c.per_codigo
            where p.per_numerodocumento ilike '%88%'
            and vc.ven_estado <> 'ANULADO'
         order by vc.ven_numfactura;

select 
            vc.ven_codigo,
            vc.ven_tipofactura,
            c.cli_codigo,
            p.per_nombre||' '||p.per_apellido as cliente,
            'N° Venta: '||vc.ven_codigo||' Factura: '||vc.ven_numfactura as venta,
            vc.ven_numfactura as factura,
            p.per_numerodocumento as cedula
         from venta_cab vc
            join cliente c on c.cli_codigo=vc.cli_codigo
            join personas p on p.per_codigo=c.per_codigo
            where p.per_numerodocumento ilike '%888%'
            and vc.ven_estado <> 'ANULADO' and ((current_date-vc.ven_fecha)<=7)
         order by vc.ven_numfactura;
        
 select cuenco_montototal from cuenta_cobrar where ven_codigo = 1;

update venta_cab set ven_estado = 'CANCELADO' where ven_codigo = 1; 

update venta_cab set ven_cuota = 1 where ven_codigo = 1;
update cuenta_cobrar set cuenco_nrocuota = 1 where ven_codigo = 1;










--TRIGGER
select u.usu_login from pedido_compra_cab pccjoin usuario u on u.usu_codigo=pcc.usu_codigo where pcc.pedco_codigo=1;
select pcc.usu_codigo from pedido_compra_cab pcc where pcc.pedco_codigo=1;

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_pedido_compra_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select pcc.usu_codigo from pedido_compra_cab pcc where pcc.pedco_codigo=NEW.pedco_codigo);
		usuLogin = (select u.usu_login from pedido_compra_cab pcc join usuario u on u.usu_codigo=pcc.usu_codigo where pcc.pedco_codigo=NEW.pedco_codigo);
        INSERT INTO pedido_compra_det_auditoria (
            pedcodetaud_codigo,
            usu_codigo,
            usu_login,
            pedcodetaud_fecha,
            pedcodetaud_procedimiento,
            pedco_codigo,
            it_codigo,
            tipit_codigo,
            pedcodet_cantidad,
            pedcodet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(pedcodetaud_codigo), 0) + 1 FROM pedido_compra_det_auditoria), -- Generar nuevo código
            usuCodigo, -- Asumiendo que tienes el usuario en NEW
            usuLogin,  -- Asumiendo que tienes el login del usuario en NEW
            current_timestamp,-- Fecha y hora actual
            'ALTA',       -- Procedimiento (puedes cambiarlo si necesitas más información)
            NEW.pedco_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.pedcodet_cantidad,
            NEW.pedcodet_precio
        );

    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select pcc.usu_codigo from pedido_compra_cab pcc where pcc.pedco_codigo=OLD.pedco_codigo);
		usuLogin = (select u.usu_login from pedido_compra_cab pcc join usuario u on u.usu_codigo=pcc.usu_codigo where pcc.pedco_codigo=OLD.pedco_codigo);
        INSERT INTO pedido_compra_det_auditoria (
            pedcodetaud_codigo,
            usu_codigo,
            usu_login,
            pedcodetaud_fecha,
            pedcodetaud_procedimiento,
            pedco_codigo,
            it_codigo,
            tipit_codigo,
            pedcodet_cantidad,
            pedcodet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(pedcodetaud_codigo), 0) + 1 FROM pedido_compra_det_auditoria), -- Generar nuevo código
            usuCodigo, -- Asumiendo que tienes el usuario en OLD
            usuLogin,  -- Asumiendo que tienes el login del usuario en OLD
            current_timestamp,         -- Fecha y hora actual
            'BAJA',       -- Procedimiento (puedes cambiarlo si necesitas más información)
            OLD.pedco_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.pedcodet_cantidad,
            OLD.pedcodet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_pedido_compra_det()
CREATE TRIGGER t_insercion_eliminacion_pedido_compra_det
AFTER INSERT OR DELETE ON pedido_compra_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_pedido_compra_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_presupuesto_proveedor_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ppc.usu_codigo from presupuesto_proveedor_cab ppc where ppc.prepro_codigo=NEW.prepro_codigo);
		usuLogin = (select u.usu_login from presupuesto_proveedor_cab ppc join usuario u on u.usu_codigo=ppc.usu_codigo where ppc.prepro_codigo=NEW.prepro_codigo);
        INSERT INTO presupuesto_proveedor_det_auditoria (
            preprodetaud_codigo,
            usu_codigo,
            usu_login,
            preprodetaud_fecha,
            preprodetaud_procedimiento,
            prepro_codigo,
            it_codigo,
            tipit_codigo,
            peprodet_cantidad,
            peprodet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(preprodetaud_codigo), 0) + 1 FROM presupuesto_proveedor_det_auditoria), -- Generar nuevo código
            usuCodigo, -- Asumiendo que tienes el usuario en NEW
            usuLogin,  -- Asumiendo que tienes el login del usuario en NEW
            current_timestamp,-- Fecha y hora actual
            'ALTA',       -- Procedimiento (puedes cambiarlo si necesitas más información)
            NEW.prepro_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.peprodet_cantidad,
            NEW.peprodet_precio
        );

    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ppc.usu_codigo from presupuesto_proveedor_cab ppc where ppc.prepro_codigo=OLD.prepro_codigo);
		usuLogin = (select u.usu_login from presupuesto_proveedor_cab ppc join usuario u on u.usu_codigo=ppc.usu_codigo where ppc.prepro_codigo=OLD.prepro_codigo);
        INSERT INTO presupuesto_proveedor_det_auditoria (
            preprodetaud_codigo,
            usu_codigo,
            usu_login,
            preprodetaud_fecha,
            preprodetaud_procedimiento,
            prepro_codigo,
            it_codigo,
            tipit_codigo,
            peprodet_cantidad,
            peprodet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(preprodetaud_codigo), 0) + 1 FROM presupuesto_proveedor_det_auditoria), -- Generar nuevo código
            usuCodigo, -- Asumiendo que tienes el usuario en OLD
            usuLogin,  -- Asumiendo que tienes el login del usuario en OLD
            current_timestamp,         -- Fecha y hora actual
            'BAJA',       -- Procedimiento (puedes cambiarlo si necesitas más información)
            OLD.prepro_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.peprodet_cantidad,
            OLD.peprodet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_presupuesto_proveedor_det()
CREATE TRIGGER t_insercion_eliminacion_presupuesto_proveedor_det
AFTER INSERT OR DELETE ON presupuesto_proveedor_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_presupuesto_proveedor_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_orden_compra_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select occ.usu_codigo from orden_compra_cab occ where occ.orcom_codigo=NEW.orcom_codigo);
		usuLogin = (select u.usu_login from orden_compra_cab occ join usuario u on u.usu_codigo=occ.usu_codigo where occ.orcom_codigo=NEW.orcom_codigo);
        INSERT INTO orden_compra_det_auditoria(
            orcomdetaud_codigo,
            usu_codigo,
            usu_login,
            orcomdetaud_fecha,
            orcomdetaud_procedimiento,
            orcom_codigo,
            it_codigo,
            tipit_codigo,
            orcomdet_cantidad,
            orcomdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(orcomdetaud_codigo), 0) + 1 FROM orden_compra_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.orcom_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.orcomdet_cantidad,
            NEW.orcomdet_precio
        );

    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select occ.usu_codigo from orden_compra_cab occ where occ.orcom_codigo=OLD.orcom_codigo);
		usuLogin = (select u.usu_login from orden_compra_cab occ join usuario u on u.usu_codigo=occ.usu_codigo where occ.orcom_codigo=OLD.orcom_codigo);
        INSERT INTO orden_compra_det_auditoria(
            orcomdetaud_codigo,
            usu_codigo,
            usu_login,
            orcomdetaud_fecha,
            orcomdetaud_procedimiento,
            orcom_codigo,
            it_codigo,
            tipit_codigo,
            orcomdet_cantidad,
            orcomdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(orcomdetaud_codigo), 0) + 1 FROM orden_compra_det_auditoria), -- Generar nuevo código
            usuCodigo, -- Asumiendo que tienes el usuario en OLD
            usuLogin,  -- Asumiendo que tienes el login del usuario en OLD
            current_timestamp,         -- Fecha y hora actual
            'BAJA',       -- Procedimiento (puedes cambiarlo si necesitas más información)
            OLD.orcom_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.orcomdet_cantidad,
            OLD.orcomdet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_orden_compra_det
CREATE TRIGGER t_insercion_eliminacion_orden_compra_det
AFTER INSERT OR DELETE ON orden_compra_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_orden_compra_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_compra_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from compra_cab cc where cc.comp_codigo=NEW.comp_codigo);
		usuLogin = (select u.usu_login from compra_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.comp_codigo=NEW.comp_codigo);
        INSERT INTO compra_det_auditoria(
            compdetaud_codigo,
            usu_codigo,
            usu_login,
            compdetaud_fecha,
            compdetaud_procedimiento,
            comp_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            compdet_cantidad,
            compdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(compdetaud_codigo), 0) + 1 FROM compra_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.comp_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
            NEW.compdet_cantidad,
            NEW.compdet_precio
        );

    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from compra_cab cc where cc.comp_codigo=OLD.comp_codigo);
		usuLogin = (select u.usu_login from compra_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.comp_codigo=OLD.comp_codigo);
        INSERT INTO compra_det_auditoria(
            compdetaud_codigo,
            usu_codigo,
            usu_login,
            compdetaud_fecha,
            compdetaud_procedimiento,
            comp_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            compdet_cantidad,
            compdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(compdetaud_codigo), 0) + 1 FROM compra_det_auditoria), 
            usuCodigo, 
            usuLogin,
            current_timestamp,
            'BAJA',
            OLD.comp_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
            OLD.compdet_cantidad,
            OLD.compdet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_compra_det
CREATE TRIGGER t_insercion_eliminacion_compra_det
AFTER INSERT OR DELETE ON compra_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_compra_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_ajuste_stock_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select aju.usu_codigo from ajuste_stock_cab aju where aju.ajus_codigo=NEW.ajus_codigo);
		usuLogin = (select u.usu_login from ajuste_stock_cab aju join usuario u on u.usu_codigo=aju.usu_codigo where aju.ajus_codigo=NEW.ajus_codigo);
        INSERT INTO ajuste_stock_det_auditoria(
            ajusdetaud_codigo,
            usu_codigo,
            usu_login,
            ajusdetaud_fecha,
            ajusdetaud_procedimiento,
            ajus_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            ajusdet_cantidad,
			ajusdet_precio,
            ajusdet_motivo
        )
        VALUES (
            (SELECT COALESCE(MAX(ajusdetaud_codigo), 0) + 1 FROM ajuste_stock_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.ajus_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
            NEW.ajusdet_cantidad,
			NEW.ajusdet_precio,
            NEW.ajusdet_motivo
        );

    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select aju.usu_codigo from ajuste_stock_cab aju where aju.ajus_codigo=OLD.ajus_codigo);
		usuLogin = (select u.usu_login from ajuste_stock_cab aju join usuario u on u.usu_codigo=aju.usu_codigo where aju.ajus_codigo=OLD.ajus_codigo);
        INSERT INTO ajuste_stock_det_auditoria(
            ajusdetaud_codigo,
            usu_codigo,
            usu_login,
            ajusdetaud_fecha,
            ajusdetaud_procedimiento,
            ajus_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            ajusdet_cantidad,
			ajusdet_precio,
            ajusdet_motivo
        )
        VALUES (
            (SELECT COALESCE(MAX(ajusdetaud_codigo), 0) + 1 FROM ajuste_stock_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',   
            OLD.ajus_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
            OLD.ajusdet_cantidad,
			OLD.ajusdet_precio,
            OLD.ajusdet_motivo
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_ajuste_stock_det
CREATE TRIGGER t_insercion_eliminacion_ajuste_stock_det
AFTER INSERT OR DELETE ON ajuste_stock_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_ajuste_stock_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_nota_compra_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ncc.usu_codigo from nota_compra_cab ncc where ncc.nocom_codigo=NEW.nocom_codigo);
		usuLogin = (select u.usu_login from nota_compra_cab ncc join usuario u on u.usu_codigo=ncc.usu_codigo where ncc.nocom_codigo=NEW.nocom_codigo);
        INSERT INTO nota_compra_det_auditoria(
            nocomdetaud_codigo,
            usu_codigo,
            usu_login,
            nocomdetaud_fecha,
            nocomdetaud_procedimiento,
            nocom_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            nocomdet_cantidad,
			nocomdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(nocomdetaud_codigo), 0) + 1 FROM nota_compra_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.nocom_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
            NEW.nocomdet_cantidad,
			NEW.nocomdet_precio
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ncc.usu_codigo from nota_compra_cab ncc where ncc.nocom_codigo=OLD.nocom_codigo);
		usuLogin = (select u.usu_login from nota_compra_cab ncc join usuario u on u.usu_codigo=ncc.usu_codigo where ncc.nocom_codigo=OLD.nocom_codigo);
        INSERT INTO nota_compra_det_auditoria(
            nocomdetaud_codigo,
            usu_codigo,
            usu_login,
            nocomdetaud_fecha,
            nocomdetaud_procedimiento,
            nocom_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            nocomdet_cantidad,
			nocomdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(nocomdetaud_codigo), 0) + 1 FROM nota_compra_det_auditoria), 
            usuCodigo,  
            usuLogin,  
            current_timestamp,
            'BAJA',   
            OLD.nocom_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
            OLD.nocomdet_cantidad,
			OLD.nocomdet_precio
		);
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_ajuste_inventario_det
CREATE TRIGGER t_insercion_eliminacion_nota_compra_det
AFTER INSERT OR DELETE ON nota_compra_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_nota_compra_det();

CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_eliminacion_stock()
RETURNS TRIGGER AS $$
--Creamos las variables
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO stock_auditoria(
            staud_codigo,
            staud_fecha,
            staud_procedimiento,
            it_codigo,
            tipit_codigo,
            dep_codigo,
			suc_codigo,
			emp_codigo,
			st_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(staud_codigo), 0) + 1 FROM stock_auditoria),   
            current_timestamp,
            'ALTA',   
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
            NEW.st_cantidad
        );
    -- Validamos si la operacion es de insercion
	ELSEIF TG_OP = 'UPDATE' THEN
    -- Registramos el valor anterior a que se actualice
    INSERT INTO stock_auditoria(
        staud_codigo,
        staud_fecha,
        staud_procedimiento,
        it_codigo,
        tipit_codigo,
        dep_codigo,
        suc_codigo,
        emp_codigo,
        st_cantidad
    )
    VALUES (
        (SELECT COALESCE(MAX(staud_codigo), 0) + 1 FROM stock_auditoria),   
        current_timestamp,
        'MODIFICACION_ANTERIOR',   
        OLD.it_codigo,
        OLD.tipit_codigo,
        OLD.dep_codigo,
        OLD.suc_codigo,
        OLD.emp_codigo,
        OLD.st_cantidad
    );
    -- Registramos el nuevo valor actualizado
    INSERT INTO stock_auditoria(
        staud_codigo,
        staud_fecha,
        staud_procedimiento,
        it_codigo,
        tipit_codigo,
        dep_codigo,
        suc_codigo,
        emp_codigo,
        st_cantidad
    )
    VALUES (
        (SELECT COALESCE(MAX(staud_codigo), 0) + 1 FROM stock_auditoria),   
        current_timestamp,
        'MODIFICACION_NUEVO',   
        NEW.it_codigo,
        NEW.tipit_codigo,
        NEW.dep_codigo,
        NEW.suc_codigo,
        NEW.emp_codigo,
        NEW.st_cantidad
    );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
        INSERT INTO stock_auditoria(
            staud_codigo,
            staud_fecha,
            staud_procedimiento,
            it_codigo,
            tipit_codigo,
            dep_codigo,
			suc_codigo,
			emp_codigo,
			st_cantidad
        )
		VALUES (
            (SELECT COALESCE(MAX(staud_codigo), 0) + 1 FROM stock_auditoria),   
            current_timestamp,
            'BAJA',   
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
            OLD.st_cantidad
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_eliminacion_stock
CREATE TRIGGER t_insercion_actualizacion_eliminacion_stock
AFTER INSERT OR UPDATE OR DELETE ON stock
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_eliminacion_stock();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_pedido_venta_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select pvc.usu_codigo from pedido_venta_cab pvc where pvc.peven_codigo=NEW.peven_codigo);
		usuLogin := (select u.usu_login from pedido_venta_cab pvc join usuario u on u.usu_codigo=pvc.usu_codigo where pvc.peven_codigo=NEW.peven_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO pedido_venta_det_auditoria (
            pevendetaud_codigo,
            usu_codigo,
            usu_login,
            pevendetaud_fecha,
            pevendetaud_procedimiento,
            peven_codigo,
            it_codigo,
            tipit_codigo,
            pevendet_cantidad,
            pevendet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(pevendetaud_codigo), 0) + 1 FROM pedido_venta_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.peven_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.pevendet_cantidad,
            NEW.pevendet_precio
        );

    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select pvc.usu_codigo from pedido_venta_cab pvc where pvc.peven_codigo=OLD.peven_codigo);
		usuLogin := (select u.usu_login from pedido_venta_cab pvc join usuario u on u.usu_codigo=pvc.usu_codigo where pvc.peven_codigo=OLD.peven_codigo);
		--Insertamos la auditoria de la nueva eliminacion	
        INSERT INTO pedido_venta_det_auditoria (
            pevendetaud_codigo,
            usu_codigo,
            usu_login,
            pevendetaud_fecha,
            pevendetaud_procedimiento,
            peven_codigo,
            it_codigo,
            tipit_codigo,
            pevendet_cantidad,
            pevendet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(pevendetaud_codigo), 0) + 1 FROM pedido_venta_det_auditoria), -- Generar nuevo código
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.peven_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.pevendet_cantidad,
            OLD.pevendet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_pedido_venta_det()
CREATE TRIGGER t_insercion_eliminacion_pedido_venta_det
AFTER INSERT OR DELETE ON pedido_venta_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_pedido_venta_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_pedido_venta_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select pvc.usu_codigo from pedido_venta_cab pvc where pvc.peven_codigo=NEW.peven_codigo);
		usuLogin := (select u.usu_login from pedido_venta_cab pvc join usuario u on u.usu_codigo=pvc.usu_codigo where pvc.peven_codigo=NEW.peven_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO pedido_venta_det_auditoria (
            pevendetaud_codigo,
            usu_codigo,
            usu_login,
            pevendetaud_fecha,
            pevendetaud_procedimiento,
            peven_codigo,
            it_codigo,
            tipit_codigo,
            pevendet_cantidad,
            pevendet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(pevendetaud_codigo), 0) + 1 FROM pedido_venta_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.peven_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.pevendet_cantidad,
            NEW.pevendet_precio
        );

    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select pvc.usu_codigo from pedido_venta_cab pvc where pvc.peven_codigo=OLD.peven_codigo);
		usuLogin := (select u.usu_login from pedido_venta_cab pvc join usuario u on u.usu_codigo=pvc.usu_codigo where pvc.peven_codigo=OLD.peven_codigo);
		--Insertamos la auditoria de la nueva eliminacion	
        INSERT INTO pedido_venta_det_auditoria (
            pevendetaud_codigo,
            usu_codigo,
            usu_login,
            pevendetaud_fecha,
            pevendetaud_procedimiento,
            peven_codigo,
            it_codigo,
            tipit_codigo,
            pevendet_cantidad,
            pevendet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(pevendetaud_codigo), 0) + 1 FROM pedido_venta_det_auditoria), -- Generar nuevo código
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.peven_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.pevendet_cantidad,
            OLD.pevendet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_pedido_venta_det()
CREATE TRIGGER t_insercion_eliminacion_pedido_venta_det
AFTER INSERT OR DELETE ON pedido_venta_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_pedido_venta_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_presupuesto_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select pc.usu_codigo from presupuesto_cab pc where pc.pres_codigo=NEW.pres_codigo);
		usuLogin := (select u.usu_login from presupuesto_cab pc join usuario u on u.usu_codigo=pc.usu_codigo where pc.pres_codigo=NEW.pres_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO presupuesto_det_auditoria (
            presdetaud_codigo,
            usu_codigo,
            usu_login,
            presdetaud_fecha,
            presdetaud_procedimiento,
            pres_codigo,
            it_codigo,
            tipit_codigo,
            presdet_cantidad,
            presdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(presdetaud_codigo), 0) + 1 FROM presupuesto_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.pres_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.presdet_cantidad,
            NEW.presdet_precio
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select pc.usu_codigo from presupuesto_cab pc where pc.pres_codigo=OLD.pres_codigo);
		usuLogin := (select u.usu_login from presupuesto_cab pc join usuario u on u.usu_codigo=pc.usu_codigo where pc.pres_codigo=OLD.pres_codigo);
		--Insertamos la auditoria de la nueva eliminacion	
        INSERT INTO presupuesto_det_auditoria (
            presdetaud_codigo,
            usu_codigo,
            usu_login,
            presdetaud_fecha,
            presdetaud_procedimiento,
            pres_codigo,
            it_codigo,
            tipit_codigo,
            presdet_cantidad,
            presdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(presdetaud_codigo), 0) + 1 FROM presupuesto_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.pres_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.presdet_cantidad,
            OLD.presdet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_presupuesto_det()
CREATE TRIGGER t_insercion_eliminacion_presupuesto_det
AFTER INSERT OR DELETE ON presupuesto_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_presupuesto_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_orden_produccion_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select opc.usu_codigo from orden_produccion_cab opc where opc.orpro_codigo=NEW.orpro_codigo);
		usuLogin := (select u.usu_login from orden_produccion_cab opc join usuario u on u.usu_codigo=opc.usu_codigo where opc.orpro_codigo=NEW.orpro_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO orden_produccion_det_auditoria (
            orprodetaud_codigo,
            usu_codigo,
            usu_login,
            orprodetaud_fecha,
            orprodetaud_procedimiento,
            orpro_codigo,
            it_codigo,
            tipit_codigo,
            orprodet_especificacion,
            orprodet_cantidad,
			dep_codigo,
			suc_codigo,
			emp_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(orprodetaud_codigo), 0) + 1 FROM orden_produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.orpro_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.orprodet_especificacion,
            NEW.orprodet_cantidad,
			NEW.dep_codigo,
		    NEW.suc_codigo,
			NEW.emp_codigo
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select opc.usu_codigo from orden_produccion_cab opc where opc.orpro_codigo=OLD.orpro_codigo);
		usuLogin := (select u.usu_login from orden_produccion_cab opc join usuario u on u.usu_codigo=opc.usu_codigo where opc.orpro_codigo=OLD.orpro_codigo);
		--Insertamos la auditoria de la nueva eliminacion	
         INSERT INTO orden_produccion_det_auditoria (
            orprodetaud_codigo,
            usu_codigo,
            usu_login,
            orprodetaud_fecha,
            orprodetaud_procedimiento,
            orpro_codigo,
            it_codigo,
            tipit_codigo,
            orprodet_especificacion,
            orprodet_cantidad,
			dep_codigo,
			suc_codigo,
			emp_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(orprodetaud_codigo), 0) + 1 FROM orden_produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.orpro_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.orprodet_especificacion,
            OLD.orprodet_cantidad,
			OLD.dep_codigo,
		    OLD.suc_codigo,
			OLD.emp_codigo
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_orden_produccion_det()
CREATE TRIGGER t_insercion_eliminacion_orden_produccion_det
AFTER INSERT OR DELETE ON orden_produccion_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_orden_produccion_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_componente_produccion_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select cpc.usu_codigo from componente_produccion_cab cpc where cpc.compro_codigo=NEW.compro_codigo);
		usuLogin := (select u.usu_login from componente_produccion_cab cpc join usuario u on u.usu_codigo=cpc.usu_codigo where cpc.compro_codigo=NEW.compro_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO componente_produccion_det_auditoria (
            comprodetaud_codigo,
            usu_codigo,
            usu_login,
            comprodetaud_fecha,
            comprodetaud_procedimiento,
            compro_codigo,
            it_codigo,
            tipit_codigo,
            comprodet_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(comprodetaud_codigo), 0) + 1 FROM componente_produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.compro_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.comprodet_cantidad
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select cpc.usu_codigo from componente_produccion_cab cpc where cpc.compro_codigo=OLD.compro_codigo);
		usuLogin := (select u.usu_login from componente_produccion_cab cpc join usuario u on u.usu_codigo=cpc.usu_codigo where cpc.compro_codigo=OLD.compro_codigo);
		--Insertamos la auditoria de la nueva eliminacion	
         INSERT INTO componente_produccion_det_auditoria (
            comprodetaud_codigo,
            usu_codigo,
            usu_login,
            comprodetaud_fecha,
            comprodetaud_procedimiento,
            compro_codigo,
            it_codigo,
            tipit_codigo,
            comprodet_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(comprodetaud_codigo), 0) + 1 FROM componente_produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.compro_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.comprodet_cantidad
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_componente_produccion_det()
CREATE TRIGGER t_insercion_eliminacion_componente_produccion_det
AFTER INSERT OR DELETE ON componente_produccion_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_componente_produccion_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_orden_produccion_det2()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select opc.usu_codigo from orden_produccion_cab opc where opc.orpro_codigo=NEW.orpro_codigo);
		usuLogin := (select u.usu_login from orden_produccion_cab opc join usuario u on u.usu_codigo=opc.usu_codigo where opc.orpro_codigo=NEW.orpro_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO orden_produccion_det2_auditoria (
            orprodet2aud_codigo,
            usu_codigo,
            usu_login,
            orprodet2aud_fecha,
            orprodet2aud_procedimiento,
            orpro_codigo,
            compro_codigo,
            it_codigo,
            tipit_codigo,
            orprodet2_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(orprodet2aud_codigo), 0) + 1 FROM orden_produccion_det2_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.orpro_codigo,
            NEW.compro_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.orprodet2_cantidad
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select opc.usu_codigo from orden_produccion_cab opc where opc.orpro_codigo=OLD.orpro_codigo);
		usuLogin := (select u.usu_login from orden_produccion_cab opc join usuario u on u.usu_codigo=opc.usu_codigo where opc.orpro_codigo=OLD.orpro_codigo);
		--Insertamos la auditoria de la nueva eliminacion	
         INSERT INTO orden_produccion_det2_auditoria (
            orprodet2aud_codigo,
            usu_codigo,
            usu_login,
            orprodet2aud_fecha,
            orprodet2aud_procedimiento,
            orpro_codigo,
            compro_codigo,
            it_codigo,
            tipit_codigo,
            orprodet2_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(orprodet2aud_codigo), 0) + 1 FROM orden_produccion_det2_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.orpro_codigo,
            OLD.compro_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.orprodet2_cantidad
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_orden_produccion_det2()
CREATE TRIGGER t_insercion_eliminacion_orden_produccion_det2
AFTER INSERT OR DELETE ON orden_produccion_det2
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_orden_produccion_det2();

CREATE OR REPLACE FUNCTION spt_insercion_modificacion_eliminacion_produccion_det_auditoria()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
		usuCodigo2 integer;
		usuLogin2 varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo := (select pc.usu_codigo from produccion_cab pc where pc.prod_codigo=NEW.prod_codigo);
		usuLogin := (select u.usu_login from produccion_cab pc join usuario u on u.usu_codigo=pc.usu_codigo where pc.prod_codigo=NEW.prod_codigo);
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO produccion_det_auditoria (
            prodetaud_codigo,
            usu_codigo,
            usu_login,
            prodetaud_fecha,
            prodetaud_procedimiento,
			prod_codigo,
            it_codigo,
            tipit_codigo,
            prodet_cantidad,
			prodet_fechainicio,
			prodet_fechafinal,
			prodet_observacion,
			prodet_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(prodetaud_codigo), 0) + 1 FROM produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.prod_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.prodet_cantidad,
			NEW.prodet_fechainicio,
			NEW.prodet_fechafinal,
			NEW.prodet_observacion,
			NEW.prodet_estado
        );
	-- Validamos si la operacion es de modificacion
	ELSEIF TG_OP = 'UPDATE' THEN
		 --Sacamos el codigo y nombre de usuario del usuario que inserto el valor viejo
		 usuCodigo := (select pc.usu_codigo from produccion_cab pc where pc.prod_codigo=OLD.prod_codigo);
		 usuLogin := (select u.usu_login from produccion_cab pc join usuario u on u.usu_codigo=pc.usu_codigo where pc.prod_codigo=OLD.prod_codigo);
	     --Insertamos en la tabla de auditoria el valor anterior del registro modificado
         INSERT INTO produccion_det_auditoria (
            prodetaud_codigo,
            usu_codigo,
            usu_login,
            prodetaud_fecha,
            prodetaud_procedimiento,
			prod_codigo,
            it_codigo,
            tipit_codigo,
            prodet_cantidad,
			prodet_fechainicio,
			prodet_fechafinal,
			prodet_observacion,
			prodet_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(prodetaud_codigo), 0) + 1 FROM produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'MODIFICACION_ANTERIOR',       
            OLD.prod_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.prodet_cantidad,
			OLD.prodet_fechainicio,
			OLD.prodet_fechafinal,
			OLD.prodet_observacion,
			OLD.prodet_estado
        );
	    --Insertamos en la tabla de auditoria el valor nuevo del registro modificado
		--Sacamos el codigo y nombre de usuario del usuario que inserto el valor nuevo
		 usuCodigo2 := (select distinct ep.usu_codigo from etapa_produccion ep where ep.prod_codigo=NEW.prod_codigo and ep.it_codigo=NEW.it_codigo);
		 usuLogin2 := (select distinct u.usu_login from etapa_produccion ep join usuario u on u.usu_codigo=ep.usu_codigo where ep.prod_codigo=NEW.prod_codigo and ep.it_codigo=NEW.it_codigo);
	    INSERT INTO produccion_det_auditoria (
            prodetaud_codigo,
            usu_codigo,
            usu_login,
            prodetaud_fecha,
            prodetaud_procedimiento,
			prod_codigo,
            it_codigo,
            tipit_codigo,
            prodet_cantidad,
			prodet_fechainicio,
			prodet_fechafinal,
			prodet_observacion,
			prodet_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(prodetaud_codigo), 0) + 1 FROM produccion_det_auditoria), 
            usuCodigo2, 
            usuLogin2,  
            current_timestamp,
            'MODIFICACION_NUEVO',       
            NEW.prod_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.prodet_cantidad,
			NEW.prodet_fechainicio,
			NEW.prodet_fechafinal,
			NEW.prodet_observacion,
			NEW.prodet_estado
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		 --Sacamos el codigo y nombre de usuario
		 usuCodigo := (select pc.usu_codigo from produccion_cab pc where pc.prod_codigo=OLD.prod_codigo);
		 usuLogin := (select u.usu_login from produccion_cab pc join usuario u on u.usu_codigo=pc.usu_codigo where pc.prod_codigo=OLD.prod_codigo);
		 --Insertamos la auditoria de la nueva eliminacion	
         INSERT INTO produccion_det_auditoria (
            prodetaud_codigo,
            usu_codigo,
            usu_login,
            prodetaud_fecha,
            prodetaud_procedimiento,
			prod_codigo,
            it_codigo,
            tipit_codigo,
            prodet_cantidad,
			prodet_fechainicio,
			prodet_fechafinal,
			prodet_observacion,
			prodet_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(prodetaud_codigo), 0) + 1 FROM produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.prod_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.prodet_cantidad,
			OLD.prodet_fechainicio,
			OLD.prodet_fechafinal,
			OLD.prodet_observacion,
			OLD.prodet_estado
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

select distinct ep.usu_codigo from etapa_produccion ep where ep.prod_codigo=1 limit 1;
select distinct ep.usu_codigo from etapa_produccion ep where ep.prod_codigo=1 and ep.it_codigo=2;

--Creamos el trigger que ejecutara la funcion spt_insercion_modificacion_eliminacion_produccion_det_auditoria()
CREATE TRIGGER t_insercion_modificacion_eliminacion_produccion_det
AFTER INSERT OR delete or UPDATE ON produccion_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_modificacion_eliminacion_produccion_det_auditoria();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_etapa_produccion()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Insertamos la auditoria de la nueva insercion
        INSERT INTO etapa_produccion_auditoria (
            etproaud_codigo,
            etproaud_fecha,
            etproaud_procedimiento,
            prod_codigo,
            it_codigo,
            tipit_codigo,
            tipet_codigo,
            etpro_fecha,
            usu_codigo,
			suc_codigo,
			emp_codigo,
			maq_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(etproaud_codigo), 0) + 1 FROM etapa_produccion_auditoria), 
            current_timestamp,
            'ALTA',       
            NEW.prod_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
            NEW.tipet_codigo,
			NEW.etpro_fecha,
			NEW.usu_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.maq_codigo
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Insertamos la auditoria de la nueva eliminacion	
         INSERT INTO etapa_produccion_auditoria (
            etproaud_codigo,
            etproaud_fecha,
            etproaud_procedimiento,
            prod_codigo,
            it_codigo,
            tipit_codigo,
            tipet_codigo,
            etpro_fecha,
            usu_codigo,
			suc_codigo,
			emp_codigo,
			maq_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(etproaud_codigo), 0) + 1 FROM etapa_produccion_auditoria), 
            current_timestamp,
            'BAJA',       
            OLD.prod_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
            OLD.tipet_codigo,
			OLD.etpro_fecha,
			OLD.usu_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
			OLD.maq_codigo
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_etapa_produccion()
CREATE TRIGGER t_insercion_eliminacion_etapa_produccion
AFTER INSERT OR DELETE ON etapa_produccion
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_etapa_produccion();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_produccion_terminada_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ptc.usu_codigo from produccion_terminada_cab ptc where ptc.proter_codigo=NEW.proter_codigo);
		usuLogin = (select u.usu_login from produccion_terminada_cab ptc join usuario u on u.usu_codigo=ptc.usu_codigo where ptc.proter_codigo=NEW.proter_codigo);
        INSERT INTO produccion_terminada_det_auditoria(
            proterdetaud_codigo,
            usu_codigo,
            usu_login,
            proterdetaud_fecha,
            proterdetaud_procedimiento,
            proter_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            proterdet_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(proterdetaud_codigo), 0) + 1 FROM produccion_terminada_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.proter_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
            NEW.proterdet_cantidad
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ptc.usu_codigo from produccion_terminada_cab ptc where ptc.proter_codigo=OLD.proter_codigo);
		usuLogin = (select u.usu_login from produccion_terminada_cab ptc join usuario u on u.usu_codigo=ptc.usu_codigo where ptc.proter_codigo=OLD.proter_codigo);
        INSERT INTO produccion_terminada_det_auditoria(
            proterdetaud_codigo,
            usu_codigo,
            usu_login,
            proterdetaud_fecha,
            proterdetaud_procedimiento,
            proter_codigo,
            it_codigo,
            tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
            proterdet_cantidad
        )
        VALUES (
            (SELECT COALESCE(MAX(proterdetaud_codigo), 0) + 1 FROM produccion_terminada_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',   
            OLD.proter_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
            OLD.proterdet_cantidad
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_produccion_terminada_det
CREATE TRIGGER t_insercion_eliminacion_produccion_terminada_det
AFTER INSERT OR DELETE ON produccion_terminada_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_produccion_terminada_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_control_calidad_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ccc.usu_codigo from control_calidad_cab ccc where ccc.conca_codigo=NEW.conca_codigo);
		usuLogin = (select u.usu_login from control_calidad_cab ccc join usuario u on u.usu_codigo=ccc.usu_codigo where ccc.conca_codigo=NEW.conca_codigo);
        INSERT INTO control_calidad_det_auditoria(
            concadetaud_codigo,
            usu_codigo,
            usu_login,
            concadetaud_fecha,
            concadetaud_procedimiento,
            conca_codigo,
            it_codigo,
            tipit_codigo,
			pacoca_codigo,
			concadet_cantidadfallida
        )
        VALUES (
            (SELECT COALESCE(MAX(concadetaud_codigo), 0) + 1 FROM control_calidad_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.conca_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.pacoca_codigo,
			NEW.concadet_cantidadfallida
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select ccc.usu_codigo from control_calidad_cab ccc where ccc.conca_codigo=OLD.conca_codigo);
		usuLogin = (select u.usu_login from control_calidad_cab ccc join usuario u on u.usu_codigo=ccc.usu_codigo where ccc.conca_codigo=OLD.conca_codigo);
        INSERT INTO control_calidad_det_auditoria(
            concadetaud_codigo,
            usu_codigo,
            usu_login,
            concadetaud_fecha,
            concadetaud_procedimiento,
            conca_codigo,
            it_codigo,
            tipit_codigo,
			pacoca_codigo,
			concadet_cantidadfallida
        )
        VALUES (
            (SELECT COALESCE(MAX(concadetaud_codigo), 0) + 1 FROM control_calidad_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',   
            OLD.conca_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.pacoca_codigo,
			OLD.concadet_cantidadfallida
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_control_calidad_det
CREATE TRIGGER t_insercion_eliminacion_control_calidad_det
AFTER INSERT OR DELETE ON control_calidad_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_control_calidad_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_mermas_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select mc.usu_codigo from mermas_cab mc where mc.mer_codigo=NEW.mer_codigo);
		usuLogin = (select u.usu_login from mermas_cab mc join usuario u on u.usu_codigo=mc.usu_codigo where mc.mer_codigo=NEW.mer_codigo);
        INSERT INTO mermas_det_auditoria(
            merdetaud_codigo,
            usu_codigo,
            usu_login,
            merdetaud_fecha,
            merdetaud_procedimiento,
            mer_codigo,
            it_codigo,
            tipit_codigo,
			merdet_cantidad,
			merdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(merdetaud_codigo), 0) + 1 FROM mermas_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.mer_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.merdet_cantidad,
			NEW.merdet_precio
        );
    --Validamos si la operacion es una eliminacion
    ELSEIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select mc.usu_codigo from mermas_cab mc where mc.mer_codigo=OLD.mer_codigo);
		usuLogin = (select u.usu_login from mermas_cab mc join usuario u on u.usu_codigo=mc.usu_codigo where mc.mer_codigo=OLD.mer_codigo);
        INSERT INTO mermas_det_auditoria(
            merdetaud_codigo,
            usu_codigo,
            usu_login,
            merdetaud_fecha,
            merdetaud_procedimiento,
            mer_codigo,
            it_codigo,
            tipit_codigo,
			merdet_cantidad,
			merdet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(merdetaud_codigo), 0) + 1 FROM mermas_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',   
            OLD.mer_codigo,
            OLD.it_codigo,
            OLD.tipit_codigo,
			OLD.merdet_cantidad,
			OLD.merdet_precio
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_mermas_det
CREATE TRIGGER t_insercion_eliminacion_mermas_det
AFTER INSERT OR DELETE ON mermas_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_mermas_det();

CREATE OR REPLACE FUNCTION spt_insercion_costo_produccion_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cpc.usu_codigo from costo_produccion_cab cpc where cpc.copro_codigo=NEW.copro_codigo);
		usuLogin = (select u.usu_login from costo_produccion_cab cpc join usuario u on u.usu_codigo=cpc.usu_codigo where cpc.copro_codigo=NEW.copro_codigo);
        INSERT INTO costo_produccion_det_auditoria(
            coprodetaud_codigo,
            usu_codigo,
            usu_login,
            coprodetaud_fecha,
            coprodetaud_procedimiento,
            copro_codigo,
            it_codigo,
            tipit_codigo,
			coprodet_cantidad,
			coprodet_costo
        )
        VALUES (
            (SELECT COALESCE(MAX(coprodetaud_codigo), 0) + 1 FROM costo_produccion_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',   
            NEW.copro_codigo,
            NEW.it_codigo,
            NEW.tipit_codigo,
			NEW.coprodet_cantidad,
			NEW.coprodet_costo
        );
    END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_costo_produccion_det
CREATE TRIGGER t_insercion_costo_produccion_det
AFTER INSERT OR DELETE ON costo_produccion_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_costo_produccion_det();

CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_apertura_cierre()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO apertura_cierre_auditoria(
            apercieaud_codigo,
            apercieaud_fecha,
            apercieaud_procedimiento,
            apercie_codigo,
            suc_codigo,
            emp_codigo,
			caj_codigo,
			usu_codigo,
			apercie_fechahoraapertura,
			apercie_fechahoracierre,
			apercie_montoapertura,
			apercie_montocierre,
			apercie_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(apercieaud_codigo), 0) + 1 FROM apertura_cierre_auditoria),   
            current_timestamp,
            'ALTA',   
            NEW.apercie_codigo,
            NEW.suc_codigo,
            NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.apercie_fechahoraapertura,
			NEW.apercie_fechahoracierre,
			NEW.apercie_montoapertura,
			NEW.apercie_montocierre,
			NEW.apercie_estado
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    -- Registramos el valor anterior a que se actualice
    INSERT INTO apertura_cierre_auditoria(
            apercieaud_codigo,
            apercieaud_fecha,
            apercieaud_procedimiento,
            apercie_codigo,
            suc_codigo,
            emp_codigo,
			caj_codigo,
			usu_codigo,
			apercie_fechahoraapertura,
			apercie_fechahoracierre,
			apercie_montoapertura,
			apercie_montocierre,
			apercie_estado
    )
    VALUES (
            (SELECT COALESCE(MAX(apercieaud_codigo), 0) + 1 FROM apertura_cierre_auditoria),   
            current_timestamp,
            'MODIFICACION_ANTERIOR',   
            OLD.apercie_codigo,
            OLD.suc_codigo,
            OLD.emp_codigo,
			OLD.caj_codigo,
			OLD.usu_codigo,
			OLD.apercie_fechahoraapertura,
			OLD.apercie_fechahoracierre,
			OLD.apercie_montoapertura,
			OLD.apercie_montocierre,
			OLD.apercie_estado
      );
    -- Registramos el nuevo valor actualizado
    INSERT INTO apertura_cierre_auditoria(
            apercieaud_codigo,
            apercieaud_fecha,
            apercieaud_procedimiento,
            apercie_codigo,
            suc_codigo,
            emp_codigo,
			caj_codigo,
			usu_codigo,
			apercie_fechahoraapertura,
			apercie_fechahoracierre,
			apercie_montoapertura,
			apercie_montocierre,
			apercie_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(apercieaud_codigo), 0) + 1 FROM apertura_cierre_auditoria),   
            current_timestamp,
            'MODIFICACION_NUEVO',   
            NEW.apercie_codigo,
            NEW.suc_codigo,
            NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.apercie_fechahoraapertura,
			NEW.apercie_fechahoracierre,
			NEW.apercie_montoapertura,
			NEW.apercie_montocierre,
			NEW.apercie_estado
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_apertura_cierre
CREATE TRIGGER t_insercion_actualizacion_apertura_cierre
AFTER INSERT OR UPDATE ON apertura_cierre
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_apertura_cierre();

CREATE OR REPLACE FUNCTION spt_insercion_recaudacion_depositar()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO recaudacion_depositar_auditoria(
            recaud_codigo,
            recaud_fecha,
            recaud_procedimiento,
            rec_codigo,
            apercie_codigo,
            suc_codigo,
			emp_codigo,
			caj_codigo,
			usu_codigo,
			rec_montoefectivo,
			rec_montocheque,
			rec_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(recaud_codigo), 0) + 1 FROM recaudacion_depositar_auditoria),   
            current_timestamp,
            'ALTA',   
            NEW.rec_codigo,
            NEW.apercie_codigo,
            NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.rec_montoefectivo,
			NEW.rec_montocheque,
			NEW.rec_estado
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_recaudacion_depositar
CREATE TRIGGER t_insercion_recaudacion_depositar
AFTER INSERT ON recaudacion_depositar
FOR EACH ROW EXECUTE FUNCTION spt_insercion_recaudacion_depositar();

CREATE OR REPLACE FUNCTION spt_insercion_arqueo_control_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO arqueo_control_auditoria(
            arcoaud_codigo,
            arcoaud_fecha,
            arcoaud_procedimiento,
            arco_codigo,
            apercie_codigo,
            suc_codigo,
			emp_codigo,
			caj_codigo,
			usu_codigo,
			arco_observacion,
			arco_fecha,
			func_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(arcoaud_codigo), 0) + 1 FROM arqueo_control_auditoria),   
            current_timestamp,
            'ALTA',   
            NEW.arco_codigo,
            NEW.apercie_codigo,
            NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.arco_observacion,
			NEW.arco_fecha,
			NEW.func_codigo
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_arqueo_control_auditoria
CREATE TRIGGER t_insercion_arqueo_control
AFTER INSERT ON arqueo_control
FOR EACH ROW EXECUTE FUNCTION spt_insercion_arqueo_control_auditoria();

CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_factura_venta()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO factura_venta_auditoria(
            facvenaud_codigo,
            facvenaud_fecha,
            facvenaud_procedimiento,
            suc_codigo,
            emp_codigo,
            caj_codigo,
			facven_numero
        )
        VALUES (
            (SELECT COALESCE(MAX(facvenaud_codigo), 0) + 1 FROM factura_venta_auditoria),   
            current_timestamp,
            'ALTA',   
            NEW.suc_codigo,
            NEW.emp_codigo,
            NEW.caj_codigo,
			NEW.facven_numero
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    -- Registramos el valor anterior a que se actualice
    	INSERT INTO factura_venta_auditoria(
            facvenaud_codigo,
            facvenaud_fecha,
            facvenaud_procedimiento,
            suc_codigo,
            emp_codigo,
            caj_codigo,
			facven_numero
        )
        VALUES (
            (SELECT COALESCE(MAX(facvenaud_codigo), 0) + 1 FROM factura_venta_auditoria),   
            current_timestamp,
            'MODIFICACION_ANTERIOR',   
            OLD.suc_codigo,
            OLD.emp_codigo,
            OLD.caj_codigo,
			OLD.facven_numero
        );
    -- Registramos el nuevo valor actualizado
   		INSERT INTO factura_venta_auditoria(
            facvenaud_codigo,
            facvenaud_fecha,
            facvenaud_procedimiento,
            suc_codigo,
            emp_codigo,
            caj_codigo,
			facven_numero
        )
        VALUES (
            (SELECT COALESCE(MAX(facvenaud_codigo), 0) + 1 FROM factura_venta_auditoria),   
            current_timestamp,
            'MODIFICACION_NUEVO',   
            NEW.suc_codigo,
            NEW.emp_codigo,
            NEW.caj_codigo,
			NEW.facven_numero
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_factura_venta
CREATE TRIGGER t_insercion_actualizacion_factura_venta
AFTER INSERT OR UPDATE ON factura_venta
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_factura_venta();

select usu_codigo from venta_cab where ven_codigo=1;

CREATE OR REPLACE FUNCTION spt_insercion_pedido_venta()
RETURNS TRIGGER AS $$
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select vc.usu_codigo from venta_cab vc where vc.ven_codigo=NEW.ven_codigo);
		usuLogin = (select u.usu_login from venta_cab vc join usuario u on u.usu_codigo=vc.usu_codigo where vc.ven_codigo=NEW.ven_codigo);
        INSERT INTO pedido_venta_auditoria(
            pedvenaud_codigo,
            usu_codigo,
            usu_login,
            pedvenaud_fecha,
            pedvenaud_procedimiento,
            ven_codigo,
			peven_codigo,
			pedven_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(pedvenaud_codigo), 0) + 1 FROM pedido_venta_auditoria),   
			usuCodigo,
			usuLogin,
            current_timestamp,
            'ALTA',   
            NEW.ven_codigo,
            NEW.peven_codigo,
            NEW.pedven_codigo
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_pedido_venta
CREATE TRIGGER t_insercion_pedido_venta
AFTER INSERT ON pedido_venta
FOR EACH ROW EXECUTE FUNCTION spt_insercion_pedido_venta();

CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_libro_venta()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO apertura_cierre_auditoria(
            apercieaud_codigo,
            apercieaud_fecha,
            apercieaud_procedimiento,
            apercie_codigo,
            suc_codigo,
            emp_codigo,
			caj_codigo,
			usu_codigo,
			apercie_fechahoraapertura,
			apercie_fechahoracierre,
			apercie_montoapertura,
			apercie_montocierre,
			apercie_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(apercieaud_codigo), 0) + 1 FROM apertura_cierre_auditoria),   
            current_timestamp,
            'ALTA',   
            NEW.apercie_codigo,
            NEW.suc_codigo,
            NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.apercie_fechahoraapertura,
			NEW.apercie_fechahoracierre,
			NEW.apercie_montoapertura,
			NEW.apercie_montocierre,
			NEW.apercie_estado
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    -- Registramos el valor anterior a que se actualice
    INSERT INTO apertura_cierre_auditoria(
            apercieaud_codigo,
            apercieaud_fecha,
            apercieaud_procedimiento,
            apercie_codigo,
            suc_codigo,
            emp_codigo,
			caj_codigo,
			usu_codigo,
			apercie_fechahoraapertura,
			apercie_fechahoracierre,
			apercie_montoapertura,
			apercie_montocierre,
			apercie_estado
    )
    VALUES (
            (SELECT COALESCE(MAX(apercieaud_codigo), 0) + 1 FROM apertura_cierre_auditoria),   
            current_timestamp,
            'MODIFICACION_ANTERIOR',   
            OLD.apercie_codigo,
            OLD.suc_codigo,
            OLD.emp_codigo,
			OLD.caj_codigo,
			OLD.usu_codigo,
			OLD.apercie_fechahoraapertura,
			OLD.apercie_fechahoracierre,
			OLD.apercie_montoapertura,
			OLD.apercie_montocierre,
			OLD.apercie_estado
      );
    -- Registramos el nuevo valor actualizado
    INSERT INTO apertura_cierre_auditoria(
            apercieaud_codigo,
            apercieaud_fecha,
            apercieaud_procedimiento,
            apercie_codigo,
            suc_codigo,
            emp_codigo,
			caj_codigo,
			usu_codigo,
			apercie_fechahoraapertura,
			apercie_fechahoracierre,
			apercie_montoapertura,
			apercie_montocierre,
			apercie_estado
        )
        VALUES (
            (SELECT COALESCE(MAX(apercieaud_codigo), 0) + 1 FROM apertura_cierre_auditoria),   
            current_timestamp,
            'MODIFICACION_NUEVO',   
            NEW.apercie_codigo,
            NEW.suc_codigo,
            NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.apercie_fechahoraapertura,
			NEW.apercie_fechahoracierre,
			NEW.apercie_montoapertura,
			NEW.apercie_montocierre,
			NEW.apercie_estado
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_apertura_cierre
CREATE TRIGGER t_insercion_actualizacion_apertura_cierre
AFTER INSERT OR UPDATE ON apertura_cierre
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_apertura_cierre();
select 
	usu_codigo,
	usu_login 
from usuario 
where usu_codigo=1
(select );


select nvc.usu_codigo from nota_venta_cab nvc where nvc.ven_codigo=NEW.ven_codigo;
select u.usu_login from nota_venta_cab nvc join usuario u on u.usu_codigo=nvc.usu_codigo where nvc.ven_codigo=NEW.ven_codigo;
select nvc.usu_codigo from nota_venta_cab nvc where nvc.ven_codigo=NEW.ven_codigo and nvc.tipco_codigo=NEW.tipco_codigo and nvc.notven_numeronota=NEW.libven_numcomprobante;


CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_libro_venta()
RETURNS TRIGGER AS $$
declare usuCodigo integer;
		usuLogin varchar;
BEGIN
	--Definimos el usuario que inserto o modifico el registro
	if NEW.tipco_codigo = 4 then
		-- Si el comprobante es una factura traemos el usuario de venta
		usuCodigo = (select vc.usu_codigo from venta_cab vc where vc.ven_codigo=NEW.ven_codigo);
		usuLogin = (select u.usu_login from venta_cab vc join usuario u on u.usu_codigo=vc.usu_codigo where vc.ven_codigo=NEW.ven_codigo);
	elseif NEW.tipco_codigo in (1, 2) then
		-- Si el comprobante es una nota traemos el usuario de nota venta
		usuCodigo = (select nvc.usu_codigo from nota_venta_cab nvc where nvc.ven_codigo=NEW.ven_codigo 
		and nvc.tipco_codigo=NEW.tipco_codigo and nvc.notven_numeronota=NEW.libven_numcomprobante);
		usuLogin = (select u.usu_login from nota_venta_cab nvc join usuario u on u.usu_codigo=nvc.usu_codigo where nvc.ven_codigo=NEW.ven_codigo
		and nvc.tipco_codigo=NEW.tipco_codigo and nvc.notven_numeronota=NEW.libven_numcomprobante);
	end if;
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO libro_venta_auditoria(
            libvenaud_codigo,
            usu_codigo,
            usu_login,
            libvenaud_fecha,
            libvenaud_procedimiento,
            libven_codigo,
			ven_codigo,
			libven_exenta,
			libven_iva5,
			libven_iva10,
			libven_fecha,
			libven_numcomprobante,
			libven_estado,
			tipco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(libvenaud_codigo), 0) + 1 FROM libro_venta_auditoria),   
			usuCodigo,
			usuLogin,
            current_timestamp,
            'ALTA',   
            NEW.libven_codigo,
			NEW.ven_codigo,
			NEW.libven_exenta,
			NEW.libven_iva5,
			NEW.libven_iva10,
			NEW.libven_fecha,
			NEW.libven_numcomprobante,
			NEW.libven_estado,
			NEW.tipco_codigo
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    	-- Registramos el nuevo valor actualizado
    	INSERT INTO libro_venta_auditoria(
            libvenaud_codigo,
            usu_codigo,
            usu_login,
            libvenaud_fecha,
            libvenaud_procedimiento,
            libven_codigo,
			ven_codigo,
			libven_exenta,
			libven_iva5,
			libven_iva10,
			libven_fecha,
			libven_numcomprobante,
			libven_estado,
			tipco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(libvenaud_codigo), 0) + 1 FROM libro_venta_auditoria),   
			usuCodigo,
			usuLogin,
            current_timestamp,
            'MODIFICACION',   
            NEW.libven_codigo,
			NEW.ven_codigo,
			NEW.libven_exenta,
			NEW.libven_iva5,
			NEW.libven_iva10,
			NEW.libven_fecha,
			NEW.libven_numcomprobante,
			NEW.libven_estado,
			NEW.tipco_codigo
        );
	END IF;
		RETURN NEW;--Este return no se utiliza
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_libro_venta
CREATE TRIGGER t_insercion_actualizacion_libro_venta
AFTER INSERT OR UPDATE ON libro_venta
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_libro_venta();

select * from cobro_cab cc join cobro_det cd on cd.cob_codigo=cc.cob_codigo where cd.ven_codigo=1;
select cc.usu_codigo from cobro_det cd 
join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
where cd.ven_codigo=1 order by cd.cob_codigo desc limit 1;

(select coalesce((select cc.cobr_cod from cobros_cab cc 
									join cobros_det cd on cd.cobr_cod = cc.cobr_cod 
								where cd.ven_cod = 1
								order by cd.cobr_cod desc 
								limit 1),0))
								
select 
	cda.usu_codigo 
from cobro_det_auditoria cda 
where cda.ven_codigo=1
order by cda.cob_codigo desc limit 1;

select nvc.usu_codigo from nota_venta_cab nvc where nvc.ven_codigo=NEW.ven_codigo 
		and nvc.tipco_codigo=NEW.tipco_codigo order by nvc.notven_codigo desc limit 1;

CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_cuenta_cobrar()
RETURNS TRIGGER AS $$
declare usuCodigo integer;
		usuLogin varchar;
		cobCodigo integer;
BEGIN
	--Definimos el usuario que inserto o modifico el registro
	if NEW.tipco_codigo = 4 then
		-- Si el comprobante es una factura traemos el usuario de venta
		usuCodigo = (select vc.usu_codigo from venta_cab vc where vc.ven_codigo=NEW.ven_codigo);
		usuLogin = (select u.usu_login from venta_cab vc join usuario u on u.usu_codigo=vc.usu_codigo where vc.ven_codigo=NEW.ven_codigo);
	elseif NEW.tipco_codigo in (1, 2) then
		-- Si el comprobante es una nota traemos el usuario de nota venta
		usuCodigo = (select nvc.usu_codigo from nota_venta_cab nvc where nvc.ven_codigo=NEW.ven_codigo 
		and nvc.tipco_codigo=NEW.tipco_codigo order by nvc.notven_codigo desc limit 1);
		usuLogin = (select nvc.usu_codigo from nota_venta_cab nvc where nvc.ven_codigo=NEW.ven_codigo 
		and nvc.tipco_codigo=NEW.tipco_codigo order by nvc.notven_codigo desc limit 1);
	elseif NEW.tipco_codigo = 5 then
		--Si el comprobante es un recibo traemos el usuario de las tablas de cobro
		--Traemos el codigo de cobro y lo guardamos dentro de una variable para su validacion, en caso de no existir devolvera 0
		cobCodigo := (select 
						coalesce(
							(select 
									cc.usu_codigo 
							from cobro_det cd 
					 		join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
					 		where cd.ven_codigo=NEW.ven_codigo 
							order by cd.cob_codigo desc limit 1), 0)
					);
		--Validamos la el codigo de cobro
		if cobCodigo = 0 then
			--Si es igual a 0 consultamos el usucodigo y usulogin de cobro detalle auditoria
			usuCodigo = (select 
							cda.usu_codigo 
						from cobro_det_auditoria cda 
						where cda.ven_codigo=NEW.ven_codigo
						order by cda.cob_codigo desc limit 1);
			usuLogin = (select 
							cda.usu_login 
						from cobro_det_auditoria cda 
						where cda.ven_codigo=NEW.ven_codigo
						order by cda.cob_codigo desc limit 1);
		else
			--Si es distinto de 0 consultamos el usucodigo y usulogin de cobro cabecera
			usuCodigo = (select cc.usu_codigo from cobro_det cd 
					 join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
					 where cd.ven_codigo=NEW.ven_codigo order by cd.cob_codigo desc limit 1);
			usuLogin = (select u.usu_login from cobro_det cd 
					 join cobro_cab cc on cc.cob_codigo=cd.cob_codigo 
					 join usuario u on u.usu_codigo=cc.usu_codigo
					 where cd.ven_codigo=NEW.ven_codigo order by cd.cob_codigo desc limit 1);
		end if;
	end if;
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO cuenta_cobrar_auditoria(
            cuencoaud_codigo,
            usu_codigo,
            usu_login,
            cuencoaud_fecha,
            cuencoaud_procedimiento,
			ven_codigo,
			cuenco_nrocuota,
			cuenco_monto,
			cuenco_saldo,
			cuenco_estado,
			tipco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cuencoaud_codigo), 0) + 1 FROM cuenta_cobrar_auditoria),   
			usuCodigo,
			usuLogin,
            current_timestamp,
            'ALTA',   
            NEW.ven_codigo,
			NEW.cuenco_nrocuota,
			NEW.cuenco_monto,
			NEW.cuenco_saldo,
			NEW.cuenco_estado,
			NEW.tipco_codigo
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    	-- Registramos el nuevo valor actualizado
    	INSERT INTO cuenta_cobrar_auditoria(
            cuencoaud_codigo,
            usu_codigo,
            usu_login,
            cuencoaud_fecha,
            cuencoaud_procedimiento,
			ven_codigo,
			cuenco_nrocuota,
			cuenco_monto,
			cuenco_saldo,
			cuenco_estado,
			tipco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cuencoaud_codigo), 0) + 1 FROM cuenta_cobrar_auditoria),   
			usuCodigo,
			usuLogin,
            current_timestamp,
            'MODIFICACION',   
            NEW.ven_codigo,
			NEW.cuenco_nrocuota,
			NEW.cuenco_monto,
			NEW.cuenco_saldo,
			NEW.cuenco_estado,
			NEW.tipco_codigo
        );
	END IF;
		RETURN NEW; --Este return no se utiliza
END
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_cuenta_cobrar
CREATE TRIGGER t_insercion_actualizacion_cuenta_cobrar
AFTER INSERT OR UPDATE ON cuenta_cobrar
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_cuenta_cobrar();

select cc.cuenco_saldo from cuenta_cobrar cc where cc.ven_codigo=1;

CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_venta_cab()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO venta_cab_auditoria(
            venaud_codigo,
			venaud_fecha,
			venaud_procedimiento,
			ven_codigo,
			ven_fecha,
			ven_numfactura,
			ven_tipofactura,
			ven_cuota,
			ven_montocuota,
			ven_interfecha,
			ven_estado,
			usu_codigo,
			cli_codigo,
			suc_codigo,
			emp_codigo,
			tipco_codigo,
			ven_timbrado
        )
        VALUES (
            (SELECT COALESCE(MAX(venaud_codigo), 0) + 1 FROM venta_cab_auditoria),   
			current_timestamp,
			'ALTA',
            NEW.ven_codigo,
			NEW.ven_fecha,
			NEW.ven_numfactura,
			NEW.ven_tipofactura,
			NEW.ven_cuota,
			NEW.ven_montocuota,
			NEW.ven_interfecha,
			NEW.ven_estado,
			NEW.usu_codigo,
			NEW.cli_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.tipco_codigo,
			NEW.ven_timbrado
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    	-- Registramos el nuevo valor actualizado
    	INSERT INTO venta_cab_auditoria(
            venaud_codigo,
			venaud_fecha,
			venaud_procedimiento,
			ven_codigo,
			ven_fecha,
			ven_numfactura,
			ven_tipofactura,
			ven_cuota,
			ven_montocuota,
			ven_interfecha,
			ven_estado,
			usu_codigo,
			cli_codigo,
			suc_codigo,
			emp_codigo,
			tipco_codigo,
			ven_timbrado
        )
        VALUES (
            (SELECT COALESCE(MAX(venaud_codigo), 0) + 1 FROM venta_cab_auditoria),   
			current_timestamp,
			(case NEW.ven_estado when 'ANULADO' then 'BAJA' else 'MODIFICACION' end),
            NEW.ven_codigo,
			NEW.ven_fecha,
			NEW.ven_numfactura,
			NEW.ven_tipofactura,
			NEW.ven_cuota,
			NEW.ven_montocuota,
			NEW.ven_interfecha,
			NEW.ven_estado,
			NEW.usu_codigo,
			NEW.cli_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.tipco_codigo,
			NEW.ven_timbrado
        );
	END IF;
		RETURN NEW; --Este return no se utiliza
END
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_venta_cab
CREATE TRIGGER t_insercion_actualizacion_venta_cab
AFTER INSERT OR UPDATE ON venta_cab
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_venta_cab();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_venta_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select vc.usu_codigo from venta_cab vc where vc.ven_codigo=NEW.ven_codigo);
		usuLogin = (select u.usu_login from venta_cab vc join usuario u on u.usu_codigo=vc.usu_codigo where vc.ven_codigo=NEW.ven_codigo);
        INSERT INTO venta_det_auditoria (
            vendetaud_codigo,
			usu_codigo,
			usu_login,
			vendetaud_fecha,
			vendetaud_procedimiento,
			ven_codigo,
			it_codigo,
			tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
			vendet_cantidad,
			vendet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(vendetaud_codigo), 0) + 1 FROM venta_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.ven_codigo,
			NEW.it_codigo,
			NEW.tipit_codigo,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.vendet_cantidad,
			NEW.vendet_precio
        );
    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select vc.usu_codigo from venta_cab vc where vc.ven_codigo=OLD.ven_codigo);
		usuLogin = (select u.usu_login from venta_cab vc join usuario u on u.usu_codigo=vc.usu_codigo where vc.ven_codigo=OLD.ven_codigo);
        INSERT INTO venta_det_auditoria (
            vendetaud_codigo,
			usu_codigo,
			usu_login,
			vendetaud_fecha,
			vendetaud_procedimiento,
			ven_codigo,
			it_codigo,
			tipit_codigo,
			dep_codigo,
			suc_codigo,
			emp_codigo,
			vendet_cantidad,
			vendet_precio
        )
        VALUES (
            (SELECT COALESCE(MAX(vendetaud_codigo), 0) + 1 FROM venta_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.ven_codigo,
			OLD.it_codigo,
			OLD.tipit_codigo,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
			OLD.vendet_cantidad,
			OLD.vendet_precio
        );
    END IF;
		RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_venta_det()
CREATE TRIGGER t_insercion_eliminacion_venta_det
AFTER INSERT OR DELETE ON venta_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_venta_det();

CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_cobro_cab()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO cobro_cab_auditoria(
            cobaud_codigo,
			cobaud_fecha,
			cobaud_procedimiento,
			cob_codigo,
			cob_fecha,
			cob_estado,
			apercie_codigo,
			suc_codigo,
			emp_codigo,
			caj_codigo,
			usu_codigo,
			tipco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cobaud_codigo), 0) + 1 FROM cobro_cab_auditoria),   
			current_timestamp,
			'ALTA',
            NEW.cob_codigo,
			NEW.cob_fecha,
			NEW.cob_estado,
			NEW.apercie_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.tipco_codigo
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    	-- Registramos el nuevo valor actualizado
    	INSERT INTO cobro_cab_auditoria(
            cobaud_codigo,
			cobaud_fecha,
			cobaud_procedimiento,
			cob_codigo,
			cob_fecha,
			cob_estado,
			apercie_codigo,
			suc_codigo,
			emp_codigo,
			caj_codigo,
			usu_codigo,
			tipco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cobaud_codigo), 0) + 1 FROM cobro_cab_auditoria),   
			current_timestamp,
			'BAJA',
            NEW.cob_codigo,
			NEW.cob_fecha,
			NEW.cob_estado,
			NEW.apercie_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.caj_codigo,
			NEW.usu_codigo,
			NEW.tipco_codigo
        );
	END IF;
		RETURN NEW; --Este return no se utiliza
END
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_cobro_cab
CREATE TRIGGER t_insercion_actualizacion_cobro_cab
AFTER INSERT OR UPDATE ON cobro_cab
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_cobro_cab();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_cobro_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from cobro_cab cc where cc.cob_codigo=NEW.cob_codigo);
		usuLogin = (select u.usu_login from cobro_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.cob_codigo=NEW.cob_codigo);
        INSERT INTO cobro_det_auditoria(
            cobdetaud_codigo,
			usu_codigo,
			usu_login,
			cobdetaud_fecha,
			cobdetaud_procedimiento,
			cobdet_codigo,
			cob_codigo,
			ven_codigo,
			cobdet_monto,
			cobdet_numerocuota,
			forco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cobdetaud_codigo), 0) + 1 FROM cobro_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.cobdet_codigo,
			NEW.cob_codigo,
			NEW.ven_codigo,
			NEW.cobdet_monto,
			NEW.cobdet_numerocuota,
			NEW.forco_codigo
        );
    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from cobro_cab cc where cc.cob_codigo=OLD.cob_codigo);
		usuLogin = (select u.usu_login from cobro_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.cob_codigo=OLD.cob_codigo);
        INSERT INTO cobro_det_auditoria(
            cobdetaud_codigo,
			usu_codigo,
			usu_login,
			cobdetaud_fecha,
			cobdetaud_procedimiento,
			cobdet_codigo,
			cob_codigo,
			ven_codigo,
			cobdet_monto,
			cobdet_numerocuota,
			forco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cobdetaud_codigo), 0) + 1 FROM cobro_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.cobdet_codigo,
			OLD.cob_codigo,
			OLD.ven_codigo,
			OLD.cobdet_monto,
			OLD.cobdet_numerocuota,
			OLD.forco_codigo
        );
    END IF;
		RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_cobro_det()
CREATE TRIGGER t_insercion_eliminacion_cobro_det
AFTER INSERT OR DELETE ON cobro_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_cobro_det();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_cobro_tarjeta()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from cobro_cab cc where cc.cob_codigo=NEW.cob_codigo);
		usuLogin = (select u.usu_login from cobro_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.cob_codigo=NEW.cob_codigo);
        INSERT INTO cobro_tarjeta_auditoria(
            cobtaaud_codigo,
			usu_codigo,
			usu_login,
			cobtaaud_fecha,
			cobtaaud_procedimiento,
			cobta_codigo,
			cobta_numero,
			cobta_monto,
			cobta_tipotarjeta,
			entad_codigo,
			ent_codigo,
			marta_codigo,
			cobdet_codigo,
			cob_codigo,
			ven_codigo,
			cobta_transaccion,
			redpa_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cobtaaud_codigo), 0) + 1 FROM cobro_tarjeta_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.cobta_codigo,
			NEW.cobta_numero,
			NEW.cobta_monto,
			NEW.cobta_tipotarjeta,
			NEW.entad_codigo,
			NEW.ent_codigo,
			NEW.marta_codigo,
			NEW.cobdet_codigo,
			NEW.cob_codigo,
			NEW.ven_codigo,
			NEW.cobta_transaccion,
			NEW.redpa_codigo
        );
    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from cobro_cab cc where cc.cob_codigo=OLD.cob_codigo);
		usuLogin = (select u.usu_login from cobro_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.cob_codigo=OLD.cob_codigo);
        INSERT INTO cobro_tarjeta_auditoria(
            cobtaaud_codigo,
			usu_codigo,
			usu_login,
			cobtaaud_fecha,
			cobtaaud_procedimiento,
			cobta_codigo,
			cobta_numero,
			cobta_monto,
			cobta_tipotarjeta,
			entad_codigo,
			ent_codigo,
			marta_codigo,
			cobdet_codigo,
			cob_codigo,
			ven_codigo,
			cobta_transaccion,
			redpa_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cobtaaud_codigo), 0) + 1 FROM cobro_tarjeta_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            OLD.cobta_codigo,
			OLD.cobta_numero,
			OLD.cobta_monto,
			OLD.cobta_tipotarjeta,
			OLD.entad_codigo,
			OLD.ent_codigo,
			OLD.marta_codigo,
			OLD.cobdet_codigo,
			OLD.cob_codigo,
			OLD.ven_codigo,
			OLD.cobta_transaccion,
			OLD.redpa_codigo
        );
    END IF;
		RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_cobro_tarjeta()
CREATE TRIGGER t_insercion_eliminacion_cobro_tarjeta
AFTER INSERT OR DELETE ON cobro_tarjeta
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_cobro_tarjeta();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_cobro_cheque()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from cobro_cab cc where cc.cob_codigo=NEW.cob_codigo);
		usuLogin = (select u.usu_login from cobro_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.cob_codigo=NEW.cob_codigo);
        INSERT INTO cobro_cheque_auditoria(
            cocheaud_codigo,
			usu_codigo,
			usu_login,
			cocheaud_fecha,
			cocheaud_procedimiento,
			coche_codigo,
			coche_numero,
			coche_monto,
			coche_tipocheque,
			coche_fechavencimiento,
			ent_codigo,
			cobdet_codigo,
			cob_codigo,
			ven_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cocheaud_codigo), 0) + 1 FROM cobro_cheque_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.coche_codigo,
			NEW.coche_numero,
			NEW.coche_monto,
			NEW.coche_tipocheque,
			NEW.coche_fechavencimiento,
			NEW.ent_codigo,
			NEW.cobdet_codigo,
			NEW.cob_codigo,
			NEW.ven_codigo
        );
    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select cc.usu_codigo from cobro_cab cc where cc.cob_codigo=OLD.cob_codigo);
		usuLogin = (select u.usu_login from cobro_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.cob_codigo=OLD.cob_codigo);
        INSERT INTO cobro_cheque_auditoria(
            cocheaud_codigo,
			usu_codigo,
			usu_login,
			cocheaud_fecha,
			cocheaud_procedimiento,
			coche_codigo,
			coche_numero,
			coche_monto,
			coche_tipocheque,
			coche_fechavencimiento,
			ent_codigo,
			cobdet_codigo,
			cob_codigo,
			ven_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(cocheaud_codigo), 0) + 1 FROM cobro_cheque_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.coche_codigo,
			OLD.coche_numero,
			OLD.coche_monto,
			OLD.coche_tipocheque,
			OLD.coche_fechavencimiento,
			OLD.ent_codigo,
			OLD.cobdet_codigo,
			OLD.cob_codigo,
			OLD.ven_codigo
        );
    END IF;
		RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_cobro_cheque()
CREATE TRIGGER t_insercion_eliminacion_cobro_cheque
AFTER INSERT OR DELETE ON cobro_cheque
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_cobro_cheque();

CREATE OR REPLACE FUNCTION spt_insercion_actualizacion_nota_venta_cab()
RETURNS TRIGGER AS $$
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
        INSERT INTO nota_venta_cab_auditoria(
            notvenaud_codigo,
			notvenaud_fecha,
			notvenaud_procedimiento,
			notven_codigo,
			notven_fecha,
			notven_numeronota,
			notven_concepto,
			notven_estado,
			tipco_codigo,
			ven_codigo,
			suc_codigo,
			emp_codigo,
			usu_codigo,
			cli_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(notvenaud_codigo), 0) + 1 FROM nota_venta_cab_auditoria),   
			current_timestamp,
			'ALTA',
            NEW.notven_codigo,
			NEW.notven_fecha,
			NEW.notven_numeronota,
			NEW.notven_concepto,
			NEW.notven_estado,
			NEW.tipco_codigo,
			NEW.ven_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo,
			NEW.usu_codigo,
			NEW.cli_codigo
        );
    -- Validamos si la operacion es de actualizacion
	ELSEIF TG_OP = 'UPDATE' THEN
    	-- Registramos el nuevo valor actualizado
    	INSERT INTO nota_venta_cab_auditoria(
            notvenaud_codigo,
			notvenaud_fecha,
			notvenaud_procedimiento,
			notven_codigo,
			notven_fecha,
			notven_numeronota,
			notven_concepto,
			notven_estado,
			tipco_codigo,
			ven_codigo,
			suc_codigo,
			emp_codigo,
			usu_codigo,
			cli_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(notvenaud_codigo), 0) + 1 FROM nota_venta_cab_auditoria),   
			current_timestamp,
			'BAJA',
            OLD.notven_codigo,
			OLD.notven_fecha,
			OLD.notven_numeronota,
			OLD.notven_concepto,
			OLD.notven_estado,
			OLD.tipco_codigo,
			OLD.ven_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo,
			OLD.usu_codigo,
			OLD.cli_codigo
        );
	END IF;
		RETURN NEW; --Este return no se utiliza
END
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_actualizacion_nota_venta_cab
CREATE TRIGGER t_insercion_actualizacion_nota_venta_cab
AFTER INSERT OR UPDATE ON nota_venta_cab
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_nota_venta_cab();

CREATE OR REPLACE FUNCTION spt_insercion_eliminacion_nota_venta_det()
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE usuCodigo integer;
		usuLogin varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select nvc.usu_codigo from nota_venta_cab nvc where nvc.notven_codigo=NEW.notven_codigo);
		usuLogin = (select u.usu_login from nota_venta_cab nvc join usuario u on u.usu_codigo=nvc.usu_codigo where nvc.notven_codigo=NEW.notven_codigo);
        INSERT INTO nota_venta_det_auditoria(
            notvendetaud_codigo,
			usu_codigo,
			usu_login,
			notvendetaud_fecha,
			notvendetaud_procedimiento,
			notven_codigo,
			it_codigo,
			tipit_codigo,
			notvendet_cantidad,
			notvendet_precio,
			dep_codigo,
			suc_codigo,
			emp_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(notvendetaud_codigo), 0) + 1 FROM nota_venta_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'ALTA',       
            NEW.notven_codigo,
			NEW.it_codigo,
			NEW.tipit_codigo,
			NEW.notvendet_cantidad,
			NEW.notvendet_precio,
			NEW.dep_codigo,
			NEW.suc_codigo,
			NEW.emp_codigo
        );
    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		--Sacamos el codigo y nombre de usuario
		usuCodigo = (select nvc.usu_codigo from nota_venta_cab nvc where nvc.notven_codigo=OLD.notven_codigo);
		usuLogin = (select u.usu_login from nota_venta_cab nvc join usuario u on u.usu_codigo=nvc.usu_codigo where nvc.notven_codigo=OLD.notven_codigo);
        INSERT INTO cobro_det_auditoria(
            cobdetaud_codigo,
			usu_codigo,
			usu_login,
			cobdetaud_fecha,
			cobdetaud_procedimiento,
			cobdet_codigo,
			cob_codigo,
			ven_codigo,
			cobdet_monto,
			cobdet_numerocuota,
			forco_codigo
        )
        VALUES (
            (SELECT COALESCE(MAX(notvendetaud_codigo), 0) + 1 FROM nota_venta_det_auditoria), 
            usuCodigo, 
            usuLogin,  
            current_timestamp,
            'BAJA',       
            OLD.notven_codigo,
			OLD.it_codigo,
			OLD.tipit_codigo,
			OLD.notvendet_cantidad,
			OLD.notvendet_precio,
			OLD.dep_codigo,
			OLD.suc_codigo,
			OLD.emp_codigo
        );
    END IF;
		RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_insercion_eliminacion_nota_venta_det()
CREATE TRIGGER t_insercion_eliminacion_nota_venta_det
AFTER INSERT OR DELETE ON nota_venta_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_nota_venta_det();

-- Metodo trigger para ejecutar sp_libro_compra y sp_cuenta_pagar

select i.tipim_codigo from items i where i.it_codigo=1;
select cc.tipco_codigo into codigo_comprobante from compra_cab cc where cc.comp_codigo=1;
select tc.tipco_descripcion into comprobante from compra_cab cc join tipo_comprobante tc on tc.tipco_codigo=cc.tipco_codigo  where cc.comp_codigo=1;
select cc.comp_numfactura into numero_comprobante from compra_cab cc where cc.comp_codigo=1;
select cc.usu_codigo from compra_cab cc where cc.comp_codigo=1;
select u.usu_login from compra_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.comp_codigo=1;


CREATE OR REPLACE FUNCTION spt_actualizacion_libro_compra_cuenta_pagar() 
RETURNS TRIGGER AS $$
--Creamos las variables
DECLARE tipoImpuesto integer;
		monto5 numeric;
		monto10 numeric;
		exenta numeric;
		monto numeric;
		codigo_comprobante integer;
		comprobante varchar;
		numero_comprobante varchar;
		codigoUsuario integer;
		usuario varchar;
BEGIN
    -- Validamos si la operacion es de insercion
    IF TG_OP = 'INSERT' THEN
		-- Consultamos datos para modificacion en libro_compra y cuenta_pagar
		-- Consultamos datos del item
		select i.tipim_codigo into tipoImpuesto from items i where i.it_codigo=NEW.it_codigo;
		-- Definimos valores por defecto a las variables 
		monto5 := 0;
	    monto10 := 0;
	    exenta := 0;
		monto := 0;
		-- Validamos y asignamos la multiplicacion en base al tipo de impuesto, esto solo para libro_compra
		if tipoImpuesto = 1 then -- 5%
			if NEW.tipit_codigo = 3 then -- validamos servicio
				monto5 := round(NEW.compdet_precio);
			else 
				monto5 := round(NEW.compdet_cantidad*NEW.compdet_precio);
			end if;
		elseif tipoImpuesto = 2 then -- 10%
			if NEW.tipit_codigo = 3 then -- validamos servicio
				monto10 := round(NEW.compdet_precio);
			else 
				monto10 := round(NEW.compdet_cantidad*NEW.compdet_precio);
			end if;
		else -- exenta
			if NEW.tipit_codigo = 3 then -- validamos servicio
				exenta := round(NEW.compdet_precio);
			else 
				exenta := round(NEW.compdet_cantidad*NEW.compdet_precio);
			end if;
		end if;
		-- Multiplicamos cantidad por precio y asignamos a total, esto solo para cuenta pagar
		if NEW.tipit_codigo = 3 then -- validamos servicio
			monto := round(NEW.compdet_precio);
		else 
			monto := round(NEW.compdet_cantidad*NEW.compdet_precio);
		end if;
		-- Consultamos datos de la cabecera
		select cc.tipco_codigo into codigo_comprobante from compra_cab cc where cc.comp_codigo=NEW.comp_codigo;
		select tc.tipco_descripcion into comprobante from compra_cab cc join tipo_comprobante tc on tc.tipco_codigo=cc.tipco_codigo  where cc.comp_codigo=NEW.comp_codigo;
		select cc.comp_numfactura into numero_comprobante from compra_cab cc where cc.comp_codigo=NEW.comp_codigo;
		select cc.usu_codigo into codigoUsuario from compra_cab cc where cc.comp_codigo=NEW.comp_codigo;
		select u.usu_login into usuario from compra_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.comp_codigo=NEW.comp_codigo;
		-- Llamamos al sp de libro compra y le pasamos los parametros
	    perform sp_libro_compra(NEW.comp_codigo, exenta, monto5, monto10, codigo_comprobante, comprobante, numero_comprobante, 1, codigoUsuario, usuario);
		-- Llammos al sp de cuenta pagar y le pasamos los parametros
		perform sp_cuenta_pagar(NEW.comp_codigo, monto, monto, 1, codigoUsuario, usuario);
    --Validamos si la operacion es una eliminacion
    ELSIF TG_OP = 'DELETE' THEN
		-- Consultamos datos para modificacion en libro_compra y cuenta_pagar
		-- Consultamos datos del item
		select i.tipim_codigo into tipoImpuesto from items i where i.it_codigo=OLD.it_codigo;
		-- Definimos valores por defecto a las variables 
		monto5 := 0;
	    monto10 := 0;
	    exenta := 0;
		monto := 0;
		-- Validamos y asignamos la multiplicacion en base al tipo de impuesto, esto solo para libro_compra
		if tipoImpuesto = 1 then -- 5%
			if OLD.tipit_codigo = 3 then -- validamos servicio
				monto5 := round(OLD.compdet_precio);
			else 
				monto5 := round(OLD.compdet_cantidad*OLD.compdet_precio);
			end if;
		elseif tipoImpuesto = 2 then -- 10%
			if OLD.tipit_codigo = 3 then -- validamos servicio
				monto10 := round(OLD.compdet_precio);
			else 
				monto10 := round(OLD.compdet_cantidad*OLD.compdet_precio);
			end if;
		else -- exenta
			if OLD.tipit_codigo = 3 then -- validamos servicio
				exenta := round(OLD.compdet_precio);
			else 
				exenta := round(OLD.compdet_cantidad*OLD.compdet_precio);
			end if;
		end if;
		-- Multiplicamos cantidad por precio y asignamos a total, esto solo para cuenta pagar
		if OLD.tipit_codigo = 3 then -- validamos servicio
			monto := round(OLD.compdet_precio);
		else 
			monto := round(OLD.compdet_cantidad*OLD.compdet_precio);
		end if;
		-- Consultamos datos de la cabecera
		select cc.tipco_codigo into codigo_comprobante from compra_cab cc where cc.comp_codigo=OLD.comp_codigo;
		select tc.tipco_descripcion into comprobante from compra_cab cc join tipo_comprobante tc on tc.tipco_codigo=cc.tipco_codigo  where cc.comp_codigo=OLD.comp_codigo;
		select cc.comp_numfactura into numero_comprobante from compra_cab cc where cc.comp_codigo=OLD.comp_codigo;
		select cc.usu_codigo into codigoUsuario from compra_cab cc where cc.comp_codigo=OLD.comp_codigo;
		select u.usu_login into usuario from compra_cab cc join usuario u on u.usu_codigo=cc.usu_codigo where cc.comp_codigo=OLD.comp_codigo;
		-- Llamamos al sp de libro compra y le pasamos los parametros
	    perform sp_libro_compra(OLD.comp_codigo, exenta, monto5, monto10, codigo_comprobante, comprobante, numero_comprobante, 2, codigoUsuario, usuario);
		-- Llammos al sp de cuenta pagar y le pasamos los parametros
		perform sp_cuenta_pagar(OLD.comp_codigo, monto, monto, 2, codigoUsuario, usuario);
    END IF;
		RETURN NULL;
END;
$$
 LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_actualizacion_libro_compra_cuenta_pagar()
CREATE TRIGGER t_actualizacion_libro_compra_cuenta_pagar
AFTER INSERT OR DELETE ON compra_det
FOR EACH ROW EXECUTE FUNCTION spt_actualizacion_libro_compra_cuenta_pagar();

-- Metodo trigger 2 para ejecutar sp_libro_compra y sp_cuenta_pagar
select ncc.tipco_codigo from nota_compra_cab ncc where ncc.nocom_codigo=(case
	when TG_OP = 'INSERT' then NEW.nocom_codigo else OLD.nocom_codigo
end
);

CREATE OR REPLACE FUNCTION spt_actualizacion2_libro_compra_cuenta_pagar() 
RETURNS TRIGGER AS $$
DECLARE
    tipoImpuesto       integer;
    monto5             numeric := 0;
    monto10            numeric := 0;
    exenta             numeric := 0;
    monto              numeric := 0;
    codigo_comprobante integer;
    comprobante        varchar;
    numero_comprobante varchar;
    codigoUsuario      integer;
    usuario            varchar;
    tipoNota           integer;
    nocomCodigo        int4;
    itCodigo           int4;
    tipitCodigo        int4;
    cantidad           numeric;
    precio             numeric;
BEGIN
    -- Tomamos los valores según si es INSERT o DELETE
    IF TG_OP = 'INSERT' THEN
        nocomCodigo := NEW.nocom_codigo;
        itCodigo    := NEW.it_codigo;
        tipitCodigo := NEW.tipit_codigo;
        cantidad    := NEW.nocomdet_cantidad;
        precio      := NEW.nocomdet_precio;
    ELSE
        nocomCodigo := OLD.nocom_codigo;
        itCodigo    := OLD.it_codigo;
        tipitCodigo := OLD.tipit_codigo;
        cantidad    := OLD.nocomdet_cantidad;
        precio      := OLD.nocomdet_precio;
    END IF;

    -- Traemos el tipo de nota (crédito o débito)
    SELECT ncc.tipco_codigo
    INTO tipoNota
    FROM nota_compra_cab ncc
    WHERE ncc.nocom_codigo = nocomCodigo;

    -- Solo procesamos notas de tipo 1 (crédito) y 2 (débito)
    IF tipoNota IN (1, 2) THEN
        -- Obtenemos tipo de impuesto del item
        SELECT i.tipim_codigo
        INTO tipoImpuesto
        FROM items i
        WHERE i.it_codigo = itCodigo;

        -- Inicializamos montos
        monto5 := 0; monto10 := 0; exenta := 0; monto := 0;

        -- Calculo de montos según impuesto y si es servicio
        IF tipoImpuesto = 1 THEN -- 5%
            IF tipitCodigo = 3 THEN
                monto5 := round(precio);
            ELSE
                monto5 := round(cantidad * precio);
            END IF;
        ELSIF tipoImpuesto = 2 THEN -- 10%
            IF tipitCodigo = 3 THEN
                monto10 := round(precio);
            ELSE
                monto10 := round(cantidad * precio);
            END IF;
        ELSE -- exenta
            IF tipitCodigo = 3 THEN
                exenta := round(precio);
            ELSE
                exenta := round(cantidad * precio);
            END IF;
        END IF;

        -- Calculo de monto total (cuenta pagar)
        IF tipitCodigo = 3 THEN
            monto := round(precio);
        ELSE
            monto := round(cantidad * precio);
        END IF;

        -- Datos de cabecera de nota
        SELECT ncc.tipco_codigo,
               tc.tipco_descripcion,
               ncc.nocom_numeronota,
               ncc.usu_codigo,
               u.usu_login
        INTO codigo_comprobante, comprobante, numero_comprobante, codigoUsuario, usuario
        FROM nota_compra_cab ncc
        JOIN tipo_comprobante tc ON tc.tipco_codigo = ncc.tipco_codigo
        JOIN usuario u ON u.usu_codigo = ncc.usu_codigo
        WHERE ncc.nocom_codigo = nocomCodigo;

		-- En caso de que sea credito, multiplicamos por -1
		IF tipoNota = 1 THEN
			monto10 := monto10*(-1);
			monto5 := monto5*(-1);
			exenta := exenta*(-1);
			monto := monto*(-1);
		END IF;

        -- Ejecutamos según operación
        IF TG_OP = 'INSERT' THEN
            PERFORM sp_libro_compra(nocomCodigo, exenta, monto5, monto10,
                                    codigo_comprobante, comprobante, numero_comprobante,
                                    1, codigoUsuario, usuario);
            PERFORM sp_cuenta_pagar(nocomCodigo, monto, monto,
                                    1, codigoUsuario, usuario);
        ELSIF TG_OP = 'DELETE' THEN
            PERFORM sp_libro_compra(nocomCodigo, exenta, monto5, monto10,
                                    codigo_comprobante, comprobante, numero_comprobante,
                                    2, codigoUsuario, usuario);
            PERFORM sp_cuenta_pagar(nocomCodigo, monto, monto,
                                    2, codigoUsuario, usuario);
        END IF;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--Creamos el trigger que ejecutara la funcion spt_actualizacion2_libro_compra_cuenta_pagar()
CREATE TRIGGER t_actualizacion2_libro_compra_cuenta_pagar
BEFORE INSERT OR DELETE ON nota_compra_det
FOR EACH ROW EXECUTE FUNCTION spt_actualizacion2_libro_compra_cuenta_pagar();


--Reejecucion de triggers
--Compras
CREATE TRIGGER t_insercion_eliminacion_pedido_compra_det
AFTER INSERT OR DELETE ON pedido_compra_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_pedido_compra_det();

CREATE TRIGGER t_insercion_eliminacion_presupuesto_proveedor_det
AFTER INSERT OR DELETE ON presupuesto_proveedor_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_presupuesto_proveedor_det();

CREATE TRIGGER t_insercion_eliminacion_compra_det
AFTER INSERT OR DELETE ON compra_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_compra_det();

CREATE TRIGGER t_insercion_eliminacion_ajuste_inventario_det
AFTER INSERT OR DELETE ON ajuste_inventario_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_ajuste_inventario_det();

CREATE TRIGGER t_insercion_eliminacion_nota_compra_det
AFTER INSERT OR DELETE ON nota_compra_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_nota_compra_det();

CREATE TRIGGER t_insercion_actualizacion_eliminacion_stock
AFTER INSERT OR UPDATE OR DELETE ON stock
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_eliminacion_stock();

--Venta
CREATE TRIGGER t_insercion_eliminacion_pedido_venta_det
AFTER INSERT OR DELETE ON pedido_venta_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_pedido_venta_det();

CREATE TRIGGER t_insercion_actualizacion_apertura_cierre
AFTER INSERT OR UPDATE ON apertura_cierre
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_apertura_cierre();

CREATE TRIGGER t_insercion_recaudacion_depositar
AFTER INSERT ON recaudacion_depositar
FOR EACH ROW EXECUTE FUNCTION spt_insercion_recaudacion_depositar();

CREATE TRIGGER t_insercion_arqueo_control
AFTER INSERT ON arqueo_control
FOR EACH ROW EXECUTE FUNCTION spt_insercion_arqueo_control_auditoria();

CREATE TRIGGER t_insercion_actualizacion_venta_cab
AFTER INSERT OR UPDATE ON venta_cab
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_venta_cab();

CREATE TRIGGER t_insercion_eliminacion_venta_det
AFTER INSERT OR DELETE ON venta_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_venta_det();

CREATE TRIGGER t_insercion_pedido_venta
AFTER INSERT ON pedido_venta
FOR EACH ROW EXECUTE FUNCTION spt_insercion_pedido_venta();

CREATE TRIGGER t_insercion_actualizacion_libro_venta
AFTER INSERT OR UPDATE ON libro_venta
FOR EACH ROW EXECUTE FUNCTION spt_insercion_actualizacion_libro_venta();

--Produccion
CREATE TRIGGER t_insercion_eliminacion_presupuesto_det
AFTER INSERT OR DELETE ON presupuesto_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_presupuesto_det();

CREATE TRIGGER t_insercion_eliminacion_orden_produccion_det
AFTER INSERT OR DELETE ON orden_produccion_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_orden_produccion_det();

CREATE TRIGGER t_insercion_eliminacion_componente_produccion_det
AFTER INSERT OR DELETE ON componente_produccion_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_componente_produccion_det();

CREATE TRIGGER t_insercion_eliminacion_orden_produccion_det2
AFTER INSERT OR DELETE ON orden_produccion_det2
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_orden_produccion_det2();

CREATE TRIGGER t_insercion_modificacion_eliminacion_produccion_det
AFTER INSERT OR DELETE ON produccion_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_modificacion_eliminacion_produccion_det_auditoria();

CREATE TRIGGER t_insercion_eliminacion_etapa_produccion
AFTER INSERT OR DELETE ON etapa_produccion
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_etapa_produccion();

CREATE TRIGGER t_insercion_eliminacion_produccion_terminada_det
AFTER INSERT OR DELETE ON produccion_terminada_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_produccion_terminada_det();

CREATE TRIGGER t_insercion_eliminacion_mermas_det
AFTER INSERT OR DELETE ON mermas_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_mermas_det();

CREATE TRIGGER t_insercion_eliminacion_control_calidad_det
AFTER INSERT OR DELETE ON control_calidad_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_eliminacion_control_calidad_det();

CREATE TRIGGER t_insercion_costo_produccion_det
AFTER INSERT OR DELETE ON costo_produccion_det
FOR EACH ROW EXECUTE FUNCTION spt_insercion_costo_produccion_det();

--vistas
select * from v_costo_produccion_det vcpd where vcpd.copro_codigo=1;
create or replace view v_costo_produccion_det as 
select 
	cpd.*,
	i.it_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	cpd.coprodet_cantidad*cpd.coprodet_costo as subtotal
from costo_produccion_det cpd 
join items i on i.it_codigo=cpd.it_codigo 
and i.tipit_codigo=cpd.tipit_codigo 
join unidad_medida um on um.unime_codigo=i.unime_codigo 
order by cpd.it_codigo;

select * from v_costo_produccion_cab vcpc where vcpc.copro_estado <> 'ANULADO';
create or replace view v_costo_produccion_cab as
select 
	cpc.copro_codigo,
	cpc.copro_fecha,
	cpc.copro_estado,
	cpc.orpro_codigo,
	cpc.usu_codigo,
	cpc.suc_codigo,
	cpc.emp_codigo,
	s.secc_descripcion,
	u.usu_login,
	s2.suc_descripcion,
	e.emp_razonsocial 
from costo_produccion_cab cpc 
	join orden_produccion_cab opc on opc.orpro_codigo=cpc.orpro_codigo 
		join seccion s on s.secc_codigo=opc.secc_codigo 
	join usuario u on u.usu_codigo=cpc.usu_codigo 
	join sucursal s2 on s2.suc_codigo=cpc.suc_codigo 
	and s2.emp_codigo=cpc.emp_codigo 
		join empresa e on e.emp_codigo=s2.emp_codigo 
order by cpc.copro_codigo;


select * from v_control_calidad_det vccd where vccd.conca_codigo=1;
create or replace view v_control_calidad_det as
select 
	ccd.*,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	t.tall_descripcion,
	pcc.pacoca_descripcion,
	um.unime_codigo,
	um.unime_descripcion 
from control_calidad_det ccd 
	join items i on i.it_codigo=ccd.it_codigo and i.tipit_codigo=ccd.tipit_codigo 
		join modelo m on m.mod_codigo=i.mod_codigo 
		join talle t on t.tall_codigo=i.tall_codigo 
		join unidad_medida um on um.unime_codigo=i.unime_codigo 
	join parametro_control_calidad pcc on pcc.pacoca_codigo=ccd.pacoca_codigo 
order by ccd.it_codigo;

select * from v_control_calidad_cab vccc where vccc.conca_estado <> 'ANULADO';
create or replace view v_control_calidad_cab as
select 
	ccc.conca_codigo,
	ccc.conca_fecha,
	ccc.conca_estado,
	ccc.proter_codigo,
	ccc.usu_codigo,
	ccc.suc_codigo,
	ccc.emp_codigo,
	s.secc_descripcion,
	u.usu_login,
	s2.suc_descripcion,
	e.emp_razonsocial
from control_calidad_cab ccc 
	join produccion_terminada_cab ptc on ptc.proter_codigo=ccc.proter_codigo 
		join produccion_cab pc on pc.prod_codigo=ptc.prod_codigo 
			join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
				join seccion s on s.secc_codigo=opc.secc_codigo 
	join usuario u on u.usu_codigo=ccc.usu_codigo 
	join sucursal s2 on s2.suc_codigo=ccc.suc_codigo and s2.emp_codigo=ccc.emp_codigo 
		join empresa e on e.emp_codigo=s2.emp_codigo 
order by ccc.conca_codigo;

select * from v_mermas_det vmd where vmd.mer_codigo=1;
create or replace view v_mermas_det as 
select 
	md.*,
	i.it_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	md.merdet_cantidad*md.merdet_precio as subtotal
from mermas_det md 
	join items i on i.it_codigo=md.it_codigo and i.tipit_codigo=md.tipit_codigo 
		join unidad_medida um on um.unime_codigo=i.unime_codigo
order by md.it_codigo;

select * from v_mermas_cab vmc where vmc.mer_estado <> 'ANULADO';
create or replace view v_mermas_cab as
select 
	mc.mer_codigo,
	mc.mer_fecha,
	mc.mer_estado,
	mc.proter_codigo,
	mc.usu_codigo,
	mc.suc_codigo,
	mc.emp_codigo,
	s.secc_descripcion,
	u.usu_login,
	s2.suc_descripcion,
	e.emp_razonsocial 
from mermas_cab mc 
	join produccion_terminada_cab ptc on ptc.proter_codigo=mc.proter_codigo 
		join produccion_cab pc on pc.prod_codigo=ptc.prod_codigo 
			join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
				join seccion s on s.secc_codigo=opc.secc_codigo 
join usuario u on u.usu_codigo=mc.usu_codigo 
join sucursal s2 on s2.suc_codigo=mc.suc_codigo 
	and s2.emp_codigo=mc.emp_codigo 
	join empresa e on e.emp_codigo=s2.emp_codigo 
order by mc.mer_codigo;


create or replace view v_produccion_terminada_det as 
select 
  	ptd.*,
  	i.it_descripcion||' '||m.mod_codigomodelo as item,
  	i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion as item2,
  	t.tall_descripcion,
  	um.unime_codigo,
  	um.unime_descripcion,
  	d.dep_descripcion 
from produccion_terminada_det ptd 
	join stock s on s.it_codigo=ptd.it_codigo 
	and s.tipit_codigo=ptd.tipit_codigo 
	and s.dep_codigo=ptd.dep_codigo
	and s.suc_codigo=ptd.suc_codigo 
	and s.emp_codigo=ptd.emp_codigo 
	join items i on i.it_codigo=s.it_codigo 
	and i.tipit_codigo=s.tipit_codigo 
	join modelo m on m.mod_codigo=i.mod_codigo 
	join talle t on t.tall_codigo=i.tall_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo 
	join deposito d on d.dep_codigo=s.dep_codigo 
	and d.suc_codigo=s.suc_codigo 
	and d.emp_codigo=s.emp_codigo 
order by ptd.it_codigo;

create or replace view v_produccion_terminada_cab as 
select 
	ptc.proter_codigo,
	ptc.proter_fecha,
	ptc.proter_fechaculminacion,
	ptc.proter_estado,
	ptc.prod_codigo,
	ptc.usu_codigo,
	ptc.suc_codigo,
	ptc.emp_codigo,
	s.secc_descripcion,
	p.per_nombre||' '||p.per_apellido as cliente,
	u.usu_login,
	s2.suc_descripcion,
	e.emp_razonsocial 
from produccion_terminada_cab ptc 
	join produccion_cab pc on pc.prod_codigo=ptc.prod_codigo 
	join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
	join seccion s on s.secc_codigo=opc.secc_codigo 
	join orden_presupuesto op on op.orpro_codigo=opc.orpro_codigo 
	join presupuesto_cab pc2 on pc2.pres_codigo=op.pres_codigo 
	join cliente c on c.cli_codigo=pc2.cli_codigo 
	join personas p on p.per_codigo=c.per_codigo 
	join usuario u on u.usu_codigo=ptc.usu_codigo 
	join sucursal s2 on s2.suc_codigo=ptc.suc_codigo 
	and s2.emp_codigo=ptc.emp_codigo 
	join empresa e on e.emp_codigo=s2.emp_codigo 
order by ptc.proter_codigo;

select * from v_etapa_produccion vep;
create or replace view v_etapa_produccion as 
select 
	ep.*,
	s.secc_descripcion,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	t.tall_descripcion,
	tep.tipet_descripcion,
	m2.maq_descripcion,
	u.usu_login,
	s2.suc_descripcion,
	e.emp_razonsocial,
	pd.prodet_estado 
from etapa_produccion ep 
	join produccion_det pd on pd.prod_codigo=ep.prod_codigo 
	and pd.it_codigo=ep.it_codigo 
	and pd.tipit_codigo=ep.tipit_codigo 
	join items i on i.it_codigo=pd.it_codigo 
	and i.tipit_codigo=pd.tipit_codigo 
	join modelo m on m.mod_codigo=i.mod_codigo 
	join talle t on t.tall_codigo=i.tall_codigo 
	join produccion_cab pc on pc.prod_codigo=pd.prod_codigo 
	join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo
	join seccion s on s.secc_codigo=opc.secc_codigo 
	join tipo_etapa_produccion tep on tep.tipet_codigo=ep.tipet_codigo 
	join maquinaria m2 on m2.maq_codigo=ep.maq_codigo 
	join usuario u on u.usu_codigo=ep.usu_codigo 
	join sucursal s2 on s2.suc_codigo=ep.suc_codigo 
	and s2.emp_codigo=ep.emp_codigo 
	join empresa e on e.emp_codigo=s2.emp_codigo 
order by ep.prod_codigo;


select * from v_produccion_det where prod_codigo=1;
select * from v_produccion_det vpd where vpd.prod_codigo=1;
create or replace view v_produccion_det as
select 
	pd.*,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	t.tall_descripcion,
	um.unime_codigo,
	um.unime_descripcion
from produccion_det pd
	join items i on i.it_codigo=pd.it_codigo
	and i.tipit_codigo=pd.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo 
	join talle t on t.tall_codigo=i.tall_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo 
order by pd.prod_codigo;


select * from v_produccion_cab;
select * from v_produccion_cab vpc where vpc.prod_estado <> 'ANULADO';
create or replace view v_produccion_cab as
select 
	pc.prod_codigo,
	pc.prod_fecha,
	pc.prod_estado,
	pc.orpro_codigo,
	pc.usu_codigo,
	pc.suc_codigo,
	pc.emp_codigo,
	opc.orpro_fechainicio,
	opc.orpro_fechaculminacion,
	s.secc_descripcion,
	u.usu_login,
	s2.suc_descripcion,
	e.emp_razonsocial 
from produccion_cab pc 
	join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo 
	join seccion s on s.secc_codigo=opc.secc_codigo 
	join usuario u on u.usu_codigo=pc.usu_codigo 
	join sucursal s2 on s2.suc_codigo=pc.suc_codigo 
	and s2.emp_codigo=pc.emp_codigo
	join empresa e on e.emp_codigo=s2.emp_codigo 
order by pc.prod_codigo;

create or replace view v_orden_produccion_det2 as 
select 
	opd.orpro_codigo,
	opd.compro_codigo,
	i.it_descripcion,
	opd.orprodet2_cantidad,
	um.unime_descripcion 
from orden_produccion_det2 opd 
	join componente_produccion_det cpd on cpd.compro_codigo=opd.compro_codigo 
	and cpd.it_codigo=opd.it_codigo
	and cpd.tipit_codigo=cpd.tipit_codigo 
	join items i on i.it_codigo=cpd.it_codigo
	and i.tipit_codigo=cpd.tipit_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo
order by opd.it_codigo;

select * from v_componente_produccion_det vcpd where vcpd.compro_codigo=1;
create or replace view v_componente_produccion_det as
select 
	cpd.*,
	i.it_descripcion as item2,
	um.unime_codigo,
	um.unime_descripcion 
from componente_produccion_det cpd 
	join items i on i.it_codigo=cpd.it_codigo
	and i.tipit_codigo=cpd.tipit_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo
order by cpd.compro_codigo;

select * from v_componente_produccion_cab vcpc where vcpc.compro_estado <> 'ANULADO';
create or replace view v_componente_produccion_cab as
select 
	cpc.compro_codigo,
	cpc.compro_fecha,
	cpc.compro_estado,
	cpc.it_codigo,
	cpc.tipit_codigo,
	cpc.usu_codigo,
	cpc.suc_codigo,
	cpc.emp_codigo,
	i.it_descripcion as item,
	m.mod_codigomodelo,
	cp.col_descripcion,
	t.tall_descripcion,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial 
from componente_produccion_cab cpc 
	join items i on i.it_codigo=cpc.it_codigo
	and i.tipit_codigo=cpc.tipit_codigo 
	join modelo m on m.mod_codigo=i.mod_codigo 
	join color_prenda cp on cp.col_codigo=m.col_codigo 
	join talle t on t.tall_codigo=i.tall_codigo
	join usuario u on u.usu_codigo=cpc.usu_codigo
	join sucursal s on s.suc_codigo=cpc.suc_codigo 
	and s.emp_codigo=cpc.emp_codigo 
	join empresa e on e.emp_codigo=s.emp_codigo 
order by cpc.compro_codigo;

create or replace view v_gui_movimiento as
select
	pg.perf_codigo,
	(case 
		when g.gui_descripcion ='CIUDAD' then
    					'CIUDAD'
		when g.gui_descripcion ='EMPRESA' then
    					'EMPRESA'
		when g.gui_descripcion ='SUCURSAL' then
    					'SUCURSAL'
		when g.gui_descripcion ='TIPO IMPUESTO' then
    					'TIPO IMPUESTO'
		when g.gui_descripcion ='TIPO PROVEEDOR' then
    					'TIPO PROVEEDOR'
		when g.gui_descripcion ='TIPO ITEM' then
    					'TIPO ITEM'
		when g.gui_descripcion ='PROVEEDOR' then
    					'PROVEEDOR'
		when g.gui_descripcion ='DEPOSITO' then
    					'DEPOSITO'
		when g.gui_descripcion ='ITEMS' then
    					'ITEMS'
		when g.gui_descripcion ='FUNCIONARIO PROVEEDOR' then
    					'FUNCIONARIO PROVEEDOR'
		when g.gui_descripcion ='CARGO' then
    					'CARGO'
		when g.gui_descripcion ='PERSONAS' then
    					'PERSONAS'
		when g.gui_descripcion ='FUNCIONARIO' then
    					'FUNCIONARIO'
		when g.gui_descripcion ='TALLE' then
    					'TALLE'
		when g.gui_descripcion ='COLOR PRENDA' then
    					'COLOR PRENDA'
		when g.gui_descripcion ='MODELO' then
    					'MODELO'
		when g.gui_descripcion ='MAQUINARIA' then
    					'MAQUINARIA'
		when g.gui_descripcion ='TIPO ETAPA PRODUCCION' then
    					'TIPO ETAPA PRODUCCION'
		when g.gui_descripcion ='UNIDAD MEDIDA' then
    					'UNIDAD MEDIDA'
		when g.gui_descripcion ='PARAMETRO CONTROL CALIDAD' then
    					'PARAMETRO CONTROL CALIDAD'
		when g.gui_descripcion ='PARAMETRO CONTROL CALIDAD' then
    					'PARAMETRO CONTROL CALIDAD'
		when g.gui_descripcion ='SECCION' then
    					'SECCION'
		when g.gui_descripcion ='EQUIPO TRABAJO' then
    					'EQUIPO TRABAJO'
		when g.gui_descripcion ='TIPO DOCUMENTO' then
    					'TIPO DOCUMENTO'
		when g.gui_descripcion ='TIPO COMPROBANTE' then
    					'TIPO COMPROBANTE'
		when g.gui_descripcion ='TIMBRADOS' then
    					'TIMBRADOS'
		when g.gui_descripcion ='FORMA COBRO' then
    					'FORMA COBRO'
		when g.gui_descripcion ='MARCA TARJETA' then
    					'MARCA TARJETA'
		when g.gui_descripcion ='RED PAGO' then
    					'RED PAGO'
		when g.gui_descripcion ='ENTIDAD EMISORA' then
    					'ENTIDAD EMISORA'
		when g.gui_descripcion ='ENTIDAD ADHERIDA' then
    					'ENTIDAD ADHERIDA'
		when g.gui_descripcion ='CAJA' then
    					'CAJA'
		when g.gui_descripcion ='CLIENTES' then
    					'CLIENTES'
		when g.gui_descripcion ='MARCA VEHICULO' then
    					'MARCA VEHICULO'
		when g.gui_descripcion ='MODELO VEHICULO' then
    					'MODELO VEHICULO'
		when g.gui_descripcion ='CHAPA VEHICULO' then
    					'CHAPA VEHICULO'
		when g.gui_descripcion ='TIPO CLIENTE' then
    					'TIPO CLIENTE'
		when g.gui_descripcion ='GUI' then
    					'GUI'
		when g.gui_descripcion ='MODULO' then
    					'MODULO'
		when g.gui_descripcion ='PERMISOS' then
    					'PERMISOS'
		when g.gui_descripcion ='PERFIL' then
    					'PERFIL'
		when g.gui_descripcion ='PERFILES PERMISOS' then
    					'PERFILES PERMISOS'
		when g.gui_descripcion ='PERFIL GUI' then
    					'PERFIL GUI'
		when g.gui_descripcion ='USUARIO' then
    					'USUARIO'
		when g.gui_descripcion ='ASIGNACION PERMISO USUARIO' then
    					'ASIGNACION PERMISO USUARIO'
		when g.gui_descripcion ='CONFIGURACIONES' then
    					'CONFIGURACIONES'
		when g.gui_descripcion ='CONFIGURACIONES SUCURSAL' then
    					'CONFIGURACIONES SUCURSAL'
    	when g.gui_descripcion ='PEDIDO COMPRA' then
    					'PEDIDO COMPRA'
    	when g.gui_descripcion ='PRESUPUESTO PROVEEDOR' then
    					'PRESUPUESTO PROVEEDOR'
    	when g.gui_descripcion ='ORDEN COMPRA' then
    					'ORDEN COMPRA'
    	when g.gui_descripcion ='COMPRA' then
    					'COMPRA'
    	when g.gui_descripcion ='AJUSTE STOCK' then
    					'AJUSTE STOCK'
    	when g.gui_descripcion ='NOTA COMPRA' then
    					'NOTA COMPRA'
    	when g.gui_descripcion ='PRESUPUESTO PRODUCCION' then
    					'PRESUPUESTO PRODUCCION'
    	when g.gui_descripcion ='COMPONENTE PRODUCCION' then
    					'COMPONENTE PRODUCCION'
    	when g.gui_descripcion ='ORDEN PRODUCCION' then
    					'ORDEN PRODUCCION'
    	when g.gui_descripcion ='PRODUCCION' then
    					'PRODUCCION'
    	when g.gui_descripcion ='ETAPA PRODUCCION' then
    					'ETAPA PRODUCCION'
    	when g.gui_descripcion ='CONTROL CALIDAD' then
    					'CONTROL CALIDAD'
    	when g.gui_descripcion ='PRODUCCION TERMINADA' then
    					'PRODUCCION TERMINADA'
    	when g.gui_descripcion ='MERMAS' then
    					'MERMAS'
    	when g.gui_descripcion ='COSTO PRODUCCION' then
    					'COSTO PRODUCCION'
    	when g.gui_descripcion ='PEDIDO VENTA' then
    					'PEDIDO VENTA'
    	when g.gui_descripcion ='APERTURA CIERRE' then
    					'APERTURA CIERRE'
    	when g.gui_descripcion ='VENTA' then
    					'VENTA'
    	when g.gui_descripcion ='COBRO' then
    					'COBRO'
    	when g.gui_descripcion ='NOTA VENTA' then
    					'NOTA VENTA'
    	when g.gui_descripcion ='REPORTE REFERENCIAL SEGURIDAD' then
    					'REPORTE REFERENCIAL SEGURIDAD'
    	when g.gui_descripcion ='REPORTE REFERENCIAL COMPRAS' then
    					'REPORTE REFERENCIAL COMPRAS'
    	when g.gui_descripcion ='REPORTE MOVIMIENTO COMPRAS' then
    					'REPORTE MOVIMIENTO COMPRAS'
    	when g.gui_descripcion ='REPORTE REFERENCIAL PRODUCCION' then
    					'REPORTE REFERENCIAL PRODUCCION'
    	when g.gui_descripcion ='REPORTE MOVIMIENTO PRODUCCION' then
    					'REPORTE MOVIMIENTO PRODUCCION'
    	when g.gui_descripcion ='REPORTE REFERENCIAL VENTAS' then
    					'REPORTE REFERENCIAL VENTAS'
    	when g.gui_descripcion ='REPORTE MOVIMIENTO VENTAS' then
    					'REPORTE MOVIMIENTO VENTAS'
    	else 'NER'
     end) as gui_movimiento,
     (case 
	    when g.gui_descripcion ='CIUDAD' then
    					'/sys8DD/referenciales/compra/ciudad/index.php'
		when g.gui_descripcion ='EMPRESA' then
    					'/sys8DD/referenciales/compra/empresa/index.php'
		when g.gui_descripcion ='SUCURSAL' then
    					'/sys8DD/referenciales/compra/sucursal/index.php'
		when g.gui_descripcion ='TIPO IMPUESTO' then
    					'/sys8DD/referenciales/compra/tipo_impuesto/index.php'
		when g.gui_descripcion ='TIPO PROVEEDOR' then
    					'/sys8DD/referenciales/compra/tipo_proveedor/index.php'
		when g.gui_descripcion ='TIPO ITEM' then
    					'/sys8DD/referenciales/compra/tipo_item/index.php'
		when g.gui_descripcion ='PROVEEDOR' then
    					'/sys8DD/referenciales/compra/proveedor/index.php'
		when g.gui_descripcion ='DEPOSITO' then
    					'/sys8DD/referenciales/compra/deposito/index.php'
		when g.gui_descripcion ='ITEMS' then
    					'/sys8DD/referenciales/compra/items/index.php'
		when g.gui_descripcion ='FUNCIONARIO PROVEEDOR' then
    					'/sys8DD/referenciales/compra/funcionario_proveedor/index.php'
		when g.gui_descripcion ='CARGO' then
    					'/sys8DD/referenciales/produccion/cargo/index.php'
		when g.gui_descripcion ='PERSONAS' then
    					'/sys8DD/referenciales/produccion/personas/index.php'
		when g.gui_descripcion ='FUNCIONARIO' then
    					'/sys8DD/referenciales/produccion/funcionario/index.php'
		when g.gui_descripcion ='TALLE' then
    					'/sys8DD/referenciales/produccion/talle/index.php'
		when g.gui_descripcion ='COLOR PRENDA' then
    					'/sys8DD/referenciales/produccion/color_prenda/index.php'
		when g.gui_descripcion ='MODELO' then
    					'/sys8DD/referenciales/produccion/modelo/index.ph'
		when g.gui_descripcion ='MAQUINARIA' then
    					'/sys8DD/referenciales/produccion/maquinaria/index.php'
		when g.gui_descripcion ='TIPO ETAPA PRODUCCION' then
    					'/sys8DD/referenciales/produccion/tipo_etapa_produccion/index.php'
		when g.gui_descripcion ='UNIDAD MEDIDA' then
    					'/sys8DD/referenciales/produccion/unidad_medida/index.php'
		when g.gui_descripcion ='PARAMETRO CONTROL CALIDAD' then
    					'/sys8DD/referenciales/produccion/parametro_control_calidad/index.php'
		when g.gui_descripcion ='SECCION' then
    					'/sys8DD/referenciales/produccion/seccion/index.php'
		when g.gui_descripcion ='EQUIPO TRABAJO' then
    					'/sys8DD/referenciales/produccion/equipo_trabajo/index.php'
		when g.gui_descripcion ='TIPO DOCUMENTO' then
    					'/sys8DD/referenciales/venta/tipo_documento/index.php'
		when g.gui_descripcion ='TIPO COMPROBANTE' then
    					'/sys8DD/referenciales/venta/tipo_comprobante/index.php'
		when g.gui_descripcion ='TIMBRADOS' then
    					'/sys8DD/referenciales/venta/timbrados/index.php'
		when g.gui_descripcion ='FORMA COBRO' then
    					'/sys8DD/referenciales/venta/forma_cobro/index.php'
		when g.gui_descripcion ='MARCA TARJETA' then
    					'/sys8DD/referenciales/venta/marca_tarjeta/index.php'
		when g.gui_descripcion ='RED PAGO' then
    					'/sys8DD/referenciales/venta/red_pago/index.php'
		when g.gui_descripcion ='ENTIDAD EMISORA' then
    					'/sys8DD/referenciales/venta/entidad_emisora/index.php'
		when g.gui_descripcion ='ENTIDAD ADHERIDA' then
    					'/sys8DD/referenciales/venta/entidad_adherida/index.php'
		when g.gui_descripcion ='CAJA' then
    					'/sys8DD/referenciales/venta/caja/index.ph'
		when g.gui_descripcion ='CLIENTES' then
    					'/sys8DD/referenciales/venta/clientes/index.php'
		when g.gui_descripcion ='MARCA VEHICULO' then
    					'/sys8DD/referenciales/venta/marca_vehiculo/index.php'
		when g.gui_descripcion ='MODELO VEHICULO' then
    					'/sys8DD/referenciales/venta/modelo_vehiculo/index.php'
		when g.gui_descripcion ='CHAPA VEHICULO' then
    					'/sys8DD/referenciales/venta/chapa_vehiculo/index.php'
		when g.gui_descripcion ='TIPO CLIENTE' then
    					'/sys8DD/referenciales/venta/tipo_cliente/index.php'
		when g.gui_descripcion ='GUI' then
    					'/sys8DD/referenciales/seguridad/gui/index.php'
		when g.gui_descripcion ='MODULO' then
    					'/sys8DD/referenciales/seguridad/modulo/index.php'
		when g.gui_descripcion ='PERMISOS' then
    					'/sys8DD/referenciales/seguridad/permisos/index.php'
		when g.gui_descripcion ='PERFIL' then
    					'/sys8DD/referenciales/seguridad/perfil/index.php'
		when g.gui_descripcion ='PERFILES PERMISOS' then
    					'/sys8DD/referenciales/seguridad/perfiles_permisos/index.php'
		when g.gui_descripcion ='PERFIL GUI' then
    					'/sys8DD/referenciales/seguridad/perfil_gui/index.php'
		when g.gui_descripcion ='USUARIO' then
    					'/sys8DD/referenciales/seguridad/usuario/index.php'
		when g.gui_descripcion ='ASIGNACION PERMISO USUARIO' then
    					'/sys8DD/referenciales/seguridad/asignacion_permiso_usuario/index.php'
		when g.gui_descripcion ='CONFIGURACIONES' then
    					'/sys8DD/referenciales/seguridad/configuraciones/index.php'
		when g.gui_descripcion ='CONFIGURACIONES SUCURSAL' then
    					'/sys8DD/referenciales/seguridad/configuraciones_sucursal/index.php'
    	when g.gui_descripcion = 'PEDIDO COMPRA' then
    					'/sys8DD/modulos/compra/pedido_compra/index.php'
    	when g.gui_descripcion = 'PRESUPUESTO PROVEEDOR' then
    					'/sys8DD/modulos/compra/presupuesto_proveedor/index.php'
    	when g.gui_descripcion = 'ORDEN COMPRA' then
    					'/sys8DD/modulos/compra/orden_compra/index.php'
    	when g.gui_descripcion = 'COMPRA' then
    					'/sys8DD/modulos/compra/compra/index.php'
    	when g.gui_descripcion = 'AJUSTE STOCK' then
    					'/sys8DD/modulos/compra/ajuste_stock/index.php'
    	when g.gui_descripcion = 'NOTA COMPRA' then
    					'/sys8DD/modulos/compra/nota_compra/index.php'
    	when g.gui_descripcion = 'PRESUPUESTO PRODUCCION' then
    					'/sys8DD/modulos/produccion/presupuesto/index.php'
    	when g.gui_descripcion = 'COMPONENTE PRODUCCION' then
    					'/sys8DD/modulos/produccion/componente_produccion/index.php'
    	when g.gui_descripcion = 'ORDEN PRODUCCION' then
    					'/sys8DD/modulos/produccion/orden_produccion/index.php'
    	when g.gui_descripcion = 'PRODUCCION' then
    					'/sys8DD/modulos/produccion/produccion/index.php'
    	when g.gui_descripcion = 'ETAPA PRODUCCION' then
    					'/sys8DD/modulos/produccion/etapa_produccion/index.php'
    	when g.gui_descripcion = 'CONTROL CALIDAD' then
    					'/sys8DD/modulos/produccion/control_calidad/index.php'
    	when g.gui_descripcion ='PRODUCCION TERMINADA' then
    					'/sys8DD/modulos/produccion/produccion_terminada/index.php'
    	when g.gui_descripcion = 'MERMAS' then
    					'/sys8DD/modulos/produccion/mermas/index.php'
    	when g.gui_descripcion = 'COSTO PRODUCCION' then
    					'/sys8DD/modulos/produccion/costo_produccion/index.php'
    	when g.gui_descripcion = 'PEDIDO VENTA' then
    					'/sys8DD/modulos/venta/pedido_venta/index.php'
    	when g.gui_descripcion = 'APERTURA CIERRE' then
    					'/sys8DD/modulos/venta/apertura_cierre/index.php'
    	when g.gui_descripcion = 'VENTA' then
    					'/sys8DD/modulos/venta/venta/index.php'
    	when g.gui_descripcion = 'COBRO' then
    					'/sys8DD/modulos/venta/cobros/index.php'
    	when g.gui_descripcion = 'NOTA VENTA' then
    					'/sys8DD/modulos/venta/nota_venta/index.php'
    	when g.gui_descripcion = 'REPORTE REFERENCIAL SEGURIDAD' then
    					'/sys8DD/report/seguridad/informe_referencial.php'
    	when g.gui_descripcion = 'REPORTE REFERENCIAL COMPRAS' then
    					'/sys8DD/report/compras/informe_referencial.php'
    	when g.gui_descripcion = 'REPORTE MOVIMIENTO COMPRAS' then
    					'/sys8DD/report/compras/informe_movimiento.php'
    	when g.gui_descripcion = 'REPORTE REFERENCIAL PRODUCCION' then
    					'/sys8DD/report/produccion/informe_referencial.php'
    	when g.gui_descripcion = 'REPORTE MOVIMIENTO PRODUCCION' then
    					'/sys8DD/report/produccion/informe_movimiento.php'
    	when g.gui_descripcion = 'REPORTE REFERENCIAL VENTAS' then
    					'/sys8DD/report/ventas/informe_referencial.php'
    	when g.gui_descripcion ='REPORTE MOVIMIENTO VENTAS' then
    					'/sys8DD/report/ventas/informe_movimiento.php'
    	else 'NER'
     end) as gui_link	
from perfil_gui pg 
	join perfil p on p.perf_codigo=pg.perf_codigo 
	join gui g on g.gui_codigo=pg.gui_codigo 
	and g.modu_codigo=pg.modu_codigo
where pg.perfgui_estado='ACTIVO';

select * from v_gui_referenciales vgm where vgm.perf_codigo=2;

create or replace view v_gui_referenciales as
select
	table_name,
	--Nombre de las tablas a mostrar
    (case 
    	when table_name='asignacion_permiso_usuario' then
    					'ASIGNACION PERMISO USUARIO'
    	when table_name='caja' then
    					'CAJA'
    	when table_name='cargo' then
    					'CARGO'
    	when table_name='ciudad' then
    					'CIUDAD'
    	when table_name='cliente' then
    					'CLIENTE'
    	when table_name='color_prenda' then
    					'COLOR PRENDA'
    	when table_name='configuraciones' then
    					'CONFIGURACIONES INTERFAZ'
    	when table_name='configuraciones_sucursal' then
    					'CONFIGURACIONES INTERFAZ SUCURSAL'
    	when table_name='deposito' then
    					'DEPOSITO'
    	when table_name='empresa' then
    					'EMPRESA'
    	when table_name='entidad_adherida' then
    					'ENTIDAD ADHERIDA'
    	when table_name='entidad_emisora' then
    					'ENTIDAD EMISORA'
    	when table_name='equipo_trabajo' then
    					'EQUIPO TRABAJO'
    	when table_name='etapa_produccion' then
    					'ETAPA PRODUCCION'
    	when table_name='forma_cobro' then
    					'FORMA COBRO'
    	when table_name='timbrados' then
    					'TIMBRADOS'
    	when table_name='funcionario' then
    					'FUNCIONARIO'
    	when table_name='funcionario_proveedor' then
    					'FUNCIONARIO PROVEEDOR'
    	when table_name='gui' then
    					'GUI'
    	when table_name='items' then
    					'ITEMS'
    	when table_name='maquinaria' then
    					'MAQUINARIA'
    	when table_name='marca_tarjeta' then
    					'MARCA TARJETA'
    	when table_name='modelo' then
    					'MODELO'
    	when table_name='modulo' then
    					'MODULO'
    	when table_name='parametro_control_calidad' then
    					'PARAMETRO CONTROL CALIDAD'
    	when table_name='perfil' then
    					'PERFIL'
    	when table_name='perfil_gui' then
    					'PERFIL GUI'
    	when table_name='perfiles_permisos' then
    					'PERFIL PERMISO'
    	when table_name='permisos' then
    					'PERMISOS'
    	when table_name='personas' then
    					'PERSONAS'
    	when table_name='proveedor' then
    					'PROVEEDOR'
    	when table_name='red_pago' then
    					'RED PAGO'
    	when table_name='seccion' then
    					'SECCION'
    	when table_name='sucursal' then
    					'SUCURSAL'
    	when table_name='talle' then
    					'TALLE'
    	when table_name='tipo_comprobante' then
    					'TIPO COMPROBANTE'
    	when table_name='tipo_documento' then
    					'TIPO DOCUMENTO'
    	when table_name='tipo_etapa_produccion' then
    					'TIPO ETAPA PRODUCCION'
    	when table_name='tipo_impuesto' then
    					'TIPO IMPUESTO'
    	when table_name='tipo_item' then
    					'TIPO ITEM'
    	when table_name='tipo_proveedor' then
    					'TIPO PROVEEDOR'
    	when table_name='unidad_medida' then
    					'UNIDAD MEDIDA'
    	when table_name='usuario' then
    					'USUARIO'
    	when table_name='pedido_compra_cab' then
    					'PEDIDO COMPRA'
    	when table_name='presupuesto_proveedor_cab' then
    					'PRESUPUESTO PROVEEDOR'
    	when table_name='orden_compra_cab' then
    					'ORDEN COMPRA'
    	when table_name='compra_cab' then
    					'COMPRA'
    	when table_name='ajuste_stock_cab' then
    					'AJUSTE STOCK'
    	when table_name='nota_compra_cab' then
    					'NOTA COMPRA'
    	when table_name='presupuesto_cab' then
    					'PRESUPUESTO PRODUCCION'
    	when table_name='componente_produccion_cab' then
    					'COMPONENTE PRODUCCION'
    	when table_name='orden_produccion_cab' then
    					'ORDEN PRODUCCION'
    	when table_name='produccion_cab' then
    					'PRODUCCION'
    	when table_name='etapa_produccion' then
    					'ETAPA PRODUCCION'
    	when table_name='control_calidad_cab' then
    					'CONTROL CALIDAD'
    	when table_name='produccion_terminada_cab' then
    					'PRODUCCION TERMINADA'
    	when table_name='mermas_cab' then
    					'MERMAS'
    	when table_name='costo_produccion_cab' then
    					'COSTO PRODUCCION'
    	when table_name='pedido_venta' then
    					'PEDIDO VENTA'
    	when table_name='apertura_cierre' then
    					'APERTURA CIERRE'
    	when table_name='venta_cab' then
    					'VENTA'
    	when table_name='cobro_cab' then
    					'COBRO'
    	when table_name='nota_venta_cab' then
    					'NOTA VENTA'
    	when table_name='pedido_presupuesto' then
    					'REPORTE REFERENCIAL SEGURIDAD'
    	when table_name='presupuesto_orden' then
    					'REPORTE REFERENCIAL COMPRAS'
    	when table_name='orden_compra' then
    					'REPORTE MOVIMIENTO COMPRAS'
    	when table_name='cuenta_pagar' then
    					'REPORTE REFERENCIAL PRODUCCION'
    	when table_name='libro_compra' then
    					'REPORTE MOVIMIENTO PRODUCCION'
    	when table_name='cuenta_cobrar' then
    					'REPORTE REFERENCIAL VENTAS'
    	when table_name='libro_venta' then
    					'REPORTE MOVIMIENTO VENTAS'
    	else 'NER'
     end) as gui_referencial,
     --URL de las tablas a mostrar dentro de la carpeta sys8DD
     (case 
    	when table_name='asignacion_permiso_usuario' then
    					'/sys8DD/referenciales/seguridad/asignacion_permiso_usuario/index.php'
    	when table_name='caja' then
    					'/sys8DD/referenciales/venta/caja/index.php'
    	when table_name='cargo' then
    					'/sys8DD/referenciales/produccion/cargo/index.php'
    	when table_name='ciudad' then
    					'/sys8DD/referenciales/compra/ciudad/index.php'
    	when table_name='cliente' then
    					'/sys8DD/referenciales/venta/clientes/index.php'
    	when table_name='color_prenda' then
    					'/sys8DD/referenciales/produccion/color_prenda/index.php'
    	when table_name='configuraciones' then
    					'/sys8DD/referenciales/seguridad/configuraciones/index.php'
    	when table_name='configuraciones_sucursal' then
    					'/sys8DD/referenciales/seguridad/configuraciones_sucursal/index.php'
    	when table_name='deposito' then
    					'/sys8DD/referenciales/compra/deposito/index.php'
    	when table_name='empresa' then
    					'/sys8DD/referenciales/compra/empresa/index.php'
    	when table_name='entidad_adherida' then
    					'/sys8DD/referenciales/venta/entidad_adherida/index.php'
    	when table_name='entidad_emisora' then
    					'/sys8DD/referenciales/venta/entidad_emisora/index.php'
    	when table_name='equipo_trabajo' then
    					'/sys8DD/referenciales/produccion/equipo_trabajo/index.php'
    	when table_name='forma_cobro' then
    					'/sys8DD/referenciales/venta/forma_cobro/index.php'
    	when table_name='timbrados' then
    					'/sys8DD/referenciales/venta/timbrados/index.php'
    	when table_name='funcionario' then
    					'/sys8DD/referenciales/produccion/funcionario/index.php'
    	when table_name='funcionario_proveedor' then
    					'/sys8DD/referenciales/compra/funcionario_proveedor/index.php'
    	when table_name='gui' then
    					'/sys8DD/referenciales/seguridad/gui/index.php'
    	when table_name='items' then
    					'/sys8DD/referenciales/compra/items/index.php'
    	when table_name='maquinaria' then
    					'/sys8DD/referenciales/produccion/maquinaria/index.php'
    	when table_name='marca_tarjeta' then
    					'/sys8DD/referenciales/venta/marca_tarjeta/index.php'
    	when table_name='modelo' then
    					'/sys8DD/referenciales/produccion/modelo/index.php'
    	when table_name='modulo' then
    					'/sys8DD/referenciales/seguridad/modulo/index.php'
    	when table_name='parametro_control_calidad' then
    					'/sys8DD/referenciales/produccion/parametro_control_calidad/index.php'
    	when table_name='perfil' then
    					'/sys8DD/referenciales/seguridad/perfil/index.php'
    	when table_name='perfil_gui' then
    					'/sys8DD/referenciales/seguridad/perfil_gui/index.php'
    	when table_name='perfiles_permisos' then
    					'/sys8DD/referenciales/seguridad/perfiles_permisos/index.php'
    	when table_name='permisos' then
    					'/sys8DD/referenciales/seguridad/permisos/index.php'
    	when table_name='personas' then
    					'/sys8DD/referenciales/produccion/personas/index.php'
    	when table_name='proveedor' then
    					'/sys8DD/referenciales/compra/proveedor/index.php'
    	when table_name='red_pago' then
    					'/sys8DD/referenciales/venta/red_pago/index.php'
    	when table_name='seccion' then
    					'/sys8DD/referenciales/produccion/seccion/index.php'
    	when table_name='sucursal' then
    					'/sys8DD/referenciales/compra/sucursal/index.php'
    	when table_name='talle' then
    					'/sys8DD/referenciales/produccion/talle/index.php'
    	when table_name='tipo_comprobante' then
    					'/sys8DD/referenciales/venta/tipo_comprobante/index.php'
    	when table_name='tipo_documento' then
    					'/sys8DD/referenciales/venta/tipo_documento/index.php'
    	when table_name='tipo_etapa_produccion' then
    					'/sys8DD/referenciales/produccion/tipo_etapa_produccion/index.php'
    	when table_name='tipo_impuesto' then
    					'/sys8DD/referenciales/compra/tipo_impuesto/index.php'
    	when table_name='tipo_item' then
    					'/sys8DD/referenciales/compra/tipo_item/index.php'
    	when table_name='tipo_proveedor' then
    					'/sys8DD/referenciales/compra/tipo_proveedor/index.php'
    	when table_name='unidad_medida' then
    					'/sys8DD/referenciales/produccion/talle/index.php'
    	when table_name='usuario' then
    					'/sys8DD/referenciales/seguridad/usuario/index.php'
    	when table_name='pedido_compra_cab' then
    					'/sys8DD/modulos/compra/pedido_compra/index.php'
    	when table_name='presupuesto_proveedor_cab' then
    					'/sys8DD/modulos/compra/presupuesto_proveedor/index.php'
    	when table_name='orden_compra_cab' then
    					'/sys8DD/modulos/compra/orden_compra/index.php'
    	when table_name='compra_cab' then
    					'/sys8DD/modulos/compra/compra/index.php'
    	when table_name='ajuste_stock_cab' then
    					'/sys8DD/modulos/compra/ajuste_stock/index.php'
    	when table_name='nota_compra_cab' then
    					'/sys8DD/modulos/compra/nota_compra/index.php'
    	when table_name='presupuesto_cab' then
    					'/sys8DD/modulos/produccion/presupuesto/index.php'
    	when table_name='componente_produccion_cab' then
    					'/sys8DD/modulos/produccion/componente_produccion/index.php'
    	when table_name='orden_produccion_cab' then
    					'/sys8DD/modulos/produccion/orden_produccion/index.php'
    	when table_name='produccion_cab' then
    					'/sys8DD/modulos/produccion/produccion/index.php'
    	when table_name='etapa_produccion' then
    					'/sys8DD/modulos/produccion/etapa_produccion/index.php'
    	when table_name='control_calidad_cab' then
    					'/sys8DD/modulos/produccion/control_calidad/index.php'
    	when table_name='produccion_terminada_cab' then
    					'/sys8DD/modulos/produccion/produccion_terminada/index.php'
    	when table_name='mermas_cab' then
    					'/sys8DD/modulos/produccion/mermas/index.php'
    	when table_name='costo_produccion_cab' then
    					'/sys8DD/modulos/produccion/costo_produccion/index.php'
    	when table_name='pedido_venta' then
    					'/sys8DD/modulos/venta/pedido_venta/index.php'
    	when table_name='apertura_cierre' then
    					'/sys8DD/modulos/venta/apertura_cierre/index.php'
    	when table_name='venta_cab' then
    					'/sys8DD/modulos/venta/venta/index.php'
    	when table_name='cobro_cab' then
    					'/sys8DD/modulos/venta/cobros/index.php'
    	when table_name='nota_venta_cab' then
    					'/sys8DD/modulos/venta/nota_venta/index.php'
    	when table_name='pedido_presupuesto' then
    					'/sys8DD/report/seguridad/informe_referencial.php'
    	when table_name='presupuesto_orden' then
    					'/sys8DD/report/compras/informe_referencial.php'
    	when table_name='orden_compra' then
    					'/sys8DD/report/compras/informe_movimiento.php'
    	when table_name='cuenta_pagar' then
    					'/sys8DD/report/produccion/informe_referencial.php'
    	when table_name='libro_compra' then
    					'/sys8DD/report/produccion/informe_movimiento.php'
    	when table_name='cuenta_cobrar' then
    					'/sys8DD/report/ventas/informe_referencial.php'
    	when table_name='libro_venta' then
    					'/sys8DD/report/ventas/informe_movimiento.php'
    	else 'NER'
     end) as gui_link
--Consltamos las tablas del esquema del sistema
from information_schema.tables 
where 
	--Validamos que solo se consulte solo las tablas de usuario
	table_schema not in ('pg_catalog', 'information_schema') 
	--Validamos solo traer las tablas que se crean con el CREATE TABLE
	and table_type in('BASE TABLE', 'VIEW')
	--Validamos traer solo las tablas de la base de datos sys8DD
	and table_catalog = 'sys8DD';

select * from v_nota_venta_det vnvd where vnvd.notven_codigo=1;
create or replace view v_nota_venta_det as
select 
	nvd.*, 
	(case 
			nvd.tipit_codigo
	     when 2
	        then 
	         	i.it_descripcion||' '||m.mod_codigomodelo
	        else 
	         	i.it_descripcion 
     end) it_descripcion,
    t.tall_descripcion,
    um.unime_descripcion,
    d.dep_descripcion,
	(case i.tipim_codigo when 1 then nvd.notvendet_cantidad * nvd.notvendet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then nvd.notvendet_cantidad * nvd.notvendet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then nvd.notvendet_cantidad * nvd.notvendet_precio else 0 end) as exenta
from nota_venta_det nvd
   join nota_venta_cab nvc on nvc.notven_codigo=nvd.notven_codigo
   join items i on i.it_codigo=nvd.it_codigo
   and i.tipit_codigo=nvd.tipit_codigo
   		join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
   		join talle t on t.tall_codigo=i.tall_codigo
   		join modelo m on m.mod_codigo=i.mod_codigo
   		join unidad_medida um on um.unime_codigo=i.unime_codigo
   join deposito d on d.dep_codigo=nvd.dep_codigo 
   and d.suc_codigo=nvd.suc_codigo 
   and d.emp_codigo=nvd.emp_codigo 
   join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
order by nvd.notven_codigo, nvd.it_codigo;

select * from v_nota_venta_cab vnvc where vnvc.notven_estado <> 'ANULADO';
create or replace view v_nota_venta_cab as
select 
	nvc.*,
	tc.tipco_descripcion,
	p.per_nombre||' '||p.per_apellido as cliente,
	vc.ven_numfactura,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	p.per_numerodocumento
from nota_venta_cab nvc
	join venta_cab vc on vc.ven_codigo=nvc.ven_codigo
	join tipo_comprobante tc on tc.tipco_codigo=nvc.tipco_codigo
	join sucursal s on s.suc_codigo=nvc.suc_codigo
	and s.emp_codigo=nvc.emp_codigo
		join empresa e on e.emp_codigo=s.emp_codigo
	join usuario u on u.usu_codigo=nvc.usu_codigo
	join cliente c on c.cli_codigo=nvc.cli_codigo
		join personas p on p.per_codigo=c.per_codigo
order by nvc.notven_codigo;


select * from v_cobro_det vcd where vcd.cob_codigo=1;

create or replace view v_cobro_det as
select
	cd.cob_codigo, 
	vc.ven_numfactura as factura,
	p.per_nombre||' '||p.per_apellido as cliente,
	p.per_numerodocumento as ci,
	fc.forco_descripcion,
	cd.cobdet_numerocuota,
	cd.cobdet_monto,
	vc.ven_cuota as cuota,
	cc.cuenco_saldo as saldo,
	cd.cobdet_codigo,
	cc.ven_codigo,
	vc.ven_montocuota,
	vc.ven_interfecha,
	cd.forco_codigo,
	ct.cobta_numero,
	ct.cobta_monto,
	ct.cobta_tipotarjeta,
	ct.entad_codigo,
	ct.ent_codigo,
	ct.marta_codigo,
	ct.cobta_transaccion,
	rp.redpa_codigo,
	rp.redpa_descripcion,
	cc2.coche_numero,
	cc2.coche_monto,
	cc2.coche_tipocheque,
	cc2.coche_fechavencimiento,
	cc2.ent_codigo as ent_codigo2,
	ee.ent_razonsocial,
	mt.marta_descripcion,
	ee2.ent_razonsocial as ent_razonsocial2,
	cc.cuenco_monto
from cobro_det cd
	join cobro_cab cc3 on cc3.cob_codigo=cd.cob_codigo
	join cuenta_cobrar cc on cc.ven_codigo=cd.ven_codigo
	join venta_cab vc on vc.ven_codigo=cc.ven_codigo
	join cliente c on c.cli_codigo=vc.cli_codigo
	join personas p on p.per_codigo=c.per_codigo
	join forma_cobro fc on fc.forco_codigo=cd.forco_codigo
		left join cobro_tarjeta ct on ct.cob_codigo=cd.cob_codigo 
		and ct.ven_codigo=cd.ven_codigo
		and ct.cobdet_codigo=cd.cobdet_codigo
		left join entidad_adherida ea on ea.entad_codigo=ct.entad_codigo
		and ea.ent_codigo=ct.ent_codigo
		and ea.marta_codigo=ct.marta_codigo
		left join entidad_emisora ee on ee.ent_codigo=ea.ent_codigo
		left join marca_tarjeta mt on mt.marta_codigo=ea.marta_codigo
		left join red_pago rp on rp.redpa_codigo=ct.redpa_codigo 
		left join cobro_cheque cc2 on cc2.cob_codigo=cd.cob_codigo
		and cc2.ven_codigo=cd.ven_codigo
		and cc2.cobdet_codigo=cd.cobdet_codigo
		left join entidad_emisora ee2 on ee2.ent_codigo=cc2.ent_codigo
order by cd.cobdet_codigo;

select * from v_cobro_cab;
select * from v_cobro_cab vcc where vcc.cob_estado <> 'ANULADO';
create or replace view v_cobro_cab as
select 
	cc.cob_codigo,
	cc.cob_fecha,
	c.caj_descripcion,
	u.usu_login,
	e.emp_razonsocial,
	s.suc_descripcion,
	cc.cob_estado
from cobro_cab cc
	join apertura_cierre ac on ac.apercie_codigo=cc.apercie_codigo
	join caja c on c.caj_codigo=ac.caj_codigo
	join sucursal s on s.suc_codigo=ac.suc_codigo
	and s.emp_codigo=ac.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
	join usuario u on u.usu_codigo=ac.usu_codigo
order by cc.cob_codigo;

select * from v_venta_det where ven_codigo=1;
select * from v_venta_det vvd where vvd.ven_codigo=1;
create or replace view v_venta_det as
select 
	vd.*,
	(case 
		vd.tipit_codigo 
     when 2
        then 
         	i.it_descripcion||' '||m.mod_codigomodelo
         else 
         	i.it_descripcion 
     end) as item,
	t.tall_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	d.dep_descripcion,
	i.tipim_codigo,
	ti.tipit_descripcion,
	(case i.tipim_codigo when 1 then vd.vendet_cantidad * vd.vendet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then vd.vendet_cantidad * vd.vendet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then vd.vendet_cantidad * vd.vendet_precio else 0 end) as exenta
from venta_det vd
	join stock s on s.it_codigo=vd.it_codigo
	and s.tipit_codigo=vd.tipit_codigo
	and s.dep_codigo=vd.dep_codigo 
	and s.suc_codigo=vd.suc_codigo
	and s.emp_codigo=vd.emp_codigo
		join items i on i.it_codigo=s.it_codigo
		and i.tipit_codigo=s.tipit_codigo
			join modelo m on m.mod_codigo=i.mod_codigo
			join talle t on t.tall_codigo=i.tall_codigo
			join unidad_medida um on um.unime_codigo=i.unime_codigo
			join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
		join deposito d on d.dep_codigo=s.dep_codigo 
		and d.suc_codigo=s.suc_codigo
		and d.emp_codigo=s.emp_codigo
			join sucursal su on su.suc_codigo=d.suc_codigo
			and su.emp_codigo=d.emp_codigo
				join empresa e on e.emp_codigo=su.emp_codigo 
order by vd.ven_codigo, i.it_codigo;

select * from v_venta_cab vvc where vvc.ven_estado <> 'ANULADO';
create or replace view v_venta_cab as
select 
	vc.*,
	p.per_numerodocumento,
	p.per_nombre||' '||p.per_apellido as cliente,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	pv.peven_codigo
from venta_cab vc
	join pedido_venta pv on pv.ven_codigo=vc.ven_codigo
	join usuario u on u.usu_codigo=vc.usu_codigo
	join cliente c on c.cli_codigo=vc.cli_codigo
		join personas p on p.per_codigo=c.per_codigo
	join sucursal s on s.suc_codigo=vc.suc_codigo 
	and s.emp_codigo=vc.emp_codigo
		join empresa e on e.emp_codigo=s.emp_codigo 
order by vc.ven_codigo;

create or replace view v_etapa_produccion as
select 
	ep.*,
	i.it_descripcion||' '||mo.mod_codigomodelo it_descripcion,
	t.tall_descripcion,
	tep.tipet_descripcion,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	ma.maq_descripcion
from etapa_produccion ep
	join orden_produccion_det opd on opd.orpro_codigo=ep.orpro_codigo
	and opd.it_codigo=ep.it_codigo
	and opd.tipit_codigo=ep.tipit_codigo
	join items i on i.it_codigo=opd.it_codigo 
	and i.tipit_codigo=opd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join modelo mo on mo.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
	join tipo_etapa_produccion tep on tep.tipet_codigo=ep.tipet_codigo
	join usuario u on u.usu_codigo=ep.usu_codigo
	join sucursal s on s.suc_codigo=ep.suc_codigo
	and s.emp_codigo=ep.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
	join maquinaria ma on ma.maq_codigo=ep.maq_codigo
order by ep.orpro_codigo;

select * from v_etapa_produccion;

create or replace view v_produccion_det as 
select 
	pd.*,
	i.it_descripcion||' '||m.mod_codigomodelo as it_descripcion,
	ti.tipit_descripcion,
	t.tall_descripcion
from produccion_det pd
	join items i on i.it_codigo=pd.it_codigo
	and i.tipit_codigo=pd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
order by pd.prod_codigo;

select * from v_produccion_det where prod_codigo=1;

create or replace view v_produccion_cab as
select 
	pc.*,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	sec.secc_descripcion
from produccion_cab pc
	join orden_produccion_cab opc on opc.orpro_codigo=pc.orpro_codigo
	join seccion sec on sec.secc_codigo=opc.secc_codigo 
	join usuario u on u.usu_codigo=pc.usu_codigo
	join sucursal s on s.suc_codigo=pc.suc_codigo
	and s.emp_codigo=pc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
order by pc.prod_codigo;

select * from v_produccion_cab;

create or replace view v_orden_produccion_det as
select 
	opd.orpro_codigo,
	opd.it_codigo,
	opd.tipit_codigo,
	opd.orprodet_cantidad,
	opd.dep_codigo,
	opd.suc_codigo,
	opd.emp_codigo,
	d.dep_descripcion,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	t.tall_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	case 
        when opd.orprodet_especificacion is null or opd.orprodet_especificacion = '' 
        then 'SIN ESPECIFICACION' 
        else opd.orprodet_especificacion 
    end as orprodet_especificacion
from orden_produccion_det opd
	join items i on i.it_codigo=opd.it_codigo
	and i.tipit_codigo=opd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
	join unidad_medida um on um.unime_codigo=i.unime_codigo 
	join deposito d on d.dep_codigo=opd.dep_codigo 
	and d.suc_codigo=opd.suc_codigo 
	and d.emp_codigo=opd.emp_codigo 
order by opd.it_codigo ;

select * from v_orden_produccion_det vopd where vopd.orpro_codigo=1;

create or replace view v_orden_produccion_cab as
select 
	opc.orpro_codigo,
	opc.orpro_fecha,
	opc.orpro_fechainicio,
	opc.orpro_fechaculminacion,
	opc.usu_codigo,
	opc.suc_codigo,
	opc.emp_codigo,
	opc.secc_codigo,
	p.per_nombre||' '||p.per_apellido as cliente,
	p.per_numerodocumento,
	op.pres_codigo,
	pc.peven_codigo,
	se.secc_descripcion,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	opc.orpro_estado
from orden_produccion_cab opc
	join usuario u on u.usu_codigo=opc.usu_codigo
	join sucursal s on s.suc_codigo=opc.suc_codigo 
	and s.emp_codigo=opc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
	join seccion se on se.secc_codigo=opc.secc_codigo
	join orden_presupuesto op on op.orpro_codigo=opc.orpro_codigo
	join presupuesto_cab pc on pc.pres_codigo=op.pres_codigo
	join cliente c on c.cli_codigo=pc.cli_codigo
	join personas p on p.per_codigo=c.per_codigo 
order by opc.orpro_codigo;

select * from v_orden_produccion_cab vopc where vopc.orpro_estado <> 'ANULADO';

create or replace view v_presupuesto_det as
select 
	pd.*,
	i.it_descripcion||' '||m.mod_codigomodelo as item,
	t.tall_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	ti.tipit_descripcion,
	(case i.tipim_codigo when 1 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then pd.presdet_cantidad * pd.presdet_precio else 0 end) as exenta
from presupuesto_det pd
join items i on i.it_codigo=pd.it_codigo
and i.tipit_codigo=pd.tipit_codigo
join modelo m on m.mod_codigo=i.mod_codigo
join talle t on t.tall_codigo=i.tall_codigo 
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join unidad_medida um on um.unime_codigo=i.unime_codigo 
order by pd.pres_codigo;

select * from v_presupuesto_det vpd where vpd.pres_codigo=1;

create or replace view v_presupuesto_cab as
select 
	pc.pres_codigo,
	pc.pres_fecharegistro,
	pc.pres_fechavencimiento,
	p.per_nombre||' '||p.per_apellido as cliente,
	p.per_numerodocumento,
	pc.peven_codigo,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	pc.pres_estado 
from presupuesto_cab pc
join usuario u on u.usu_codigo=pc.usu_codigo
join sucursal s on s.suc_codigo=pc.suc_codigo
and s.emp_codigo=pc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
join cliente c on c.cli_codigo=pc.cli_codigo
join personas p on p.per_codigo=c.per_codigo
order by pc.pres_codigo;

select * from v_presupuesto_cab vpc where vpc.pres_estado <> 'ANULADO';

create or replace view v_pedido_produccion_cab as
select 
	ppc.*,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial
from pedido_produccion_cab ppc 
join usuario u on u.usu_codigo=ppc.usu_codigo 
join sucursal s on s.suc_codigo=ppc.suc_codigo and s.emp_codigo=ppc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by ppc.pedpro_codigo;

select * from v_pedido_produccion_cab;

create or replace view v_pedido_produccion_det as
select
	ppd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	(case i.tipim_codigo when 1 then ppd.pedprodet_cantidad * ppd.pedprodet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ppd.pedprodet_cantidad * ppd.pedprodet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ppd.pedprodet_cantidad * ppd.pedprodet_precio else 0 end) as exenta
from pedido_produccion_det ppd 
join items i on i.it_codigo=ppd.it_codigo
and i.tipit_codigo=ppd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
order by ppd.pedpro_codigo;

select * from v_pedido_produccion_det where pedpro_codigo=1;

create or replace view v_nota_compra_det as
select 
	ncd.*,
	i.tipim_codigo,
	i.it_descripcion,
	ti.tipit_descripcion,
	um.unime_descripcion,
	d.dep_descripcion,
	(case i.tipim_codigo when 1 then ncd.nocomdet_cantidad * ncd.nocomdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ncd.nocomdet_cantidad * ncd.nocomdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ncd.nocomdet_cantidad * ncd.nocomdet_precio else 0 end) as exenta
from nota_compra_det ncd
	join items i on i.it_codigo=ncd.it_codigo
	and i.tipit_codigo=ncd.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
	join unidad_medida um on um.unime_codigo=i.unime_codigo
	join deposito d on d.dep_codigo=ncd.dep_codigo
order by ncd.nocom_codigo, ncd.it_codigo;

select * from v_nota_compra_det vncd where vncd.nocom_codigo = 1;

create or replace view v_nota_compra_cab as
select 
	ncc.nocom_codigo,
	ncc.nocom_fecha,
	ncc.nocom_numeronota,
	ncc.nocom_concepto,
	ncc.nocom_estado,
	ncc.tipco_codigo,
	ncc.suc_codigo,
	ncc.emp_codigo,
	ncc.usu_codigo,
	ncc.comp_codigo,
	ncc.pro_codigo,
	ncc.tipro_codigo,
	ncc.nocom_timbrado,
	ncc.nocom_timbrado_venc,
	ncc.nocom_chapa,
	nocom_funcionario,
	tc.tipco_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	u.usu_login,
	cc.comp_numfactura,
	p.pro_razonsocial,
	tp.tipro_descripcion
from nota_compra_cab ncc
	join tipo_comprobante tc on tc.tipco_codigo=ncc.tipco_codigo
	join sucursal s on s.suc_codigo=ncc.suc_codigo
	and s.emp_codigo=ncc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo 
	join usuario u on u.usu_codigo=ncc.usu_codigo
	join compra_cab cc on cc.comp_codigo=ncc.comp_codigo
	join proveedor p on p.pro_codigo=ncc.pro_codigo
	and p.tipro_codigo=ncc.tipro_codigo
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
order by ncc.nocom_codigo;

select * from v_nota_compra_cab vncc where vncc.nocom_estado <> 'ANULADO';

new Intl.NumberFormat("us-US").format(objeto.orcomdet_cantidad);

create or replace view v_compra_det as
select 
	cd.*,
	i.tipim_codigo,
	i.it_descripcion,
	ti.tipit_descripcion,
	d.dep_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	(case i.tipim_codigo when 1 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then cd.compdet_cantidad * cd.compdet_precio else 0 end) as exenta
from compra_det cd
	join stock s on s.it_codigo=cd.it_codigo
	and s.tipit_codigo=cd.tipit_codigo
	and s.dep_codigo=cd.dep_codigo 
	and s.suc_codigo=cd.suc_codigo
	and s.emp_codigo=cd.emp_codigo
	join items i on i.it_codigo=s.it_codigo
	and i.tipit_codigo=s.tipit_codigo
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
	join deposito d on d.dep_codigo=s.dep_codigo
	and d.suc_codigo=s.suc_codigo
	and d.emp_codigo=s.emp_codigo 
	join sucursal su on su.suc_codigo=d.suc_codigo
	and su.emp_codigo=d.emp_codigo
	join empresa e on e.emp_codigo=su.emp_codigo
	join unidad_medida um on um.unime_codigo=i.unime_codigo
order by cd.comp_codigo, cd.it_codigo;

select * from v_compra_det vcd where vcd.comp_codigo=1;

create or replace view v_compra_cab as
select 
	cc.comp_codigo,
	cc.comp_fecha,
	cc.comp_numfactura,
	cc.comp_tipofactura,
	cc.comp_cuota,
	cc.comp_interfecha,
	cc.comp_estado,
	cc.pro_codigo,
	cc.tipro_codigo,
	cc.suc_codigo,
	cc.emp_codigo,
	cc.usu_codigo,
	cc.comp_montocuota,
	cc.comp_timbrado,
	cc.tipco_codigo,
	cc.comp_timbrado_venc,
	p.pro_razonsocial,
	tp.tipro_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	u.usu_login,
	tc.tipco_descripcion ,
	oc.orcom_codigo
from compra_cab cc
	join orden_compra oc on oc.comp_codigo=cc.comp_codigo
	join proveedor p on p.pro_codigo=cc.pro_codigo
	and p.tipro_codigo=cc.tipro_codigo
	join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
	join tipo_comprobante tc on tc.tipco_codigo=cc.tipco_codigo 
	join usuario u on u.usu_codigo=cc.usu_codigo
	join sucursal s on s.suc_codigo=cc.suc_codigo
	and s.emp_codigo=cc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
order by cc.comp_codigo;

select 
         d.dep_codigo,
         d.dep_descripcion
      from deposito d
         where d.suc_codigo=$sucursal 
         and d.emp_codigo=$empresa
         and d.dep_descripcion ilike '%%'
         and d.dep_estado='ACTIVO';

select * from v_compra_cab vcc where vcc.comp_estado <> 'ANULADO';

create or replace view v_pedido_venta_det as
select 
	pvd.*,
	(case 
			pvd.tipit_codigo
	     when 2
	        then 
	         	i.it_descripcion||' '||m.mod_codigomodelo
	        else 
	         	i.it_descripcion 
     end) as item,
	t.tall_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	ti.tipit_descripcion,
	(case i.tipim_codigo when 1 then pvd.pevendet_cantidad * pvd.pevendet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then pvd.pevendet_cantidad * pvd.pevendet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then pvd.pevendet_cantidad * pvd.pevendet_precio else 0 end) as exenta
from pedido_venta_det pvd
	join items i on i.it_codigo=pvd.it_codigo
	and i.tipit_codigo=pvd.tipit_codigo
		join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
		join tipo_impuesto tim on tim.tipim_codigo=i.tipim_codigo
		join modelo m on m.mod_codigo=i.mod_codigo
		join talle t on t.tall_codigo=i.tall_codigo
		join unidad_medida um on um.unime_codigo=i.unime_codigo
order by pvd.peven_codigo;

select * from v_pedido_venta_det vpvd where vpvd.peven_codigo=1;

create or replace view v_pedido_venta_cab as
select 
	pvc.peven_codigo,
	pvc.peven_fecha,
	pvc.peven_estado,
	pvc.suc_codigo,
	pvc.emp_codigo,
	pvc.cli_codigo,
	pvc.usu_codigo,
	p.per_nombre||' '||p.per_apellido as cliente,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial,
	p.per_numerodocumento
from pedido_venta_cab pvc
	join usuario u on u.usu_codigo=pvc.usu_codigo 
	join cliente c on c.cli_codigo=pvc.cli_codigo
	join personas p on p.per_codigo=c.per_codigo
	join sucursal s on s.suc_codigo=pvc.suc_codigo
	and s.emp_codigo=pvc.emp_codigo
	join empresa e on e.emp_codigo=s.emp_codigo
order by pvc.peven_codigo;

select * from v_pedido_venta_cab vpvc where vpvc.peven_estado <> 'ANULADO';

create or replace view v_ajuste_stock_det as
select
	ajust.*,
	(case 
	when i.tipit_codigo in(1, 3, 4)
		then 
			i.it_descripcion 
		else 
			i.it_descripcion||' '||m.mod_codigomodelo||' '||t.tall_descripcion 
	end) as it_descripcion,
	ti.tipit_descripcion,
	d.dep_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	ajust.ajusdet_cantidad*ajust.ajusdet_precio as subtotal
from ajuste_stock_det ajust
	join stock s on s.it_codigo=ajust.it_codigo
	and s.tipit_codigo=ajust.tipit_codigo and
	s.dep_codigo=ajust.dep_codigo and s.suc_codigo=ajust.suc_codigo
	and s.emp_codigo=ajust.emp_codigo
	join items i on i.it_codigo=s.it_codigo 
	and i.tipit_codigo=s.tipit_codigo 
	join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
	join modelo m on m.mod_codigo=i.mod_codigo
	join talle t on t.tall_codigo=i.tall_codigo
	join deposito d on d.dep_codigo=s.dep_codigo and
	d.suc_codigo=s.suc_codigo and d.emp_codigo=s.emp_codigo 
	join unidad_medida um on um.unime_codigo=i.unime_codigo
	order by ajust.ajus_codigo, ajust.it_codigo;

select * from v_ajuste_inventario_det where ajuin_codigo=1;

create or replace view v_ajuste_stock_cab as
select 
	aju.ajus_codigo,
	aju.ajus_fecha,
	aju.ajus_tipoajuste,
	aju.ajus_estado,
	aju.suc_codigo,
	aju.emp_codigo,
	aju.usu_codigo,
	u.usu_login,
	e.emp_razonsocial,
	s.suc_descripcion
from ajuste_stock_cab aju
join usuario u on u.usu_codigo=aju.usu_codigo
join sucursal s on s.suc_codigo=aju.suc_codigo
and s.emp_codigo=aju.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by aju.ajus_codigo;

select * from v_ajuste_inventario_cab vaic where vaic.ajuin_estado <> 'ANULADO';

create or replace view v_orden_compra_cab as
select 
	occ.orcom_codigo,
	occ.orcom_fecha,
	occ.orcom_condicionpago,
	occ.orcom_cuota,
	occ.orcom_montocuota,
	occ.orcom_interfecha,
	occ.pro_codigo,
	occ.orcom_estado,
	p.pro_razonsocial,
	p.pro_email,
	occ.tipro_codigo,
	tp.tipro_descripcion,
	occ.usu_codigo,
	u.usu_login,
	occ.suc_codigo,
	s.suc_descripcion,
	occ.emp_codigo,
	e.emp_razonsocial,
	po.prepro_codigo,
	pepre.pedco_codigo
from orden_compra_cab occ
join usuario u on u.usu_codigo=occ.usu_codigo
join proveedor p on p.pro_codigo=occ.pro_codigo
and p.tipro_codigo=occ.tipro_codigo
join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo
join sucursal s on s.suc_codigo=occ.suc_codigo
and s.emp_codigo=occ.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
join presupuesto_orden po on po.orcom_codigo=occ.orcom_codigo
join pedido_presupuesto pepre on pepre.prepro_codigo=po.prepro_codigo
order by occ.orcom_codigo;

select * from v_orden_compra_cab vocc where vocc.orcom_estado <> 'ANULADO' ;

create or replace view v_orden_compra_det as
select 
	ocd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	(case i.tipim_codigo when 1 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ocd.orcomdet_cantidad * ocd.orcomdet_precio else 0 end) as exenta
from orden_compra_det ocd
join items i on i.it_codigo=ocd.it_codigo 
and i.tipit_codigo=ocd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
join unidad_medida um on um.unime_codigo=i.unime_codigo
order by ocd.orcom_codigo, ocd.it_codigo;

select * from v_orden_compra_det vocd where vocd.orcom_codigo = 1;

create or replace view v_presupuesto_proveedor_cab as
select 
	ppc.prepro_codigo,
	ppc.prepro_fechaactual,
	ppc.prepro_fechavencimiento,
	ppc.prepro_estado,	
	u.usu_login,
	p.pro_razonsocial,
	p.pro_ruc,
	tp.tipro_codigo,
	tp.tipro_descripcion,
	s.suc_descripcion,
	e.emp_razonsocial,
	pp.pedco_codigo,
	ppc.pro_codigo 
from presupuesto_proveedor_cab ppc
join usuario u on u.usu_codigo=ppc.usu_codigo
join proveedor p on p.pro_codigo=ppc.pro_codigo
and p.tipro_codigo=ppc.tipro_codigo
join tipo_proveedor tp on tp.tipro_codigo=p.tipro_codigo 
join sucursal s on s.suc_codigo=ppc.suc_codigo 
and s.emp_codigo=ppc.emp_codigo 
join empresa e on e.emp_codigo=s.emp_codigo
join pedido_presupuesto pp on pp.prepro_codigo=ppc.prepro_codigo
order by ppc.prepro_codigo;

select * from v_presupuesto_proveedor_cab vppc where vppc.prepro_estado <> 'ANULADO';

create or replace view v_presupuesto_proveedor_det as
select
	ppd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	(case i.tipim_codigo when 1 then ppd.peprodet_cantidad * ppd.peprodet_precio else 0 end) as grav5,
	(case i.tipim_codigo when 2 then ppd.peprodet_cantidad * ppd.peprodet_precio else 0 end) as grav10,
	(case i.tipim_codigo when 3 then ppd.peprodet_cantidad * ppd.peprodet_precio else 0 end) as exenta
from presupuesto_proveedor_det ppd 
join items i on i.it_codigo=ppd.it_codigo
and i.tipit_codigo=ppd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
join unidad_medida um on um.unime_codigo=i.unime_codigo
order by ppd.prepro_codigo, ppd.it_codigo;

select * from v_presupuesto_proveedor_det where prepro_codigo = 1;

select 
*
from solicitud_presupuesto_det spd 

select 
	pcc.pedco_codigo,
	pcc.pedco_fecha,
	pcc.pedco_estado,
	pcc.suc_codigo,
	pcc.emp_codigo,
	pcc.usu_codigo,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial
from pedido_compra_cab pcc 
join usuario u on u.usu_codigo=pcc.usu_codigo
join funcionario f on f.func_codigo=u.func_codigo
join personas p on p.per_codigo=f.per_codigo 
join sucursal s on s.suc_codigo=pcc.suc_codigo and s.emp_codigo=pcc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by pcc.pedco_codigo;

create or replace view v_pedido_compra_cab as
select 
	pcc.pedco_codigo,
	pcc.pedco_fecha,
	pcc.pedco_estado,
	pcc.suc_codigo,
	pcc.emp_codigo,
	pcc.usu_codigo,
	u.usu_login,
	s.suc_descripcion,
	e.emp_razonsocial
from pedido_compra_cab pcc 
join usuario u on u.usu_codigo=pcc.usu_codigo
join funcionario f on f.func_codigo=u.func_codigo
join personas p on p.per_codigo=f.per_codigo 
join sucursal s on s.suc_codigo=pcc.suc_codigo and s.emp_codigo=pcc.emp_codigo
join empresa e on e.emp_codigo=s.emp_codigo
order by pcc.pedco_codigo;

select * from v_pedido_compra_cab vpcc where vpcc.pedco_estado <> 'ANULADO';

select 
	spd.it_codigo as it_codigo2,
	spd.tipit_codigo as tipit_codigo2,
	i.it_descripcion as it_descripcion2,
	spd.solpredet_cantidad,
	ti.tipit_descripcion as tipit_descripcion2,
	um.unime_descripcion as unime_descripcion2
from solicitud_presupuesto_det spd 
	join items i on i.it_codigo=spd.it_codigo 
	and i.tipit_codigo=spd.tipit_codigo 
		join tipo_item ti on ti.tipit_codigo=i.tipit_codigo 
		join unidad_medida um on um.unime_codigo=i.unime_codigo 
where spd.solpre_codigo=1
order by spd.solpre_codigo, spd.it_codigo;

create or replace view v_pedido_compra_det as
select
	pcd.*,
	i.it_descripcion,
	ti.tipit_descripcion,
	um.unime_codigo,
	um.unime_descripcion,
	pcd.pedcodet_cantidad*pcd.pedcodet_precio as subtotal
from pedido_compra_det pcd 
join items i on i.it_codigo=pcd.it_codigo
and i.tipit_codigo=pcd.tipit_codigo
join tipo_item ti on ti.tipit_codigo=i.tipit_codigo
join tipo_impuesto ti2 on ti2.tipim_codigo=i.tipim_codigo
join unidad_medida um on um.unime_codigo=i.unime_codigo
order by pcd.pedco_codigo, pcd.it_codigo;

select 
         c.caj_codigo, 
         c.caj_descripcion
      from caja c
         where c.caj_descripcion ilike '%ca%' and c.caj_estado = 'ACTIVO';
        
select * from cargo c where c.car_descripcion ilike '%%' and c.car_estado = 'ACTIVO';

select * from v_pedido_compra_det vpcd where vpcd.pedco_codigo=1;

select * from ciudad c where c.ciu_descripcion ilike '%$ciudad%' and c.ciu_estado = 'ACTIVO';

select
      c.cli_codigo,
      p.per_numerodocumento,
      p.per_nombre||''||p.per_apellido as cliente
   from cliente c
      join personas p on p.per_codigo=c.per_codigo
      where p.per_numerodocumento ilike '%$cliente%' and c.cli_estado='ACTIVO'
   order by c.cli_codigo;
  
select * from color_prenda cp where cp.col_descripcion ilike '%$color%' and cp.col_estado = 'ACTIVO';

select * from empresa where emp_razonsocial ilike '%$empresa%' and emp_estado = 'ACTIVO';

select * from entidad_emisora where ent_razonsocial ilike '%$empresa%' and ent_estado = 'ACTIVO';

select 
	*, 
	it_costo as pedcodet_precio 
from items 
where 
	it_descripcion ilike '%$item%' 
	and tipit_codigo <> 2
	and it_estado = 'ACTIVO'
order by it_codigo;

select 
            f.func_codigo,
            p.per_nombre||' '||p.per_apellido as funcionario,
            p.per_numerodocumento,
            f.suc_codigo,
            f.emp_codigo 
        from funcionario f
            join personas p on p.per_codigo=f.per_codigo
            where p.per_numerodocumento ilike '%$funcionario%' and f.func_estado = 'ACTIVO';
           
select * from forma_cobro where forco_estado = 'ACTIVO' order by forco_codigo;

select 
         f.func_codigo,
         p.per_nombre||' '||p.per_apellido as funcionario,
         p.per_numerodocumento
      from funcionario f
         join personas p on p.per_codigo=f.per_codigo
         where p.per_numerodocumento ilike '%$per_numerodocumento%'
         and f.func_estado = 'ACTIVO';
        
select 
            g.*,
            m.modu_descripcion 
         from gui g
         join modulo m on m.modu_codigo=g.modu_codigo 
         where g.gui_descripcion ilike '%$gui%' and g.gui_estado = 'ACTIVO';
        
select * from maquinaria where maq_descripcion ilike '%$maquinaria%' and maq_estado = 'ACTIVO' order by maq_codigo;

select * from marca_tarjeta where marta_descripcion ilike '%$empresa%' and marta_estado = 'ACTIVO';

select * from modelo m where m.mod_codigomodelo ilike '%$modelo%' and m.mod_estado = 'ACTIVO';

select * from modulo m where m.modu_estado = 'ACTIVO';

select * from perfil where perf_descripcion ilike '%$perfil%' and perf_estado = 'ACTIVO';

select distinct pp.perf_codigo, p.perf_descripcion 
      from perfiles_permisos pp 
      join perfil p on pp.perf_codigo=p.perf_codigo 
      where p.perf_descripcion ilike '%$perfil%' and pp.perfpe_estado = 'ACTIVO';
     
select 
	pp.perm_codigo, 
	pp.perfpe_codigo, 
	p.perm_descripcion 
from perfiles_permisos pp 
	join permisos p on p.perm_codigo=pp.perm_codigo 
where pp.perf_codigo=$perfil and pp.perfpe_estado = 'ACTIVO';

select * from permisos where perm_descripcion ilike '%$permiso%' and perm_estado = 'ACTIVO';

select
            p.per_codigo,
            p.per_nombre||' '||p.per_apellido as persona,
            p.per_numerodocumento 
      from personas p
            where p.per_numerodocumento like '%$persona%' and p.per_estado = 'ACTIVO';
           
select 
         s.secc_codigo,
         s.secc_descripcion
      from seccion s 
         where (s.suc_codigo=$sucursal and s.emp_codigo=$empresa) and s.secc_estado = 'ACTIVO';
        
select 
	s.suc_codigo, 
	s.suc_descripcion 
from sucursal s 
where s.emp_codigo = $empresa and s.suc_estado = 'ACTIVO';

select * from talle t where t.tall_descripcion ilike '%$talle%' and t.tall_estado = 'ACTIVO';

select *
      from tipo_comprobante tc
         where tc.tipco_descripcion ilike '%$tipoComprobante%'
         and tc.tipco_estado = 'ACTIVO'
      order by tc.tipco_codigo;
     
select * from tipo_documento where tipdo_descripcion ilike '%$tipoDocumento%' and tipdo_estado = 'ACTIVO';

select * from tipo_etapa_produccion where tipet_descripcion ilike '%$etapa%' and tipet_estado = 'ACTIVO' order by tipet_codigo;

select 
	* 
from tipo_impuesto ti 
	where ti.tipim_descripcion ilike '%%'
	and ti.tipim_estado = 'ACTIVO';

select 
	* 
from tipo_item ti 
	where ti.tipit_descripcion ilike '%$tipoItem%'
	and ti.tipit_estado = 'ACTIVO'; 

select 
	* 
from tipo_proveedor tp 
	where tp.tipro_descripcion ilike '%$tipoProveedor%'
	and tp.tipro_estado = 'ACTIVO';

select 
	* 
from unidad_medida um 
	where um.unime_descripcion ilike '%$unidad%'
	and um.unime_estado = 'ACTIVO';

select 
            u.usu_codigo, 
            u.usu_login, 
            u.perf_codigo, 
            p.perf_descripcion 
         from usuario u 
            join perfil p on p.perf_codigo=u.perf_codigo 
         where usu_login ilike '%$usuario%' 
         and u.usu_estado = 'ACTIVO';

--DDL
alter table acceso add column acc_ip varchar not null;  
alter table acceso add column acc_ip_region varchar not null;  
alter table acceso add column acc_ip_ciudad varchar not null;

alter table acceso_control add column accon_ip_pais varchar not null;
alter table acceso_control add column accon_ip_region varchar not null;
alter table acceso_control add column accon_ip_ciudad varchar not null;

alter table actualizacion_contrasenia add column accontra_ip_pais varchar not null;
alter table actualizacion_contrasenia add column accontra_ip_region varchar not null;
alter table actualizacion_contrasenia add column accontra_ip_ciudad varchar not null;
        
ALTER TABLE cuenta_pagar RENAME COLUMN cuenpa_montototal TO cuenpa_monto;
ALTER TABLE cuenta_pagar RENAME COLUMN cuenpa_montosaldo TO cuenpa_saldo;

ALTER TABLE cuenta_cobrar RENAME COLUMN cuenco_montototal TO cuenco_monto;
ALTER TABLE cuenta_cobrar RENAME COLUMN cuenco_montosaldo TO cuenco_saldo;

alter table orden_compra_cab add column orcom_montocuota numeric;
ALTER TABLE orden_compra_cab ALTER COLUMN orcom_montocuota SET NOT NULL;

alter table compra_cab add column comp_montocuota numeric;
ALTER TABLE compra_cab ALTER COLUMN comp_montocuota SET NOT NULL;

ALTER TABLE compra_cab ALTER COLUMN comp_montocuota SET NOT NULL;

alter table items add constraint unidad_medida_items_fk
foreign key (unime_codigo)
references unidad_medida (unime_codigo)
on delete restrict
on update cascade;

alter table items add column unime_codigo integer;
alter table ciudad add column ciu_audit text;
alter table deposito add column dep_audit text;
alter table empresa add column emp_audit text;
alter table items add column it_audit text;
alter table proveedor add column pro_audit text;
alter table tipo_impuesto add column tipim_audit text;
alter table sucursal add column suc_email varchar;
alter table sucursal add column suc_audit varchar;
alter table tipo_item add column tipit_audit text;
alter table tipo_proveedor add column tipro_audit text;
alter table tipo_comprobante add column tipco_audit text;
alter table tipo_documento add column tipdo_audit text;
alter table caja add column caj_audit text;
alter table forma_cobro add column forco_audit text;
alter table cliente add column cli_audit text;
alter table tipo_proveedor add column tipro_audit text;
alter table entidad_adherida add column entad_audit text;
alter table entidad_emisora add column ent_audit text;
alter table marca_tarjeta add column marta_audit text;
alter table asignacion_permiso_usuario add column asigperm_audit text;
alter table gui add column gui_audit text;
alter table modulo add column modu_audit text;
alter table perfil add column perf_audit text;
alter table perfil_gui add column perfgui_audit text;
alter table permisos add column perm_audit text;
alter table perfiles_permisos add column perfpe_audit text;
alter table usuario add column usu_audit text;
alter table cargo add column car_audit text;
alter table personas add column per_audit text;
alter table talle add column tall_audit text;
alter table color_prenda add column col_audit text;
alter table funcionario add column func_audit text;
alter table modelo add column mod_audit text;
alter table maquinaria add column maq_audit text;
alter table tipo_etapa_produccion add column tipet_audit text;
alter table unidad_medida add column unime_simbolo text;
alter table unidad_medida add column unime_audit text;
alter table parametro_control_calidad add column pacoca_audit text;
alter table seccion add column secc_audit text;
alter table equipo_trabajo add column eqtra_audit text;
alter table pedido_compra_cab add column pedco_audit text;
alter table presupuesto_proveedor_cab add column prepro_audit text;
alter table pedido_presupuesto add column pedpre_audit text;
alter table orden_compra_cab add column orcom_audit text;
alter table presupuesto_orden add column presor_audit text;
alter table compra_cab add column comp_audit text;
alter table cuenta_pagar add column cuenpa_audit text;
alter table libro_compra add column licom_audit text;
alter table orden_compra add column ordencom_audit text;
alter table ajuste_inventario_cab add column ajuin_audit text;
alter table ajuste_inventario_det add column ajuindet_precio numeric;
alter table empresa add column emp_timbrado varchar;
alter table proveedor add column pro_timbrado varchar;
alter table compra_cab add column comp_timbrado varchar;
alter table nota_compra_cab add column nocom_audit text;
alter table nota_compra_det add column dep_codigo integer;
alter table nota_compra_det add column suc_codigo integer;
alter table nota_compra_det add column emp_codigo integer;
alter table libro_compra add column tipco_codigo integer;
alter table libro_compra add column licom_numcomprobante varchar;
alter table libro_compra add column licom_estado varchar;
alter table libro_compra add column licom_audit text;
alter table pedido_venta_cab add column peven_audit text;
alter table presupuesto_cab add column pres_audit text;
alter table orden_produccion_cab add column orpro_audit text;
alter table orden_presupuesto add column orpre_audit text;
alter table orden_produccion_det add column dep_codigo integer;
alter table orden_produccion_det add column suc_codigo integer;
alter table orden_produccion_det add column emp_codigo integer;
alter table orden_produccion_det add column emp_codigo integer;
alter table produccion_cab add column prod_audit text;
alter table produccion_det add column prodet_estado varchar;
alter table venta_cab add column tipco_codigo integer;
alter table libro_venta add column tipco_codigo integer;
alter table cuenta_cobrar add column tipco_codigo integer;
alter table venta_cab add column ven_timbrado varchar;
alter table cobro_cab add column tipco_codigo integer;
alter table cobro_cab_auditoria add column tipco_codigo integer;
alter table cobro_tarjeta add column cobta_transaccion varchar;
alter table cobro_tarjeta add column redpa_codigo integer;
alter table cobro_tarjeta_auditoria add column cobta_transaccion varchar;
alter table nota_venta_det add column dep_codigo integer;
alter table nota_venta_det add column suc_codigo integer;
alter table nota_venta_det add column emp_codigo integer;
alter table empresa add column emp_timbrado_fec_inic date;
alter table empresa add column emp_timbrado_fec_venc date;
alter table items add column it_stock_min numeric;
alter table items add column it_stock_max numeric;
alter table proveedor add column pro_timbrado_venc date;
alter table compra_cab add column comp_timbrado_venc date;
alter table stock add column st_audit text;
alter table nota_compra_cab add column nocom_timbrado varchar;
alter table nota_compra_cab add column nocom_timbrado_venc date;
alter table nota_compra_cab add column nocom_chapa varchar;
alter table nota_compra_cab add column nocom_funcionario integer;

select now(); 

ALTER TABLE compra_cab RENAME COLUMN com_numfactura TO comp_numfactura;

update items set unime_codigo = 1;

ALTER TABLE ciudad ALTER COLUMN ciu_audit SET NOT NULL;

alter table stock drop constraint unidad_medida_stock_fk;

alter table stock drop column unime_codigo;

select tc.constraint_name from information_schema.table_constraints tc where tc.table_name='items';

ALTER TABLE cobro_cab ALTER COLUMN cob_fecha TYPE timestamp USING cob_fecha::timestamp;

ALTER TABLE cobro_cheque ALTER COLUMN coche_tipocheque TYPE tipo_cheque2 USING coche_tipocheque::tipo_cheque2;

alter table perfiles_permisos add column perfpe_codigo integer;
alter table perfiles_permisos add constraint perfiles_permisos_pk primary key(perfpe_codigo); 

ALTER TABLE venta_det 
ADD PRIMARY KEY (ven_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo);

ALTER TABLE venta_cab_auditoria 
ADD PRIMARY KEY (venaud_codigo);

create type sexo as enum('M', 'F');
create type condicion_pago as enum('CONTADO', 'CREDITO');
create type condicion_pago as enum('CONTADO', 'CREDITO');
create type tipo_cheque as enum('A LA VISTA', 'DIFERIDO');
create type tipo_cheque2 as enum('A LA VISTA', 'DIFERIDOSssss');
create type tipo_ajuste as enum('POSITIVO', 'NEGATIVO');
create type tipo_factura as enum('CONTADO', 'CREDITO');

drop table modelo;
select g.*, m.modu_descripcion  from gui g join modulo m on m.modu_codigo = g.modu_codigo;