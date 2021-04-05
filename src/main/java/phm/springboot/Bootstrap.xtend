package phm.springboot

import phm.RepositorioUsuarios
import phm.Usuario
import phm.PreguntaSimple
import phm.RepositorioPreguntas
import phm.RegistroRespuestas
import phm.RepositorioHistoriales
import java.time.ZonedDateTime
import java.time.ZoneId
import phm.PreguntaRiesgosa
import phm.PreguntaSolidaria

class Bootstrap {

	var liliana = new Usuario => [
		username = 'liliana';
		password = "123456";
		nombre = "Liliana";
		apellido = "Perez";
		fechaNacimiento = ZonedDateTime.of(1998, 5, 29, 17, 4, 15, 0, ZoneId.of("GMT-3"));
		puntaje = 1000;
	]
	
	var pep = new Usuario => [
		username = 'pep';
		password = "123456";
		nombre = "Pep";
		apellido = "Guardiola";
		fechaNacimiento = ZonedDateTime.of(1990, 5, 14, 17, 4, 15, 0, ZoneId.of("GMT-3"));
		puntaje = 55;
	]
	
	var jose = new Usuario => [
		username = 'jose';
		password = "123456";
		nombre = "Jose";
		apellido = "Mourinho";
		fechaNacimiento = ZonedDateTime.of(1995, 7, 13, 17, 4, 15, 0, ZoneId.of("GMT-3"));
		puntaje = 125;
	]
	
	var juana = new Usuario => [
		username = 'juana';
		password = "juana";
		nombre = "Juana";
		apellido = "Viale";
		fechaNacimiento = ZonedDateTime.of(1980, 5, 13, 17, 4, 15, 0, ZoneId.of("GMT-3"));
		puntaje = 30;
	]

	var pregunta01 = new PreguntaSimple => [
		pregunta = "¿Cuál es el lugar más frío de la tierra?";
		id = 1;
		opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];
		autor = liliana;
		respuestaCorrecta = "Opcion 2"
	]
	
	var pregunta02 = new PreguntaSimple => [
		pregunta = "¿Cuál es el río más largo del mundo?";
		id = 2;
		opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];
		autor = liliana;
		respuestaCorrecta = "Opcion 2"
	]
	
	var pregunta03 = new PreguntaSimple => [
		pregunta = "¿Cómo se llama la Reina del Reino Unido?";
		id = 3;
		opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];
		autor = jose;
		respuestaCorrecta = "Opcion 2"
	]
	
	var pregunta04 = new PreguntaRiesgosa => [
		pregunta = "¿En qué continente está Ecuador?";
		id = 4;
		opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];
		autor = pep;
		respuestaCorrecta = "Opcion 2"
	]
	
	var pregunta05 = new PreguntaRiesgosa => [
		pregunta = "¿Dónde originaron los juegos olímpicos?";
		id = 5;
		opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];
		autor = pep;
		respuestaCorrecta = "Opcion 2"
	]
	
	var pregunta06 = new PreguntaRiesgosa => [
		pregunta = "¿Qué tipo de animal es la ballena?";
		id = 6;
		opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];
		autor = jose;
		respuestaCorrecta = "Opcion 2"
	]
	
	var pregunta07 = new PreguntaSolidaria => [
		pregunta = "¿De qué colores es la bandera de México?";
		id = 7;
		opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];
		autor = juana;
		respuestaCorrecta = "Opcion 2"
	]
	
	var pregunta08 = new PreguntaSolidaria => [
		pregunta = "¿Qué cantidad de huesos en el cuerpo humano?";
		id = 8;
		opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];
		autor = juana;
		respuestaCorrecta = "Opcion 2;"
	]

	var registroPep01 = new RegistroRespuestas => [
		pregunta = "¿Cuál es el lugar más frío de la tierra?";
		fechaRespuesta = ZonedDateTime.of(2021, 3, 25, 17, 4, 15, 0, ZoneId.of("GMT-3"));
		puntosOtorgados = 10
	]
	
	var registroPep02 = new RegistroRespuestas => [
		pregunta = "¿Qué cantidad de huesos en el cuerpo humano?";
		fechaRespuesta = ZonedDateTime.of(2021, 3, 25, 17, 4, 15, 0, ZoneId.of("GMT-3"));
		puntosOtorgados = 15
	]
	
	var registroPep03 = new RegistroRespuestas => [
		pregunta = "¿De qué colores es la bandera de México?";
		fechaRespuesta = ZonedDateTime.of(2021, 3, 25, 17, 4, 15, 0, ZoneId.of("GMT-3"));
		puntosOtorgados = 30
	]

	var registroJuana01 = new RegistroRespuestas => [
		pregunta = "¿Cuál es el lugar más frío de la tierra?";
		fechaRespuesta = ZonedDateTime.of(2021, 5, 20, 12, 4, 15, 0, ZoneId.of("GMT-3"));
		puntosOtorgados = 10
	]
	var registroJuana02 = new RegistroRespuestas => [
		pregunta = "¿Dónde originaron los juegos olímpicos?";
		fechaRespuesta = ZonedDateTime.of(2021, 5, 20, 15, 4, 15, 0, ZoneId.of("GMT-3"));
		puntosOtorgados = 100
	]
	
	var registroJuana03 = new RegistroRespuestas => [
		pregunta = "¿Qué cantidad de huesos en el cuerpo humano?";
		fechaRespuesta = ZonedDateTime.of(2021, 5, 20, 19, 4, 15, 0, ZoneId.of("GMT-3"));
		puntosOtorgados = 15
	]

	var registroJose01 = new RegistroRespuestas => [
		pregunta = "¿Cuál es el lugar más frío de la tierra?";
		fechaRespuesta = ZonedDateTime.of(2021, 5, 20, 12, 4, 15, 0, ZoneId.of("GMT-3"));
		puntosOtorgados = 10
	]
	
	var registroJose02 = new RegistroRespuestas => [
		pregunta = "¿Cuál es el lugar más frío de la tierra?";
		fechaRespuesta = ZonedDateTime.of(2021, 5, 20, 15, 4, 15, 0, ZoneId.of("GMT-3"));
		puntosOtorgados = 10
	]
	
	var registroJose03 = new RegistroRespuestas => [
		pregunta = "¿Cómo se llama la Reina del Reino Unido?";
		fechaRespuesta = ZonedDateTime.of(2021, 5, 20, 19, 4, 15, 0, ZoneId.of("GMT-3"));
		puntosOtorgados = 10
	]

	/*************************** RUN *******************************/
	
	def void run() {
		cargarAmigos
		cargarHistorial
		asignarPuntos
		crearUsuarios
		crearHistoriales
		crearPreguntas
	}

	/************************** CARGA DE DATOS *****************************/
	
	def void crearUsuarios() {
		RepositorioUsuarios.instance => [
			create(liliana)
			create(pep)
			create(jose)
			create(juana)
		]
	}

	def void crearPreguntas() {
		RepositorioPreguntas.instance => [
			create(pregunta01)
			create(pregunta02)
			create(pregunta03)
			create(pregunta04)
			create(pregunta05)
			create(pregunta06)
			create(pregunta07)
			create(pregunta08)
		]
	}

	def void crearHistoriales() {
		RepositorioHistoriales.instance => [
			create(registroPep01)
			create(registroPep02)
			create(registroPep03)
			create(registroJuana01)
			create(registroJuana02)
			create(registroJuana03)
			create(registroJose01)
			create(registroJose02)
			create(registroJose03)
		]
	}

	def void cargarAmigos() {
		jose.amigos.add(pep.username)
		jose.amigos.add(juana.username)
		pep.amigos.add(juana.username)
	}

	def void cargarHistorial() {
		pep.historial.add(registroPep01)
		pep.historial.add(registroPep02)
		pep.historial.add(registroPep03)
		juana.historial.add(registroJuana01)
		juana.historial.add(registroJuana02)
		juana.historial.add(registroJuana03)
		jose.historial.add(registroJose01)
		jose.historial.add(registroJose02)
		jose.historial.add(registroJose03)
	}

	def void asignarPuntos() {
		pregunta07.asignarPuntos(30)
		pregunta08.asignarPuntos(15)
	}
}
