package phm.springboot.controller

import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import phm.RepositorioPreguntas
import org.springframework.http.ResponseEntity
import org.springframework.http.HttpStatus

@RestController
@CrossOrigin
class ControllerPregunta {
	@GetMapping("/busqueda/preguntas")
	def getPreguntas() {
		try {
			val repoPreguntas = RepositorioPreguntas.instance
			val todasLasPreguntas = repoPreguntas.todasLasPreguntas()
			ResponseEntity.ok(todasLasPreguntas)				
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}	
}