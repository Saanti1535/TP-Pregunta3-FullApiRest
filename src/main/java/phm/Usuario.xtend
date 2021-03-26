package phm

import java.time.LocalDate
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.annotation.JsonIgnore

@Accessors //Este Accessors es necesario para pegarle desde el repo en memoria
class Usuario extends Entidad {
	@Accessors String username
	@JsonIgnore
	@Accessors String password
	String nombre
	String apellido
	LocalDate fechaNacimiento
	List<Usuario> amigos = newLinkedList
	@Accessors float puntaje

	def void agregarPuntos(float puntos) {
		puntaje += puntos
	}

	def void quitarPuntos(float puntos) {
		puntaje -= puntos
	}

	/* Metodos para mapeo con JSON */
	@JsonProperty("fechaNacimiento")
	def LocalDate obtenerFechaNacimiento(String fecha) {
		var String[] parte = fecha.split("-");
		var int anio = Integer.parseInt(parte.get(0))
		var int mes = Integer.parseInt(parte.get(1))
		var int dia = Integer.parseInt(parte.get(2))

		this.fechaNacimiento = LocalDate.of(anio, mes, dia)
	}
	
	@JsonProperty("amigos")
	def void obtenerListaDeAmigos(List<String> amigos) {
		amigos.forEach(amigo |
			this.amigos.add(RepositorioUsuarios.instance.buscarPorNombreDeUsuario(amigo))
		)
	}

}
