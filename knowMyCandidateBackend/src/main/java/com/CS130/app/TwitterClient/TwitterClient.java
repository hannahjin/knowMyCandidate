package com.CS130.app.TwitterClient;
import com.CS130.app.web.Newsfeed;
import com.CS130.app.web.NewsfeedFactory;
import com.CS130.app.web.Candidate;
import com.CS130.app.web.CandidateFactory;

import org.parse4j.ParseCloud;
import org.parse4j.ParseException;
import org.parse4j.ParseFile;
import org.parse4j.ParseObject;
import org.parse4j.ParseQuery;
import org.parse4j.callback.SaveCallback;

import twitter4j.*;
import twitter4j.auth.AccessToken;
import twitter4j.conf.ConfigurationBuilder;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.TimeUnit;


public class TwitterClient {

    int TWEETS_PER_CANDIDATE = 5;

    public boolean fetchCandidateTweets() {
        Properties properties = new Properties();
        InputStream input = null;
        try {
            //replace twitter4j-template.properties with twitter4j.properties with auth keys before using
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
            CandidateFactory candidateFactory = new CandidateFactory();

            if (candidateDetails.isEmpty())
            	addCandidatesToProcess();
            for (CandidateDetails candidate : candidateDetails) {
                System.out.println("Fetching tweets for candidate: " + candidate.parseId);

                String username = candidate.twitterUsername;
                Paging paging = new Paging(1, TWEETS_PER_CANDIDATE);
                
                //Candidate cur_candidate = candidateFactory.getCandidate(candidate.parseId);
                //ParseFile thumbnail = cur_candidate.getThumbnail();
                //System.out.println("got candidate: " + cur_candidate.getFirstName());
                //thumbnail.save();
                
                List<Status> tweets = new ArrayList<Status>();

				tweets = twitter.getUserTimeline(username, paging);

                for (int i = 0; i < tweets.size(); i++) {
                    Status tweet = tweets.get(i);

                    NewsfeedFactory newsfeedFactory = new NewsfeedFactory();
                    Newsfeed newsfeed = newsfeedFactory.getNewNewsfeed();

                    if (tweet.getRetweetedStatus() != null) {
                        String retweetedText = "RT @" + tweet.getRetweetedStatus().getUser().getScreenName() + ": " + tweet.getRetweetedStatus().getText();
                        newsfeed.setSummary(retweetedText);
                    } else {
                        newsfeed.setSummary(tweet.getText());
                    }

                    newsfeed.setSource("Twitter");
                    newsfeed.setCandidateID(candidate.parseId);
                    newsfeed.setTwitterUsername(candidate.twitterUsername);
                    newsfeed.setFavoriteCount(tweet.getFavoriteCount());
                    newsfeed.setRetweetCount(tweet.getRetweetCount());
                    newsfeed.setTweetDate(tweet.getCreatedAt());

                    newsfeed.setUrl("http://twitter.com/" + candidate.twitterUsername + "/status/" + tweet.getId());
                    newsfeed.save();
                }
            }

            deleteAllOldTweets();

            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            System.out.println("Finished updating tweets.");
            return true;
        }
        catch (Exception ex) {
            ex.printStackTrace();
            System.out.println("Failed to fetch candidate tweets.");
            return false;
        }
    }

    protected void deleteAllOldTweets() {
        try {
            ParseQuery<Newsfeed> parseQuery = ParseQuery.getQuery(Newsfeed.class);
            parseQuery.whereEqualTo("source", "Twitter");
            Date date = new Date(new Date().getTime() - TimeUnit.MINUTES.toMillis(10));
            parseQuery.whereLessThan("updatedAt", date);

            parseQuery.limit(1000); //by default parse only allows 100 items to be deleted
            List<Newsfeed> newsfeedList = parseQuery.find();
            int num_tweets = 0;
            if (newsfeedList != null) {
            	num_tweets = newsfeedList.size();
                for (Newsfeed newsfeed : newsfeedList) {
                    System.out.println("Deleting old tweets for " + newsfeed.getCandidateID() + " created on " + newsfeed.getCreatedAt());
                    newsfeed.delete();
                }
            }
            System.out.println("Deleted " + num_tweets + " old tweets.");
        } catch (ParseException e) {
            e.printStackTrace();
            System.out.println("Failed to delete old candidate tweets from parse");
        }
    }

    protected void addCandidatesToProcess() {
        addCandidate("MartinOMalley", "MartinO'Malley");
        addCandidate("HillaryClinton", "HillaryClinton");
        addCandidate("realDonaldTrump", "DonaldTrump");
        addCandidate("BernieSanders", "BernieSanders");
        addCandidate("RealBenCarson", "BenCarson");
        addCandidate("marcorubio", "MarcoRubio");
        addCandidate("tedcruz", "TedCruz");
        addCandidate("JebBush", "JebBush");
        addCandidate("CarlyFiorina", "CarlyFiorina");
        addCandidate("GovMikeHuckabee", "MikeHuckabee");
        addCandidate("RandPaul", "RandPaul");
        addCandidate("ChrisChristie", "ChrisChristie");
        addCandidate("JohnKasich", "JohnKasich");
        addCandidate("LindseyGrahamSC", "LindseyGraham");
        addCandidate("GovernorPataki", "GeorgePataki");
        addCandidate("RickSantorum", "RickSantorum");
        addCandidate("BobbyJindal", "BobbyJindal");
        addCandidate("gov_gilmore", "JimGilmore");
        addCandidate("DrJillStein", "JillStein");
    }

    protected void addCandidate(String twitterUsername, String parseId) {
        CandidateDetails candidate = new CandidateDetails();
        candidate.parseId = parseId;
        candidate.twitterUsername = twitterUsername;
        candidateDetails.add(candidate);
    }

    private class CandidateDetails {
        String parseId;
        String twitterUsername;
    }

    protected ArrayList<CandidateDetails> candidateDetails = new ArrayList<CandidateDetails>();
}
