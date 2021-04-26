package phm.domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.annotation.JsonIgnore
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter
import javax.validation.constraints.NotBlank
import javax.validation.constraints.Past
import javax.persistence.Entity
import javax.persistence.OneToMany
import javax.persistence.ElementCollection
import javax.persistence.Table
import javax.persistence.Column
import javax.persistence.OrderColumn
import javax.persistence.FetchType
import java.util.Set
import javax.persistence.CascadeType
import javax.persistence.JoinColumn
import javax.validation.constraints.Size

@Accessors //Este Accessors es necesario para pegarle desde el repo en memoria

@Entity
@Table(name="usuario")
class Usuario extends Entidad {
	@Accessors String username
	
	@JsonIgnore
	@Accessors String password
	
	@NotBlank(message = "El usuario debe tener un nombre")
	String nombre
	
	@NotBlank(message = "El usuario debe tener un apellido")
	String apellido
	
	@Column(columnDefinition = "TIMESTAMP")
	@Past(message = "La fecha de nacimiento debe ser anterior a hoy")
	ZonedDateTime fechaNacimiento
	
	@ElementCollection(targetClass=String)
	@OrderColumn
	List<String> amigos = newLinkedList
	
	@Accessors float puntaje
	
	@OneToMany(fetch=FetchType.LAZY, cascade=CascadeType.MERGE)
	@JoinColumn(name="id_usuario")
	Set<RegistroRespuestas> historial = newHashSet

	def void agregarPuntos(float puntos) {
		puntaje += puntos
	}

	def void quitarPuntos(float puntos) {
		puntaje -= puntos
	}

	/* Metodos para mapeo con JSON */
	@JsonProperty("fechaNacimiento")
	def void obtenerFechaNacimiento(String fecha) {
		this.fechaNacimiento = ZonedDateTime.parse(fecha, DateTimeFormatter.ISO_OFFSET_DATE_TIME)
	}
	
	def yaRespondio(String preguntaAResponder){
		historial.exists[respuesta | respuesta.pregunta == preguntaAResponder]
	}
	
	def update(Usuario actualizado) {
		this.nombre = actualizado.nombre
		this.apellido = actualizado.apellido
		this.fechaNacimiento = actualizado.fechaNacimiento
		this.amigos != actualizado.amigos ? this.amigos = actualizado.amigos // Si los amigos no cambian no pisamos los valores. Si lo hacemos, se hacen queries innecesarias
	}

}
