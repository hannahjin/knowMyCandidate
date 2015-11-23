package com.CS130.app.web;

import static spark.Spark.*;

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
    }
    
}
