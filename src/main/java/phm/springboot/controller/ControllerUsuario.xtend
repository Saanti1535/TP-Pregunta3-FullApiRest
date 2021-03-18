package phm.springboot.controller

import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.PostMapping
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import phm.RepositorioUsuarios
import phm.Usuario

@RestController
@CrossOrigin
class ControllerUsuario {
	
	@PostMapping("/login/{nombreUsuario}")
	def usuarioPorNombre(@RequestBody String password, @PathVariable String nombreUsuario) {
		try {
			val repoUsuarios = RepositorioUsuarios.instance
			if(!repoUsuarios.existeUsuarioConNombreDeUsuario(nombreUsuario)){
				return new ResponseEntity<String>("Usuario o contraseña incorrecto/a", HttpStatus.UNAUTHORIZED)
			}
			
			var Usuario usuario = repoUsuarios.buscarPorNombreDeUsuario(nombreUsuario)
			
        	var JsonElement jsonElement = new JsonParser().parse(password);     
        	var JsonObject jsonObject = jsonElement.getAsJsonObject();
			var String claveRecibida = jsonObject.get("password").asString

			if(usuario.password == claveRecibida){
				ResponseEntity.ok(usuario)				
			}else{
				return new ResponseEntity<String>("Usuario o contraseña incorrecto/a", HttpStatus.UNAUTHORIZED)
			}
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	

	
	/****GENERALES***/
		
	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}	
}