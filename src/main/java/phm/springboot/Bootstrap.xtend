package phm.springboot

import phm.RepositorioUsuarios
import phm.Usuario
import phm.PreguntaSimple
import phm.RepositorioPreguntas

class Bootstrap {
		var juan = new Usuario => [username = 'juan'; password = "123456"]
		var maria = new Usuario => [username = 'maria'; password = "123456"]
		var jose = new Usuario => [username = 'jose'; password = "123456"]
		var juana = new Usuario => [username = 'juana'; password = "juana"]
		
		var pregunta01 = new PreguntaSimple => [ pregunta = "pregunta01"; ]
		var pregunta02 = new PreguntaSimple => [ pregunta = "pregunta02"; ]
		var pregunta03 = new PreguntaSimple => [ pregunta = "pregunta03"; ]
		var pregunta04 = new PreguntaSimple => [ pregunta = "pregunta04"; ]
		var pregunta05 = new PreguntaSimple => [ pregunta = "pregunta05"; ]
		var pregunta06 = new PreguntaSimple => [ pregunta = "pregunta06"; ]
		var pregunta07 = new PreguntaSimple => [ pregunta = "pregunta07"; ]
		var pregunta08 = new PreguntaSimple => [ pregunta = "pregunta08"; ]
		
	
/**********************************************************/
	def void run() {
		crearUsuarios
		crearPreguntas
	}

/********************************************************* USUARIOS */
	def void crearUsuarios() {
		RepositorioUsuarios.instance => [
			create(juan)
			create(maria)
			create(jose)
			create(juana)
		]	
	}
	
	def void crearPreguntas() {
		RepositorioPreguntas.instance => [
			create(pregunta01)
			create(pregunta02)
			create(pregunta03)
			create(pregunta04)
			create(pregunta05)
			create(pregunta06)
			create(pregunta07)
			create(pregunta08)
		]	
	}	
}