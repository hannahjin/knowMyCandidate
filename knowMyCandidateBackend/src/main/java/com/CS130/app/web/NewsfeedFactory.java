package com.CS130.app.web;

import java.util.List;

import org.parse4j.ParseException;
import org.parse4j.ParseQuery;

public class NewsfeedFactory {

	public Newsfeed getNewNewsfeed() {
		return new Newsfeed();
	}
	
	public List<Newsfeed> getNewsfeed(String candidateID) throws ParseException {
	    ParseQuery<Newsfeed> query = ParseQuery.getQuery(Newsfeed.class);
        query.whereEqualTo("candidateID", candidateID);
        
        List<Newsfeed> candidateList;
        candidateList = query.find();
        
        return candidateList;
	}
	
   public List<Newsfeed> getNewsfeedTweets(String candidateID) throws ParseException {
        ParseQuery<Newsfeed> query = ParseQuery.getQuery(Newsfeed.class);
        query.whereEqualTo("candidateID", candidateID);
        query.whereEqualTo("source", "Twitter");
        
        List<Newsfeed> candidateList;
        candidateList = query.find();
        
        return candidateList;
    }   
}