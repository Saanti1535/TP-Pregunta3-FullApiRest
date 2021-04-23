package phm.controller

import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PutMapping
import phm.domain.Usuario
import org.springframework.beans.factory.annotation.Autowired
import java.util.Arrays
import phm.domain.UsuarioDTO
import phm.service.UsuarioService

@CrossOrigin
@RestController
class ControllerUsuario {

	@Autowired
	UsuarioService usuarioService

	@PostMapping("/login/{username}")
	def loginUsuarioPorNombre(@RequestBody String password, @PathVariable String username) {

		val String claveRecibida = Mapper.extraerStringDeJson(password, "password")
		val Usuario usuario = usuarioService.buscarPorUsername(username, claveRecibida)
		val UsuarioDTO usuarioDTO = UsuarioDTO.fromUsuario(usuario)

		return usuarioDTO
	}

	@GetMapping("/usuarios/{id},{usernameABuscar}")
	def getAmigosParaAgregar(@PathVariable Long id, @PathVariable String usernameABuscar) {

		return this.usuarioService.buscarNoAgregados(id, usernameABuscar)
	}

	// Cambiar nombre de rutas
	@GetMapping("/usuario/{id}")
	def getUsuarioPorId(@PathVariable Long id) {
		var Usuario usuario = usuarioService.buscarPorId(id).orElse(null)
		usuario.amigos = Arrays.asList(usuario.amigos)
		usuario
	}

	@PutMapping("/actualizar/{id}")
	def updateUsuarioPorId(@RequestBody String body, @PathVariable Long id) {
		val usuario = Mapper.mapear.readValue(body, Usuario)
		usuarioService.actualizar(usuario)
		
	}

}
