package phm.springboot.controller

import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import phm.RepositorioPreguntas
import org.springframework.http.ResponseEntity
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import com.google.gson.JsonElement
import com.google.gson.JsonParser
import com.google.gson.JsonObject
import phm.Pregunta

@RestController
@CrossOrigin
class ControllerPregunta {
	
	@GetMapping("/busqueda/preguntas")
	def getTodasLasPreguntas() {
		try {
			val repoPreguntas = RepositorioPreguntas.instance
			val todasLasPreguntas = repoPreguntas.getTodasLasPreguntas()
			ResponseEntity.ok(todasLasPreguntas)				
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}	
	
	@GetMapping("/busqueda/preguntasActivas")
	def getPreguntasActivas() {
		try {
			val repoPreguntas = RepositorioPreguntas.instance
			val preguntasActivas = repoPreguntas.getPreguntasActivas()
			ResponseEntity.ok(preguntasActivas)				
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}	
	
	// Preguntas filtradas por la pregunta misma
	@PostMapping("/busqueda/preguntas")
	def preguntasFiltradas(@RequestBody String unaBusqueda) {
		try {
			var JsonElement jsonElement = new JsonParser().parse(unaBusqueda)
        	var JsonObject jsonObject = jsonElement.getAsJsonObject()
			var String busqueda = jsonObject.get("unaBusqueda").asString
			
			var Pregunta[] preguntas = RepositorioPreguntas.instance.search(busqueda)
			ResponseEntity.ok(preguntas)				
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
}