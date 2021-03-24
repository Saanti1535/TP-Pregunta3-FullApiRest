package phm

import java.util.List
import java.time.LocalDateTime
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Pregunta extends Entidad{
	static final long minutosDeVigencia = 5
	@Accessors var String pregunta
	var String respuestaCorrecta
	var List<String> opciones = newArrayList
	@Accessors var LocalDateTime fechaHoraDeCreacion = LocalDateTime.now() //Fecha y hora juntos, sirve para hacer mas simple la comparacion
	@Accessors var Usuario autor
	
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
}



class PreguntaSimple extends Pregunta{
	static final float puntos = 10
	
	
	//HACER TEMPLATE 
	override responder(Usuario participante, String respuesta){
		esRespuestaCorrecta(respuesta) ? participante.agregarPuntos(puntos)
	}
}


class PreguntaRiesgosa extends Pregunta{
	static final long minutosDeRiesgo = 1
	static final float puntos = 100
	static final float puntosEnRiesgo = 50
	
	override responder(Usuario participante, String respuesta){
		if(esRespuestaCorrecta(respuesta)){
			if(esRespuestaRapida){
				this.autor.quitarPuntos(puntosEnRiesgo)
			}
		 	participante.agregarPuntos(puntos)
		}
	}
	
	def boolean esRespuestaRapida(){
		var LocalDateTime tiempoLimite = fechaHoraDeCreacion.plusMinutes(minutosDeRiesgo)
		LocalDateTime.now().isBefore(tiempoLimite)
	}
}


// Los puntos los define el autor o deja que cada participante lo haga a la hora de responder? -- depende edl autor
// "Donar" los puntos significa que esos puntos se le quitan al autor tambien? -- restar al autor
/**** De esta forma, los puntos los indica el autor y no se le quitan a él si se responde bien */
class PreguntaSolidaria extends Pregunta{
	final float puntos
		
	new(float puntos){
		super()
		this.puntos = puntos
	}
	
	override responder(Usuario participante, String respuesta){
		esRespuestaCorrecta(respuesta) ? participante.agregarPuntos(puntos)
	}
}


