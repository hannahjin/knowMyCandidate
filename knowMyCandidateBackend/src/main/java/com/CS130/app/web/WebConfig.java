package com.CS130.app.web;

import static spark.Spark.*;

import org.json.JSONObject;

/**
 * @author david
 * Basic web pages shown by Spark
 * Not actually used in app.
 */
public class WebConfig {
    
    private final String webhook_key = "JeQnvYEojk3c97IWZepoFb2pzOvImJP8ZN70wsMS";
    
    public WebConfig() {
        staticFileLocation("/public");
        setupRoutes();
    }
    
    private void setupRoutes() {
        
        get("/", (req, res) -> "Main Page");
        get("/hello", (req, res) -> "Hello World");
        get("/bye", (req, res) -> "Bye World");
        get("/bye1", (req, res) -> "Bye World");
        
        post("/api", "application/json", (req, res) -> {
            if (req.headers("X-Parse-Webhook-Key") != webhook_key) {
                return new JSONObject().put("error", "Request Unauthorized");
            }
            if (req.params("functionName") == "getMaxImage") {
                String image_url = req.params("image_url");
                System.out.println(image_url);
                String max_img_url = "google.com";
                return new JSONObject().put("success", max_img_url);
            }
            
            return new JSONObject().put("error", "Request function unrecognized");
        });
    }
    
}
