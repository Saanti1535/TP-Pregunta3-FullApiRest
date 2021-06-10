package phm.domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonSubTypes
import com.fasterxml.jackson.annotation.JsonTypeInfo
import com.fasterxml.jackson.annotation.JsonTypeName
import com.fasterxml.jackson.annotation.JsonIgnore
import javax.persistence.DiscriminatorValue
import org.springframework.data.mongodb.core.mapping.Document
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Transient
import java.time.LocalDateTime
import org.bson.types.ObjectId

@Accessors
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type", visible = true)
@JsonSubTypes( 
	@JsonSubTypes.Type(name = "preguntaSimple", value = PreguntaSimple), 
	@JsonSubTypes.Type(name = "preguntaRiesgosa", value = PreguntaRiesgosa), 
	@JsonSubTypes.Type(name = "preguntaSolidaria", value = PreguntaSolidaria)
)
@Document(collection="preguntas")
abstract class Pregunta{
	
	@Transient
	public static final long minutosDeVigencia = 1
	
	@Id
	@Accessors ObjectId _id
	
	@JsonProperty("_id")
	def get_id(){
		return _id.toString()
	}
	
	def getObjectId(){
		_id
	}
	
	@JsonIgnore
	@Accessors boolean bajaLogica = false
		
	@Accessors var String pregunta
	
	var String respuestaCorrecta
	
	var List<String> opciones = newArrayList
	
	@Accessors var LocalDateTime fechaHoraDeCreacion = LocalDateTime.now() //Fecha y hora juntos, sirve para hacer mas simple la comparacion
	
	@Transient
	@JsonIgnore
	@Accessors var Usuario autor
	
	var long idAutor 
	
	def String getRespuestaCorrecta(){
	   return respuestaCorrecta
	}	
	
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
		registro.fechaRespuesta = LocalDateTime.now()
		registro.puntosOtorgados = puntos
		
		participante.historial.add(registro)
	}
	
	def void agregarPuntos(Usuario participante, float puntos){
		participante.agregarPuntos(puntos)
		modificarHistorial(participante, puntos)
	}
}

@Accessors
@DiscriminatorValue("1")
@JsonTypeName("preguntaSimple")
@Document(collection="preguntas")
class PreguntaSimple extends Pregunta{
//	final String type = "preguntaSimple"
	@Accessors(PUBLIC_GETTER) static final float puntos = 10
	
	@JsonProperty("puntos")
	def getPuntos(){
		puntos
	}	
	//HACER TEMPLATE 
	override responder(Usuario participante, String respuesta){
		if(esRespuestaCorrecta(respuesta)){
			agregarPuntos(participante, puntos)
		} else modificarHistorial(participante, 0)
	}
	
}

@Accessors
@DiscriminatorValue("2")
@JsonTypeName("preguntaRiesgosa")
@Document(collection="preguntas")
class PreguntaRiesgosa extends Pregunta{
//	final String type = "preguntaRiesgosa"
	static final long minutosDeRiesgo = 1
	@Accessors(PUBLIC_GETTER) static final float puntos = 100
	static final float puntosEnRiesgo = 50
	
	@JsonProperty("puntos")
	def getPuntos(){
		puntos
	}	
	
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

@Accessors
@DiscriminatorValue("3")
@JsonTypeName("preguntaSolidaria")
@Document(collection="preguntas")
class PreguntaSolidaria extends Pregunta{
//	final String type = "preguntaSolidria"
	@Accessors(PUBLIC_GETTER) float puntos
	
	@JsonProperty("puntos")
	def getPuntos(){
		puntos
	}	
		
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



/* PREGUNTA CON ANNOTATIONS PARA PERSISTENCIA RELACIONAL */

//import java.util.List
//import org.eclipse.xtend.lib.annotations.Accessors
//import com.fasterxml.jackson.annotation.JsonProperty
//import com.fasterxml.jackson.annotation.JsonIgnoreProperties
//import com.fasterxml.jackson.annotation.JsonSubTypes
//import com.fasterxml.jackson.annotation.JsonTypeInfo
//import com.fasterxml.jackson.annotation.JsonTypeName
//import com.fasterxml.jackson.annotation.JsonIgnore
//import javax.persistence.DiscriminatorValue
//import java.time.ZonedDateTime
//import javax.persistence.Entity
//import com.fasterxml.jackson.annotation.JsonProperty.Access
//import javax.persistence.Table
//import javax.persistence.ElementCollection
//import javax.persistence.DiscriminatorColumn
//import javax.persistence.DiscriminatorType
//import javax.persistence.Inheritance
//import javax.persistence.InheritanceType
//import javax.persistence.ManyToOne
//import javax.persistence.Column
//import javax.persistence.FetchType
//import javax.persistence.OrderColumn
//import javax.validation.constraints.NotBlank
//import javax.validation.constraints.Size

//@Accessors
//@JsonIgnoreProperties(ignoreUnknown = true)
//@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type", visible = true)
//@JsonSubTypes( 
//	@JsonSubTypes.Type(name = "preguntaSimple", value = PreguntaSimple), 
//	@JsonSubTypes.Type(name = "preguntaRiesgosa", value = PreguntaRiesgosa), 
//	@JsonSubTypes.Type(name = "preguntaSolidaria", value = PreguntaSolidaria)
//)
//@Entity
//@Table(name="pregunta")
//@Inheritance(strategy=InheritanceType.SINGLE_TABLE)
//@DiscriminatorColumn(name="tipo_pregunta",    
//                     discriminatorType=DiscriminatorType.INTEGER)
//abstract class Pregunta extends Entidad{
//	public static final long minutosDeVigencia = 5
//	
//	@Column(length=255)
//	@NotBlank(message = "El campo pregunta no puede estar vacío")
//	@Accessors var String pregunta
//	
//	@Column(length=255)
//	@NotBlank(message = "La pregunta debe tener una respuesta correcta indicada")
//	var String respuestaCorrecta
//	
//	@ElementCollection(targetClass=String)
//	@OrderColumn
//	@Size(min = 2, message = "La pregunta debe tener al menos 2 opciones")
//	var List<String> opciones = newArrayList
//	
//	@Column(columnDefinition = "TIMESTAMP")
//	@Accessors var ZonedDateTime fechaHoraDeCreacion = ZonedDateTime.now() //Fecha y hora juntos, sirve para hacer mas simple la comparacion
//	
//	@JsonIgnore
//	@ManyToOne(fetch = FetchType.LAZY)
//	@Accessors var Usuario autor
//	
//	@JsonProperty("idAutor")
//	def getIdAutor(){
//		autor.id
//	}
//	
//	def String getRespuestaCorrecta(){
//	   return respuestaCorrecta
//	}	
//	
//	def String setRespuestaCorrecta(String respuesta){
//	   respuestaCorrecta = respuesta
//	}	
//	
//	
//	@JsonProperty("nombreAutor")
//	def String getNombreAutor(){
//		autor.nombre + ' ' + autor.apellido
//	}
//	
//	def boolean estaActiva(){
//		var ZonedDateTime vencimiento = fechaHoraDeCreacion.plusMinutes(minutosDeVigencia)
//		ZonedDateTime.now().isBefore(vencimiento)
//	}
//	
//	def boolean esRespuestaCorrecta(String respuesta){
//		respuesta.equals(respuestaCorrecta)
//	}
//	
//	def void responder(Usuario participante, String respuesta)
//	
//	def Boolean preguntaContieneString(String busqueda){
//		return pregunta.toLowerCase().contains(busqueda.toLowerCase())
//	}
//	
//	def void modificarHistorial(Usuario participante, float puntos){
//		var RegistroRespuestas registro = new RegistroRespuestas()
//		registro.pregunta = pregunta
//		registro.fechaRespuesta = ZonedDateTime.now()
//		registro.puntosOtorgados = puntos
//		
//		participante.historial.add(registro)
//	}
//	
//	def void agregarPuntos(Usuario participante, float puntos){
//		participante.agregarPuntos(puntos)
//		modificarHistorial(participante, puntos)
//	}
//}
//
//@Accessors
//@Entity
//@DiscriminatorValue("1")
//@JsonTypeName("preguntaSimple")
//class PreguntaSimple extends Pregunta{
//	final String type = "preguntaSimple"
//	@Accessors(PUBLIC_GETTER) static final float puntos = 10
//	
//	@JsonProperty("puntos")
//	def getPuntos(){
//		puntos
//	}	
//	//HACER TEMPLATE 
//	override responder(Usuario participante, String respuesta){
//		if(esRespuestaCorrecta(respuesta)){
//			agregarPuntos(participante, puntos)
//		} else modificarHistorial(participante, 0)
//	}
//	
//}
//
//@Accessors
//@Entity
//@DiscriminatorValue("2")
//@JsonTypeName("preguntaRiesgosa")
//class PreguntaRiesgosa extends Pregunta{
//	final String type = "preguntaRiesgosa"
//	static final long minutosDeRiesgo = 1
//	@Accessors(PUBLIC_GETTER) static final float puntos = 100
//	static final float puntosEnRiesgo = 50
//	
//	@JsonProperty("puntos")
//	def getPuntos(){
//		puntos
//	}	
//	
//	override responder(Usuario participante, String respuesta){
//		if(esRespuestaCorrecta(respuesta)){
//			if(esRespuestaRapida){
//				this.autor.quitarPuntos(puntosEnRiesgo)
//			}
//		 	agregarPuntos(participante, puntos)
//		} else modificarHistorial(participante, 0)
//	}
//	
//	def boolean esRespuestaRapida(){
//		var ZonedDateTime tiempoLimite = fechaHoraDeCreacion.plusMinutes(minutosDeRiesgo)
//		ZonedDateTime.now().isBefore(tiempoLimite)
//	}
//}
//
//@Accessors
//@Entity
//@DiscriminatorValue("3")
//@JsonTypeName("preguntaSolidaria")
//class PreguntaSolidaria extends Pregunta{
//	final String type = "preguntaSolidria"
//	@Accessors(PUBLIC_GETTER) float puntos
//	
//	@JsonProperty("puntos")
//	def getPuntos(){
//		puntos
//	}	
//		
//	def asignarPuntos(float losPuntos){
//		puntos = losPuntos
//	}
//	
//	override responder(Usuario participante, String respuesta){
//		if(esRespuestaCorrecta(respuesta)) {
//			agregarPuntos(participante, puntos)
//			autor.quitarPuntos(puntos)
//		} else modificarHistorial(participante, 0)
//	}
//}