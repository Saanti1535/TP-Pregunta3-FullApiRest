package phm.domain

import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonIgnore
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.MappedSuperclass
import javax.persistence.Column

@MappedSuperclass
abstract class Entidad {
	@Id	
	@GeneratedValue
	@Accessors long id
	
	@JsonIgnore
	@Column	
	@Accessors boolean bajaLogica = false
}
