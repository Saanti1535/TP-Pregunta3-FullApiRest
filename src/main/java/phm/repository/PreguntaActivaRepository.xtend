package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.PreguntaDTO
import java.util.List
import org.springframework.data.repository.query.QueryByExampleExecutor

interface PreguntaActivaRepository extends CrudRepository<PreguntaDTO, String>, QueryByExampleExecutor<PreguntaDTO> {
	def List<PreguntaDTO> findByPreguntaContaining(String busqueda)
}