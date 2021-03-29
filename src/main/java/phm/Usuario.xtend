package phm

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.annotation.JsonIgnore
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter
import javax.validation.constraints.NotBlank
import javax.validation.constraints.Past

@Accessors //Este Accessors es necesario para pegarle desde el repo en memoria

class Usuario extends Entidad {
	@Accessors String username
	@JsonIgnore
	@Accessors String password
	@NotBlank
	String nombre
	@NotBlank
	String apellido
	@Past
	ZonedDateTime fechaNacimiento
	List<Usuario> amigos = newLinkedList
	@Accessors float puntaje
	@Accessors List<RegistroRespuestas> historial = newArrayList

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
	
	@JsonProperty("amigos")
	def void obtenerListaDeAmigos(List<String> amigos) {
		amigos.forEach(amigo |
			this.amigos.add(RepositorioUsuarios.instance.buscarPorNombreDeUsuario(amigo))
		)
	}
	
	def yaRespondio(String preguntaAResponder){
		historial.exists[respuesta | respuesta.pregunta == preguntaAResponder]
	}

}
