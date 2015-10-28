package com.CS130.app;

import static spark.Spark.port;

import com.CS130.app.TwitterClient.TwitterClient;
import com.CS130.app.WebScraping.WebParser;
import com.CS130.app.web.*;

import org.parse4j.Parse;
import org.parse4j.ParseException;
import org.parse4j.ParseObject;
import org.parse4j.util.ParseRegistry;


public class Main {

    public static void main(String[] args) {

    	// For Heroku, app must bind to port that Heroku provides with $PORT environment variable
    	// If you want to run locally without heroku (e.g. in Eclipse), set port() to a hard-coded value
//    	 port(5000);
        port(Integer.valueOf(System.getenv("PORT")));

    	// setup Spark and basic routes
        new WebConfig();

        // subclasses need to be initialized before calling Parse.initialize()
        ParseRegistry.registerSubclass(Candidate.class);
        ParseRegistry.registerSubclass(Issue.class);
        ParseRegistry.registerSubclass(Newsfeed.class);

        String applicationId = "K1OX77eW0lBtAm8TSc8HYHzvfe7KkM4qi9vwtCBF";
        String restAPIKey = "QCArbvRm6jUYwEEcSNNUT2G4nTTex4qV5KbrJHlS";
        Parse.initialize(applicationId, restAPIKey);

        boolean scrapeData = false;
        boolean scrapeFromLocalFile = true;
        if (scrapeData) {
            WebParser webParser = new WebParser();
            webParser.parse(scrapeFromLocalFile);
        }

        boolean fetchTweets = true;
        if (fetchTweets) {
            TwitterClient twitterClient = new TwitterClient();
            twitterClient.fetchCandidateTweets();
        }
        
        /*
        CandidateFactory exampleFactory = new CandidateFactory();
        Candidate hillary = exampleFactory.getNewCandidate();
        hillary.setFirstName("Marco");
        hillary.setLastName("Rubio");
        hillary.setAge(67);
        try {
        	hillary.save();
        } catch (ParseException e) {
        	System.out.println("Failed to save Hillary");
        }

        ParseObject testObject = new ParseObject("TestObject");
       	testObject.put("name", "Bob");
       	testObject.put("thing", 200);
       	testObject.put("email", "Bob@bob.com");
        try {
			testObject.save();
		} catch (ParseException e) {
			System.out.println("Failed to save ParseObject");
		}
		*/
    }
    
}
