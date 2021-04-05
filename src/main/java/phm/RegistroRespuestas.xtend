package phm

import java.time.LocalDate
import org.eclipse.xtend.lib.annotations.Accessors
import java.time.ZonedDateTime
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter

@Accessors
class RegistroRespuestas extends Entidad{
	String pregunta
	ZonedDateTime fechaRespuesta
	float puntosOtorgados
	
	@JsonProperty("fechaRespuesta")
	def void obtenerFechaRespuesta(String fecha) {
		this.fechaRespuesta = ZonedDateTime.parse(fecha, DateTimeFormatter.ISO_OFFSET_DATE_TIME) 
	}
}