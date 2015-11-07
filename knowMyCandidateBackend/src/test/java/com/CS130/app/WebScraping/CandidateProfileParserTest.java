package com.CS130.app.WebScraping;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for Twitter client.
 */
public class CandidateProfileParserTest extends TestCase
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public CandidateProfileParserTest( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( CandidateProfileParserTest.class );
    }

    private CandidateProfileParser candidateProfileParser;

    public void setUp() {
        candidateProfileParser = new CandidateProfileParser();
    }

    public void testCreatingCandidateList()
    {
        candidateProfileParser.addCandidatesToProcess();
        assertEquals(candidateProfileParser.candidateIds.size(), 19);
    }

    public void testAddingOneCandidate()
    {
        int candidateIdSize = candidateProfileParser.candidateIds.size();
        candidateProfileParser.addCandidate(40, "Hillary", "Clinton");
        assertEquals(candidateIdSize + 1, candidateProfileParser.candidateIds.size());
    }

    public void testCandidateProfileParsingSuccess() {
        assertTrue(candidateProfileParser.parse(true));
    }

}
