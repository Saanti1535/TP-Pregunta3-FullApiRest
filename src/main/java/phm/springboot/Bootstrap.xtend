package phm.springboot

import phm.RepositorioUsuarios
import phm.Usuario
import phm.PreguntaSimple
import phm.RepositorioPreguntas
import java.time.LocalDate


class Bootstrap {
	var liliana = new Usuario => [username = 'liliana'; password = "123456"; nombre="liliana"; apellido="el ventilador"; fechaNacimiento = LocalDate.of(1990, 05, 09); puntaje=1000]
	var pep 	= new Usuario => [username = 'pep'; 	password = "123456"; nombre="pep"; apellido="guardiola"; fechaNacimiento = LocalDate.of(1990, 05, 09); puntaje=350]
	var jose 	= new Usuario => [username = 'jose'; 	password = "123456"; nombre="jose"; apellido="mourinho"; fechaNacimiento = LocalDate.of(1990, 05, 09); puntaje=400]
	var juana 	= new Usuario => [username = 'juana'; 	password = "juana"; nombre="juana"; apellido="viale"; fechaNacimiento = LocalDate.of(1990, 05, 09); puntaje=50]
	
	var pregunta01 = new PreguntaSimple => [ pregunta = "Vamos a filtrar"; id = 1; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"]; autor=liliana;]
	var pregunta02 = new PreguntaSimple => [ pregunta = "Que lindo filtro locoooo"; id = 2; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=liliana;]
	var pregunta03 = new PreguntaSimple => [ pregunta = "¿¿¿¿????"; id = 3; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=jose; respuestaCorrecta="Opcion 2"]
	var pregunta04 = new PreguntaSimple => [ pregunta = "pregunta04"; id = 4; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=pep; respuestaCorrecta="Opcion 2"]
	var pregunta05 = new PreguntaSimple => [ pregunta = "pregunta05"; id = 5; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=pep; respuestaCorrecta="Opcion 2"]
	var pregunta06 = new PreguntaSimple => [ pregunta = "pregunta06"; id = 6; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=jose; respuestaCorrecta="Opcion 2"]
	var pregunta07 = new PreguntaSimple => [ pregunta = "pregunta07"; id = 7; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=juana; respuestaCorrecta="Opcion 2"]
	var pregunta08 = new PreguntaSimple => [ pregunta = "pregunta08"; id = 8; opciones = #["Opcion 1", "Opcion 2", "Opcion 3"];autor=juana; respuestaCorrecta="Opcion 2"]
		
	
/**********************************************************/
	def void run() {
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