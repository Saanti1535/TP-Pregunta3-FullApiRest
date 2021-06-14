package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.PreguntaDTO
import org.springframework.data.repository.query.QueryByExampleExecutor

interface PreguntaActivaRepository extends CrudRepository<PreguntaDTO, String>, QueryByExampleExecutor<PreguntaDTO> {}