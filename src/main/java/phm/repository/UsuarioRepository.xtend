package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.Usuario
import org.springframework.stereotype.Repository
import org.springframework.data.jpa.repository.EntityGraph
import java.util.Optional

@Repository
interface UsuarioRepository extends CrudRepository<Usuario, Long> {
	
	@EntityGraph(attributePaths = #["amigos", "historial"])
	def Usuario findByUsername(String username)
	
	@EntityGraph(attributePaths = #["historial", "amigos"])
	override Optional<Usuario> findById(Long id)
	
//	def Usuario getById(Long id) 
}