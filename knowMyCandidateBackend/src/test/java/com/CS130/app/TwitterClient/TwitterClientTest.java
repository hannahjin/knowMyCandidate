package com.CS130.app.TwitterClient;

import com.CS130.app.TwitterClient.TwitterClient;
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for Twitter client.
 */
public class TwitterClientTest extends TestCase
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public TwitterClientTest( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( TwitterClientTest.class );
    }


    private TwitterClient twitterClient= null;

    public void setUp()
    {
        twitterClient = new TwitterClient();
    }

    public void testCreatingCandidateList()
    {
        twitterClient.addCandidatesToProcess();
        assertEquals(twitterClient.candidateDetails.size(), 18);
    }

    public void testAddingOneCandidate()
    {
        int candidateIdSize = twitterClient.candidateDetails.size();
        twitterClient.addCandidate("HillaryClinton", "HillaryClinton");
        assertEquals(candidateIdSize + 1, twitterClient.candidateDetails.size());
    }

    public void testFetchingTweets() {
        //TODO: mock out twitter and parse
        //assertTrue(twitterClient.fetchCandidateTweets());
    }

}
