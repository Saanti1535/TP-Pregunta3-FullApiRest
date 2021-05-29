package phm.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import javax.validation.constraints.Size
import javax.validation.constraints.NotNull
import org.springframework.data.annotation.Id
import org.springframework.data.redis.core.RedisHash
import org.springframework.data.redis.core.TimeToLive

@Accessors
@RedisHash("PreguntaActiva")
class PreguntaDTO {
  @Id
  String _id
  
  @TimeToLive
  long segundosDeVigencia = Pregunta.minutosDeVigencia * 60 // El TTL funciona con segundos
  
  String pregunta
  Long idAutor
  boolean activa

  private new() {}

  def static fromPregunta(Pregunta pregunta) {
    new PreguntaDTO => [
      _id = pregunta._id.toString()
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
