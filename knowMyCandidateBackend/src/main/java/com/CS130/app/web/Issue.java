package com.CS130.app.web;

import org.parse4j.ParseObject;
import org.parse4j.ParseClassName;


@ParseClassName("Issue")
public class Issue extends ParseObject {
	public Issue() { }
	
	public String getTopic() {
		return getString("topic");
	}
	
	public void setTopic(String topic) {
		put("topic", topic);
	}

	public int getCandidatesFor() {
		return getInt("candidatesFor")
	}

	public int getCandidatesAgainst() {
		return getInt("candidatesAgainst");
	}

	public int getCandidatesNeutral() {
		return getInt("candidatesNeutral");
	}

	public void setCandidatesFor(int count) {
		put("candidatesFor", count);
	}

	public void setCandidatesAgainst(int count) {
		put("candidatesAgainst", count);
	}

	public void setCandidatesNeutral(int count) {
		put("candidatesNeutral", count);
	}
}
