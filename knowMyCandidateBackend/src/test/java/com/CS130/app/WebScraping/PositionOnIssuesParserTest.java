package com.CS130.app.WebScraping;

import com.CS130.app.web.Candidate;
import com.CS130.app.web.CandidateFactory;
import com.CS130.app.web.Issue;
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import org.junit.runner.RunWith;
import org.mockito.Matchers;
import org.mockito.Mockito;
import org.parse4j.Parse;
import org.parse4j.ParseObject;
import org.parse4j.ParseQuery;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.Mock;
import org.powermock.core.classloader.annotations.PowerMockIgnore;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.util.ArrayList;
import java.util.Map;

import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.*;


/**
 * Unit test for Twitter client.
 */
@RunWith(PowerMockRunner.class)
@PrepareForTest({ParseQuery.class, ParseObject.class, Candidate.class, Issue.class, CandidateFactory.class})
@PowerMockIgnore("javax.net.ssl.*")
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

    @Mock
    public ParseQuery<Issue> mockedIssue;

    @Mock
    public ParseQuery<Candidate> mockedCandidate;


    public void testPositionOnIssuesParsingSuccess() {
        try {
            PowerMockito.mockStatic(ParseQuery.class);
            PowerMockito.when(ParseQuery.getQuery(Issue.class)).thenReturn(mockedIssue);
            PowerMockito.when(ParseQuery.getQuery(Candidate.class)).thenReturn(mockedCandidate);
            boolean scrapeFromLocalSrcFile = true;
            boolean saveToParseDb = false;
            positionOnIssuesParser.parse(scrapeFromLocalSrcFile, saveToParseDb);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

}
