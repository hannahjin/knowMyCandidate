package com.CS130.app.WebScraping;

public class WebParser {

    public void parse(boolean scrapeLocalFile) {
        ParserContext parserContext;

        parserContext = new ParserContext(new IssueListParser());
        parserContext.executeStrategy(scrapeLocalFile);

        parserContext = new ParserContext(new CandidateProfileParser());
        parserContext.executeStrategy(scrapeLocalFile);

        parserContext = new ParserContext(new PositionOnIssuesParser());
        parserContext.executeStrategy(scrapeLocalFile);
    }
}

