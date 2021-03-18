package phm

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List

class Repositorio<T extends Entidad> {
	@Accessors List<T> lista = newArrayList
	@Accessors Integer id = 0

	def create(T object) {
		lista.add(object)
		object.id = id
		id++
	}

	def delete(T object) {
		lista.remove(object)
	}

	def T getById(int id) {
		lista.filter[elemento|elemento.id == id].get(0)
	}
	
}

class RepositorioUsuarios extends Repositorio<Usuario>{
	static RepositorioUsuarios repositorioUsuarios

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