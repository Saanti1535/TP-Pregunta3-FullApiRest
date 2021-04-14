package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.Usuario
import org.springframework.stereotype.Repository

@Repository
interface UsuarioRepository extends CrudRepository<Usuario, Long> {
	
	def Usuario findByUsernameEquals(String username) //Chequear bien si es username o nombreUsuario
}