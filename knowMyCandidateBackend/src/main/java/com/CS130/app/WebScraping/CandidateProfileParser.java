package com.CS130.app.WebScraping;

import com.CS130.app.web.Candidate;
import com.CS130.app.web.CandidateFactory;
import com.CS130.app.web.Issue;
import com.CS130.app.web.IssueFactory;
import org.parse4j.ParseException;
import org.parse4j.ParseQuery;

import java.io.File;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by ishan on 10/17/15.
 */
public class CandidateProfileParser implements ParserStrategy {
    @Override
    public boolean parse(boolean scrapeLocalFile, boolean save) {
        try {
            addCandidatesToProcess();

            for (CandidateID candidateId : candidateIds) {
                System.out.println("\nScraping Candidate Profile data for " + candidateId.firstName + " " + candidateId.lastName + "\n");
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

                ArrayList<String> regexStrings = new ArrayList<String>();

                String regexCaptureBasicData = "<div class='ddh-field'><span class='title'>([^<]*):<\\/span>([^<]*)<\\/div>";
                String regexCaptureMoreBasicData = "<td class='fname'>(.*)<\\/td>\\n*\\s*<td class='fdata'>([a-zA-Z\\s,\\d()'\"]*)<\\/td>";
                String regexCaptureDataContainingLinks = "<td class='fname'>(.*)<\\/td>\\n*\\s*<td class='fdata'><a href=.*(http.*)(?:'|\").*rel.*<\\/td>";
                String regexCaptureDataInMultipleRows = "<td class='fname'>(.*)<\\/td>\\n*\\s*<td class='fdata'><div class=\"list_scroll\"><table class=\"list_table\" id=\"rep_[^<]*\">(?:<tbody>)*<tr class=\"[^>]*\"><td>([a-zA-Z]*)<\\/td><\\/tr>";

                regexStrings.add(regexCaptureBasicData);
                regexStrings.add(regexCaptureMoreBasicData);
                regexStrings.add(regexCaptureDataContainingLinks);
                regexStrings.add(regexCaptureDataInMultipleRows);

                ParseQuery<Candidate> query = ParseQuery.getQuery(Candidate.class);
                query.whereEqualTo("lastName", candidateId.lastName);
                query.limit(1);
                List<Candidate> candidateList = query.find();
                Candidate candidate;

                if (candidateList == null || candidateList.size() == 0) {
                    CandidateFactory candidateFactory = new CandidateFactory();
                    candidate = candidateFactory.getNewCandidate();
                    candidate.setFirstName(candidateId.firstName);
                    candidate.setLastName(candidateId.lastName);
                }
                else {
                    candidate = candidateList.get(0);
                }

                for (String regex : regexStrings) {
                    Pattern pattern = Pattern.compile(regex);
                    Matcher m = pattern.matcher(content);

                    while (m.find()) {
                        String attribute = m.group(1);
                        String field = attribute.replaceAll("\\s","");
                        String value = m.group(2);
                        if (value.charAt(0) == ' ')
                            value = value.replaceFirst("\\s", "");
                        candidate.setAnyField(field, value);

                        System.out.println(field + ": " + value);
                    }
                }

                try {
                    if (save) {
                        candidate.save();
                    }
                } catch (ParseException e) {
                    e.printStackTrace();
                    System.out.println("Failed to save candidate: " + candidateId.firstName + " " + candidateId.lastName);
                }
            }
            return true;
        }
        catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    protected void addCandidatesToProcess() {
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
        addCandidate(66, "Jim", "Webb");
        addCandidate(61, "Scott", "Walker");
        addCandidate(67, "Lincoln", "Chafee");
        addCandidate(42, "Rick", "Perry");
    }

    protected void addCandidate(int id, String firstName, String lastName) {
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

    protected ArrayList<CandidateID> candidateIds = new ArrayList<CandidateID>();
}
