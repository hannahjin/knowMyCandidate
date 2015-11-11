package com.CS130.app.WebScraping;

import com.CS130.app.web.Candidate;
import com.CS130.app.web.Issue;
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import org.junit.runner.RunWith;
import org.parse4j.ParseQuery;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.Mock;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;


/**
 * Unit test for Twitter client.
 */
@RunWith(PowerMockRunner.class)
@PrepareForTest(ParseQuery.class)
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

    @Mock
    public ParseQuery<Issue> mockedIssue;

    public void testIssueListParsingSuccess() {
        try {
            PowerMockito.mock(Candidate.class);
            PowerMockito.mockStatic(ParseQuery.class);
            PowerMockito.when(ParseQuery.getQuery(Issue.class)).thenReturn(mockedIssue);
            assertTrue(issueListParser.parse(true));
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

}
