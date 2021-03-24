package phm

import org.eclipse.xtend.lib.annotations.Accessors

abstract class Entidad {
	@Accessors long id
	@Accessors boolean bajaLogica = false
	
}
