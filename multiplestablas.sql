-- CREAR LA BASE DE DATOS

CREATE DATABASE multiples_tablas;

--  CREAR TABLA DE USUARIOS

CREATE TABLE usuarios (id SERIAL PRIMARY KEY, 
email VARCHAR(100) UNIQUE NOT NULL, 
nombre VARCHAR(50)NOT NULL, 
apellido VARCHAR(50) NOT NULL, 
rol VARCHAR(20) NOT NULL);

-- SE CREAN 5 USUARIOS

insert into Usuarios (email, nombre, apellido, rol) values ('mosto@papy.com', 'Mosto', 'Papy', 'usuario');
insert into Usuarios (email, nombre, apellido, rol) values ('jose@radio.com', 'Jose', 'Fuer', 'administrador');
insert into Usuarios (email, nombre, apellido, rol) values ('humber@google.com', 'Humberto', 'Rodriguez', 'usuario');
insert into Usuarios (email, nombre, apellido, rol) values ('xime@amazon.com', 'Ximena', 'Gimenez', 'usuario');
insert into Usuarios (email, nombre, apellido, rol) values ('Rodri@gmail.com', 'Rodrigo', 'Rodriguez', 'usuario');

-- SE CREA TABLA DE ARTICULOS

CREATE TABLE "Posts (artículos)" (
   id SERIAL PRIMARY KEY,
   titulo VARCHAR(200) NOT NULL,
   contenido TEXT NOT NULL,
   fecha_creacion TIMESTAMP NOT NULL,
   fecha_actualizacion TIMESTAMP NOT NULL,
   destacado BOOLEAN DEFAULT false,
   usuario_id BIGINT
);

-- Se crean 5 posts.

INSERT INTO "Posts (artículos)" (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES 
  ('Bienvenidos a mi Blog', 'Este es el incio de un proyecto que tenia en mente desde hace mucho tiempo, al cual quiero que seas bienvenido. Si deseas apoyarme, solo continua leyendo. Gracias!', '2023-12-06', '2024-01-20', true, 2),
  ('Descubriendo Nuevos Caminos', 'En este articulo, compartiré algunas ideas que de seguro a ti te van a encantar, acompañame en este fascinante viaje', '2024-01-21', '2024-01-19', true, 2),
  ('Tres veces una vez', 'Hoy quiero compartir contigo una historia fascinante sobre un acontecimiento inusual que ocurrió tres veces una vez. ¡No te lo pierdas!', '2024-02-22', '2024-02-25', true, 1),
  ('Mr. Conservador: Goldwater sobre Goldwater', 'Exploraré las ideas conservadoras a través de la perspectiva única de Goldwater en este artículo. Descubre más sobre sus pensamientos y su impacto en la política.', '2024-03-02', '2024-03-04', false, 3),
  ('El Tesoro Secreto de Tarzán', 'Acompaña a Tarzán en su nueva aventura mientras descubre un tesoro secreto. ¿Qué misterios se revelarán en la selva? ¡Descúbrelo en este emocionante relato!', '2024-04-17', '2024-14-12', false, NULL);

-- CREAR TABLA DE COMENTARIOS

CREATE TABLE Comentarios (
   id SERIAL PRIMARY KEY,
   contenido TEXT NOT NULL,
   fecha_creacion TIMESTAMP NOT NULL,
   usuario_id BIGINT NOT NULL,
   post_id BIGINT NOT NULL
);

-- Se crean 5 comentarios.

INSERT INTO Comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES 
  ('Excelente, estoy emocionado al leer estas nuevas aventuras.', '2024-01-20', 1, 1),
  ('Me encantó leer sobre esto, muchas gracias.', '2024-01-19', 2, 1),
  ('¡ME ENCANTA! Me encanta cómo abordas este tema.', '2024-02-22', 3, 1),
  ('Me parece que es un proyecto muy hermoso. Tu perspectiva es única y valiosa.', '2024-03-04', 1, 2),
  ('Gracias por compartir tan interesante contenido.', '2024-14-12', 2, 2);

-- *** --

-- 1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido
--LISTO

-- 2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post.

SELECT Usuarios.nombre, Usuarios.email, "Posts (artículos)".titulo, "Posts (artículos)".contenido
FROM Usuarios
INNER JOIN "Posts (artículos)" ON Usuarios.id = "Posts (artículos)".usuario_id;

-- 3. Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier id.

SELECT "Posts (artículos)".id, "Posts (artículos)".titulo, "Posts (artículos)".contenido
FROM "Posts (artículos)"
JOIN Usuarios ON "Posts (artículos)".usuario_id = Usuarios.id
WHERE Usuarios.rol = 'administrador';

-- 4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario. 

SELECT Usuarios.id, Usuarios.email, COUNT("Posts (artículos)".id) AS cantidad_posts
FROM Usuarios
INNER JOIN "Posts (artículos)" ON Usuarios.id = "Posts (artículos)".usuario_id
GROUP BY Usuarios.id, Usuarios.email;

-- 5. Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email. 

SELECT Usuarios.email, COUNT("Posts (artículos)".id) AS cantidad_posts
FROM Usuarios
INNER JOIN "Posts (artículos)" ON Usuarios.id = "Posts (artículos)".usuario_id
GROUP BY Usuarios.email
ORDER BY cantidad_posts DESC
LIMIT 1;

-- 6. Muestra la fecha del último post de cada usuario. 

SELECT Usuarios.email, "Posts (artículos)".titulo, MAX("Posts (artículos)".fecha_creacion) AS fecha_ultimo_post
FROM Usuarios
LEFT JOIN "Posts (artículos)" ON Usuarios.id = "Posts (artículos)".usuario_id
GROUP BY Usuarios.email, "Posts (artículos)".titulo;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios. 

SELECT "Posts (artículos)".titulo, "Posts (artículos)".contenido, COUNT(Comentarios.id) AS cantidad_comentarios
FROM "Posts (artículos)"
LEFT JOIN Comentarios ON "Posts (artículos)".id = Comentarios.post_id
GROUP BY "Posts (artículos)".titulo, "Posts (artículos)".contenido
ORDER BY cantidad_comentarios DESC
LIMIT 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió. 

SELECT "Posts (artículos)".titulo, "Posts (artículos)".contenido
FROM "Posts (artículos)"
LEFT JOIN Comentarios ON "Posts (artículos)".id = Comentarios.post_id

SELECT
    "Posts (artículos)".titulo AS titulo_post,
    "Posts (artículos)".contenido AS contenido_post,
    Comentarios.contenido AS contenido_comentario,
    Usuarios.email AS email_usuario
FROM
    "Posts (artículos)"
JOIN
    Comentarios ON "Posts (artículos)".id = Comentarios.post_id
JOIN
    Usuarios ON Comentarios.usuario_id = Usuarios.id;

-- 9. Muestra el contenido del último comentario de cada usuario. 

SELECT
    Usuarios.email AS email_usuario,
    Comentarios.contenido AS contenido_ultimo_comentario
FROM
    Usuarios
JOIN Comentarios ON Usuarios.id = Comentarios.usuario_id
LEFT JOIN Comentarios AS com2 ON Comentarios.usuario_id = com2.usuario_id AND Comentarios.fecha_creacion < com2.fecha_creacion
WHERE
    com2.fecha_creacion IS NULL;

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario. Hint: Recuerda el uso de Having 

SELECT Usuarios.email
FROM Usuarios
LEFT JOIN Comentarios ON Usuarios.id = Comentarios.usuario_id
GROUP BY Usuarios.id, Usuarios.email
HAVING COUNT(Comentarios.id) = 0;