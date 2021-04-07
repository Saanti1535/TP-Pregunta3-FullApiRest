package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.Pregunta

interface PreguntaRepository extends CrudRepository<Pregunta, Long> {
	
}