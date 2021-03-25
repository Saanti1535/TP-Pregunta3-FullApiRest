package phm.springboot

import phm.RepositorioUsuarios
import phm.Usuario
import phm.PreguntaSimple
import phm.RepositorioPreguntas
import java.time.LocalDate


class Bootstrap {
	var liliana = new Usuario => [
		username = 'liliana';
		password = "123456";
		nombre="Liliana";
		apellido="Perez";
		fechaNacimiento = LocalDate.of(1990, 05, 09);
		puntaje=1000;
	]
	var pep = new Usuario => [
		username = 'pep';
		password = "123456";
		nombre="Pep";
		apellido="Guardiola";
		fechaNacimiento = LocalDate.of(1990, 05, 09);
		puntaje=350;
	]
	var jose = new Usuario => [
		username = 'jose';
		password = "123456";
		nombre="Jose";
		apellido="Mourinho";
		fechaNacimiento = LocalDate.of(1990, 05, 09);
		puntaje=400;
	]
	var juana = new Usuario => [
		username = 'juana';
		password = "juana";
		nombre="Juana";
		apellido="Viale";
		fechaNacimiento = LocalDate.of(1990, 05, 09);
		puntaje=50;
	]
	
	var pregunta01 = new PreguntaSimple => [ pregunta = "¿Cuál es el lugar más frío de la tierra?"; id = 1; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"]; autor=liliana;]
	var pregunta02 = new PreguntaSimple => [ pregunta = "¿Cuál es el río más largo del mundo?"; id = 2; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=liliana;]
	var pregunta03 = new PreguntaSimple => [ pregunta = "¿Cómo se llama la Reina del Reino Unido?"; id = 3; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=jose; respuestaCorrecta="Opcion 2"]
	var pregunta04 = new PreguntaSimple => [ pregunta = "¿En qué continente está Ecuador?"; id = 4; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=pep; respuestaCorrecta="Opcion 2"]
	var pregunta05 = new PreguntaSimple => [ pregunta = "¿Dónde originaron los juegos olímpicos?"; id = 5; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=pep; respuestaCorrecta="Opcion 2"]
	var pregunta06 = new PreguntaSimple => [ pregunta = "¿Qué tipo de animal es la ballena?"; id = 6; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=jose; respuestaCorrecta="Opcion 2"]
	var pregunta07 = new PreguntaSimple => [ pregunta = "¿De qué colores es la bandera de México?"; id = 7; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=juana; respuestaCorrecta="Opcion 2"]
	var pregunta08 = new PreguntaSimple => [ pregunta = "¿Qué cantidad de huesos en el cuerpo humano?"; id = 8; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=juana; respuestaCorrecta="Opcion 2"]
		
	
/**********************************************************/
	def void run() {
		jose.amigos.add(pep)
		jose.amigos.add(juana)
		jose.amigos.add(liliana)
		pep.amigos.add(juana)
		crearUsuarios
		crearPreguntas
	}

/********************************************************* USUARIOS */
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
}