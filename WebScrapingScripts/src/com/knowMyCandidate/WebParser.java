package com.knowMyCandidate;

public class WebParser {

    public static void main(String[] args) {
//        ParserContext parserContext1 = new ParserContext(new PositionOnIssuesParser());
//        parserContext1.executeStrategy();
        ParserContext parserContext2 = new ParserContext(new CandidateProfileParser());
        parserContext2.executeStrategy();
    }
}

