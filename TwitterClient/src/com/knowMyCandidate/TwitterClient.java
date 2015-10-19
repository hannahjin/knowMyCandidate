package com.knowMyCandidate;
import twitter4j.*;
import twitter4j.auth.AccessToken;
import twitter4j.conf.ConfigurationBuilder;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;


public class TwitterClient {

    public static void main(String[] args) {
        Properties properties = new Properties();
        InputStream input = null;
        try {
            input = new FileInputStream("twitter4j.properties");
            properties.load(input);

            String consumerKey = properties.getProperty("consumerKey");
            String consumerKeySecret = properties.getProperty("consumerSecret");
            String accessToken = properties.getProperty("accessToken");
            String accessTokenSecret = properties.getProperty("accessTokenSecret");

            ConfigurationBuilder configurationbuilder = new ConfigurationBuilder();
            configurationbuilder.setOAuthConsumerKey(consumerKey);
            configurationbuilder.setOAuthConsumerSecret(consumerKeySecret);

            AccessToken token = new AccessToken(accessToken, accessTokenSecret);

            Twitter twitter = new TwitterFactory(configurationbuilder.build()).getInstance(token);
            String user = "realDonaldTrump";
            List<Status> statuses = twitter.getUserTimeline(user);
            for (Status status : statuses)
                System.out.println("@" + status.getUser().getScreenName() + " - " + status.getText());

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
