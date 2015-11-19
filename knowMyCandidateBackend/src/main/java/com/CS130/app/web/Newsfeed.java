package com.CS130.app.web;

import org.parse4j.ParseObject;
import org.parse4j.ParseClassName;
import org.parse4j.ParseFile;

import java.util.Date;

@ParseClassName("Newsfeed")
public class Newsfeed extends ParseObject {
    public Newsfeed() {}

    public String getCandidateID() {
        return getString("candidateID");
    }

    public void setCandidateID(String candidateID) {
        put("candidateID", candidateID);
    }

    public String getSource() {
        return getString("source");
    }

    public void setSource(String source) {
        put("source", source);
    }

    public String getSummary() {
        return getString("summary");
    }

    public void setSummary(String tweetText) {
        put("summary", tweetText);
    }

    public int getRetweetCount() {
        return getInt("retweetCount");
    }

    public void setRetweetCount(int count) {
        put("retweetCount", count);
    }

    public int getFavoriteCount() {
        return getInt("favoriteCount");
    }

    public void setFavoriteCount(int count) {
        put("favoriteCount", count);
    }

    public String getTwitterUsername() {
        return getString("twitterUsername");
    }

    public void setTwitterUsername(String twitterUsername) {
        put("twitterUsername", twitterUsername);
    }

    public Date getTweetDate() {
        return getDate("date");
    }

    public void setTweetDate(Date date) {
        put("date", date);
    }
    
    public void setThumbnail(ParseFile file) {
    	put("thumbnail", file);
    }
}