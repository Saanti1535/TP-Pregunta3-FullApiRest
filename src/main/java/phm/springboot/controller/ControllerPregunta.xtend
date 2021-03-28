package phm.springboot.controller

import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import phm.RepositorioPreguntas
import org.springframework.http.ResponseEntity
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import phm.Pregunta
import org.springframework.web.bind.annotation.PathVariable
import phm.RepositorioUsuarios
import phm.Usuario
import org.springframework.web.bind.annotation.PutMapping
import phm.PreguntaSimple
import phm.PreguntaSolidaria

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
	
	@GetMapping("/busqueda/pregunta/{id}")
	def preguntaPorId(@PathVariable int id) {
		try {
			val repoPreguntas = RepositorioPreguntas.instance
			var Pregunta pregunta
			try{
				pregunta = repoPreguntas.getById(id)
			}catch (Exception e){
				return new ResponseEntity<String>("Id de pregunta inexistente", HttpStatus.BAD_REQUEST)			
			}
			ResponseEntity.ok(pregunta)				
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

			repoPreguntas.create(nuevaPregunta)
			
			ResponseEntity.ok(Mapper.mapear.writeValueAsString(nuevaPregunta))

		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	

}