package com.CS130.app.web;

import org.parse4j.ParseObject;

public class NewsfeedFactory {

	public Newsfeed getNewNewsfeed() {
		return new Newsfeed();
	}
	
	public Newsfeed getNewsfeed(String objectId) {
		Newsfeed newsfeedReference = (Newsfeed) ParseObject.createWithoutData("Newsfeed", objectId);
		return newsfeedReference;
	}	
}