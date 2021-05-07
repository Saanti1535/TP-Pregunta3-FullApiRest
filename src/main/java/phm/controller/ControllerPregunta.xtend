package phm.controller

import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.beans.factory.annotation.Autowired
import phm.domain.PreguntaDTO
import javax.transaction.Transactional
import phm.service.PreguntaService
import phm.domain.UpdatePregunta
import phm.domain.Pregunta

@RestController
@CrossOrigin
class ControllerPregunta {
	
	@Autowired
	PreguntaService preguntaService

	
	@GetMapping("/busqueda/preguntas")
	def getTodasLasPreguntas() {
			
		val todasLasPreguntas = preguntaService.getTodasLasPreguntasDTO()
		todasLasPreguntas
	}	
	
	// Preguntas filtradas por la pregunta misma
	@PostMapping("/busqueda/preguntas")
	def preguntasFiltradas(@RequestBody String unaBusqueda) {
			var busqueda = Mapper.extraerStringDeJson(unaBusqueda, "unaBusqueda")
			var soloActivas = Mapper.extraerBooleanDeJson(unaBusqueda, "soloActivas")
			
			var PreguntaDTO[] preguntasDTO = preguntaService.getPreguntasFiltradas(busqueda, soloActivas)
			preguntasDTO	
	}
	
	@GetMapping("/busqueda/pregunta/{id}/{idUsuario}")
	def preguntaPorId(@PathVariable long id, @PathVariable long idUsuario) {
			val pregunta = preguntaService.getPreguntaPorId(id, idUsuario)
			return pregunta
	}
	
	@Transactional
	@PostMapping("/revisarRespuesta/{idPregunta}")
	def revisarRespuesta(@RequestBody String respuesta, @PathVariable long idPregunta) {
			var laRespuesta = Mapper.extraerStringDeJson(respuesta, "laRespuesta")
			var idUsuario = Mapper.extraerLongDeJson(respuesta, "idUsuario")
				
			preguntaService.verificarRespuesta(laRespuesta, idPregunta, idUsuario)
	}
	
	
	@PutMapping("/busqueda/pregunta/{id}")
	def updatePreguntaPorId(@RequestBody String body, @PathVariable long id) {		
			val updatePregunta = Mapper.mapear.readValue(body, UpdatePregunta)
			preguntaService.updatePreguntaById(updatePregunta, id)
			ResponseEntity.ok().build
	}
	
	@PutMapping("/crearPregunta/{idAutor}/{puntos}")
	def crearPregunta(@RequestBody String body, @PathVariable long idAutor, @PathVariable int puntos) {
		val nuevaPregunta = Mapper.mapear.readValue(body, Pregunta)
		preguntaService.crearPregunta(nuevaPregunta, idAutor, puntos)
	}
	

}