package phm.service

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import phm.repository.UsuarioRepository
import phm.domain.Usuario

@Service
class UsuarioService {

	@Autowired
	UsuarioRepository repoUsuario
	
	def getUsuarioById(long idUsuario){
		repoUsuario.findById(idUsuario).orElse(null)
	}
	
	def guardarUsuario(Usuario usuario){
		repoUsuario.save(usuario)
	}
	
}