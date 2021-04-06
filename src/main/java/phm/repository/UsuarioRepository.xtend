package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.Usuario

interface UsuarioRepository extends CrudRepository<Usuario, Long> {
	
}