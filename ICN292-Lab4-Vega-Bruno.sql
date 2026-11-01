DROP DATABASE IF EXISTS austral;
CREATE DATABASE austral;
USE austral;
CREATE TABLE autores (
    id_autor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    pais VARCHAR(60),
    genero ENUM('Cómic', 'Ensayo', 'Infantil', 'Novela', 'Poesía') NOT NULL
);

CREATE TABLE colecciones (
    id_coleccion INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(120) NOT NULL,
    fecha_publicacion DATE NOT NULL
);

CREATE TABLE libros (
    id_libro INT PRIMARY KEY AUTO_INCREMENT,
    id_autor INT NOT NULL,
    id_coleccion INT,
    titulo VARCHAR(120) NOT NULL,
    paginas INT,
    ejemplares_vendidos INT,
    anio INT,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_coleccion) REFERENCES colecciones(id_coleccion)
);

CREATE TABLE pagos (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_autor INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

INSERT INTO autores (nombre, pais, genero)
VALUES
('Elena Pizarro', 'Chile', 'Novela'),
('Harold Finch', 'Inglaterra', 'Ensayo'),
('Rodrigo Bahamonde', 'Chile', 'Poesía'),
('Valentina Correa', 'Argentina', 'Infantil'),
('Nora Keller', 'Estados Unidos', 'Novela'),
('Kenji Arakawa', NULL, 'Cómic');

INSERT INTO libros
(id_autor, titulo, paginas, ejemplares_vendidos, anio)
VALUES
(1, 'Cielo de Enero', 210, 1500, 2024),
(1, 'Marea Baja', 185, 800, 2023),
(1, 'El Norte', 200, 2200, 2024),
(2, 'Estrellas que Caen', 240, 3000, 2022),
(2, 'Máquinas', 215, 450, 2024),
(3, 'Luz Artificial', 300, 1200, 2024),
(3, 'Ruido Blanco', 280, 600, 2023),
(4, 'El Barrio de Lila', 190, 5000, 2024),
(4, 'Antes del Amanecer', 205, 2700, 2024),
(4, 'La Calle 8', 175, 900, 2023),
(5, 'Flor de Hierro', 195, 4100, 2024),
(5, 'Hora Dorada', 220, 1800, 2022);

-- Consulta 1
SELECT nombre, genero
FROM autores
WHERE pais <> 'Chile' OR pais IS NULL
ORDER BY nombre;

-- Consulta 2
SELECT titulo, paginas
FROM libros
WHERE paginas BETWEEN 190 AND 220
ORDER BY paginas ASC;

-- Consulta 3
SELECT
    COUNT(*) AS cantidad_libros,
    SUM(ejemplares_vendidos) AS total_vendidos,
    AVG(paginas) AS promedio_paginas,
    MIN(anio) AS anio_mas_antiguo,
    MAX(ejemplares_vendidos) AS mayor_venta
FROM libros;

-- Consulta 4
SELECT DISTINCT genero
FROM autores
ORDER BY genero ASC;

-- Consulta 5
SELECT a.nombre, COUNT(*) AS cantidad_libros
FROM autores AS a
JOIN libros AS l ON a.id_autor = l.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor, a.nombre
HAVING COUNT(*) > 1
ORDER BY a.nombre;

-- Consulta 6
SELECT titulo, ejemplares_vendidos
FROM libros
WHERE anio = 2024 AND ejemplares_vendidos > 2000
ORDER BY ejemplares_vendidos DESC
LIMIT 3;

-- Consulta 7
INSERT INTO libros
(id_autor, titulo, paginas, ejemplares_vendidos, anio)
VALUES
(3, 'Papel Mojado', 260, 50, 2024);

SELECT *
FROM libros
WHERE titulo = 'Papel Mojado';

DELETE FROM libros
WHERE titulo = 'Papel Mojado';

SELECT *
FROM libros
WHERE titulo = 'Papel Mojado';

-- Consulta 8
SELECT titulo, ejemplares_vendidos
FROM libros
WHERE titulo = 'Cielo de Enero';

UPDATE libros
SET ejemplares_vendidos = ejemplares_vendidos + 100
WHERE titulo = 'Cielo de Enero';

SELECT titulo, ejemplares_vendidos
FROM libros
WHERE titulo = 'Cielo de Enero';

-- Consulta 9: datos de prueba
INSERT INTO colecciones (titulo, fecha_publicacion)
VALUES
('Voces Contemporáneas', '2024-03-15'),
('Mundos de Papel', '2024-08-20');

UPDATE libros
SET id_coleccion = 1
WHERE id_autor BETWEEN 1 AND 3;

UPDATE libros
SET id_coleccion = 2
WHERE id_autor BETWEEN 4 AND 5;

SELECT
    l.titulo AS libro,
    c.titulo AS coleccion,
    CAST(c.fecha_publicacion AS CHAR) AS fecha_publicacion
FROM libros AS l
JOIN colecciones AS c
    ON l.id_coleccion = c.id_coleccion
ORDER BY l.titulo;

-- Consulta 10: datos de prueba
INSERT INTO pagos (id_autor, fecha_pago, monto)
VALUES
(1, '2024-09-10', 150000.00),
(1, '2024-10-10', 75000.00),
(2, '2024-10-15', 120000.00);

-- Consulta 10: detalle de pagos
SELECT
    a.nombre,
    CAST(p.fecha_pago AS CHAR) AS fecha_pago,
    p.monto
FROM pagos AS p
JOIN autores AS a ON p.id_autor = a.id_autor
ORDER BY a.nombre, p.fecha_pago;

-- Consulta 10: total por autor
SELECT
    a.nombre,
    SUM(p.monto) AS total_pagado
FROM autores AS a
JOIN pagos AS p ON a.id_autor = p.id_autor
GROUP BY a.id_autor, a.nombre
ORDER BY a.nombre;