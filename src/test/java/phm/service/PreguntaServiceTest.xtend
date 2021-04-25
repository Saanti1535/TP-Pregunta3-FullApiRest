package phm.service

import org.springframework.boot.test.context.SpringBootTest
import org.springframework.beans.factory.annotation.Autowired
import org.junit.jupiter.api.Test
import static org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.DisplayName

@SpringBootTest
@DisplayName("Testeo al service de preguntas")
class PreguntaServiceTest {
	
	@Autowired
	PreguntaService preguntaService
	
	@Test
	@DisplayName("Se responde una pregunta de forma correcta")
	def void responderPregunta() {
		val respuesta = '{laRespuesta: "Opcion 2", idUsuario: 1}'
		
		val resultado = preguntaService.verificarRespuesta(respuesta, 1L)
		
		assertEquals(resultado, 'Correcto')
	}
	
	
}