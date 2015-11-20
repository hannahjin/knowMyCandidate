package com.CS130.app;

import static spark.Spark.port;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import com.CS130.app.TwitterClient.TwitterClient;
import com.CS130.app.WebScraping.WebParser;
import com.CS130.app.web.*;

import org.parse4j.Parse;
import org.parse4j.util.ParseRegistry;


public class Main {

	private static Properties prop;
	private static InputStream config_file;
	private static boolean scrapeData;
	private static boolean fetchTweets;
	
    private static final ScheduledExecutorService scheduler =
	       Executors.newScheduledThreadPool(1);
	
    public static void main(String[] args) {

    	// For Heroku, app must bind to port that Heroku provides with $PORT environment variable
    	// If you want to run locally without heroku (e.g. in Eclipse), set port() to a hard-coded value
        port(5000);
//        port(Integer.valueOf(System.getenv("PORT")));

    	// setup Spark and basic routes
        new WebConfig();
        
        // load default settings from backend.properties. This is only done once at start of program.
        // Changes to the settings are done to member variables scrapeData and fetchTweets and are not saved into backend.properties
        loadConfiguration();

        // subclasses need to be initialized before calling Parse.initialize()
        ParseRegistry.registerSubclass(Candidate.class);
        ParseRegistry.registerSubclass(Issue.class);
        ParseRegistry.registerSubclass(Newsfeed.class);

        // TODO: move id and key to private file
        String applicationId = "K1OX77eW0lBtAm8TSc8HYHzvfe7KkM4qi9vwtCBF";
        String restAPIKey = "QCArbvRm6jUYwEEcSNNUT2G4nTTex4qV5KbrJHlS";
        Parse.initialize(applicationId, restAPIKey);

        // TODO: add a UI trigger to run a web scraping
        boolean scrapeFromLocalFile = true;
		boolean saveToParse = true;
        if (scrapeData) {
            WebParser webParser = new WebParser();
            webParser.parse(scrapeFromLocalFile, saveToParse);
        }
        
        scheduleTweetFetcher();
    }
    
    public static boolean getScrapeData() {
    	return scrapeData;
    }
    
    public static void setScrapeData(boolean setting) {
    	scrapeData = setting;
    }
    
    public static boolean getFetchTweets() {
    	return fetchTweets;
    }
    
    public static void setFetchTweets(boolean setting) {
    	fetchTweets = setting;
    }
    
    public static void loadConfiguration() {
        prop = new Properties();
        try {
			config_file = new FileInputStream("backend.properties");
			prop.load(config_file);
			
			scrapeData = Boolean.parseBoolean(prop.getProperty("scrapeData"));
			fetchTweets = Boolean.parseBoolean(prop.getProperty("fetchTweets"));
			
		} catch (IOException e) {
			e.printStackTrace();
			System.err.println("Failed to load backend.properties. Defaulting to disabled settings.");
			scrapeData = false;
			fetchTweets = false;
		} finally {
			if (config_file != null) {
				try {
					config_file.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
    }
    
    private static void scheduleTweetFetcher() {
    	TwitterClient twitterClient = new TwitterClient();
    	
    	final Runnable tweetFetcher = new Runnable() {
    		public void run() {
    			if (fetchTweets)
    				twitterClient.fetchCandidateTweets();
			}
    	};
    	// TODO: make twitter refresh period configurable with Web UI
    	scheduler.scheduleAtFixedRate(tweetFetcher, 0, 120, TimeUnit.MINUTES);
    }
    
}
