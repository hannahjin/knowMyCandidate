package com.CS130.app.web;

import java.util.List;

import org.parse4j.ParseException;
import org.parse4j.ParseQuery;

public class CandidateFactory {

	public Candidate getNewCandidate() {
		return new Candidate();
	}
	
	public Candidate getCandidate(String candidateID) throws ParseException {	
		ParseQuery<Candidate> query = ParseQuery.getQuery(Candidate.class);
		query.whereEqualTo("candidateID", candidateID);

		List<Candidate> candidateList;
		candidateList = query.find();

		if (candidateList == null || candidateList.size() == 0)
			return getNewCandidate();

		return candidateList.get(0);
	}
}
