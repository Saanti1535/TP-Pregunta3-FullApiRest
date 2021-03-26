package phm

import java.time.LocalDate
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RegistroRespuestas extends Entidad{
	String pregunta
	LocalDate fechaRespuesta
	float puntosOtorgados
}