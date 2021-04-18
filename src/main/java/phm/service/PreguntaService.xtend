package phm.service

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import phm.repository.PreguntaRepository
import phm.domain.PreguntaDTO
import phm.controller.Mapper
import phm.domain.Pregunta
import java.util.Arrays
import javassist.NotFoundException
import phm.domain.Usuario
import phm.repository.RegistroRespuestasRepository
import phm.domain.UpdatePregunta
import org.springframework.web.server.ResponseStatusException
import org.springframework.http.HttpStatus
import phm.domain.PreguntaSolidaria
import org.springframework.http.ResponseEntity

@Service
class PreguntaService {

	@Autowired
	PreguntaRepository repoPregunta	
	
	@Autowired
	UsuarioService usuarioService
	
	@Autowired
	RegistroRespuestasRepository repoRegistro
	
	def getTodasLasPreguntasDTO(){
		return repoPregunta.findAll().toList.map [ PreguntaDTO.fromPregunta(it) ]
	}
	
	def getPreguntasFiltradas(String unaBusqueda){
			var busqueda = Mapper.extraerStringDeJson(unaBusqueda, "unaBusqueda")
			var soloActivas = Mapper.extraerBooleanDeJson(unaBusqueda, "soloActivas")
			
			var Pregunta[] preguntas = repoPregunta.findByPreguntaContaining(busqueda)
			
			if(soloActivas){
				preguntas = preguntas.filter[pregunta | pregunta.estaActiva].toList()				
			}
			
			return preguntas.map [ PreguntaDTO.fromPregunta(it) ]		
	}
	
	def getPreguntaPorId(long idPregunta, long idUsuario){
		try {
			var Pregunta pregunta
			try{
				pregunta = repoPregunta.findById(idPregunta).orElse(null)
			}catch (Exception e){
				return new ResponseEntity<String>("Id de pregunta inexistente", HttpStatus.BAD_REQUEST)			
			}
			
			var Usuario usuario = usuarioService.getUsuarioById(idUsuario)
			
			pregunta.opciones = Arrays.asList(pregunta.opciones)
			pregunta.autor = usuarioService.getUsuarioById(pregunta.autor.id)
			
			if(!usuario.yaRespondio(pregunta.pregunta)){
				return ResponseEntity.ok(pregunta)	
			}else{
				return new ResponseEntity<String>("No se puede acceder a la pregunta dado que ya la repsondió anteriormente", HttpStatus.UNAUTHORIZED)					
			}
		} catch (Exception e) {
			return new ResponseEntity<String>("No se pudo completar la acción", HttpStatus.INTERNAL_SERVER_ERROR)
		}	
	}
	
	def verificarRespuesta(String respuesta, long idPregunta){
			var laRespuesta = Mapper.extraerStringDeJson(respuesta, "laRespuesta")
			var idUsuario = Mapper.extraerLongDeJson(respuesta, "idUsuario")

			var pregunta = repoPregunta.findById(idPregunta).get()
			var Usuario usuario = usuarioService.getUsuarioById(idUsuario)
			
			pregunta.responder(usuario, laRespuesta)
			repoRegistro.save(usuario.historial.last) //Se crea el registro en la base
			usuarioService.guardarUsuario(usuario) //Actualizacion del historial	
			
			var String esRespuesta
			if(pregunta.esRespuestaCorrecta(laRespuesta)){
				esRespuesta = 'Correcto'				
			}else{
				esRespuesta = 'Incorrecto'
			}	
			
			return esRespuesta
	}
	
	def updatePreguntaForId(String body, long idPregunta){
			val updatePregunta = Mapper.mapear.readValue(body, UpdatePregunta)
			repoPregunta.findById(idPregunta).map[pregunta | 
				pregunta => [ 
					opciones = updatePregunta.opciones
				]
				repoPregunta.save(pregunta)
			].orElseThrow([
				throw new ResponseStatusException(HttpStatus.NOT_FOUND, "La pregunta con ID = " + idPregunta + " no existe") // No se usa ResponseEntity porque no funciona con throw 
			])
	}
	
	def crearPregunta(String body, long idAutor, int puntos){
			val nuevaPregunta = Mapper.mapear.readValue(body, Pregunta)
			nuevaPregunta.autor = usuarioService.getUsuarioById(idAutor)
			
			if (nuevaPregunta instanceof PreguntaSolidaria){
				nuevaPregunta.asignarPuntos(puntos)
			}
			
			repoPregunta.save(nuevaPregunta)
	}
	
}