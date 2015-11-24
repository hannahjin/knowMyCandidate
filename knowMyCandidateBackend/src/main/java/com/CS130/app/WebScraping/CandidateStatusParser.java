package com.CS130.app.WebScraping;

import java.io.File;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.CS130.app.web.Candidate;
import com.sun.org.apache.xpath.internal.operations.Bool;
import org.parse4j.ParseException;
import org.parse4j.ParseQuery;

/**
 * Created by ishan on 11/23/15.
 */
public class CandidateStatusParser implements ParserStrategy {

    public static void main(String[] args) {
        CandidateStatusParser x = new CandidateStatusParser();
        x.parse(false, false);
    }
    @Override
    public boolean parse(boolean scrapeLocalFile, boolean save) {
        try {
            System.out.println("\nScraping Status of Candidates\n");

            String content;
            if (!scrapeLocalFile) {
                String urlStr = "http://www.rollingstone.com/politics/news/us-presidential-election-candidates-2016";
                URL url = new URL(urlStr);
                URLConnection connection = url.openConnection();
                connection.setRequestProperty("User-Agent", "Mozilla/5.0");

                if (connection instanceof HttpURLConnection) {
                    HttpURLConnection httpConnection = (HttpURLConnection) connection;

                    int code = httpConnection.getResponseCode();
                    if (code != 200 && code != 301 && code != 302 && code != 303) {
                        System.out.println("Error code " + code);
                        return false;
                    }
                }

                content = new Scanner(connection.getInputStream(), "UTF-8").useDelimiter("\\A").next();
            } else {
                String filename = "CandidateSourceFiles/CandidateStatuses.html";
                content = new Scanner(new File(filename)).useDelimiter("\\Z").next();
            }

            //regex to scrape http://www.nytimes.com/interactive/2016/us/elections/2016-presidential-candidates.html
            //String regex = "<div class=\"g-name\">(.*)<\\/div>\\s*<div class=\"g-status\">(.*)<\\/div>";

            //regex to scrape http://www.rollingstone.com/politics/news/us-presidential-election-candidates-2016
            String regex = "<dd class=\"card.*\\s(.*)\" id=\"(.*)\">";
            Pattern pattern = Pattern.compile(regex);
            Matcher m = pattern.matcher(content);

            HashMap<String, Boolean> statuses = new HashMap<>();
            while (m.find()) {
                String runningPosition = m.group(1);
                String candidateLastName = m.group(2);
                System.out.println(candidateLastName + ": " + runningPosition);
                Boolean hasDroppedOut = false;
                if (runningPosition.equalsIgnoreCase("out"))
                    hasDroppedOut = true;

                if (!statuses.containsKey(candidateLastName))
                    statuses.put(candidateLastName, hasDroppedOut);
            }

            ParseQuery<Candidate> query = ParseQuery.getQuery(Candidate.class);
            List<Candidate> candidateList = query.find();
            if (candidateList != null && candidateList.size() > 0) {
                for (Candidate candidate : candidateList) {
                    String lastName = candidate.getLastName().toLowerCase();
                    if (statuses.containsKey(lastName)) {
                        Boolean status = statuses.get(lastName);
                        candidate.setHasDroppedOut(status);
                    } else {
                        candidate.setHasDroppedOut(false);
                    }

                    try {
                        if (save) {
                            candidate.save();
                        }
                    } catch (ParseException e) {
                        System.out.println("Failed to save candidate status for candidate: " + candidate.getFirstName() + " " + candidate.getLastName());
                    }
                }
            }
            return true;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }
}
