PGDMP     	                
    |        
   Electronic    15.8    15.8 ?    ]           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ^           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            _           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            `           1262    16398 
   Electronic    DATABASE     �   CREATE DATABASE "Electronic" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Paraguay.1252';
    DROP DATABASE "Electronic";
                postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                postgres    false            a           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   postgres    false    5            �            1255    16399 \   sp_pedidos_ventas(integer, timestamp without time zone, integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_pedidos_ventas(idpedido integer, pedfechapedido timestamp without time zone, idcliente integer, pedobservaciones character varying, operacion integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare ultcod integer;
begin
	if operacion = 1 then
		ultcod = (select coalesce(max(id_pedido),0)+1 from pedidos_ventas);
		INSERT INTO public.pedidos_ventas
				(id_pedido, 
				ped_fecha_registro, 
				ped_fecha_pedido, 
				id_cliente, 
				ped_observaciones, 
				ped_estado)
		values	(ultcod, 
				current_timestamp, 
				pedfechapedido, 
				idcliente, 
				upper(pedobservaciones), 
				'PENDIENTE');
		raise notice 'EL NUEVO PEDIDO FUE REGISTRADO CON EXITO';
		return ultcod;			
	end if;
	if operacion = 2 then
		update pedidos_ventas 
		set ped_estado = 'ANULADO'
		where id_pedido = idpedido;
		raise notice 'EL PEDIDO FUE ANULADO CON EXITO';
		return idpedido;
	end if;
end

$$;
 �   DROP FUNCTION public.sp_pedidos_ventas(idpedido integer, pedfechapedido timestamp without time zone, idcliente integer, pedobservaciones character varying, operacion integer);
       public          postgres    false    5            �            1255    16400 P   sp_pedidos_ventas_detalles(integer, integer, numeric, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.sp_pedidos_ventas_detalles(idpedido integer, idproducto integer, pvdcantidad numeric, pvdprecio integer, idtipo integer, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin 
	if operacion = 1 then 
		INSERT INTO public.pedidos_ventas_detalles
			(
				id_pedido, 
				id_producto, 
				pvd_cantidad, 
				pvd_precio, 
				id_tipo)
		VALUES(
				idpedido, 
				idproducto,
				pvdcantidad, 
				pvdprecio, 
				idtipo);
		raise notice 'EL DETALLE DEL PEDIDO FUE REGISTRADO CON EXITO';
	end if;
	if operacion = 2 then
		delete from pedidos_ventas_detalles
		where id_pedido = idpedido and id_producto = idproducto;
		raise notice 'EL DETALLE DEL PEDIDO FUE ELIMINADO CON EXITO';
end if;
end 
$$;
 �   DROP FUNCTION public.sp_pedidos_ventas_detalles(idpedido integer, idproducto integer, pvdcantidad numeric, pvdprecio integer, idtipo integer, operacion integer);
       public          postgres    false    5            �            1255    16401 |   sp_personas(integer, character varying, character varying, character varying, character varying, character varying, integer)    FUNCTION     5  CREATE FUNCTION public.sp_personas(idpersona integer, pernombres character varying, perapellidos character varying, pernrodocumento character varying, pertelefono character varying, peremail character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin 
    if operacion in(1,2) then
        if pernombres = '' then
            raise exception 'DEBE PROPORCIONAR EL NOMBRE';
        end if;
        if perapellidos = '' then
            raise exception 'DEBE PROPORCIONAR EL APELLIDO';
        end if;
       if pernrodocumento = '' then
            raise exception 'DEBE PROPORCIONAR EL NUMERO DE DOCUMENTO';
        end if;
        perform * from personas
        where per_nro_documento = pernrodocumento
        and id_persona != idpersona;
        if found then
            raise exception 'ESTA PERSONA YA EXISTE';
        end if;
    end if;
    if operacion = 1 then
        -- aqui hacemos un insert
        INSERT INTO personas  
        (id_persona, 
        per_nombres, 
        per_apellidos, 
        per_nro_documento, 
        per_telefono, 
        per_email)
        VALUES(
        (select coalesce(max(id_persona), 0)+1 from personas), 
        upper(pernombres),
        upper(perapellidos),
        pernrodocumento, 
        pertelefono,
        per_email);
        raise notice 'LA PERSONA FUE REGISTRADO CON EXITO';
    end if;
    if operacion = 2 then
        -- aqui hacemos un update
        UPDATE personas
        SET per_nombres=upper(pernombres),
      		per_nombres=upper(pernombres), 
            per_nro_documento=pernrodocumento, 
            per_telefono=pertelefono, 
            per_telefono=pertelefono, 
            per_email=peremail
        WHERE id_persona=idpersona;
        raise notice 'LOS DATOS DE LA PERSONA FUE MODIFICADO CON EXITO';
    end if;
    if operacion = 3 then
        -- aqui hacemos un delete
        delete from personas
        where id_persona = idpersona;
        raise notice 'EL REGISTRO DE LA PERSONA FUE ELIMINADO CON EXITO';
    end if;
end
$$;
 �   DROP FUNCTION public.sp_personas(idpersona integer, pernombres character varying, perapellidos character varying, pernrodocumento character varying, pertelefono character varying, peremail character varying, operacion integer);
       public          postgres    false    5            �            1255    16402 �   sp_personas(integer, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, integer)    FUNCTION     �  CREATE FUNCTION public.sp_personas(idpersona integer, pernombres character varying, perapellidos character varying, pernrodocumento character varying, pertelefono character varying, peremail character varying, perfechanac timestamp without time zone, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin 
    if operacion in(1,2) then
        if pernombres = '' then
            raise exception 'DEBE PROPORCIONAR EL NOMBRE';
        end if;
        if perapellidos = '' then
            raise exception 'DEBE PROPORCIONAR EL APELLIDO';
        end if;
       if pernrodocumento = '' then
            raise exception 'DEBE PROPORCIONAR EL NUMERO DE DOCUMENTO';
        end if;
        perform * from personas
        where per_nro_documento = pernrodocumento
        and id_persona != idpersona;
        if found then
            raise exception 'ESTA PERSONA YA EXISTE';
        end if;
    end if;
    if operacion = 1 then
        -- aqui hacemos un insert
        INSERT INTO personas  
        (id_persona, 
        per_nombres, 
        per_apellidos, 
        per_nro_documento, 
        per_telefono, 
        per_email,
        per_fecha_nac)
        VALUES(
        (select coalesce(max(id_persona), 0)+1 from personas), 
        upper(pernombres),
        upper(perapellidos),
        pernrodocumento, 
        pertelefono,
        per_email,
        per_fecha_nac);
        raise notice 'LA PERSONA FUE REGISTRADO CON EXITO';
    end if;
    if operacion = 2 then
        -- aqui hacemos un update
        UPDATE personas
        SET per_nombres=upper(pernombres),
      		per_nombres=upper(pernombres), 
            per_nro_documento=pernrodocumento, 
            per_telefono=pertelefono, 
            per_telefono=pertelefono, 
            per_email=peremail,
            per_fecha_nac=perfechanac
        WHERE id_persona=idpersona;
        raise notice 'LOS DATOS DE LA PERSONA FUE MODIFICADO CON EXITO';
    end if;
    if operacion = 3 then
        -- aqui hacemos un delete
        delete from personas
        where id_persona = idpersona;
        raise notice 'EL REGISTRO DE LA PERSONA FUE ELIMINADO CON EXITO';
    end if;
end
$$;
   DROP FUNCTION public.sp_personas(idpersona integer, pernombres character varying, perapellidos character varying, pernrodocumento character varying, pertelefono character varying, peremail character varying, perfechanac timestamp without time zone, operacion integer);
       public          postgres    false    5            �            1255    16403 �   sp_personas(integer, character varying, character varying, character varying, character varying, character varying, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.sp_personas(idpersona integer, pernombres character varying, perapellidos character varying, pernrodocumento character varying, pertelefono character varying, peremail character varying, perfechanac character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin 
    if operacion in(1,2) then
        if pernombres = '' then
            raise exception 'DEBE PROPORCIONAR EL NOMBRE';
        end if;
        if perapellidos = '' then
            raise exception 'DEBE PROPORCIONAR EL APELLIDO';
        end if;
       if pernrodocumento = '' then
            raise exception 'DEBE PROPORCIONAR EL NUMERO DE DOCUMENTO';
        end if;
        perform * from personas
        where per_nro_documento = pernrodocumento
        and id_persona != idpersona;
        if found then
            raise exception 'ESTA PERSONA YA EXISTE';
        end if;
    end if;
    if operacion = 1 then
        -- aqui hacemos un insert
        INSERT INTO personas  
        (id_persona, 
        per_nombres, 
        per_apellidos, 
        per_nro_documento, 
        per_telefono, 
        per_email,
        per_fecha_nac)
        VALUES(
        (select coalesce(max(id_persona), 0)+1 from personas), 
        upper(pernombres),
        upper(perapellidos),
        pernrodocumento, 
        pertelefono,
        per_email,
        per_fecha_nac);
        raise notice 'LA PERSONA FUE REGISTRADO CON EXITO';
    end if;
    if operacion = 2 then
        -- aqui hacemos un update
        UPDATE personas
        SET per_nombres=upper(pernombres),
      		per_nombres=upper(pernombres), 
            per_nro_documento=pernrodocumento, 
            per_telefono=pertelefono, 
            per_telefono=pertelefono, 
            per_email=peremail,
            per_fecha_nac=perfechanac
        WHERE id_persona=idpersona;
        raise notice 'LOS DATOS DE LA PERSONA FUE MODIFICADO CON EXITO';
    end if;
    if operacion = 3 then
        -- aqui hacemos un delete
        delete from personas
        where id_persona = idpersona;
        raise notice 'EL REGISTRO DE LA PERSONA FUE ELIMINADO CON EXITO';
    end if;
end
$$;
   DROP FUNCTION public.sp_personas(idpersona integer, pernombres character varying, perapellidos character varying, pernrodocumento character varying, pertelefono character varying, peremail character varying, perfechanac character varying, operacion integer);
       public          postgres    false    5            �            1255    16404    sp_proveedores(integer, character varying, character varying, character varying, character varying, character varying, integer)    FUNCTION       CREATE FUNCTION public.sp_proveedores(idproveedor integer, prorazon character varying, proruc character varying, protel character varying, prodir character varying, proemail character varying, operacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin 
    if operacion in(1,2) then
        if prorazon = '' then
            raise exception 'DEBE PROPORCIONAR LA RAZON SOCIAL';
        end if;
        if proruc = '' then
            raise exception 'DEBE PROPORCIONAR EL RUC';
        end if;
        perform * from proveedores
        where pro_ruc = proruc
        and id_proveedor != idproveedor;
        if found then
            raise exception 'ESTE PROVEEDOR YA EXISTE';
        end if;
    end if;
    if operacion = 1 then
        -- aqui hacemos un insert
        INSERT INTO proveedores 
        (id_proveedor, 
        pro_razon, 
        pro_ruc, 
        pro_tel, 
        pro_dir, 
        pro_email)
        VALUES(
        (select coalesce(max(id_proveedor), 0)+1 from proveedores), 
        upper(prorazon), 
        proruc, 
        protel, 
        upper(prodir), 
        proemail);
        raise notice 'EL PROVEEDRO FUE REGISTRADO CON EXITO';
    end if;
    if operacion = 2 then
        -- aqui hacemos un update
        UPDATE proveedores
        SET pro_razon=upper(prorazon), 
            pro_ruc=proruc, 
            pro_tel=protel, 
            pro_dir=upper(prodir), 
            pro_email=proemail
        WHERE id_proveedor=idproveedor;
        raise notice 'EL PROVEEDRO FUE MODIFICADO CON EXITO';
    end if;
    if operacion = 3 then
        -- aqui hacemos un delete
        delete from proveedores
        where id_proveedor = idproveedor;
        raise notice 'EL PROVEEDOR FUE ELIMINADO CON EXITO';
    end if;
end
$$;
 �   DROP FUNCTION public.sp_proveedores(idproveedor integer, prorazon character varying, proruc character varying, protel character varying, prodir character varying, proemail character varying, operacion integer);
       public          postgres    false    5            �            1259    16405    cargos    TABLE     o   CREATE TABLE public.cargos (
    id_cargos integer NOT NULL,
    car_descripcion character varying NOT NULL
);
    DROP TABLE public.cargos;
       public         heap    postgres    false    5            �            1259    16410    clientes    TABLE     �   CREATE TABLE public.clientes (
    id_cliente integer NOT NULL,
    cli_ruc character varying NOT NULL,
    id_persona integer NOT NULL,
    cli_direccion character varying
);
    DROP TABLE public.clientes;
       public         heap    postgres    false    5            �            1259    16415    empresas    TABLE     R  CREATE TABLE public.empresas (
    id_empresa integer NOT NULL,
    emp_denominacion character varying NOT NULL,
    emp_ruc character varying(25) NOT NULL,
    emp_direccion character varying NOT NULL,
    emp_telefono character varying NOT NULL,
    emp_email character varying NOT NULL,
    emp_actividad character varying NOT NULL
);
    DROP TABLE public.empresas;
       public         heap    postgres    false    5            �            1259    16420    funcionarios    TABLE     �   CREATE TABLE public.funcionarios (
    id_funcionario integer NOT NULL,
    fun_fecha_ingreso character varying NOT NULL,
    id_persona integer NOT NULL,
    id_cargos integer NOT NULL
);
     DROP TABLE public.funcionarios;
       public         heap    postgres    false    5            �            1259    16425    pedidos_ventas    TABLE       CREATE TABLE public.pedidos_ventas (
    id_pedido integer NOT NULL,
    ped_fecha_registro timestamp without time zone,
    ped_fecha_pedido timestamp without time zone,
    id_cliente integer,
    ped_observaciones character varying,
    ped_estado character varying
);
 "   DROP TABLE public.pedidos_ventas;
       public         heap    postgres    false    5            �            1259    16430    pedidos_ventas_detalles    TABLE     �   CREATE TABLE public.pedidos_ventas_detalles (
    id_pedido integer NOT NULL,
    id_producto integer NOT NULL,
    pvd_cantidad numeric,
    pvd_precio integer,
    id_tipo integer
);
 +   DROP TABLE public.pedidos_ventas_detalles;
       public         heap    postgres    false    5            �            1259    16435    perfiles    TABLE     q   CREATE TABLE public.perfiles (
    id_perfil integer NOT NULL,
    per_descripcion character varying NOT NULL
);
    DROP TABLE public.perfiles;
       public         heap    postgres    false    5            �            1259    16440    personas    TABLE     ]  CREATE TABLE public.personas (
    id_persona integer NOT NULL,
    per_nombres character varying NOT NULL,
    per_apellidos character varying NOT NULL,
    per_nro_documento character varying NOT NULL,
    per_telefono character varying NOT NULL,
    per_email character varying NOT NULL,
    per_fecha_nac timestamp without time zone NOT NULL
);
    DROP TABLE public.personas;
       public         heap    postgres    false    5            �            1259    16445 	   productos    TABLE     �   CREATE TABLE public.productos (
    id_producto integer NOT NULL,
    pro_descri character varying NOT NULL,
    pro_costo integer,
    pro_precio integer,
    pro_estado character varying NOT NULL,
    id_tipo integer
);
    DROP TABLE public.productos;
       public         heap    postgres    false    5            �            1259    16450    proveedores    TABLE     �   CREATE TABLE public.proveedores (
    id_proveedor integer NOT NULL,
    pro_razon character varying NOT NULL,
    pro_ruc character varying NOT NULL,
    pro_tel character varying,
    pro_dir character varying,
    pro_email character varying
);
    DROP TABLE public.proveedores;
       public         heap    postgres    false    5            �            1259    16455 
   sucursales    TABLE       CREATE TABLE public.sucursales (
    id_sucursal integer NOT NULL,
    suc_nombre character varying NOT NULL,
    suc_direccion character varying NOT NULL,
    suc_email character varying NOT NULL,
    suc_telefono character varying NOT NULL,
    id_empresa integer NOT NULL
);
    DROP TABLE public.sucursales;
       public         heap    postgres    false    5            �            1259    16460    tipo_impuestos    TABLE     v   CREATE TABLE public.tipo_impuestos (
    id_tipo integer NOT NULL,
    tipo_descripcion character varying NOT NULL
);
 "   DROP TABLE public.tipo_impuestos;
       public         heap    postgres    false    5            �            1259    16465    usuarios    TABLE     (  CREATE TABLE public.usuarios (
    id_usuario integer NOT NULL,
    usu_login character varying NOT NULL,
    usu_clave character varying NOT NULL,
    usu_estado character varying NOT NULL,
    id_funcionario integer NOT NULL,
    id_sucursal integer NOT NULL,
    id_perfil integer NOT NULL
);
    DROP TABLE public.usuarios;
       public         heap    postgres    false    5            N          0    16405    cargos 
   TABLE DATA           <   COPY public.cargos (id_cargos, car_descripcion) FROM stdin;
    public          postgres    false    214   �|       O          0    16410    clientes 
   TABLE DATA           R   COPY public.clientes (id_cliente, cli_ruc, id_persona, cli_direccion) FROM stdin;
    public          postgres    false    215   *}       P          0    16415    empresas 
   TABLE DATA           �   COPY public.empresas (id_empresa, emp_denominacion, emp_ruc, emp_direccion, emp_telefono, emp_email, emp_actividad) FROM stdin;
    public          postgres    false    216   �}       Q          0    16420    funcionarios 
   TABLE DATA           `   COPY public.funcionarios (id_funcionario, fun_fecha_ingreso, id_persona, id_cargos) FROM stdin;
    public          postgres    false    217   ~       R          0    16425    pedidos_ventas 
   TABLE DATA           �   COPY public.pedidos_ventas (id_pedido, ped_fecha_registro, ped_fecha_pedido, id_cliente, ped_observaciones, ped_estado) FROM stdin;
    public          postgres    false    218   4~       S          0    16430    pedidos_ventas_detalles 
   TABLE DATA           l   COPY public.pedidos_ventas_detalles (id_pedido, id_producto, pvd_cantidad, pvd_precio, id_tipo) FROM stdin;
    public          postgres    false    219   &       T          0    16435    perfiles 
   TABLE DATA           >   COPY public.perfiles (id_perfil, per_descripcion) FROM stdin;
    public          postgres    false    220   �       U          0    16440    personas 
   TABLE DATA           �   COPY public.personas (id_persona, per_nombres, per_apellidos, per_nro_documento, per_telefono, per_email, per_fecha_nac) FROM stdin;
    public          postgres    false    221   �       V          0    16445 	   productos 
   TABLE DATA           h   COPY public.productos (id_producto, pro_descri, pro_costo, pro_precio, pro_estado, id_tipo) FROM stdin;
    public          postgres    false    222   ߀       W          0    16450    proveedores 
   TABLE DATA           d   COPY public.proveedores (id_proveedor, pro_razon, pro_ruc, pro_tel, pro_dir, pro_email) FROM stdin;
    public          postgres    false    223   x�       X          0    16455 
   sucursales 
   TABLE DATA           q   COPY public.sucursales (id_sucursal, suc_nombre, suc_direccion, suc_email, suc_telefono, id_empresa) FROM stdin;
    public          postgres    false    224   �       Y          0    16460    tipo_impuestos 
   TABLE DATA           C   COPY public.tipo_impuestos (id_tipo, tipo_descripcion) FROM stdin;
    public          postgres    false    225   b�       Z          0    16465    usuarios 
   TABLE DATA           x   COPY public.usuarios (id_usuario, usu_login, usu_clave, usu_estado, id_funcionario, id_sucursal, id_perfil) FROM stdin;
    public          postgres    false    226   ��       �           2606    16471    cargos cargos_pk 
   CONSTRAINT     U   ALTER TABLE ONLY public.cargos
    ADD CONSTRAINT cargos_pk PRIMARY KEY (id_cargos);
 :   ALTER TABLE ONLY public.cargos DROP CONSTRAINT cargos_pk;
       public            postgres    false    214            �           2606    16473    clientes clientes_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pk PRIMARY KEY (id_cliente);
 >   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pk;
       public            postgres    false    215            �           2606    16475    empresas empresas_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.empresas
    ADD CONSTRAINT empresas_pk PRIMARY KEY (id_empresa);
 >   ALTER TABLE ONLY public.empresas DROP CONSTRAINT empresas_pk;
       public            postgres    false    216            �           2606    16477    funcionarios funcionarios_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pk PRIMARY KEY (id_funcionario);
 F   ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_pk;
       public            postgres    false    217            �           2606    16479 4   pedidos_ventas_detalles pedidos_ventas_detalles_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_ventas_detalles
    ADD CONSTRAINT pedidos_ventas_detalles_pkey PRIMARY KEY (id_pedido, id_producto);
 ^   ALTER TABLE ONLY public.pedidos_ventas_detalles DROP CONSTRAINT pedidos_ventas_detalles_pkey;
       public            postgres    false    219    219            �           2606    16481 "   pedidos_ventas pedidos_ventas_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.pedidos_ventas
    ADD CONSTRAINT pedidos_ventas_pkey PRIMARY KEY (id_pedido);
 L   ALTER TABLE ONLY public.pedidos_ventas DROP CONSTRAINT pedidos_ventas_pkey;
       public            postgres    false    218            �           2606    16483    perfiles perfiles_pk 
   CONSTRAINT     Y   ALTER TABLE ONLY public.perfiles
    ADD CONSTRAINT perfiles_pk PRIMARY KEY (id_perfil);
 >   ALTER TABLE ONLY public.perfiles DROP CONSTRAINT perfiles_pk;
       public            postgres    false    220            �           2606    16485    personas personas_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.personas
    ADD CONSTRAINT personas_pk PRIMARY KEY (id_persona);
 >   ALTER TABLE ONLY public.personas DROP CONSTRAINT personas_pk;
       public            postgres    false    221            �           2606    16487    productos productos_pk 
   CONSTRAINT     ]   ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pk PRIMARY KEY (id_producto);
 @   ALTER TABLE ONLY public.productos DROP CONSTRAINT productos_pk;
       public            postgres    false    222            �           2606    16489    proveedores proveedores_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id_proveedor);
 F   ALTER TABLE ONLY public.proveedores DROP CONSTRAINT proveedores_pkey;
       public            postgres    false    223            �           2606    16491    sucursales sucursales_pk 
   CONSTRAINT     _   ALTER TABLE ONLY public.sucursales
    ADD CONSTRAINT sucursales_pk PRIMARY KEY (id_sucursal);
 B   ALTER TABLE ONLY public.sucursales DROP CONSTRAINT sucursales_pk;
       public            postgres    false    224            �           2606    16493     tipo_impuestos tipo_impuestos_pk 
   CONSTRAINT     c   ALTER TABLE ONLY public.tipo_impuestos
    ADD CONSTRAINT tipo_impuestos_pk PRIMARY KEY (id_tipo);
 J   ALTER TABLE ONLY public.tipo_impuestos DROP CONSTRAINT tipo_impuestos_pk;
       public            postgres    false    225            �           2606    16495    usuarios usuarios_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pk PRIMARY KEY (id_usuario);
 >   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_pk;
       public            postgres    false    226            �           2606    16496 #   funcionarios cargos_funcionarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT cargos_funcionarios_fk FOREIGN KEY (id_cargos) REFERENCES public.cargos(id_cargos);
 M   ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT cargos_funcionarios_fk;
       public          postgres    false    3227    217    214            �           2606    16501 !   sucursales empresas_sucursales_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.sucursales
    ADD CONSTRAINT empresas_sucursales_fk FOREIGN KEY (id_empresa) REFERENCES public.empresas(id_empresa);
 K   ALTER TABLE ONLY public.sucursales DROP CONSTRAINT empresas_sucursales_fk;
       public          postgres    false    216    3231    224            �           2606    16506 !   usuarios funcionarios_usuarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT funcionarios_usuarios_fk FOREIGN KEY (id_funcionario) REFERENCES public.funcionarios(id_funcionario);
 K   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT funcionarios_usuarios_fk;
       public          postgres    false    226    3233    217            �           2606    16511 >   pedidos_ventas_detalles pedidos_ventas_detalles_id_pedido_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_ventas_detalles
    ADD CONSTRAINT pedidos_ventas_detalles_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES public.pedidos_ventas(id_pedido) ON UPDATE CASCADE ON DELETE RESTRICT;
 h   ALTER TABLE ONLY public.pedidos_ventas_detalles DROP CONSTRAINT pedidos_ventas_detalles_id_pedido_fkey;
       public          postgres    false    3235    219    218            �           2606    16516 @   pedidos_ventas_detalles pedidos_ventas_detalles_id_producto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_ventas_detalles
    ADD CONSTRAINT pedidos_ventas_detalles_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto) ON UPDATE CASCADE ON DELETE RESTRICT;
 j   ALTER TABLE ONLY public.pedidos_ventas_detalles DROP CONSTRAINT pedidos_ventas_detalles_id_producto_fkey;
       public          postgres    false    219    3243    222            �           2606    16521 7   pedidos_ventas_detalles pedidos_ventas_detalles_tipo_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_ventas_detalles
    ADD CONSTRAINT pedidos_ventas_detalles_tipo_fk FOREIGN KEY (id_tipo) REFERENCES public.tipo_impuestos(id_tipo) ON UPDATE CASCADE ON DELETE RESTRICT;
 a   ALTER TABLE ONLY public.pedidos_ventas_detalles DROP CONSTRAINT pedidos_ventas_detalles_tipo_fk;
       public          postgres    false    219    225    3249            �           2606    16526 -   pedidos_ventas pedidos_ventas_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos_ventas
    ADD CONSTRAINT pedidos_ventas_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT;
 W   ALTER TABLE ONLY public.pedidos_ventas DROP CONSTRAINT pedidos_ventas_id_cliente_fkey;
       public          postgres    false    218    215    3229            �           2606    16531    usuarios perfiles_usuarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT perfiles_usuarios_fk FOREIGN KEY (id_perfil) REFERENCES public.perfiles(id_perfil);
 G   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT perfiles_usuarios_fk;
       public          postgres    false    226    3239    220            �           2606    16536    clientes personas_clientes_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT personas_clientes_fk FOREIGN KEY (id_persona) REFERENCES public.personas(id_persona) ON UPDATE CASCADE ON DELETE RESTRICT;
 G   ALTER TABLE ONLY public.clientes DROP CONSTRAINT personas_clientes_fk;
       public          postgres    false    3241    221    215            �           2606    16541 %   funcionarios personas_funcionarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT personas_funcionarios_fk FOREIGN KEY (id_persona) REFERENCES public.personas(id_persona);
 O   ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT personas_funcionarios_fk;
       public          postgres    false    3241    217    221            �           2606    16546     productos productos_id_tipo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_id_tipo_fkey FOREIGN KEY (id_tipo) REFERENCES public.tipo_impuestos(id_tipo) ON UPDATE CASCADE ON DELETE RESTRICT;
 J   ALTER TABLE ONLY public.productos DROP CONSTRAINT productos_id_tipo_fkey;
       public          postgres    false    222    225    3249            �           2606    16551    usuarios sucursales_usuarios_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT sucursales_usuarios_fk FOREIGN KEY (id_sucursal) REFERENCES public.sucursales(id_sucursal);
 I   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT sucursales_usuarios_fk;
       public          postgres    false    3247    224    226            N      x�3�tt����	rt�R������ =��      O   ^   x�3�417560�Ե�4�<<���)�ˈ�������Lגӈ�18����ߏ˘��,�k�i����������e�	Tlnii�k�i3%F��� ���      P   ^   x�3�t�IM.)���L�442615ӵ�<<���)�3.吞��������˙��� f����8*��*8�x:���+���:���y:9\1z\\\ �O&      Q      x�3�42�74�7204�4�4����� )'G      R   �   x���Kj�0E��*���+齙!�RH;���QۃD4��܏���hB�(_P��&�J$���	ڼ���]?���F~ުD't�TЌr/= 2 � '� �L.�ȬT�� � )�R�y: K��\����v)I3�?��|��� v�$L��[� ���*�:M0�@�
[�"o&�ϭ� ��2������l�H��t��r/���b��      S   [   x�M���0�f�
�f��?GIS��8Ζuf(��a����2
E�/ck3ȎE�e���+չ���!��2s�;��ΒW鹈���U      T   <   x�3�tt����	rt��2�s�q�2�t���L8�\�\�B<���b���� ��      U   �   x�]�Mj�0������h�߮"�	5�]l�	وք;.5��=Jϐ�U2m
��A��=�r�+x*�bRP.�tV���t�o�{w^���Qp�\C�[&ˡ�����3J/F"$s�0�$����׍A%�j(x�ͽ�m]��CJ��q.1�X��6��t:��Ι������45�u�#�l��Ǥ:�Xa��������r�;~�K ��&�YM}X��Z��:��"�S��ʲ�6;S�      V   �   x�m�;� D��� "�����lc�����@J3�<���v|BV�GZ�R�m��5�O��AV�>�4]���t���85"�p'����2g�
g;R�^�ӐkO�[$��5b+�Ѿ0$�.����!��i4�      W   �   x�3�v�Wpv��4��413ѵ�4��0U046R042�<<���)��8� ?95�A/9?�ˈ3$�3���_!Xϑ����������X��Ԍ�18����ߏ��(�4/-�՘��?�?���d'�R#�������$B���qqq  i,y      X   :   x�3�tvvT�u	��<<���)�31+�A/9?�����P���D��̜Ӑ+F��� U,�      Y   )   x�3�t�p�q�2�trstqT0U�2�sT�b���� ��I      Z   A   x�3��J��MLI�420JN�43JL6�4072M��M�R��M��8�C<��9A�+F��� ��1     