package phm.repository

import phm.domain.LogModificaciones
import org.springframework.stereotype.Repository
import org.springframework.data.mongodb.repository.MongoRepository

@Repository
interface LogRepository extends MongoRepository<LogModificaciones, String>{
	
}