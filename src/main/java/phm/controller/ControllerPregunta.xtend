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

@RestController
@CrossOrigin
class ControllerPregunta {
	
	@Autowired
	PreguntaRepository repoPregunta
	
	@GetMapping("/busqueda/preguntas")
	def getTodasLasPreguntas() {
		try {
			val todasLasPreguntas = repoPregunta.findAll()
			ResponseEntity.ok(todasLasPreguntas)				
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}	
	
	//Unificar endpoints 
//	@GetMapping("/busqueda/preguntasActivas")
//	def getPreguntasActivas() {
//		try {
//			val preguntasActivas = RepositorioPreguntas.instance.getPreguntasActivas()
//			ResponseEntity.ok(preguntasActivas)				
//		} catch (Exception e) {
//			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
//		}
//	}	
	
	// Preguntas filtradas por la pregunta misma
	@PostMapping("/busqueda/preguntas")
	def preguntasFiltradas(@RequestBody String unaBusqueda) {
		try {
			var busqueda = Mapper.extraerStringDeJson(unaBusqueda, "unaBusqueda")
			var soloActivas = Mapper.extraerBooleanDeJson(unaBusqueda, "soloActivas")
			
			var Pregunta[] preguntas = RepositorioPreguntas.instance.search(busqueda)
			
			if(soloActivas){
				preguntas = preguntas.filter[pregunta | pregunta.estaActiva].toList()				
			}
			
			ResponseEntity.ok(preguntas)				
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	@GetMapping("/busqueda/pregunta/{id}/{idUsuario}")
	def preguntaPorId(@PathVariable int id, @PathVariable int idUsuario) {
		try {
			val repoPreguntas = RepositorioPreguntas.instance
			val repoUsuarios = RepositorioUsuarios.instance
			var Pregunta pregunta
			try{
				pregunta = repoPreguntas.getById(id)
			}catch (Exception e){
				return new ResponseEntity<String>("Id de pregunta inexistente", HttpStatus.BAD_REQUEST)			
			}
			
			var Usuario usuario = repoUsuarios.getById(idUsuario)
			if(!usuario.yaRespondio(pregunta.pregunta)){
				ResponseEntity.ok(pregunta)	
			}else{
				return new ResponseEntity<String>("No se puede acceder a la pregunta dado que ya la repsondió anteriormente", HttpStatus.UNAUTHORIZED)					
			}		
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	@PostMapping("/revisarRespuesta/{id}")
	def revisarRespuesta(@RequestBody String respuesta, @PathVariable long id) {
		try {
			val repoPreguntas = RepositorioPreguntas.instance
			
			var Pregunta pregunta = repoPreguntas.getById(id)
			
			var laRespuesta = Mapper.extraerStringDeJson(respuesta, "laRespuesta")
			var idUsuario = Mapper.extraerLongDeJson(respuesta, "idUsuario")

			val repoUsuarios = RepositorioUsuarios.instance
			
			var Usuario usuario = repoUsuarios.getById(idUsuario)
			
			pregunta.responder(usuario, laRespuesta)
			
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
	def updatePreguntaPorId(@RequestBody String body, @PathVariable Integer id) {
		try {			
			if(id === null){
				return new ResponseEntity<String>("Error de identificación de pregunta", HttpStatus.BAD_REQUEST)
			}
			val repoPreguntas = RepositorioPreguntas.instance
			val pregunta = Mapper.mapear.readValue(body, Pregunta)
			
			pregunta.autor = repoPreguntas.getById(id).autor
			repoPreguntas.update(pregunta)
			ResponseEntity.ok(Mapper.mapear.writeValueAsString(pregunta))						
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	
	@PutMapping("/crearPregunta/{idAutor}/{puntos}")
	def crearPregunta(@RequestBody String body, @PathVariable long idAutor, @PathVariable float puntos) {
		try {
			val repoPreguntas = RepositorioPreguntas.instance
			val repoUsuarios = RepositorioUsuarios.instance
			
			val nuevaPregunta = Mapper.mapear.readValue(body, Pregunta)
			nuevaPregunta.autor = repoUsuarios.getById(idAutor)
			
			if (nuevaPregunta instanceof PreguntaSolidaria){
				nuevaPregunta.asignarPuntos(puntos)
			}

			if(!repoPreguntas.existePregunta(nuevaPregunta.pregunta)){
				repoPreguntas.create(nuevaPregunta)			
				ResponseEntity.ok(Mapper.mapear.writeValueAsString(nuevaPregunta))				
			}else{
				return new ResponseEntity<String>("La pregunta que quiere ingresar ya existe", HttpStatus.BAD_REQUEST)	
			}

		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	

}