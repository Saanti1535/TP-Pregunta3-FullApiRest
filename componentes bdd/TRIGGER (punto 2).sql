CREATE TABLE actualizacionPregunta (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_pregunta INT NOT NULL,
    fecha TIMESTAMP  NOT NULL,
    preguntaAnterior VARCHAR(255) NOT NULL,
    preguntaNueva VARCHAR(255) NOT NULL
);

DELIMITER $$
CREATE TRIGGER after_update_pregunta 
AFTER UPDATE ON pregunta 
FOR EACH ROW
BEGIN
	IF OLD.pregunta <> NEW.pregunta THEN
		INSERT INTO actualizacionPregunta (id_pregunta, fecha, preguntaAnterior, preguntaNueva)
            VALUES (NEW.id, SYSDATE(), OLD.pregunta, NEW.pregunta);
	END IF;
END $$
DELIMITER ;

SELECT * FROM actualizacionpregunta;
UPDATE pregunta SET pregunta="HOLA" WHERE id = 1;
