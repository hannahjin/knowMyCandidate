package com.CS130.app.WebScraping;

public class WebParser {

    public void parse() {
        ParserContext parserContext;

        parserContext = new ParserContext(new IssueListParser());
        parserContext.executeStrategy();

        parserContext = new ParserContext(new CandidateProfileParser());
        parserContext.executeStrategy();

        parserContext = new ParserContext(new PositionOnIssuesParser());
        parserContext.executeStrategy();
    }
}

