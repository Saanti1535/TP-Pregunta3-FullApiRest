package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.Pregunta
import org.springframework.stereotype.Repository
import java.util.List
import org.springframework.data.jpa.repository.EntityGraph
import java.util.Optional

@Repository
interface PreguntaRepository extends CrudRepository<Pregunta, Long> {
	
	
	def Pregunta findByPregunta(String pregunta)
	
	@EntityGraph(attributePaths = #["opciones"])
	override Optional<Pregunta> findById(Long id)
	
	def List<Pregunta> findByPreguntaContaining(String busqueda)
	
}

/*
 https://docs.spring.io/spring-data/jpa/docs/1.4.3.RELEASE/reference/html/jpa.repositories.html
 Enlace con el listado para los métodos
 */