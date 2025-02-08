--Modulo
select * from modulo where (modu_codigo between $desde and $hasta) order by modu_codigo;

--Perfil
select * from perfil where perf_codigo between 1 and 1 order by perf_codigo;

--Permisos
select * from permisos where perm_codigo between 1 and 3 order by perm_codigo;

--Acesso
select * from acceso a where a.acc_fecha between '2023-09-21' and '21-09-2023' order by a.acc_codigo;

--GUI
select g.*, m.modu_descripcion from gui g join modulo m on m.modu_codigo=g.modu_codigo where g.gui_codigo
between 1 and 4 order by g.gui_codigo;

--Perfil Gui
select pg.*, p.perf_descripcion, g.gui_descripcion, m.modu_descripcion from perfil_gui pg join perfil p on p.perf_codigo=pg.perf_codigo join gui g on g.gui_codigo=pg.gui_codigo and g.modu_codigo=pg.modu_codigo join modulo m on m.modu_codigo=g.modu_codigo where pg.perfgui_codigo between 1 and 3 order by pg.perfgui_codigo;

--Perfiles Permisos
select pp.*, perf.perf_descripcion, perm.perm_descripcion from perfiles_permisos pp join perfil perf on perf.perf_codigo=pp.perf_codigo join permisos perm on perm.perm_codigo=pp.perm_codigo where pp.perfpe_codigo between 1 and 2 order by perfpe_codigo:

--Usuario
select u.*, m.modu_descripcion, p.perf_descripcion, p2.per_nombre||' '||p2.per_apellido as funcionario from usuario u join modulo m on m.modu_codigo=u.modu_codigo
join perfil p on p.perf_codigo=u.perf_codigo join funcionario f on f.func_codigo=u.func_codigo join personas p2 on p2.per_codigo=f.per_codigo where u.usu_fecha between 'fecha' and 'fecha' order by u.usu_codigo;

--Asignacion Permiso Usuario
select apu.*, u.usu_login , p.perf_descripcion, p2.perm_descripcion from asignacion_permiso_usuario apu
join usuario u on u.usu_codigo=apu.usu_codigo join perfiles_permisos pp on pp.perfpe_codigo=apu.perfpe_codigo 
and pp.perf_codigo=apu.perf_codigo and pp.perm_codigo=apu.perm_codigo join perfil p on p.perf_codigo=pp.perf_codigo
join permisos p2 on p2.perm_codigo=pp.perm_codigo where apu.asigperm_codigo between 1 and 2 order by apu.asigperm_codigo;