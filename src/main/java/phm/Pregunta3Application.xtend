package phm

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.data.redis.repository.configuration.EnableRedisRepositories
import org.springframework.data.redis.core.RedisKeyValueAdapter.EnableKeyspaceEvents

@SpringBootApplication 
@EnableRedisRepositories(enableKeyspaceEvents = EnableKeyspaceEvents.ON_STARTUP)
class Pregunta3Application {
	def static void main(String[] args) {
		SpringApplication.run(Pregunta3Application, args)
	}
}