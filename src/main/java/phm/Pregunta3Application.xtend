package phm

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication

@SpringBootApplication class Pregunta3Application {
	def static void main(String[] args) {
		new Bootstrap => [run] 
		SpringApplication.run(Pregunta3Application, args)
	}
}