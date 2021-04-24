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
	
}