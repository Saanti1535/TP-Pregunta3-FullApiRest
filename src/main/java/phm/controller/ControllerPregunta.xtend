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
import phm.domain.RepositorioPreguntas
import phm.domain.Pregunta
import phm.domain.RepositorioUsuarios
import phm.domain.PreguntaSolidaria
import phm.domain.Usuario
import phm.repository.PreguntaRepository
import org.springframework.beans.factory.annotation.Autowired
import phm.domain.PreguntaDTO
import phm.repository.UsuarioRepository
import java.util.Arrays
import org.springframework.web.server.ResponseStatusException
import phm.domain.UpdatePregunta
import javax.transaction.Transactional
import phm.repository.RegistroRespuestasRepository

@RestController
@CrossOrigin
class ControllerPregunta {
	
	@Autowired
	PreguntaRepository repoPregunta
	
	@Autowired
	RegistroRespuestasRepository repoRegistro
	
	@Autowired
	UsuarioRepository repoUsuario
	
	@GetMapping("/busqueda/preguntas")
	def getTodasLasPreguntas() {
		try {
			val todasLasPreguntas = repoPregunta.findAll().toList.map [ PreguntaDTO.fromPregunta(it) ]
			ResponseEntity.ok(todasLasPreguntas)				
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}	
	
	// Preguntas filtradas por la pregunta misma
	@PostMapping("/busqueda/preguntas")
	def preguntasFiltradas(@RequestBody String unaBusqueda) {
		try {
			var busqueda = Mapper.extraerStringDeJson(unaBusqueda, "unaBusqueda")
			var soloActivas = Mapper.extraerBooleanDeJson(unaBusqueda, "soloActivas")
			
			var Pregunta[] preguntas = repoPregunta.findByPreguntaContaining(busqueda)
			
			if(soloActivas){
				preguntas = preguntas.filter[pregunta | pregunta.estaActiva].toList()				
			}
			
			var PreguntaDTO[] preguntasDTO = preguntas.map [ PreguntaDTO.fromPregunta(it) ]
			
			ResponseEntity.ok(preguntasDTO)				
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	@GetMapping("/busqueda/pregunta/{id}/{idUsuario}")
	def preguntaPorId(@PathVariable long id, @PathVariable long idUsuario) {
		try {
			var Pregunta pregunta
			try{
				pregunta = repoPregunta.findById(id).orElse(null)
			}catch (Exception e){
				return new ResponseEntity<String>("Id de pregunta inexistente", HttpStatus.BAD_REQUEST)			
			}
			
			var Usuario usuario = repoUsuario.findById(idUsuario).orElse(null)
			
			pregunta.opciones = Arrays.asList(pregunta.opciones)
			pregunta.autor = repoUsuario.findById(pregunta.autor.id).orElse(null)
			
			if(!usuario.yaRespondio(pregunta.pregunta)){
				ResponseEntity.ok(pregunta)	
			}else{
				return new ResponseEntity<String>("No se puede acceder a la pregunta dado que ya la repsondió anteriormente", HttpStatus.UNAUTHORIZED)					
			}
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	@Transactional
	@PostMapping("/revisarRespuesta/{id}")
	def revisarRespuesta(@RequestBody String respuesta, @PathVariable long id) {
		try {
			var laRespuesta = Mapper.extraerStringDeJson(respuesta, "laRespuesta")
			var idUsuario = Mapper.extraerLongDeJson(respuesta, "idUsuario")

			var pregunta = repoPregunta.findById(id).get()
			var Usuario usuario = repoUsuario.findById(idUsuario).get()
			
			pregunta.responder(usuario, laRespuesta)
			repoRegistro.save(usuario.historial.last)
			repoUsuario.save(usuario) //Actualizacion del historial
			
			if(pregunta.esRespuestaCorrecta(laRespuesta)){
				ResponseEntity.ok('Correcto')				
			}else{
				ResponseEntity.ok('Incorrecto')
			}
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acci�n", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	
	@PutMapping("/busqueda/pregunta/{id}")
	def updatePreguntaPorId(@RequestBody String body, @PathVariable Long id) {
		try {			
			val updatePregunta = Mapper.mapear.readValue(body, UpdatePregunta)
			repoPregunta.findById(id).map[pregunta | 
				pregunta => [ 
					opciones = updatePregunta.opciones
				]
				repoPregunta.save(pregunta)
			].orElseThrow([
				throw new ResponseStatusException(HttpStatus.NOT_FOUND, "La pregunta con ID = " + id + " no existe") // No se usa ResponseEntity porque no funciona con throw 
			])
			ResponseEntity.ok().build
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	@PutMapping("/crearPregunta/{idAutor}/{puntos}")
	def crearPregunta(@RequestBody String body, @PathVariable long idAutor, @PathVariable float puntos) {
		try {
			val nuevaPregunta = Mapper.mapear.readValue(body, Pregunta)
			nuevaPregunta.autor = repoUsuario.findById(idAutor).get()
			
			if (nuevaPregunta instanceof PreguntaSolidaria){
				nuevaPregunta.asignarPuntos(puntos)
			}
			
			repoPregunta.save(nuevaPregunta)
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	

}