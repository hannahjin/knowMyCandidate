package com.CS130.app.web;

import static spark.Spark.*;
import spark.template.freemarker.FreeMarkerEngine;
import spark.ModelAndView;
import static spark.Spark.get;

import com.CS130.app.Main;


/**
 * @author david
 * Basic web pages shown by Spark
 * Not actually used in app.
 */
public class WebConfig {
    
    public WebConfig() {
        staticFileLocation("/public");
        setupRoutes();
    }
    
    private void setupRoutes() {
        get("/", (req, res) -> "Main Page");
        get("/hello", (req, res) -> "Hello World");
        get("/bye", (req, res) -> "Bye World");
        get("/bye1", (req, res) -> "Bye World");
        
        get("/status", (req, res) -> {
        	String status = "<p>Know My Candidate Heroku Backend Current Settings<p>\n";
        	status += "<p>fetchTweets=" + Main.getFetchTweets() + "<br>";
        	status += "scrapeData=" + Main.getScrapeData() + "</p>";
        	return status;
        });
        
        get("/enablefetchtweets", (req, res) -> {
        	Main.setFetchTweets(true);
        	return "Enabled fetchTweets";
        });
        
        get("/disablefetchtweets", (req, res) -> {
        	Main.setFetchTweets(false);
        	return "Disabled fetchTweets";
        });
    }
    
}
