package phm.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import javax.validation.constraints.Size
import javax.validation.constraints.NotNull

@Accessors
class PreguntaDTO {
  String id
  String pregunta
  Long idAutor
  boolean activa

  private new() {}

  def static fromPregunta(Pregunta pregunta) {
    new PreguntaDTO => [
      id = pregunta.id
      pregunta = pregunta.pregunta
      idAutor = pregunta.idAutor
      activa = pregunta.estaActiva
    ]
  }
}

@Accessors
class UpdatePregunta {
	@Size(min = 2, message = "La pregunta debe tener al menos 2 opciones")
	var List<String> opciones = newArrayList
	@NotNull(message = "La pregunta debe tener al menos una opcion correcta")
	var String respuestaCorrecta
	
	 new(){}
	
	def static fromPregunta(Pregunta pregunta) {
	    new UpdatePregunta() => [
	    	opciones = pregunta.opciones
	    	respuestaCorrecta = pregunta.respuestaCorrecta
	    ]
  }
}
