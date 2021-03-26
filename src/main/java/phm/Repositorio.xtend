package phm

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List

class Repositorio<T extends Entidad> {
	@Accessors List<T> lista = newArrayList
	@Accessors long id = 0

	def create(T object) {
		lista.add(object)
		object.id = id
		id++
	}

	def delete(T object) {
		getById(object.id).bajaLogica = true
	}
	
	def hardDelete(T object) {
		lista.remove(object) 
	}

	def T getById(long id) {
		lista.findFirst[ elemento | elemento.id == id ]
	}
	
	def update(T object) {
		val index = lista.indexOf(getById(object.id))
		try {
			hardDelete(getById(object.id)) //Si se le manda el object directamente no funciona (porque ya viene modificado y no lo encuentra)
		} catch (Exception e) {
			throw new Exception("No se ha podido encontrar el id solicitado")
		}
			lista.add(index, object)
		
	}
	
}



class RepositorioUsuarios extends Repositorio<Usuario>{
	static RepositorioUsuarios repositorioUsuarios

   	private new(){}

	def static RepositorioUsuarios getInstance() {
		if (repositorioUsuarios === null) {
			repositorioUsuarios = new RepositorioUsuarios
		}
		repositorioUsuarios
	}

   	def Usuario buscarPorNombreDeUsuario(String nombreUsuario){
   	   lista.findFirst(usuario | usuario.username == nombreUsuario)
   	}  
   
   	def boolean existeUsuarioConNombreDeUsuario(String nombreUsuario){
   	   lista.exists[usuario | usuario.username == nombreUsuario]
   	} 
   
}



class RepositorioPreguntas extends Repositorio<Pregunta>{
	static RepositorioPreguntas repositorioPreguntas
	
	private new(){}

	def static RepositorioPreguntas getInstance() {
		if (repositorioPreguntas === null) {
			repositorioPreguntas = new RepositorioPreguntas
		}
		repositorioPreguntas
	}
	
	def getTodasLasPreguntas(){
		lista
	}
	
	def getPreguntasActivas() {
		lista.filter[pregunta | pregunta.estaActiva].toList()
	}
	
	def List<Pregunta> search(String busqueda) {
		return lista.filter[preguntaContieneString(busqueda)].toList()
	}
	
}