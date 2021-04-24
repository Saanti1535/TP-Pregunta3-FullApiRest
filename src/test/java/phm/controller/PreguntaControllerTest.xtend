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
	
}