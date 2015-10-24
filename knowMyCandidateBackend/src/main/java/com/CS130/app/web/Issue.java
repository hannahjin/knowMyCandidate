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
}
