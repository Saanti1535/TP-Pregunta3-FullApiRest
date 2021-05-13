package phm.domain

import org.springframework.data.mongodb.core.mapping.Document
import javax.persistence.Id
import org.eclipse.xtend.lib.annotations.Accessors

@Document(collection = "database_sequences")
class DatabaseSequence {

    @Id
    String id;
	
	@Accessors
    long seq;

}