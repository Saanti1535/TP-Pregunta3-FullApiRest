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