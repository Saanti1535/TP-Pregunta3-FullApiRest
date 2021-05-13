package phm.service

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

import java.util.Objects;

import static org.springframework.data.mongodb.core.FindAndModifyOptions.options;
import static org.springframework.data.mongodb.core.query.Criteria.where;
import static org.springframework.data.mongodb.core.query.Query.query;
import phm.domain.DatabaseSequence

@Service
class SequenceGeneratorService {

	@Autowired
    MongoOperations mongoOperations;

    def long generateSequence(String seqName) {
		val DatabaseSequence counter = mongoOperations.findAndModify(query(where("_id").is(seqName))
			, new Update().inc("seq", 1),
			options().returnNew(true).upsert(true), DatabaseSequence);
		return !Objects.isNull(counter) ? counter.getSeq() : 1;
    }
}