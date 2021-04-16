package phm.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List

@Accessors
class PreguntaDTO {
  Long id
  String pregunta
  Long idAutor

  private new() {}

  def static fromPregunta(Pregunta pregunta) {
    new PreguntaDTO => [
      id = pregunta.id
      pregunta = pregunta.pregunta
      idAutor = pregunta.getIdAutor()
    ]
  }
}

@Accessors
class UpdatePregunta {
	var List<String> opciones = newArrayList
	
	private new(){}
	
	def static fromPregunta(Pregunta pregunta) {
	    new UpdatePregunta() => [
	    	opciones = pregunta.opciones
	    ]
  }
}
