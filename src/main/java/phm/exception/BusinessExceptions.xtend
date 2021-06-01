package phm.exception

class BusinessExceptions extends Exception{
	new(String mensaje) {
		super(mensaje)
	}
}

class DTONotNullException extends Exception{
	new(String mensaje) {
		super(mensaje)
	}
}