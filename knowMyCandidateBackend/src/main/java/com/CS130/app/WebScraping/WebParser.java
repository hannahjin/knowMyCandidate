package com.CS130.app.WebScraping;

public class WebParser {

    public void parse(boolean scrapeLocalFile, boolean save) {
        ParserContext parserContext;

        parserContext = new ParserContext(new IssueListParser());
        parserContext.executeStrategy(scrapeLocalFile, save);

        parserContext = new ParserContext(new CandidateProfileParser());
        parserContext.executeStrategy(scrapeLocalFile, save);

        parserContext = new ParserContext(new PositionOnIssuesParser());
        parserContext.executeStrategy(scrapeLocalFile, save);

        parserContext = new ParserContext(new CandidateStatusParser());
        parserContext.executeStrategy(scrapeLocalFile, save);
    }
}

