CREATE DATABASE PROYECTO2;
USE PROYECTO2;

-- ***** TABLAS ***** --

CREATE TABLE IF NOT EXISTS CARRERA(
 id_carrera INT NOT NULL AUTO_INCREMENT,
 nombre VARCHAR(100) NOT NULL
); 

CREATE TABLE IF NOT EXISTS ESTUDIANTE(
 carnet BIGINT PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 apellido VARCHAR(100) NOT NULL,
 fecha_nacimiento DATE NOT NULL,
 correo VARCHAR(100) NOT NULL,
 telefono BIGINT NOT NULL,
 direccion VARCHAR(150) NOT NULL,
 dpi BIGINT NOT NULL,
 id_carrera INT NOT NULL,
 creditos INT NOT NULL DEFAULT 0,
 fecha_creacion DATETIME,
 FOREIGN KEY (id_carrera) REFERENCES CARRERA(id_carrera)
);

CREATE TABLE IF NOT EXISTS CURSO(
 codigo INT PRIMARY KEY NOT NULL,
 nombre VARCHAR(150) NOT NULL,
 creditos_necesarios INT NOT NULL,
 creditos_otorgados INT NOT NULL,
 obligatorio TINYINT NOT NULL,
 id_carrera INT NOT NULL,
 FOREIGN KEY (id_carrera) REFERENCES CARRERA(id_carrera)
);

CREATE TABLE IF NOT EXISTS DOCENTE(
siif INT PRIMARY KEY NOT NULL,
nombre VARCHAR(150) NOT NULL,
apellido VARCHAR(150) NOT NULL,
fecha_nacimiento DATE NOT NULL,
correo VARCHAR(150) NOT NULL,
telefono BIGINT NOT NULL,
direccion VARCHAR(150) NOT NULL,
dpi BIGINT NOT NULL,
fecha_creacion DATETIME NULL
);

CREATE TABLE IF NOT EXISTS HABILITAR_CURSO(
id_cursohabilitado INT AUTO_INCREMENT PRIMARY KEY,
codigo_curso INT NOT NULL,
ciclo VARCHAR(3) NOT NULL,
siif_docente INT NOT NULL,
cupo_maximo INT NOT NULL,
seccion VARCHAR(3) NOT NULL,
year_curso DATE NOT NULL,
asignados INT NOT NULL,
FOREIGN KEY (siif_docente) REFERENCES DOCENTE(siif),
FOREIGN KEY (codigo_curso) REFERENCES CURSO(codigo)  
);

CREATE TABLE IF NOT EXISTS HORARIO_CURSO(
id_horario INT AUTO_INCREMENT PRIMARY KEY,
dia INT(1) NOT NULL,
horario VARCHAR(15) NOT NULL,
id_cursohabilitado  INT NOT NULL,
FOREIGN KEY (id_cursohabilitado ) REFERENCES HABILITAR_CURSO(id_cursohabilitado ) 
);

CREATE TABLE IF NOT EXISTS ACTA(
id_acta INT AUTO_INCREMENT PRIMARY KEY,
fecha_hora DATETIME NOT NULL,
codigo_curso INT NOT NULL,
FOREIGN KEY (codigo_curso) REFERENCES CURSO(codigo)  
);

CREATE TABLE IF NOT EXISTS ASIGNACION_CURSO(
id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
estado_asignacion TINYINT NOT NULL,
carnet_estudiante BIGINT NOT NULL,
codigo_curso INT NOT NULL,
FOREIGN KEY (carnet_estudiante) REFERENCES ESTUDIANTE(carnet),
FOREIGN KEY (codigo_curso) REFERENCES CURSO(codigo)  
);

CREATE TABLE IF NOT EXISTS NOTA(
id_nota INT AUTO_INCREMENT PRIMARY KEY,
id_cursohabilitado  INT NOT NULL,
carnet_estudiante BIGINT NOT NULL,
nota INT NOT NULL,
FOREIGN KEY (id_cursohabilitado ) REFERENCES HABILITAR_CURSO(id_cursohabilitado ),
FOREIGN KEY (carnet_estudiante) REFERENCES ESTUDIANTE(carnet)
);

/* ----- FUNCIONES ----- */
/*Funciones Carrera*/

DELIMITER $$
    CREATE FUNCTION validarLetras(
    cadena varchar(100)
    )
    RETURNS BOOLEAN
    DETERMINISTIC
    BEGIN
    DECLARE valido BOOLEAN;
    IF (SELECT REGEXP_INSTR(cadena, '[^a-zA-Z ]') = 0) THEN
        SELECT TRUE INTO valido;
    ELSE
        SELECT FALSE INTO valido;
    end if;
    RETURN (valido);
END $$

/*-------------------------------------------------------------*/

DELIMITER $$
CREATE PROCEDURE crearCarrera(
    IN ingresar_nombre VARCHAR(100)
)
crear_Carrera:BEGIN

IF (NOT validarLetras(ingresar_nombre)) THEN
    SELECT 'El nombre solo debe contener letras' AS ERROR;
    LEAVE crear_Carrera;
end if;

INSERT INTO CARRERA(nombre) VALUES (ingresar_nombre);
SELECT CONCAT('Carrera ', ingresar_nombre, ' registrado') AS MENSAJE;
END $$