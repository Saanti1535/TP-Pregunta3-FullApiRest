package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.Usuario
import org.springframework.stereotype.Repository
import org.springframework.data.jpa.repository.EntityGraph

@Repository
interface UsuarioRepository extends CrudRepository<Usuario, Long> {
	
	@EntityGraph(attributePaths = #["amigos", "historial"])
	def Usuario findByUsername(String username)
}