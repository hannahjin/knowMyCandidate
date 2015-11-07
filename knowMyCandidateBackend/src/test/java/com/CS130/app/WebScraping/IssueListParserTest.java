package com.CS130.app.WebScraping;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for Twitter client.
 */
public class IssueListParserTest extends TestCase
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public IssueListParserTest( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( IssueListParserTest.class );
    }

    private IssueListParser issueListParser = null;

    public void setUp() {
        issueListParser = new IssueListParser();
    }

    public void testIssueListParsingSuccess() {
        assertTrue(issueListParser.parse(true));
    }

}
