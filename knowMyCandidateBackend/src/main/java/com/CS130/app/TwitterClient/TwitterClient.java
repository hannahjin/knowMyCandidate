package com.CS130.app.TwitterClient;
import com.CS130.app.web.Newsfeed;
import com.CS130.app.web.NewsfeedFactory;
import com.CS130.app.web.Candidate;
import com.CS130.app.web.CandidateFactory;

import org.parse4j.ParseException;
import org.parse4j.ParseFile;
import org.parse4j.ParseQuery;

import twitter4j.*;
import twitter4j.auth.AccessToken;
import twitter4j.conf.ConfigurationBuilder;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
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
                System.out.println("Processing tweets for candidate: " + candidate.parseId);

                NewsfeedFactory newsfeedFactory = new NewsfeedFactory();
                List<Newsfeed> preExistingTweets = newsfeedFactory.getNewsfeedTweets(candidate.parseId);

                long latestTweetId = 1L;
                if (preExistingTweets != null && preExistingTweets.size() > 0) {
                    System.out.println("Found " + preExistingTweets.size() + " existing tweets");
                    latestTweetId = Long.parseLong(preExistingTweets.get(0).getTweetId());
                }

                String username = candidate.twitterUsername;
                Paging paging = new Paging(1, TWEETS_PER_CANDIDATE).sinceId(latestTweetId);

                Candidate cur_candidate = candidateFactory.getCandidate(candidate.parseId);
                ParseFile cur_thumbnail = cur_candidate.getThumbnail();

                byte[] img = cur_thumbnail.getData();
                ParseFile thumbnail = new ParseFile("thumbnail.jpg", img);
                thumbnail.save();

                List<Status> tweets = twitter.getUserTimeline(username, paging);
                System.out.println("Found " + tweets.size() + " new tweets");

                for (int i = 0; i < tweets.size(); i++) {
                    Status tweet = tweets.get(i);

                    Newsfeed newsfeed;
                    if (preExistingTweets != null && preExistingTweets.size() == TWEETS_PER_CANDIDATE) {
                        //pre-existing tweets list is sorted in descending order of time, so replace tweets from the end with new ones
                        newsfeed = preExistingTweets.get(TWEETS_PER_CANDIDATE - 1 - i);
                    }
                    else {
                        newsfeed = newsfeedFactory.getNewNewsfeed();
                        newsfeed.setSource("Twitter");
                        newsfeed.setCandidateID(candidate.parseId);
                        newsfeed.setTwitterUsername(candidate.twitterUsername);
                        newsfeed.setThumbnail(thumbnail);
                    }

                    String text = tweet.getText();
                    if (tweet.getRetweetedStatus() != null) {
                        text = "RT @" + tweet.getRetweetedStatus().getUser().getScreenName() + ": " + tweet.getRetweetedStatus().getText();
                    }

                    String textWithRemovedURLs = text;
                    //external links are stored within URL entities, so if no external links, remove from text
                    if (tweet.getURLEntities().length == 0) {
                        textWithRemovedURLs = text.replaceAll("https?:\\/\\/\\S*", "");
                    }

                    newsfeed.setSummary(textWithRemovedURLs);
                    newsfeed.setFavoriteCount(tweet.getFavoriteCount());
                    newsfeed.setRetweetCount(tweet.getRetweetCount());
                    newsfeed.setTweetDate(tweet.getCreatedAt());
                    newsfeed.setUrl("http://twitter.com/" + candidate.twitterUsername + "/status/" + tweet.getId());
                    newsfeed.setTweetId(Long.toString(tweet.getId()));
                    newsfeed.save();
                }
            }

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

//    protected void deleteAllOldTweets() {
//        try {
//            ParseQuery<Newsfeed> parseQuery = ParseQuery.getQuery(Newsfeed.class);
//            parseQuery.whereEqualTo("source", "Twitter");
//            Date date = new Date(new Date().getTime() - TimeUnit.MINUTES.toMillis(10));
//            parseQuery.whereLessThan("updatedAt", date);
//
//            parseQuery.limit(1000); //by default parse only allows 100 items to be deleted
//            List<Newsfeed> newsfeedList = parseQuery.find();
//            int num_tweets = 0;
//            if (newsfeedList != null) {
//                num_tweets = newsfeedList.size();
//                for (Newsfeed newsfeed : newsfeedList) {
//                    System.out.println("Deleting old tweets for " + newsfeed.getCandidateID() + " created on " + newsfeed.getCreatedAt());
//                    newsfeed.delete();
//                }
//            }
//            System.out.println("Deleted " + num_tweets + " old tweets.");
//        } catch (ParseException e) {
//            e.printStackTrace();
//            System.out.println("Failed to delete old candidate tweets from parse");
//        }
//    }

    protected void addCandidatesToProcess() {
        addCandidate("MartinOMalley", "Martin O'Malley");
        addCandidate("HillaryClinton", "Hillary Clinton");
        addCandidate("realDonaldTrump", "Donald Trump");
        addCandidate("BernieSanders", "Bernie Sanders");
        addCandidate("RealBenCarson", "Ben Carson");
        addCandidate("marcorubio", "Marco Rubio");
        addCandidate("tedcruz", "Ted Cruz");
        addCandidate("JebBush", "Jeb Bush");
        addCandidate("CarlyFiorina", "Carly Fiorina");
        addCandidate("GovMikeHuckabee", "Mike Huckabee");
        addCandidate("RandPaul", "Rand Paul");
        addCandidate("ChrisChristie", "Chris Christie");
        addCandidate("JohnKasich", "John Kasich");
        addCandidate("LindseyGrahamSC", "Lindsey Graham");
        addCandidate("GovernorPataki", "George Pataki");
        addCandidate("RickSantorum", "Rick Santorum");
        addCandidate("BobbyJindal", "Bobby Jindal");
        addCandidate("gov_gilmore", "Jim Gilmore");
        addCandidate("DrJillStein", "Jill Stein");
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
