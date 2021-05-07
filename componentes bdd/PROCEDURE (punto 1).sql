DELIMITER $$
CREATE PROCEDURE preguntas_creadas_por(UsernameBuscado VARCHAR(255))
BEGIN
    SELECT pregunta
		FROM pregunta
        JOIN usuario ON usuario.id = autor_id
			WHERE usuario.username = UsernameBuscado;
END $$
DELIMITER ;

CALL preguntas_creadas_por('pep');