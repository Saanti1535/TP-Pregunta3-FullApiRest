package phm.springboot.controller

import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import com.google.gson.JsonElement
import com.google.gson.JsonParser
import com.google.gson.JsonObject

class Mapper {

	static def mapear() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}
	
	static def extraerStringDeJson(String elJsonRecibido, String nombreDato){
			return extraeDato(elJsonRecibido, nombreDato).asString
	}	
	
	static def extraerLongDeJson(String elJsonRecibido, String nombreDato){
			return extraeDato(elJsonRecibido, nombreDato).asLong
	}
	
	static def extraeDato(String elJsonRecibido, String nombreDato){
			var JsonElement jsonElement = new JsonParser().parse(elJsonRecibido)
        	var JsonObject jsonObject = jsonElement.getAsJsonObject()
        	var dato = jsonObject.get(nombreDato)
        	return dato
	}	
}