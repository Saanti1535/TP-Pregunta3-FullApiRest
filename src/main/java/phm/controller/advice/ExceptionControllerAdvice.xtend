package phm.controller.advice

import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.http.HttpStatus

@ControllerAdvice
class ExceptionControllerAdvice {
	
	@ExceptionHandler(IllegalArgumentException)
	def ResponseEntity<String> handleSecurityException(IllegalArgumentException excepcion) {
		return new ResponseEntity<String>(excepcion.message, HttpStatus.BAD_REQUEST)
	}
	
	@ExceptionHandler(SecurityException)
	def ResponseEntity<String> handleSecurityException(SecurityException excepcion) {
		return new ResponseEntity<String>(excepcion.message, HttpStatus.UNAUTHORIZED)
	}
}