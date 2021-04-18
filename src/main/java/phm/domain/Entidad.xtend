package phm.domain

import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonIgnore
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.MappedSuperclass
import javax.persistence.Column
import javax.persistence.GenerationType

@MappedSuperclass
abstract class Entidad { 
	@Id	
	@GeneratedValue(strategy = GenerationType.IDENTITY) 
	@Accessors Long id
	
	@JsonIgnore
	@Column	
	@Accessors boolean bajaLogica = false
}
