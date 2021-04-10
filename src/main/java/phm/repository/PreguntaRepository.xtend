package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.Pregunta
import org.springframework.stereotype.Repository

@Repository
interface PreguntaRepository extends CrudRepository<Pregunta, Long> {
	
}