package phm.repository

import phm.domain.LogModificaciones
import org.springframework.stereotype.Repository
import org.springframework.data.mongodb.repository.MongoRepository
import java.util.List

@Repository
interface LogRepository extends MongoRepository<LogModificaciones, String>{
	def List<LogModificaciones> findByIdUsuario(Long idUsuario)
}