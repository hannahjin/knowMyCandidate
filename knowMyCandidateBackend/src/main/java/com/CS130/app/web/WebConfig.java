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
        post("/bye1", (req, res) -> "Bye World");
        
        post("/api", "application/json", (req, res) -> {
            if (!req.headers("X-Parse-Webhook-Key").equals(webhook_key)) {
                return new JSONObject().put("error", "Request Unauthorized");
            }
            
            JSONObject body = new JSONObject(req.body());
            
            if (body.getString("functionName").equals("getMaxImage")) {
                JSONObject params = body.getJSONObject("params");
                String image_url = "";
                if (params != null) {
                    image_url = params.getString("image_url");
                    String max_img_url = "google.com";
                    System.out.println("image url: " + image_url);
                    return new JSONObject().put("success", max_img_url);
                    
                } else {
                    return new JSONObject().put("error", "image_url was missing from the request");
                }
            }
            
            return new JSONObject().put("error", "Request function unrecognized. functionName param was: " + req.queryParams("functionName"));
        });
    }
    
}
