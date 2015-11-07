package com.CS130.app.WebScraping;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for Twitter client.
 */
public class PositionOnIssuesParserTest extends TestCase
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public PositionOnIssuesParserTest( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( PositionOnIssuesParserTest.class );
    }

    private PositionOnIssuesParser positionOnIssuesParser= null;

    public void setUp() {
        positionOnIssuesParser = new PositionOnIssuesParser();
    }

    public void testCreatingCandidateList()
    {
        positionOnIssuesParser.addCandidatesToProcess();
        assertEquals(positionOnIssuesParser.candidateIds.size(), 19);
    }

    public void testAddingOneCandidate()
    {
        int candidateIdSize = positionOnIssuesParser.candidateIds.size();
        positionOnIssuesParser.addCandidate(40, "Hillary", "Clinton");
        assertEquals(candidateIdSize + 1, positionOnIssuesParser.candidateIds.size());
    }

    public void testPositionOnIssuesParsingSuccess() {
        assertTrue(positionOnIssuesParser.parse(true));
    }

}
