CREATE VIEW usuario_con_mas_de_3_rtas AS
SELECT usuario.nombre AS usuario_con_mas_de_3_rtas FROM registro
JOIN USUARIO ON usuario.id = registro.id_usuario
GROUP BY usuario.nombre
HAVING COUNT(usuario.id) > 3