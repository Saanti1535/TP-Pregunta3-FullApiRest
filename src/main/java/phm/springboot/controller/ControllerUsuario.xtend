package phm.springboot.controller

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.PostMapping
import phm.RepositorioUsuarios
import phm.Usuario
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PutMapping

@CrossOrigin
@RestController
class ControllerUsuario {
	
	@PostMapping("/login/{nombreUsuario}")
	def loginUsuarioPorNombre(@RequestBody String password, @PathVariable String nombreUsuario) {
		try {
			val repoUsuarios = RepositorioUsuarios.instance
			if(!repoUsuarios.existeUsuarioConNombreDeUsuario(nombreUsuario)){
				return new ResponseEntity<String>("Usuario o contrase�a incorrecto/a", HttpStatus.UNAUTHORIZED)
			}
			
			var Usuario usuario = repoUsuarios.buscarPorNombreDeUsuario(nombreUsuario)
			
			var String claveRecibida = Mapper.extraerStringDeJson(password, "password")

			if(usuario.password == claveRecibida){
				ResponseEntity.ok(usuario)				
			}else{
				return new ResponseEntity<String>("Usuario o contraseña incorrecto/a", HttpStatus.UNAUTHORIZED)
			}
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acci�n", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	@PostMapping("/usuarios/{id}")
	def getUsuarios(@PathVariable Integer id, @RequestBody String busqueda){
		try {
			
			val String usuarioABuscar = Mapper.extraerStringDeJson(busqueda,"busqueda")
			
			val repoUsuarios = RepositorioUsuarios.instance
			val usuarioLogueado = repoUsuarios.getById(id)
			val usuarios = repoUsuarios.lista
			.filter(usuario | 
				usuario.id !== id
				&& !usuarioLogueado.amigos.exists(amigo | amigo.id === usuario.id)
				&& usuario.username.toLowerCase().contains(usuarioABuscar.toLowerCase())
			)
			.map(usuario | usuario.username)
			.toList()
						
			ResponseEntity.ok(usuarios)
		} catch(Exception e){
			return new ResponseEntity<String>("No se pudo completar la acci�n", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	// Cambiar nombre de rutas
	@GetMapping("/perfil/{id}")
	def getUsuarioPorId(@PathVariable Integer id) {
		try {
			val repoUsuarios = RepositorioUsuarios.instance
			var Usuario usuario 
			try{
				usuario = repoUsuarios.getById(id)
			}catch (Exception e){
				//Chequear bien qué excepciones son catcheables acá (a ver cuál es la más adecuada)
				return new ResponseEntity<String>("Id de usuario inexistente", HttpStatus.NOT_FOUND)			
			}
			if(usuario.id === id){
				ResponseEntity.ok(usuario)				
			}
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	
	@PutMapping("/perfil/{id}")
	def updateUsuarioPorId(@RequestBody String body, @PathVariable Integer id) {
		try {			
			//Chequear si puede pasar que exista un ID null 
			if(id === null){
				return new ResponseEntity<String>("Error de identificación", HttpStatus.BAD_REQUEST)
			}
			val repoUsuarios = RepositorioUsuarios.instance
			val actualizado = Mapper.mapear.readValue(body, Usuario)
			actualizado.username = repoUsuarios.getById(id).username
			actualizado.password = repoUsuarios.getById(id).password
			
			if(id !== actualizado.id){
				return new ResponseEntity<String>("Error de indentificación", HttpStatus.BAD_REQUEST)
			}else{
				repoUsuarios.update(actualizado)
			}
			
			ResponseEntity.ok(Mapper.mapear.writeValueAsString(actualizado))						
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	

}