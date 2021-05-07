package phm.service

import org.springframework.boot.test.context.SpringBootTest
import org.springframework.beans.factory.annotation.Autowired
import org.junit.jupiter.api.Test
import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertThrows
import phm.domain.Usuario
import org.junit.jupiter.api.DisplayName
import javax.validation.ConstraintViolationException

@SpringBootTest
@DisplayName("Testeo al service de usuarios")
class UsuarioServiceTest {
	
	@Autowired
	UsuarioService usuarioService
	
	@Test
	@DisplayName("Se busca un usuario con username y contraseña validos y se devuelve un usuario existente")
	def void buscarUsuarioPorUsernameYContraseñaExistentes() {
		val username = 'pep'
		val contraseña = '123456'
		
		val Long idUsuarioEncontrado = usuarioService.buscarPorUsernameYContrasenia(username, contraseña)
		val Usuario usuarioEncontrado = usuarioService.buscarUsuarioSinAmigosNiHistorialPorId(idUsuarioEncontrado).orElse(null)
		
		assertEquals(usuarioEncontrado.username, username)
		assertEquals(usuarioEncontrado.password, contraseña)
	}
	
	@Test
	@DisplayName("Se busca un usuario con contraseña no existente y se lanza una excepcion de seguridad")
	def void buscarUsuarioPorUsernameYContraseñaInexistentes() {
		val username = 'pep'
		val contraseña = '1234567'
		
		assertThrows(SecurityException, [usuarioService.buscarPorUsernameYContrasenia(username, contraseña)])
	}
	
	@Test
	@DisplayName("Se actualiza el nombre de un usuario con datos validos y se efectua el cambio")
	def void actualizarNombreDeUsuario() {
		
		val String nombreActualizado = 'Pepo'
		
		val Usuario usuarioOriginal = usuarioService.buscarPorId(1L).orElse(null)
		val Usuario usuarioActualizado = usuarioOriginal
		usuarioActualizado.nombre = nombreActualizado 
		
		usuarioService.actualizar(usuarioActualizado)
		
		assertEquals(usuarioOriginal.nombre, nombreActualizado)
	}
	
	@Test
	@DisplayName("Se actualiza el apellido de un usuario dejando este campo vacio y se lanza una excepcion de validaciones")
	def void actualizarNombreDeUsuarioInvalido() {
		
		val String nombreActualizado = ' '
		
		val Usuario usuarioOriginal = usuarioService.buscarPorId(1L).orElse(null)
		val Usuario usuarioActualizado = usuarioOriginal
		usuarioActualizado.nombre = nombreActualizado 
		
		assertThrows(ConstraintViolationException, [usuarioService.actualizar(usuarioActualizado)])
	}
}