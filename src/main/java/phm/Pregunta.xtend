package phm

import java.util.List
import java.time.LocalDateTime
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.LocalDate
import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonSubTypes
import com.fasterxml.jackson.annotation.JsonTypeInfo
import com.fasterxml.jackson.annotation.JsonTypeName
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonProperty.Access

@Accessors
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type", visible = true)
@JsonSubTypes( 
	@JsonSubTypes.Type(name = "preguntaSimple", value = PreguntaSimple), 
	@JsonSubTypes.Type(name = "preguntaRiesgosa", value = PreguntaRiesgosa), 
	@JsonSubTypes.Type(name = "preguntaSolidaria", value = PreguntaSolidaria)
)
abstract class Pregunta extends Entidad{
	static final long minutosDeVigencia = 0
	@Accessors var String pregunta
	var String respuestaCorrecta
	var List<String> opciones = newArrayList
	@Accessors var LocalDateTime fechaHoraDeCreacion = LocalDateTime.now() //Fecha y hora juntos, sirve para hacer mas simple la comparacion
	@Accessors var Usuario autor
	
	@JsonProperty("idAutor")
	def getIdAutor(){
		autor.id
	}
	
	@JsonIgnore
	def String getRespuestaCorrecta(){
	   return respuestaCorrecta
	}	
	
	@JsonProperty(access = Access.WRITE_ONLY)
	def String setRespuestaCorrecta(String respuesta){
	   respuestaCorrecta = respuesta
	}	
	
	
	@JsonProperty("nombreAutor")
	def String getNombreAutor(){
		autor.nombre + ' ' + autor.apellido
	}
	
	def boolean estaActiva(){
		var LocalDateTime vencimiento = fechaHoraDeCreacion.plusMinutes(minutosDeVigencia)
		LocalDateTime.now().isBefore(vencimiento)
	}
	
	def boolean esRespuestaCorrecta(String respuesta){
		respuesta.equals(respuestaCorrecta)
	}
	
	def void responder(Usuario participante, String respuesta)
	
	def Boolean preguntaContieneString(String busqueda){
		return pregunta.toLowerCase().contains(busqueda.toLowerCase())
	}
	
	def void modificarHistorial(Usuario participante, float puntos){
		var RegistroRespuestas registro = new RegistroRespuestas()
		registro.pregunta = pregunta
		registro.fechaRespuesta = LocalDate.now()
		registro.puntosOtorgados = puntos
		
		participante.historial.add(registro)
	}
	
	def void agregarPuntos(Usuario participante, float puntos){
		participante.agregarPuntos(puntos)
		modificarHistorial(participante, puntos)
	}
}


@JsonTypeName("preguntaSimple")
class PreguntaSimple extends Pregunta{
	final String type = "preguntaSimple"
	static final float puntos = 10
	
	//HACER TEMPLATE 
	override responder(Usuario participante, String respuesta){
		if(esRespuestaCorrecta(respuesta)){
			agregarPuntos(participante, puntos)
		} else modificarHistorial(participante, 0)
	}
}


@JsonTypeName("preguntaRiesgosa")
class PreguntaRiesgosa extends Pregunta{
	final String type = "preguntaRiesgosa"
	static final long minutosDeRiesgo = 1
	static final float puntos = 100
	static final float puntosEnRiesgo = 50
	
	override responder(Usuario participante, String respuesta){
		if(esRespuestaCorrecta(respuesta)){
			if(esRespuestaRapida){
				this.autor.quitarPuntos(puntosEnRiesgo)
			}
		 	agregarPuntos(participante, puntos)
		} else modificarHistorial(participante, 0)
	}
	
	def boolean esRespuestaRapida(){
		var LocalDateTime tiempoLimite = fechaHoraDeCreacion.plusMinutes(minutosDeRiesgo)
		LocalDateTime.now().isBefore(tiempoLimite)
	}
}


@JsonTypeName("preguntaSolidaria")
class PreguntaSolidaria extends Pregunta{
	final String type = "preguntaSolidria"
	float puntos
		
	def asignarPuntos(float losPuntos){
		puntos = losPuntos
	}
	
	override responder(Usuario participante, String respuesta){
		if(esRespuestaCorrecta(respuesta)) {
			agregarPuntos(participante, puntos)
			autor.quitarPuntos(puntos)
		} else modificarHistorial(participante, 0)
	}
}


