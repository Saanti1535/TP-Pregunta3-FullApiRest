package phm.domain

import org.eclipse.xtend.lib.annotations.Accessors

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
