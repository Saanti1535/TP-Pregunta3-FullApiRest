package phm.domain

import org.bson.types.ObjectId
import org.eclipse.xtend.lib.annotations.Accessors
import org.springframework.data.annotation.Id
import java.util.List
import java.time.LocalDateTime
import org.springframework.data.mongodb.core.mapping.Document


@Accessors 
@Document(collection="LogModificaciones")
class LogModificaciones {
	
	@Id
	var ObjectId id
	
	var long idUsuario
	var ObjectId idPregunta
	var LocalDateTime fechaHoraDeCreacion = LocalDateTime.now()
	
	var String preguntaAnterior
	var List<String> opcionesAnteriores = newArrayList

	var String preguntaNueva
	var List<String> opcionesNuevas = newArrayList
	
	new(Pregunta preguntaAnterior, Pregunta preguntaNueva){
		this.idUsuario = preguntaAnterior.idAutor
		this.idPregunta = preguntaAnterior.getObjectId
		this.preguntaAnterior = preguntaAnterior.pregunta
		this.opcionesAnteriores = preguntaAnterior.opciones
		this.preguntaNueva = preguntaNueva.pregunta
		this.opcionesNuevas = preguntaNueva.opciones
	}
}