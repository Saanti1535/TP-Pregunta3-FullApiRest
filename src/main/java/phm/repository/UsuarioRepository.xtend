package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.Usuario
import org.springframework.stereotype.Repository
import org.springframework.data.jpa.repository.EntityGraph
import java.util.Optional
import java.util.List
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

@Repository
interface UsuarioRepository extends CrudRepository<Usuario, Long> {
	
	def Usuario findByUsername(String username)
	
	@EntityGraph(attributePaths = #["historial", "amigos"])
	override Optional<Usuario> findById(Long id)
	
	@EntityGraph(attributePaths = #["historial"])
	def Optional<Usuario> findUsuarioSinAmigosById(Long id)
	
	@EntityGraph(attributePaths = #["amigos"])
	def Optional<Usuario> findUsuarioSinHistorialById(Long id)
	
	def Optional<Usuario> findUsuarioSinAmigosNiHistorialById(Long id)
	
	//Trae los amigos del usuario (id)
	@Query(value = "SELECT amigos FROM usuario_amigos tabla WHERE tabla.usuario_id = :id", nativeQuery = true)
	def List<String> getAmigosById(@Param("id") Long id)

	//Trae los nombres NO AMIGOS del usuario (id) filtrados por el criterio de búsqueda (usernameABuscar)
	@Query(value = "SELECT username FROM usuario u 
						WHERE u.username NOT IN (SELECT amigos FROM usuario_amigos tabla WHERE tabla.usuario_id = :id) 
						AND u.id != :id
						AND u.username LIKE %:usernameABuscar%", nativeQuery = true)
	def List<String> getAmigosNoAgregadosById(@Param("id") Long id, @Param("usernameABuscar")String usernameABuscar)
	
	
//	def Usuario getById(Long id) 
}


	//Trae los amigos del usuario (id) filtrados por el criterio de búsqueda (usernameABuscar)
//	@Query(value = "SELECT amigos FROM usuario_amigos tabla WHERE tabla.usuario_id = :id AND tabla.amigos LIKE %:usernameABuscar%", nativeQuery = true)
//	def List<String> getAmigosById(@Param("id") Long id, @Param("usernameABuscar")String usernameABuscar)

