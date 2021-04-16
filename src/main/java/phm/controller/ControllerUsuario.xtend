package phm.controller

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PutMapping
import java.time.ZonedDateTime
import phm.domain.Usuario
import org.springframework.beans.factory.annotation.Autowired
import phm.repository.UsuarioRepository
import java.util.Arrays

@CrossOrigin
@RestController
class ControllerUsuario {
	
	@Autowired
	UsuarioRepository repoUsuarios
	
	//Hacer DTO con cosas imporantes
	@PostMapping("/login/{nombreUsuario}")
	def loginUsuarioPorNombre(@RequestBody String password, @PathVariable String nombreUsuario) {
		 
			var Usuario usuario = repoUsuarios.findByUsername(nombreUsuario)
			var String claveRecibida = Mapper.extraerStringDeJson(password, "password")

			if(usuario === null || usuario.password != claveRecibida){
				return new ResponseEntity<String>("Usuario o contraseña incorrecto/a", HttpStatus.UNAUTHORIZED)
			}else{
				ResponseEntity.ok(usuario)
			} 
	}
	
	@PostMapping("/usuarios/{id}")
	def getAmigosParaAgregar(@PathVariable Long id, @RequestBody String usernameABuscar){
		try {
			
			val String usernameBuscado = Mapper.extraerStringDeJson(usernameABuscar,"usernameABuscar")
			val usernames = repoUsuarios.getAmigosNoAgregadosById(id, usernameBuscado)
						
			ResponseEntity.ok(usernames)
		} catch(Exception e){
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	
	// Cambiar nombre de rutas
	@GetMapping("/perfil/{id}")
	def getUsuarioPorId(@PathVariable Long id) {
			var Usuario usuario 
			
			usuario = repoUsuarios.findById(id).orElse(null)
			usuario.amigos = Arrays.asList(usuario.amigos)
			usuario.historial = Arrays.asList(usuario.historial)
			
			if(usuario.id === id){
				ResponseEntity.ok(usuario)				
			}
	}
	
	
	@PutMapping("/perfil/{id}")
	def updateUsuarioPorId(@RequestBody String body, @PathVariable Long id) {
					
			//Chequear si puede pasar que exista un ID null 
			if(id === null){
				return new ResponseEntity<String>("Error de identificación", HttpStatus.BAD_REQUEST)
			}
			
			
			val actualizado = Mapper.mapear.readValue(body, Usuario)
			val usuarioOriginal = repoUsuarios.findById(id).orElse(null)
			actualizado.username = usuarioOriginal.username
			actualizado.password = usuarioOriginal.password
			
			if(id !== actualizado.id){
				return new ResponseEntity<String>("Error de indentificación", HttpStatus.BAD_REQUEST)
			}else{
				camposDeUsuarioValidos(actualizado) ?
				repoUsuarios.save(actualizado) :
				return new ResponseEntity<String>("Los datos del usuario no son validos", HttpStatus.BAD_REQUEST)
			}
			
			ResponseEntity.ok(Mapper.mapear.writeValueAsString(actualizado))						
		
	}
	
	
	def boolean camposDeUsuarioValidos(Usuario usuario) {
		val ZonedDateTime hoy = ZonedDateTime.now()
		
		!(usuario.nombre.isBlank() ||
		  usuario.apellido.isBlank() ||
		  usuario.fechaNacimiento.isAfter(hoy)
		)
	}
	

}