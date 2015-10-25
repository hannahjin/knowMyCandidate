package com.CS130.app.WebScraping;

import java.net.URL;
import java.net.URLConnection;
import java.util.List;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.CS130.app.web.Candidate;
import com.CS130.app.web.CandidateFactory;
import com.CS130.app.web.Issue;
import com.CS130.app.web.IssueFactory;
import org.parse4j.Parse;
import org.parse4j.ParseException;
import org.parse4j.ParseObject;
import org.parse4j.ParseQuery;
import org.parse4j.util.ParseRegistry;

/**
 * Created by ishan on 10/17/15.
 */
public class IssueListParser implements ParserStrategy {
    @Override
    public void parse() {
        try {
            String urlStr = "http://presidential-candidates.insidegov.com/l/40";
            URL url = new URL(urlStr);
            URLConnection connection = url.openConnection();
            connection.setRequestProperty("User-Agent", "Mozilla/5.0");

            String content = new Scanner(connection.getInputStream(), "UTF-8").useDelimiter("\\A").next();

            String regex = "<td colspan='2' class='fullrow fdata'><font size=\"3\"><b>(.*)<\\/b><\\/font> - <font color=.*<i>(.*)<\\/i>";
            Pattern pattern = Pattern.compile(regex);
            Matcher m = pattern.matcher(content);

            while (m.find()) {
                String issueString = m.group(1);

                ParseQuery<Issue> query = ParseQuery.getQuery(Issue.class);
                query.whereEqualTo("topic", issueString);
                query.limit(1);
                List<Issue> issueList = query.find();
                Issue issue;

                if (issueList == null) {
                    IssueFactory issueFactory = new IssueFactory();
                    issue = issueFactory.getNewIssue();
                    issue.setTopic(issueString);
                    try {
                        issue.save();
                    } catch (ParseException e) {
                        System.out.println("Failed to save issue: " + issueString);
                    }
                }
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
