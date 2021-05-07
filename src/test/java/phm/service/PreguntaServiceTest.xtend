package phm.service

import org.springframework.boot.test.context.SpringBootTest
import org.springframework.beans.factory.annotation.Autowired
import org.junit.jupiter.api.Test
import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertNotNull
import static org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.api.DisplayName
import phm.domain.Pregunta
import phm.repository.PreguntaRepository
import phm.domain.PreguntaSimple
import javax.validation.ConstraintViolationException
import org.springframework.test.context.ActiveProfiles

@SpringBootTest
@ActiveProfiles("test")
@DisplayName("Testeo al service de preguntas")
class PreguntaServiceTest {
	
	@Autowired
	PreguntaService preguntaService
	@Autowired
	PreguntaRepository preguntaRepository
	
	@Test
	@DisplayName("Se responde una pregunta de forma correcta")
	def void responderPregunta() {
		val respuesta = 'Opcion 2'
		
		val resultado = preguntaService.verificarRespuesta(respuesta, 1L, 1L)
		
		assertEquals('Correcto', resultado)
	}
	
	@Test
	@DisplayName("Se crea una pregunta valida")
	def void crearPregunta() {
		val Pregunta nuevaPregunta = new PreguntaSimple => [
			pregunta = 'Cuanto mide la torre eiffel?'
			opciones = #['Opcion 1', 'Opcion 2']
			respuestaCorrecta = 'Opcion 2'
		]
		
		preguntaService.crearPregunta(nuevaPregunta, 1L, 25)
		val preguntaCreada = preguntaRepository.findById(1L).orElse(null)
		
		assertNotNull(preguntaCreada)
	}
	
	@Test
	@DisplayName("Se crea una pregunta con menos de dos opciones (invalida)")
	def void crearPreguntaInvalida() {
		val Pregunta nuevaPregunta = new PreguntaSimple => [
			pregunta = 'Cuanto mide la torre eiffel?'
			opciones = #['Opcion 1']
			respuestaCorrecta = 'Opcion 2'
		]
		
		assertThrows(ConstraintViolationException, [preguntaService.crearPregunta(nuevaPregunta, 1L, 25)])
	}
	
//	@Test
//	@DisplayName("Se actualiza una pregunta de forma correcta")
//	@Transactional
//	def void actualizarPregunta() {
//		val UpdatePregunta updatePregunta = new UpdatePregunta 
//		updatePregunta.opciones = Arrays.asList('Opcion 5', 'Opcion 6')
//		updatePregunta.respuestaCorrecta = "Opcion 5"
//		val Pregunta pregunta = preguntaRepository.findById(1L).orElse(null)
//		
//		preguntaService.updatePreguntaById(updatePregunta, 1L)
//		
//		assertEquals(updatePregunta.opciones, pregunta.opciones)
//	}
	
	
}