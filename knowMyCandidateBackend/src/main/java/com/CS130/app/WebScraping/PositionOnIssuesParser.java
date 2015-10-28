package com.CS130.app.WebScraping;

import com.CS130.app.web.Candidate;
import com.CS130.app.web.CandidateFactory;
import com.CS130.app.web.Issue;
import org.parse4j.ParseException;
import org.parse4j.ParseObject;
import org.parse4j.ParseQuery;

import java.io.File;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by ishan on 10/17/15.
 */
public class PositionOnIssuesParser implements ParserStrategy {
    @Override
    public void parse(boolean scrapeLocalFile) {
        try {
            boolean addToIssuesPoll = true;

            if (addToIssuesPoll)
                resetPolls();

            addCandidatesToProcess();

            for (CandidateID candidateId : candidateIds) {
                //http://webcache.googleusercontent.com/search?q=cache:
                String content;
                if (!scrapeLocalFile) {
                    String urlStr = "http://webcache.googleusercontent.com/search?q=cache:http://presidential-candidates.insidegov.com/l/" + candidateId.id;
                    URL url = new URL(urlStr);
                    URLConnection connection = url.openConnection();
                    connection.setRequestProperty("User-Agent", "Mozilla/5.0");

                    if (connection instanceof HttpURLConnection) {
                        HttpURLConnection httpConnection = (HttpURLConnection) connection;
                        int code = httpConnection.getResponseCode();
                        if (code != 200) {
                            System.out.println("Error code " + code);
                            continue;
                        }
                    }
                    content = new Scanner(connection.getInputStream(), "UTF-8").useDelimiter("\\A").next();
                } else {
                    String filename = "CandidateSourceFiles/" + candidateId.firstName + candidateId.lastName + ".html";
                    content = new Scanner(new File(filename)).useDelimiter("\\Z").next();
                }

                String regex = "<td colspan='2' class='fullrow fdata'><font size=\"3\"><b>(.*)<\\/b><\\/font> - .*<i>(.*)<\\/i>";
                Pattern pattern = Pattern.compile(regex);
                Matcher m = pattern.matcher(content);

                ParseQuery<Candidate> query = ParseQuery.getQuery(Candidate.class);
                query.whereEqualTo("lastName", candidateId.lastName);
                query.limit(1);
                List<Candidate> candidateList = query.find();
                Candidate candidate;

                if (candidateList == null) {
                    CandidateFactory candidateFactory = new CandidateFactory();
                    candidate = candidateFactory.getNewCandidate();
                    candidate.setFirstName(candidateId.firstName);
                    candidate.setLastName(candidateId.lastName);
                } else {
                    candidate = candidateList.get(0);
                }

                ArrayList<Map<String, String>> issues = new ArrayList<>();

                while (m.find()) {
                    String issue = m.group(1);
                    String position = m.group(2);

                    Map<String, String> map = new HashMap<>();
                    map.put(issue, position);
                    issues.add(map);

                    if (addToIssuesPoll)
                        addToIssuesPoll(issue, position);
                }
                candidate.setIssues(issues);

                try {
                    candidate.save();
                } catch (ParseException e) {
                    e.printStackTrace();
                    System.out.println("Failed to save candidate issues for: " + candidateId.firstName + " " + candidateId.lastName);
                }
            }
        } catch (Exception ex){
            ex.printStackTrace();
        }
    }

    private void resetPolls() {
        try {
            ParseQuery<Issue> query = ParseQuery.getQuery(Issue.class);
            List<Issue> issueList = query.find();
            for (Issue issue : issueList) {
                issue.setCandidatesFor(0);
                issue.setCandidatesAgainst(0);
                issue.setCandidatesNeutral(0);
                issue.save();
            }
        } catch (ParseException e) {
            e.printStackTrace();
            System.out.println("Failed to reset polls count");
        }
    }

    private void addToIssuesPoll(String issueStr, String position) {
        try {
            ParseQuery<Issue> query = ParseQuery.getQuery(Issue.class);
            query.whereEqualTo("topic", issueStr);
            query.limit(1);
            List<Issue> issueList = query.find();

            if (issueList != null) {
                Issue issue = issueList.get(0);

                if (position.equals("Strongly Agrees") || position.equals("Agrees"))
                    issue.setCandidatesFor(issue.getCandidatesFor() + 1);
                else if (position.equals("Strongly Disagrees") || position.equals("Disagrees"))
                    issue.setCandidatesAgainst(issue.getCandidatesAgainst() + 1);
                else
                    issue.setCandidatesNeutral(issue.getCandidatesNeutral() + 1);

                issue.save();
            } else {
                System.out.println("Issue " + issueStr + "not found in parse db");
            }

        } catch (ParseException e) {
            e.printStackTrace();
            System.out.println("Failed to save issue poll count for: " + issueStr);
        }
    }

    private void addCandidatesToProcess() {
        addCandidate(40, "Hillary", "Clinton");
        addCandidate(70, "Donald", "Trump");
        addCandidate(35, "Bernie", "Sanders");
        addCandidate(64, "Ben", "Carson");
        addCandidate(50, "Marco", "Rubio");
        addCandidate(62, "Ted", "Cruz");
        addCandidate(46, "Jeb", "Bush");
        addCandidate(63, "Carly", "Fiorina");
        addCandidate(52, "Mike", "Huckabee");
        addCandidate(57, "Rand", "Paul");
        addCandidate(37, "Chris", "Christie");
        addCandidate(47, "John", "Kasich");
        addCandidate(65, "Lindsey", "Graham");
        addCandidate(51, "Martin", "O'Malley");
        addCandidate(68, "George", "Pataki");
        addCandidate(58, "Rick", "Santorum");
        addCandidate(56, "Bobby", "Jindal");
        addCandidate(72, "Jim", "Gilmore");
        addCandidate(44, "Jill", "Stein");
    }

    private void addCandidate(int id, String firstName, String lastName) {
        CandidateID candidate = new CandidateID();
        candidate.id = id;
        candidate.firstName = firstName;
        candidate.lastName = lastName;
        candidateIds.add(candidate);
    }

    private class CandidateID {
        int id;
        String firstName;
        String lastName;
    }

    private ArrayList<CandidateID> candidateIds = new ArrayList<CandidateID>();
}
