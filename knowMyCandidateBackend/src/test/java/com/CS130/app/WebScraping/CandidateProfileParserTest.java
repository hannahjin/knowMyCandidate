package com.CS130.app.WebScraping;

import com.CS130.app.web.Candidate;
import com.CS130.app.web.CandidateFactory;
import com.CS130.app.web.Issue;
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import org.junit.runner.RunWith;
import org.parse4j.ParseObject;
import org.parse4j.ParseQuery;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.Mock;
import org.powermock.core.classloader.annotations.PowerMockIgnore;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

/**
 * Unit test for Twitter client.
 */
@RunWith(PowerMockRunner.class)
@PrepareForTest({ParseQuery.class, ParseObject.class, Candidate.class, CandidateFactory.class})
@PowerMockIgnore("javax.net.ssl.*")
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

    @Mock
    public ParseQuery<Candidate> mockedCandidate;

    public void testCandidateProfileParsingSuccess() {
        try {
            PowerMockito.mockStatic(ParseQuery.class);
            PowerMockito.when(ParseQuery.getQuery(Candidate.class)).thenReturn(mockedCandidate);
            boolean scrapeFromLocalSrcFile = true;
            boolean saveToParseDb = false;
            assertTrue(candidateProfileParser.parse(scrapeFromLocalSrcFile, saveToParseDb));
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

}
