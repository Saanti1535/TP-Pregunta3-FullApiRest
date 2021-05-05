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
@DisplayName("Testeo al controller de Usuarios")
class UsuarioControllerTest {

	@Autowired
	MockMvc mockMvc

	@Test
	@DisplayName("A un usuario sin amigos le aparecen todos los otros usuarios para amistarse")
	def void alguienSinAmigosPuedeAmistarseConTodos() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/usuarios/{id},{usernameABuscar}",1, ""))
		.andExpect(status.isOk)
		.andExpect(content.contentType(MediaType.APPLICATION_JSON))
		.andExpect(jsonPath("$.length()").value(3))
	}
	
	@Test
	@DisplayName("A un usuario con amigos solo le aparecen, para amistarse, los usuarios que todavia no son amigos")
	def void alguienConAmigosNoLeAparacenTodosParaAmistarse() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/usuarios/{id},{usernameABuscar}",2, ""))
		.andExpect(status.isOk)
		.andExpect(content.contentType(MediaType.APPLICATION_JSON))
		.andExpect(jsonPath("$.length()").value(2))
	}
	
	@Test
	@DisplayName("Un usuario puede ingresar con los datos correctos")
	def void unUsuarioPuedeLoguearseConDatosCorrectos() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/login/{username}","pep")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"password": "123456"}')
		)
		.andExpect(status.isOk)
	}
	
	@Test
	@DisplayName("Un usuario no puede ingresar con los datos correctos, tira un 4xx")
	def void unUsuarioNoPuedeLoguearseConDatosCorrectos() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/login/{username}","pep")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"password": "lala"}')
		)
		.andExpect(status.is4xxClientError)
	}
	
	@Test
	@Transactional
	@DisplayName("Se puede actualizar un usurio")
	def void sePuedeActualizarUsuario() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/actualizar/{id}",2)
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"id":2,"nombre":"Pepa","apellido":"Guardiola","puntaje":55,"fechaNacimiento":"1990-05-14T20:04:15.000-03:00","amigos":["juana"],"historial":[{"id":3,"pregunta":"¿De qué colores es la bandera de México?","fechaRespuesta":"2021-03-25T20:04:15.000Z","puntosOtorgados":30},{"id":1,"pregunta":"¿Cuál es el lugar más frío de la tierra?","fechaRespuesta":"2021-03-25T20:04:15.000Z","puntosOtorgados":10},{"id":2,"pregunta":"¿Qué cantidad de huesos en el cuerpo humano?","fechaRespuesta":"2021-03-25T20:04:15.000Z","puntosOtorgados":15}]}')
		)
		.andExpect(status.isOk)
		//pep ahora es Pepa
		mockMvc
		.perform(MockMvcRequestBuilders.get("/usuario/{id}", 2))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.nombre").value("Pepa"))
	}
	
	@Test
	@Transactional
	@DisplayName("No se puede actualizar un usurio con datos faltantes")
	def void noSePuedeActualizarUsuarioConDatosFaltantes() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/actualizar/{id}",2)
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"id":2,"nombre":"","apellido":"","puntaje":55,"fechaNacimiento":"1990-05-14T20:04:15.000-03:00","amigos":["juana"],"historial":[{"id":3,"pregunta":"¿De qué colores es la bandera de México?","fechaRespuesta":"2021-03-25T20:04:15.000Z","puntosOtorgados":30},{"id":1,"pregunta":"¿Cuál es el lugar más frío de la tierra?","fechaRespuesta":"2021-03-25T20:04:15.000Z","puntosOtorgados":10},{"id":2,"pregunta":"¿Qué cantidad de huesos en el cuerpo humano?","fechaRespuesta":"2021-03-25T20:04:15.000Z","puntosOtorgados":15}]}')
		)
		.andExpect(status.is4xxClientError)
	}
	
}