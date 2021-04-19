package phm.controller.advice

import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.http.HttpStatus
import javax.validation.ConstraintViolationException

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
		return new ResponseEntity<String>(excepcion.localizedMessage, HttpStatus.BAD_REQUEST)
	}
}