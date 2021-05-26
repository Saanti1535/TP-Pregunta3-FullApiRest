package phm.domain

import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter
import javax.persistence.Entity
import javax.persistence.Table
import javax.persistence.Column
import java.time.LocalDateTime

@Accessors
@Entity
@Table(name="registro")
class RegistroRespuestas extends Entidad {
	
	@Column(length=255)
	String pregunta
	
	@Column(columnDefinition = "TIMESTAMP")
	LocalDateTime fechaRespuesta
	
	float puntosOtorgados
	
	@JsonProperty("fechaRespuesta")
	def void obtenerFechaRespuesta(String fecha) {
		this.fechaRespuesta = LocalDateTime.parse(fecha, DateTimeFormatter.ISO_OFFSET_DATE_TIME) 
	}
}