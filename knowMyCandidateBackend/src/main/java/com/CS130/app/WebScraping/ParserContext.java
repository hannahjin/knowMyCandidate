package com.CS130.app.WebScraping;

/**
 * Created by ishan on 10/17/15.
 */
public class ParserContext {
    private  ParserStrategy parserStrategy;

    public ParserContext(ParserStrategy strategy){
        this.parserStrategy = strategy;
    }

    public void executeStrategy(boolean scrapeLocalFile, boolean save) {
        parserStrategy.parse(scrapeLocalFile, save);
    }
}
