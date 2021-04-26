package phm.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import javax.validation.constraints.Size

@Accessors
class PreguntaDTO {
  Long id
  String pregunta
  Long idAutor
  boolean activa

  private new() {}

  def static fromPregunta(Pregunta pregunta) {
    new PreguntaDTO => [
      id = pregunta.id
      pregunta = pregunta.pregunta
      idAutor = pregunta.getIdAutor()
      activa = pregunta.estaActiva
    ]
  }
}

@Accessors
class UpdatePregunta {
	@Size(min = 2, message = "La preguntna debe tener al menos 2 opciones")
	var List<String> opciones = newArrayList
	
	 new(){}
	
	def static fromPregunta(Pregunta pregunta) {
	    new UpdatePregunta() => [
	    	opciones = pregunta.opciones
	    ]
  }
}
