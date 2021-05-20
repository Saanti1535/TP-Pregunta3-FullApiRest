package phm.service

import org.springframework.stereotype.Service
import phm.domain.Pregunta
import org.springframework.beans.factory.annotation.Autowired
import phm.repository.LogRepository
import phm.domain.LogModificaciones
import java.util.List

@Service
class LogService {
	
	@Autowired
	LogRepository repoLog
	
	def List<LogModificaciones> obtener(Long idUsuario) {
		return repoLog.findByIdUsuario(idUsuario)
	}
	
	def agregarRegistro(Pregunta preguntaAnterior, Pregunta preguntaNueva) {
		val registro = new LogModificaciones()
		registro.cargarDatos(preguntaAnterior, preguntaNueva)
		repoLog.save(registro)
	}
	
}