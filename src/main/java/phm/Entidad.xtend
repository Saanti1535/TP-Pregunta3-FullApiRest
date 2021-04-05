package phm

import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonIgnore

abstract class Entidad {
	@Accessors long id
	@JsonIgnore
	@Accessors boolean bajaLogica = false
	
}
