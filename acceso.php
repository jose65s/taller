<?php
session_start();
header('Content-type: application/json; charset=utf-8');
require_once "{$_SERVER['DOCUMENT_ROOT']}/Electronic/app/clases/Conexion.php";
$objConexion = new Conexion();
$conexion = $objConexion->getConexion();

$usuario = $_POST['usu_login'];
$clave = $_POST['usu_clave'];

$sql = "select 
            u.*,
            p.per_nombres,
            p.per_apellidos,
            p.per_email,
            p2.per_descripcion, 
            s.suc_nombre 
        from usuarios u
            join funcionarios f on f.id_funcionario = u.id_funcionario 
            join personas p on p.id_persona = f.id_persona
            join perfiles p2 on p2.id_perfil = u.id_perfil 
            join sucursales s on s.id_sucursal = u.id_sucursal 
            where usu_login = '$usuario' and usu_clave = md5('$clave');";
    $resultado = pg_query($conexion,$sql);
    $datos = pg_fetch_assoc($resultado);
    if(!(!$datos)){
        $_SESSION['usuario'] = $datos; 
    }
    echo json_encode($datos); 
?>