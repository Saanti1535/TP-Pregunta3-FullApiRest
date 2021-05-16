package phm.service

import org.springframework.stereotype.Service
import phm.domain.Pregunta
import org.springframework.beans.factory.annotation.Autowired
import phm.repository.LogRepository
import phm.domain.LogModificaciones

@Service
class LogService {
	
	@Autowired
	LogRepository repoLog
	
	def agregarRegistro(Pregunta preguntaAnterior, Pregunta preguntaNueva) {
		var registro = new LogModificaciones(preguntaAnterior, preguntaNueva)
		repoLog.save(registro)
	}
	
}