ALTER TABLE usuario modify puntaje Int NOT NULL;

##Para hacer la prueba de funcionamiento
INSERT INTO usuario (id, baja_logica, apellido, fecha_nacimiento, nombre, password, puntaje, username)
VALUES (6,0, 'perez', '2000-01-01 10:15', 'pepe', 'elPepe', null, 'pepePerez');