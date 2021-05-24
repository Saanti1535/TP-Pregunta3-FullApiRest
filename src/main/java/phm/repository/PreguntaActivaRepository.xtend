package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.PreguntaDTO

interface PreguntaActivaRepository extends CrudRepository<PreguntaDTO, String> {}