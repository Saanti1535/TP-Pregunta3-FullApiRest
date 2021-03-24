package phm

import java.time.LocalDate
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors //Este Accessors es necesario para pegarle desde el repo en memoria
class Usuario extends Entidad {
	@Accessors String username
	@Accessors String password
	String nombre
	String apellido
	LocalDate fechaNacimiento
	List<Usuario> amigos = newArrayList
	@Accessors float puntaje
	
	def void agregarPuntos(float puntos){
		puntaje += puntos
	}
	
	def void quitarPuntos(float puntos) {
		puntaje -= puntos
	}
	
}