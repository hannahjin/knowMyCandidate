package com.CS130.app.web;

import org.parse4j.ParseObject;
import org.parse4j.ParseClassName;


@ParseClassName("Candidate")
public class Candidate extends ParseObject {
	public Candidate() {
	}
	
	public String getFirstName() {
		return getString("firstName");
	}
	
	public void setFirstName(String value) {
		put("firstName", value);
	}
	
	public String getLastName() {
		return getString("lastName");
	}
	
	public void setLastName(String value) {
		put("lastName", value);
	}
	
	public int getAge() {
		return getInt("Age");
	}
	
	public void setAge(int value) {
		put("Age", value);
	}
	
	public String getParty() {
		return getString("party");
	}
	
	public void setParty(String value) {
		put("party", value);
	}
	
	public String getCurrentPosition() {
		return getString("currentPosition");
	}
	
	public void setCurrentPosition(String value) {
		put("currentPosition", value);
	}
	
	// TODO: add rest of getters and setters
	// getIssues
}
