package com.CS130.app;

import static spark.Spark.port;

import com.CS130.app.web.WebConfig;

public class Main {

    public static void main(String[] args) {

        port(Integer.valueOf(System.getenv("PORT")));
        
        new WebConfig();
        
    }

}
