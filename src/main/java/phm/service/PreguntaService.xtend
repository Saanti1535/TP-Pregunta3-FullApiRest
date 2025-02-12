package phm.service

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import phm.repository.PreguntaRepository
import phm.domain.PreguntaDTO
import phm.domain.Pregunta
import java.util.Arrays
import phm.domain.Usuario
import phm.domain.UpdatePregunta
import org.springframework.web.server.ResponseStatusException
import org.springframework.http.HttpStatus
import phm.domain.PreguntaSolidaria
import org.springframework.http.ResponseEntity
import org.springframework.validation.annotation.Validated
import javax.validation.Valid
import javax.transaction.Transactional
import org.bson.types.ObjectId
import java.time.LocalDateTime
import phm.repository.PreguntaActivaRepository
import java.util.List
import phm.exception.DTONullException

@Service
@Validated
class PreguntaService {

	@Autowired
	PreguntaRepository repoPregunta	
	
	@Autowired
	PreguntaActivaRepository repoPreguntaActiva	
	
	@Autowired
	UsuarioService usuarioService
	
	@Autowired
	LogService logService
	
	def getTodasLasPreguntasDTO(){
		return repoPregunta.findAll().toList.map [ PreguntaDTO.fromPregunta(it) ]
	}
	
	def getPreguntasFiltradas(String busqueda, boolean soloActivas){
			var Pregunta[] preguntas
			var int minutosDeVigencia = Pregunta.minutosDeVigencia as int
			var fechaDesdeParaQueEstenActivas = LocalDateTime.now().minusMinutes(minutosDeVigencia)
			
			
			if(soloActivas){
				preguntas = repoPregunta.obtenerPreguntasFiltradasActivas(busqueda, fechaDesdeParaQueEstenActivas)				
			} else preguntas = repoPregunta.findByPreguntaContaining(busqueda)
			
			return preguntas.map [ PreguntaDTO.fromPregunta(it) ]		
	}
	
	def getPreguntasActivasFiltradas(String busqueda){
			val List<PreguntaDTO> preguntasActivas = repoPreguntaActiva.findAll().toList()
			preguntasActivas.isEmpty ? throw new DTONullException("No hay preguntas activas, que contengan lo buscado")
			preguntasActivas.filter[pregunta.toLowerCase().contains(busqueda.toLowerCase())].toList()
	}
	
	def getPreguntaPorId(ObjectId idPregunta, long idUsuario){
			var Pregunta pregunta
			try{
				pregunta = repoPregunta.findBy_id(idPregunta)
			}catch (Exception e){
				return new ResponseEntity<String>("Id de pregunta inexistente", HttpStatus.BAD_REQUEST)			
			}
			
			var Usuario usuario = usuarioService.buscarUsuarioSinLosAmigosPorId(idUsuario).orElse(null)
			var Usuario autor = usuarioService.buscarUsuarioSinLosAmigosPorId(pregunta.idAutor).orElse(null)
			
			pregunta.opciones = Arrays.asList(pregunta.opciones)
			
			pregunta.autor = autor
			pregunta.idAutor !== usuario.id ? pregunta.respuestaCorrecta = null
			
			if(!usuario.yaRespondio(pregunta.pregunta)){
				pregunta
			}else{
				return new ResponseEntity<String>("No se puede acceder a la pregunta dado que ya la respondió anteriormente", HttpStatus.UNAUTHORIZED)					
			}
		
	}
	
	def verificarRespuesta(String laRespuesta, String idPregunta, long idUsuario){
			var pregunta = repoPregunta.findById(idPregunta).get()
			pregunta.autor = usuarioService.buscarUsuarioSinLosAmigosPorId(pregunta.idAutor).orElse(null)
			var Usuario usuario = usuarioService.buscarUsuarioSinLosAmigosPorId(idUsuario).orElse(null)
			
			if (pregunta.estaActiva) {
				
				pregunta.responder(usuario, laRespuesta)
				usuarioService.actualizar(usuario) //Actualizacion del historial
				
				
				var String esRespuesta
				
				if(pregunta.esRespuestaCorrecta(laRespuesta)){
					esRespuesta = 'Correcto'
					usuarioService.actualizar(pregunta.autor)		
				}else{
					esRespuesta = 'Incorrecto'
				}	
				
				return esRespuesta
			} else {
				return 'No puede responder esta pregunta ya que se encuentra inactiva'
			}
			
			
	}
	
	@Transactional
	def updatePreguntaById(@Valid UpdatePregunta updatePregunta, String idPregunta) {
		try{
		val _id = new ObjectId(idPregunta)
		//Ver doble query vs mapear a mano los atributos que necesitamos conservar para la copia de la pregunta anterior
		var preguntaAnterior = repoPregunta.findBy_id(_id)
		var preguntaActualizada = repoPregunta.findBy_id(_id)

			preguntaActualizada.opciones = updatePregunta.opciones
			preguntaActualizada.respuestaCorrecta = updatePregunta.respuestaCorrecta
			
			repoPregunta.save(preguntaActualizada)
			logService.agregarRegistro(preguntaAnterior, preguntaActualizada)
		}catch (Exception e){
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "La pregunta con ID = " + idPregunta + " no existe") // No se usa ResponseEntity porque no funciona con throw			
		}
 
	}
	
	@Transactional
	def void crearPregunta(@Valid Pregunta nuevaPregunta, int puntos){
			nuevaPregunta.autor = usuarioService.buscarUsuarioSinAmigosNiHistorialPorId(nuevaPregunta.idAutor).orElse(null)
			if (nuevaPregunta instanceof PreguntaSolidaria){
				nuevaPregunta.asignarPuntos(puntos)
			}
			repoPregunta.save(nuevaPregunta)
			val preguntaConId= repoPregunta.findByPregunta(nuevaPregunta.pregunta)
			//Es necesario guardarla primero en mongo para que tengan el mismo id.
			val PreguntaDTO nuevaPreguntaDTO = PreguntaDTO.fromPregunta(preguntaConId)
			repoPreguntaActiva.save(nuevaPreguntaDTO)
	}
	
}