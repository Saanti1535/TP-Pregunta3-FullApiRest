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
import org.springframework.web.bind.annotation.PathVariable
import phm.RepositorioUsuarios
import phm.Usuario
import org.springframework.web.bind.annotation.PutMapping
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.SerializationFeature
import phm.PreguntaSimple

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
			
        	var JsonElement jsonElement = new JsonParser().parse(respuesta);     
        	var JsonObject jsonObject = jsonElement.getAsJsonObject();
			var String laRespuesta = jsonObject.get("laRespuesta").asString
			
			jsonElement = new JsonParser().parse(respuesta);     
        	jsonObject = jsonElement.getAsJsonObject();
			var long idUsuario = jsonObject.get("idUsuario").asLong

			val repoUsuarios = RepositorioUsuarios.instance
			
			var Usuario usuario = repoUsuarios.getById(idUsuario)
			
			if(pregunta.esRespuestaCorrecta(laRespuesta)){
				pregunta.responder(usuario, laRespuesta)
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
			val pregunta = Mapper.mapear.readValue(body, PreguntaSimple)
			
			pregunta.autor = repoPreguntas.getById(id).autor
			repoPreguntas.update(pregunta)
			ResponseEntity.ok(Mapper.mapear.writeValueAsString(pregunta))						
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}
	}
	

}