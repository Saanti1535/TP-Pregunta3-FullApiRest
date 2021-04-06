package phm.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.time.ZonedDateTime
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter
import javax.persistence.Entity
import javax.persistence.Table

@Accessors
@Entity
@Table(name="registro")
class RegistroRespuestas extends Entidad {
	String pregunta
	ZonedDateTime fechaRespuesta
	float puntosOtorgados
	
	@JsonProperty("fechaRespuesta")
	def void obtenerFechaRespuesta(String fecha) {
		this.fechaRespuesta = ZonedDateTime.parse(fecha, DateTimeFormatter.ISO_OFFSET_DATE_TIME) 
	}
}