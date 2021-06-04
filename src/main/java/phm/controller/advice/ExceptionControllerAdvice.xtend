package phm.controller.advice

import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.http.HttpStatus
import javax.validation.ConstraintViolationException
import phm.exception.DTONullException

@ControllerAdvice
class ExceptionControllerAdvice {
	
	@ExceptionHandler(IllegalArgumentException)
	def ResponseEntity<String> handleIllegalArgumentException(IllegalArgumentException excepcion) {
		return new ResponseEntity<String>(excepcion.message, HttpStatus.BAD_REQUEST)
	}
	
	@ExceptionHandler(SecurityException)
	def ResponseEntity<String> handleSecurityException(SecurityException excepcion) {
		return new ResponseEntity<String>(excepcion.message, HttpStatus.UNAUTHORIZED)
	}
	
	@ExceptionHandler(ConstraintViolationException)
	def ResponseEntity<String> handleConstraintViolationException(ConstraintViolationException excepcion) {
		return new ResponseEntity<String>(mensajeDeErrorEnValidacion(excepcion.message), HttpStatus.BAD_REQUEST)
	}
	
	@ExceptionHandler(DTONullException)
	def ResponseEntity<String> handleDTONullException(DTONullException excepcion){
		return new ResponseEntity<String>(excepcion.message, HttpStatus.BAD_REQUEST)
	}
	
//	@ExceptionHandler(Exception)
//	def ResponseEntity<String> handleAllExceptions(Exception excepcion){
//		return new ResponseEntity<String>("Hubo un error interno en el servidor", HttpStatus.INTERNAL_SERVER_ERROR)
//	}
	 
	private def mensajeDeErrorEnValidacion(String mensaje){
		val int indiceComienzoError = mensaje.indexOf(": ") + 1
		mensaje.substring(indiceComienzoError)
		
	}
}