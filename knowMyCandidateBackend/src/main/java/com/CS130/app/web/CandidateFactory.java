package com.CS130.app.web;

import org.parse4j.ParseObject;

public class CandidateFactory {

	public Candidate getNewCandidate() {
		return new Candidate();
	}
	
	public Candidate getCandidate(String objectId) {
		// TODO: try to get rid of cast
		Candidate candidateReference = (Candidate) ParseObject.createWithoutData("Candidate", objectId);
		return candidateReference;
	}
	
}
