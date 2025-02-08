--Ya agregado referencial produccion
CREATE TABLE unidad_medida (
                unime_codigo INTEGER NOT NULL,
                unime_descripcion VARCHAR NOT NULL,
                unime_estado VARCHAR NOT NULL,
                CONSTRAINT unidad_medida_pk PRIMARY KEY (unime_codigo)
);

--Ya agregado referencial seguridad
CREATE TABLE acceso (
                acc_codigo INTEGER NOT NULL,
                acc_usuario VARCHAR NOT NULL,
                acc_fechahora TIMESTAMP NOT NULL,
                acc_obs VARCHAR NOT NULL,
                CONSTRAINT acceso_pk PRIMARY KEY (acc_codigo)
);

--Ya agregado movimiento compra
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

--Ya agregado referencial seguridad
CREATE TABLE modulo (
                modu_codigo INTEGER NOT NULL,
                modu_descripcion VARCHAR NOT NULL,
                modu_estado VARCHAR NOT NULL,
                CONSTRAINT modulo_pk PRIMARY KEY (modu_codigo)
);

--Ya agregado referencial seguridad
CREATE TABLE gui (
                gui_codigo INTEGER NOT NULL,
                modu_codigo INTEGER NOT NULL,
                gui_descripcion VARCHAR NOT NULL,
                gui_estado VARCHAR NOT NULL,
                CONSTRAINT gui_pk PRIMARY KEY (gui_codigo, modu_codigo)
);

--Ya agregado referencial seguridad
CREATE TABLE permisos (
                perm_codigo INTEGER NOT NULL,
                perm_descripcion VARCHAR NOT NULL,
                perm_estado VARCHAR NOT NULL,
                CONSTRAINT permisos_pk PRIMARY KEY (perm_codigo)
);

--Ya agregado referencial seguridad
CREATE TABLE perfil (
                perf_codigo INTEGER NOT NULL,
                perf_descripcion VARCHAR NOT NULL,
                perf_estado VARCHAR NOT NULL,
                CONSTRAINT perfil_pk PRIMARY KEY (perf_codigo)
);

--Ya agregado referencial seguridad
CREATE TABLE perfil_gui (
                perf_codigo INTEGER NOT NULL,
                gui_codigo INTEGER NOT NULL,
                modu_codigo INTEGER NOT NULL,
                perfgui_estado VARCHAR NOT NULL,
                CONSTRAINT perfil_gui_pk PRIMARY KEY (perf_codigo, gui_codigo, modu_codigo)
);

--Ya agregado referencial seguridad
CREATE TABLE perfiles_permisos (
                perf_codigo INTEGER NOT NULL,
                perm_codigo INTEGER NOT NULL,
                perfpe_estado VARCHAR NOT NULL,
                CONSTRAINT perfiles_permisos_pk PRIMARY KEY (perf_codigo, perm_codigo)
);

--Ya agregado referencial produccion
CREATE TABLE maquinaria (
                maq_codigo INTEGER NOT NULL,
                maq_descripcion VARCHAR NOT NULL,
                maq_estado VARCHAR NOT NULL,
                CONSTRAINT maquinaria_pk PRIMARY KEY (maq_codigo)
);

--Ya agregado referencial produccion
CREATE TABLE cargo (
                car_codigo INTEGER NOT NULL,
                car_descripcion VARCHAR NOT NULL,
                car_estado VARCHAR NOT NULL,
                CONSTRAINT cargo_pk PRIMARY KEY (car_codigo)
);

--Ya agregado referencial produccion
CREATE TABLE parametro_control_calidad (
                pacoca_codigo INTEGER NOT NULL,
                pacoca_descripcion VARCHAR NOT NULL,
                pacoca_estado VARCHAR NOT NULL,
                CONSTRAINT parametro_control_calidad_pk PRIMARY KEY (pacoca_codigo)
);

--Ya agregado referencial produccion
CREATE TABLE tipo_etapa_produccion (
                tipet_codigo INTEGER NOT NULL,
                tipet_descripcion VARCHAR NOT NULL,
                tipet_estado VARCHAR NOT NULL,
                CONSTRAINT tipo_etapa_produccion_pk PRIMARY KEY (tipet_codigo)
);

--Ya agregado referencial venta
CREATE TABLE marca_tarjeta (
                marta_codigo INTEGER NOT NULL,
                marta_descripcion VARCHAR NOT NULL,
                marta_estado VARCHAR NOT NULL,
                CONSTRAINT marca_tarjeta_pk PRIMARY KEY (marta_codigo)
);

--Ya agregado referencial venta
CREATE TABLE forma_cobro (
                forco_codigo INTEGER NOT NULL,
                forco_descripcion VARCHAR NOT NULL,
                forco_estado VARCHAR NOT NULL,
                CONSTRAINT forma_cobro_pk PRIMARY KEY (forco_codigo)
);

--Ya agregado referencial venta
CREATE TABLE entidad_emisora (
                ent_codigo INTEGER NOT NULL,
                ent_razonsocial VARCHAR NOT NULL,
                ent_ruc VARCHAR NOT NULL,
                ent_telefono VARCHAR NOT NULL,
                ent_email VARCHAR NOT NULL,
                ent_estado VARCHAR NOT NULL,
                CONSTRAINT entidad_emisora_pk PRIMARY KEY (ent_codigo)
);

--Ya agregado referencial venta
CREATE TABLE entidad_adherida (
                entad_codigo INTEGER NOT NULL,
                ent_codigo INTEGER NOT NULL,
                marta_codigo INTEGER NOT NULL,
                CONSTRAINT entidad_adherida_pk PRIMARY KEY (entad_codigo, ent_codigo, marta_codigo)
);

--Ya agregado referencial venta
CREATE TABLE tipo_comprobante (
                tipco_codigo INTEGER NOT NULL,
                tipco_descripcion VARCHAR NOT NULL,
                tipco_estado VARCHAR NOT NULL,
                CONSTRAINT tipo_comprobante_pk PRIMARY KEY (tipco_codigo)
);

--Ya agregado referencial venta
CREATE TABLE tipo_documento (
                tipdo_codigo INTEGER NOT NULL,
                tipdo_descripcion VARCHAR NOT NULL,
                tipdo_estado VARCHAR NOT NULL,
                CONSTRAINT tipo_documento_pk PRIMARY KEY (tipdo_codigo)
);

--Ya agregado referencial produccion
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

--Ya agregado referencial compra
CREATE TABLE ciudad (
                ciu_codigo INTEGER NOT NULL,
                ciu_descripcion VARCHAR NOT NULL,
                ciu_estado VARCHAR NOT NULL,
                CONSTRAINT ciudad_pk PRIMARY KEY (ciu_codigo)
);

--ya agregado referencial venta
CREATE TABLE cliente (
                cli_codigo INTEGER NOT NULL,
                cli_direccion VARCHAR NOT NULL,
                cli_tipocliente VARCHAR NOT NULL,
                cli_estado VARCHAR NOT NULL,
                per_codigo INTEGER NOT NULL,
                ciu_codigo INTEGER NOT NULL,
                CONSTRAINT cliente_pk PRIMARY KEY (cli_codigo)
);

--Ya agregado referencial compra
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

--Ya agregado referencial compra
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

--Ya agregado referencial produccion
CREATE TABLE seccion (
                secc_codigo INTEGER NOT NULL,
                secc_descripcion VARCHAR NOT NULL,
                secc_estado VARCHAR NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT seccion_pk PRIMARY KEY (secc_codigo)
);

--Ya agregado referencial produccion
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

--Ya agregado referencial produccion
CREATE TABLE equipo_trabajo (
                func_codigo INTEGER NOT NULL,
                secc_codigo INTEGER NOT NULL,
                eqtra_estado VARCHAR NOT NULL,
                CONSTRAINT equipo_trabajo_pk PRIMARY KEY (func_codigo, secc_codigo)
);

--Ya agregado referencial seguridad
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

--Ya agregado referencial seguridad
CREATE TABLE asignacion_permiso_usuario (
                usu_codigo INTEGER NOT NULL,
                perf_codigo INTEGER NOT NULL,
                perm_codigo INTEGER NOT NULL,
                asigperm_estado VARCHAR NOT NULL,
                CONSTRAINT asignacion_permiso_usuario_pk PRIMARY KEY (usu_codigo, perf_codigo, perm_codigo)
);

--Ya agregado movimiento produccion
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


CREATE TABLE produccion_terminada_cab (
                proter_codigo INTEGER NOT NULL,
                proter_fechaculminacion DATE NOT NULL,
                proter_estado VARCHAR NOT NULL,
                orpro_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                cli_codigo INTEGER NOT NULL,
                CONSTRAINT produccion_terminada_cab_pk PRIMARY KEY (proter_codigo)
);


CREATE TABLE mermas_cab (
                mer_codigo INTEGER NOT NULL,
                mer_fecha DATE NOT NULL,
                mer_estado VARCHAR NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                orpro_codigo INTEGER NOT NULL,
                CONSTRAINT mermas_cab_pk PRIMARY KEY (mer_codigo)
);

--Ya agregado movimiento produccion
CREATE TABLE produccion_cab (
                prod_codigo INTEGER NOT NULL,
                prod_fecha INTEGER NOT NULL,
                orpro_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT produccion_cab_pk PRIMARY KEY (prod_codigo)
);

--Ya agregado movimiento produccion
CREATE TABLE pedido_produccion_cab (
                pedpro_codigo INTEGER NOT NULL,
                pedpro_fecha DATE NOT NULL,
                pedpro_estado VARCHAR NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT pedido_produccion_cab_pk PRIMARY KEY (pedpro_codigo)
);

--Ya agregado movimiento venta
CREATE TABLE venta_cab (
                ven_codigo INTEGER NOT NULL,
                ven_fecha DATE NOT NULL,
                ven_numfactura VARCHAR NOT NULL,
                ven_tipofactura VARCHAR NOT NULL,
                ven_cuota INTEGER,
                vent_montocuota NUMERIC,
                ven_interfecha VARCHAR,
                ven_estado VARCHAR NOT NULL,
                usu_codigo INTEGER NOT NULL,
                cli_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT venta_cab_pk PRIMARY KEY (ven_codigo)
);

--Ya agregado movimiento venta
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

--Ya agregado movimiento venta
CREATE TABLE cuenta_cobrar (
                ven_codigo INTEGER NOT NULL,
                cuenco_nrocuota INTEGER,
                cuenco_montototal NUMERIC NOT NULL,
                cuenco_montosaldo NUMERIC NOT NULL,
                cuenco_estado VARCHAR NOT NULL,
                CONSTRAINT cuenta_cobrar_pk PRIMARY KEY (ven_codigo)
);

--Ya agregado movimiento venta
CREATE TABLE libro_venta (
                libven_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                libven_exenta NUMERIC,
                libven_iva5 NUMERIC,
                libven_iva10 NUMERIC,
                libven_fecha DATE NOT NULL,
                libven_numfactura VARCHAR NOT NULL,
                libven_estado VARCHAR NOT NULL,
                CONSTRAINT libro_venta_pk PRIMARY KEY (libven_codigo, ven_codigo)
);

--Ya agregado movimiento venta
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

--Ya agregado movimiento produccion
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

--Ya agregado movimiento produccion
CREATE TABLE orden_presupuesto (
                orpre_codigo INTEGER NOT NULL,
                orpro_codigo INTEGER NOT NULL,
                pres_codigo INTEGER NOT NULL,
                CONSTRAINT orden_presupuesto_pk PRIMARY KEY (orpre_codigo, orpro_codigo, pres_codigo)
);

--Ya agregado movimiento venta
CREATE TABLE pedido_venta (
                ven_codigo INTEGER NOT NULL,
                peven_codigo INTEGER NOT NULL,
                pedidoven_codigo INTEGER NOT NULL,
                CONSTRAINT pedido_venta_pk PRIMARY KEY (ven_codigo, peven_codigo, pedidoven_codigo)
);

--Ya agregado movimiento compra
CREATE TABLE ajuste_inventario_cab (
                ajuin_codigo INTEGER NOT NULL,
                ajuin_fecha DATE NOT NULL,
                ajuin_tipoajuste VARCHAR NOT NULL,
                ajuin_estado VARCHAR NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                CONSTRAINT ajuste_inventario_cab_pk PRIMARY KEY (ajuin_codigo)
);

--Ya agregado referencial compra
CREATE TABLE deposito (
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                dep_descripcion VARCHAR NOT NULL,
                dep_estado VARCHAR NOT NULL,
                ciu_codigo INTEGER NOT NULL,
                CONSTRAINT deposito_pk PRIMARY KEY (dep_codigo, suc_codigo, emp_codigo)
);

--Ya agregado movimiento de compra 
CREATE TABLE pedido_compra_cab (
                pedco_codigo INTEGER NOT NULL,
                pedco_fecha DATE NOT NULL,
                pedco_estado VARCHAR NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                CONSTRAINT pedido_compra_cab_pk PRIMARY KEY (pedco_codigo)
);

--Ya agregado referencial venta
CREATE TABLE caja (
                caj_codigo INTEGER NOT NULL,
                caj_descripcion VARCHAR NOT NULL,
                caj_estado VARCHAR NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                CONSTRAINT caja_pk PRIMARY KEY (caj_codigo)
);

--Ya agregado referencial venta
CREATE TABLE apertura_cierre (
                apercie_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                caj_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                apercie_fechahoraapertura TIMESTAMP,
                apercie_fechahoracierre TIMESTAMP,
                apercie_montoapertura NUMERIC,
                apercie_montocierre NUMERIC NOT NULL,
                apercie_estado VARCHAR NOT NULL,
                CONSTRAINT apertura_cierre_pk PRIMARY KEY (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
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

--Ya agregado movimiento venta
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
                coche_tipocheque VARCHAR NOT NULL,
                coche_fechavencimiento DATE NOT NULL,
                coche_estado VARCHAR NOT NULL,
                ent_codigo INTEGER NOT NULL,
                cob_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                cobdet_codigo INTEGER NOT NULL,
                CONSTRAINT cobro_cheque_pk PRIMARY KEY (coche_codigo)
);

--Ya agrega movimiento compra
CREATE TABLE cobro_tarjeta (
                cobta_codigo INTEGER NOT NULL,
                cobta_numero VARCHAR NOT NULL,
                cobta_monto NUMERIC NOT NULL,
                cobta_tipotarjeta VARCHAR NOT NULL,
                cobta_estado VARCHAR NOT NULL,
                entad_codigo INTEGER NOT NULL,
                ent_codigo INTEGER NOT NULL,
                marta_codigo INTEGER NOT NULL,
                cob_codigo INTEGER NOT NULL,
                ven_codigo INTEGER NOT NULL,
                cobdet_codigo INTEGER NOT NULL,
                CONSTRAINT cobro_tarjeta_pk PRIMARY KEY (cobta_codigo)
);

--Ya agregado movimiento venta
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

--Ya agregado movimiento venta
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
                CONSTRAINT recaudacion_depositar_pk PRIMARY KEY (rec_codigo, apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
);

--Ya agregado referencial produccion
CREATE TABLE talle (
                tall_codigo INTEGER NOT NULL,
                tall_descripcion VARCHAR NOT NULL,
                tall_estado VARCHAR NOT NULL,
                CONSTRAINT talle_pk PRIMARY KEY (tall_codigo)
);

--Ya agregado referencial producciom
CREATE TABLE color_prenda (
                col_codigo INTEGER NOT NULL,
                col_descripcion VARCHAR NOT NULL,
                col_estado VARCHAR NOT NULL,
                CONSTRAINT color_prenda_pk PRIMARY KEY (col_codigo)
);

--Ya agregado referencial produccion
CREATE TABLE modelo (
                mod_codigo INTEGER NOT NULL,
                mod_codigomodelo VARCHAR NOT NULL,
                mod_sexo sexo NOT NULL,
                mod_observacion VARCHAR,
                mod_estado VARCHAR NOT NULL,
                col_codigo INTEGER NOT NULL,
                CONSTRAINT modelo_pk PRIMARY KEY (mod_codigo)
);

--Ya agregado referencial produccion
CREATE TABLE costo_servicio (
                costserv_codigo INTEGER NOT NULL,
                costserv_costo NUMERIC NOT NULL,
                costserv_estado VARCHAR NOT NULL,
                mod_codigo INTEGER NOT NULL,
                CONSTRAINT costo_servicio_pk PRIMARY KEY (costserv_codigo)
);


CREATE TABLE costo_produccion (
                copro_codigo INTEGER NOT NULL,
                copro_fecha DATE NOT NULL,
                copro_estado VARCHAR NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                mod_codigo INTEGER NOT NULL,
                costserv_codigo INTEGER NOT NULL,
                CONSTRAINT costo_produccion_pk PRIMARY KEY (copro_codigo)
);


CREATE TABLE costo_produccion_cargo (
                copro_codigo INTEGER NOT NULL,
                car_codigo INTEGER NOT NULL,
                cosproca_costo NUMERIC NOT NULL,
                CONSTRAINT costo_produccion_cargo_pk PRIMARY KEY (copro_codigo, car_codigo)
);

--Ya agregado referencial compra
CREATE TABLE tipo_item (
                tipit_codigo INTEGER NOT NULL,
                tipit_descripcion VARCHAR NOT NULL,
                tipit_estado VARCHAR NOT NULL,
                CONSTRAINT tipo_item_pk PRIMARY KEY (tipit_codigo)
);

--Ya agregado referencial compra
CREATE TABLE tipo_impuesto (
                tipim_codigo INTEGER NOT NULL,
                tipim_descripcion VARCHAR NOT NULL,
                tipim_estado VARCHAR NOT NULL,
                CONSTRAINT tipo_impuesto_pk PRIMARY KEY (tipim_codigo)
);

--Ya agregado referencial compra
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


CREATE TABLE costo_produccion_item (
                copro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                cosproit_cantidad NUMERIC NOT NULL,
                cosproit_costo NUMERIC NOT NULL,
                CONSTRAINT costo_produccion_item_pk PRIMARY KEY (copro_codigo, it_codigo, tipit_codigo)
);

--Ya agregado movimiento produccion
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


CREATE TABLE control_calidad (
                conca_fecha DATE NOT NULL,
                conca_estado VARCHAR NOT NULL,
                prod_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                pacoca_codigo INTEGER NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL
);

--Ya agregado movimiento produccion
CREATE TABLE orden_produccion_det (
                orpro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                orprodet_especificacion VARCHAR NOT NULL,
                orprodet_cantidad INTEGER NOT NULL,
                CONSTRAINT orden_produccion_det_pk PRIMARY KEY (orpro_codigo, it_codigo, tipit_codigo)
);

--Ya agregado movimiento produccion
CREATE TABLE etapa_produccion (
                orpro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                tipet_codigo INTEGER NOT NULL,
                etpro_fecha DATE NOT NULL,
                etpro_estado VARCHAR NOT NULL,
                usu_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                maq_codigo INTEGER NOT NULL,
                CONSTRAINT etapa_produccion_pk PRIMARY KEY (orpro_codigo, it_codigo, tipit_codigo, tipet_codigo)
);

--Ya agregado movimiento produccio
CREATE TABLE pedido_produccion_det (
                pedpro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                pedprodet_cantidad INTEGER NOT NULL,
                pedprodet_precio NUMERIC NOT NULL,
                CONSTRAINT pedido_produccion_det_pk PRIMARY KEY (pedpro_codigo, it_codigo, tipit_codigo)
);

--Ya agregado movimiento produccion
CREATE TABLE presupuesto_det (
                pres_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                presdet_cantidad INTEGER NOT NULL,
                presdet_precio NUMERIC NOT NULL,
                CONSTRAINT presupuesto_det_pk PRIMARY KEY (pres_codigo, it_codigo, tipit_codigo)
);

--Ya agregado movimiento venta
CREATE TABLE nota_venta_det (
                notven_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                notvendet_cantidad INTEGER NOT NULL,
                notvendet_precio NUMERIC NOT NULL,
                CONSTRAINT nota_venta_det_pk PRIMARY KEY (notven_codigo, it_codigo, tipit_codigo)
);

--Ya agregado movimiento venta
CREATE TABLE pedido_venta_det (
                peven_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                pevendet_cantidad INTEGER NOT NULL,
                pevendet_precio NUMERIC NOT NULL,
                CONSTRAINT pedido_venta_det_pk PRIMARY KEY (peven_codigo, it_codigo, tipit_codigo)
);

--Ya agregado
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


CREATE TABLE produccion_terminada_det (
                proter_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                proterdet_cantidad NUMERIC NOT NULL,
                CONSTRAINT produccion_terminada_det_pk PRIMARY KEY (proter_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
);


CREATE TABLE mermas_det (
                mer_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                merdet_cantidadmerma NUMERIC NOT NULL,
                merdet_observacion VARCHAR NOT NULL,
                CONSTRAINT mermas_det_pk PRIMARY KEY (mer_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
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

--Ya agregado movimiento compra
CREATE TABLE ajuste_inventario_det (
                ajuin_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                dep_codigo INTEGER NOT NULL,
                suc_codigo INTEGER NOT NULL,
                emp_codigo INTEGER NOT NULL,
                ajuindet_cantidad NUMERIC NOT NULL,
                ajuindet_motivo VARCHAR NOT NULL,
                CONSTRAINT ajuste_inevntario_det_pk PRIMARY KEY (ajuin_codigo, it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
);

--Ya agregadi movimiento compra
CREATE TABLE pedido_compra_det (
                pedco_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                pedcodet_cantidad NUMERIC NOT NULL,
                pedcodet_precio NUMERIC NOT NULL,
                CONSTRAINT pedido_compra_det_pk PRIMARY KEY (pedco_codigo, it_codigo, tipit_codigo)
);

--Ya agregado referencial compra
CREATE TABLE tipo_proveedor (
                tipro_codigo INTEGER NOT NULL,
                tipro_descripcion VARCHAR NOT NULL,
                tipro_estado VARCHAR NOT NULL,
                CONSTRAINT tipo_proveedor_pk PRIMARY KEY (tipro_codigo)
);

--Ya agregado referenciales compras
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

--Ya agregado movimiento compra
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

--Ya agregado movimiento compra
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

--Ya agregado movimiento compra
CREATE TABLE nota_compra_det (
                nocom_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                credecomdet_cantidad NUMERIC NOT NULL,
                credecomdet_precio NUMERIC NOT NULL,
                CONSTRAINT nota_compra_det_pk PRIMARY KEY (nocom_codigo, it_codigo, tipit_codigo)
);

--Ya agregado movimiento compra
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

--Ya agregado movimiento compra
CREATE TABLE cuenta_pagar (
                comp_codigo INTEGER NOT NULL,
                cuenpa_nrocuota INTEGER,
                cuenpa_montototal NUMERIC NOT NULL,
                cuenpa_montosaldo NUMERIC NOT NULL,
                cuenpa_estado VARCHAR NOT NULL,
                CONSTRAINT cuenta_pagar_pk PRIMARY KEY (comp_codigo)
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

--Ya agregado movimiento compra
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


CREATE TABLE orden_compra (
                comp_codigo INTEGER NOT NULL,
                orcom_codigo INTEGER NOT NULL,
                ordencom_codigo INTEGER NOT NULL,
                CONSTRAINT orden_compra_pk PRIMARY KEY (comp_codigo, orcom_codigo, ordencom_codigo)
);

--Ya agregado movimiento compra
CREATE TABLE orden_compra_det (
                orcom_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                orcomdet_cantidad NUMERIC NOT NULL,
                orcomdet_precio NUMERIC NOT NULL,
                CONSTRAINT orden_compra_det_pk PRIMARY KEY (orcom_codigo, it_codigo, tipit_codigo)
);

--Ya agregado movimiento compra
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

--Ya agregado movimiento compra
CREATE TABLE presupuesto_orden (
                orcom_codigo INTEGER NOT NULL,
                prepro_codigo INTEGER NOT NULL,
                presor_codigo INTEGER NOT NULL,
                CONSTRAINT presupuesto_orden_pk PRIMARY KEY (orcom_codigo, prepro_codigo, presor_codigo)
);

--Ya agregado movimiento compra
CREATE TABLE pedido_presupuesto (
                pedco_codigo INTEGER NOT NULL,
                prepro_codigo INTEGER NOT NULL,
                pedpre_codigo INTEGER NOT NULL,
                CONSTRAINT pedido_presupuesto_pk PRIMARY KEY (pedco_codigo, prepro_codigo, pedpre_codigo)
);

--Ya agregado movimiento compra
CREATE TABLE presupuesto_proveedor_det (
                prepro_codigo INTEGER NOT NULL,
                it_codigo INTEGER NOT NULL,
                tipit_codigo INTEGER NOT NULL,
                peprodet_cantidad NUMERIC NOT NULL,
                peprodet_precio NUMERIC NOT NULL,
                CONSTRAINT presupuesto_proveedor_det_pk PRIMARY KEY (prepro_codigo, it_codigo, tipit_codigo)
);

--Ya agregado referencial seguridad
ALTER TABLE usuario ADD CONSTRAINT modulo_usuario_fk
FOREIGN KEY (modu_codigo)
REFERENCES modulo (modu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial seguridad
ALTER TABLE gui ADD CONSTRAINT modulo_gui_fk
FOREIGN KEY (modu_codigo)
REFERENCES modulo (modu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial seguridad
ALTER TABLE perfil_gui ADD CONSTRAINT gui_perfil_gui_fk
FOREIGN KEY (gui_codigo, modu_codigo)
REFERENCES gui (gui_codigo, modu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial seguridad
ALTER TABLE perfiles_permisos ADD CONSTRAINT permisos_perfiles_permisos_fk
FOREIGN KEY (perm_codigo)
REFERENCES permisos (perm_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial seguridad
ALTER TABLE usuario ADD CONSTRAINT perfil_usuario_fk
FOREIGN KEY (perf_codigo)
REFERENCES perfil (perf_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial seguridad
ALTER TABLE perfiles_permisos ADD CONSTRAINT perfil_perfiles_permisos_fk
FOREIGN KEY (perf_codigo)
REFERENCES perfil (perf_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial seguridad
ALTER TABLE perfil_gui ADD CONSTRAINT perfil_perfil_gui_fk
FOREIGN KEY (perf_codigo)
REFERENCES perfil (perf_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial seguridad
ALTER TABLE asignacion_permiso_usuario ADD CONSTRAINT perfiles_permisos_asignacion_permiso_usuario_fk
FOREIGN KEY (perf_codigo, perm_codigo)
REFERENCES perfiles_permisos (perf_codigo, perm_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento prooduccion
ALTER TABLE etapa_produccion ADD CONSTRAINT maquinaria_etapa_produccion_fk
FOREIGN KEY (maq_codigo)
REFERENCES maquinaria (maq_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial produccion
ALTER TABLE funcionario ADD CONSTRAINT cargo_funcionario_fk
FOREIGN KEY (car_codigo)
REFERENCES cargo (car_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE costo_produccion_cargo ADD CONSTRAINT cargo_costo_produccion_cargo_fk
FOREIGN KEY (car_codigo)
REFERENCES cargo (car_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE control_calidad ADD CONSTRAINT parametro_control_calidad_control_calidad_fk
FOREIGN KEY (pacoca_codigo)
REFERENCES parametro_control_calidad (pacoca_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE etapa_produccion ADD CONSTRAINT tipo_etapa_produccion_etapa_produccion_fk
FOREIGN KEY (tipet_codigo)
REFERENCES tipo_etapa_produccion (tipet_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial venta
ALTER TABLE entidad_adherida ADD CONSTRAINT marca_tarjeta_entidad_adherida_fk
FOREIGN KEY (marta_codigo)
REFERENCES marca_tarjeta (marta_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE cobro_det ADD CONSTRAINT forma_cobro_cobro_det_fk
FOREIGN KEY (forco_codigo)
REFERENCES forma_cobro (forco_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado teferencial venta
ALTER TABLE entidad_adherida ADD CONSTRAINT entidad_emisora_entidad_adherida_fk
FOREIGN KEY (ent_codigo)
REFERENCES entidad_emisora (ent_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE cobro_cheque ADD CONSTRAINT entidad_emisora_cobro_cheque_fk
FOREIGN KEY (ent_codigo)
REFERENCES entidad_emisora (ent_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE cobro_tarjeta ADD CONSTRAINT entidad_adherida_cobro_tarjeta_fk
FOREIGN KEY (entad_codigo, ent_codigo, marta_codigo)
REFERENCES entidad_adherida (entad_codigo, ent_codigo, marta_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE nota_compra_cab ADD CONSTRAINT tipo_comprobante_nota_compra_cab_fk
FOREIGN KEY (tipco_codigo)
REFERENCES tipo_comprobante (tipco_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimento venta
ALTER TABLE nota_venta_cab ADD CONSTRAINT tipo_comprobante_nota_venta_cab_fk
FOREIGN KEY (tipco_codigo)
REFERENCES tipo_comprobante (tipco_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial produccion
ALTER TABLE personas ADD CONSTRAINT tipo_documento_personas_fk
FOREIGN KEY (tipdo_codigo)
REFERENCES tipo_documento (tipdo_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial venta
ALTER TABLE cliente ADD CONSTRAINT personas_cliente_fk
FOREIGN KEY (per_codigo)
REFERENCES personas (per_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial produccion
ALTER TABLE funcionario ADD CONSTRAINT personas_funcionario_fk
FOREIGN KEY (per_codigo)
REFERENCES personas (per_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial compra
ALTER TABLE sucursal ADD CONSTRAINT ciudad_sucursal_fk
FOREIGN KEY (ciu_codigo)
REFERENCES ciudad (ciu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial compra
ALTER TABLE deposito ADD CONSTRAINT ciudad_deposito_fk
FOREIGN KEY (ciu_codigo)
REFERENCES ciudad (ciu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial produccion
ALTER TABLE funcionario ADD CONSTRAINT ciudad_funcionario_fk
FOREIGN KEY (ciu_codigo)
REFERENCES ciudad (ciu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cliente ADD CONSTRAINT ciudad_cliente_fk
FOREIGN KEY (ciu_codigo)
REFERENCES ciudad (ciu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE pedido_venta_cab ADD CONSTRAINT cliente_pedido_venta_cab_fk
FOREIGN KEY (cli_codigo)
REFERENCES cliente (cli_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimmento venta
ALTER TABLE venta_cab ADD CONSTRAINT cliente_venta_cab_fk
FOREIGN KEY (cli_codigo)
REFERENCES cliente (cli_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE nota_venta_cab ADD CONSTRAINT cliente_nota_venta_cab_fk
FOREIGN KEY (cli_codigo)
REFERENCES cliente (cli_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE presupuesto_cab ADD CONSTRAINT cliente_presupuesto_cab_fk
FOREIGN KEY (cli_codigo)
REFERENCES cliente (cli_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE produccion_terminada_cab ADD CONSTRAINT cliente_produccion_terminada_cab_fk
FOREIGN KEY (cli_codigo)
REFERENCES cliente (cli_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial compra
ALTER TABLE sucursal ADD CONSTRAINT empresa_sucursal_fk
FOREIGN KEY (emp_codigo)
REFERENCES empresa (emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial venta
ALTER TABLE caja ADD CONSTRAINT sucursal_caja_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE pedido_compra_cab ADD CONSTRAINT sucursal_pedido_compra_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE presupuesto_proveedor_cab ADD CONSTRAINT sucursal_presupuesto_proveedor_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE orden_compra_cab ADD CONSTRAINT sucursal_orden_compra_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial compra
ALTER TABLE deposito ADD CONSTRAINT sucursal_deposito_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE compra_cab ADD CONSTRAINT sucursal_compra_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE ajuste_inventario_cab ADD CONSTRAINT sucursal_ajuste_inventario_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE nota_compra_cab ADD CONSTRAINT sucursal_nota_compra_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE pedido_venta_cab ADD CONSTRAINT sucursal_pedido_venta_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimmento venta
ALTER TABLE venta_cab ADD CONSTRAINT sucursal_venta_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado moviemnto venta
ALTER TABLE apertura_cierre ADD CONSTRAINT sucursal_apertura_cierre_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE nota_venta_cab ADD CONSTRAINT sucursal_nota_venta_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE presupuesto_cab ADD CONSTRAINT sucursal_presupuesto_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE pedido_produccion_cab ADD CONSTRAINT sucursal_pedido_produccion_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE orden_produccion_cab ADD CONSTRAINT sucursal_orden_produccion_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE etapa_produccion ADD CONSTRAINT sucursal_etapa_produccion_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


--Ya agregado movimiento produccion
ALTER TABLE produccion_cab ADD CONSTRAINT sucursal_produccion_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE control_calidad ADD CONSTRAINT sucursal_control_calidad_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE mermas_cab ADD CONSTRAINT sucursal_mermas_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE costo_produccion ADD CONSTRAINT sucursal_costo_produccion_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial produccion
ALTER TABLE funcionario ADD CONSTRAINT sucursal_funcionario_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial produccion
ALTER TABLE seccion ADD CONSTRAINT sucursal_seccion_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE produccion_terminada_cab ADD CONSTRAINT sucursal_produccion_terminada_cab_fk
FOREIGN KEY (suc_codigo, emp_codigo)
REFERENCES sucursal (suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial produccion
ALTER TABLE equipo_trabajo ADD CONSTRAINT seccion_equipo_trabajo_fk
FOREIGN KEY (secc_codigo)
REFERENCES seccion (secc_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE orden_produccion_cab ADD CONSTRAINT seccion_orden_produccion_cab_fk
FOREIGN KEY (secc_codigo)
REFERENCES seccion (secc_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial seguridad
ALTER TABLE usuario ADD CONSTRAINT funcionario_usuario_fk
FOREIGN KEY (func_codigo)
REFERENCES funcionario (func_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE arqueo_control ADD CONSTRAINT funcionario_arqueo_control_fk
FOREIGN KEY (func_codigo)
REFERENCES funcionario (func_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial produccion
ALTER TABLE equipo_trabajo ADD CONSTRAINT funcionario_equipo_trabajo_fk
FOREIGN KEY (func_codigo)
REFERENCES funcionario (func_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE pedido_compra_cab ADD CONSTRAINT usuario_pedido_compra_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE presupuesto_proveedor_cab ADD CONSTRAINT usuario_presupuesto_proveedor_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE orden_compra_cab ADD CONSTRAINT usuario_orden_compra_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE compra_cab ADD CONSTRAINT usuario_compra_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE ajuste_inventario_cab ADD CONSTRAINT usuario_ajuste_inventario_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE nota_compra_cab ADD CONSTRAINT usuario_nota_compra_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE pedido_venta_cab ADD CONSTRAINT usuario_pedido_venta_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta   
ALTER TABLE venta_cab ADD CONSTRAINT usuario_venta_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimeinto venta
ALTER TABLE apertura_cierre ADD CONSTRAINT usuario_apertura_cierre_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimeinto venta
ALTER TABLE nota_venta_cab ADD CONSTRAINT usuario_nota_venta_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE presupuesto_cab ADD CONSTRAINT usuario_presupuesto_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE pedido_produccion_cab ADD CONSTRAINT usuario_pedido_produccion_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE orden_produccion_cab ADD CONSTRAINT usuario_orden_produccion_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE etapa_produccion ADD CONSTRAINT usuario_etapa_produccion_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE produccion_cab ADD CONSTRAINT usuario_produccion_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE control_calidad ADD CONSTRAINT usuario_control_calidad_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE mermas_cab ADD CONSTRAINT usuario_mermas_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE costo_produccion ADD CONSTRAINT usuario_costo_produccion_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE produccion_terminada_cab ADD CONSTRAINT usuario_produccion_terminada_cab_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial seguridad
ALTER TABLE asignacion_permiso_usuario ADD CONSTRAINT usuario_asignacion_permiso_usuario_fk
FOREIGN KEY (usu_codigo)
REFERENCES usuario (usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE orden_produccion_det ADD CONSTRAINT orden_produccion_cab_orden_produccion_det_fk
FOREIGN KEY (orpro_codigo)
REFERENCES orden_produccion_cab (orpro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE orden_presupuesto ADD CONSTRAINT orden_produccion_cab_orden_presupuesto_fk
FOREIGN KEY (orpro_codigo)
REFERENCES orden_produccion_cab (orpro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE produccion_cab ADD CONSTRAINT orden_produccion_cab_produccion_cab_fk
FOREIGN KEY (orpro_codigo)
REFERENCES orden_produccion_cab (orpro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE mermas_cab ADD CONSTRAINT orden_produccion_cab_mermas_cab_fk
FOREIGN KEY (orpro_codigo)
REFERENCES orden_produccion_cab (orpro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE produccion_terminada_cab ADD CONSTRAINT orden_produccion_cab_produccion_terminada_cab_fk
FOREIGN KEY (orpro_codigo)
REFERENCES orden_produccion_cab (orpro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE produccion_terminada_det ADD CONSTRAINT produccion_terminada_cab_produccion_terminada_det_fk
FOREIGN KEY (proter_codigo)
REFERENCES produccion_terminada_cab (proter_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE mermas_det ADD CONSTRAINT mermas_cab_mermas_det_fk
FOREIGN KEY (mer_codigo)
REFERENCES mermas_cab (mer_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE produccion_det ADD CONSTRAINT produccion_cab_produccion_det_fk
FOREIGN KEY (prod_codigo)
REFERENCES produccion_cab (prod_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE pedido_produccion_det ADD CONSTRAINT pedido_produccion_cab_pedido_produccion_det_fk
FOREIGN KEY (pedpro_codigo)
REFERENCES pedido_produccion_cab (pedpro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE venta_det ADD CONSTRAINT venta_cab_venta_det_fk
FOREIGN KEY (ven_codigo)
REFERENCES venta_cab (ven_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE libro_venta ADD CONSTRAINT venta_cab_libro_venta_fk
FOREIGN KEY (ven_codigo)
REFERENCES venta_cab (ven_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE cuenta_cobrar ADD CONSTRAINT venta_cab_cuenta_cobrar_fk
FOREIGN KEY (ven_codigo)
REFERENCES venta_cab (ven_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE pedido_venta ADD CONSTRAINT venta_cab_pedido_venta_fk
FOREIGN KEY (ven_codigo)
REFERENCES venta_cab (ven_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE nota_venta_cab ADD CONSTRAINT venta_cab_nota_venta_cab_fk
FOREIGN KEY (ven_codigo)
REFERENCES venta_cab (ven_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE nota_venta_det ADD CONSTRAINT nota_venta_cab_nota_venta_det_fk
FOREIGN KEY (notven_codigo)
REFERENCES nota_venta_cab (notven_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE cobro_det ADD CONSTRAINT cuenta_cobrar_cobro_det_fk
FOREIGN KEY (ven_codigo)
REFERENCES cuenta_cobrar (ven_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE pedido_venta_det ADD CONSTRAINT pedido_venta_cab_pedido_venta_det_fk
FOREIGN KEY (peven_codigo)
REFERENCES pedido_venta_cab (peven_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE pedido_venta ADD CONSTRAINT pedido_venta_cab_pedido_venta_fk
FOREIGN KEY (peven_codigo)
REFERENCES pedido_venta_cab (peven_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE presupuesto_cab ADD CONSTRAINT pedido_venta_cab_presupuesto_cab_fk
FOREIGN KEY (peven_codigo)
REFERENCES pedido_venta_cab (peven_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE presupuesto_det ADD CONSTRAINT presupuesto_cab_presupuesto_det_fk
FOREIGN KEY (pres_codigo)
REFERENCES presupuesto_cab (pres_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE orden_presupuesto ADD CONSTRAINT presupuesto_cab_orden_presupuesto_fk
FOREIGN KEY (pres_codigo)
REFERENCES presupuesto_cab (pres_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE ajuste_inventario_det ADD CONSTRAINT ajuste_inventario_cab_ajuste_inevntario_det_fk
FOREIGN KEY (ajuin_codigo)
REFERENCES ajuste_inventario_cab (ajuin_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado
ALTER TABLE stock ADD CONSTRAINT unidad_medida_stock_fk
FOREIGN KEY (unime_codigo)
REFERENCES unidad_medida (unime_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado
ALTER TABLE stock ADD CONSTRAINT deposito_stock_fk
FOREIGN KEY (dep_codigo, suc_codigo, emp_codigo)
REFERENCES deposito (dep_codigo, suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compras
ALTER TABLE pedido_compra_det ADD CONSTRAINT pedido_compra_cab_pedido_compra_det_fk
FOREIGN KEY (pedco_codigo)
REFERENCES pedido_compra_cab (pedco_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE pedido_presupuesto ADD CONSTRAINT pedido_compra_cab_pedido_presupuesto_fk
FOREIGN KEY (pedco_codigo)
REFERENCES pedido_compra_cab (pedco_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimeinto venta
ALTER TABLE apertura_cierre ADD CONSTRAINT caja_apertura_cierre_fk
FOREIGN KEY (caj_codigo)
REFERENCES caja (caj_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimeinto venta
ALTER TABLE recaudacion_depositar ADD CONSTRAINT apertura_cierre_recaudacion_depositar_fk
FOREIGN KEY (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
REFERENCES apertura_cierre (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE arqueo_control ADD CONSTRAINT apertura_cierre_arqueo_control_fk
FOREIGN KEY (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
REFERENCES apertura_cierre (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta 
ALTER TABLE cobro_cab ADD CONSTRAINT apertura_cierre_cobro_cab_fk
FOREIGN KEY (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
REFERENCES apertura_cierre (apercie_codigo, suc_codigo, emp_codigo, caj_codigo, usu_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE; 

--Ya agregado movimiento venta
ALTER TABLE cobro_det ADD CONSTRAINT cobro_cab_cobro_det_fk
FOREIGN KEY (cob_codigo)
REFERENCES cobro_cab (cob_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE cobro_tarjeta ADD CONSTRAINT cobro_det_cobro_tarjeta_fk
FOREIGN KEY (cob_codigo, ven_codigo, cobdet_codigo)
REFERENCES cobro_det (cob_codigo, ven_codigo, cobdet_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE cobro_cheque ADD CONSTRAINT cobro_det_cobro_cheque_fk
FOREIGN KEY (cob_codigo, ven_codigo, cobdet_codigo)
REFERENCES cobro_det (cob_codigo, ven_codigo, cobdet_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial compra
ALTER TABLE items ADD CONSTRAINT talle_items_fk
FOREIGN KEY (tall_codigo)
REFERENCES talle (tall_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial produccion
ALTER TABLE modelo ADD CONSTRAINT color_prenda_modelo_fk
FOREIGN KEY (col_codigo)
REFERENCES color_prenda (col_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial compra
ALTER TABLE items ADD CONSTRAINT modelo_items_fk
FOREIGN KEY (mod_codigo)
REFERENCES modelo (mod_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial produccion
ALTER TABLE costo_servicio ADD CONSTRAINT modelo_costo_servicio_fk
FOREIGN KEY (mod_codigo)
REFERENCES modelo (mod_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE costo_produccion ADD CONSTRAINT modelo_costo_produccion_fk
FOREIGN KEY (mod_codigo)
REFERENCES modelo (mod_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE costo_produccion ADD CONSTRAINT servicio_costo_produccion_fk
FOREIGN KEY (costserv_codigo)
REFERENCES costo_servicio (costserv_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE costo_produccion_cargo ADD CONSTRAINT costo_produccion_costo_produccion_cargo_fk
FOREIGN KEY (copro_codigo)
REFERENCES costo_produccion (copro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE costo_produccion_item ADD CONSTRAINT costo_produccion_costo_produccion_item_fk
FOREIGN KEY (copro_codigo)
REFERENCES costo_produccion (copro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial compra
ALTER TABLE items ADD CONSTRAINT tipo_item_items_fk
FOREIGN KEY (tipit_codigo)
REFERENCES tipo_item (tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial compra
ALTER TABLE items ADD CONSTRAINT tipo_impuesto_items_fk
FOREIGN KEY (tipim_codigo)
REFERENCES tipo_impuesto (tipim_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimento compras
ALTER TABLE pedido_compra_det ADD CONSTRAINT items_pedido_compra_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE presupuesto_proveedor_det ADD CONSTRAINT items_presupuesto_proveedor_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE orden_compra_det ADD CONSTRAINT items_orden_compra_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado
ALTER TABLE stock ADD CONSTRAINT items_stock_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE nota_compra_det ADD CONSTRAINT items_nota_compra_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE pedido_venta_det ADD CONSTRAINT items_pedido_venta_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE nota_venta_det ADD CONSTRAINT items_nota_venta_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE presupuesto_det ADD CONSTRAINT items_presupuesto_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE pedido_produccion_det ADD CONSTRAINT items_pedido_produccion_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion 
ALTER TABLE orden_produccion_det ADD CONSTRAINT items_orden_produccion_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE produccion_det ADD CONSTRAINT items_produccion_det_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE costo_produccion_item ADD CONSTRAINT items_costo_produccion_item_fk
FOREIGN KEY (it_codigo, tipit_codigo)
REFERENCES items (it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE control_calidad ADD CONSTRAINT produccion_det_control_calidad_fk
FOREIGN KEY (prod_codigo, it_codigo, tipit_codigo)
REFERENCES produccion_det (prod_codigo, it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento produccion
ALTER TABLE etapa_produccion ADD CONSTRAINT orden_produccion_det_etapa_produccion_fk
FOREIGN KEY (orpro_codigo, it_codigo, tipit_codigo)
REFERENCES orden_produccion_det (orpro_codigo, it_codigo, tipit_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE compra_det ADD CONSTRAINT stock_compra_det_fk
FOREIGN KEY (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
REFERENCES stock (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE ajuste_inventario_det ADD CONSTRAINT stock_ajuste_inventario_det_fk
FOREIGN KEY (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
REFERENCES stock (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento venta
ALTER TABLE venta_det ADD CONSTRAINT stock_venta_det_fk
FOREIGN KEY (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
REFERENCES stock (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE mermas_det ADD CONSTRAINT stock_mermas_det_fk
FOREIGN KEY (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
REFERENCES stock (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE produccion_terminada_det ADD CONSTRAINT stock_produccion_terminada_det_fk
FOREIGN KEY (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
REFERENCES stock (it_codigo, tipit_codigo, dep_codigo, suc_codigo, emp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado referencial compra
ALTER TABLE proveedor ADD CONSTRAINT tipo_proveedor_proveedor_fk
FOREIGN KEY (tipro_codigo)
REFERENCES tipo_proveedor (tipro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE presupuesto_proveedor_cab ADD CONSTRAINT proveedor_presupuesto_proveedor_cab_fk
FOREIGN KEY (pro_codigo, tipro_codigo)
REFERENCES proveedor (pro_codigo, tipro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE orden_compra_cab ADD CONSTRAINT proveedor_orden_compra_cab_fk
FOREIGN KEY (pro_codigo, tipro_codigo)
REFERENCES proveedor (pro_codigo, tipro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE compra_cab ADD CONSTRAINT proveedor_compra_cab_fk
FOREIGN KEY (pro_codigo, tipro_codigo)
REFERENCES proveedor (pro_codigo, tipro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE nota_compra_cab ADD CONSTRAINT proveedor_nota_compra_cab_fk
FOREIGN KEY (pro_codigo, tipro_codigo)
REFERENCES proveedor (pro_codigo, tipro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE libro_compra ADD CONSTRAINT compra_cab_libro_compra_fk
FOREIGN KEY (comp_codigo)
REFERENCES compra_cab (comp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE cuenta_pagar ADD CONSTRAINT compra_cab_cuenta_pagar_fk
FOREIGN KEY (comp_codigo)
REFERENCES compra_cab (comp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE compra_det ADD CONSTRAINT compra_cab_compra_det_fk
FOREIGN KEY (comp_codigo)
REFERENCES compra_cab (comp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE orden_compra ADD CONSTRAINT compra_cab_orden_compra_fk
FOREIGN KEY (comp_codigo)
REFERENCES compra_cab (comp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE nota_compra_cab ADD CONSTRAINT compra_cab_nota_compra_cab_fk
FOREIGN KEY (comp_codigo)
REFERENCES compra_cab (comp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE nota_compra_det ADD CONSTRAINT nota_compra_cab_nota_compra_det_fk
FOREIGN KEY (nocom_codigo)
REFERENCES nota_compra_cab (nocom_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE orden_compra_det ADD CONSTRAINT orden_compra_cab_orden_compra_det_fk
FOREIGN KEY (orcom_codigo)
REFERENCES orden_compra_cab (orcom_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE presupuesto_orden ADD CONSTRAINT orden_compra_cab_presupuesto_orden_fk
FOREIGN KEY (orcom_codigo)
REFERENCES orden_compra_cab (orcom_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE orden_compra ADD CONSTRAINT orden_compra_cab_orden_compra_fk
FOREIGN KEY (orcom_codigo)
REFERENCES orden_compra_cab (orcom_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE presupuesto_proveedor_det ADD CONSTRAINT presupuesto_proveedor_cab_presupuesto_proveedor_det_fk
FOREIGN KEY (prepro_codigo)
REFERENCES presupuesto_proveedor_cab (prepro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE pedido_presupuesto ADD CONSTRAINT presupuesto_proveedor_cab_pedido_presupuesto_fk
FOREIGN KEY (prepro_codigo)
REFERENCES presupuesto_proveedor_cab (prepro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE presupuesto_orden ADD CONSTRAINT presupuesto_proveedor_cab_presupuesto_orden_fk
FOREIGN KEY (prepro_codigo)
REFERENCES presupuesto_proveedor_cab (prepro_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Ya agregado movimiento compra
ALTER TABLE libro_compra ADD CONSTRAINT compra_cab_libro_compra_fk
FOREIGN KEY (comp_codigo)
REFERENCES compra_cab (comp_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;