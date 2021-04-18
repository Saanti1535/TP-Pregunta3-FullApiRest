package phm.service

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import phm.repository.UsuarioRepository
import phm.domain.Usuario
import org.springframework.validation.annotation.Validated
import javax.validation.Valid

@Service
@Validated
class UsuarioService {

	@Autowired
	UsuarioRepository repoUsuario
	
	def buscarPorUsername(String username, String claveRecibida){
		val usuario = repoUsuario.findByUsername(username)
		validar(usuario, usuario.password, claveRecibida)
		usuario
	}
	
	def buscarPorId(Long id) {
		repoUsuario.findById(id)
	}
	
	def buscarNoAgregados(Long id, String usuarioBuscado) {
		repoUsuario.getAmigosNoAgregadosById(id, usuarioBuscado)
	}
	
	def validar(Usuario usuario, String password, String claveRecibida) {
		(usuario === null || password != claveRecibida) ? throw new SecurityException("Usuario o contraseña incorrectos")
	}
	
	def actualizar(@Valid Usuario actualizado){
		val usuarioOriginal = repoUsuario.findById(actualizado.id).orElse(null)
		actualizado.username = usuarioOriginal.username
		actualizado.password = usuarioOriginal.password
		repoUsuario.save(actualizado)
	}
	
}