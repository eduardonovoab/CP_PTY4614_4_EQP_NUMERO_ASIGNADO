-- Desactivar auto-increment en cero
-- START TRANSACTION;
-- SET time_zone = "+00:00";

-- Características de la base de datos
-- No necesario en Oracle

-- Estructura de tabla para la tabla `historial_movimientos`
CREATE TABLE historial_movimientos (
  id NUMBER(11) NOT NULL,
  producto_id NUMBER(11) NOT NULL,
  cantidad NUMBER(11) NOT NULL,
  tipo VARCHAR2(7) CHECK (tipo IN ('entrada', 'salida')) NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Estructura de tabla para la tabla `preordenes`
CREATE TABLE preordenes (
  id NUMBER(11) NOT NULL,
  usuario_id NUMBER(11) NOT NULL,
  producto_id NUMBER(11) NOT NULL,
  fecha_preorden TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  estado VARCHAR2(10) DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'completada'))
);

-- Estructura de tabla para la tabla `productos`
CREATE TABLE productos (
  id NUMBER(11) NOT NULL,
  nombre VARCHAR2(100) NOT NULL,
  talla VARCHAR2(10) NOT NULL,
  precio NUMBER(10, 2) NOT NULL,
  color VARCHAR2(50) NOT NULL,
  stock NUMBER(11) NOT NULL,
  img VARCHAR2(255) NOT NULL,
  fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Estructura de tabla para la tabla `usuarios`
CREATE TABLE usuarios (
  id NUMBER(11) NOT NULL,
  nombre VARCHAR2(100) NOT NULL,
  email VARCHAR2(100) NOT NULL UNIQUE,
  password VARCHAR2(255) NOT NULL,
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Crear índices y llaves primarias
ALTER TABLE historial_movimientos
  ADD PRIMARY KEY (id);

CREATE INDEX producto_id_idx ON historial_movimientos (producto_id);

ALTER TABLE preordenes
  ADD PRIMARY KEY (id);

CREATE INDEX usuario_id_idx ON preordenes (usuario_id);
CREATE INDEX producto_id_preordenes_idx ON preordenes (producto_id);

ALTER TABLE productos
  ADD PRIMARY KEY (id);

ALTER TABLE usuarios
  ADD PRIMARY KEY (id);

-- Crear secuencias para AUTO_INCREMENT
CREATE SEQUENCE historial_movimientos_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE preordenes_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE productos_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE usuarios_seq START WITH 1 INCREMENT BY 1;

-- Crear triggers para AUTO_INCREMENT
CREATE OR REPLACE TRIGGER historial_movimientos_bir
BEFORE INSERT ON historial_movimientos
FOR EACH ROW
BEGIN
  :new.id := historial_movimientos_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER preordenes_bir
BEFORE INSERT ON preordenes
FOR EACH ROW
BEGIN
  :new.id := preordenes_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER productos_bir
BEFORE INSERT ON productos
FOR EACH ROW
BEGIN
  :new.id := productos_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER usuarios_bir
BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
  :new.id := usuarios_seq.NEXTVAL;
END;

-- Agregar restricciones de claves foráneas
ALTER TABLE historial_movimientos
  ADD CONSTRAINT fk_producto_id FOREIGN KEY (producto_id) REFERENCES productos (id);

ALTER TABLE preordenes
  ADD CONSTRAINT fk_usuario_id FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
  ADD CONSTRAINT fk_producto_id_preorden FOREIGN KEY (producto_id) REFERENCES productos (id);

-- No se necesita COMMIT en scripts de creación de DDL en Oracle
