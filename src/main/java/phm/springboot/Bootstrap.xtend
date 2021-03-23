package phm.springboot

import phm.RepositorioUsuarios
import phm.Usuario

class Bootstrap {
		var juan = new Usuario => [username = 'juan'; password = "123456"]
		var maria = new Usuario => [username = 'maria'; password = "123456"]
		var jose = new Usuario => [username = 'jose'; password = "123456"]
		var juana = new Usuario => [username = 'juana'; password = "123456"]
	
/**********************************************************/
	def void run() {
		crearUsuarios
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
}