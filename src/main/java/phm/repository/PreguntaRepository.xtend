package phm.repository

import org.springframework.data.repository.CrudRepository
import phm.domain.Pregunta
import org.springframework.stereotype.Repository
import java.util.List
import org.springframework.data.jpa.repository.EntityGraph
import java.util.Optional
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.time.ZonedDateTime

@Repository
interface PreguntaRepository extends CrudRepository<Pregunta, Long> {
	
	
	def Pregunta findByPregunta(String pregunta)
	
	@EntityGraph(attributePaths = #["opciones", "autor"])
	override Optional<Pregunta> findById(Long id)
	
	
	def List<Pregunta> findByPreguntaContaining(String busqueda)
	
	@Query("SELECT p FROM Pregunta p 
				WHERE p.fechaHoraDeCreacion > :fechaDesdeParaQueEstenActivas
				AND p.pregunta LIKE %:busqueda%")
	def List<Pregunta> obtenerPreguntasFiltradasActivas(@Param("busqueda") String busqueda, @Param("fechaDesdeParaQueEstenActivas") ZonedDateTime fechaDesdeParaQueEstenActivas)
}
/*
 https://docs.spring.io/spring-data/jpa/docs/1.4.3.RELEASE/reference/html/jpa.repositories.html
 Enlace con el listado para los métodos
 */