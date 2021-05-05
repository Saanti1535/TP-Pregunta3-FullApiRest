package phm.controller

import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.test.context.ActiveProfiles
import org.junit.jupiter.api.DisplayName
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.test.web.servlet.MockMvc
import org.junit.jupiter.api.Test
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders


import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
import org.springframework.http.MediaType

import javax.transaction.Transactional

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@DisplayName("Testeo al controller de preguntas")
class PreguntaControllerTest {

	@Autowired
	MockMvc mockMvc

	@Test
	@DisplayName("el get que utiliza la home trae todas las preguntas")
	def void traerTodasLasPreguntas() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/busqueda/preguntas"))
		.andExpect(status.isOk)
		.andExpect(content.contentType(MediaType.APPLICATION_JSON))
		.andExpect(jsonPath("$.length()").value(8))
	}
	
	@Test
	@DisplayName("Un usuario no puede responder una pregunta que anteriormente respondió")
	def void usuarioNoPuedeResponderDosVecesLaMismaPregunta() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/busqueda/pregunta/{id}/{idUsuario}",1,2))
		.andExpect(status.is4xxClientError)
	}
	
	@Test
	@Transactional
	@DisplayName("Una respuesta correcta suma puntos")
	def void respuestaCorrectaSumaPuntos() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/revisarRespuesta/{idPregunta}",2)
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"laRespuesta": "Opcion 2", "idUsuario": 2}')
		)
		.andExpect(status.isOk)
		//pep empieza con 55
		mockMvc
		.perform(MockMvcRequestBuilders.get("/usuario/{id}", 2))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.puntaje").value(65))
	}
	
	@Test
	@Transactional
	@DisplayName("Una respuesta incorrecta no suma puntos, pero si se registra en el historial")
	def void respuestaIncorrectaNoSumaPuntosSoloSeRegistra() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/revisarRespuesta/{idPregunta}",2)
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"laRespuesta": "Opcion 3", "idUsuario": 2}')
		)
		//pep empieza con 55 y con registros de respuestas (el registro aumenta, los puntos quedan igual)
		mockMvc
		.perform(MockMvcRequestBuilders.get("/usuario/{id}", 2))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.puntaje").value(55))
		.andExpect(jsonPath("$.historial.length()").value(4))
	}
	
}