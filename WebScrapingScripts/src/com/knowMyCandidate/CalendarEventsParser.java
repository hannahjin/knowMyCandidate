package com.knowMyCandidate;

import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Skeleton created by ishan on 10/17/15.
 * Implemented by jennhuang on 10/21/15.
 */
public class CalendarEventsParser implements ParserStrategy {
    @Override
    public void parse() {
        try {
            
            String urlStr = "https://en.wikipedia.org/wiki/Veterans_Party_of_America";
            URL url = new URL(urlStr);
            URLConnection connection = url.openConnection();
            connection.setRequestProperty("User-Agent", "Mozilla/5.0");

            String content = new Scanner(connection.getInputStream(), "UTF-8").useDelimiter("\\A").next();
            System.out.println(content);
            /*
            ArrayList<String> regexStrings = new ArrayList<String>();

            String regexCaptureBasicData = "<td class='fname'>(.*)<\\/td>\\n*\\s*<td class='fdata'>([a-zA-Z\\s,\\d()'\"]*)<\\/td>";
            String regexCaptureDataContainingLinks = "<td class='fname'>(.*)<\\/td>\\n*\\s*<td class='fdata'><a href=.*(http.*)(?:'|\").*rel.*<\\/td>";
            String regexCaptureDataInMultipleRows = "<td class='fname'>(.*)<\\/td>\\n*\\s*<td class='fdata'><div class=\"list_scroll\"><table class=\"list_table\" id=\"rep_[^<]*\">(?:<tbody>)*<tr class=\"[^>]*\"><td>([a-zA-Z]*)<\\/td><\\/tr>";

            regexStrings.add(regexCaptureBasicData);
            regexStrings.add(regexCaptureDataContainingLinks);
            regexStrings.add(regexCaptureDataInMultipleRows);

            for (String regex : regexStrings) {
                Pattern pattern = Pattern.compile(regex);
                Matcher m = pattern.matcher(content);
                while (m.find()) {
                    String attribute = m.group(1);
                    String value = m.group(2);
                    System.out.println(attribute + ": " + value);
                }
            }
            */
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
