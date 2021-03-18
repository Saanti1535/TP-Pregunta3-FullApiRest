package phm

import org.eclipse.xtend.lib.annotations.Accessors

abstract class Entidad {
	@Accessors double id
	@Accessors boolean bajaLogica = false
}
