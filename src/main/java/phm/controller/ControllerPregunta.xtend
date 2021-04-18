package phm.controller

import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.http.ResponseEntity
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.beans.factory.annotation.Autowired
import phm.domain.PreguntaDTO
import javax.transaction.Transactional
import phm.service.PreguntaService

@RestController
@CrossOrigin
class ControllerPregunta {
	
	@Autowired
	PreguntaService preguntaService

	
	@GetMapping("/busqueda/preguntas")
	def getTodasLasPreguntas() {
		try {
			
			val todasLasPreguntas = preguntaService.getTodasLasPreguntasDTO()
			ResponseEntity.ok(todasLasPreguntas)
							
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}	
	
	// Preguntas filtradas por la pregunta misma
	@PostMapping("/busqueda/preguntas")
	def preguntasFiltradas(@RequestBody String unaBusqueda) {
		try {
			
			var PreguntaDTO[] preguntasDTO = preguntaService.getPreguntasFiltradas(unaBusqueda)
			ResponseEntity.ok(preguntasDTO)	
						
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	@GetMapping("/busqueda/pregunta/{id}/{idUsuario}")
	def preguntaPorId(@PathVariable long id, @PathVariable long idUsuario) {
			return preguntaService.getPreguntaPorId(id, idUsuario)
	}
	
	@Transactional
	@PostMapping("/revisarRespuesta/{id}")
	def revisarRespuesta(@RequestBody String respuesta, @PathVariable long id) {
		try {
			
			var String esRespuesta = preguntaService.verificarRespuesta(respuesta, id)
			ResponseEntity.ok(esRespuesta)
		
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acci�n", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	
	@PutMapping("/busqueda/pregunta/{id}")
	def updatePreguntaPorId(@RequestBody String body, @PathVariable long id) {
		try {			
			preguntaService.updatePreguntaForId(body, id)
			ResponseEntity.ok().build
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	@PutMapping("/crearPregunta/{idAutor}/{puntos}")
	def crearPregunta(@RequestBody String body, @PathVariable long idAutor, @PathVariable int puntos) {
		try {
			preguntaService.crearPregunta(body, idAutor, puntos)
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	

}