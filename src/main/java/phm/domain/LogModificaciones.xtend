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
	var String pregunta
	var LocalDateTime fechaHoraDeModificacion = LocalDateTime.now()
	var List<String> opcionesAnteriores = newArrayList
	var List<String> opcionesNuevas = newArrayList
	var String opcionCorrectaAnterior
	var String opcionCorrectaActual
	
	def void cargarDatos(Pregunta preguntaAnterior, Pregunta preguntaNueva){
		this.pregunta = preguntaAnterior.pregunta
		this.idUsuario = preguntaAnterior.idAutor
		this.idPregunta = preguntaAnterior.getObjectId
		this.opcionesAnteriores = preguntaAnterior.opciones
		this.opcionesNuevas = preguntaNueva.opciones
		this.opcionCorrectaAnterior = preguntaAnterior.respuestaCorrecta
		this.opcionCorrectaActual = preguntaNueva.respuestaCorrecta
	}
}