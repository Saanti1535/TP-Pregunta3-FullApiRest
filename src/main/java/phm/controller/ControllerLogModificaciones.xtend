package phm.controller

import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.CrossOrigin
import phm.service.LogService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import phm.domain.LogModificaciones
import org.springframework.web.bind.annotation.PathVariable
import java.util.List

@RestController
@CrossOrigin
class ControllerLogModificaciones {
	
	@Autowired
	LogService logService
	
	@GetMapping('/log/{idUsuario}')
	def List<LogModificaciones> obtener(@PathVariable Long idUsuario) {
		return logService.obtener(idUsuario)
	}
	
}