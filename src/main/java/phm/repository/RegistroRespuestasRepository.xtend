package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.RegistroRespuestas
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface RegistroRespuestasRepository extends CrudRepository<RegistroRespuestas, Long> {
	def Optional<RegistroRespuestas> findByPregunta(String pregunta)
}