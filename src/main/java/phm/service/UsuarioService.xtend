package phm.service

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import phm.repository.UsuarioRepository
import phm.domain.Usuario
import org.springframework.validation.annotation.Validated
import javax.validation.Valid
import javax.transaction.Transactional

@Service
@Validated
class UsuarioService {

	@Autowired
	UsuarioRepository repoUsuario
	
	def buscarPorUsernameYContrasenia(String username, String claveRecibida){
		val usuario = repoUsuario.findByUsername(username)
		validar(usuario, usuario.password, claveRecibida)
		usuario
	}
	
	def buscarPorId(Long id) {
		repoUsuario.findById(id)
	}
	
	def buscarUsuarioSinLosAmigosPorId(Long id){
		repoUsuario.findUsuarioSinAmigosById(id)
	}
	def buscarUsuarioSinAmigosNiHistorialPorId(Long id){
		repoUsuario.findUsuarioSinAmigosNiHistorialById(id)
	}
	
	def buscarNoAgregados(Long id, String usuarioBuscado) {
		repoUsuario.getAmigosNoAgregadosById(id, usuarioBuscado)
	}
	
	def validar(Usuario usuario, String password, String claveRecibida) {
		(usuario === null || password != claveRecibida) ? throw new SecurityException("Usuario o contraseña incorrectos")
	}
	
	@Transactional
	def actualizar(@Valid Usuario actualizado){
		val usuarioOriginal = repoUsuario.findById(actualizado.id).orElse(null)
		usuarioOriginal.update(actualizado)
		repoUsuario.save(usuarioOriginal)
	}
	
}