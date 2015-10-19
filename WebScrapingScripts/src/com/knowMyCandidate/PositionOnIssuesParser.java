package com.knowMyCandidate;

import java.net.URL;
import java.net.URLConnection;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by ishan on 10/17/15.
 */
public class PositionOnIssuesParser implements ParserStrategy {
    @Override
    public void parse() {
        try {
            //http://webcache.googleusercontent.com/search?q=cache: (google cache if needed)
            //TODO: iterate over urls for each candidate
            String urlStr = "http://presidential-candidates.insidegov.com/l/40";
            URL url = new URL(urlStr);
            URLConnection connection = url.openConnection();
            connection.setRequestProperty("User-Agent", "Mozilla/5.0");

            String content = new Scanner(connection.getInputStream(), "UTF-8").useDelimiter("\\A").next();

            String regex = "<td colspan='2' class='fullrow fdata'><font size=\"3\"><b>(.*)<\\/b><\\/font> - <font color=.*<i>(.*)<\\/i>";
            Pattern pattern = Pattern.compile(regex);
            Matcher m = pattern.matcher(content);

            while (m.find()) {
                String issue = m.group(1);
                String position = m.group(2);
                System.out.println(issue + ", " + position);
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
